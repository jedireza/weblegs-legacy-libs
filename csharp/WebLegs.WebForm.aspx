<%@ Import Namespace="System" %>
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

//--> Begin Class :: WebForm
	public static class WebForm {
		//--> Begin :: Properties
			//no properties
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			//no constructor
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: RadioButton
			public static string RadioButton(string Name, string Value, bool Checked, bool Disabled, string Custom) {
				return "<input type=\"radio\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value) +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (Checked == true ? "checked=\"checked\" " : "") + (Custom != "" ? Custom : "") +" />";
			}
		//<-- End Method :: RadioButton
		
		//##################################################################################
		
		//--> Begin Method :: CheckBox
			public static string CheckBox(string Name, string Value, bool Checked, bool Disabled, string Custom) {
				return "<input type=\"checkbox\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value) +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (Checked == true ? "checked=\"checked\" " : "") + (Custom != "" ? Custom : "") +" />";
			}
		//<-- End Method :: CheckBox
		
		//##################################################################################
		
		//--> Begin Method :: HiddenField
			public static string HiddenField(string Name, string Value) {
				return "<input type=\"hidden\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value) +"\" />";
			}
			public static string HiddenField(string Name, string Value, string Custom) {
				return "<input type=\"hidden\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value) +"\" "+ (Custom != "" ? Custom : "") +" />";
			}
		//<-- End Method :: HiddenField
		
		//##################################################################################
		
		//--> Begin Method :: TextBox
			public static string TextBox(string Name, string Value, int Size, int MaxLength, bool Disabled, string Custom) {
				return "<input type=\"text\" name=\""+ Name +"\" size=\""+ Size +"\" maxlength=\""+ MaxLength +"\" value=\""+ Codec.HTMLEncode(Value) +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (Custom != "" ? Custom : "") +" />";
			}
		//<-- End Method :: TextBox
		
		//##################################################################################
		
		//--> Begin Method :: PasswordBox
			public static string PasswordBox(string Name, string Value, int Size, int MaxLength, bool Disabled, string Custom) {
				return "<input type=\"password\" name=\""+ Name +"\" size=\""+ Size +"\" maxlength=\""+ MaxLength +"\" value=\""+ Codec.HTMLEncode(Value) +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (Custom != "" ? Custom : "") +" />";
			}
		//<-- End Method :: PasswordBox
		
		//##################################################################################
		
		//--> Begin Method :: TextArea
			public static string TextArea(string Name, string Value, int NumCols, int NumRows, bool Disabled, string Custom) {
				return "<textarea name=\""+ Name +"\" cols=\""+ NumCols +"\" rows=\""+ NumRows +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (Custom != "" ? Custom : "") +">"+ Codec.HTMLEncode(Value) +"</textarea>";
			}
		//<-- End Method :: TextArea
		
		//##################################################################################
		
		//--> Begin Method :: FileField
			public static string FileField(string Name, int Size, bool Disabled, string Custom) {
				return "<input type=\"file\" name=\""+ Name +"\" size=\""+ Size +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (Custom != "" ? Custom : "") +" />";
			}
		//<-- End Method :: FileField
		
		//##################################################################################
		
		//--> Begin Method :: Button
			public static string Button(string Name, string Value, bool Disabled, string Custom) {
				return "<input type=\"button\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value) +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (Custom != "" ? Custom : "") +" />";
			}
		//<-- End Method :: Button
		
		//##################################################################################
		
		//--> Begin Method :: SubmitButton
			public static string SubmitButton(string Name, string Value, bool Disabled, string Custom) {
				return "<input type=\"submit\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value) +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (Custom != "" ? Custom : "") +" />";
			}
		//<-- End Method :: SubmitButton
		
		//##################################################################################
		
		//--> Begin Method :: ResetButton
			public static string ResetButton(string Name, string Value, bool Disabled, string Custom) {
				return "<input type=\"reset\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value) +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (Custom != "" ? Custom : "") +" />";
			}
		//<-- End Method :: ResetButton
		
		//##################################################################################
		
		//--> Begin Method :: DropDown
			public static string DropDown(string Name, string CurrentValue, int Size, string Options, string Values, bool Disabled, string Custom) {
				//dd collection string
				string tmpDropDown = "";
		
				//check if values should be the same as options
				if(Values == "") {
					Values = Options;
				}
				
				//break-out arrays
				string[] OptionsArray = Options.Split('|');
				string[] ValuesArray = Values.Split('|');
				
				//check if options/values are the same length
				if(OptionsArray.Length != ValuesArray.Length) {
					//options and values didn't match
					throw new Exception("WebLegs.WebForm.DropDown(): Option count is different than value count.");
				} 
				else {
					//build drop down
					tmpDropDown = "<select name=\""+ Name +"\" size=\""+ Size +"\" "+ (Disabled == true ? "disabled=\"true\"" : "") +" "+ (Custom != "" ? Custom : "") +">";
					for(int i = 0 ; i < OptionsArray.Length ; i++) {
						if(CurrentValue == ValuesArray[i]) {
							tmpDropDown += "<option value=\""+ Codec.HTMLEncode(ValuesArray[i]) +"\" selected=\"selected\">"+ Codec.HTMLEncode(OptionsArray[i]) +"</option>";
						}
						else {
							tmpDropDown += "<option value=\""+ Codec.HTMLEncode(ValuesArray[i]) +"\">"+ Codec.HTMLEncode(OptionsArray[i]) +"</option>";
						}
					}
					tmpDropDown += "</select>";
				}
				return tmpDropDown;
			}
		//<-- End Method :: DropDown
	}
//<-- End Class :: WebForm

//##########################################################################################
</script>