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

##--> Begin Class :: WebRequestFile
	{package WebRequestFile;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $this = {
					"FormName" => undef,
					"FileName" => undef,
					"ContentType" => undef,
					"ContentLength" => undef,
					"FileData" => undef
				};
				bless($this, ref($class) || $class);
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: SaveAs
			sub SaveAs() {
				my $this = shift;
				my $FilePath = shift;
				
				open(FILEHANDLE,">$FilePath") or die $!;
				binmode(FILEHANDLE);
				print FILEHANDLE $this->{FileData};
				close(FILEHANDLE);
			}
		##<-- End Method :: SaveAs
	}
##<-- End Class :: WebRequestFile

############################################################################################
1;