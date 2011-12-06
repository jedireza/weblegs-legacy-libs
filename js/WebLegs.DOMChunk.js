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
	WebLegs.DOMChunk = function(ThisDOMTemplate) {
		this.Blank = null;
		this.All = new Array();
		this.Current = null;
		
		//set base path
		this.BasePath = ThisDOMTemplate.XPathQuery;
		
		this.DOMXPath = ThisDOMTemplate.DOMXPath;
		this.DOMDocument = ThisDOMTemplate.DOMDocument;
		
		this.Original = ThisDOMTemplate.GetNode();
		this.Blank = this.Original.cloneNode(true);
	}
//<-- End Method :: Constructor

//##########################################################################################

//<-- Begin Method :: RootNode
	WebLegs.DOMTemplate.prototype.Root = function() {
		//clear out results nodes
		this.ResultNodes = null;
		
		//clear out xpath query
		this.XPathQuery = "";
		
		return this;
	}
//<-- End Method :: RootNode

//##########################################################################################

//--> Begin Method :: Inhertiance
	WebLegs.DOMChunk.prototype = new WebLegs.DOMTemplate();
//<-- End Method :: Inhertiance

//##########################################################################################

//--> Begin Method :: Begin
	WebLegs.DOMChunk.prototype.Begin = function () {
		//make a copy of blank
		this.Current = this.Blank.cloneNode(true);
		
		//put current in the tree
		this.Original.parentNode.replaceChild(this.Current, this.Original); 
		
		//current is the new original
		this.Original = this.Current;
	}
//<-- End Method :: Begin

//##########################################################################################

//--> Begin Method :: End
	WebLegs.DOMChunk.prototype.End = function() {
		//save a copy of current now that its been edited
		this.All.push(this.Current.cloneNode(true));
	}
//<-- End Method :: End

//##########################################################################################

//--> Begin Method :: Render
	WebLegs.DOMChunk.prototype.Render = function() {
		for(var i = 0; i < this.All.length; i++) {
			//add new node with new values to parent node
			this.Original.parentNode.appendChild(this.All[i]);
		}
		
		this.Original.parentNode.removeChild(this.Original);
	}
//<-- End Method :: Render

//##########################################################################################