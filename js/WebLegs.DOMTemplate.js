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

//--> Begin :: Namespace Check
	//define vars for needed objects
	var WebLegs;
	
	//is our namespace present?
	if(!WebLegs) {
		WebLegs = {};
	}
//<-- End :: Namespace Check

//##########################################################################################

//--> Begin Method :: Constructor
	WebLegs.DOMTemplate = function() {
		this.XPathQuery = "";
		this.DOMDocument = document;
		this.ResultNodes = new Array();
		this.BasePath = "";
	};
//<-- End Method :: Constructor

//##########################################################################################

//<-- Begin Method :: Traverse
	WebLegs.DOMTemplate.prototype.Traverse = function(Value) {
		//clear out results nodes
		this.ResultNodes = null;

		//set the xpath query
		this.XPathQuery += Value;

		return this;
	}
//<-- End Method :: Traverse

//##########################################################################################

//<-- Begin Method :: GetDOMChunk
	WebLegs.DOMTemplate.prototype.GetDOMChunk = function() {
		var ReturnData = new WebLegs.DOMChunk(this);
		this.XPathQuery = "";
		return ReturnData;
	}
//<-- End Method :: GetDOMChunk

//##########################################################################################

//<-- Begin Method :: ExecuteQuery
	WebLegs.DOMTemplate.prototype.ExecuteQuery = function(NewXPathQuery) {
		//ExecuteQuery(XPathQuery) overload
		if(NewXPathQuery != undefined) {
			var ReturnNodes = new Array();
			var Nodes = this.DOMDocument.evaluate(this.BasePath + NewXPathQuery, this.DOMDocument, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
			var i = 0;
			for(var i = 0; i < Nodes.snapshotLength; i++) {
				ReturnNodes.push(Nodes.snapshotItem(i));
			}
			
			//return this reference
			return ReturnNodes;
		}
		//ExecuteQuery() overload
		else {
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
			var ReturnNodes = new Array();
			var Nodes = this.DOMDocument.evaluate(this.BasePath + this.XPathQuery, this.DOMDocument, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
			var i = 0;
			for(var i = 0; i < Nodes.snapshotLength; i++) {
				ReturnNodes.push(Nodes.snapshotItem(i));
			}

			//clear out xpath query
			this.XPathQuery = "";
			
			//set result nodes property
			this.ResultNodes =  ReturnNodes;

			//return this reference
			return this;
		}
	}
//<-- End Method :: ExecuteQuery

//##########################################################################################

//<-- Begin Method :: ToString
	WebLegs.DOMTemplate.prototype.ToString = function() {
		var Output = "";
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		
		//ToString()
		if(NumberOfArgs == 0) {
			var MyRootNode = this.DOMDocument.createElement("div");
			var MyHTMLNode = this.DOMDocument.createElement("html");
			for(var i = 0 ; i < this.DOMDocument.body.parentNode.attributes.length ; i++) {
				MyHTMLNode.setAttribute(this.DOMDocument.body.parentNode.attributes[i].nodeName, this.DOMDocument.body.parentNode.attributes[i].nodeValue);
			}
			MyRootNode.appendChild(MyHTMLNode);
			try {
				MyHTMLNode.innerHTML = this.DOMDocument.body.parentNode.innerHTML;
				return MyRootNode.innerHTML;
			}
			//IE hack job
			catch(Error){
				var CompleteSource = MyRootNode.innerHTML.replace(/\<\/HTML\>/i, "");
				CompleteSource += this.DOMDocument.body.parentNode.innerHTML;
				CompleteSource += "</HTML>";
				return CompleteSource;
			}
		}
		else {
			//ToString(XmlNodeList ThisNodeList)
			if(Args[0].item) {
				//get all children
				for(var i = 0 ; i < Args[0].length ; i++){
					Output += this.ToString(Args[0].item(i));
				}
			}
			//ToString(XmlNode ThisNode)
			else{
				var MyCloneParent = this.DOMDocument.createElement("div");
				var MyClone = Args[0].cloneNode(true);
				MyCloneParent.appendChild(MyClone);
				Output += MyCloneParent.innerHTML;
			}
		}
		
		return Output;
	}
//<-- End Method :: ToString

//##########################################################################################

//<-- Begin Method :: GetNodesByTagName
	WebLegs.DOMTemplate.prototype.GetNodesByTagName = function(TagName) {
		//clear out results nodes
		this.ResultNodes = null;

		//set the xpath query
		this.XPathQuery += "//"+ TagName;

		return this;
	}
//<-- End Method :: GetNodesByTagName

//##########################################################################################

//<-- Begin Method :: GetNodeByID
	WebLegs.DOMTemplate.prototype.GetNodeByID = function(Value) {
		//clear out results nodes
		this.ResultNodes = null;
		
		//set the xpath query
		this.XPathQuery += "//*[@id='"+ Value +"']";

		return this;
	}
//<-- End Method :: GetNodeByID

//##########################################################################################

//<-- Begin Method :: GetNodesByAttribute
	WebLegs.DOMTemplate.prototype.GetNodesByAttribute = function(Attribute, Value) {
		//clear out results nodes
		this.ResultNodes = null;
		
		//GetNodesByAttribute(Attribute, Value)
		if(Value != undefined) {
			//set the xpath query
			this.XPathQuery += "//*[@"+ Attribute +"='"+ Value +"']";
		}
		//GetNodesByAttribute(Attribute)
		else{
			//set the xpath query
			this.XPathQuery += "//*[@"+ Attribute +"]";
		}

		return this;
	}
//<-- End Method :: GetNodesByAttribute

//##########################################################################################

//<-- Begin Method :: GetNodesByDataSet
	WebLegs.DOMTemplate.prototype.GetNodesByDataSet = function(Attribute, Value) {
		//GetNodesByDataSet(Attribute, Value)
		if(Value != undefined) {
			//use GetNodesByAttribute
			this.GetNodesByAttribute("data-"+ Attribute, Value);
		}
		//GetNodesByDataSet(Attribute)
		else{
			//use GetNodesByAttribute
			this.GetNodesByAttribute("data-"+ Attribute);
		}

		return this;
	}
//<-- End Method :: GetNodesByDataSet

//##########################################################################################

//<-- Begin Method :: GetNodesByAttributes
	WebLegs.DOMTemplate.prototype.GetNodesByAttributes = function(Attributes) {
		//clear out results nodes
		this.ResultNodes = null;
		
		var Query = "";
		for(Item in Attributes) {
			Query += "@"+ Item +"='"+ Attributes[Item] +"' and ";
		}
		
		//clean up the end - remove the last "' and "
		Query = Query.substring(0, Query.length - 5);
		
		//set the xpath query
		this.XPathQuery += "//*["+ Query +"]";
		
		//execute query
		return this;
	}
//<-- End Method :: GetNodesByAttributes
	
//##########################################################################################

//<-- Begin Method :: SetAttribute
	WebLegs.DOMTemplate.prototype.SetAttribute = function() {
		//emulate overloading with these argument count and vars
		var Nodes = "";
		var Attribute = "";
		var Value = "";
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		
		//SetAttribute(string Attribute, string Value)
		if(NumberOfArgs == 2) {
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
		
			//set argument vars
			Attribute = Args[0];
			Value = Args[1];
			
			for(var i = 0; i < this.ResultNodes.length; i++) {
				this.ResultNodes[i].setAttribute(Attribute, Value);
			}
		
		}
		else if(NumberOfArgs == 3) {
			//set argument vars
			Nodes = Args[0];
			Attribute = Args[1];
			Value = Args[2];
			
			//SetAttribute(array Nodes, string Attribute, string Value)
			if(Nodes instanceof Array == true) {
				for(i = 0; i < Nodes.length; i++) {
					Nodes[i].setAttribute(Attribute, Value);
				}
			}
			//SetAttribute(node Nodes, string Attribute, string Value)
			else{
				Nodes.setAttribute(Attribute, Value);
			}
		}
		
		return this;
	}
//<-- End Method :: SetAttribute

//##########################################################################################

//<-- Begin Method :: GetAttribute
	WebLegs.DOMTemplate.prototype.GetAttribute = function() {
		//emulate overloading with these argument count and vars
		var Nodes = "";
		var Attribute = "";
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		var ReturnValue = "";
		
		//GetAttribute(string Attribute)
		if(NumberOfArgs == 1) {
			Attribute = Args[0];
			
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			ReturnValue = this.ResultNodes[0].getAttribute(Attribute);
		}
		//GetAttribute(node Node, string Attribute)
		else if(NumberOfArgs == 2) {
			Node = Args[0];
			Attribute = Args[1];
			ReturnValue = Node.getAttribute(Attribute);
		}
		
		//this is a termination method clear out properties
		this.XPathQuery = "";
		this.ResultNodes = null;
		
		return ReturnValue;
	}
//<-- End Method :: GetAttribute

//##########################################################################################

//<-- Begin Method :: SetInnerHTML
	WebLegs.DOMTemplate.prototype.SetInnerHTML = function() {
		//emulate overloading with these argument count and vars
		var Nodes = "";
		var Attribute = "";
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		var ReturnValue = "";
		
		//SetInnerHTML(string Value)
		if(NumberOfArgs == 1) {
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			
			Value = Args[0];
			
			for(var i = 0; i < this.ResultNodes.length; i++) {
				this.ResultNodes[i].innerHTML = Value;
			}
		}
		else if(NumberOfArgs == 2) {
			Nodes = Args[0];
			Value = Args[1];
			
			//SetInnerHTML(array Nodes, string Value)
			if(Nodes instanceof Array == true) {
				for(var i = 0; i < Nodes.length; i++) {
					Nodes[i].innerHTML = Value;
				}
			}
			//SetInnerHTML(node Nodes, string Value)
			else{
				Nodes.innerHTML = Value;
			}
		}
		
		return this;
	}
//<-- End Method :: SetInnerHTML

//##########################################################################################

//<-- Begin Method :: GetOuterHTML
	WebLegs.DOMTemplate.prototype.GetOuterHTML = function() {
		//emulate overloading with these argument count and vars
		var Node = "";
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		var ReturnValue = "";
		
		//GetOuterHTML()
		if(NumberOfArgs == 0) {
			//execute query if this.ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			
			ReturnValue = this.GetOuterHTML(this.ResultNodes[0]);
		}
		//GetOuterHTML(node $Node)
		else if(NumberOfArgs == 1) {
			ReturnValue = this.ToString(Args[0]);
		}
		
		//this is a termination method clear out properties
		this.XPathQuery = "";
		this.ResultNodes = null;
		
		return ReturnValue;
	}
//<-- End Method :: GetOuterHTML

//##########################################################################################

//<-- Begin Method :: GetInnerHTML
	WebLegs.DOMTemplate.prototype.GetInnerHTML = function() {
		//emulate overloading with these argument count and vars
		var Nodes = "";
		var Attribute = "";
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		var ReturnValue = "";
		
		//GetInnerHTML()
		if(NumberOfArgs == 0) {
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			
			ReturnValue = this.ResultNodes[0].innerHTML;
		}
		//GetInnerHTML(node Node)
		else if(NumberOfArgs == 1) {
			Node = Args[0];
			ReturnValue = Node.innerHTML;
		}
		
		return ReturnValue;
	}
//<-- End Method :: GetInnerHTML

//##########################################################################################

//<-- Begin Method :: SetInnerText
	WebLegs.DOMTemplate.prototype.SetInnerText = function() {
		//emulate overloading with these argument count and vars
		var Nodes = "";
		var Attribute = "";
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		var ReturnValue = "";
		
		//SetInnerText(Value)
		if(NumberOfArgs == 1) {
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			
			//set argument
			Value = Args[0];
			
			for(var i = 0; i < this.ResultNodes.length; i++) {
				this.ResultNodes[i].textContent = Value;
			}
		}
		else if(NumberOfArgs == 2) {
			Nodes = Args[0];
			Value = Args[1];
			
			//SetInnerText(array Nodes, string Value)
			if(gettype(Nodes) == "array") {
				for(var i = 0; i < Nodes.length; i++) {
					Nodes[i].textContent = Value;
				}
			}
			//SetInnerText(node Nodes, string Value)
			else{
				Nodes.textContent = Value;
			}
		}
		
		return this;
	}
//<-- End Method :: SetInnerText

//##########################################################################################

//<-- Begin Method :: GetInnerText
	WebLegs.DOMTemplate.prototype.GetInnerText = function() {
		//emulate overloading with these argument count and vars
		var Nodes = "";
		var Attribute = "";
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		var ReturnValue = "";
		
		//GetInnerText()
		if(NumberOfArgs == 0) {
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			
			ReturnValue = this.ResultNodes[0].textContent;
		}
		//GetInnerText(node Node)
		else if(NumberOfArgs == 1) {
			Node = Args[0];
			ReturnValue = Node.textContent;
		}
		
		//this is a termination method clear out properties
		this.XPathQuery = "";
		this.ResultNodes = null;
		
		return ReturnValue;
	}
//<-- End Method :: GetInnerText

//##########################################################################################

//<-- Begin Method :: Remove
	WebLegs.DOMTemplate.prototype.Remove = function() {
		//emulate overloading with these argument count and vars
		var Nodes = "";
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		
		//Remove()
		if(NumberOfArgs == 0) {
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			
			for(var i = 0; i < this.ResultNodes.length; i++) {
				this.ResultNodes[i].parentNode.removeChild(this.ResultNodes[i]);
			}
		}
		else if(NumberOfArgs == 1) {
			Nodes = Args[0];
			
			//Remove(array Nodes)
			if(Nodes instanceof Array == true) {
				for(var i = 0; i < Nodes.length; i++) {
					Nodes[i].parentNode.removeChild(Nodes[i]);
				}
			}
			//Remove(node Nodes)
			else{
				Nodes.parentNode.removeChild(Nodes);
			}
		}
		
		//this is a termination method clear out properties
		this.XPathQuery = "";
		this.ResultNodes = null;
	}
//<-- End Method :: Remove

//##########################################################################################

//<-- Begin Method :: RemoveAttribute
	WebLegs.DOMTemplate.prototype.RemoveAttribute = function() {
		//emulate overloading with these argument count and vars
		var Nodes = "";
		var Attribute = "";
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		var ReturnValue = "";
		
		//RemoveAttribute(Attribute)
		if(NumberOfArgs == 1) {
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			
			Attribute = Args[0];

			for(i = 0; i < this.ResultNodes.length; i++) {
				this.ResultNodes[i].removeAttribute(Attribute);
			}
		}
		else if(NumberOfArgs == 2) {
			Nodes = Args[0];
			Attribute = Args[1];
			
			//RemoveAttribute(array Nodes, string Attribute)
			if(Nodes instanceof Array == true) {
				for(var i = 0; i < Nodes.length; i++) {
					Nodes[i].removeAttribute(Attribute);
				}
			}
			//RemoveAttribute(node Nodes, string Attribute)
			else{
				Nodes.removeAttribute(Attribute);
			}
		}
		
		return this;
	}
//<-- End Method :: RemoveAttribute

//##########################################################################################

//<-- Begin Method :: RemoveAllAttributes
	WebLegs.DOMTemplate.prototype.RemoveAllAttributes = function() {
		//emulate overloading with these argument count and vars
		var Nodes = "";
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		var ReturnValue = "";
		
		//RemoveAllAttributes()
		if(NumberOfArgs == 0) {
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			
			for(var i = 0; i < this.ResultNodes.length; i++) {
	
				//get attribute names
				var AttributeNames = new Array();
				
				for(var j = this.ResultNodes[i].attributes.length - 1; j >= 0; j--) {
					AttributeNames.push(this.ResultNodes[i].attributes[j].nodeName);
				}
				
				//remove all attributes
				for(k = 0 ; k <= AttributeNames.length; k++) {
					this.ResultNodes[i].removeAttribute(AttributeNames[k]);
				}
			}
			
			
		}
		else if(NumberOfArgs == 1) {
			Nodes = Args[0];	
			//RemoveAllAttributes(array Nodes)
			if(Nodes instanceof Array == true) {
				for(i = 0; i < Nodes.length; i++) {
		
					//get attribute names
					var AttributeNames = new Array();
					
					for(var j = Nodes[i].attributes.length - 1; j >= 0; j--) {
						AttributeNames.push(Nodes[i].attributes[j].nodeName);
					}
					
					//remove all attributes
					for(k = 0 ; k <= AttributeNames.length; k++) {
						Nodes[i].removeAttribute(AttributeNames[k]);
					}
				}
			}
			//RemoveAllAttributes(node Nodes)
			else{
				
				//get attribute names
				var AttributeNames = new Array();
				
				for(var i = Node.attributes.length - 1; i >= 0; i--) {
					AttributeNames.push(Node.attributes[i].nodeName);
				}
				
				//remove all attributes
				for(i = 0 ; i <= AttributeNames.length; i++) {
					Node.removeAttribute(AttributeNames[i]);
				}
			}
		}
		return this;
	}
//<-- End Method :: RemoveAllAttributes

//##########################################################################################

//<-- Begin Method :: GetNodes
	WebLegs.DOMTemplate.prototype.GetNodes = function() {
		//execute query
		this.ExecuteQuery();
		
		var ReturnValue = this.ResultNodes;
		
		//this is a termination method clear out properties
		this.XPathQuery = "";
		this.ResultNodes = null;
		
		return ReturnValue;
	}
//<-- End Method :: GetNodes

//##########################################################################################

//<-- Begin Method :: GetNode
	WebLegs.DOMTemplate.prototype.GetNode = function() {
		//execute query
		this.ExecuteQuery();
		
		var ReturnValue = this.ResultNodes[0];
		
		//this is a termination method clear out properties
		this.XPathQuery = "";
		this.ResultNodes = null;
		
		return ReturnValue;
	}
//<-- End Method :: GetNode

//##########################################################################################

//<-- Begin Method :: GetNodesAsString
	WebLegs.DOMTemplate.prototype.GetNodesAsString = function() {
		//execute query
		this.ExecuteQuery();
		
		//get the node array
		var XMLNodes = this.ResultNodes;
		
		//this is a termination method clear out properties
		this.XPathQuery = "";
		this.ResultNodes = null;
		
		//output container
		var ReturnValue = "";
		
		//loop over items and build string
		for(var i = 0 ; i < XMLNodes.length ; i++) {
			ReturnValue += this.ToString(XMLNodes[i]);
		}
		
		return ReturnValue;
	}
//<-- End Method :: GetNodesAsString

//##########################################################################################

//<-- Begin Method :: ReplaceNode
	WebLegs.DOMTemplate.prototype.ReplaceNode = function() {
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		
		if(NumberOfArgs == 1){
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			this.ReplaceNode(this.ResultNodes[0], Args[1]);
		}
		else if(NumberOfArgs == 2){
			Args[0].parentNode.replaceChild(Args[1], Args[0]);
		}
		
		return this;
	}
//<-- End Method :: ReplaceNode
		
//##################################################################################

//--> Begin Method :: RenameNode
	WebLegs.DOMTemplate.prototype.RenameNode = function() {
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		
		//RenameNodes(NodeType)
		if(NumberOfArgs == 1){
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			this.RenameNodes(this.ResultNodes[0], Args[0]);
		}
		//RenameNodes(Node, NodeType)
		else if(NumberOfArgs == 2){
			this.RenameNodes(Args[0], Args[1]);
		}
		return this;
	}
//<-- End Method :: RenameNode

//##################################################################################

//--> Begin Method :: RenameNodes
	WebLegs.DOMTemplate.prototype.RenameNodes = function() {
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		
		//RenameNodes(NodeType)
		if(NumberOfArgs == 1){
			
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			for(var i = 0; i < this.ResultNodes.length; i++) {
				this.RenameNodes(this.ResultNodes[i], Args[0]);
			}
		}
		else if(NumberOfArgs == 2){
			//RenameNodes(Nodes[], NodeType)
			if(Args[0] instanceof Array){
				for(var i = 0; i < Args[0].length; i++){
					this.RenameNodes(Args[0], Args[1]);
				}
			}
			//RenameNodes(Node, NodeType)
			else{
				var ThisNode = Args[0];
				var NewNode = this.DOMDocument.createElement(Args[1]);
				
				//set attributes
				for(var i = 0; i < ThisNode.attributes.length; i++) {
					NewNode.setAttribute(ThisNode.attributes[i].nodeName, ThisNode.attributes[i].nodeValue);
				}
				
				//set children
				NewNode.innerHTML = ThisNode.innerHTML;
				
				//replace nodes
				this.ReplaceNode(ThisNode, NewNode);
			}
		}
		return this;
	}
//<-- End Method :: RenameNodes

//##########################################################################################

//<-- Begin Method :: ReplaceInnerString
	WebLegs.DOMTemplate.prototype.ReplaceInnerString = function(This, WithThat) {
		//execute query if ResultNodes == null
		if(this.ResultNodes == null) {
			//execute query
			this.ExecuteQuery();
		}
		var Source = this.GetInnerHTML(this.ResultNodes[0]);
		while(Source.indexOf(This) > -1) {
			Source = Source.replace(This, WithThat);
		}
		this.SetInnerHTML(this.ResultNodes[0], Source);
		return this;
	}
//<-- End Method :: ReplaceInnerString

//##########################################################################################

//<-- Begin Method :: GetInnerSubString
	WebLegs.DOMTemplate.prototype.GetInnerSubString = function(Start, End) {
		//execute query if ResultNodes == null
		if(this.ResultNodes == null) {
			//execute query
			this.ExecuteQuery();
		}
		var Source = this.GetInnerHTML(this.ResultNodes[0]);
		
		var MyStart = 0;
		var MyEnd = 0;
		if(Source.indexOf(Start) != -1 && Source.lastIndexOf(End) != -1) {
			MyStart = (Source.indexOf(Start)) + Start.length;
			MyEnd = (Source.lastIndexOf(End));
			
			try{
				return Source.substr(MyStart, MyEnd - MyStart);
			}
			catch(Error) {
				throw("WebLegs.DOMTemplate.GetInnerSubString(): Boundry string mismatch.");
			}
		}
		else {
			throw("WebLegs.DOMTemplate.GetInnerSubString(): Boundry strings not present in source string.");
		}
	}
//<-- End Method :: GetInnerSubString

//##########################################################################################

//<-- Begin Method :: RemoveInnerSubString
	WebLegs.DOMTemplate.prototype.RemoveInnerSubString = function(Start, End, RemoveKeys) {
		if(RemoveKeys == undefined) {
			RemoveKeys = false;
		}
		
		//execute query if ResultNodes == null
		if(this.ResultNodes == null) {
			//execute query
			this.ExecuteQuery();
		}
		var Source = this.GetInnerHTML(this.ResultNodes[0]);
		
		var SubString = "";
		
		//try to get the sub string and remove
		try {
			SubString = this.GetInnerSubString(Start, End);
			while(Source.indexOf(SubString) > -1) {
				Source = Source.replace(SubString, "");
			}
		}
		catch(Error) {
			throw("WebLegs.DOMTemplate.RemoveInnerSubString(): Boundry string mismatch.");
		}
		
		//should we remove the keys too?
		if(RemoveKeys) {
			while(Source.indexOf(Start) > -1) {
				Source = Source.replace(Start, "");
			}
			while(Source.indexOf(End) > -1) {
				Source = Source.replace(End, "");
			}
		}
		
		//load this back into the dom
		this.SetInnerHTML(this.ResultNodes[0], Source);
		
		return this;
	}
//<-- End Method :: RemoveInnerSubString

//##################################################################################

//--> Begin Method :: AppendChild
	WebLegs.DOMTemplate.prototype.AppendChild = function() {
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		
		//AppendChild(Node ParentNode, Node ThisNode)
		if(NumberOfArgs == 2){
			Args[0].appendChild(Args[1]);
		}
		//AppendChild(Node ThisNode)
		else{
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			this.AppendChild(this.ResultNodes[0], Args[0]);
		}
		return this;
	}
//<-- End Method :: AppendChild

//##################################################################################

//--> Begin Method :: PrependChild
	WebLegs.DOMTemplate.prototype.PrependChild = function() {
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		
		//PrependChild(Node ParentNode, Node ThisNode)
		if(NumberOfArgs == 2){
			Args[0].insertBefore(Args[1], Args[0].firstChild);
		}
		//PrependChild(Node ThisNode)
		else{
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			this.PrependChild(this.ResultNodes[0], Args[0]);
		}
		
		return this;
	}
//<-- End Method :: PrependChild

//##################################################################################

//--> Begin Method :: InsertAfter
	WebLegs.DOMTemplate.prototype.InsertAfter = function() {
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		
		//InsertAfter(Node RefNode, Node ThisNode)
		if(NumberOfArgs == 2){
			//determine if the ref node is the last node
			if(Args[0].parentNode.lastChild.isSameNode(Args[0]) == true){
				Args[0].parentNode.appendChild(Args[1]);
			}
			//its not the last node
			else{
				Args[0].parentNode.insertBefore(Args[1], Args[0].nextSibling);
			}
		}
		//InsertAfter(Node ThisNode)
		else{
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			this.InsertAfter(this.ResultNodes[0], Args[0]);
		}
		
		return this;
	}
//<-- End Method :: InsertAfter

//##################################################################################

//--> Begin Method :: InsertBefore
	WebLegs.DOMTemplate.prototype.InsertBefore = function() {
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		
		//InsertBefore(Node RefNode, Node ThisNode)
		if(NumberOfArgs == 2){
			Args[0].parentNode.insertBefore(Args[1], Args[0]);
		}
		//InsertBefore(Node ThisNode)
		else{
			//execute query if ResultNodes == null
			if(this.ResultNodes == null) {
				//execute query
				this.ExecuteQuery();
			}
			this.InsertBefore(this.ResultNodes[0], Args[0]);
		}
		return this;
	}
//<-- End Method :: InsertBefore

//##########################################################################################