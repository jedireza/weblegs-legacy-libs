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

##--> Begin Class :: SMTPDriver
	{package SMTPDriver;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $this = {
					"Username" => "",
					"Password" => "",
					"Host" => "",
					"Port" => 25,
					"Protocol" => "tcp", #ssl/tls/tcp
					"Timeout" => 10,
					"Annoucement" => "",
					"ReplyCode" => -1,
					"ReplyText" => "",
					"Reply" => "",
					"Command" => "",
					"Socket" => SocketDriver->new()
				};
				bless($this, ref($class) || $class);
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: Open
			sub Open() {
				my $this = shift;
				
				#make sure we're not already connected
				if($this->{Socket}->IsOpen()) {
					return;
				}
				
				#make sure the host was specified
				if($this->{Host} eq "") {
					die("Weblegs.SMTPDriver.Open(): No host specified.");
				}
				
				#attempt to connect
				$this->{Socket}->{Host} = $this->{Host};
				$this->{Socket}->{Port} = $this->{Port};
				$this->{Socket}->{Protocol} = $this->{Protocol};
				$this->{Socket}->{Timeout} = $this->{Timeout};
				eval {
					$this->{Socket}->Open();
				};
				if($@) {
					die("Weblegs.SMTPDriver.Open(): Failed to connect to host. ". $@);
				}
				
				#retrieve announcements (also clears the response from socket)
				$this->{Annoucement} = $this->{Socket}->ReadLine();
				
				#try "EHLO" command first
				$this->Request("EHLO ". $this->{Host});
				
				if($this->{ReplyCode} != 250) {
					#try "HELO" now
					$this->Request("HELO ". $this->{Host});
					if($this->{ReplyCode} != 250) {
						die("Weblegs.SMTPDriver.Open(): 'HELO' and 'EHLO' command(s) were not accepted by the server (SMTP Error Number: ". $this->{ReplyCode} .". SMTP Error: ". $this->{ReplyText} ."). Full Text: ". $this->{Reply} .").");
					}
				}
				
				#if username is not blank this implies use of authentication
				if($this->{Username} ne "") {
					if($this->Authenticate("AUTH LOGIN") == 0) {
						if($this->Authenticate("AUTH PLAIN") == 0) {
							if($this->Authenticate("AUTH CRAM-MD5") == 0) {
								die("Weblegs.SMTPDriver.Open(): 'AUTH LOGIN, AUTH PLAIN & AUTH CRAM-MD5' commands were not accepted by the server (SMTP Error Number: ". $this->{ReplyCode} .". SMTP Error: ". $this->{ReplyText} ." Full Text: ". $this->{Reply} .").");
							}
						}
					}
				}
			}
		##<-- End Method :: Open
		
		####################################################################################
		
		##--> Begin Method :: Close
			sub Close() {
				my $this = shift;
				
				#see if there is an open connection
				if(!$this->{Socket}->IsOpen()) {
					return;
				}
				
				#finalize session
				$this->Request("QUIT");
				if($this->{ReplyCode} != 221) {
					die("Weblegs.SMTPDriver.Close(): '". $this->{Command} ."' command was not accepted by the server (SMTP Error Number: ". $this->{ReplyCode} .". SMTP Error: ". $this->{ReplyText} .". Full Text: ". $this->{Reply} .").");
				}
				
				#close socket
				$this->{Socket}->Close();
			}
		##<-- End Method :: Close
		
		####################################################################################
		
		##--> Begin Method :: Authenticate
			sub Authenticate() {
				my $this = shift;
				my $Command = shift;
				
				my $Request = "";
				if($Command eq "AUTH CRAM-MD5") {
					#start authentication
					$this->Request("AUTH CRAM-MD5");
					
					if($this->{ReplyCode} != 334) {
						return 0;
					}
					
					#begin generate hmac md5 hash
						my $Data = Codec::Base64Decode($this->{ReplyText});
						my $Key = $this->{Password};
						my $Digest = Codec::HMACMD5Encrypt($Key, $Data);
					#end generate hmac md5 hash
					
					$Request = Codec::Base64Encode($this->{Username} ." ". $Digest);
					$Request =~ s/^\s*//;
					$Request =~ s/\s*$//;
					
					$this->Request($Request);
					
					if($this->{ReplyCode} != 235) {
						return 0;
					}
			
					#everything went through
					return 1;
				}
				#- - - - - - - - - - - - - -#
				elsif($Command eq "AUTH LOGIN") {
					#start authentication
					$this->Request("AUTH LOGIN");
					if($this->{ReplyCode} != 334) {
						return 0;
					}
					
					#send encoded username
					$Request = Codec::Base64Encode($this->{Username});
					$Request =~ s/^\s*//;
					$Request =~ s/\s*$//;
					$this->Request($Request);
					if($this->{ReplyCode} != 334) {
						return 0;
					}
					
					#send encoded password
					my $Request = Codec::Base64Encode($this->{Password});
					$Request =~ s/^\s*//;
					$Request =~ s/\s*$//;
					$this->Request($Request);
					if($this->{ReplyCode} != 235) {
						return 0;
					}
					
					#everything went through
					return 1;
				}
				#- - - - - - - - - - - - - -#
				elsif($Command eq "AUTH PLAIN") {
					#start authentication
					$this->Request("AUTH PLAIN");
					
					if($this->{ReplyCode} != 334) {
						return 0;
					}
					
					$Request = Codec::Base64Encode(chr(0) . $this->{Username} . chr(0) . $this->{Password});
					$Request =~ s/^\s*//;
					$Request =~ s/\s*$//;
					$this->Request($Request);
					
					if($this->{ReplyCode} != 235) {
						return 0;
					}
					
					#everything went through
					return 1;
				}
				
				#didn't make it
				return 0;
			}
		##<-- End Method :: Authenticate
		
		####################################################################################
		
		##--> Begin Method :: SetFrom
			sub SetFrom() {
				my $this = shift;
				my $FromAddress = shift;
				
				$this->Request("MAIL FROM:<". $FromAddress .">");
				if($this->{ReplyCode} != 250) {
					die("Weblegs.SMTPDriver.SetFrom(): '". $this->{Command} ."' command was not accepted by the server (SMTP Error Number: ". $this->{ReplyCode} .". SMTP Error: ". $this->{ReplyText} .". Full Text: ". $this->{Reply} .").");
				}
			}
		##<-- End Method :: SetFrom
		
		####################################################################################
		
		##--> Begin Method :: AddRecipient
			sub AddRecipient() {
				my $this = shift;
				my $EmailAddress = shift;
				
				$this->Request("RCPT TO:<". $EmailAddress .">");
				if($this->{ReplyCode} != 251 && $this->{ReplyCode} != 250) {
					die("Weblegs.SMTPDriver.AddRecipient(): '". $this->{Command} ."' command was not accepted by the server (SMTP Error Number: ". $this->{ReplyCode} .". SMTP Error: ". $this->{ReplyText} .". Full Text: ". $this->{Reply} .").");
				}
			}
		##<-- End Method :: AddRecipient
		
		####################################################################################
		
		##--> Begin Method :: Send
			sub Send() {
				my $this = shift;
				my $Data = shift;
				
				#tell the server to get ready
				$this->Request("DATA");
				if($this->{ReplyCode} != 354) {
					die("Weblegs.SMTPDriver.Send(): '". $this->{Command} ."' command was not accepted by the server (SMTP Error Number: ". $this->{ReplyCode} .". SMTP Error: ". $this->{ReplyText} .". Full Text: ". $this->{Reply} .").");		
				}
				
				#split up the data
				my @arrMessageData = split(/\n/, $Data);
				
				#write lines to connection
				for(my $i = 0 ; $i < scalar(@arrMessageData) ; $i++) {
					$this->{Socket}->Write($arrMessageData[$i] ."\r\n");
				}
				
				#finalize DATA command
				$this->Request("\r\n.");
				if($this->{ReplyCode} != 250) {
					die("Weblegs.SMTPDriver.Send(): '". $this->{Command} ."' command was not accepted by the server (SMTP Error Number: ". $this->{ReplyCode} .". SMTP Error: ". $this->{ReplyText} .". Full Text: ". $this->{Reply} .").");
				}
			}
		##<-- End Method :: Send
		
		####################################################################################
		
		##--> Begin Method :: Request
			sub Request() {
				my $this = shift;
				my $Command = shift;
				
				#clear the last reply
				$this->{Reply} = "";
				$this->{ReplyText} = "";
				$this->{ReplyCode} = -1;
				
				#populate the command property
				$this->{Command} = $Command;
				
				#write to connection
				$this->{Socket}->Write($this->{Command} ."\r\n");
				
				#get reply
				my $Line = "";
				while($Line = $this->{Socket}->ReadLine()) {
					if(substr($Line, 3, 1) eq " ") {
						$this->{Reply} = $Line;
						last;
					}
				}
				
				#parse reply data
				$this->{ReplyText} = substr($this->{Reply}, 4);
				$this->{ReplyCode} = substr($this->{Reply}, 0,3) + 0;
				
				#return the reply message (easier to dev w/)
				return $this->{Reply};
			}
		##<-- End Method :: Request
	}
##<-- End Class :: SMTPDriver

############################################################################################
1;