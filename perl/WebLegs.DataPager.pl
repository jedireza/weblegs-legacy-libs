#!/usr/bin/perl
use strict;
use POSIX qw(floor);
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

##--> Begin Class :: DataPager
	{package DataPager;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $this = {
					"RecordsPerPage" => 0,
					"TotalRecords" => 0,
					"CurrentPage" => 0,
					"LinkLoopOffset" => 0
				};
				bless($this, ref($class) || $class);
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: GetTotalPages
			sub GetTotalPages() {
				my $this = shift;
				
				my $TotalPages = POSIX::floor($this->{TotalRecords} / $this->{RecordsPerPage});
				if($this->{TotalRecords} % $this->{RecordsPerPage} > 0) {
					$TotalPages++;
				}
				if($TotalPages <= 0) {
					$TotalPages = 1;
				}
				return $TotalPages;
			}
		##<-- End Method :: GetTotalPages
		
		####################################################################################
		
		##--> Begin Method :: GetRecordToStart
			sub GetRecordToStart() {
				my $this = shift;
				
				my $RecordToStart = 0;
				if($this->{CurrentPage} > $this->GetTotalPages()) {
					$this->{CurrentPage} = $this->GetTotalPages();
				}
				$RecordToStart = ($this->{CurrentPage} - 1) * $this->{RecordsPerPage};
				if($RecordToStart < 0) {
					$RecordToStart = 0;
				}
				return $RecordToStart;
			}
		##<-- End Method :: GetRecordToStart
		
		####################################################################################
		
		##--> Begin Method :: GetRecordToStop
			sub GetRecordToStop() {
				my $this = shift;
				
				my $RecordToStop = $this->GetRecordToStart() + $this->{RecordsPerPage};
				if($RecordToStop > $this->{TotalRecords}) {
					$RecordToStop = $this->{TotalRecords};
				}
				return $RecordToStop;
			}
		##<-- End Method :: GetRecordToStop
		
		####################################################################################
		
		##--> Begin Method :: GetPreviousPage
			sub GetPreviousPage() {
				my $this = shift;
				
				if($this->{CurrentPage} - 1 <= 0) {
					return 1;
				}
				else {
					return $this->{CurrentPage} - 1;
				}
			}
		##<-- End Method :: GetPreviousPage
		
		####################################################################################
		
		##--> Begin Method :: GetNextPage
			sub GetNextPage() {
				my $this = shift;
				
				if($this->{CurrentPage} + 1 > $this->GetTotalPages()) {
					return $this->GetTotalPages();
				}
				else {
					return $this->{CurrentPage} + 1;
				}
			}
		##<-- End Method :: GetNextPage
		
		####################################################################################
		
		##--> Begin Method :: HasPreviousPage
			sub HasPreviousPage() {
				my $this = shift;
				
				if($this->{CurrentPage} - 1 <= 0) {
					return 0;
				}
				else {
					return 1;
				}
			}
		##<-- End Method :: HasPreviousPage
		
		####################################################################################
		
		##--> Begin Method :: HasNextPage
			sub HasNextPage() {
				my $this = shift;
				
				if($this->{CurrentPage} + 1 > $this->GetTotalPages()) {
					return 0;
				}
				else {
					return 1;
				}
			}
		##<-- End Method :: HasNextPage
		
		####################################################################################
		
		##--> Begin Method :: GetLinkLoopStart
			sub GetLinkLoopStart() {
				my $this = shift;
				
				if($this->{CurrentPage} - $this->{LinkLoopOffset} < 1) {
					return 1;
				}
				else {
					return $this->{CurrentPage} - $this->{LinkLoopOffset};
				}
			}
		##<-- End Method :: GetLinkLoopStart
		
		####################################################################################
		
		##--> Begin Method :: GetLinkLoopStop
			sub GetLinkLoopStop() {
				my $this = shift;
				
				if($this->{CurrentPage} + $this->{LinkLoopOffset} > $this->GetTotalPages()) {
					return $this->GetTotalPages();
				}
				else {
					return $this->{CurrentPage} + $this->{LinkLoopOffset};
				}
			}
		##<-- End Method :: GetLinkLoopStop
	}
##<-- End Class :: DataPager

############################################################################################
1;