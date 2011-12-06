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

##--> Begin Class :: DOMChunk
	{package DOMChunk;
		##--> Begin :: Inheritance
			our @ISA = qw(DOMTemplate);
		##<-- End :: Inheritance
		
		####################################################################################
		
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $ThisDOMTemplate = shift;
				
				my $this = {
					"Blank" => undef,
					"All" => undef,
					"Current" => undef,
					"Original" => undef
				};
				bless($this, ref($class) || $class);
				
				#initialize
				$this->{All} = [];
				
				#setup this chunk
				$this->{BasePath} = $ThisDOMTemplate->{XPathQuery};
				$this->{DOMXPath} = $ThisDOMTemplate->{DOMXPath};
				$this->{DOMDocument} = $ThisDOMTemplate->{DOMDocument};
				$this->{Original} = $ThisDOMTemplate->GetNode();
				$this->{Blank} = $this->{Original}->cloneNode(1);
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: Root
			sub Root() {
				my $this = shift;
				
				#clear out results nodes
				$this->{ResultNodes} = undef;
				
				#clear out xpath query
				$this->{XPathQuery} = "";
				
				return $this;
			}
		##<-- End Method :: Root
		
		####################################################################################
		
		##--> Begin Method :: Begin
			sub Begin() {
				my $this = shift;
				
				#make a copy of blank
				$this->{Current} = $this->{Blank}->cloneNode(1);

				#put current in the tree
				$this->{Original}->parentNode()->replaceChild($this->{Current}, $this->{Original}); 
				
				#current is the new original
				$this->{Original} = $this->{Current};
			}
		##<-- End Method :: Begin
		
		####################################################################################
		
		##--> Begin Method :: End
			sub End() {
				my $this = shift;
				
				#save a copy of current now that its been edited
				push(@{$this->{All}}, $this->{Current}->cloneNode(1));
			}
		##<-- End Method :: End
		
		####################################################################################
		
		##--> Begin Method :: Render
			sub Render() {
				my $this = shift;
				
				for(my $i = 0 ; $i < scalar(@{$this->{All}}); $i++) {
					$this->{Original}->parentNode()->insertBefore($this->{All}->[$i], $this->{Original});
				}
				$this->{Original}->parentNode()->removeChild($this->{Original});
			}
		##<-- End Method :: Render
	}
##<-- End Class :: DOMChunk

############################################################################################
1;