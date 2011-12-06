#!/usr/bin/perl
use strict;
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
#*/

############################################################################################

##--> Begin Class :: WebRequest
	{package WebRequest;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $SessionReference = shift;
				my $this = {
					"FormHash" => undef,
					"RawFormString" => undef,
					"MaxRequestLength" => undef,
					"Files" => undef,
					"QueryStringHash" => undef,
					"RawQueryString" => undef,
					"CookieHash" => undef,
					"OperatingSystem" => undef,
					"IRS" => undef,
					"CRLF" => undef,
					"Session" => undef
				};
				bless($this, ref($class) || $class);
				
				#initialize
				$this->{FormHash} = ();
				$this->{Files} = [];
				$this->{QueryStringHash} = ();
				$this->{CookieHash} = ();
				
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
					#store the IRS
					$this->{IRS} = $/;
					
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
				
				#populate form (POST)
					#change IRS
					$/ = $this->{CRLF};
					
					#some containers
					my $PostString = "";
					my %PostData = ();
					
					#get the content length (size of post)
					if(!defined($this->{MaxRequestLength})) {
						$this->{MaxRequestLength} = (1024 * 5000); #5mb by default
					}
					my $ContentLength = defined($ENV{'CONTENT_LENGTH'}) ? $ENV{'CONTENT_LENGTH'} : 0;
					
					#is this a multipart/form-data post
					if(defined($ENV{"REQUEST_METHOD"}) && $ENV{"REQUEST_METHOD"} eq "POST" && defined($ENV{"CONTENT_TYPE"}) && $ENV{"CONTENT_TYPE"} =~ m|^multipart/form-data|) {
						#error out on unreasonably large requests
						if(($this->{MaxRequestLength} > 0) && ($ContentLength > $this->{MaxRequestLength})) {
							#this needs to be a real HTTP status code error
							die("WebLegs.WebRequest.Constructor(): Request length too large. Maximum request length is set to '". $this->{MaxRequestLength} ."'. (413 Request entity too large)");
						}
						
						#find the boundry
						my($PartBoundry) = $ENV{"CONTENT_TYPE"} =~ /boundary=\"?([^\";,]+)\"?/; #"commenting for code coloring purposes only
						$PartBoundry = "--". $PartBoundry;
						
						#get raw post data
							my $RawPostData = "";
							binmode(STDIN);
							while(<STDIN>) {
								$RawPostData .= $_;
							}
						#end get raw post data
						
						#break into parts
						my @PostedParts = split(/\Q$PartBoundry/, $RawPostData);
						
						#loop over parts
						for(my $i = 0 ; $i < scalar(@PostedParts) ; $i++) {
							#skip the first and last items
							if(($i == 0) || ($i == (scalar(@PostedParts) - 1))) {
								next;
							}
							
							#seperate the headers from the body
							my $PartSplitter = $this->{CRLF}.$this->{CRLF};
							my($PartHeaders, $PartBody) = $PostedParts[$i] =~ /^(.*?)$PartSplitter(.*?)$this->{CRLF}$/s;
							
							#is this a file?
							if($PartHeaders =~ /Content-Type/g) {
								#create a new WebRequestFile
								my $tmpFile = WebRequestFile->new();
								
								#find the file properties
								my($FormName, $FileName, $ContentType) = $PartHeaders =~ /Content-Disposition: form-data; name="(.*?)"; filename="(.*?)".*?Content-Type: (.*?)$/s;
								
								#clean up file name, some browsers (like IE) submit the client's full path
								if($FileName =~ /\/|\\/) {
									#split by slashes
									my @PathParts = split(/\/|\\/, $FileName);
									#the last one is the filename
									$FileName = $PathParts[(scalar(@PathParts) - 1)];
								}
								
								#fill up the WebRequestFile object
								$tmpFile->{FormName} = $FormName;
								$tmpFile->{FileName} = $FileName;
								$tmpFile->{ContentType} = $ContentType;
								$tmpFile->{ContentLength} = length($PartBody);
								$tmpFile->{FileData} = $PartBody;
								
								#add file to file array
								if($FileName ne "") {
									push(@{$this->{Files}}, $tmpFile);
								}
							}
							#nope, just basic form data
							else {
								#build up the post data
								my($Name) = $PartHeaders =~ /Content-Disposition: form-data; name="(.*?)"/;
								my $Value = $PartBody;
								
								#add to instance hash able
								if(!defined($PostData{"$Name"})) {
									$PostData{"$Name"} = $Value;
								}
								else {
									$PostData{"$Name"} .= ",$Value";
								}
							}
						}
						
						#build the post string
						my $i = 0;
						my $TotalKeys = scalar(keys(%PostData));
						for my $Key (keys(%PostData)) {
							$PostString .= $Key ."=". $PostData{$Key};
							if(($i + 1) != $TotalKeys) {
								$PostString .= "&";
							}
							$i++;
						}
					}
					#nope, just basic post data
					elsif(defined($ENV{"REQUEST_METHOD"}) && $ENV{"REQUEST_METHOD"} eq "POST") {
						read(STDIN, $PostString, $ENV{"CONTENT_LENGTH"});
						my @FormParts = split(/\&/, $PostString);
						foreach my $FormPart (@FormParts) {
							my ($Name, $Value) = split( /\=/, $FormPart);
							if(!defined($PostData{"$Name"})) {
								$PostData{"$Name"} = $Value;
							}
							else {
								$PostData{"$Name"} .= ",$Value";
							}
						}
					}
					
					#link to instance
					$this->{FormHash} = \%PostData;
					$this->{RawFormString} = $PostString;
					
					#change IRS back
					$/ = $this->{IRS};
				#end populate form (post)
				
				#populate query (GET)
					my %QueryString = ();
					my @QueryParts = split(/\&/, $ENV{"QUERY_STRING"});
					foreach my $QueryPart (@QueryParts) {
						my ($Name, $Value) = split(/\=/, $QueryPart);
						if(!defined($QueryString{"$Name"})){
							$QueryString{"$Name"} = $Value;
						}
						else {
							$QueryString{"$Name"} .= ",$Value";
						}
					}
					$this->{QueryStringHash} = \%QueryString;
					$this->{RawQueryString} = $ENV{"QUERY_STRING"};
				#end populate query (GET)
				
				#populate cookies
					my $CookieInput = $ENV{"HTTP_COOKIE"};
					if(!defined($CookieInput)){$CookieInput = ""};
					my %Cookies = ();
					my @CookieParts = split('; ', $CookieInput);
					foreach my $CookiePart (@CookieParts) {
						my ($Name, $Value) = split( /\=/, $CookiePart);
						if(!defined($Cookies{"$Name"})) {
							$Cookies{"$Name"} = $Value;
						}
						else {
							$Cookies{"$Name"} .= ", $Value";
						}
					}
					$this->{CookieHash} = \%Cookies;
				#end populate cookies
				
				#session support
					if($SessionReference) {
						$this->{Session} = $SessionReference;
					}
					else {
						#get the current session id
						my $SessionID = $this->Cookies("CGISESSID");
						
						#create a session object
						$this->{Session} = new CGI::Session(undef, $SessionID, {Directory =>'/tmp'});
					}
				#end session support
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: Form
			sub Form() {
				my $this = shift;
				my $Token = shift;
				
				if(!defined($Token)) {
					return $this->{RawFormString};
				}
				elsif(!defined($this->{FormHash}->{$Token})) {
					return undef;
				}
				else {
					my $ReturnValue = $this->{FormHash}->{$Token};
					$ReturnValue = Codec::URLDecode($ReturnValue);
					return $ReturnValue;
				}
			}
		##<-- End Method :: Form
		
		####################################################################################
		
		##--> Begin Method :: QueryString
			sub QueryString() {
				my $this = shift;
				my $Token = shift;
				
				if(!defined($Token)) {
					return $this->{RawQueryString};
				}
				elsif(!defined($this->{QueryStringHash}->{$Token})) {
					return undef;
				}
				else {
					my $ReturnValue = $this->{QueryStringHash}->{$Token};
					$ReturnValue = Codec::URLDecode($ReturnValue);
					return $ReturnValue;
				}
			}
		##<-- End Method :: QueryString
		
		####################################################################################
		
		##--> Begin Method :: Input
			sub Input() {
				my $this = shift;
				my $Token = shift;
				my $Default = shift;
				my $FormFirst = shift;
				
				#clean up a bit
				if(!defined($Default)) {
					$Default = "*|*weblegs.default*|*";
				}
				if(!defined($FormFirst)) {
					$FormFirst = 1;
				}
				
				#container
				my $ReturnValue = "";
				
				if($FormFirst) {
					$ReturnValue = $this->{FormHash}->{$Token};
					if(!defined($ReturnValue)) {
						$ReturnValue = $this->{QueryStringHash}->{$Token};
					}
				}
				else {
					$ReturnValue = $this->{QueryStringHash}->{$Token};
					if(!defined($ReturnValue)) {
						$ReturnValue = $this->{FormHash}->{$Token};
					}
				}
				
				if(!defined($ReturnValue)) {
					$ReturnValue = $Default eq "*|*weblegs.default*|*" ? "" : $Default;
				}
				
				$ReturnValue = Codec::URLDecode($ReturnValue);
				return $ReturnValue;
			}
		##<-- End Method :: Input
		
		####################################################################################
		
		##--> Begin Method :: File
			sub File() {
				my $this = shift;
				my $Key = shift;
				
				if(defined($this->{Files})) {
					for(my $i = 0 ; $i < scalar(@{$this->{Files}}) ; $i++) {
						my $tmpFile = @{$this->{Files}}[$i];
						if($tmpFile->{FormName} eq $Key) {
							return $this->{Files}[$i];
						}
					}
				}
				
				return undef;
			}
		##<-- End Method :: File
		
		####################################################################################
		
		##--> Begin Method :: ServerVariables
			sub ServerVariables() {
				my $this = shift;
				my $Token = shift;
				
				return $ENV{"$Token"} || undef;
			}
		##<-- End Method :: ServerVariables
		
		####################################################################################
		
		##--> Begin Method :: Session
			sub Session() {
				my $this = shift;
				my $Token = shift;
				
				#get the value requested
				if(defined($this->{Session}->param($Token))) {
					return $this->{Session}->param($Token);
				}
				else {
					return undef;
				}
			}
		##<-- End Method :: Session
		
		####################################################################################
		
		##--> Begin Method :: Cookies
			sub Cookies() {
				my $this = shift;
				my $Token = shift;
				
				if($this->{CookieHash}->{$Token}) {
					my $Value = Codec::URLDecode($this->{CookieHash}->{$Token});
					return $Value;
				}
				else {
					return undef;
				}
			}
		##<-- End Method :: Cookies
		
		####################################################################################
		
		##--> Begin Method :: Header
			sub Header() {
				my $this = shift;
				my $Token = shift;
				
				#get token ready for CGI headers
				$Token =~ s/-/_/g;
				$Token = uc($Token);
				
				if(defined($ENV{"HTTP_$Token"})) {
					return $ENV{"HTTP_$Token"};
				}
				else {
					return undef;
				}
			}
		##<-- End Method :: Header
	}
##<-- End Class :: WebRequest

############################################################################################
1;