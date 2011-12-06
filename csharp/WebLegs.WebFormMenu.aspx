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

//--> Begin Class :: WebFormMenu
	public class WebFormMenu {
		//--> Begin :: Properties
			public string Name;
			public int Size;
			public bool SelectMultiple;
			public List<string[]> Attributes;
			public StringCollection SelectedValues;
			public List<string[]> Options;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: WebFormMenu
			public WebFormMenu() {
				this.Name = "";
				this.Size = 1;
				this.SelectMultiple = false;
				this.Attributes = new List<string[]>();
				this.SelectedValues = new StringCollection();
				this.Options = new List<string[]>();
			}
			public WebFormMenu(string Name, int Size, bool SelectMultiple) {
				this.Name = Name;
				this.Size = Size;
				this.SelectMultiple = SelectMultiple;
				this.Attributes = new List<string[]>();
				this.SelectedValues = new StringCollection();
				this.Options = new List<string[]>();
			}
		//<-- End :: WebFormMenu
		
		//##################################################################################
		
		//--> Begin Method :: AddAttribute
			public void AddAttribute(string Name, string Value) {
				this.Attributes.Add(new string[]{Name, Value});
			}
		//<-- End Method :: AddAttribute
		
		//##################################################################################
		
		//--> Begin Method :: AddOption
			public void AddOption(string Label, string Value) {
				this.Options.Add(new string[]{Label, Value});
			}
			public void AddOption(string Label, string Value, string Custom) {
				this.Options.Add(new string[]{Label, Value, Custom});
			}
		//<-- End Method :: AddOption
		
		//##################################################################################
		
		//--> Begin Method :: AddOptionGroup
			public void AddOptionGroup(string Label) {
				this.Options.Add(new string[]{Label, "", "", "group"});
			}
			public void AddOptionGroup(string Label, string Custom) {
				this.Options.Add(new string[]{Label, "", Custom, "group"});
			}
		//<-- End Method :: AddOptionGroup
		
		//##################################################################################
		
		//--> Begin Method :: AddSelectedValue
			public void AddSelectedValue(string Value) {
				this.SelectedValues.Add(Value);
			}
		//<-- End Method :: AddSelectedValue
		
		//##################################################################################
		
		//--> Begin Method :: GetOptionTags
			public string GetOptionTags() {
				//main container
				string tmpOptionTags = "";
				
				//last group reference
				int? LastGroupReference = null;
				
				//build options
				for(int i = 0 ; i < this.Options.Count ; i++) {
					//check for groups
					if(this.Options[i].Length == 4) {
						//was there a group before this
						if(LastGroupReference == null) {
							LastGroupReference = i;
						}
						else {
							tmpOptionTags += "</optgroup>";
							LastGroupReference = i;
						}
						tmpOptionTags += "<optgroup label=\""+ Codec.HTMLEncode(this.Options[i][0]) + "\" "+ this.Options[i][2] +">";
					}
					//normal option
					else {
						tmpOptionTags += "<option value=\""+ Codec.HTMLEncode(this.Options[i][1]) +"\""+ (this.SelectedValues.Contains(this.Options[i][1]) ? " selected=\"selected\"" : "") + (this.Options[i].Length == 3 ? " "+ this.Options[i][2] : "") +">"+ Codec.HTMLEncode(this.Options[i][0]) +"</option>";
					}
					
					//should end a group
					if(LastGroupReference != null && ((i + 1) == this.Options.Count)) {
						tmpOptionTags += "</optgroup>";
					}
				}
				return tmpOptionTags;
			}
		//<-- End Method :: GetOptionTags
		
		//##################################################################################
		
		//--> Begin Method :: ToString
			public override string ToString() {
				string tmpDropDown = "";
				
				//start the beginning select tag
				tmpDropDown += "<select name=\""+ this.Name +"\" size=\""+ this.Size.ToString() +"\""+ (this.SelectMultiple ? " multiple=\"multiple\"" : "");
					
				//add any custom attributes
				for(int i = 0 ; i < this.Attributes.Count ; i++) {
					tmpDropDown += " "+ this.Attributes[i][0] +"=\""+ this.Attributes[i][1] +"\"";
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
</script>