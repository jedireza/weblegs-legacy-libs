<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<script language="c#" runat="server">
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

//--> Begin Class :: Alert
	public class Alert {
		//--> Begin :: Properties
			public List<string> Alerts;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public Alert() {
				this.Alerts = new List<string>();
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Add
			public void Add(string Value) {
				this.Alerts.Add(Value);
			}
		//<-- End Method :: Add
		
		//##################################################################################
		
		//--> Begin Method :: Count
			public int Count() {
				return this.Alerts.Count;
			}
		//<-- End Method :: Count
		
		//##################################################################################
		
		//--> Begin Method :: Item
			public string Item(string Index) {
				return Item(Convert.ToInt32(Index));
			}
			public string Item(int Index) {
				return this.Alerts[Index];
			}
		//<-- End Method :: Item
		
		//##################################################################################
		
		//--> Begin Method :: ToJSON
			public string ToJSON() {
				string AlertJSON = "";
				AlertJSON += "{";
				
				//build the json
				for(int i = 0 ; i < this.Alerts.Count ; i++) {
					AlertJSON += "\""+ (i+1) +"\":\""+ this.Alerts[i].Replace("\"", "\\\"") +"\"";
					if(i+1 != this.Alerts.Count) {
						AlertJSON += ",";
					}
				}
				
				AlertJSON += "}";
				return AlertJSON;
			}
		//<-- End Method :: ToJSON
		
		//##################################################################################
		
		//--> Begin Method :: ToArray
			public string[] ToArray() {
				//how man items?
				string[] AlertArray = new string[Alerts.Count];
				
				//build the array
				for(int i = 0 ; i < this.Alerts.Count ; i++) {
					AlertArray[i] = this.Alerts[i];
				}
				
				//return the new array
				return AlertArray;
			}
		//<-- End Method :: ToArray
	}
//<-- End Class :: Alert

//##########################################################################################
</script>