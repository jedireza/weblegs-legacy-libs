#!/usr/bin/perl
use strict;
use Time::HiRes;
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

##--> Begin Class :: Timer
	{package Timer;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $this = {
					"TimeStart" => undef,
					"TimeStop" => undef,
					"TimeSpent" => undef
				};
				bless($this, ref($class) || $class);
				
				#construct
				$this->{TimeStart} = 0;
				$this->{TimeStop} = 0;
				$this->{TimeSpent} = 0;
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: Start
			sub Start() {
				my $this = shift;
				$this->{TimeStart} = Time::HiRes::gettimeofday();
			}
		##<-- End Method :: Start
		
		####################################################################################
		
		##--> Begin Method :: Stop
			sub Stop() {
				my $this = shift;
				$this->{TimeStop} = Time::HiRes::gettimeofday();
				$this->{TimeSpent} = ($this->{TimeStop} - $this->{TimeStart});
			}
		##<-- End Method :: Stop
	}
##<-- End Class :: Timer

############################################################################################
1;