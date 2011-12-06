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
	WebLegs.BrowserWindow = function() {
		//no constructor, no properties
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Function :: IncludeCSS
	WebLegs.BrowserWindow.IncludeCSS = function(URL){
		var Tag = document.createElement("link");
		Tag.setAttribute("href", URL);	
		Tag.setAttribute("rel", "stylesheet");
		Tag.setAttribute("type", "text/css");
		
		var HeadTag = document.getElementsByTagName("head")[0];
		if(HeadTag != null){
			HeadTag.appendChild(Tag);
		}
		else {
			document.body.appendChild(Tag);
		}
	}
//<-- End Function :: IncludeCSS

//##########################################################################################

//--> Begin Function :: IncludeJS
	WebLegs.BrowserWindow.IncludeJS = function(URL){
		var Tag = document.createElement("script");
		Tag.setAttribute("src", URL);	
		Tag.setAttribute("type", "text/javascript");
		
		var HeadTag = document.getElementsByTagName("head")[0];
		if(HeadTag != null){
			HeadTag.appendChild(Tag);
		}
		else {
			document.body.appendChild(Tag);
		}
	}
//<-- End Function :: IncludeJS

//##########################################################################################

//--> Begin Method :: GetEvent
	WebLegs.BrowserWindow.GetEvent = function(Event) {
		var EventObj = {};
		EventObj.Target;
		EventObj.Type;
		
		//target
			//check for anti-event model (usually ie)
			if(!Event) {
				Event = window.event;
			}
			//usually ff
			if(Event.target) {
				EventObj.Target = Event.target;
			}
			else if(Event.srcElement) {
				EventObj.Target = Event.srcElement;
			}
			//safari bug?
			if(EventObj.Target.nodeType == 3) {
				EventObj.Target = EventObj.Target.parentNode;
			}
		//end target
		
		//type
		EventObj.Type = Event.type;
		
		return EventObj;
	};
//<-- End Method :: GetEvent

//##########################################################################################

//--> Begin Method :: GetWindowWidth
	//this method returns the canvas width (in pixels) for the browser or frame
	WebLegs.BrowserWindow.GetWindowWidth = function() {
		if(self.innerWidth) {
			//in firefox we want to remove the scrollbar
			//from this measurement if it exists
			if(this.GetDocumentHeight() > self.innerHeight) {
				return self.innerWidth - 19;
			}
			return self.innerWidth;
		}
		else if(document.documentElement && document.documentElement.clientWidth) {
			return document.documentElement.clientWidth;
		}
		else if(document.body) {
			return document.body.clientWidth;
		}
		else{
			return 0;
		}
	};
//<-- End Method :: GetWindowWidth

//##########################################################################################

//--> Begin Method :: GetWindowHeight
	//this method returns the canvas height (in pixels) for the browser or frame
	WebLegs.BrowserWindow.GetWindowHeight = function() {
		if(self.innerHeight) {
			//in firefox we want to remove the scrollbar
			//from this measurement if it exists
			if(this.GetDocumentWidth() > self.innerWidth) {
				return self.innerHeight - 19;
			}
			return self.innerHeight;
		}
		else if(document.documentElement && document.documentElement.clientHeight) {
			return document.documentElement.clientHeight;
		}
		else if(document.body) {
			return document.body.clientHeight;
		}
		else{
			return 0;
		}
	};
//<-- End Method :: GetWindowHeight

//##########################################################################################

//--> Begin Method :: GetDocumentWidth
	//get document width
	WebLegs.BrowserWindow.GetDocumentWidth = function() {
		var test1 = document.body.scrollWidth;
		var test2 = document.body.offsetWidth;
		//all but Explorer Mac
		if(test1 > test2) {
			return document.body.scrollWidth;
		}
		else {
			//Explorer Mac
			//would also work in Explorer 6 Strict, Mozilla and Safari
			return document.body.offsetWidth;
		}
	};
//<-- End Method :: GetDocumentWidth

//##########################################################################################

//--> Begin Method :: GetDocumentHeight
	//get document height
	WebLegs.BrowserWindow.GetDocumentHeight = function() {
		var test1 = document.body.scrollHeight;
		var test2 = document.body.offsetHeight
		//all but Explorer Mac
		if(test1 > test2) {
			return document.body.scrollHeight;
		}
		else {
			//Explorer Mac
			//would also work in Explorer 6 Strict, Mozilla and Safari
			return document.body.offsetHeight;
		}
	};
//<-- End Method :: GetDocumentHeight

//##########################################################################################

//--> Begin Method :: GetScrolledX
	//this method returns the X offset (horizontal scroll amount)
	WebLegs.BrowserWindow.GetScrolledX = function() {
		//all except IE
		if(self.pageXOffset) {
			return self.pageXOffset;
		}
		//IE 6 strict
		else if(document.documentElement && document.documentElement.scrollLeft) {
			return document.documentElement.scrollLeft;
		}
		//all others
		else if(document.body) {
			return document.body.scrollLeft;
		}
	};
//<-- End Method :: GetScrolledX

//##########################################################################################

//--> Begin Method :: GetScrolledY
	//this method returns the Y offset (vertical scroll amount)
	WebLegs.BrowserWindow.GetScrolledY = function() {
		//all except IE
		if(self.pageYOffset) {
			return self.pageYOffset;
		}
		//IE 6 strict
		else if(document.documentElement && document.documentElement.scrollTop) {
			return document.documentElement.scrollTop;
		}
		//all others
		else if(document.body) {
			return document.body.scrollTop;
		}
	};
//<-- End Method :: GetScrolledY

//##########################################################################################

//--> Begin Method :: GetElementHeight
	//this method returns the height of a rendered element
	WebLegs.BrowserWindow.GetElementHeight = function(Element) {
		var elementHeight = 0;
		if(Element.offsetHeight) {
			elementHeight = Element.offsetHeight;
		}
		else if(Element.clip && Element.clip.height) {
			elementHeight = Element.clip.height;
		}
		else if(Element.style && Element.style.pixelHeight) {
			elementHeight = Element.style.pixelHeight;
		}
		return parseInt(elementHeight);
	};
//<-- End Method :: GetElementHeight

//##########################################################################################

//--> Begin Method :: GetElementWidth
	//this method returns the width of a rendered element
	WebLegs.BrowserWindow.GetElementWidth = function(Element) {
		var elementWidth = 0;
		if(Element.offsetWidth) {
			elementWidth = Element.offsetWidth;
		}
		else if(Element.clip && Element.clip.width) {
			elementWidth = Element.clip.width;
		}
		else if(Element.style && Element.style.pixelWidth) {
			elementWidth = Element.style.pixelWidth;
		}
		return parseInt(elementWidth);
	};
//<-- End Method :: GetElementWidth

//##########################################################################################

//--> Begin Method :: GetElementTop
	//this method returns the top coordinate for an element
	WebLegs.BrowserWindow.GetElementTop = function(Element) {
		var elementTop = 0;
		elementTop = Element.offsetTop;
		var ParentElement = Element.offsetParent;
		while(ParentElement != null) {
  			elementTop += ParentElement.offsetTop;
	  		ParentElement = ParentElement.offsetParent;
  		}
		return elementTop;
	};
//<-- End Method :: GetElementTop

//##########################################################################################

//--> Begin Method :: GetElementLeft
	//this method returns the left coordinate for an element
	WebLegs.BrowserWindow.GetElementLeft = function(Element) {
		var elementLeft = 0;
		elementLeft = Element.offsetLeft;
		var ParentElement = Element.offsetParent;
		while(ParentElement != null) {
  			elementLeft += ParentElement.offsetLeft;
	  		ParentElement = ParentElement.offsetParent;
  		}
		return elementLeft;
	};
//<-- End Method :: GetElementLeft

//##########################################################################################