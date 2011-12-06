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

##--> Begin Class :: Alert
	{package Alert;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $this = {
					"Alerts" => undef
				};
				bless($this, ref($class) || $class);
				
				#initialize
				$this->{Alerts} = [];
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: Add
			sub Add() {
				my $this = shift;
				my $Value = shift;
				
				#set alert
				push(@{$this->{Alerts}}, $Value);
			}
		##<-- End Method :: Add
		
		####################################################################################
		
		##--> Begin Method :: Count
			sub Count() {
				my $this = shift;
				
				#return current count
				return scalar(@{$this->{Alerts}});
			}
		##<-- End Method :: Count
		
		####################################################################################
		
		##--> Begin Method :: Item
			sub Item() {
				my $this = shift;
				my $Index = shift;
				
				#get alert
				return @{$this->{Alerts}}[$Index];
			}
		##<-- End Method :: Item
		
		####################################################################################
		
		##--> Begin Method :: ToJSON
			sub ToJSON() {
				my $this = shift;
				
				my $AlertJSON = "";
				$AlertJSON .= "{";
				
				#build the json
				for(my $i = 0 ; $i < scalar(@{$this->{Alerts}}) ; $i++) {
					my $tmpValue = @{$this->{Alerts}}[$i];
					$tmpValue =~ s/"/""/g;
					
					$AlertJSON .= "\"". ($i+1) ."\":\"". $tmpValue ."\"";
					
					if($i + 1 != scalar(@{$this->{Alerts}})) {
						$AlertJSON .= ",";
					}
				}
				
				$AlertJSON .= "}";
				return $AlertJSON;
			}
		##<-- End Method :: ToJSON
		
		####################################################################################
		
		##--> Begin Method :: ToArray
			sub ToArray() {
				my $this = shift;
				
				#return array
				return @{$this->{Alerts}};
			}
		##<-- End Method :: ToArray
	}
##<-- End Class :: Alert

############################################################################################
1;