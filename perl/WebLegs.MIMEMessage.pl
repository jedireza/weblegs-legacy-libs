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

##--> Begin Class :: MIMEMessage
	{package MIMEMessage;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $Data = shift;
				my $this = {
					"Headers" => undef,
					"Preamble" => "",
					"Body" => undef,
					"FileBody" => undef,
					"Parts" => undef
				};
				bless($this, ref($class) || $class);
				
				#initialize
				$this->{Headers} = [];
				$this->{Parts} = [];
				
				#constructor overload
				if(defined($Data)) {
					$this->Parse($Data);
				}
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: Parse
			sub Parse() {
				my $this = shift;
				my $Data = shift;
				
				#clean up the line spaces
				$Data =~ s/\r\n/\n/g;
				$Data =~ s/\r/\n/g;
				
				#seperate the headers and body
				my($tmpHeaders, $tmpBody) = $Data =~ /(.*?)\n\n(.*)/sg;
				
				#parse the header and body
				$this->ParseHeaders($tmpHeaders);
				$this->ParseBody($tmpBody, 1);
			}
		##<-- End Method :: Parse
		
		####################################################################################
		
		##--> Begin Method :: ParseHeaders
			sub ParseHeaders() {
				my $this = shift;
				my $Data = shift;
				
				while($Data =~ m/(\S*?): (.*?)(?=\n\S*?: |$)/sg) {
					#grab the group matches
					my $Name = $1;
					my $Value = $2;
					#clean up multiple white-spaces
					$Value =~ s/\s+/ /g;
					#add to headers collection
					push(@{$this->{Headers}}, [$Name, $Value]);
				}
			}
		##<-- End Method :: ParseHeaders
		
		####################################################################################
		
		##--> Begin Method :: ParseBody
			sub ParseBody() {
				my $this = shift;
				my $Data = shift;
				my $Decode = shift;
				
				if(lc($this->GetMediaType()) eq "application") {
					#check for encoding
					if($this->GetContentTransferEncoding() =~ m/base64/) {
						if($Decode) {
							$this->{Body} = $Data;
							$this->{FileBody} = Codec::Base64Decode($Data);
						}
						else {
							$this->{Body} = Codec::Base64Encode($this->{FileBody});
						}
					}
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif(lc($this->GetMediaType()) eq "audio") {
					#check for encoding
					if($this->GetContentTransferEncoding() =~ m/base64/) {
						if($Decode) {
							$this->{Body} = $Data;
							$this->{FileBody} = Codec::Base64Decode($Data);
						}
						else {
							$this->{Body} = Codec::Base64Encode($this->{FileBody});
						}
					}
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif(lc($this->GetMediaType()) eq "image") {
					#check for encoding
					if($this->GetContentTransferEncoding() =~ m/base64/) {
						if($Decode) {
							$this->{Body} = $Data;
							$this->{FileBody} = Codec::Base64Decode($Data);
						}
						else {
							$this->{Body} = Codec::Base64Encode($this->{FileBody});
						}
					}
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif(lc($this->GetMediaType()) eq "message") {
					if(lc($this->GetMediaSubType()) eq "rfc822") {
						#make the first part of this message
						#the parsed message
						push(@{$this->{Parts}}, MIMEMessage->new($Data));
					}
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif(lc($this->GetMediaType()) eq "model") {
					#not implemented
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif(lc($this->GetMediaType()) eq "multipart") {
					#the boundry is required for multipart messages
					my $MultiPartBoundry = $this->GetMediaBoundary();
					
					#find the preamble
					if($Data =~ m/(.*?)--$MultiPartBoundry/s) {
						$this->{Preamble} = $1;
					}
					
					#get each part of the message
					while($Data =~ m/--$MultiPartBoundry(.*?)(?=--$MultiPartBoundry)/sg) {
						#grab the group matches
						my $tmpPart = $1;
						#add to headers collection
						push(@{$this->{Parts}}, MIMEMessage->new($tmpPart));
					}
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif(lc($this->GetMediaType()) eq "text") {
					#check for encoding
					if($this->GetContentTransferEncoding() =~ m/base64/) {
						if($Decode) {
							$this->{Body} = Codec::Base64Decode($Data);
						}
						else {
							$this->{Body} = Codec::Base64Encode($Data);
						}
					}
					elsif($this->GetContentTransferEncoding() =~ m/quoted-printable/) {
						if($Decode) {
							$this->{Body} = Codec::QuotedPrintableDecode($Data);
						}
						else {
							$this->{Body} = Codec::QuotedPrintableEncode($Data);
						}
					}
					else {
						$this->{Body} = $Data;
					}
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif(lc($this->GetMediaType()) eq "video") {
					#check for encoding
					if($this->GetContentTransferEncoding() =~ m/base64/) {
						if($Decode) {
							$this->{Body} = $Data;
							$this->{FileBody} = Codec::Base64Decode($Data);
						}
						else {
							$this->{Body} = Codec::Base64Encode($this->{FileBody});
						}
					}
				}
			}
		##<-- End Method :: ParseBody
		
		####################################################################################
		
		##--> Begin Method :: AddHeader
			sub AddHeader() {
				my $this = shift;
				my $Name = shift;
				my $Value = shift;
				
				push(@{$this->{Headers}}, [$Name, $Value]);
			}
		##<-- End Method :: AddHeader
		
		####################################################################################
		
		##--> Begin Method :: RemoveHeader
			sub RemoveHeader() {
				my $this = shift;
				my $Name = shift;
				
				for(my $i = 0 ; $i < scalar(@{$this->{Headers}}) ; $i++) {
					if(lc($this->{Headers}->[$i][0]) eq lc($Name)) {
						splice(@{$this->{Headers}}, $i, 1);
					}
				}
			}
		##<-- End Method :: RemoveHeader
		
		####################################################################################
		
		##--> Begin Method :: GetHeader
			sub GetHeader() {
				my $this = shift;
				my $Name = shift;
				
				for(my $i = 0 ; $i < scalar(@{$this->{Headers}}) ; $i++) {
					if(lc($this->{Headers}->[$i][0]) eq lc($Name)) {
						return $this->{Headers}->[$i][1];
					}
				}
				
				return "";
			}
		##<-- End Method :: GetHeader
		
		####################################################################################
		
		##--> Begin Method :: GetContentTransferEncoding
			sub GetContentTransferEncoding() {
				my $this = shift;
				
				if($this->GetHeader("Content-Transfer-Encoding") ne "") {
					return $this->GetHeader("Content-Transfer-Encoding");
				}
				else {
					return "";
				}
			}
		##<-- End Method :: GetContentTransferEncoding
		
		####################################################################################
		
		##--> Begin Method :: GetMediaType
			sub GetMediaType() {
				my $this = shift;
				
				my $tmpMediaType = "";
				if($this->GetHeader("Content-Type") =~ m/^(.*?)\/(.*?);|$/) {
					$tmpMediaType = $1;
				}
				if($tmpMediaType eq "") {
					$tmpMediaType = "text";
				}
				return $tmpMediaType;
			}
		##<-- End Method :: GetMediaType
		
		####################################################################################
		
		##--> Begin Method :: GetMediaSubType
			sub GetMediaSubType() {
				my $this = shift;
				
				my $tmpMediaSubType = "";
				if($this->GetHeader("Content-Type") =~ m/^(.*?)\/(.*?);|$/) {
					$tmpMediaSubType = $2;
				}
				if($tmpMediaSubType eq "") {
					$tmpMediaSubType = "text";
				}
				return $tmpMediaSubType;
			}
		##<-- End Method :: GetMediaSubType
		
		####################################################################################
		
		##--> Begin Method :: GetMediaFileName
			sub GetMediaFileName() {
				my $this = shift;
				
				my $tmpMediaFile = "";
				if($this->GetHeader("Content-Disposition") =~ m/name="{0,1}(.*?)("|;|$)/) {
					$tmpMediaFile = $1;
				}
				return $tmpMediaFile;
			}
		##<-- End Method :: GetMediaFileName
		
		####################################################################################
		
		##--> Begin Method :: GetMediaCharacterSet
			sub GetMediaCharacterSet() {
				my $this = shift;
				
				my $tmpMediaCharacterSet = "";
				if($this->GetHeader("Content-Type") =~ m/charset="{0,1}(.*?)("|;|$)/) {
					$tmpMediaCharacterSet = $1;
				}
				if($tmpMediaCharacterSet eq "") {
					$tmpMediaCharacterSet = "us-ascii";
				}
				return $tmpMediaCharacterSet;
			}
		##<-- End Method :: GetMediaCharacterSet
		
		####################################################################################
		
		##--> Begin Method :: GetMediaBoundary
			sub GetMediaBoundary() {
				my $this = shift;
				
				my $tmpBoundary = "";
				if($this->GetHeader("Content-Type") =~ m/boundary="{0,1}(.*?)(?:"|$)/) {
					$tmpBoundary = $1;
				}
				return $tmpBoundary;
			}
		##<-- End Method :: GetMediaBoundary
		
		####################################################################################
		
		##--> Begin Method :: IsAttachment
			sub IsAttachment() {
				my $this = shift;
				
				if($this->GetHeader("Content-Disposition") =~ m/attachment/) {
					return 1;
				}
				else {
					return 0;
				}
			}
		##<-- End Method :: IsAttachment
		
		####################################################################################
		
		##--> Begin Method :: ToString
			sub ToString() {
				my $this = shift;
				
				my $tmpMIMEMessage = "";
				
				#loop over the headers
				for(my $i = 0 ; $i < scalar(@{$this->{Headers}}) ; $i++) {
					my $tmpThisHeader = $this->{Headers}->[$i][0] .": ". $this->{Headers}->[$i][1];
					my $tmpThisFixedHeader = "";
					if(length($tmpThisHeader) > 74) {
						while(length($tmpThisHeader) > 74) {
							#find the next space character furthest to the end (or the 74th character)
							if(rindex(substr($tmpThisHeader, 0, 73), " ") > -1) {
								$tmpThisFixedHeader .= substr($tmpThisHeader, 0, rindex(substr($tmpThisHeader, 0, 73), " ")) ."\n\t";
								#remove from tmpThisHeader
								$tmpThisHeader = substr($tmpThisHeader, rindex(substr($tmpThisHeader, 0, 73), " "));
								#trim it up (important)
								$tmpThisHeader =~ s/^\s*//;
								$tmpThisHeader =~ s/\s*$//;
							}
							#try to find a space someone after that then
							elsif(index($tmpThisHeader, " ") > -1) {
								$tmpThisFixedHeader .= substr($tmpThisHeader, 0, index($tmpThisHeader, " ")) ."\n\t";
								#remove from tmpThisHeader
								$tmpThisHeader = substr($tmpThisHeader, index($tmpThisHeader, " "));
								#trim it up (important)
								$tmpThisHeader =~ s/^\s*//;
								$tmpThisHeader =~ s/\s*$//;
							}
							else {
								#this is a long line w/ no breaking potential
								$tmpThisFixedHeader .= $tmpThisHeader;
								$tmpThisHeader = "";
							}
						}
						#if there is still content in tmpThisHeader ... append it
						if(length($tmpThisHeader) > 0) {
							$tmpThisFixedHeader .= $tmpThisHeader;
						}
					}
					else {
						$tmpThisFixedHeader = $tmpThisHeader;
					}
					$tmpThisFixedHeader .= "\n";
					$tmpMIMEMessage .= $tmpThisFixedHeader;
				}
				
				#we should alrady have the first space from the last header
				#but fix it here if there are no headers (probably never happens)
				if(scalar(@{$this->{Headers}}) == 0) {
					$tmpMIMEMessage .= "\n";
				}
				
				#add header/body space
				$tmpMIMEMessage .= "\n";
				
				#add preamble
				if($this->{Preamble} ne "") {
					$tmpMIMEMessage .= $this->{Preamble} ."\n";
				}
				
				#add body text
				if(scalar(@{$this->{Parts}}) == 0) {
					#en/decode on the way out
					$this->ParseBody($this->{Body}, 0);
					$tmpMIMEMessage .= $this->{Body};
				}
				else {
					#go through each part
					for(my $i = 0 ; $i < scalar(@{$this->{Parts}}) ; $i++) {
						#add boundary above
						if($this->GetMediaBoundary() ne "") {
							$tmpMIMEMessage .= "\n--". $this->GetMediaBoundary() ."\n";
						}
						
						#add body content
						$tmpMIMEMessage .= $this->{Parts}->[$i]->ToString();
						
						#add boundary above
						if($this->GetMediaBoundary() ne "" && ($i + 1) == scalar(@{$this->{Parts}})) {
							$tmpMIMEMessage .= "\n--". $this->GetMediaBoundary() ."--\n\n";
						}
					}
				}
				
				return $tmpMIMEMessage;
			}
		##<-- End Method :: ToString
		
		####################################################################################
		
		##--> Begin Method :: SaveAs
			sub SaveAs() {
				my $this = shift;
				my $FilePath = shift;
				
				open(FILEHANDLE,">$FilePath") or die $!;
				binmode(FILEHANDLE);
				print FILEHANDLE $this->ToString();
				close(FILEHANDLE);
			}
		##<-- End Method :: SaveAs
		
		####################################################################################
		
		##--> Begin Method :: SaveBodyAs
			sub SaveBodyAs() {
				my $this = shift;
				my $FilePath = shift;
				
				open(FILEHANDLE,">$FilePath") or die $!;
				binmode(FILEHANDLE);
				print FILEHANDLE $this->{Body};
				close(FILEHANDLE);
			}
		##<-- End Method :: SaveBodyAs
		
		####################################################################################
		
		##--> Begin Method :: SaveFileAs
			sub SaveFileAs() {
				my $this = shift;
				my $FilePath = shift;
				
				open(FILEHANDLE,">$FilePath") or die $!;
				binmode(FILEHANDLE);
				print FILEHANDLE $this->{FileBody};
				close(FILEHANDLE);
			}
		##<-- End Method :: SaveFileAs
	}
##<-- End Class :: MIMEMessage

############################################################################################
1;