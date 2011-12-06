<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.Exception.*" %>
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
			static String RadioButton(String Name, String Value, boolean Checked, boolean Disabled, String Custom) {
				return "<input type=\"radio\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value).replace("\"", "&#34;") +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (Checked == true ? "checked=\"checked\" " : "") + (!Custom.equals("") ? Custom : "") +" />";
			}
		//<-- End Method :: RadioButton
		
		//##################################################################################
		
		//--> Begin Method :: CheckBox
			static String CheckBox(String Name, String Value, boolean Checked, boolean Disabled, String Custom) {
				return "<input type=\"checkbox\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value).replace("\"", "&#34;") +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (Checked == true ? "checked=\"checked\" " : "") + (!Custom.equals("") ? Custom : "") +" />";
			}
		//<-- End Method :: CheckBox
		
		//##################################################################################
		
		//--> Begin Method :: HiddenField
			static String HiddenField(String Name, String Value) {
				return "<input type=\"hidden\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value).replace("\"", "&#34;") +"\" />";
			}
			static String HiddenField(String Name, String Value, String Custom) {
				return "<input type=\"hidden\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value).replace("\"", "&#34;") +"\" "+ (!Custom.equals("") ? Custom : "") +" />";
			}
		//<-- End Method :: HiddenField
		
		//##################################################################################
		
		//--> Begin Method :: TextBox
			static String TextBox(String Name, String Value, int Size, int MaxLength, boolean Disabled, String Custom) {
				return "<input type=\"text\" name=\""+ Name +"\" size=\""+ Size +"\" maxlength=\""+ MaxLength +"\" value=\""+ Codec.HTMLEncode(Value).replace("\"", "&#34;") +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (!Custom.equals("") ? Custom : "") +" />";
			}
		//<-- End Method :: TextBox
		
		//##################################################################################
		
		//--> Begin Method :: PasswordBox
			static String PasswordBox(String Name, String Value, int Size, int MaxLength, boolean Disabled, String Custom) {
				return "<input type=\"password\" name=\""+ Name +"\" size=\""+ Size +"\" maxlength=\""+ MaxLength +"\" value=\""+ Codec.HTMLEncode(Value).replace("\"", "&#34;") +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (!Custom.equals("") ? Custom : "") +" />";
			}
		//<-- End Method :: PasswordBox
		
		//##################################################################################
		
		//--> Begin Method :: TextArea
			static String TextArea(String Name, String Value, int NumCols, int NumRows, boolean Disabled, String Custom) {
				return "<textarea name=\""+ Name +"\" cols=\""+ NumCols +"\" rows=\""+ NumRows +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (!Custom.equals("") ? Custom : "") +">"+ Value +"</textarea>";
			}
		//<-- End Method :: TextArea
		
		//##################################################################################
		
		//--> Begin Method :: FileField
			static String FileField(String Name, int Size, boolean Disabled, String Custom) {
				return "<input type=\"file\" name=\""+ Name +"\" size=\""+ Size +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (!Custom.equals("") ? Custom : "") +" />";
			}
		//<-- End Method :: FileField
		
		//##################################################################################
		
		//--> Begin Method :: Button
			static String Button(String Name, String Value, boolean Disabled, String Custom) {
				return "<input type=\"button\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value).replace("\"", "&#34;") +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (!Custom.equals("") ? Custom : "") +" />";
			}
		//<-- End Method :: Button
		
		//##################################################################################
		
		//--> Begin Method :: SubmitButton
			static String SubmitButton(String Name, String Value, boolean Disabled, String Custom) {
				return "<input type=\"submit\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value).replace("\"", "&#34;") +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (!Custom.equals("") ? Custom : "") +" />";
			}
		//<-- End Method :: SubmitButton
		
		//##################################################################################
		
		//--> Begin Method :: ResetButton
			static String ResetButton(String Name, String Value, boolean Disabled, String Custom) {
				return "<input type=\"reset\" name=\""+ Name +"\" value=\""+ Codec.HTMLEncode(Value).replace("\"", "&#34;") +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") + (!Custom.equals("") ? Custom : "") +" />";
			}
		//<-- End Method :: ResetButton
		
		//##################################################################################
		
		//--> Begin Method :: DropDown
			static String DropDown(String Name, String CurrentValue, int Size, String Options, String Values, boolean Disabled, String Custom) throws Exception {
				//dd collection String
				String tmpDropDown = "";
		
				//check if values should be the same as options
				if(Values.equals("")) {
					Values = Options;
				}
				
				//break-out arrays
				String[] OptionsArray = Options.split("[|]");
				String[] ValuesArray = Values.split("[|]");
				
				//check if options/values are the same length
				if(OptionsArray.length != ValuesArray.length) {
					//options and values didn't match
					throw new Exception("WebLegs.WebForm.DropDown(): Option count is different than value count.");
				} 
				else {
					//build drop down
					tmpDropDown = "<select name=\""+ Name +"\" size=\""+ Size +"\" "+ (Disabled == true ? "disabled=\"true\"" : "") +" "+ (!Custom.equals("") ? Custom : "") +">";
					for(int i = 0 ; i < OptionsArray.length ; i++) {
						if(CurrentValue.equals(ValuesArray[i])) {
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
%>