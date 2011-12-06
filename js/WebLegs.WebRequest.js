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
	WebLegs.WebRequest = function() {
		this.QueryStringArray = null;
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: Form
	WebLegs.WebRequest.prototype.Form = function(Key, Default, FormReference) {
		//get all forms as querystring
		if(Key == undefined && Default == undefined && FormReference == undefined) {
			var QueryArray = new Array();
			for(var i = 0; i < document.forms.length; i++ ) {
				var CurrentForm = document.forms[i];
				for(var j = 0; j < CurrentForm.length; j++ ) {
					var Add = false;
					var CurrentElement = CurrentForm[j];
					switch(CurrentElement.type) {
						//- - - - - - - - - - - - - - - - - - - -//
						case "radio":
							if(CurrentElement.checked) {
								Add = true;
							}
							break;
						//- - - - - - - - - - - - - - - - - - - -//
						case "checkbox":
							if(CurrentElement.checked) {
								Add = true;
							}
							break;
						//- - - - - - - - - - - - - - - - - - - -//
						case "submit":
						case "button":
							Add = false;
							break;
						//- - - - - - - - - - - - - - - - - - - -//
						default:
							Add = true;
							break;
					}
					
					//dont add disabled items
					if(CurrentElement.disabled == true){
						Add = false;
					}
					
					if(Add) {
						QueryArray.push(encodeURIComponent(CurrentElement.name) + "=" + encodeURIComponent(CurrentElement.value));
					}
					
				}
			}
			
			return QueryArray.join("&");
		}
		//get specific form as querystring
		else if(Key instanceof HTMLFormElement == true && Default == undefined && FormReference == undefined) {
			var QueryArray = new Array();
			var CurrentForm = Key;
			for(var j = 0; j < CurrentForm.length; j++ ) {
		
				var Add = false;
				var CurrentElement = CurrentForm[j];
				switch(CurrentElement.type) {
					//- - - - - - - - - - - - - - - - - - - -//
					case "radio":
						if(CurrentElement.checked) {
							Add = true;
						}
						break;
					//- - - - - - - - - - - - - - - - - - - -//
					case "checkbox":
						if(CurrentElement.checked) {
							Add = true;
						}
						break;
					//- - - - - - - - - - - - - - - - - - - -//
					case "submit":
					case "button":
						Add = false;
						break;
					//- - - - - - - - - - - - - - - - - - - -//
					default:
						Add = true;
						break;
				}
				
				//dont add disabled items
				if(CurrentElement.disabled == true){
					Add = false;
				}
				
				if(Add) {
					QueryArray.push(encodeURIComponent(CurrentElement.name) + "=" + encodeURIComponent(CurrentElement.value));
				}
			}
			return QueryArray.join("&");
		}
		//search all forms for specific key, and return first one found
		else if(Key != undefined && Default == undefined && FormReference == undefined) {
			
			var ReturnValue = "";
			//loop through each form
			for(var i = 0; i < document.forms.length; i++ ) {
				//loop through each element in current form
				var CurrentForm = document.forms[i];
				for(var j = 0; j < CurrentForm.length; j++ ) {
					//is the current element name equal to the key?
					var CurrentElement = CurrentForm[j];
					if(CurrentElement.name.toUpperCase() == Key.toUpperCase()) {
						ReturnValue += CurrentElement.value + ",";
					}
				}
			}
			
			if(ReturnValue != "") {
				//remove last ',' and return
				return ReturnValue.substring(0, ReturnValue.length - 1);
			}
		}
		//search all forms for a specific key and return first one found, if not found return default
		else if(Key != undefined && Default != undefined && FormReference == undefined) {
			//loop through each form
			for(var i = 0; i < document.forms.length; i++ ) {
				//loop through each element in current form
				var CurrentForm = document.forms[i];
				for(var j = 0; j < CurrentForm.length; j++ ) {
					//is the current element name equal to the key?
					var CurrentElement = CurrentForm[j];
					if(CurrentElement.name.toUpperCase() == Key.toUpperCase() && CurrentElement.disabled != true) {
						return CurrentElement.value;
					}
				}
			}
			
			//return default
			return Default;
		}
		//search specific form for specific key and return first one found, if not found return default
		else if(Key != undefined && Default != undefined && FormReference instanceof HTMLFormElement == true) {
			//loop through each element in current form
			var CurrentForm = FormReference;
			for(var j = 0; j < CurrentForm.length; j++ ) {
				//is the current element name equal to the key?
				var CurrentElement = CurrentForm[j];
				if(CurrentElement.name.toUpperCase() == Key.toUpperCase() && CurrentElement.disabled != true) {
					return CurrentElement.value;
				}
			}
			
			//return default
			return Default;
		}
		
		return null;
	};
//<-- End Method :: Form

//##########################################################################################

//--> Begin Method :: QueryString
	WebLegs.WebRequest.prototype.QueryString = function(Key, Default) {
		//just return query string
		if(Key == undefined) {
			//remove the ? at the beginning of the querystring
			return document.location.search.substring(1, document.location.search.length);
		}
		
		//if this.QueryString is null that means we havent used it yet
		if(this.QueryStringArray == null) {
			//make sure there are items to organize
			if(document.location.search.length > 0) {
				//assign Array 
				this.QueryStringArray = new Array();
				var TmpQueryString = document.location.search.substring(1, document.location.search.length).split('&');
				for(var i=0;i < TmpQueryString.length;i++) {
					var TmpPair = TmpQueryString[i].split('=');
					
					//check to see if there is a key in the array already, if there isnt add it
					if(this.QueryStringArray[TmpPair[0]] == undefined) {
						this.QueryStringArray[TmpPair[0]] = TmpPair[1];
					}
					// if there is then concat with ','
					else{
						this.QueryStringArray[TmpPair[0]] += ","+ TmpPair[1];
					}
					
				}
			}
			else{
				//there werent any 
				this.QueryStringArray = new Array();	
			}
		}
		
		//if the defaul is set and the key does not have a value return default
		if(Default != undefined && this.QueryStringArray[Key] == undefined) {
			return Default;
		}
		//if the the key does not have a value then return null
		else if(this.QueryStringArray[Key] == undefined) {
			return null;
		}
		
		return this.QueryStringArray[Key];
	};
//<-- End Method :: QueryString

//##########################################################################################

//--> Begin Method :: Input
	WebLegs.WebRequest.prototype.Input = function(Key, Default, FormFirst) {
		//container
		Value = null;
		
		if(FormFirst == true) {
			Value = this.Form(Key);
			if(Value == null) {
				Value =  this.QueryString(Key);
			}
		}
		else {
			Value =  this.QueryString(Key);
			if(Value == null) {
				Value = this.Form(Key);
			}
		}
		
		if(Value == null && Default != undefined) {
			Value = Default;
		}
		
		return Value;
	};
//<-- End Method :: Input

//##########################################################################################

//--> Begin Method :: Cookies
	WebLegs.WebRequest.prototype.Cookies = function(Key) {
		var Cookies = document.cookie.split("; ");
		for(var i=0; i < Cookies.length; i++) {
			var TmpPair = Cookies[i].split('=');
			if(Key.toUpperCase() == TmpPair[0].toUpperCase()) {
				return TmpPair[1];
			}
		}
		return null;
	};
//<-- End Method :: Cookies

//##########################################################################################