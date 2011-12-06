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
	WebLegs.WebFormMenu = function(Name, Size, SelectMultiple) {
		this.Name = Name;
		this.Size = Size;
		this.SelectMultiple = SelectMultiple;
		this.Attributes = new Array();
		this.SelectedValues = new Array();
		this.Options = new Array();
	}
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: AddAttribute
	WebLegs.WebFormMenu.prototype.AddAttribute = function(Name, Value) {
		var Attribute = new Object();
		Attribute["name"] = Name;
		Attribute["value"] = Value;
		this.Attributes.push(Attribute);
	}
//<-- End Method :: AddAttribute

//##########################################################################################

//--> Begin Method :: AddOption
	WebLegs.WebFormMenu.prototype.AddOption = function(Label, Value, Custom) {
		var Option = new Object();
		Option["label"] = Label;
		Option["value"] = Value;
		Option["custom"] = (Custom == undefined ? "" : Custom);
		Option["groupflag"] = false;
		this.Options.push(Option);
	}
//<-- End Method :: AddOption
		
//##################################################################################

//--> Begin Method :: AddOptionGroup
	WebLegs.WebFormMenu.prototype.AddOptionGroup = function(Label, Custom) {
		var OptionGroup = new Object();
		OptionGroup["label"] = Label;
		OptionGroup["value"] = "";
		OptionGroup["custom"] = (Custom == undefined ? "" : Custom);
		OptionGroup["groupflag"] = true;
		this.Options.push(OptionGroup);
	}
//<-- End Method :: AddOptionGroup

//##########################################################################################

//--> Begin Method :: AddSelectedValue
	WebLegs.WebFormMenu.prototype.AddSelectedValue = function(Value) {
		this.SelectedValues.push(Value);
	}
//<-- End Method :: AddSelectedValue

//##################################################################################

//--> Begin Method :: GetOptionTags
	WebLegs.WebFormMenu.prototype.GetOptionTags = function() {
		//main container
		var tmpOptionTags = "";
		
		//last group reference
		var LastGroupReference = null;
		
		//build options
		for(i = 0 ; i < this.Options.length ; i++) {
			//check for groups
			if(this.Options[i]["groupflag"] == true) {
				//was there a group before this
				if(LastGroupReference == null) {
					LastGroupReference = i;
				}
				else {
					tmpOptionTags += "</optgroup>";
					LastGroupReference = i;
				}
				tmpOptionTags += "<optgroup label=\""+ WebLegs.Codec.HTMLEncode(this.Options[i]["label"]) + "\" "+ this.Options[i]["custom"] +">";
			}
			//normal option
			else {
				var IsSelected = false;
				for(j = 0 ; j < this.SelectedValues.length; j++) {
					if(this.SelectedValues[j] == this.Options[i]["value"]){
						IsSelected = true;
						break;
					}
				}
				tmpOptionTags += "<option value=\""+ WebLegs.Codec.HTMLEncode(this.Options[i]["value"]) +"\""+ (IsSelected == true ? " selected=\"selected\"" : "") +" "+ this.Options[i]["custom"] +">"+ WebLegs.Codec.HTMLEncode(this.Options[i]["label"]) +"</option>";
			}
			
			//should end a group
			if(LastGroupReference != null && ((i + 1) == this.Options.length)) {
				tmpOptionTags += "</optgroup>";
			}
		}
		return tmpOptionTags;
	}
//<-- End Method :: GetOptionTags

//##########################################################################################

//--> Begin Method :: ToString
	WebLegs.WebFormMenu.prototype.ToString = function() {
		tmpDropDown = "";
		
		//start the beginning select tag
		tmpDropDown += "<select name=\""+ this.Name +"\" size=\""+ this.Size +"\" "+ (this.SelectMultiple ? "multiple=\"multiple\"" : "");

		//add any custom attributes
		for(i = 0 ; i < this.Attributes.length ; i++) {
			tmpDropDown += " "+ this.Attributes[i]["name"] +"=\""+ this.Attributes[i]["value"] +"\"";
		}
		
		//finish the begining select tag
		tmpDropDown += ">";
		
		//add the options
		tmpDropDown += this.GetOptionTags();
		
		//finish building the select tag
		tmpDropDown += "</select>";
		
		return tmpDropDown;
		
		//finish building the select tag
		tmpDropDown += "</select>";
		
		return tmpDropDown;
	}
//<-- End Method :: ToString

//##########################################################################################