#!/usr/bin/perl
use strict;
############################################################################################

#/*
#Copyright (C) 2005-2010 WebLegs, Inc.
#This program is free software: you can redistribute it and/or modify it under the terms
#of the GNU General Public License as published by the Free Software Foundation, either
#version 3 of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
#without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#See the GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License along with this program.
#If not, see <http://www.gnu.org/licenses/>.
#*/

############################################################################################

##--> Begin Class :: WebForm
	{package WebForm;
		##--> Begin :: Constructor
			#no constructor
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: RadioButton
			sub RadioButton($$$$;$) {
				my ($Name, $Value, $Checked, $Disabled, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				return "<input type=\"radio\" name=\"". $Name ."\" value=\"". Codec::HTMLEncode($Value) ."\" ". ($Checked == 1 ? " checked=\"checked\" " : "") ." ". ($Disabled == 1 ? " disabled=\"disabled\" " : "") ." ". $Custom ."/>";
			}
		##<-- End Method :: RadioButton
		
		####################################################################################
		
		##--> Begin Method :: CheckBox
			sub CheckBox($$$$;$) {
				my ($Name, $Value, $Checked, $Disabled, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				return "<input type=\"checkbox\" name=\"". $Name ."\" value=\"". Codec::HTMLEncode($Value) ."\" ". ($Checked == 1 ? " checked=\"checked\" " : "") ." ". ($Disabled == 1 ? " disabled=\"disabled\" " : "") ." ". $Custom ."/>";
			}
		##<-- End Method :: CheckBox
		
		####################################################################################
		
		##--> Begin Method :: HiddenField
			sub HiddenField($$;$) {
				my ($Name, $Value, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				return "<input type=\"hidden\" name=\"". $Name ."\" value=\"". Codec::HTMLEncode($Value) ."\" ". $Custom ."/>";
			}
		##<-- End Method :: HiddenField
		
		####################################################################################
		
		##--> Begin Method :: TextBox
			sub TextBox($$$$$;$) {
				my ($Name, $Value, $Size, $MaxLength, $Disabled, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				return "<input type=\"text\" name=\"". $Name ."\" value=\"". Codec::HTMLEncode($Value) ."\" size=\"". $Size ."\" maxlength=\"". $MaxLength ."\" ". ($Disabled == 1 ? "disabled=\"disabled\" " : "") ." ". $Custom ."/>";
			}
		##<-- End Method :: TextBox
		
		####################################################################################
		
		##--> Begin Method :: PasswordBox
			sub PasswordBox($$$$$;$) {
				my ($Name, $Value, $Size, $MaxLength, $Disabled, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				return "<input type=\"password\" name=\"". $Name ."\" value=\"". Codec::HTMLEncode($Value) ."\" size=\"". $Size ."\" maxlength=\"". $MaxLength ."\" ". ($Disabled == 1 ? "disabled=\"disabled\" " : "") ." ". $Custom ."/>";
			}
		##<-- End Method :: PasswordBox
		
		####################################################################################
		
		##--> Begin Method :: TextArea
			sub TextArea($$$$$;$) {
				my ($Name, $Value, $NumCols, $NumRows, $Disabled, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				return "<textarea name=\"". $Name ."\" cols=\"". $NumCols ."\" rows=\"". $NumRows ."\" ". ($Disabled == 1 ? " disabled=\"disabled\" " : "") ." ". $Custom .">". Codec::HTMLEncode($Value) ."</textarea>";
			}
		##<-- End Method :: TextArea
		
		####################################################################################
		
		##--> Begin Method :: FileField
			sub FileField($$$;$) {
				my ($Name, $Size, $Disabled, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				return "<input type=\"file\" name=\"". $Name ."\" size=\"". $Size ."\" ". ($Disabled == 1 ? " disabled=\"disabled\" " : "") . ($Custom ne "" ? $Custom : "") ." />";
			}
		##<-- End Method :: FileField
		
		####################################################################################
		
		##--> Begin Method :: Button
			sub Button($$$;$) {
				my ($Name, $Value, $Disabled, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				return "<input type=\"button\" name=\"". $Name ."\" value=\"". Codec::HTMLEncode($Value) ."\" ". ($Disabled == 1 ? "disabled=\"disabled\" " : "") ." ". $Custom ."/>";
			}
		##<-- End Method :: Button
		
		####################################################################################
		
		##--> Begin Method :: SubmitButton
			sub SubmitButton($$$;$) {
				my ($Name, $Value, $Disabled, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				return "<input type=\"submit\" name=\"". $Name ."\" value=\"". Codec::HTMLEncode($Value) ."\" ". ($Disabled == 1 ? "disabled=\"disabled\" " : "") ." ". $Custom ."/>";
			}
		##<-- End Method :: SubmitButton
		
		####################################################################################
		
		##--> Begin Method :: ResetButton
			sub ResetButton($$$;$) {
				my ($Name, $Value, $Disabled, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				return "<input type=\"reset\" name=\"". $Name ."\" value=\"". Codec::HTMLEncode($Value) ."\" ". ($Disabled == 1 ? "disabled=\"disabled\" " : "") ." ". $Custom ."/>";
			}
		##<-- End Method :: ResetButton
		
		####################################################################################
		
		##--> Begin Method :: DropDown
			sub DropDown($$$$$$;$) {
				my ($Name, $CurrentValue, $Size, $Options, $Values, $Disabled, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				
				my $mydd = "";
				$mydd .= "<select name=\"". $Name ."\" size=\"". $Size ."\" ". ($Disabled == 1 ? " disabled=\"disabled\" " : "") ." ". $Custom .">";
					#check for options
					if(length($Values) == 0) {
						$Values = $Options;
					}
					
					#explode strings into arrays (split)
					my @option_array = split(/\|/, $Options);
					my @value_array = split(/\|/, $Values);
					
					#count array items
					my $option_count = scalar(@option_array);
					my $value_count = scalar(@value_array);
					
					#check if option/vlaue count match
					if($option_count != $value_count) {
						die("WebLegs.WebForm.DropDown(): Option count is different than value count.");
					}
					else {
						#loop through arrays and build options
						for(my $i = 0 ; $i < $option_count ; $i++) {
							$mydd .= "<option value=\"". Codec::HTMLEncode($value_array[$i]) ."\" ". ($value_array[$i] eq $CurrentValue ? " selected=\"selected\" " : "") .">". Codec::HTMLEncode($option_array[$i]) ."</option>";
						}
					}
				$mydd .= "</select>";
				return $mydd;
			}
		##<-- End Method :: DropDown
	}
##<-- End Class :: WebForm

############################################################################################
1;