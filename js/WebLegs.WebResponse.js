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
	WebLegs.WebResponse = function() {
		//do nothing
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: Finalize
	WebLegs.WebResponse.prototype.Finalize = function() {
		//future plans for server-side javascript implementations
	};
//<-- End Method :: Finalize

//##########################################################################################

//--> Begin Method :: Write
	WebLegs.WebResponse.prototype.Write = function(Value) {
		document.write(Value);
	};
//<-- End Method :: Write

//##########################################################################################

//--> Begin Method :: Redirect
	WebLegs.WebResponse.prototype.Redirect = function(URL) {
		window.location = URL;
	};
//<-- End Method :: Redirect

//##########################################################################################

//--> Begin Method :: Cookies
	WebLegs.WebResponse.prototype.Cookies = function(Key, Value, Minutes, Path, Domain, Secure) {
		var Cookie = Key +"="+ Value +"; ";
		
		//should we add the expiration date?
		if(Minutes != undefined) {
			var Now = new Date();
			Now.setMinutes((Minutes + Now.getMinutes()));
			
			var Expires = Now.toGMTString();
			Cookie += "expires="+ Expires +"; ";
		}
		
		//should we add the path?
		if(Path != undefined) {
			Cookie += " path="+ Path +"; ";
		}
		else{
			Cookie += " path=/; ";
		}
		
		//should we add the domain?
		if(Domain != undefined) {
			Cookie += " domain="+ Domain +"; ";
		}
		else{
			Cookie += " domain="+ document.location.hostname +"; ";
		}
		
		//if we are ssl make cookies require ssl | probably only used w/ server side js implementations
		if(Secure == true) {
			Cookie += " secure";
		}
		else if(document.location.protocol == "https") {
			Cookie += " secure";
		}

		//set cookie
		//"name=value; expires=date; path=path; domain=domain; secure";
		document.cookie = Cookie;
	};
//<-- End Method :: Cookies

//##########################################################################################

//--> Begin Method :: ClearCookies
	WebLegs.WebResponse.prototype.ClearCookies = function(Path, Domain) {
		//get all cookies
		var RawCookies = document.cookie;
		
		//split the cookies
		var CookieArray = RawCookies.split("; ");
		
		//loop over and expire cookies
		for(var i = 0 ; i < CookieArray.length ; i++) {
			if(Path != undefined && Domain != undefined) {
				this.Cookies(CookieArray[i], "", -1000, Path, Domain);
			}
			else if(Path != undefined) {
				this.Cookies(CookieArray[i], "", -1000, Path);
			}
			else {
				this.Cookies(CookieArray[i], "", -1000);
			}
		}
	};
//<-- End Method :: ClearCookies

//##########################################################################################