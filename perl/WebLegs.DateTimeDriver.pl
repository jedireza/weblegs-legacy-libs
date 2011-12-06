#!/usr/bin/perl
use strict;
use Date::Manip;
use Date::Calc;
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

##--> Begin Class :: DateTimeDriver
	{package DateTimeDriver;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				
				my $this = {
					#core
					"DateTime" => undef,
					"Year" => undef,
					"Month" => undef,
					"Day" => undef,
					"Hour" => undef,
					"Minute" => undef,
					"Second" => undef,
					
					#informational
					"IsLeapYear" => undef,
					"DayOfWeek" => undef,
					"DayOfYear" => undef,
					"DaysInYear" => undef,
					"StartDayOfMonth" => undef,
					"EndDayOfMonth" => undef,
					"WeekOfYear" => undef,
					"DaysInMonth" => undef,
					"WeeksInYear" => undef,
					"DayName" => undef,
					"DayNameAbbr" => undef,
					"MonthName" => undef,
					"MonthNameAbbr" => undef,
					
					#helpers
					"DayNamesAbbr" => undef,
					"DayNames" => undef,
					"MonthNamesAbbr" => undef,
					"MonthNames" => undef,
					"MinValue" => '1901-12-13 20:45:54',
					"MaxValue" => '2038-01-19 03:14:07'
				};
				bless($this, ref($class) || $class);
				
				#setup static data
				@{$this->{MonthNames}} = qw(January February March April May June July August September October November December);
				@{$this->{MonthNamesAbbr}} = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
				@{$this->{DayNames}} = qw(Monday Tuesday Wednesday Thursday Friday Saturday Sunday);
				@{$this->{DayNamesAbbr}} = qw(Mon Tue Wed Thu Fri Sat Sun);
				
				#constructor overloads
					#(Year, Month, Day, Hour, Minute, Second)
					if(scalar(@_) eq 6) {
						my ($Year, $Month, $Day, $Hour, $Minute, $Second) = @_;
						my $tmpDate = Date::Manip::ParseDate($Year ."-". $Month ."-". $Day);
						$this->{DateTime} = Date::Manip::Date_SetTime($tmpDate, $Hour, $Minute, $Second);
					}
					#(Year, Month, Day)
					elsif(scalar(@_) eq 3) {
						my ($Year, $Month, $Day) = @_;
						$this->{DateTime} = Date::Manip::ParseDate($Year ."-". $Month ."-". $Day);
					}
					#(Value)
					elsif(scalar(@_) eq 1) {
						my ($Value) = @_;
						$this->Parse($Value);
					}
				#end constructor overloads
				
				#lets fill out our properties
				$this->RefreshProperties();
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: Set
			sub Set() {
				my $this = shift;
				my ($Year, $Month, $Day, $Hour, $Minute, $Second) = @_;
				
				#Set(Year, Month, Day, Hour, Minute, Second)
				if(defined($Year) && defined($Month) && defined($Day) && defined($Hour) && defined($Minute) && defined($Second)) {
					my $tmpDate = Date::Manip::ParseDate($Year ."-". $Month ."-". $Day);
					$this->{DateTime} = Date::Manip::Date_SetTime($tmpDate, $Hour, $Minute, $Second);
				}
				#Set(Year, Month, Day)
				else {
					$this->{DateTime} = Date::Manip::ParseDate($Year ."-". $Month ."-". $Day);
				}
				
				#refresh properties
				$this->RefreshProperties();
				
				return $this; #chaining
			}
		##<-- End Method :: Set
		
		####################################################################################
		
		##--> Begin Method :: RefreshProperties
			sub RefreshProperties() {
				my $this = shift;
				
				#should we parse?
				if(!defined($this->{DateTime})) {
					$this->{DateTime} = Date::Manip::ParseDate(localtime()."");
				}
				elsif(length($this->{DateTime}) == 0) {
					$this->{DateTime} = Date::Manip::ParseDate(localtime()."");
				}
				else {
					$this->{DateTime} = Date::Manip::ParseDate($this->{DateTime});
				}
				my ($Year, $Month, $Day, $Hour, $Minute, $Second) = split(/-/, Date::Manip::UnixDate($this->{DateTime}, "%Y-%m-%d-%H-%M-%S"));
				
				#remove zero padding
				$Month =~ s/0(\d)/$1/g;
				$Day =~ s/0(\d)/$1/g;
				$Hour =~ s/0(\d)/$1/g;
				$Minute =~ s/0(\d)/$1/g;
				$Second =~ s/0(\d)/$1/g;
				
				#assign properties
				$this->{Year} = $Year;
				$this->{Month} = $Month;
				$this->{Day} = $Day;
				$this->{Hour} = $Hour;
				$this->{Minute} = $Minute;
				$this->{Second} = $Second;
				
				#years evenly divisible by 4 are leap years
				my $IsLeap = 0;
				if($this->{Year} % 4 == 0) {
					$IsLeap = 1;
					
					#except years that are not evenly divisible by 400.
					if($this->{Year} % 100 == 0 && $this->{Year} % 400 != 0) {
						$IsLeap = 0;
					}
				}
				
				#keep track of the result
				$this->{IsLeapYear} = $IsLeap,
				$this->{DayOfWeek} = Date::Calc::Day_of_Week($Year,$Month,$Day);
				$this->{DayOfYear} = Date::Calc::Day_of_Year($Year,$Month,$Day);
				$this->{StartDayOfMonth} = Date::Calc::Day_of_Week($Year,$Month,1);
				$this->{EndDayOfMonth} = Date::Calc::Day_of_Week($Year,$Month,Date::Calc::Days_in_Month($Year,$Month));
				$this->{WeekOfYear} = Date::Calc::Week_of_Year($Year,$Month,$Day);
				$this->{WeeksInYear} = Date::Calc::Weeks_in_Year($Year);
				$this->{DaysInMonth} = Date::Calc::Days_in_Month($Year,$Month);
				$this->{DaysInYear} = Date::Calc::Days_in_Year($Year,12);
				$this->{DayName} = @{$this->{DayNames}}[$this->{DayOfWeek} - 1];
				$this->{DayNameAbbr} = @{$this->{DayNamesAbbr}}[$this->{DayOfWeek} - 1];
				$this->{MonthName} = @{$this->{MonthNames}}[$this->{Month} - 1];
				$this->{MonthNameAbbr} = @{$this->{MonthNamesAbbr}}[$this->{Month} - 1];
				
				return;
			}
		##<-- End Method :: RefreshProperties
		
		####################################################################################
		
		##--> Begin Method :: Add
			sub Add() {
				my $this = shift;
				my ($Years, $Months, $Days, $Hours, $Minutes, $Seconds) = @_;
				
				my @NewDate = Date::Calc::Add_Delta_YMDHMS($this->{Year},$this->{Month},$this->{Day},$this->{Hour},$this->{Minute},$this->{Second},$Years,$Months,$Days,$Hours,$Minutes,$Seconds);
				#0 pad month, days, hour, min, sec
				grep $NewDate[$_] =~ s/^([0-9])$/0$1/, (1..5);
				#distribute results
				$this->{DateTime} = $NewDate[0]."".$NewDate[1]."".$NewDate[2]."".$NewDate[3].":".$NewDate[4].":".$NewDate[5];
				$this->RefreshProperties();
				
				return $this; #chaining
			}
		##<-- End Method :: Add
				
		####################################################################################
		
		##--> Begin Method :: AddSeconds
			sub AddSeconds() {
				my $this = shift;
				my $Value = shift;
				
				$this->Add(0,0,0,0,0,$Value);
				return $this; #chaining
			}
		##<-- End Method :: AddSeconds
				
		####################################################################################
		
		##--> Begin Method :: AddMinutes
			sub AddMinutes() {
				my $this = shift;
				my $Value = shift;
				
				$this->Add(0,0,0,0,$Value,0);
				return $this; #chaining
			}
		##<-- End Method :: AddMinutes
				
		####################################################################################
		
		##--> Begin Method :: AddHours
			sub AddHours() {
				my $this = shift;
				my $Value = shift;
				
				$this->Add(0,0,0,$Value,0,0);
				return $this; #chaining
			}
		##<-- End Method :: AddHours
				
		####################################################################################
		
		##--> Begin Method :: AddDays
			sub AddDays() {
				my $this = shift;
				my $Value = shift;
				
				$this->Add(0,0,$Value,0,0,0);
				return $this; #chaining
			}
		##<-- End Method :: AddDays
				
		####################################################################################
		
		##--> Begin Method :: AddMonths
			sub AddMonths() {
				my $this = shift;
				my $Value = shift;
				
				$this->Add(0,$Value,0,0,0,0);
				return $this; #chaining
			}
		##<-- End Method :: AddMonths
				
		####################################################################################
		
		##--> Begin Method :: AddYears
			sub AddYears() {
				my $this = shift;
				my $Value = shift;
				
				$this->Add($Value,0,0,0,0,0);
				return $this; #chaining
			}
		##<-- End Method :: AddYears
		
		####################################################################################
		
		##--> Begin Method :: Diff
			sub Diff() {
				my $this = shift;
				my $DateTime = shift;
				
				my @time_diff = Date::Calc::Delta_DHMS(
					$this->{Year}, $this->{Month}, $this->{Day}, $this->{Hour}, $this->{Minute}, $this->{Second},
					$DateTime->{Year}, $DateTime->{Month}, $DateTime->{Day}, $DateTime->{Hour}, $DateTime->{Minute}, $DateTime->{Second}
				);
				
				my $TotalSecondsDifferent = $time_diff[3] + ($time_diff[2] * 60) + (($time_diff[1] * 60) * 60) + ((($time_diff[0] * 24) * 60) * 60);
				
				my $Data = {
					"Milliseconds" => 0,
					"Seconds" => $time_diff[3],
					"Minutes" => $time_diff[2],
					"Hours" => $time_diff[1],
					"Days" => $time_diff[0],
					"TotalMilliseconds" => ($TotalSecondsDifferent * 1000),
					"TotalSeconds" => $TotalSecondsDifferent,
					"TotalMinutes" => ($TotalSecondsDifferent / 60),
					"TotalHours" => (($TotalSecondsDifferent / 60) / 60),
					"TotalDays" => ((($TotalSecondsDifferent / 60) / 60) / 24)
				};
				
				return $Data;
			}
		##<-- End Method :: Diff
		
		####################################################################################
		
		##--> Begin Method :: Now
			sub Now() {
				my $this = shift;
				return DateTimeDriver->new();
			}
		##<-- End Method :: Now
		
		####################################################################################
		
		##--> Begin Method :: SetMinValue
			sub SetMinValue() {
				my $this = shift;
				$this->Parse($this->{MinValue});
			}
		##<-- End Method :: SetMinValue
		
		####################################################################################
		
		##--> Begin Method :: SetMaxValue
			sub SetMaxValue() {
				my $this = shift;
				$this->Parse($this->{MaxValue});
			}
		##<-- End Method :: SetMaxValue
		
		####################################################################################
		
		##--> Begin Method :: Parse
			sub Parse() {
				my $this = shift;
				my $Value = shift;
				if(Date::Manip::ParseDate($Value)) {
					$this->{DateTime} = $Value;
					$this->RefreshProperties();
				}
				else {
					$this->SetMinValue();
				}
				return $this;
			}
		##<-- End Method :: Parse
		
		####################################################################################
		
		##--> Begin Method :: ToString
			sub ToString() {
				my $this = shift;
				my $Format = shift;
				
				if(!defined($Format)) {
					$Format = "yyyy-MM-dd HH:mm:ss";
				}
				
				#support for the [...content...] blocks
					my @ValidKeyCharacters = ('a','b','c','e','f','g','i','j','k','l','p','q','r','u','v','w','x','z');
					my $SavedText = {};
					my @Matches = $Format =~ m/(\[.*?\])/g;
					for(my $i = 0 ; $i < scalar(@Matches) ; $i++) {
						#generate random key
						my $ThisKey = "";
						for(my $j = 0 ; $j < 20 ; $j++) {
							$ThisKey .= $ValidKeyCharacters[int(rand(scalar(@ValidKeyCharacters)))];
						}
						my $ThisMatch = $Matches[$i];
						$ThisMatch =~ s/\[//g;
						$ThisMatch =~ s/\]//g;
						$SavedText->{$ThisKey} = $ThisMatch;
						
						$Format =~ s/\Q$Matches[$i]/$ThisKey/;
					}
				#end support for the [...content...] blocks
				
				#setup internal token translation
				$Format =~ s/dddd/!!!!/g;
				$Format =~ s/ddd/!!!/g;
				$Format =~ s/dd/!!/g;
				$Format =~ s/do/!\@/g;
				$Format =~ s/d/!/g;
				$Format =~ s/hh/==/g;
				$Format =~ s/ho/=\@/g;
				$Format =~ s/h/=/g;
				$Format =~ s/HH/$$/g;
				$Format =~ s/HO/\$\@/g;
				$Format =~ s/H/\$/g;
				$Format =~ s/mm/\%\%/g;
				$Format =~ s/mo/\%\@/g;
				$Format =~ s/m/\%/g;
				$Format =~ s/MMMM/^^^^/g;
				$Format =~ s/MMM/^^^/g;
				$Format =~ s/MM/^^/g;
				$Format =~ s/MO/^\@/g;
				$Format =~ s/M/^/g;
				$Format =~ s/ss/&&/g;
				$Format =~ s/so/&\@/g;
				$Format =~ s/s/&/g;
				$Format =~ s/tt/**/g;
				$Format =~ s/t/*/g;
				$Format =~ s/TT/__/g;
				$Format =~ s/T/_/g;
				$Format =~ s/yyyyo/~~~~\@/g;
				$Format =~ s/yyyy/~~~~/g;
				$Format =~ s/yy/~~/g;
				
				#translate internal tokens
					$Format =~ s/!!!!/$this->{DayName}/g;
					$Format =~ s/!!!/$this->{DayNameAbbr}/g;
					
					my $DayZero = $this->{Day};
					if(length($DayZero) == 1) {
						$DayZero = "0". $DayZero;
					}
					$Format =~ s/!!/$DayZero/g;
					
					my $DayOrdinal = $this->OrdinalSuffix($this->{Day});
					$Format =~ s/!@/$DayOrdinal/g;
					
					$Format =~ s/!/$this->{Day}/g;
					
					my $Hour12 = $this->{Hour};
					if($Hour12 > 12){
						$Hour12 -= 12;
					}
					if(length($Hour12) == 1) {
						$Hour12 = "0". $Hour12;
					}
					$Format =~ s/==/$Hour12/g;
					
					my $Hour12Ordinal = $this->{Hour};
					if($Hour12Ordinal > 12){
						$Hour12Ordinal -= 12;
					}
					$Hour12Ordinal = $this->OrdinalSuffix($Hour12Ordinal);
					$Format =~ s/=@/$Hour12Ordinal/g;
					
					my $Hour12Single = $this->{Hour};
					if($Hour12Single > 12){
						$Hour12Single -= 12;
					}
					$Format =~ s/=/$Hour12Single/g;
					
					my $Hour24Zero = $this->{Hour};
					if(length($Hour24Zero) == 1) {
						$Hour24Zero = "0". $Hour24Zero;
					}
					$Format =~ s/$$/$Hour24Zero/g;
					
					my $Hour24Ordinal = $this->OrdinalSuffix($this->{Hour});
					$Format =~ s/\$\@/$Hour24Ordinal/g;
									
					$Format =~ s/\$/$this->{Hour}/g;
					
					my $MinuteZero = $this->{Minute};
					if(length($MinuteZero) == 1) {
						$MinuteZero = "0". $MinuteZero;
					}
					$Format =~ s/\%\%/$MinuteZero/g;
					
					my $MinuteOrdinal = $this->OrdinalSuffix($this->{Minute});
					$Format =~ s/\%\@/$MinuteOrdinal/g;
					
					$Format =~ s/\%/$this->{Minute}/g;
					
					$Format =~ s/\^\^\^\^/$this->{MonthName}/g;
					$Format =~ s/\^\^\^/$this->{MonthNameAbbr}/g;
					
					my $MonthZero = $this->{Month};
					if(length($MonthZero) == 1) {
						$MonthZero = "0". $MonthZero;
					}
					$Format =~ s/\^\^/$MonthZero/g;
					
					my $MonthOrdinal = $this->OrdinalSuffix($this->{Month});
					$Format =~ s/\^@/$MonthOrdinal/g;
					
					$Format =~ s/\^/$this->{Month}/g;
					
					my $SecondZero = $this->{Second};
					if(length($SecondZero) == 1) {
						$SecondZero = "0". $SecondZero;
					}
					$Format =~ s/&&/$SecondZero/g;
					
					my $SecondOrdinal = $this->OrdinalSuffix($this->{Second});
					$Format =~ s/&\@/$SecondOrdinal/g;
					
					$Format =~ s/&/$this->{Second}/g;
					
					my $TimeOfDay = "AM";
					if($this->{Hour} >= 12) {
						$TimeOfDay = "PM";
					}
					my $TimeOfDaySingle = substr($TimeOfDay, 0, 1);
					my $TimeOfDayLower = lc($TimeOfDay);
					my $TimeOfDayLowerSingle = lc($TimeOfDaySingle);
					$Format =~ s/\*\*/$TimeOfDayLower/g;
					$Format =~ s/\*/$TimeOfDayLowerSingle/g;
					$Format =~ s/__/$TimeOfDay/g;
					$Format =~ s/_/$TimeOfDaySingle/g;
					
					my $YearOrdinal = $this->OrdinalSuffix($this->{Year});
					$Format =~ s/~~~~\@/$YearOrdinal/g;
					$Format =~ s/~~~~/$this->{Year}/g;
					my $Year2Digit = substr($this->{Year}, 2);
					$Format =~ s/~~/$Year2Digit/g;
				#end translate internal tokens
				
				#replace keys in string
				foreach (keys %{$SavedText}) {
				   $Format =~ s/$_/$SavedText->{$_}/g;
				}
				
				return $Format;
			}
		##<-- End Method :: ToString
		
		####################################################################################
		
		##--> Begin Method :: OrdinalSuffix
			sub OrdinalSuffix() {
				my $this = shift;
				my $Value = shift;
				
				#format numbers with 'st', 'nd', 'rd', 'th'
				my $Abr = "";
				my $strNumber = $Value;
				
				my $strLastNumber = substr($strNumber, length($strNumber) -1);
				my $strLastTwoNumbers = substr($strNumber, length($strNumber) -1);
				if(length($strNumber) >= 2) {
					$strLastTwoNumbers = substr($strNumber, length($strNumber) -2);
				}
				else {
					$strLastTwoNumbers = $strLastNumber;
				}
				
				if($strLastNumber eq "1") {
					if($strLastTwoNumbers eq "11") {$Abr = "th";} else {$Abr = "st";}
				}
				elsif($strLastNumber eq "2") {
					if($strLastTwoNumbers eq "12") {$Abr = "th";} else {$Abr = "nd";}
				}
				elsif($strLastNumber eq "3") {
					if($strLastTwoNumbers eq "13") {$Abr = "th";} else {$Abr = "rd";}
				}
				elsif($strLastNumber eq "4" || $strLastNumber eq "5" || $strLastNumber eq "6" || $strLastNumber eq "7" || $strLastNumber eq "8" || $strLastNumber eq "9" || $strLastNumber eq "0") {
					$Abr = "th";
				}
				else {
					$Abr = "";
				}
				
				return $strNumber . $Abr;
			}
		##<-- End Method :: OrdinalSuffix
	}
##<-- End Class :: DateTimeDriver

############################################################################################
1;