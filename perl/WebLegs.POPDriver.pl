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

##--> Begin Class :: POPDriver
	{package POPDriver;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $this = {
					"Username" => "",
					"Password" => "",
					"Host" => "",
					"Port" => 110,
					"Protocol" => "tcp",
					"Timeout" => 10,
					"Command" => "",
					"Reply" => "",
					"IsError" => 0,
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
					die("Weblegs.POPDriver.Open(): No host specified.");
				}
				
				#make sure the username was specified
				if($this->{Username} eq "") {
					die("Weblegs.POPDriver.Open(): No username specified.");
				}
				
				#make sure the password was specified
				if($this->{Password} eq "") {
					die("Weblegs.POPDriver.Open(): No password specified.");
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
					die("Weblegs.POPDriver.Open(): Failed to connect to host '". $this->{Host} ."'. ". $@);
				}
								
				#read to clear buffer
				$this->{Socket}->ReadLine();
				
				#send username
				$this->Request("USER ". $this->{Username});
				if($this->{IsError}) {
					die("Weblegs.POPDriver.Open(): '". $this->{Command} ."' command was not accepted by the server. (POP Error: ". $this->{Reply} .").");
				}
				
				#send password
				$this->Request("PASS ". $this->{Password});
				if($this->{IsError}) {
					die("Weblegs.POPDriver.Open(): '". $this->{Command} ."' command was not accepted by the server. (POP Error: ". $this->{Reply} .").");
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
				if($this->{IsError}) {
					die("Weblegs.POPDriver.Close(): '". $this->{Command} ."' command was not accepted by the server. (POP Error: ". $this->{Reply} .").");
				}
				
				#close socket
				$this->{Socket}->Close();
			}
		##<-- End Method :: Close
		
		####################################################################################
		
		##--> Begin Method :: GetMessageCount
			sub GetMessageCount() {
				my $this = shift;
				
				$this->Request("STAT");
				if($this->{IsError}) {
					die("Weblegs.POPDriver.GetMessageCount(): '". $this->{Command} ."' command was not accepted by the server. (POP Error: ". $this->{Reply} .").");
				}
				
				my @arrStats = split(/ /, $this->{Reply});
				
				#the second element is the number of messages
				return $arrStats[1] + 0;
			}
		##<-- End Method :: GetMessageCount
		
		####################################################################################
		
		##--> Begin Method :: GetMailBoxSize
			sub GetMailBoxSize() {
				my $this = shift;
				
				$this->Request("STAT");
				if($this->{IsError}) {
					die("Weblegs.POPDriver.GetMailBoxSize(): '". $this->{Command} ."' command was not accepted by the server. (POP Error: ". $this->{Reply} .").");
				}
				
				my @arrStats = split(/ /, $this->{Reply});
				
				#the third element is the number of messages
				return $arrStats[2] + 0;
			}
		##<-- End Method :: GetMailBoxSize
		
		####################################################################################
		
		##--> Begin Method :: GetHeaders
			sub GetHeaders() {
				my $this = shift;
				my $MessageNumber = shift;
				
				#send command and collect response and read until eol
				$this->Request("TOP ". $MessageNumber ." 0");
				if($this->{IsError}) {
					die("Weblegs.POPDriver.GetHeaders(): '". $this->{Command} ."' command was not accepted by the server. (POP Error: ". $this->{Reply} .").");
				}
				
				return $this->{Reply};
			}
		##<-- End Method :: GetHeaders
		
		####################################################################################
		
		##--> Begin Method :: GetMessage
			sub GetMessage() {
				my $this = shift;
				my $MessageNumber = shift;
				
				#send command and collect response and read until eol
				$this->Request("RETR ". $MessageNumber);
				if($this->{IsError}) {
					die("Weblegs.POPDriver.GetMessage(): '". $this->{Command} ."' command was not accepted by the server. (POP Error: ". $this->{Reply} .").");
				}
				
				return $this->{Reply};
			}
		##<-- End Method :: GetMessage
		
		####################################################################################
		
		##--> Begin Method :: DeleteMessage
			sub DeleteMessage() {
				my $this = shift;
				my $MessageNumber = shift;
				
				#send command
				$this->Request("DELE ". $MessageNumber);
				if($this->{IsError}) {
					die("Weblegs.POPDriver.DeleteMessage(): '". $this->{Command} ."' command was not accepted by the server. (POP Error: ". $this->{Reply} .").");
				}
			}
		##<-- End Method :: DeleteMessage
		
		####################################################################################
		
		##--> Begin Method :: Request
			sub Request() {
				my $this = shift;
				my $Command = shift;
				
				#populate the command property
				$this->{Command} = $Command;
				
				#write to connection
				$this->{Socket}->Write($this->{Command} ."\r\n");
				
				#read the response
				my $ReturnData = "";
				my $tmpData = $this->{Socket}->ReadLine();
				
				#check for error
				if(substr($tmpData, 0, 1) eq "-") {
					$this->{IsError} = 1;
					$ReturnData = $tmpData;
				}
				else {
					$this->{IsError} = 0;
					
					#should we read a multi-line response?
					if(
						(substr($this->{Command}, 0, 4) eq "LIST" && !substr($this->{Command}, 0, 5) ne "LIST ") || 
						substr($this->{Command}, 0, 4) eq "RETR" || 
						substr($this->{Command}, 0, 3) eq "TOP" || 
						substr($this->{Command}, 0, 4) eq "UIDL"
					) {
						while($tmpData ne ".") {
							$ReturnData .= $tmpData ."\r\n";
							$tmpData = $this->{Socket}->ReadLine();
						}
					}
					else {
						$ReturnData = $tmpData;
					}
				}
				
				#populate reply message
				$this->{Reply} = $ReturnData;
				
				#return the reply message (easier to dev w/)
				return $this->{Reply};
			}
		##<-- End Method :: Request
	}
##<-- End Class :: POPDriver

############################################################################################
1;