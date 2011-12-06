<%@ page import="javax.xml.transform.*" %>
<%@ page import="javax.xml.transform.stream.*" %>
<%@ page import="org.xml.sax.EntityResolver" %>
<%@ page import="org.xml.sax.InputSource" %>
<%@ page import="org.xml.sax.SAXException" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.io.Writer" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.net.MalformedURLException" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="javax.xml.parsers.*" %>
<%@ page import="javax.xml.transform.dom.DOMSource" %>
<%@ page import="javax.xml.xpath.XPathFactory" %>
<%@ page import="javax.xml.xpath.XPath" %>
<%@ page import="javax.xml.xpath.XPathExpression" %>
<%@ page import="javax.xml.xpath.XPathConstants" %>
<%@ page import="javax.xml.xpath.XPathExpressionException" %>
<%@ page import="java.lang.Exception.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Enumeration" %>
<%!
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
			public String XPathQuery;
			public Document DOMDocument;
			public XPath DOMXPath;
			public Node[] ResultNodes;
			public String BasePath;
			public String DTD;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public DOMTemplate() {
				//create new xpath factory
				XPathFactory MyXPathFactory = XPathFactory.newInstance();
				this.DOMXPath = MyXPathFactory.newXPath();
				this.XPathQuery = "";
				this.BasePath = "";
				this.DTD = "";
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//<-- End Method :: Traverse
			public DOMTemplate Traverse(String Value) {
				//clear out results nodes
				this.ResultNodes = null;
		
				//set the xpath query
				this.XPathQuery += Value;
				
				return this;
			}
		//<-- End Method :: Traverse
		
		//##################################################################################
		
		//--> Begin Method :: GetDOMChunk
			public DOMChunk GetDOMChunk()throws Exception {
				DOMChunk ReturnData = new DOMChunk(this);
				this.ResultNodes = null;
				this.XPathQuery = "";
				return ReturnData;
			}
		//<-- End Method :: GetDOMChunk
		
		//##################################################################################
		
		//--> Begin Method :: LoadFile
			public DOMTemplate LoadFile(String Path) throws Exception {
				BufferedReader XMLSourceReader = null;
				StringBuffer FileData = null;
				try{
					//read in xml file into a string
					int NumberRead = 0;
					char[] Buffer = new char[1024];
					FileData = new StringBuffer(1000);
					XMLSourceReader = new BufferedReader(new FileReader(Path));
					while((NumberRead = XMLSourceReader.read(Buffer)) != -1){
						FileData.append(Buffer, 0, NumberRead);
					}
				}
				catch(Exception e){
					throw new Exception("WebLegs.DOMTemplate.LoadFile(): File not found or not able to access.");
				}
				finally{
					//close buffer reader
					XMLSourceReader.close();
				}
				
				//load string
				this.Load(FileData.toString());
				
				//return this reference
				return this;
			}
			public DOMTemplate LoadFile(String Path, String RootPath) throws Exception {			
				BufferedReader XMLSourceReader = null;
				StringBuffer FileData = null;
				try{
					//read in xml file into a string
					int NumberRead = 0;
					char[] Buffer = new char[1024];
					FileData = new StringBuffer(1000);
					XMLSourceReader = new BufferedReader(new FileReader(Path));
					while((NumberRead = XMLSourceReader.read(Buffer)) != -1){
						FileData.append(Buffer, 0, NumberRead);
					}
				}
				catch(Exception e){
					throw new Exception("WebLegs.DOMTemplate.LoadFile(): File not found or not able to access.");
				}
				finally{
					//close buffer reader
					XMLSourceReader.close();
				}
				
				//load string
				this.Load(FileData.toString(), RootPath);
				
				//return this reference
				return this;
			}
		//<-- End Method :: LoadFile
		
		//##################################################################################
		
		//--> Begin Method :: Load
			public DOMTemplate Load(String Source) throws Exception {
				//create a document builder factory
				DocumentBuilderFactory MyDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
				
				//get the dtd
				Pattern MyPattern = Pattern.compile("(<!DOCTYPE.*?>)");
				Matcher MyMatcher = MyPattern.matcher(Source);
				if(MyMatcher.find()){
					this.DTD = MyMatcher.group(1);
				}
				
				//remove doctype
				Source = Source.replaceAll("<!DOCTYPE.*?>", "");
				
				//turn off validation
				MyDocumentBuilderFactory.setValidating(false);
				
				//creat a dom document from the transformed data - also convert bytes to UTF-8
				this.DOMDocument = MyDocumentBuilderFactory.newDocumentBuilder().parse(new ByteArrayInputStream(Source.getBytes("UTF8")));
				
				//clear out xpath query
				this.XPathQuery = "";
				
				//clear out result nodes
				this.ResultNodes =  null;
				
				//return this reference
				return this;
			}
			public DOMTemplate Load(String Source, String RootPath) throws Exception {
				//get xsl file path from <?xml-stylesheet type="text/xml" href="_XSL/templates/www_main.xsl"?>
				String XSLTFilePath = "";
				Pattern MyPattern = Pattern.compile("xml-stylesheet.*href=[\"|\'](.*?)[\"|\']");
				Matcher MyMatcher = MyPattern.matcher(Source);
				
				//if we found the stylesheet then set the filepath
				if(MyMatcher.find()){
					XSLTFilePath = MyMatcher.group(1);
				}
				
				//get the system ids for both the file and stylesheet
				//String XMLSystemID = new File(Path).toURL().toExternalForm();
				String XSLTSystemID = new File(RootPath + XSLTFilePath).toURL().toExternalForm();
				
				//get the dtd
				MyPattern = Pattern.compile("(<!DOCTYPE.*?>)");
				MyMatcher = MyPattern.matcher(Source);
				if(MyMatcher.find()){
					this.DTD = MyMatcher.group(1);
				}
								
				//strip out dtd
				Source = Source.replaceAll("<!DOCTYPE.*?>", "");
				
				//create stream sources
				//StreamSource XMLSource = new StreamSource(XMLSystemID); 
				StreamSource XMLSource = new StreamSource(new StringReader(Source));
				StreamSource XSLTSource = new StreamSource(XSLTSystemID);
				
				//send result to a writer
				StringWriter MyStringWriter = new StringWriter();
				Result MyResult = new StreamResult(MyStringWriter);
				
				//create transformer factory
				TransformerFactory MyTransformerFactory = TransformerFactory.newInstance();
				
				//set resolver
				MyTransformerFactory.setURIResolver(null);
				
				//create new transformer
				Transformer MyTransformer = MyTransformerFactory.newTransformer(XSLTSource);
				
				//set output properties
				MyTransformer.setOutputProperty(OutputKeys.CDATA_SECTION_ELEMENTS, "yes");
				MyTransformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
				//MyTransformer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"); //I have not found the option to turn remote download off
				MyTransformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
				//MyTransformer.setOutputProperty(OutputKeys.INDENT, "yes");
				MyTransformer.setOutputProperty(OutputKeys.MEDIA_TYPE, "text/xml");
				MyTransformer.setOutputProperty(OutputKeys.METHOD, "xml");
				MyTransformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
				MyTransformer.setOutputProperty(OutputKeys.STANDALONE, "yes");
				MyTransformer.setOutputProperty(OutputKeys.VERSION, "1.0"); 
	
				//transform document
				MyTransformer.transform(XMLSource, MyResult);
			
				//create a document builder factory
				DocumentBuilderFactory MyDocumentBuilderFactory = DocumentBuilderFactory.newInstance();

				//turn off validation
				MyDocumentBuilderFactory.setValidating(false);
				
				//create new doc builder
				DocumentBuilder MyDocumentBuilder = MyDocumentBuilderFactory.newDocumentBuilder();

				//creat a dom document from the transformed data - also convert bytes to UTF-8
				this.DOMDocument = MyDocumentBuilder.parse(new ByteArrayInputStream(MyStringWriter.toString().getBytes("UTF8")));
				
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
			public Node[] ExecuteQuery(String NewXPathQuery) throws Exception {
				//compile expression
				XPathExpression XPathExp = this.DOMXPath.compile(NewXPathQuery);
			
				//get result
				Object ThisResult = XPathExp.evaluate(this.DOMDocument, XPathConstants.NODESET);
				
				//cast result to node list
				NodeList MyNodes = (NodeList) ThisResult;
				
				//create result node array
				Node[] ReturnNodes = new Node[MyNodes.getLength()];
				
				//add each node to array
				for(int i = 0; i < MyNodes.getLength(); i++) {
					ReturnNodes[i] = MyNodes.item(i);
				}
				
				//return nodes
				return ReturnNodes;			
			}
			public DOMTemplate ExecuteQuery() throws Exception {
				//if its blank default to whole document
				if(this.BasePath.equals("") && this.XPathQuery.equals("")) {
					this.XPathQuery = "//*";
				}
				//this accomodates for the duplicate queries in both the basepath and xpathquery
				//this can happen when attempting to access the parent node in a DOMChunk
				else if(this.BasePath.equals(this.XPathQuery)){
					this.XPathQuery = "";
				}
				
				//compile expression
				XPathExpression XPathExp = this.DOMXPath.compile(this.BasePath + this.XPathQuery);
			
				//get result
				Object ThisResult = XPathExp.evaluate(this.DOMDocument, XPathConstants.NODESET);
				
				//cast result to node list
				NodeList MyNodes = (NodeList) ThisResult;
				
				//create result node array
				Node[] ReturnNodes = new Node[MyNodes.getLength()];
				
				//add each node to array
				for(int i = 0; i < MyNodes.getLength(); i++) {
					ReturnNodes[i] = MyNodes.item(i);
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
			public String ToString() throws Exception {	
				//create domsource from document
				Source ThisSource = new DOMSource(this.DOMDocument);
				
				//create bytearray output stream
				ByteArrayOutputStream MyByteArray = new ByteArrayOutputStream();
				
				//create stream result
				Result MyResult = new StreamResult(MyByteArray);
				
				//create transformer
				Transformer MyTransformer = TransformerFactory.newInstance().newTransformer();
				
				//transform document
				MyTransformer.transform(ThisSource, MyResult);
				
				return this.DTD + MyByteArray.toString();
			}
			public String ToString(Node ThisNode) throws Exception {
				//create domsource from document
				Source ThisSource = new DOMSource(ThisNode);
				
				//create bytearray output stream
				ByteArrayOutputStream MyByteArray = new ByteArrayOutputStream();
				
				//create stream result
				Result MyResult = new StreamResult(MyByteArray);
				
				//create transformer
				Transformer MyTransformer = TransformerFactory.newInstance().newTransformer();
				
				//set output properties
				//MyTransformer.setOutputProperty(OutputKeys.CDATA_SECTION_ELEMENTS, "yes");
				//MyTransformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
				//MyTransformer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"); //I have not found the option to turn remote download off
				//MyTransformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
				//MyTransformer.setOutputProperty(OutputKeys.INDENT, "yes");
				//MyTransformer.setOutputProperty(OutputKeys.MEDIA_TYPE, "text/xml");
				//MyTransformer.setOutputProperty(OutputKeys.METHOD, "xml");
				MyTransformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
				//MyTransformer.setOutputProperty(OutputKeys.STANDALONE, "yes");
				//MyTransformer.setOutputProperty(OutputKeys.VERSION, "1.0"); 
				
				//transform document
				MyTransformer.transform(ThisSource, MyResult);
				
				return MyByteArray.toString();
			}
			public String ToString(NodeList ThisNodeList) throws Exception {
				String Output = "";
				
				//get all children
				for(int i = 0; i < ThisNodeList.getLength(); i++){
					Output += this.ToString(ThisNodeList.item(i));
				}
				
				return Output;
			}
		//<-- End Method :: ToString
		
		//##################################################################################
		
		//--> Begin Method :: GetNodesByTagName
			public DOMTemplate GetNodesByTagName(String TagName) throws Exception {
				//execute query
				this.ResultNodes = null;
				
				//set the xpath query
				this.XPathQuery += "//"+ TagName;
				
				return this;
			}
		//<-- End Method :: GetNodesByTagName
		
		//##################################################################################
		
		//--> Begin Method :: GetNodeByID
			public DOMTemplate GetNodeByID(String Value) throws Exception {
				//execute query
				this.ResultNodes = null;
				
				//set the xpath query
				this.XPathQuery += "//*[@id='"+ Value +"']";
				
				return this;
			}
		//<-- End Method :: GetNodeByID
		
		//##################################################################################
		
		//--> Begin Method :: GetNodesByAttribute
			public DOMTemplate GetNodesByAttribute(String Attribute) throws Exception {
				//execute query
				this.ResultNodes = null;
				
				//set the xpath query
				this.XPathQuery += "//*[@"+ Attribute +"]";
				
				return this;
			}
			public DOMTemplate GetNodesByAttribute(String Attribute, String Value) throws Exception {
				//execute query
				this.ResultNodes = null;
				
				//set the xpath query
				this.XPathQuery += "//*[@"+ Attribute +"='"+ Value +"']";
				
				return this;
			}
		//<-- End Method :: GetNodesByAttribute
		
		//##################################################################################
		
		//--> Begin Method :: GetNodesByDataSet
			public DOMTemplate GetNodesByDataSet(String Attribute) throws Exception {
				//use GetNodesByAttribute
				this.GetNodesByAttribute("data-"+ Attribute);
				return this;
			}		
			public DOMTemplate GetNodesByDataSet(String Attribute, String Value) throws Exception {
				//use GetNodesByAttribute
				this.GetNodesByAttribute("data-"+ Attribute, Value);
				
				return this;
			}
		//<-- End Method :: GetNodesByDataSet
		
		//##################################################################################
		
		//--> Begin Method :: GetNodesByAttributes
			public DOMTemplate GetNodesByAttributes(Hashtable Attributes) throws Exception {
				//clear out results nodes
				this.ResultNodes = null;
				
				Vector MyVector = new Vector(Attributes.keySet());
    			Collections.sort(MyVector);
				
				String Query = "";
				int Counter = 0;
				int Count = Attributes.size();
				for(Enumeration e = MyVector.elements(); e.hasMoreElements();) {
					String Key = (String) e.nextElement();
					String Value = (String) Attributes.get(Key);
					Query += "@"+ Key +"='"+ Value +"'";
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
			public DOMTemplate SetAttribute(String Attribute, String Value) throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
	
				for(int i = 0 ; i < this.ResultNodes.length; i++) {
					this.SetAttribute(this.ResultNodes[i], Attribute, Value);
				}
		
				return this;
			}
			public DOMTemplate SetAttribute(Node Node, String Attribute, String Value) throws Exception {
				//create new a attribute node
				Attr NewAttribute = this.DOMDocument.createAttribute(Attribute);
				NewAttribute.setValue(Value);
				
				//add new attribute
				Node.getAttributes().setNamedItem(NewAttribute);
				
				return this;
			}
			public DOMTemplate SetAttribute(Node[] Nodes, String Attribute, String Value) throws Exception {
				for(int i = 0 ; i < Nodes.length; i++) {
					this.SetAttribute(Nodes[i], Attribute, Value);
				}
				
				return this;
			}
		//<-- End Method :: SetAttribute
		
		//##################################################################################
		
		//--> Begin Method :: GetAttribute
			public String GetAttribute(String Attribute) throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				if(this.ResultNodes[0] != null){
					return this.ResultNodes[0].getAttributes().getNamedItem(Attribute).getNodeValue().toString();
				}
				else{
					return null;
				}
			}
			public String GetAttribute(Node Node, String Attribute) throws Exception {
				return Node.getAttributes().getNamedItem(Attribute).getNodeValue().toString();
			}
		//<-- End Method :: GetAttribute
		
		//##################################################################################
		
		//--> Begin Method :: SetInnerHTML
			public DOMTemplate SetInnerHTML(String Value) throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				//set node value
				for(int i = 0 ; i < this.ResultNodes.length ; i++) {
					this.SetInnerHTML(this.ResultNodes[i], Value);
				}
				
				return this;
			}
			public DOMTemplate SetInnerHTML(Node Node, String Value) throws Exception {
				//remove all child nodes
				while(Node.getChildNodes().getLength() != 0){
					this.Remove(Node.getChildNodes().item(0));
				}
				
				//first we try to append the node xml
				try{
					//set a root node
					Value = "<container-root>"+ Value +"</container-root>";
					
					//create a document builder factory
					DocumentBuilderFactory MyDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
					
					//turn off validation
					MyDocumentBuilderFactory.setValidating(false);
					
					//create a dom document from the transformed data - also convert bytes to UTF-8
					Document NewDocNode = MyDocumentBuilderFactory.newDocumentBuilder().parse(new ByteArrayInputStream(Value.getBytes("UTF8")));
					
					//import the new document element into the main document - this doesnt mean its visible yet
					Node NewNode = this.DOMDocument.importNode(NewDocNode.getDocumentElement(), true);
										
					//append children to Node
					for(int i = 0; i < NewNode.getChildNodes().getLength(); i++){
						Node.appendChild(NewNode.getChildNodes().item(i).cloneNode(true));
					}
				}
				//if it fails - let just import a text node
				catch(Exception e){
					
					//create text node from value
					Text NewTextNode = this.DOMDocument.createTextNode(Value);
					
					//now append the new node
					Node.appendChild(NewTextNode);
				}
				
				return this;
			}
			public DOMTemplate SetInnerHTML(Node[] Nodes, String Value) throws Exception {
				for(int i = 0 ; i < Nodes.length ; i++) {
					this.SetInnerHTML(Nodes[i], Value);
				}
				return this;
			}
		//<-- End Method :: SetInnerHTML
		
		//##################################################################################
		
		//--> Begin Method :: GetOuterHTML
			public String GetOuterHTML() throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				return this.ToString(this.ResultNodes[0]);
			}
			public String GetOuterHTML(Node Node) throws Exception {
				return this.ToString(Node);
			}
		//<-- End Method :: GetOuterHTML
			
		//##################################################################################
		
		//--> Begin Method :: GetInnerHTML
			public String GetInnerHTML() throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				return this.ToString(this.ResultNodes[0].getChildNodes());
			}
			public String GetInnerHTML(Node Node) throws Exception {
				return this.ToString(Node.getChildNodes());
			}
		//<-- End Method :: GetInnerHTML
		
		//##################################################################################
		
		//--> Begin Method :: SetInnerText
			public DOMTemplate SetInnerText(String Value) throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				for(int i = 0 ; i < this.ResultNodes.length ; i++) {
					this.SetInnerText(this.ResultNodes[i], Value);
				}
				return this;
			}
			public DOMTemplate SetInnerText(Node Node, String Value) throws Exception {
				//remove all child nodes
				while(Node.getChildNodes().getLength() != 0){
					this.Remove(Node.getChildNodes().item(0));
				}
				
				//create text node from value
				Text NewTextNode = this.DOMDocument.createTextNode(Value);
				
				//now append the new node
				Node.appendChild(NewTextNode);

				return this;
			}
			public DOMTemplate SetInnerText(Node[] Nodes, String Value) throws Exception {
				for(int i = 0 ; i < Nodes.length ; i++) {
					this.SetInnerText(Nodes[i], Value);
				}
				return this;
			}
		//<-- End Method :: SetInnerText
		
		//##################################################################################
		
		//--> Begin Method :: GetInnerText
			public String GetInnerText() throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				return this.ToString(this.ResultNodes[0].getChildNodes());
			}
			
			public String GetInnerText(Node Node) throws Exception {
				return this.ToString(Node.getChildNodes());
			}
		//<-- End Method :: GetInnerText
		
		//##################################################################################
		
		//--> Begin Method :: Remove
			public DOMTemplate Remove() throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				for(int i = 0 ; i < this.ResultNodes.length ; i++) {
					this.ResultNodes[i].getParentNode().removeChild(this.ResultNodes[i]);
				}
				//return this reference
				return this;
			}
			
			public DOMTemplate Remove(Node Node) throws Exception {
				Node.getParentNode().removeChild(Node);
				
				//return this reference
				return this;
			}
			public DOMTemplate Remove(Node[] Nodes) throws Exception {
				for(int i = 0 ; i < Nodes.length ; i++) {
					this.Remove(Nodes[i]);
				}
				
				//return this reference
				return this;
			}
		//<-- End Method :: Remove
		
		//##################################################################################
		
		//--> Begin Method :: RemoveAttribute
			public DOMTemplate RemoveAttribute(String Attribute) throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				for(int i = 0 ; i < this.ResultNodes.length ; i++) {
					this.ResultNodes[i].getAttributes().removeNamedItem(Attribute);
				}
				return this;
			}
			
			public DOMTemplate RemoveAttribute(Node Node, String Attribute) throws Exception {
				Node.getAttributes().removeNamedItem(Attribute);
				return this;
			}
			
			public DOMTemplate RemoveAttribute(Node[] Nodes, String Attribute) throws Exception {
				for(int i = 0 ; i < Nodes.length ; i++) {
					Nodes[i].getAttributes().removeNamedItem(Attribute);
				}
				return this;
			}
		//<-- End Method :: RemoveAttribute
		
		//##################################################################################
		
		//--> Begin Method :: RemoveAllAttributes
			public DOMTemplate RemoveAllAttributes() throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				for(int i = 0 ; i < this.ResultNodes.length ; i++) {
					this.RemoveAllAttributes(this.ResultNodes[i]);
				}
				return this;
			}
			
			public DOMTemplate RemoveAllAttributes(Node Node) throws Exception {
				//remove all attributes
				while(Node.getAttributes().getLength() != 0){
					Node.getAttributes().removeNamedItem(Node.getAttributes().item(0).getNodeName());
				}
				return this;
			}
		
			public DOMTemplate RemoveAllAttributes(Node[] Nodes) throws Exception {
				for(int i = 0 ; i < Nodes.length ; i++) {
					this.RemoveAllAttributes(Nodes[i]);
				}
				return this;
			}
		//<-- End Method :: RemoveAllAttributes
		
		//##################################################################################
		
		//--> Begin Method :: GetNodes
			public Node[] GetNodes() throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				Node[] ReturnValue = this.ResultNodes;
				
				//this is a termination method clear out properties
				this.XPathQuery = "";
				this.ResultNodes = null;
				
				return ReturnValue;
			}
		//<-- End Method :: GetNodes
		
		//##################################################################################
		
		//--> Begin Method :: GetNode
			public Node GetNode() throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				Node ReturnValue = null;
				if(this.ResultNodes.length > 0) {
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
			public String GetNodesAsString() throws Exception {
				//execute query
				this.ExecuteQuery();
				
				//get the node array
				Node[] ReturnNodes = this.ResultNodes;
				
				//this is a termination method clear out properties
				this.XPathQuery = "";
				this.ResultNodes = null;
				
				//output container
				String ReturnValue = "";
				
				//loop over items and build string
				for(int i = 0 ; i < ReturnNodes.length ; i++) {
					ReturnValue += this.ToString(ReturnNodes[i]);
				}
				
				return ReturnValue;
			}
		//<-- End Method :: GetNodesAsString
		
		//##################################################################################
		
		//--> Begin Method :: ReplaceNode
			public DOMTemplate ReplaceNode(Node ThisNode, Node WithThisNode) throws Exception {
				ThisNode.getParentNode().replaceChild(WithThisNode, ThisNode);
				return this;
			}
			public DOMTemplate RenameNode(Node WithThisNode) throws Exception {
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
			public DOMTemplate RenameNode(String NodeType) throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				//rename
				this.RenameNodes(this.ResultNodes[0], NodeType);
				return this;
			}
			public DOMTemplate RenameNode(Node ThisNode, String NodeType) throws Exception {
				this.RenameNodes(ThisNode, NodeType);
				return this;
			}
		//<-- End Method :: RenameNode
				
		//##################################################################################
		
		//--> Begin Method :: RenameNodes
			public DOMTemplate RenameNodes(String NodeType) throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				
				//rename
				for(int i = 0 ; i < this.ResultNodes.length ; i++) {
					this.RenameNodes(this.ResultNodes[i], NodeType);
				}
				
				return this;
			}
			public DOMTemplate RenameNodes(Node ThisNode, String NodeType) throws Exception {
				Element NewNode = this.DOMDocument.createElement(NodeType); 
				
				//add attributes
				for(int i = 0; i < ThisNode.getAttributes().getLength(); i++){
					//create new a attribute node
					Attr NewAttribute = this.DOMDocument.createAttribute(ThisNode.getAttributes().item(i).getNodeName());
					NewAttribute.setValue(ThisNode.getAttributes().item(i).getNodeValue());
					
					//add new attribute
					NewNode.getAttributes().setNamedItem(NewAttribute);
				}

				//append children to Node
				for(int i = 0; i < ThisNode.getChildNodes().getLength(); i++){
					NewNode.appendChild(ThisNode.getChildNodes().item(i).cloneNode(true));
				}
				
				//replace existing node with new one
				this.ReplaceNode(ThisNode, NewNode);
				
				return this;
			}
			public DOMTemplate RenameNodes(Node[] Nodes, String NodeType) throws Exception {
				for(int i = 0 ; i < Nodes.length ; i++) {
					this.RenameNodes(Nodes[i], NodeType);
				}
				return this;
			}
		//<-- End Method :: RenameNodes
		
		//##################################################################################
		
		//--> Begin Method :: ReplaceInnerString
			public DOMTemplate ReplaceInnerString(String This, String WithThat) throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				String Source = this.GetInnerHTML(this.ResultNodes[0]);
				Source.replaceAll(This.replaceAll("([\\\\*+\\[\\](){}\\$.?\\^|])", "\\\\$1"), WithThat);
				this.SetInnerHTML(this.ResultNodes[0], Source);
				
				//return this reference
				return this;
			}
		//<-- End Method :: ReplaceInnerString
		
		//##################################################################################
		
		//--> Begin Method :: GetInnerSubString
			public String GetInnerSubString(String Start, String End) throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				String Source = java.net.URLDecoder.decode(this.GetInnerHTML(this.ResultNodes[0]));
				int MyStart = 0;
				int MyEnd = 0;
				if(Source.indexOf(Start) > -1 && Source.lastIndexOf(End) > -1) {
					MyStart = (Source.indexOf(Start)) + Start.length();
					MyEnd = Source.lastIndexOf(End);
					try{
						return Source.substring(MyStart, MyEnd);
					}
					catch(Exception e){
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
			public DOMTemplate RemoveInnerSubString(String Start, String End) throws Exception {
				this.RemoveInnerSubString(Start, End, false);

				//return this reference
				return this;
			}
			public DOMTemplate RemoveInnerSubString(String Start, String End, boolean RemoveKeys) throws Exception {
				//execute query if ResultNodes == null
				if(this.ResultNodes == null) {
					//execute query
					this.ExecuteQuery();
				}
				String Source = this.GetInnerHTML(this.ResultNodes[0]);
				String SubString = "";
				
				//try to get the sub string and remove
				try {
					SubString = this.GetInnerSubString(Start, End);
					Source = Source.replaceAll(SubString, "");
				}
				catch(Exception e){
					throw new Exception("WebLegs.DOMTemplate.RemoveInnerSubString(): Boundry string mismatch.");
				}
				
				//should we remove the keys too?
				if(RemoveKeys) {
					Source = Source.replaceAll(Start, "");
					Source = Source.replaceAll(End, "");
				}
				
				//load this back into the dom
				this.SetInnerHTML(this.ResultNodes[0], Source);
				
				//return this reference
				return this;
			}
		//<-- End Method :: RemoveInnerSubString
		
		//##################################################################################
		
		//--> Begin Method :: SaveAs
			public void SaveAs(String FilePath) throws Exception {
				Writer OutputBuffer = null;
				try {
					OutputBuffer = new BufferedWriter(new FileWriter(new File(FilePath)));
					OutputBuffer.write(this.ToString());
				}
				catch(Exception e){
					throw new Exception("WebLegs.DOMTemplate.SaveAs(): Unable to save file.");
				}
				finally {
					OutputBuffer.close();
				}
			}
		//<-- End Method :: SaveAs
		
		//##################################################################################
		
		//--> Begin Method :: AppendChild
			public DOMTemplate AppendChild(Node ParentNode, Node ThisNode) throws Exception {
				ParentNode.appendChild(ThisNode);
				return this;
			}
			public DOMTemplate AppendChild(Node ThisNode) throws Exception {
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
			public DOMTemplate PrependChild(Node ParentNode, Node ThisNode) throws Exception {
				ParentNode.insertBefore(ThisNode, ParentNode.getFirstChild());
				return this;
			}
			public DOMTemplate PrependChild(Node ThisNode) throws Exception {
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
			public DOMTemplate InsertAfter(Node RefNode, Node ThisNode) throws Exception {
				//determine if the ref node is the last node
				if(RefNode.getParentNode().getLastChild() == RefNode){
					RefNode.getParentNode().appendChild(ThisNode);
				}
				//its not the last node
				else{
					RefNode.getParentNode().insertBefore(ThisNode, RefNode.getNextSibling());
				}
				return this;
			}
			public DOMTemplate InsertAfter(Node ThisNode) throws Exception {
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
			public DOMTemplate InsertBefore(Node RefNode, Node ThisNode) throws Exception {
				RefNode.getParentNode().insertBefore(ThisNode, RefNode);
				return this;
			}
			public DOMTemplate InsertBefore(Node ThisNode) throws Exception {
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
%>