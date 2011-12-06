#!/usr/bin/perl
use strict;
use Date::Manip;
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

##--> Begin Class :: DataValidator
	{package DataValidator;
		##--> Begin :: Constructor
			#no constructor
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: IsValidEmail
			sub IsValidEmail($) {
				my $EmailAddress = shift;
				
				my $Match = 0;
				if($EmailAddress =~ m/^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/) {
					$Match = 1;
				}
				return $Match;
			}
		##<-- End Method :: IsValidEmail
		
		####################################################################################
		
		##--> Begin Method :: IsValidURL
			sub IsValidURL($) {
				my $URL = shift;
				
				my $Match = 0;
				if($URL =~ m/^s?https?:\/\/[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+$/) { #'this comment is for code coloring
					$Match = 1;
				}
				return $Match;
			}
		##<-- End Method :: IsValidURL
		
		####################################################################################
		
		##--> Begin Method :: IsPhone
			sub IsPhone($;$) {
				my $Phone = shift;
				my $CountryCode = shift;
				if(!defined($CountryCode)) {
					$CountryCode = "us";
				}
				
				my $Match = 0;
				if(lc($CountryCode) eq "us") {
					if($Phone =~ m/^([01][\s\.-]?)?(\(\d{3}\)|\d{3})[\s\.-]?\d{3}[\s\.-]?\d{4}$/) {
						$Match = 1;
					}
				}
				return $Match;
			}
		##<-- End Method :: IsPhone
		
		####################################################################################
		
		##--> Begin Method :: IsPostalCode
			sub IsPostalCode($;$) {
				my $PostalCode = shift;
				my $CountryCode = shift;
				if(!defined($CountryCode)) {
					$CountryCode = "us";
				}
				
				my $Match = 0;
				if(lc($CountryCode) eq "us") {
					if($PostalCode =~ m/^\d{5}(-?\d{4})?$/) {
						$Match = 1;
					}
				}
				return $Match;
			}
		##<-- End Method :: IsPostalCode
		
		####################################################################################
		
		##--> Begin Method :: IsAlpha
			sub IsAlpha($) {
				my $Input = shift;
				
				my $Match = 0;
				if($Input =~ m/^[a-zA-Z]+$/) {
					$Match = 1;
				}
				return $Match;
			}
		##<-- End Method :: IsAlpha
		
		####################################################################################
		
		##--> Begin Method :: IsIPv4
			sub IsIPv4($) {
				my $Input = shift;
				
				my $Match = 0;
				if($Input =~ m/^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/) {
					$Match = 1;
				}
				return $Match;
			}
		##<-- End Method :: IsIPv4
		
		####################################################################################
		
		##--> Begin Method :: IsInt
			sub IsInt($) {
				my $Input = shift;
				
				if($Input =~ /^-?\d+$/) {
					return 1;
				}
				else {
					return 0;
				}
			}
		##<-- End Method :: IsInt
		
		####################################################################################
		
		##--> Begin Method :: IsDouble
			sub IsDouble($) {
				my $Input = shift;
				
				my $Match = 0;
				if($Input =~ m/^-?(?:\d+(?:\.\d*)?|\.\d+)$/) {
					$Match = 1;
				}
				return $Match;
			}
		##<-- End Method :: IsDouble
		
		####################################################################################
		
		##--> Begin Method :: IsNumeric
			sub IsNumeric($) {
				my $Input = shift;
				
				if(DataValidator::IsInt($Input) || DataValidator::IsDouble($Input)) {
					return 1;
				}
				else {
					return 0;
				}
			}
		##<-- End Method :: IsNumeric
		
		####################################################################################
		
		##--> Begin Method :: IsDateTime
			sub IsDateTime($) {
				my $Input = shift;
				
				if(Date::Manip::ParseDate($Input)) {
					#return true
					return 1;
				}
				else {
					return 0;
				}
			}
		##<-- End Method :: IsDateTime
		
		####################################################################################
		
		##--> Begin Method :: MinLength
			sub MinLength($$) {
				my $Value = shift;
				my $Length = shift;
				
				if(length($Value) >= $Length){
					return 1;
				}
				else{
					return 0;
				}
			}
		##<-- End Method :: MinLength
		
		####################################################################################
		
		##--> Begin Method :: MaxLength
			sub MaxLength($$) {
				my $Value = shift;
				my $Length = shift;
				
				if(length($Value) <= $Length){
					return 1;
				}
				else{
					return 0;
				}
			}
		##<-- End Method :: MaxLength
		
		####################################################################################
		
		##--> Begin Method :: Length
			sub Length($$) {
				my $Value = shift;
				my $Length = shift;
				
				if(length($Value) == $Length){
					return 1;
				}
				else{
					return 0;
				}
			}
		##<-- End Method :: Length
	}
##<-- End Class :: DataValidator

############################################################################################
1;