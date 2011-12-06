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
	WebLegs.WebForm = function() {
		//no constructor, no properties
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: RadioButton
	WebLegs.WebForm.RadioButton = function(Name, Value, Checked, Disabled, Custom) {
		return "<input type=\"radio\" name=\""+ Name +"\" value=\""+ WebLegs.Codec.HTMLEncode(Value) +"\" "+ (Checked == true ? " checked=\"checked\" " : "") +" "+ (Disabled == true ? " disabled=\"disabled\" " : "") +" "+ Custom +"/>";
	}
//<-- End Method :: RadioButton

//##########################################################################################

//--> Begin Method :: CheckBox
	WebLegs.WebForm.CheckBox = function(Name, Value, Checked, Disabled, Custom) {
		return "<input type=\"checkbox\" name=\""+ Name +"\" value=\""+ WebLegs.Codec.HTMLEncode(Value) +"\" "+ (Checked == true ? " checked=\"checked\" " : "") +" "+ (Disabled == true ? " disabled=\"disabled\" " : "") +" "+ Custom +"/>";
	}
//<-- End Method :: CheckBox

//##########################################################################################

//--> Begin Method :: HiddenField
	WebLegs.WebForm.HiddenField = function(Name, Value, Custom) {
		return "<input type=\"hidden\" name=\""+ Name +"\" value=\""+ WebLegs.Codec.HTMLEncode(Value) +"\" "+ Custom +"/>";
	}
//<-- End Method :: HiddenField

//##########################################################################################

//--> Begin Method :: TextBox
	WebLegs.WebForm.TextBox = function( Name, Value, Size, MaxLength, Disabled, Custom) {
		return "<input type=\"text\" name=\""+ Name +"\" value=\""+ WebLegs.Codec.HTMLEncode(Value) +"\" size=\""+ Size +"\" maxlength=\""+ MaxLength +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") +" "+ Custom +"/>";
	}
//<-- End Method :: TextBox

//##########################################################################################

//--> Begin Method :: PasswordBox
	WebLegs.WebForm.PasswordBox = function(Name, Value, Size, MaxLength, Disabled, Custom) {
		return "<input type=\"password\" name=\""+ Name +"\" value=\""+ WebLegs.Codec.HTMLEncode(Value) +"\" size=\""+ Size +"\" maxlength=\"" + MaxLength +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") +" "+ Custom +"/>";
	}
//<-- End Method :: PasswordBox

//##########################################################################################

//--> Begin Method :: TextArea
	WebLegs.WebForm.TextArea = function(Name, Value, NumCols, NumRows, Disabled, Custom) {
		return "<textarea name=\""+ Name +"\" cols=\""+ NumCols +"\" rows=\""+ NumRows +"\" "+ (Disabled == true ? " disabled=\"disabled\" " : "") +" "+ Custom +">"+ WebLegs.Codec.HTMLEncode(Value) +"</textarea>";
	}
//<-- End Method :: TextArea

//##########################################################################################

//--> Begin Method :: FileField
	WebLegs.WebForm.FileField = function(Name, Size, Disabled, Custom) {
		return "<input type=\"file\" name=\""+ Name +"\" size=\""+ Size +"\" "+ (Disabled == true ? " disabled=\"disabled\" " : "") + (Custom != "" ? Custom : "") +" />";
	}
//<-- End Method :: FileField

//##########################################################################################

//--> Begin Method :: Button
	WebLegs.WebForm.Button = function(Name, Value, Disabled, Custom) {
		return "<input type=\"button\" name=\""+ Name +"\" value=\""+ WebLegs.Codec.HTMLEncode(Value) +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") +" "+ Custom +"/>";
	}
//<-- End Method :: Button

//##########################################################################################

//--> Begin Method :: SubmitButton
	WebLegs.WebForm.SubmitButton = function( Name, Value, Disabled, Custom) {
		return "<input type=\"submit\" name=\""+ Name +"\" value=\""+ WebLegs.Codec.HTMLEncode(Value) +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") +" "+ Custom +"/>";
	}
//<-- End Method :: SubmitButton

//##########################################################################################

//--> Begin Method :: ResetButton
	WebLegs.WebForm.ResetButton = function(Name, Value, Disabled, Custom) {
		return "<input type=\"reset\" name=\""+ Name +"\" value=\""+ WebLegs.Codec.HTMLEncode(Value) +"\" "+ (Disabled == true ? "disabled=\"disabled\" " : "") +" "+ Custom +"/>";
	}
//<-- End Method :: ResetButton

//##########################################################################################

//--> Begin Method :: DropDown
	WebLegs.WebForm.DropDown = function(Name, CurrentValue, Size, Options, Values, Disabled, Custom) {
		var mydd = "";
		mydd += "<select name=\""+ Name +"\" size=\""+ Size +"\" "+ (Disabled == true ? " disabled=\"disabled\" " : "") +" "+ Custom +">";
			//check for options
			if(Values.length == 0) {
				Values = Options;
			}
			//explode strings into arrays (split)
			var option_array = Options.split("|");
			var value_array = Values.split("|");
	
			//count array items
			var option_count = option_array.length;
			var value_count = value_array.length;
			
			//check if option/vlaue count match
			if(option_count != value_count) {
				throw("WebLegs.WebForm.DropDown(): Option count is different than value count.");
			}
			else {
				//loop through arrays and build options
				for(var i = 0 ; i < option_count ; i++) {
					mydd += "<option value=\""+ WebLegs.Codec.HTMLEncode(value_array[i]) +"\" "+ (value_array[i] == CurrentValue ? " selected=\"selected\" " : "") +">"+ WebLegs.Codec.HTMLEncode(option_array[i]) +"</option>";
				}
			}
		mydd += "</select>";
		return mydd;
	}
//<-- End Method :: DropDown

//##########################################################################################