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
	WebLegs.TextChunk = function(Source, Begin, End) {
		if(Source == undefined) {
			this.Blank = "";
			this.Current = "";
			this.All = "";
		}
		else{
			var MyStart = 0;
			var MyEnd = 0;
			if(Source.indexOf(Begin) != -1 && Source.indexOf(End) != -1) {
				MyStart = (Source.indexOf(Begin)) + Begin.length;
				MyEnd = (Source.indexOf(End));
				
				try{
					this.Blank = Source.substr(MyStart, MyEnd - MyStart);
				}
				catch(Error) {
					throw("WebLegs.TextChunk.Constructor(): Boundry string mismatch.");
				}
				
				this.Current = "";
				this.All = "";
			}
			else {
				throw("WebLegs.TextChunk.Constructor(): Boundry strings not present in source string.");
			}
			
		}
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: Begin
	WebLegs.TextChunk.prototype.Begin = function() {
		this.Current = this.Blank;
	};
//<-- End Method :: Begin

//##########################################################################################

//--> Begin Method :: End
	WebLegs.TextChunk.prototype.End = function() {
		this.All += this.Current;
	};
//<-- End Method :: End

//##########################################################################################

//--> Begin Method :: Replace
	WebLegs.TextChunk.prototype.Replace = function(This, WithThis) {
		while(this.Current.indexOf(This) != -1) {
			this.Current = this.Current.replace(This, WithThis);
		}
		return this;
	};
//<-- End Method :: Replace

//##########################################################################################

//--> Begin Method :: ToString
	WebLegs.TextChunk.prototype.ToString = function() {
		return this.All;
	};
//<-- End Method :: ToString

//##########################################################################################