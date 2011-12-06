<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<%@ Import Namespace="System.Xml.XPath" %>
<script language="vb" runat="server">
'/##########################################################################################

'/*
'Copyright (C) 2005-2010 WebLegs, Inc.
'This program is free software: you can redistribute it and/or modify it under the terms
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

'/--> Begin Class :: TextTemplate
	Public Class TextTemplate 
		'/--> Begin :: Properties
			Public Source As String
			Public DTD As String
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New() 
				Me.Source = ""
				Me.DTD = ""
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: LoadFile
			Public Function LoadFile(Path As String) As TextTemplate
				If Not File.Exists(Path) Then
					Throw New Exception("WebLegs.TextTemplate.LoadFile(): File not found or not able to access.")
				End If
				
				'get the file source
				Dim myFile As StreamReader 
				myFile = File.OpenText(Path)
				Dim Source As String = myFile.ReadToEnd()
				myFile.Close()
				
				'load source
				Me.Load(Source)
				
				Return Me
			End Function
			Public Function LoadFile(Path As String, RootPath As String) As TextTemplate
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
			Public Function Load(Source As String) As TextTemplate
				'strip out the DTD if we find one
				Dim myDTDMatch As Match = Regex.Match(Source, "(<!DOCTYPE.*?>)")
				If myDTDMatch.Success Then
					Me.DTD = myDTDMatch.Groups(1).Value
					Source = Source.Replace(myDTDMatch.Groups(1).Value, "")
				End If
				
				'String container
				Me.Source = Source
				Return Me
			End Function
			Public Function Load(Source As String, RootPath As String) As TextTemplate
				'strip out the DTD if we find one
				Dim myDTDMatch As Match = Regex.Match(Source, "(<!DOCTYPE.*?>)")
				If myDTDMatch.Success Then
					Me.DTD = myDTDMatch.Groups(1).Value
					Source = Source.Replace(myDTDMatch.Groups(1).Value, "")
				End If
				
				'setup the reader and writer
				Dim myXmlReader As XmlTextReader = Nothing
				Dim myXmlWriter As TextXHTMLWriter = Nothing
				
				Try
					'create the XslCompiledTransform object
					Dim myXslt As XslCompiledTransform = New XslCompiledTransform()
					
					'create a resolver
					Dim myResolver As XmlSecureResolver = New XmlSecureResolver(New XmlUrlResolver(), RootPath)
					
					'crate an xml reader
					myXmlReader = New XmlTextReader(New System.IO.MemoryStream(System.Text.Encoding.Default.GetBytes(Source)))
					myXmlReader.XmlResolver = Nothing
					
					'get the xpath document
					Dim myXPathDoc As XPathDocument = New XPathDocument(myXmlReader)
					
					'create a xml doc navigator
					Dim myNavigator As XPathNavigator = myXPathDoc.CreateNavigator()
					
					'dynamically load the xml-stylesheet
						If myNavigator.MoveToChild(XPathNodeType.ProcessingInstruction) Then
							If myNavigator.Name = "xml-stylesheet" Then
								Dim myTarget As String = myNavigator.Value
								Dim myHByRefMatch As Match = Regex.Match(myTarget, "href=[""|''](.*?)[""|'']")
								If myHByRefMatch.Success Then
									myXslt.Load(RootPath & myHByRefMatch.Groups(1).Value, XsltSettings.TrustedXslt, myResolver)
									myHByRefMatch = myHByRefMatch.NextMatch()
								End If
							End If
						End If
					'end dynamically load the xml-stylesheet
					
					'create memorty stream
					Dim myMemoryStream As System.IO.MemoryStream = New System.IO.MemoryStream()
					
					'create XmlTextWriter
					myXmlWriter = New TextXHTMLWriter(myMemoryStream)
					
					'transform the document
					myXslt.Transform(myXPathDoc, myXmlWriter)
					
					'close our writer
					myXmlWriter.Close()
					
					'close our xml reader
					myXmlReader.Close()
					
					'resulting String
					Me.Source = System.Text.Encoding.UTF8.GetString(myMemoryStream.ToArray())
				Finally
					'close our reader and writer
					If Not IsNothing(myXmlReader) Then
						myXmlReader.Close()
					End If
					If Not IsNothing(myXmlWriter) Then
						myXmlWriter.Close()
					End If
				End Try
				Return Me
			End Function
		'/<-- End Method :: Load
		
		'/##################################################################################
		
		'/--> Begin Method :: Replace
			Public Function Replace(This As String, WithThis As String) As TextTemplate
				Me.Source = Me.Source.Replace(This, WithThis)
				Return Me
			End Function
		'/<-- End Method :: Replace
		
		'/##################################################################################
		
		'/--> Begin Method :: GetSubString
			Public Function GetSubString(Start As String, [End] AS String) As String 
				Dim MyStart As Integer = 0
				Dim MyEnd As Integer = 0
				
				If Me.Source.IndexOf(Start) > -1 And Me.Source.LastIndexOf([End]) > -1 Then
					MyStart = (Me.Source.IndexOf(Start)) + Start.Length
					MyEnd = Me.Source.LastIndexOf([End])
					Try
						Return Me.Source.SubString(MyStart, MyEnd - MyStart)
					Catch 
						Throw New Exception("WebLegs.TextTemplate.GetSubString(): Boundry String mismatch.")
					End Try
				Else 
					Throw New Exception("WebLegs.TextTemplate.GetSubString(): Boundry Strings not present in source String.")
				End If
			End Function
		'/<-- End Method :: GetSubString
		
		'/##################################################################################
		
		'/--> Begin Method :: RemoveSubString
			Public Function RemoveSubString(Start As String, [End] As String) As TextTemplate
				Me.RemoveSubString(Start, [End], False)
				Return Me
			End Function
			Public Function RemoveSubString(Start As String, [End] As String, RemoveKeys As Boolean) As TextTemplate
				Dim SubString As String = ""
				
				'try to get the sub String and remove
				Try 
					SubString = GetSubString(Start, [End])
				Catch 
					Throw New Exception("WebLegs.TextTemplate.RemoveSubString(): Boundry String mismatch.")
				End Try
				
				'should we remove the keys too?
				If RemoveKeys Then
					Me.Replace(Start, "")
					Me.Replace([End], "")
				End If
				
				Return Me
			End Function
		'/<-- End Method :: RemoveSubString
		
		'/##################################################################################
		
		'/--> Begin Method :: ToString
			Public Overrides Function ToString() As String
				Return Me.DTD & Me.Source
			End Function
		'/<-- End Method :: ToString
		
		'/##################################################################################
		
		'/--> Begin Method :: SaveAs
			Public Sub SaveAs(FilePath As String)
				Try
					'try to write file
					File.WriteAllText(FilePath, Me.Source, Encoding.UTF8)
				Catch e As Exception
					Throw New Exception("WebLegs.TextTemplate.SaveAs(): Unable to save file.")
				End Try
			End Sub
		'/<-- End Method :: SaveAs
	End Class
'/<-- End Class :: TextTemplate

'/##########################################################################################
'/##########################################################################################
'/##########################################################################################

'/--> Begin Class :: TextXHTMLWriter
	'overload the XmlTextWriter (hacked)
	Public Class TextXHTMLWriter 
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
'/<-- End Class :: TextXHTMLWriter

'/##########################################################################################
</script>