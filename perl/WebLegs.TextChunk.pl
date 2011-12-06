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

##--> Begin Class :: TextChunk
	{package TextChunk;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $Source = shift;
				my $Start = shift;
				my $End = shift;
				
				my $this = {
					"Blank" => "",
					"Current" => "",
					"All" => ""
				};
				bless($this, ref($class) || $class);
				
				#overload new(Source, Start, End)
				if(defined($Source) && defined($Start) && defined($End)) {
					my $MyStart = 0;
					my $MyEnd = 0;
					
					if(index($Source, $Start) > -1 && rindex($Source, $End) > -1) {
						$MyStart = index($Source, $Start) + length($Start);
						$MyEnd = rindex($Source, $End);
						if(substr($Source, $MyStart, $MyEnd - $MyStart)) {
							$this->{Blank} = substr($Source, $MyStart, $MyEnd - $MyStart);
						}
						else {
							die("WebLegs.TextChunk.Constructor(): Boundry string mismatch.");
						}
					}
					else {
						die("WebLegs.TextChunk.Constructor(): Boundry strings not present in source string.");
					}
				}
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: Begin
			sub Begin() {
				my $this = shift;
				
				$this->{Current} = $this->{Blank};
			}
		##<-- End Method :: Begin
		
		####################################################################################
		
		##--> Begin Method :: End
			sub End() {
				my $this = shift;
				#concatenate current with all
				$this->{All} .= $this->{Current};
			}
		##<-- End Method :: End
		
		####################################################################################
		
		##--> Begin Method :: Replace
			sub Replace() {
				my $this = shift;
				my $This = shift;
				my $WithThis = shift;
				
				$this->{Current} =~ s/\Q$This/$WithThis/g;
				return $this;
			}
		##<-- End Method :: Replace
		
		####################################################################################
		
		##--> Begin Method :: ToString
			sub ToString() {
				my $this = shift;
				
				return $this->{All};
			}
		##<-- End Method :: ToString
	}
##<-- End Class :: TextChunk

############################################################################################
1;