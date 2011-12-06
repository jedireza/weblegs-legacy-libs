#!/usr/bin/perl
use strict;
use CGI::Cookie;
use CGI::Session;
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
#
#*/

############################################################################################

##--> Begin Class :: WebResponse
	{package WebResponse;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $this = {
					"RedirectURL" => undef,
					"ResponseHeaders" => undef,
					"ResponseCookies" => undef,
					"CRLF" => undef,
					"Session" => undef
				};
				bless($this, ref($class) || $class);
				
				#figure out the OS
					if(!($this->{OperatingSystem} = $^O)) {
						require Config;
						$this->{OperatingSystem} = $Config::Config{"osname"};
					}
					if($this->{OperatingSystem} =~ /^MSWin/i) {
					  $this->{OperatingSystem} = "WINDOWS";
					}
					elsif($this->{OperatingSystem} =~ /^VMS/i) {
					  $this->{OperatingSystem} = "VMS";
					}
					elsif($this->{OperatingSystem} =~ /^dos/i) {
					  $this->{OperatingSystem} = "DOS";
					}
					elsif($this->{OperatingSystem} =~ /^MacOS/i) {
						$this->{OperatingSystem} = "MACINTOSH";
					}
					elsif($this->{OperatingSystem} =~ /^os2/i) {
						$this->{OperatingSystem} = "OS2";
					}
					elsif($this->{OperatingSystem} =~ /^epoc/i) {
						$this->{OperatingSystem} = "EPOC";
					}
					elsif($this->{OperatingSystem} =~ /^cygwin/i) {
						$this->{OperatingSystem} = "CYGWIN";
					}
					else {
						$this->{OperatingSystem} = "UNIX";
					}
				#end figure out the OS
				
				#find the CRLF for this OS
					#find the CRLF
					my $CompatabilityCheck = "\011" ne "\t";
					if($this->{OperatingSystem} eq "VMS") {
						$this->{CRLF} = "\n";
					}
					elsif($CompatabilityCheck) {
						$this->{CRLF} = "\r\n";
					}
					else {
						$this->{CRLF} = "\015\012";
					}
				#end find the CRLF for this OS
				
				#session support
					my $SessionID = undef;
					my %Cookies = fetch CGI::Cookie;
					my $FoundSessionCookie = 0;
					foreach(keys %Cookies) {
						if($_ eq "CGISESSID") {
							$SessionID = $Cookies{$_};
							my @Matches = $SessionID =~ m/CGISESSID=(.*?);/g;
							if(@Matches) {
								$SessionID = $Matches[0];
								$FoundSessionCookie = $Matches[0];
							}
						}
					}
					
					#create a session object
					$this->{Session} = new CGI::Session(undef, $SessionID, {Directory=>'/tmp'});
					
					#get the sessionid
					$SessionID = $this->{Session}->id();
					
					#if we didn't have a SessionID before, or its different pass the cookie
					if($FoundSessionCookie ne $SessionID) {
						$this->Cookies("CGISESSID", $SessionID);
					}
				#end session support
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: Finalize
			sub Finalize() {
				my $this = shift;
				my $Data = shift;
				
				#is there a redirect URL?
				if(defined($this->{RedirectURL})) {
					#make sure there is an HTTP status code
					if(!defined($this->{ResponseHeaders}->{"Status"})) {
						print("Status: 302 Moved Temporarily". $this->{CRLF});
					}
					else {
						print("Status: ". $this->{ResponseHeaders}->{"Status"} . $this->{CRLF});
						delete($this->{ResponseHeaders}->{"Status"});
					}
					
					#make sure there is a Location header
					if(!defined($this->{ResponseHeaders}->{"Location"})) {
						print("Location: ". $this->{RedirectURL} . $this->{CRLF});
					}
					else {
						print("Location: ". $this->{ResponseHeaders}->{"Location"} . $this->{CRLF});
						delete($this->{ResponseHeaders}->{"Location"});
					}
					
					#print cookies
					foreach(@{$this->{ResponseCookies}}) {
						print("Set-Cookie: ". $_ . $this->{CRLF});
					}
					
					#print the remaining headers
					while(my ($Key, $Value) = each(%{$this->{ResponseHeaders}})) {
						print($Key .": ". $Value . $this->{CRLF});
					}
					
					print($this->{CRLF});
				}
				else {
					#make sure there is an HTTP status code
					if(!defined($this->{ResponseHeaders}->{"Status"})) {
						print("Status: 200 OK". $this->{CRLF});
					}
					else {
						print("Status: ". $this->{ResponseHeaders}->{"Status"} . $this->{CRLF});
						delete($this->{ResponseHeaders}->{"Status"});
					}
					
					#make sure there is a Content-type
					if(!defined($this->{ResponseHeaders}->{"Content-type"})) {
						print("Content-type: text/html". $this->{CRLF});
					}
					else {
						print("Content-type: ". $this->{ResponseHeaders}->{"Content-type"} . $this->{CRLF});
						delete($this->{ResponseHeaders}->{"Content-type"});
					}
					
					#print cookies
					foreach(@{$this->{ResponseCookies}}) {
						print("Set-Cookie: ". $_ . $this->{CRLF});
					}
					
					#print the remaining headers
					while(my ($Key, $Value) = each(%{$this->{ResponseHeaders}})) {
						print($Key .": ". $Value . $this->{CRLF});
					}
					
					#print the header/body seperator
					print($this->{CRLF});
					
					#write the data
					if(!defined($Data)){$Data = "";}
					print($Data);
				}
				
				#end the request
				$this->End();
			}
		##<-- End Method :: Finalize
		
		####################################################################################
		
		##--> Begin Method :: Write
			sub Write() {
				my $this = shift;
				my $Value = shift;
				
				print($Value);
			}
		##<-- End Method :: Write
		
		####################################################################################
		
		##--> Begin Method :: Redirect
			sub Redirect() {
				my $this = shift;
				my $URL = shift;
				
				#set location header
				$this->AddHeader("Location", $URL);
				
				#populate RedirectURL property
				$this->{RedirectURL} = $URL;
				
				#finalize request
				$this->Finalize();
			}
		##<-- End Method :: Redirect
		
		####################################################################################
		
		##--> Begin Method :: End
			sub End() {
				my $this = shift;
				
				#stop the execution of perl
				exit(1);
			}
		##<-- End Method :: End
		
		####################################################################################
		
		##--> Begin Method :: AddHeader
			sub AddHeader() {
				my $this = shift;
				my $Name = shift;
				my $Value = shift;
				
				#add (or replace) into instance hash table
				$this->{ResponseHeaders}->{"$Name"} = $Value;
			}
		##<-- End Method :: AddHeader
		
		####################################################################################
		
		##--> Begin Method :: Session
			sub Session() {
				my $this = shift;
				my $Name = shift;
				my $Value = shift;
				
				#set session param
				$this->{Session}->param($Name, $Value);
			}
		##<-- End Method :: Session
		
		####################################################################################
		
		##--> Begin Method :: Cookies
			sub Cookies() {
				my $this = shift;
				my $Key = shift;
				my $Value = shift;
				my $Minutes = shift;
				my $Path = shift;
				my $Domain = shift;
				my $Secure = shift;
				
				#create a new cookie
				my $NewCookie = new CGI::Cookie();
				$NewCookie->name($Key);
				$NewCookie->value($Value);
				if(defined($Minutes)) {
					$NewCookie->expires(scalar(gmtime(time + ($Minutes * 60))) ." GMT");
				}
				if(defined($Path)) {
					$NewCookie->path($Path);
				}
				if(defined($Domain)) {
					$NewCookie->domain($Domain);
				}
				else {
					$NewCookie->domain($ENV{"HTTP_HOST"});
				}
				if(defined($Secure)) {
					$NewCookie->secure(1);
				}
				
				#add the cookie header
				push(@{$this->{ResponseCookies}}, "$NewCookie");
			}
		##<-- End Method :: Cookies
		
		####################################################################################
		
		##--> Begin Method :: ClearCookies
			sub ClearCookies() {
				my $this = shift;
				my $Path = shift;
				my $Domain = shift;
				
				my %Cookies = fetch CGI::Cookie;
				foreach (keys %Cookies) {
					if(defined($Path) && defined($Domain)) {
					   $this->Cookies($_, "", -100, $Path, $Domain);
					}
					elsif(defined($Path)) {
					   $this->Cookies($_, "", -100, $Path);
					}
					else {
					   $this->Cookies($_, "", -100);
					}
				}
			}
		##<-- End Method :: ClearCookies
		
		####################################################################################
		
		##--> Begin Method :: ClearSession
			sub ClearSession() {
				my $this = shift;
				
				$this->{Session}->delete();
			}
		##<-- End Method :: ClearSession
	}
##<-- End Class :: WebResponse

############################################################################################
1;