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

##--> Begin Class :: WebFormMenu
	{package WebFormMenu;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $Name = shift;
				my $Size = shift;
				my $SelectMultiple = shift;
				
				my $this = {
					"Name" => $Name,
					"Size" => $Size,
					"SelectMultiple" => $SelectMultiple,
					"Attributes" => undef,
					"SelectedValues" => undef,
					"Options" => undef
				};
				bless($this, ref($class) || $class);
				
				#initialize
				$this->{SelectedValues} = [];
				$this->{Options} = [];
				
				#construct
				$this->{Attributes} = ();
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: AddAttribute
			sub AddAttribute() {
				my $this = shift;
				my ($Name, $Value) = @_;
				$this->{Attributes}{$Name} = $Value;
			}
		##<-- End Method :: AddAttribute
		
		####################################################################################
		
		##--> Begin Method :: AddOption
			sub AddOption() {
				my $this = shift;
				my ($Label, $Value, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				push(@{$this->{Options}}, {label => $Label, value => $Value, custom => $Custom});
			}
		##<-- End Method :: AddOption
		
		####################################################################################
		
		##--> Begin Method :: AddOptionGroup
			sub AddOptionGroup() {
				my $this = shift;
				my ($Label, $Custom) = @_;
				if(!defined($Custom)) {
					$Custom = "";
				}
				push(@{$this->{Options}}, {label => $Label, value => "", custom => $Custom, group => "group"});
			}
		##<-- End Method :: AddOptionGroup
		
		####################################################################################
		
		##--> Begin Method :: AddSelectedValue
			sub AddSelectedValue() {
				my $this = shift;
				my ($Value) = @_;
				push(@{$this->{SelectedValues}}, $Value);
			}
		##<-- End Method :: AddSelectedValue
		
		####################################################################################
		
		##--> Begin Method :: GetOptionTags
			sub GetOptionTags() {
				my $this = shift;
				
				#main container
				my $tmpOptionTags = "";
				
				#last group reference
				my $LastGroupReference = undef;
				
				#build options
				for(my $i = 0 ; $i < scalar(@{$this->{Options}}) ; $i++) {
					#check for groups
					if(scalar(keys(%{$this->{Options}->[$i]})) == 4) {
						#was there a group before this
						if(!defined($LastGroupReference)) {
							$LastGroupReference = $i;
						}
						else {
							$tmpOptionTags .= "</optgroup>";
							$LastGroupReference = $i;
						}
						
						$tmpOptionTags .= "<optgroup label=\"". Codec::HTMLEncode($this->{Options}->[$i]->{"label"}) ."\" ". $this->{Options}->[$i]->{"custom"} .">";
					}
					#normal option
					else {
						my $Label = $this->{Options}->[$i]->{"label"};
						my $Value = $this->{Options}->[$i]->{"value"};
						my $Custom = $this->{Options}[$i]->{"custom"};
						
						#add value
						$tmpOptionTags .= "<option value=\"". Codec::HTMLEncode($Value) ."\""; 
						
						#is selected
						for my $SelectedValue (@{$this->{SelectedValues}}) {
							if($Value eq $SelectedValue) {
								$tmpOptionTags .= " selected=\"selected\" ";
							}
						}

						#add custom
						if($Custom ne "") {
							$Custom = " ". $Custom;
						}
						$tmpOptionTags .= $Custom;
						
						#add label
						$tmpOptionTags .= ">". Codec::HTMLEncode($Label) ."</option>";
					}
					
					#should end a group
					if(defined($LastGroupReference) && (($i + 1) == scalar(@{$this->{Options}}))) {
						$tmpOptionTags .= "</optgroup>";
					}
				}
				return $tmpOptionTags;
			}
		##<-- End Method :: GetOptionTags
		
		####################################################################################
		
		##--> Begin Method :: ToString
			sub ToString() {
				my $this = shift;
				
				#main container
				my $tmpDropDown = "";
				
				#start the beginning select tag
				$tmpDropDown .= "<select name=\"". $this->{Name} ."\" size=\"". $this->{Size} ."\"". ($this->{SelectMultiple} == 1 ? " multiple=\"multiple\"" : "");
		
				#add any custom attributes
				for my $Key (keys %{$this->{Attributes}}) {
					$tmpDropDown .= " ". $Key ."=\"". $this->{Attributes}->{$Key} ."\"";
				}
				
				#finish the begining select tag
				$tmpDropDown .= ">";
				
				#add the options
				$tmpDropDown .= $this->GetOptionTags();
				
				#finish building the select tag
				$tmpDropDown .= "</select>";
				
				return $tmpDropDown;
			}
		##<-- End Method :: ToString
	}
##<-- End Class :: WebFormMenu

############################################################################################
1;