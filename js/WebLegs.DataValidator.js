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
	WebLegs.DataValidator = function() {
		//no constructor, no properties
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: IsValidEmail
	WebLegs.DataValidator.IsValidEmail = function (Value) {
		return (/^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)\.([A-Za-z]{2,})$/).test(Value);
	}
//<-- End Method :: IsValidEmail

//##########################################################################################

//--> Begin Method :: IsValidURL
	WebLegs.DataValidator.IsValidURL = function(Value) {
		return (/^(http:\/\/www.|https:\/\/www.|ftp:\/\/www.|www.){1}([\w]+)(.[\w]+){1,2}$/).test(Value);
	}
//<-- End Method :: IsValidURL

//##########################################################################################

//--> Begin Method :: IsPhone
	WebLegs.DataValidator.IsPhone = function(Value) {
		return (/^([01][\s\.-]?)?(\(\d{3}\)|\d{3})[\s\.-]?\d{3}[\s\.-]?\d{4}$/).test(Value);
	}
//<-- End Method :: IsPhone

//##########################################################################################

//--> Begin Method :: IsPostalCode
	WebLegs.DataValidator.IsPostalCode = function(Value, CountryCode) {
		if(CountryCode == undefined) {
			CountryCode = "us";
		}
		switch(CountryCode.toLowerCase()){
			case "us":
				return (/^\d{5}(-?\d{4})?$/).test(Value);
				break;
			default:
				//do nothing
				return false;
		}
	}
//<-- End Method :: IsPostalCode

//##########################################################################################

//--> Begin Method :: IsAlpha
	WebLegs.DataValidator.IsAlpha = function(Value) {
		return (/^([a-zA-Z]+)$/).test(Value);
	}
//<-- End Method :: IsAlpha

//##########################################################################################

//--> Begin Method :: IsIPv4
	WebLegs.DataValidator.IsIPv4 = function(Value) {
		return (/^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/).test(Value);
	}
//<-- End Method :: IsIPv4

//##########################################################################################

//--> Begin Method :: IsInt
	WebLegs.DataValidator.IsInt = function(Value) {
		return (/^[0-9]+$/).test(Value);
	}
//<-- End Method :: IsInt

//##########################################################################################

//--> Begin Method :: IsDouble
	WebLegs.DataValidator.IsDouble = function(Value) {
		return (/^(?=.*[1-9].*$)\d{0,7}(?:\.\d{0,9})?$/).test(Value);
	}
//<-- End Method :: IsDouble

//##########################################################################################

//--> Begin Method :: IsNumeric
	WebLegs.DataValidator.IsNumeric = function(Value) {
		return (/^(?=.*[1-9].*$)\d{0,7}(?:\.\d{0,9})?$/).test(Value);
	}
//<-- End Method :: IsNumeric

//##########################################################################################

//--> Begin Method :: IsDateTime
	WebLegs.DataValidator.IsDateTime = function(Value) {
		if(isNaN(Date.parse(Value))){
			return false;	
		}
		else{
			return true;	
		}
	}
//<-- End Method :: IsDateTime

//##########################################################################################

//--> Begin Method :: MinLength
	WebLegs.DataValidator.MinLength = function(Value, Length) {
		//make sure Value is a string
		Value += "";
		if(Value.length >= Length){
			return true;
		}
		else{
			return false;
		}
	}
//<-- End Method :: MinLength

//##########################################################################################

//--> Begin Method :: MaxLength
	WebLegs.DataValidator.MaxLength = function(Value, Length) {
		//make sure Value is a string
		Value += "";
		if(Value.length <= Length){
			return true;
		}
		else{
			return false;
		}
	}
//<-- End Method :: MaxLength

//##########################################################################################

//--> Begin Method :: Length
	WebLegs.DataValidator.Length = function(Value, Length) {
		//make sure Value is a string
		Value += "";
		if(Value.length == Length){
			return true;
		}
		else{
			return false;
		}
	}
//<-- End Method :: Length

//##########################################################################################