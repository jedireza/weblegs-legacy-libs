<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<%@ Import Namespace="System.Xml.XPath" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<script language="c#" runat="server">
//##########################################################################################

/*
Copyright (C) 2005-2010 WebLegs, Inc.
This program is free software: you can redistribute it and/or modify it under the terms
of the GNU General Public License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.
If not, see <http://www.gnu.org/licenses/>.
*/

//##########################################################################################

//--> Begin Class :: DOMTemplate
	public class DOMTemplate {
		//--> Begin :: Properties
			public string XPathQuery;
			public XmlDocument DOMDocument;
			public XPathNavigator DOMXPath;
			public XmlNode[] ResultNodes;
			public string BasePath;
			public string DTD;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public DOMTemplate() {
				this.XPathQuery = "";
				this.DOMDocument = new XmlDocument();
				this.DOMXPath = this.DOMDocument.CreateNavigator();
				this.BasePath = "";
				this.DTD = "";
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//<-- End Method :: Traverse
			public DOMTemplate Traverse(string Value) {
				//clear out results nodes
				this.ResultNodes = null;
				
				//set the xpath query
				this.XPathQuery += Value;
				
				return this;
			}
		//<-- End Method :: Traverse
		
		//##################################################################################
		
		//--> Begin Method :: GetDOMChunk
			public DOMChunk GetDOMChunk(){
				DOMChunk ReturnData = new DOMChunk(this);
				this.XPathQuery = "";
				return ReturnData;
			}
		//<-- End Method :: GetDOMChunk
		
		//##################################################################################
		
		//--> Begin Method :: LoadFile
			public DOMTemplate LoadFile(string Path) {
				if(!File.Exists(Path)) {
					throw new Exception("WebLegs.DOMTemplate.LoadFile(): The file '"+ Path +"' was not found or is inaccessable.");
				}
				
				StreamReader myFile = File.OpenText(Path);
				string Source = myFile.ReadToEnd();
				myFile.Close();
				
				//load source
				this.Load(Source);
				
				//return this reference
				return this;
			}
			public DOMTemplate LoadFile(string Path, string RootPath) {
				if(!File.Exists(Path)) {
					throw new Exception("WebLegs.DOMTemplate.LoadFile(): The file '"+ Path +"' was not found or is inaccessable.");
				}
				
				//read file to end
				StreamReader myFile = File.OpenText(Path);
				string Source = myFile.ReadToEnd();
				myFile.Close();
				
				//load source
				this.Load(Source, RootPath);
				
				//return this reference
				return this;
			}
		//<-- End Method :: LoadFile
		
		//##################################################################################
		
		//--> Begin Method :: Load
			public DOMTemplate Load(string Source) {
				//strip out the DTD if we find one
				Match myDTDMatch = Regex.Match(Source, "(<!DOCTYPE.*?>)");
				if(myDTDMatch.Success) {
					this.DTD = myDTDMatch.Groups[1].Value;
					Source = Source.Replace(myDTDMatch.Groups[1].Value, "");
				}
				
				//load the source into the DOMDocument
				this.DOMDocument.XmlResolver = null;
				this.DOMDocument.LoadXml(Source);
				
				//setup the DOMXPath
				this.DOMXPath = this.DOMDocument.CreateNavigator();
				
				//clear out xpath query
				this.XPathQuery = "";
				
				//clear out result nodes
				this.ResultNodes =  null;
				
				//return this reference
				return this;
			}
			public DOMTemplate Load(string Source, string RootPath) {
				//strip out the DTD if we find one
				Match myDTDMatch = Regex.Match(Source, "(<!DOCTYPE.*?>)");
				if(myDTDMatch.Success) {
					this.DTD = myDTDMatch.Groups[1].Value;
					Source = Source.Replace(myDTDMatch.Groups[1].Value, "");
				}
				
				//setup the reader and writer
				XmlTextReader myXmlReader = null;
				DOMXHTMLWriter myXmlWriter = null;
				
				try {
					//create the XslCompiledTransform object
					XslCompiledTransform myXslt = new XslCompiledTransform();
					
					//create a resolver
					XmlSecureResolver myResolver = new XmlSecureResolver(new XmlUrlResolver(), RootPath);
					
					//create an xml reader
					myXmlReader = new XmlTextReader(new StringReader(Source));
					myXmlReader.XmlResolver = null;
					
					//get the xpath document
					XPathDocument myXPathDoc = new XPathDocument(myXmlReader);
					
					//create a xml doc navigator
					XPathNavigator myNavigator = myXPathDoc.CreateNavigator();
					
					//dynamically load the xml-stylesheet
					if(myNavigator.MoveToChild(XPathNodeType.ProcessingInstruction)) {
						if(myNavigator.Name == "xml-stylesheet") {
							string myTarget = myNavigator.Value;
							Match myHrefMatch = Regex.Match(myTarget, "href=[\"|'](.*?)[\"|']");
							if(myHrefMatch.Success) {
								myXslt.Load(RootPath + myHrefMatch.Groups[1].Value, XsltSettings.TrustedXslt, myResolver);
								myHrefMatch = myHrefMatch.NextMatch();
							}
						}
					}
					//end dynamically load the xml-stylesheet
					
					//create memorty stream
					System.IO.MemoryStream myMemoryStream = new System.IO.MemoryStream();
					
					//create XmlTextWriter
					myXmlWriter = new DOMXHTMLWriter(myMemoryStream);
					
					//transform the document
					myXslt.Transform(myXPathDoc, myXmlWriter);
					
					//resulting string
					string NewSource = System.Text.Encoding.UTF8.GetString(myMemoryStream.ToArray()).Trim();
					
					//turn off xml resolver
					this.DOMDocument.XmlResolver = null;
					
					//load the data into the DOMDocument
					this.DOMDocument.LoadXml(NewSource);
					
					//setup the DOMXPath
					this.DOMXPath = this.DOMDocument.CreateNavigator();
				}
				finally {
					//close our reader and writer
					if(!(myXmlReader == null)) {
						myXmlReader.Close();
					}
					if(!(myXmlWriter == null)) {
						myXmlWriter.Close();
					}
				}
				
				//clear out xpath query
				this.XPathQuery = "";
				
				//clear out result nodes
				this.ResultNodes =  null;
				
				//return this reference
				return this;
			}
		//<-- End Method :: Load
		
		//##################################################################################
		
		//--> Begin Method :: ExecuteQuery
			public XmlNode[] ExecuteQuery(string NewXPathQuery) {
				//setup our iterator
				XPathNodeIterator Iterator = this.DOMXPath.Select(this.BasePath + NewXPathQuery);
				
				XmlNode[] ReturnNodes = new XmlNode[Iterator.Count];
				int i = 0;
				while(Iterator.MoveNext()) {
					XmlNode Node = ((IHasXmlNode)Iterator.Current).GetNode();
					ReturnNodes[i] = Node;
					i++;
				}

				//return this reference
				return ReturnNodes;
			}
			public DOMTemplate ExecuteQuery() {
				//if its blank default to whole document
				if(this.BasePath == "" && this.XPathQuery == "") {
					this.XPathQuery = "//*";
				}
				//this accomodates for the duplicate queries in both the basepath and xpathquery
				//this can happen when attempting to access the parent node in a DOMChunk
				else if(this.BasePath == this.XPathQuery){
					this.XPathQuery = "";
				}
				//setup our iterator

				XPathNodeIterator Iterator = this.DOMXPath.Select(this.BasePath + this.XPathQuery);
				XmlNode[] ReturnNodes = new XmlNode[Iterator.Count];
				int i = 0;
				while(Iterator.MoveNext()) {
					XmlNode Node = ((IHasXmlNode)Iterator.Current).GetNode();
					ReturnNodes[i] = Node;
					i++;
				}

				//clear out xpath query
				this.XPathQuery = "";
				
				//set result nodes property
				this.ResultNodes =  ReturnNodes;

				//return this reference
				return this;
			}
		//<-- End Method :: ExecuteQuery
		
		//##################################################################################
		
		//--> Begin Method :: ToString
			public override string ToString() {
				return this.DTD + this.DOMDocument.OuterXml;
			}
			public string ToString(XmlNodeList ThisNodeList) {
				string Output = "";
				
				//get all children
				for(int i = 0; i < ThisNodeList.Count ; i++){
					Output += this.ToString(ThisNodeList.Item(i));
				}
				
				return Output;
			}
			public string ToString(XmlNode ThisNode) {
				return ThisNode.OuterXml;
			}
		//<-- End Method :: ToString
		
		//##################################################################################
		
		//--> Begin Method :: GetNodesByTagName
			public DOMTemplate GetNodesByTagName(string TagName) {
				//execute query
				this.ResultNodes = null;
				
				//set the xpath query
				this.XPathQuery += "//"+ TagName;
				
				return this;
			}
		//<-- End Method :: GetNodesByTagName
		
		//##################################################################################
		
		//--> Begin Method :: GetNodeByID
			public DOMTemplate GetNodeByID(string Value) {
				//execute query
				this.ResultNodes = null;
				
				//set the xpath query
				this.XPathQuery += "//*[@id='"+ Value +"']";
				
				return this;
			}
		//<-- End Method :: GetNodeByID
		
		//##################################################################################
		
		//--> Begin Method :: GetNodesByAttribute
			public DOMTemplate GetNodesByAttribute(string Attribute) {
				//execute query
				this.ResultNodes = null;
				
				//set the xpath query
				this.XPathQuery += "//*[@"+ Attribute +"]";
				
				return this;
			}		
			public DOMTemplate GetNodesByAttribute(string Attribute, string Value) {
				//execute query
				this.ResultNodes = null;
				
				//set the xpath query
				this.XPathQuery += "//*[@"+ Attribute +"='"+ Value +"']";
				
				return this;
			}
		//<-- End Method :: GetNodesByAttribute
		
		//##################################################################################
		
		//--> Begin Method :: GetNodesByDataSet
			public DOMTemplate GetNodesByDataSet(string Attribute) {
				//use GetNodesByAttribute
				this.GetNodesByAttribute("data-"+ Attribute);
				
				return this;
			}		
			public DOMTemplate GetNodesByDataSet(string Attribute, string Value) {
				//use GetNodesByAttribute
				this.GetNodesByAttribute("data-"+ Attribute, Value);
				
				return this;
			}
		//<-- End Method :: GetNodesByDataSet
		
		//##################################################################################
		
		//--> Begin Method :: GetNodesByAttributes
			public DOMTemplate GetNodesByAttributes(Hashtable Attributes) {
				//clear out results nodes
				this.ResultNodes = null;
				
				string Query = "";
				int Counter = 0;
				int Count = Attributes.Count;
				foreach(string Key in Attributes.Keys) {
					Query += "@"+ Key +"='"+ Attributes[Key] +"'";
					
					if((Counter + 1) != Count) {
						Query += " and ";
					}
		
					Counter++;
				}
				
				//set the xpath query
				this.XPathQuery += "//*["+ Query +"]";
				
				//execute query
				return this;
			}
		//<-- End Method :: GetNodesByAttributes
		
		//##################################################################################
		
		//--> Begin Method :: SetAttribute
			public DOMTemplate SetAttribute(string Attribute, string Value) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				for(int i = 0 ; i < this.ResultNodes.Length ; i++) {
					this.SetAttribute(ResultNodes[i], Attribute, Value);
				}
				
				return this;
			}
			public DOMTemplate SetAttribute(XmlNode Node, string Attribute, string Value) {
				XmlAttribute NewAttribute = this.DOMDocument.CreateAttribute(Attribute);
				NewAttribute.Value = Value;
				Node.Attributes.SetNamedItem(NewAttribute);
				
				return this;
			}
			public DOMTemplate SetAttribute(XmlNode[] Nodes, string Attribute, string Value) {
				for(int i = 0 ; i < Nodes.Length ; i++) {
					this.SetAttribute(Nodes[i], Attribute, Value);
				}
				
				return this;
			}
		//<-- End Method :: SetAttribute
		
		//##################################################################################
		
		//--> Begin Method :: GetAttribute
			public string GetAttribute(string Attribute) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				return this.GetAttribute(this.ResultNodes[0], Attribute);
			}
			public string GetAttribute(XmlNode Node, string Attribute) {
				return Node.Attributes.GetNamedItem(Attribute).Value;
			}
		//<-- End Method :: GetAttribute
		
		//##################################################################################
		
		//--> Begin Method :: SetInnerHTML
			public DOMTemplate SetInnerHTML(string Value) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				for(int i = 0 ; i < this.ResultNodes.Length ; i++) {
					this.SetInnerHTML(ResultNodes[i], Value);
				}
				
				return this;
			}
			public DOMTemplate SetInnerHTML(XmlNode Node, string Value) {
				
				//clear node contents
				Node.InnerXml = "";
				
				//import new node
				XmlDocument tmpDOMDocument = new XmlDocument();
				tmpDOMDocument.LoadXml("<container-root>"+ Value +"</container-root>");
				XmlNode NewNode = this.DOMDocument.ImportNode(tmpDOMDocument.DocumentElement, true);
				
				for(int i = 0; i < NewNode.ChildNodes.Count; i++){
					Node.AppendChild(NewNode.ChildNodes[i].CloneNode(true));
				}
				
				return this;
			}
			public DOMTemplate SetInnerHTML(XmlNode[] Nodes, string Value) {
				for(int i = 0 ; i < Nodes.Length ; i++) {
					this.SetInnerHTML(Nodes[i], Value);
				}
				
				return this;
			}
		//<-- End Method :: SetInnerHTML
		
		//##################################################################################
		
		//--> Begin Method :: GetOuterHTML
			public string GetOuterHTML() {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				return this.ResultNodes[0].OuterXml;
			}
			public string GetOuterHTML(XmlNode Node) {
				return Node.OuterXml;
			}
		//<-- End Method :: GetOuterHTML
			
		//##################################################################################
		
		//--> Begin Method :: GetInnerHTML
			public string GetInnerHTML() {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				return this.ResultNodes[0].InnerXml;
			}
			public string GetInnerHTML(XmlNode Node) {
				return Node.InnerXml;
			}
		//<-- End Method :: GetInnerHTML
		
		//##################################################################################
		
		//--> Begin Method :: SetInnerText
			public DOMTemplate SetInnerText(string Value) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				for(int i = 0 ; i < this.ResultNodes.Length ; i++) {
					this.ResultNodes[i].InnerText = Value;
				}
				return this;
			}
			public DOMTemplate SetInnerText(XmlNode Node, string Value) {
				Node.InnerText = Value;
				return this;
			}
			public DOMTemplate SetInnerText(XmlNode[] Nodes, string Value) {
				for(int i = 0 ; i < Nodes.Length ; i++) {
					Nodes[i].InnerText = Value;
				}
				return this;
			}
		//<-- End Method :: SetInnerText
		
		//##################################################################################
		
		//--> Begin Method :: GetInnerText
			public string GetInnerText() {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				return this.ResultNodes[0].InnerText;
			}
			public string GetInnerText(XmlNode Node) {
				return Node.InnerText;
			}
		//<-- End Method :: GetInnerText
		
		//##################################################################################
		
		//--> Begin Method :: Remove
			public DOMTemplate Remove() {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				for(int i = 0 ; i < this.ResultNodes.Length ; i++) {
					this.Remove(ResultNodes[i]);
				}
				
				//return this reference
				return this;
			}
			public DOMTemplate Remove(XmlNode Node) {
				Node.ParentNode.RemoveChild(Node);
				
				//return this reference
				return this;
			}
			public DOMTemplate Remove(XmlNode[] Nodes) {
				for(int i = 0 ; i < Nodes.Length ; i++) {
					this.Remove(Nodes[i]);
				}
				
				//return this reference
				return this;
			}
		//<-- End Method :: Remove
		
		//##################################################################################
		
		//--> Begin Method :: RemoveAttribute
			public DOMTemplate RemoveAttribute(string Attribute) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				for(int i = 0 ; i < this.ResultNodes.Length ; i++) {
					this.ResultNodes[i].Attributes.RemoveNamedItem(Attribute);
				}
				return this;
			}
			public DOMTemplate RemoveAttribute(XmlNode Node, string Attribute) {
				Node.Attributes.RemoveNamedItem(Attribute);
				return this;
			}
			public DOMTemplate RemoveAttribute(XmlNode[] Nodes, string Attribute) {
				for(int i = 0 ; i < Nodes.Length ; i++) {
					Nodes[i].Attributes.RemoveNamedItem(Attribute);
				}
				return this;
			}
		//<-- End Method :: RemoveAttribute
		
		//##################################################################################
		
		//--> Begin Method :: RemoveAllAttributes
			public DOMTemplate RemoveAllAttributes() {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				for(int i = 0 ; i < this.ResultNodes.Length ; i++) {
					this.ResultNodes[i].Attributes.RemoveAll();
				}
				return this;
			}
			public DOMTemplate RemoveAllAttributes(XmlNode Node) {
				Node.Attributes.RemoveAll();
				return this;
			}
			public DOMTemplate RemoveAllAttributes(XmlNode[] Nodes) {
				for(int i = 0 ; i < Nodes.Length ; i++) {
					Nodes[i].Attributes.RemoveAll();
				}
				return this;
			}
		//<-- End Method :: RemoveAllAttributes
		
		//##################################################################################
		
		//--> Begin Method :: GetNodes
			public XmlNode[] GetNodes() {
				//execute query
				this.ExecuteQuery();
				
				XmlNode[] ReturnValue = this.ResultNodes;
				
				//this is a termination method clear out properties
				this.XPathQuery = "";
				this.ResultNodes = null;
				
				return ReturnValue;
			}
		//<-- End Method :: GetNodes
	
		//##################################################################################
		
		//--> Begin Method :: GetNode
			public XmlNode GetNode() {
				//execute query
				this.ExecuteQuery();
				
				XmlNode ReturnValue = null;
				if(this.ResultNodes.Length > 0) {
					ReturnValue = this.ResultNodes[0];
				}
				
				//this is a termination method clear out properties
				this.XPathQuery = "";
				this.ResultNodes = null;
				
				return ReturnValue;
			}
		//<-- End Method :: GetNode
	
		//##################################################################################
		
		//--> Begin Method :: GetNodesAsString
			public string GetNodesAsString() {
				//execute query
				this.ExecuteQuery();
				
				//get the node array
				XmlNode[] XMLNodes = this.ResultNodes;
				
				//this is a termination method clear out properties
				this.XPathQuery = "";
				this.ResultNodes = null;
				
				//output container
				string ReturnValue = "";
				
				//loop over items and build string
				for(int i = 0 ; i < XMLNodes.Length ; i++) {
					ReturnValue += this.ToString(XMLNodes[i]);
				}
				
				return ReturnValue;
			}
		//<-- End Method :: GetNodesAsString
		
		//##################################################################################
		
		//--> Begin Method :: ReplaceNode
			public DOMTemplate ReplaceNode(XmlNode ThisNode, XmlNode WithThisNode) {
				ThisNode.ParentNode.ReplaceChild(WithThisNode, ThisNode);
				return this;
			}
			public DOMTemplate ReplaceNode(XmlNode WithThisNode) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				this.ReplaceNode(this.ResultNodes[0], WithThisNode);
				return this;
			}
		//<-- End Method :: ReplaceNode
		
		//##################################################################################
		
		//--> Begin Method :: RenameNode
			public DOMTemplate RenameNode(string NodeType) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				//rename
				this.RenameNodes(this.ResultNodes[0], NodeType);
				return this;
			}
			public DOMTemplate RenameNode(XmlNode ThisNode, string NodeType) {
				this.RenameNodes(ThisNode, NodeType);
				return this;
			}
		//<-- End Method :: RenameNode
				
		//##################################################################################
		
		//--> Begin Method :: RenameNodes
			public DOMTemplate RenameNodes(string NodeType) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				//rename
				for(int i = 0 ; i < this.ResultNodes.Length ; i++) {
					this.RenameNodes(this.ResultNodes[i], NodeType);
				}
				return this;
			}
			public DOMTemplate RenameNodes(XmlNode ThisNode, string NodeType) {
				XmlNode NewNode = this.DOMDocument.CreateNode("element", NodeType, ""); 
				
				//add attributes
				for(int i = 0; i < ThisNode.Attributes.Count; i++){
					XmlAttribute NewAttribute = this.DOMDocument.CreateAttribute(ThisNode.Attributes[i].Name);
					NewAttribute.Value = ThisNode.Attributes[i].Value;
					NewNode.Attributes.SetNamedItem(NewAttribute);
				}

				//add children to new node
				for(int i = 0; i < ThisNode.ChildNodes.Count; i++){
					NewNode.AppendChild(ThisNode.ChildNodes[i].CloneNode(true));
				}
				
				//replace existing node with new one
				this.ReplaceNode(ThisNode, NewNode);
				
				return this;
			}
			public DOMTemplate RenameNodes(XmlNode[] Nodes, string NodeType) {
				for(int i = 0 ; i < Nodes.Length ; i++) {
					this.RenameNodes(Nodes[i], NodeType);
				}
				return this;
			}
		//<-- End Method :: RenameNodes
		
		//##################################################################################
		
		//--> Begin Method :: ReplaceInnerString
			public DOMTemplate ReplaceInnerString(string This, string WithThat) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				string Source = this.GetInnerHTML(this.ResultNodes[0]);
				Source = Source.Replace(This, WithThat);
				this.SetInnerHTML(this.ResultNodes[0], Source);
				
				//return this reference
				return this;
			}
		//<-- End Method :: ReplaceInnerString
		
		//##################################################################################
		
		//--> Begin Method :: GetInnerSubString
			public string GetInnerSubString(string Start, string End) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				string Source = this.GetInnerHTML(this.ResultNodes[0]);
				
				int MyStart = 0;
				int MyEnd = 0;
				
				if(Source.IndexOf(Start) > -1 && Source.LastIndexOf(End) > -1) {
					MyStart = (Source.IndexOf(Start)) + Start.Length;
					MyEnd = Source.LastIndexOf(End);
					try{
						return Source.Substring(MyStart, MyEnd - MyStart);
					}
					catch {
						throw new Exception("WebLegs.DOMTemplate.GetInnerSubString(): Boundry string mismatch.");
					}
				}
				else {
					throw new Exception("WebLegs.DOMTemplate.GetInnerSubString(): Boundry strings not present in source string.");
				} 
			}
		//<-- End Method :: GetInnerSubString
		
		//##################################################################################
		
		//--> Begin Method :: RemoveInnerSubString
			public DOMTemplate RemoveInnerSubString(string Start, string End) {
				this.RemoveInnerSubString(Start, End, false);
				
				//return this reference
				return this;
			}
			public DOMTemplate RemoveInnerSubString(string Start, string End, bool RemoveKeys) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				string Source = this.GetInnerHTML(this.ResultNodes[0]);
				string SubString = "";
				
				//try to get the sub string and remove
				try {
					SubString = this.GetInnerSubString(Start, End);
					Source = Source.Replace(SubString, "");
				}
				catch {
					throw new Exception("WebLegs.DOMTemplate.RemoveInnerSubString(): Boundry string mismatch.");
				}
				
				//should we remove the keys too?
				if(RemoveKeys) {
					Source = Source.Replace(Start, "");
					Source = Source.Replace(End, "");
				}
				
				//load this back into the dom
				this.SetInnerHTML(this.ResultNodes[0], Source);
				
				//return this reference
				return this;
			}
		//<-- End Method :: RemoveInnerSubString
		
		//##################################################################################
		
		//--> Begin Method :: SaveAs
			public void SaveAs(string FilePath) {
				try{
					//try to write file
					File.WriteAllText(FilePath, this.ToString(), Encoding.UTF8);
				}
				catch(Exception e) {
					throw new Exception("WebLegs.DOMTemplate.SaveAs(): Unable to save file to '"+ FilePath +"'. "+ e.ToString());
				}
			}
		//<-- End Method :: SaveAs
		
		//##################################################################################
		
		//--> Begin Method :: AppendChild
			public DOMTemplate AppendChild(XmlNode ParentNode, XmlNode ThisNode) {
				ParentNode.AppendChild(ThisNode);
				return this;
			}
			public DOMTemplate AppendChild(XmlNode ThisNode) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				//append child
				this.AppendChild(this.ResultNodes[0], ThisNode);
				return this;
			}
		//<-- End Method :: AppendChild
		
		//##################################################################################
		
		//--> Begin Method :: PrependChild
			public DOMTemplate PrependChild(XmlNode ParentNode, XmlNode ThisNode) {
				ParentNode.PrependChild(ThisNode);
				return this;
			}
			public DOMTemplate PrependChild(XmlNode ThisNode) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				//Prepend child
				this.PrependChild(this.ResultNodes[0], ThisNode);
				return this;
			}
		//<-- End Method :: PrependChild
		
		//##################################################################################
		
		//--> Begin Method :: InsertAfter
			public DOMTemplate InsertAfter(XmlNode RefNode, XmlNode ThisNode) {
				RefNode.ParentNode.InsertAfter(ThisNode, RefNode);
				return this;
			}
			public DOMTemplate InsertAfter(XmlNode ThisNode) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				//Prepend child
				this.InsertAfter(this.ResultNodes[0], ThisNode);
				return this;
			}
		//<-- End Method :: InsertAfter
		
		//##################################################################################
		
		//--> Begin Method :: InsertBefore
			public DOMTemplate InsertBefore(XmlNode RefNode, XmlNode ThisNode) {
				RefNode.ParentNode.InsertBefore(ThisNode, RefNode);
				return this;
			}
			public DOMTemplate InsertBefore(XmlNode ThisNode) {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				//Prepend child
				this.InsertBefore(this.ResultNodes[0], ThisNode);
				return this;
			}
		//<-- End Method :: InsertBefore
	}
//<-- End Class :: DOMTemplate

//##########################################################################################
//##########################################################################################
//##########################################################################################

//--> Begin Class :: DOMXHTMLWriter
	//overload the XmlTextWriter (hacked)
	public class DOMXHTMLWriter : XmlTextWriter  {
		//--> Begin :: Properties
			//elements that should be closed
			private string[] FullEndElements = new string[]{"script", "title", "textarea", "div", "span", "select"};
			//container/flag
			private string LastStartElement = null;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public DOMXHTMLWriter(System.IO.Stream stream) : base(stream, Encoding.UTF8) { }
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: WriteStartElement
			public override void WriteStartElement(string Prefix, string LocalName, string Namespace) {
				LastStartElement = LocalName;
				base.WriteStartElement(Prefix, LocalName, Namespace);
			}
		//<-- End Method :: WriteStartElement
		
		//##################################################################################
		
		//--> Begin Method :: WriteEndElement
			public override void WriteEndElement() {
				//if the last opened element is in the full end elements array, then write a full end element for it
				if(Array.IndexOf(FullEndElements, LastStartElement) > -1) {
					WriteFullEndElement();
				}
				else {
					base.WriteEndElement();
				}
			}
		//<-- End Method :: WriteEndElement
	}
//<-- End Class :: DOMXHTMLWriter

//##########################################################################################
</script>