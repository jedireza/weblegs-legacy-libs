<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%!
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
			public List<String> Alerts;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public Alert() {
				this.Alerts = new ArrayList<String>();
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Add
			public void Add(String Value) {
				this.Alerts.add(Value);
			}
		//<-- End Method :: Add
		
		//##################################################################################
		
		//--> Begin Method :: Count
			public int Count() {
				return this.Alerts.size();
			}
		//<-- End Method :: Count
		
		//##################################################################################
		
		//--> Begin Method :: Item
			public String Item(String Index) {
				return this.Item(Integer.valueOf(Index));
			}
			public String Item(int Index) {
				return String.valueOf(this.Alerts.get(Index));
			}
		//<-- End Method :: Item
		
		//##################################################################################
		
		//--> Begin Method :: ToJSON
			public String ToJSON() {
				String AlertJSON = "";
				AlertJSON += "{";
				
				//build the json
				for(int i = 0 ; i < this.Alerts.size(); i++) {
					AlertJSON += "\""+ (i+1) +"\":\""+ String.valueOf(this.Alerts.get(i)).replaceAll("\"", "\\\"") +"\"";
					if(i+1 != this.Alerts.size()) {
						AlertJSON += ",";
					}
				}
				
				AlertJSON += "}";
				return AlertJSON;
			}
		//<-- End Method :: ToJSON
		
		//##################################################################################
		
		//--> Begin Method :: ToArray
			public String[] ToArray() {
				//how man items?
				String[] AlertArray = new String[Alerts.size()];
				
				//build the array
				for(int i = 0 ; i < this.Alerts.size() ; i++) {
					AlertArray[i] = String.valueOf(this.Alerts.get(i));
				}
				
				//return the new array
				return AlertArray;
			}
		//<-- End Method :: ToArray
	}
//<-- End Class :: Alert

//##########################################################################################
%>