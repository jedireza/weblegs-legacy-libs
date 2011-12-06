<%@ page import="java.util.*" %>
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

//--> Begin Class :: WebFormMenu
	public class WebFormMenu {
		//--> Begin :: Properties
			public String Name;
			public int Size;
			public boolean SelectMultiple;
			public ArrayList<String[]> Attributes;
			public ArrayList<String> SelectedValues;
			public ArrayList<String[]> Options;
			public ArrayList<String[]> OptionGroups;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: WebFormMenu
			public WebFormMenu() {
				this.Name = "";
				this.Size = 1;
				this.SelectMultiple = false;
				this.Attributes = new ArrayList<String[]>();
				this.SelectedValues = new ArrayList<String>();
				this.Options = new ArrayList<String[]>();
				this.OptionGroups = new ArrayList<String[]>();
			}
			public WebFormMenu(String Name, int Size, boolean SelectMultiple) {
				this.Name = Name;
				this.Size = Size;
				this.SelectMultiple = SelectMultiple;
				this.Attributes = new ArrayList<String[]>();
				this.SelectedValues = new ArrayList<String>();
				this.Options = new ArrayList<String[]>();
				this.OptionGroups = new ArrayList<String[]>();
			}
		//<-- End :: WebFormMenu
		
		//##################################################################################
		
		//--> Begin Method :: AddAttribute
			public void AddAttribute(String Name, String Value) {
				this.Attributes.add(new String[]{Name, Value});
			}
		//<-- End Method :: AddAttribute
		
		//##################################################################################
		
		//--> Begin Method :: AddOption
			public void AddOption(String Label, String Value) {
				this.Options.add(new String[]{Label, Value});
			}
			public void AddOption(String Label, String Value, String Custom) {
				this.Options.add(new String[]{Label, Value, Custom});
			}
			public void AddOption(String Label, String Value, String Custom, String GroupFlag) {
				this.Options.add(new String[]{Label, Value, Custom, GroupFlag});
			}
		//<-- End Method :: AddOption
		
		//##################################################################################
		
		//--> Begin Method :: AddOptionGroup
			public void AddOptionGroup(String Label) {
				this.Options.add(new String[]{Label, "", "", "group"});
			}
			public void AddOptionGroup(String Label, String Custom) {
				this.Options.add(new String[]{Label, "", Custom, "group"});
			}
		//<-- End Method :: AddOptionGroup
		
		//##################################################################################
		
		//--> Begin Method :: AddSelectedValue
			public void AddSelectedValue(String Value) {
				this.SelectedValues.add(Value);
			}
		//<-- End Method :: AddSelectedValue
		
		//##################################################################################
		
		//--> Begin Method :: GetOptionTags
			public String GetOptionTags() {
				//main container
				String tmpOptionTags = "";
				
				//last group reference
				int LastGroupReference = -1;
				
				//build options
				for(int i = 0 ; i < this.Options.size() ; i++) {
					//check for groups
					if(this.Options.get(i).length == 4) {
						//was there a group before this
						if(LastGroupReference == -1) {
							LastGroupReference = i;
						}
						else {
							tmpOptionTags += "</optgroup>";
							LastGroupReference = i;
						}
						tmpOptionTags += "<optgroup label=\""+ Codec.HTMLEncode(this.Options.get(i)[0]) + "\" "+ Codec.HTMLEncode(this.Options.get(i)[2]) +">";
					}
					//normal option
					else {
						tmpOptionTags += "<option value=\""+ Codec.HTMLEncode(this.Options.get(i)[1]) +"\""+ (this.SelectedValues.contains(this.Options.get(i)[1]) ? " selected=\"selected\"" : "") + (this.Options.get(i).length == 3 ? " "+ this.Options.get(i)[2] : "") +">"+ Codec.HTMLEncode(this.Options.get(i)[0]) +"</option>";
					}
					
					//should end a group
					if(LastGroupReference != -1 && ((i + 1) == this.Options.size())) {
						tmpOptionTags += "</optgroup>";
					}
				}
				return tmpOptionTags;
			}
		//<-- End Method :: GetOptionTags
		
		//##################################################################################
		
		//--> Begin Method :: ToString
			public String ToString() {
				String tmpDropDown = "";
				
				//start the beginning select tag
				tmpDropDown += "<select name=\""+ String.valueOf(this.Name) +"\" size=\""+ String.valueOf(this.Size) +"\""+ (this.SelectMultiple ? " multiple=\"multiple\"" : "");
					
				//add any custom attributes
				for(int i = 0 ; i < this.Attributes.size() ; i++) {
					tmpDropDown += " "+ this.Attributes.get(i)[0] +"=\""+ this.Attributes.get(i)[1] +"\"";
				}
				
				//finish the begining select tag
				tmpDropDown += ">";
				
				//add the options
				tmpDropDown += this.GetOptionTags();
				
				//finish building the select tag
				tmpDropDown += "</select>";
				
				return tmpDropDown;
			}
		//<-- End Method :: ToString
	}
//<-- End Class :: WebFormMenu

//##########################################################################################
%>