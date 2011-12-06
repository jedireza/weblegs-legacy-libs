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
	WebLegs.TextTemplate = function() {
		this.Source = "";
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: Load
	WebLegs.TextTemplate.prototype.Load = function(MyString) {
		this.Source = MyString;
		return this;
	};
//<-- End Method :: Load

//##########################################################################################

//--> Begin Method :: Replace
	WebLegs.TextTemplate.prototype.Replace = function(This, WithThis) {
		while(this.Source.indexOf(This) != -1) {
			this.Source = this.Source.replace(This, WithThis);
		}
		return this;
	};
//<-- End Method :: Replace

//##########################################################################################

//--> Begin Method :: GetSubString
	WebLegs.TextTemplate.prototype.GetSubString = function(Start, End) {
		var MyStart = 0;
		var MyEnd = 0;
		if(this.Source.indexOf(Start) != -1 && this.Source.lastIndexOf(End) != -1) {
			MyStart = (this.Source.indexOf(Start)) + Start.length;
			MyEnd = (this.Source.lastIndexOf(End));
			
			try{
				return this.Source.substr(MyStart, MyEnd - MyStart);
			}
			catch(Error) {
				throw("WebLegs.TextTemplate.GetSubString(): Boundry string mismatch.");
			}
		}
		else {
			throw("WebLegs.TextTemplate.GetSubString(): Boundry strings not present in source string.");
		}
	};
//<-- End Method :: GetSubString

//##########################################################################################

//--> Begin Method :: RemoveSubString
	WebLegs.TextTemplate.prototype.RemoveSubString = function(Start, End, RemoveKeys) {
		if(RemoveKeys == undefined) {
			RemoveKeys = false;
		}
		try{
			SubString = this.GetSubString(Start, End);
		}
		catch(Error) {
			throw("WebLegs.TextTemplate.RemoveSubString(): Boundry string mismatch.");
		}
		
		//remove substring
		this.Replace(SubString, "");
		
		//should we remove the keys too?
		if(RemoveKeys) {
			this.Replace(Start, "");
			this.Replace(End, "");
		}
		return this;
	};
//<-- End Method :: RemoveSubString

//##########################################################################################

//--> Begin Method :: ToString
	WebLegs.TextTemplate.prototype.ToString = function() {
		return this.Source;
	};
//<-- End Method :: ToString

//##########################################################################################