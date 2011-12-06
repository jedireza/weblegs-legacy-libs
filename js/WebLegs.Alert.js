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
	WebLegs.Alert = function() {
		this.Alerts = new Array();
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: Add
	WebLegs.Alert.prototype.Add = function(Value) {
		this.Alerts.push(Value);
	};
//<-- End Method :: Add

//##########################################################################################

//--> Begin Method :: Count
	WebLegs.Alert.prototype.Count = function() {
		return this.Alerts.length;
	};
//<-- End Method :: Count

//##########################################################################################

//--> Begin Method :: Item
	WebLegs.Alert.prototype.Item = function(Index) {
		return this.Alerts[Index];
	};
//<-- End Method :: Item

//##########################################################################################

//--> Begin Method :: ToJSON
	WebLegs.Alert.prototype.ToJSON = function() {
		var AlertJSON = "";
		AlertJSON += "{";
		
		//build the json
		for(var i = 0 ; i < this.Alerts.length ; i++) {
			var TempItem = this.Alerts[i];
			TempItem = TempItem.replace(/"/g, "\\\"");
			
			AlertJSON += "\""+ (i+1) +"\":\""+ TempItem +"\"";
			if(i+1 != this.Alerts.length) {
				AlertJSON += ",";
			}
		}
		
		AlertJSON += "}";
		return AlertJSON;	
	};
//<-- End Method :: ToJSON

//##########################################################################################

//--> Begin Method :: ToArray
	WebLegs.Alert.prototype.ToArray = function() {
		return this.Alerts
	};
//<-- End Method :: ToArray

//##########################################################################################