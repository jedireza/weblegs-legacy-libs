<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<%@ Import Namespace="System.Xml.XPath" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<script language="vb" runat="server">
'/##########################################################################################

'/*
'Copyright (C) 2005-2010 WebLegs, Inc.
'This program is free software: you can redistribute it and/or modIfy it under the terms
'of the GNU General Public License as published by the Free Software Foundation, either
'version 3 of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
'without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
'See the GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License along with this program.
'If not, see <http://www.gnu.org/licenses/>.
'*/

'/##########################################################################################

'/--> Begin Class :: DOMTemplate
	Public Class DOMTemplate 
		'/--> Begin :: Properties
			Public XPathQuery As String
			Public DOMDocument As XmlDocument
			Public DOMXPath As XPathNavigator
			Public ResultNodes As XmlNode()
			Public BasePath As String
			Public DTD As String
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New() 
				Me.XPathQuery = ""
				Me.DOMDocument = New XmlDocument()
				Me.DOMXPath = Me.DOMDocument.CreateNavigator()
				Me.BasePath = ""
				Me.DTD = ""
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/<-- End Method :: Traverse
			Public Function Traverse(Value As String) As DOMTemplate
				'clear out results nodes
				Me.ResultNodes = Nothing
		
				'set the xpath query
				Me.XPathQuery &= Value
				
				Return Me
			End Function
		'/<-- End Method :: Traverse
		
		'/##################################################################################
		
		'/--> Begin Method :: GetDOMChunk
			Public Function GetDOMChunk() AS DOMChunk
				Dim ReturnData As DOMChunk = New DOMChunk(Me)
				Me.XPathQuery = ""
				Return ReturnData
			End Function
		'/<-- End Method :: GetDOMChunk
		
		'/##################################################################################
		
		'/--> Begin Method :: LoadFile
			Public Function LoadFile(Path As String) As DOMTemplate
				If Not File.Exists(Path) Then
					Throw New Exception("WebLegs.DOMTemplate.LoadFile(): File not found or not able to access.")
				End If
				
				Dim myFile As StreamReader = File.OpenText(Path)
				Dim Source As String = myFile.ReadToEnd()
				myFile.Close()
				
				'load string
				Me.Load(Source)
				
				'return this reference
				Return Me
			End Function
			Public Function LoadFile(Path As String, RootPath As String) As DOMTemplate
				If Not File.Exists(Path) Then
					Throw New Exception("WebLegs.DOMTemplate.LoadFile(): File not found or not able to access.")
				End If
				
				Dim myFile As StreamReader = File.OpenText(Path)
				Dim Source As String = myFile.ReadToEnd()
				myFile.Close()
				
				'load string
				Me.Load(Source, RootPath)
				
				'return this reference
				Return Me
			End Function
		'/<-- End Method :: LoadFile
		
		'/##################################################################################
		
		'/--> Begin Method :: Load
			Public Function Load(Source As String) As DOMTemplate
				'strip out the DTD if we find one
				Dim myDTDMatch As Match = Regex.Match(Source, "(<!DOCTYPE.*?>)")
				If myDTDMatch.Success Then
					Me.DTD = myDTDMatch.Groups(1).Value
					Source = Source.Replace(myDTDMatch.Groups(1).Value, "")
				End If
				
				'turn off xml resolver
				Me.DOMDocument.XmlResolver = Nothing
				
				'load the source Integero the DOMDocument
				Me.DOMDocument.LoadXml(Source)
				
				'setup the DOMXPath
				Me.DOMXPath = Me.DOMDocument.CreateNavigator()
				
				'clear out xpath query
				Me.XPathQuery = ""
				
				'clear out result nodes
				Me.ResultNodes =  Nothing
				
				'return this reference
				Return Me
			End Function
			Public Function Load(Source As String, RootPath As String) As DOMTemplate
				'strip out the DTD if we find one
				Dim myDTDMatch As Match = Regex.Match(Source, "(<!DOCTYPE.*?>)")
				If myDTDMatch.Success Then
					Me.DTD = myDTDMatch.Groups(1).Value
					Source = Source.Replace(myDTDMatch.Groups(1).Value, "")
				End If
				
				'setup the reader and writer
				Dim myXmlReader As XmlTextReader = Nothing
				Dim myXmlWriter As DOMXHTMLWriter = Nothing
				
				Try
					'create the XslCompiledTransform object
					Dim myXslt As XslCompiledTransform = New XslCompiledTransform()
					
					'create a resolver
					Dim myResolver As XmlSecureResolver = New XmlSecureResolver(New XmlUrlResolver(), RootPath)
					
					'crate an xml reader
					myXmlReader = New XmlTextReader(New StringReader(Source))
					myXmlReader.XmlResolver = Nothing
					
					'get the xpath document
					Dim myXPathDoc As XPathDocument = New XPathDocument(myXmlReader)
					
					'create a xml doc navigator
					Dim myNavigator As XPathNavigator = myXPathDoc.CreateNavigator()
					
					'dynamically load the xml-stylesheet
					If myNavigator.MoveToChild(XPathNodeType.ProcessingInstruction) Then
						If myNavigator.Name = "xml-stylesheet" Then
							Dim myTarget As String = myNavigator.Value
							Dim myHrefMatch As Match = Regex.Match(myTarget, "href=[""|'](.*?)[""|']")
							If myHrefMatch.Success Then
								myXslt.Load(RootPath & myHrefMatch.Groups(1).Value, XsltSettings.TrustedXslt, myResolver)
								myHrefMatch = myHrefMatch.NextMatch()
							End If
						End If
					End If
					'end dynamically load the xml-stylesheet
					
					'create memorty stream
					Dim myMemoryStream As System.IO.MemoryStream = New System.IO.MemoryStream()
					
					'create XmlTextWriter
					myXmlWriter = New DOMXHTMLWriter(myMemoryStream)
					
					'transform the document
					myXslt.Transform(myXPathDoc, myXmlWriter)
					
					'close our writer
					myXmlWriter.Close()
					
					'close our xml reader
					myXmlReader.Close()
					
					'resulting String
					Dim NewSource As String = System.Text.Encoding.UTF8.GetString(myMemoryStream.ToArray()).Trim()
					
					'turn off xml resolver
					Me.DOMDocument.XmlResolver = Nothing
					
					'load the data into the DOMDocument
					Me.DOMDocument.LoadXml(NewSource)
					
					'setup the DOMXPath
					Me.DOMXPath = Me.DOMDocument.CreateNavigator()
				Finally
					'close our reader and writer
					If Not IsNothing(myXmlReader) Then
						myXmlReader.Close()
					End If
					If Not IsNothing(myXmlWriter) Then
						myXmlWriter.Close()
					End If
				End Try
				
				'clear out xpath query
				Me.XPathQuery = ""
				
				'clear out result nodes
				Me.ResultNodes =  Nothing
				
				'return this reference
				Return Me
			End Function
		'/<-- End Method :: Load
		
		'/##################################################################################
		
		'/--> Begin Method :: ExecuteQuery
			Public Function ExecuteQuery(NewXPathQuery As String) AS XmlNode() 
				'setup our iterator
				Dim Iterator As XPathNodeIterator = Me.DOMXPath.Select(Me.BasePath & NewXPathQuery)
				
				Dim ReturnNodes(Iterator.Count - 1) As XmlNode
				Dim i As Integer = 0
				While Iterator.MoveNext()
					Dim Node As XmlNode = (CType(Iterator.Current, IHasXmlNode)).GetNode()
					ReturnNodes(i) = Node
					i = i + 1
				End While

				'Return Me reference
				Return ReturnNodes
			End Function
			Public Function ExecuteQuery() As DOMTemplate 
				'If its blank default to whole document
				If Me.BasePath = "" And Me.XPathQuery = "" Then
					Me.XPathQuery = "//*"
				'this accomodates for the duplicate queries in both the basepath and xpathquery
				'this can happen when attempting to access the parent node in a DOMChunk
				ElseIf Me.BasePath = Me.XPathQuery Then
					Me.XPathQuery = ""
				End If
				'setup our iterator

				Dim Iterator As XPathNodeIterator = Me.DOMXPath.Select(Me.BasePath & Me.XPathQuery)
				Dim ReturnNodes(Iterator.Count - 1) As XmlNode
				Dim i As Integer = 0
				While Iterator.MoveNext()
					Dim Node As XmlNode = (CType(Iterator.Current, IHasXmlNode)).GetNode()
					ReturnNodes(i) = Node
					i = i + 1
				End While

				'clear out xpath query
				Me.XPathQuery = ""
				
				'set result nodes property
				Me.ResultNodes =  ReturnNodes

				'Return Me reference
				Return Me
			End Function
		'/<-- End Method :: ExecuteQuery
		
		'/##################################################################################
		
		'/--> Begin Method :: ToString
			Public Overrides Function ToString() As String 
				Return Me.DTD & Me.DOMDocument.OuterXml
			End Function
			Public Overloads Function ToString(ThisNodeList As XmlNodeList) As String 
				Dim Output As String = ""
				
				'get all children
				For i As Integer = 0 To ThisNodeList.Count - 1
					Output &= Me.ToString(ThisNodeList.Item(i))
				Next
				
				Return Output
			End Function
			Public Overloads Function ToString(ThisNode As XmlNode) As String 
				Return ThisNode.OuterXml
			End Function
		'/<-- End Method :: ToString
		
		'/##################################################################################
		
		'/--> Begin Method :: GetNodesByTagName
			Public Function GetNodesByTagName(TagName As String) As DOMTemplate 
				'execute query
				Me.ResultNodes = Nothing
				
				'set the xpath query
				Me.XPathQuery &= "//"& TagName
				
				Return Me
			End Function
		'/<-- End Method :: GetNodesByTagName
		
		'/##################################################################################
		
		'/--> Begin Method :: GetNodeByID
			Public Function GetNodeByID(Value As String) As DOMTemplate 
				'execute query
				Me.ResultNodes = Nothing
				
				'set the xpath query
				Me.XPathQuery &= "//*[@id='"& Value &"']"
				
				Return Me
			End Function
		'/<-- End Method :: GetNodeByID
		
		'/##################################################################################
		
		'/--> Begin Method :: GetNodesByAttribute
			Public Function GetNodesByAttribute(Attribute As String) As DOMTemplate 
				'execute query
				Me.ResultNodes = Nothing
				
				'set the xpath query
				Me.XPathQuery &= "//*[@"& Attribute &"]"
				
				Return Me
			End Function
			Public Function GetNodesByAttribute(Attribute As String, Value As String) As DOMTemplate 
				'execute query
				Me.ResultNodes = Nothing
				
				'set the xpath query
				Me.XPathQuery &= "//*[@"& Attribute &"='"& Value &"']"
				
				Return Me
			End Function
		'/<-- End Method :: GetNodesByAttribute
		
		'/##################################################################################
		
		'/--> Begin Method :: GetNodesByDataSet
			Public Function GetNodesByDataSet(Attribute As String) As DOMTemplate 
				'use GetNodesByAttribute
				Me.GetNodesByAttribute("data-"& Attribute)
				
				Return Me
			End Function
			Public Function GetNodesByDataSet(Attribute As String, Value As String) As DOMTemplate 
				'use GetNodesByAttribute
				Me.GetNodesByAttribute("data-"& Attribute, Value)
				
				Return Me
			End Function
		'/<-- End Method :: GetNodesByAttribute
		
		'/##################################################################################
		
		'/--> Begin Method :: GetNodesByAttributes
			Public Function GetNodesByAttributes(Attributes As Hashtable) As DOMTemplate 
				'clear out results nodes
				Me.ResultNodes = Nothing
				
				Dim Query As String = ""
				Dim Counter As Integer = 0
				Dim Count As Integer = Attributes.Count
				For Each Key As String in Attributes.Keys
					Query &= "@"& Key &"='"& Attributes(Key) &"'"
					
					If (Counter + 1) <> Count Then
						Query &= " and "
					End If
		
					Counter = Counter + 1
				Next
				
				'set the xpath query
				Me.XPathQuery &= "//*["& Query &"]"
				
				'execute query
				Return Me
			End Function
		'/<-- End Method :: GetNodesByAttributes
		
		'/##################################################################################
		
		'/--> Begin Method :: SetAttribute
			Public Function SetAttribute(Attribute As String, Value As String) As DOMTemplate 
				'execute query If ResultNodes = Nothing
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				For i As Integer = 0 To Me.ResultNodes.Length - 1
					Me.SetAttribute(ResultNodes(i), Attribute, Value)
				Next
				
				Return Me
			End Function
			Public Function SetAttribute(Node As XmlNode, Attribute As String, Value As String) As DOMTemplate 
				Dim NewAttribute As XmlAttribute = Me.DOMDocument.CreateAttribute(Attribute)
				NewAttribute.Value = Value
				Node.Attributes.SetNamedItem(NewAttribute)
				
				Return Me
			End Function
			Public Function SetAttribute(Nodes As XmlNode(), Attribute As String, Value As String) As DOMTemplate 
				For i As Integer = 0 To Nodes.Length - 1
					Me.SetAttribute(Nodes(i), Attribute, Value)
				Next
				
				Return Me
			End Function
		'/<-- End Method :: SetAttribute

		'/##################################################################################
		
		'/--> Begin Method :: GetAttribute
			Public Function GetAttribute(Attribute As String) As String 
				'execute query If ResultNodes = Nothing
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				Return Me.GetAttribute(Me.ResultNodes(0), Attribute)
			End Function
			Public Function GetAttribute(Node As XmlNode, Attribute As String) As String 
				Return Node.Attributes.GetNamedItem(Attribute).Value
			End Function
		'/<-- End Method :: GetAttribute
		
		'/##################################################################################
		
		'/--> Begin Method :: SetInnerHTML
			Public Function SetInnerHTML(Value As String) As DOMTemplate 
				'execute query if ResultNodes == null
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				For i As Integer = 0 To Me.ResultNodes.Length - 1
					Me.SetInnerHTML(ResultNodes(i), Value)
				Next
				
				Return Me
			End Function
			Public Function SetInnerHTML(Node As XmlNode, Value As String) As DOMTemplate 
				'//clear node contents
				Node.InnerXml = ""
				
				'//import new node
				Dim tmpDOMDocument As XmlDocument = New XmlDocument()
				tmpDOMDocument.LoadXml("<container-root>"& Value &"</container-root>")
				Dim NewNode As XmlNode = Me.DOMDocument.ImportNode(tmpDOMDocument.DocumentElement, true)
				
				'append children
				For i As Integer = 0 To NewNode.ChildNodes.Count - 1
					If Not IsNothing(NewNode.ChildNodes(i)) Then
						Node.AppendChild(NewNode.ChildNodes(i).CloneNode(True))
					End If
				Next
				
				Return Me
			End Function
			Public Function SetInnerHTML(Nodes As XmlNode(), Value As String) AS DOMTemplate
				For i As Integer = 0 To Nodes.Length - 1
					Me.SetInnerHTML(Nodes(i), Value)
				Next
				
				Return Me
			End Function
		'/<-- End Method :: SetInnerHTML
		
		'/##################################################################################
		
		'/--> Begin Method :: GetOuterHTML
			Public Function GetOuterHTML() As String 
				'execute query If ResultNodes = Nothing
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				Return Me.ResultNodes(0).OuterXml
			End Function
			Public Function GetOuterHTML(Node As XmlNode) As String 
				Return Node.OuterXml
			End Function
		'/<-- End Method :: GetOuterHTML
				
		'/##################################################################################
		
		'/--> Begin Method :: GetInnerHTML
			Public Function GetInnerHTML() As String 
				'execute query If ResultNodes = Nothing
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				Return Me.ResultNodes(0).InnerXml
			End Function
			Public Function GetInnerHTML(Node As XmlNode) As String 
				Return Node.InnerXml
			End Function
		'/<-- End Method :: GetInnerHTML
		
		'/##################################################################################
		
		'/--> Begin Method :: SetInnerText
			Public Function SetInnerText(Value As String) As DOMTemplate 
				'execute query If ResultNodes = Nothing
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				For i As Integer = 0 To Me.ResultNodes.Length - 1
					Me.ResultNodes(i).InnerText = Value
				Next
				Return Me
			End Function
			Public Function SetInnerText(Node As XmlNode, Value As String) As DOMTemplate 
				Node.InnerText = Value
				Return Me
			End Function
			Public Function SetInnerText(Nodes As XmlNode(), Value As String) As DOMTemplate 
				For i As Integer = 0 To Nodes.Length - 1
					Nodes(i).InnerText = Value
				Next
				Return Me
			End Function
		'/<-- End Method :: SetInnerText
		
		'/##################################################################################
		
		'/--> Begin Method :: GetInnerText
			Public Function GetInnerText() As String 
				'execute query If ResultNodes = Nothing
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				Return Me.ResultNodes(0).InnerText
			End Function
			Public Function GetInnerText(Node As XmlNode) As String 
				Return Node.InnerText
			End Function
		'/<-- End Method :: GetInnerText
		
		'/##################################################################################
		
		'/--> Begin Method :: Remove
			Public Function Remove() As DOMTemplate
				'execute query If ResultNodes = Nothing
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				For i As Integer = 0 To Me.ResultNodes.Length - 1
					Me.Remove(ResultNodes(i))
				Next
				
				'return this reference
				Return Me
			End Function
			Public Function Remove(Node As XmlNode) As DOMTemplate
				Node.ParentNode.RemoveChild(Node)
				
				'return this reference
				Return Me
			End Function
			Public Function Remove(Nodes As XmlNode()) As DOMTemplate
				For i As Integer = 0 To Nodes.Length - 1
					Me.Remove(Nodes(i))
				Next
				
				'return this reference
				Return Me
			End Function
		'/<-- End Method :: Remove
		
		'/##################################################################################
		
		'/--> Begin Method :: RemoveAttribute
			Public Function RemoveAttribute(Attribute As String) As DOMTemplate 
				'execute query If ResultNodes = Nothing
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				For i As Integer = 0 To Me.ResultNodes.Length - 1
					Me.ResultNodes(i).Attributes.RemoveNamedItem(Attribute)
				Next
				Return Me
			End Function
			
			Public Function RemoveAttribute(Node As XmlNode, Attribute As String) As DOMTemplate 
				Node.Attributes.RemoveNamedItem(Attribute)
				Return Me
			End Function
			
			Public Function RemoveAttribute(Nodes As XmlNode(), Attribute As String) As DOMTemplate 
				For i As Integer = 0 To Nodes.Length - 1
					Nodes(i).Attributes.RemoveNamedItem(Attribute)
				Next
				Return Me
			End Function
		'/<-- End Method :: RemoveAttribute
		
		'/##################################################################################
		
		'/--> Begin Method :: RemoveAllAttributes
			Public Function RemoveAllAttributes() As DOMTemplate 
				'execute query If ResultNodes = Nothing
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				For i As Integer = 0 To Me.ResultNodes.Length - 1
					Me.ResultNodes(i).Attributes.RemoveAll()
				Next
				Return Me
			End Function
			
			Public Function RemoveAllAttributes(Node As XmlNode) As DOMTemplate 
				Node.Attributes.RemoveAll()
				Return Me
			End Function
		
			Public Function RemoveAllAttributes(Nodes As XmlNode()) As DOMTemplate 
				For i As Integer = 0 To Nodes.Length - 1
					Nodes(i).Attributes.RemoveAll()
				Next
				Return Me
			End Function
		'/<-- End Method :: RemoveAllAttributes
		
		'/##################################################################################
		
		'/--> Begin Method :: GetNodes
			Public Function GetNodes() As XmlNode() 
				'execute query
				Me.ExecuteQuery()
				
				Dim ReturnValue As XmlNode() = Me.ResultNodes
				
				'this is a termination method clear out properties
				Me.XPathQuery = ""
				Me.ResultNodes = Nothing
				
				Return ReturnValue
			End Function
		'/<-- End Method :: GetNodes
		
		'/##################################################################################
		
		'/--> Begin Method :: GetNode
			Public Function GetNode() As XmlNode 
				'execute query
				Me.ExecuteQuery()
				
				Dim ReturnValue As XmlNode = Nothing
				If Me.ResultNodes.Length > 0 Then
					ReturnValue = Me.ResultNodes(0)
				End If
				
				'this is a termination method clear out properties
				Me.XPathQuery = ""
				Me.ResultNodes = Nothing
				
				Return ReturnValue
			End Function
		'/<-- End Method :: GetNode
		
		'/##################################################################################
		
		'/--> Begin Method :: GetNodesAsString
			Public Function GetNodesAsString() As String 
				'execute query
				Me.ExecuteQuery()
				
				'get the node array
				Dim XMLNodes As XmlNode() = Me.ResultNodes
				
				'this is a termination method clear out properties
				Me.XPathQuery = ""
				Me.ResultNodes = Nothing
				
				'output container
				Dim ReturnValue As String = ""
				
				'loop over items and build String
				For i As Integer = 0 To XMLNodes.Length - 1
					ReturnValue &= Me.ToString(XMLNodes(i))
				Next
				
				Return ReturnValue
			End Function
		'/<-- End Method :: GetNodesAsString
		
		'/##################################################################################
		
		'/--> Begin Method :: ReplaceNode
			Public Function ReplaceNode(ThisNode As XmlNode, WithThisNode As XmlNode)  As DOMTemplate
				ThisNode.ParentNode.ReplaceChild(WithThisNode, ThisNode)
				Return Me
			End Function
			Public Function ReplaceNode(WithThisNode As XmlNode) As DOMTemplate
				'execute query if ResultNodes == null
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				Me.ReplaceNode(Me.ResultNodes(0), WithThisNode)
				Return Me
			End Function
		'/<-- End Method :: ReplaceNode
		
		'/##################################################################################
		
		'/--> Begin Method :: RenameNode
			Public Function RenameNode(NodeType As String) As DOMTemplate
				'execute query if ResultNodes == null
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				'rename
				Me.RenameNodes(Me.ResultNodes(0), NodeType)
				Return Me
			End Function
			Public Function RenameNode(ThisNode As XmlNode, NodeType As String) As DOMTemplate
				Me.RenameNodes(ThisNode, NodeType)
				Return Me
			End Function
		'/<-- End Method :: RenameNode
				
		'/##################################################################################
		
		'/--> Begin Method :: RenameNodes
			Public Function RenameNodes(NodeType As String) As DOMTemplate
				'execute query if ResultNodes == null
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				'rename
				For i As Integer = 0 To Me.ResultNodes.Length - 1
					Me.RenameNodes(Me.ResultNodes(i), NodeType)
				Next
				Return Me
			End Function
			Public Function RenameNodes(ThisNode As XmlNode, NodeType As String) As DOMTemplate
				
				Dim NewNode As XmlNode = Me.DOMDocument.CreateNode("element", NodeType, "")
				
				'add attributes
				For i As Integer = 0 To ThisNode.Attributes.Count - 1
					Dim NewAttribute As XmlAttribute = Me.DOMDocument.CreateAttribute(ThisNode.Attributes(i).Name)
					NewAttribute.Value = ThisNode.Attributes(i).Value
					NewNode.Attributes.SetNamedItem(NewAttribute)
				Next

				'add children to new node			
				Dim tmpNodes(ThisNode.ChildNodes.Count) As XmlNode
				For i As Integer = 0 To ThisNode.ChildNodes.Count - 1
					Dim tmpNode As XmlNode = ThisNode.ChildNodes(i)
					If Not IsNothing(tmpNode) Then
						tmpNodes(i) = tmpNode
					End If
				Next
				For i As Integer = 0 To tmpNodes.Length - 1
					If Not IsNothing(tmpNodes(i)) Then
						NewNode.AppendChild(tmpNodes(i))
					End If
				Next
				
				
				'replace existing node with new one
				Me.ReplaceNode(ThisNode, NewNode)
				
				Return Me
			End Function
			Public Function RenameNodes(Nodes As XmlNode(), NodeType  As String) As DOMTemplate
				For i As Integer = 0 To Nodes.Length - 1
					Me.RenameNodes(Nodes(i), NodeType)
				Next
				Return Me
			End Function
		'/<-- End Method :: RenameNodes
		
		'/##################################################################################
		
		'/--> Begin Method :: ReplaceInnerString
			Public Function ReplaceInnerString(This As String, WithThat As String) As DOMTemplate
				'execute query If ResultNodes = Nothing
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				Dim Source As String = Me.GetInnerHTML(Me.ResultNodes(0))
				Source = Source.Replace(This, WithThat)
				Me.SetInnerHTML(Me.ResultNodes(0), Source)
				
				'return this reference
				Return Me
			End Function
		'/<-- End Method :: ReplaceInnerString
		
		'/##################################################################################
		
		'/--> Begin Method :: GetInnerSubString
			Public Function GetInnerSubString(Start As String, [End] As String) As String 
				'execute query If ResultNodes = Nothing
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				Dim Source As String = Me.GetInnerHTML(Me.ResultNodes(0))
				
				
				Dim MyStart As Integer = 0
				Dim MyEnd As Integer = 0
				
				If Source.IndexOf(Start) > -1 And Source.LastIndexOf([End]) > -1 Then
					MyStart = (Source.IndexOf(Start)) + Start.Length
					MyEnd = Source.LastIndexOf([End])
					Try
						Return Source.SubString(MyStart, MyEnd - MyStart)
					Catch 
						Throw New Exception("WebLegs.DOMTemplate.GetInnerSubString(): Boundry String mismatch.")
					End Try
				Else 
					Throw New Exception("WebLegs.DOMTemplate.GetInnerSubString(): Boundry Strings not present in source String.")
				End If
			End Function
		'/<-- End Method :: GetInnerSubString
		
		'/##################################################################################
		
		'/--> Begin Method :: RemoveInnerSubString
			Public Function RemoveInnerSubString(Start As String, [End] As String) As DOMTemplate
				Me.RemoveInnerSubString(Start, [End], false)
			End Function
			Public Function RemoveInnerSubString(Start As String, [End] As String, RemoveKeys As Boolean) As DOMTemplate
				'execute query If ResultNodes = Nothing
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				Dim Source As String = Me.GetInnerHTML(Me.ResultNodes(0))
				
				Dim SubString As String = ""
				
				'try to get the sub String and remove
				Try 
					SubString = Me.GetInnerSubString(Start, [End])
					Source = Source.Replace(SubString, "")
				Catch 
					Throw New Exception("WebLegs.DOMTemplate.RemoveInnerSubString(): Boundry String mismatch.")
				End Try
				
				'should we remove the keys too?
				If RemoveKeys Then
					Source = Source.Replace(Start, "")
					Source = Source.Replace([End], "")
				End If
				
				'load this back Integero the dom
				Me.SetInnerHTML(Me.ResultNodes(0), Source)
			End Function
		'/<-- End Method :: RemoveInnerSubString
		
		'/##################################################################################
		
		'/--> Begin Method :: SaveAs
			Public Sub SaveAs(FilePath As String)
				Try
					'try to write file
					File.WriteAllText(FilePath, Me.ToString(), Encoding.UTF8)
				Catch e As Exception
					Throw New Exception("WebLegs.DOMTemplate.SaveAs(): Unable to save file.")
				End Try
			End Sub
		'/<-- End Method :: SaveAs
		
		'/##################################################################################
		
		'/--> Begin Method :: AppendChild
			Public Function AppendChild(ParentNode As XmlNode, ThisNode As XmlNode) As DOMTemplate
				ParentNode.AppendChild(ThisNode)
				Return Me
			End Function
			Public Function AppendChild(ThisNode As XmlNode)
				'execute query if ResultNodes == null
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				'append child
				Me.AppendChild(Me.ResultNodes(0), ThisNode)
				
				Return Me
			End Function
		'/<-- End Method :: AppendChild
		
		'/##################################################################################
		
		'/--> Begin Method :: PrependChild
			Public Function PrependChild(ParentNode As XmlNode, ThisNode As XmlNode) As DOMTemplate
				ParentNode.PrependChild(ThisNode)
				Return Me
			End Function 
			Public Function PrependChild(ThisNode As XmlNode)
				'execute query if ResultNodes == null
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				'Prepend child
				Me.PrependChild(Me.ResultNodes(0), ThisNode)
				Return Me
			End Function
		'/<-- End Method :: PrependChild
		
		'/##################################################################################
		
		'/--> Begin Method :: InsertAfter
			Public Function InsertAfter(RefNode As XmlNode, ThisNode As XmlNode) As DOMTemplate
				RefNode.ParentNode.InsertAfter(ThisNode, RefNode)
				Return Me
			End Function
			Public Function InsertAfter(ThisNode As XmlNode)
				'execute query if ResultNodes == null
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				'Prepend child
				Me.InsertAfter(Me.ResultNodes(0), ThisNode)
				Return Me
			End Function
		'/<-- End Method :: InsertAfter
		
		'/##################################################################################
		
		'/--> Begin Method :: InsertBefore
			Public Function InsertBefore(RefNode As XmlNode, ThisNode As XmlNode) As DOMTemplate
				RefNode.ParentNode.InsertBefore(ThisNode, RefNode)
				Return Me
			End Function
			Public Function InsertBefore(ThisNode As XmlNode)
				'execute query if ResultNodes == null
				If IsNothing(Me.ResultNodes) Then
					'execute query
					Me.ExecuteQuery()
				End If
				
				'Prepend child
				Me.InsertBefore(Me.ResultNodes(0), ThisNode)
				Return Me
			End Function
		'/<-- End Method :: InsertBefore
	End Class
'/<-- End Class :: DOMTemplate

'/##########################################################################################
'/##########################################################################################
'/##########################################################################################

'/--> Begin Class :: DOMXHTMLWriter
	'overload the XmlTextWriter (hacked)
	Public Class DOMXHTMLWriter 
		Inherits XmlTextWriter  
		'/--> Begin :: Properties
			'base stream
			Public BaseStream = MyBase.BaseStream
			'elements that should be closed
			Private FullEndElements As String() = New String(){"script", "title", "textarea", "div", "span", "select"}
			'container/flag
			Private LastStartElement As String = Nothing
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New(stream As System.IO.Stream) 
				MyBase.New(stream, Encoding.UTF8)
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin :: Close
			Public Sub Close()
				MyBase.Close()
			End Sub
		'/<-- End :: Close
		
		'/##################################################################################
		
		'/--> Begin Method :: WriteStartElement
			Public Overrides Sub WriteStartElement(PByRefix As String, LocalName As String, InpNamespace As String) 
				LastStartElement = LocalName
				MyBase.WriteStartElement(PByRefix, LocalName, InpNamespace)
			End Sub
		'/<-- End Method :: WriteStartElement
		
		'/##################################################################################
		
		'/--> Begin Method :: WriteEndElement
			Public Overrides Sub WriteEndElement() 
				'If the last opened element is in the full end elements array, then write a full end element for it
				If Array.IndexOf(FullEndElements, LastStartElement) > -1 Then 
					WriteFullEndElement()
				Else 
					MyBase.WriteEndElement()
				End If
			End Sub
		'/<-- End Method :: WriteEndElement
	End Class
'/<-- End Class :: DOMXHTMLWriter

'/##########################################################################################
</script>