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

##--> Begin Class :: POPClient
	{package POPClient;
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
					"POPDriver" => POPDriver->new()
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
				
				$this->{POPDriver}->{Username} = $this->{Username};
				$this->{POPDriver}->{Password} = $this->{Password};
				$this->{POPDriver}->{Host} = $this->{Host};
				$this->{POPDriver}->{Port} = $this->{Port};
				$this->{POPDriver}->{Protocol} = $this->{Protocol};
				$this->{POPDriver}->{Timeout} = $this->{Timeout};
				
				#try to connect
				eval {
					$this->{POPDriver}->Open();
				};
				if($@) {
					die("Weblegs.POPClient.Open(): Failed to connect to host '". $this->{Host} ."'. ". $@);
				}
			}
		##<-- End Method :: Open
		
		####################################################################################
		
		##--> Begin Method :: Close
			sub Close() {
				my $this = shift;
				
				#try to close
				eval {
					$this->{POPDriver}->Close();
				};
				if($@) {
					die("Weblegs.POPClient.Close(): Failed to close. ". $@);
				}
			}
		##<-- End Method :: Close
		
		####################################################################################
		
		##--> Begin Method :: GetMessageCount
			sub GetMessageCount() {
				my $this = shift;
				
				my $ReturnValue;
				eval {
					$ReturnValue = $this->{POPDriver}->GetMessageCount();
				};
				if($@) {
					die("Weblegs.POPClient.GetMessageCount(): Failed to get message count. ". $@);
				}
				
				return $ReturnValue;
			}
		##<-- End Method :: GetMessageCount
		
		####################################################################################
		
		##--> Begin Method :: GetMailBoxSize
			sub GetMailBoxSize() {
				my $this = shift;
				
				my $ReturnValue;
				eval {
					$ReturnValue = $this->{POPDriver}->GetMailBoxSize();
				};
				if($@) {
					die("Weblegs.POPClient.GetMailBoxSize(): Failed to get mailbox size. ". $@);
				}
				
				return $ReturnValue;
			}
		##<-- End Method :: GetMailBoxSize
		
		####################################################################################
		
		##--> Begin Method :: DeleteMessage
			sub DeleteMessage() {
				my $this = shift;
				my $MessageNumber = shift;
				
				#try to delete
				eval {
					$this->{POPDriver}->DeleteMessage($MessageNumber);
				};
				if($@) {
					die("Weblegs.POPClient.DeleteMessage(): Failed to delete message #". $MessageNumber .". ". $@);
				}
			}
		##<-- End Method :: DeleteMessage
		
		####################################################################################
		
		##--> Begin Method :: DeleteMessages
			sub DeleteMessages() {
				my $this = shift;
				my $Start = shift;
				my $End = shift;
				
				#overload DeleteMessages()
				if(!defined($Start) && !defined($End)) {
					#get the message count
					my $MessageCount = $this->GetMessageCount();
					
					#are there any messages?
					if($MessageCount > 0) {
						#lets call our other overload
						$Start = 1;
						$End = $MessageCount;
					}
				}
				
				#overload DeleteMessages($Start, $End)
				if($Start > 0 && $End > 0) {
					for(my $i = $Start ; $i <= $End ; $i++) {
						#try to delete
						eval {
							$this->{POPDriver}->DeleteMessage($i);
						};
						if($@) {
							die("Weblegs.POPClient.DeleteMessages(): Failed to delete message #". $i .". ". $@);
						}
					}
				}
			}
		##<-- End Method :: DeleteMessages
		
		####################################################################################
		
		##--> Begin Method :: GetMIMEMessage
			sub GetMIMEMessage() {
				my $this = shift;
				my $MessageNumber = shift;
				
				my $thisMIME = $this->GetMessage($MessageNumber);
				return MIMEMessage->new($thisMIME);
			}
		##<-- End Method :: GetMIMEMessage
		
		####################################################################################
		
		##--> Begin Method :: GetMIMEMessages
			sub GetMIMEMessages() {
				my $this = shift;
				my $Start = shift;
				my $End = shift;
				
				#setup array of MIMEMessages
				my $myMIMEMessages = [];
				
				#overload GetMIMEMessages()
				if(!defined($Start) && !defined($End)) {
					#get the message count
					my $MessageCount = $this->GetMessageCount();
					
					#are there any messages?
					if($MessageCount > 0) {
						#lets call our other overload
						$Start = 1;
						$End = $MessageCount;
					}
				}
				
				#overload GetMIMEMessages($Start, $End)
				if($Start > 0 && $End > 0) {
					for(my $i = $Start ; $i <= $End ; $i++) {
						eval {
							push(@{$myMIMEMessages}, $this->GetMIMEMessage($i));
						};
						if($@) {
							die("Weblegs.POPClient.GetMIMEMessages(): Failed to get message #". $i .". ". $@);
						}
					}
				}
				
				#return
				return $myMIMEMessages;
			}
		##<-- End Method :: GetMIMEMessages
		
		####################################################################################
		
		##--> Begin Method :: GetHeader
			sub GetHeader() {
				my $this = shift;
				my $MessageNumber = shift;
				
				my $ReturnValue;
				eval {
					$ReturnValue = $this->{POPDriver}->GetHeaders($MessageNumber);
				};
				if($@) {
					die("Weblegs.POPClient.GetHeader(): Failed to get headers for message #". $MessageNumber .". ". $@);
				}
				
				return $ReturnValue;
			}
		##<-- End Method :: GetHeader
		
		####################################################################################
		
		##--> Begin Method :: GetHeaders
			sub GetHeaders() {
				my $this = shift;
				my $Start = shift;
				my $End = shift;
				
				#setup array of MIMEMessages
				my $myHeaders = [];
				
				#overload GetHeaders()
				if(!defined($Start) && !defined($End)) {
					#get the message count
					my $MessageCount = $this->GetMessageCount();
					
					#are there any messages?
					if($MessageCount > 0) {
						#lets call our other overload
						$Start = 1;
						$End = $MessageCount;
					}
				}
				
				#overload GetHeaders($Start, $End)
				if($Start > 0 && $End > 0) {
					for(my $i = $Start ; $i <= $End ; $i++) {
						eval {
							push(@{$myHeaders}, $this->GetHeader($i));
						};
						if($@) {
							die("Weblegs.POPClient.GetHeaders(): Failed to get headers for message #". $i .". ". $@);
						}
					}
				}
				
				#return
				return $myHeaders;
			}
		##<-- End Method :: GetHeaders
		
		####################################################################################
		
		##--> Begin Method :: GetMessage
			sub GetMessage() {
				my $this = shift;
				my $MessageNumber = shift;
				
				my $ReturnValue;
				eval {
					$ReturnValue = $this->{POPDriver}->GetMessage($MessageNumber);
				};
				if($@) {
					die("Weblegs.POPClient.GetMessage(): Failed to get message #". $MessageNumber .". ". $@);
				}
				
				return $ReturnValue;
			}
		##<-- End Method :: GetMessage
		
		####################################################################################
		
		##--> Begin Method :: GetMessages
			sub GetMessages() {
				my $this = shift;
				my $Start = shift;
				my $End = shift;
				
				#setup array of MIMEMessages
				my $myMessages = [];
				
				#overload GetMessages()
				if(!defined($Start) && !defined($End)) {
					#get the message count
					my $MessageCount = $this->GetMessageCount();
					
					#are there any messages?
					if($MessageCount > 0) {
						#lets call our other overload
						$Start = 1;
						$End = $MessageCount;
					}
				}
				
				#overload GetMessages($Start, $End)
				if($Start > 0 && $End > 0) {
					for(my $i = $Start ; $i <= $End ; $i++) {
						eval {
							push(@{$myMessages}, $this->GetMessage($i));
						};
						if($@) {
							die("Weblegs.POPClient.GetMessages(): Failed to get message #". $i .". ". $@);
						}
					}
				}
				
				#return
				return $myMessages;
			}
		##<-- End Method :: GetMessages
	}
##<-- End Class :: POPClient

############################################################################################
1;