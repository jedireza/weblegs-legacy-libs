#!/usr/bin/perl
use strict;
use IO::Socket;
use IO::Socket::SSL;
############################################################################################

# /*
# Copyright (C) 2005-2010 WebLegs, Inc.
# This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with this program.
# If not, see <http://www.gnu.org/licenses/>.
# */

############################################################################################

##--> Begin Class :: SocketDriver
	{package SocketDriver;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $this = {
					"Connection" => undef,
					"Host" => undef,
					"Port" => undef,
					"Protocol" => undef,
					"Timeout" => undef
				};
				bless($this, ref($class) || $class);
				
				#set some defaults
				$this->{Connection} = undef;
				$this->{Host} = "";
				$this->{Port} = -1;
				$this->{Protocol} = "tcp"; #ssl/tls/tcp
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin :: Destructor
			sub DESTROY() {
				my $this = shift;
				$this->Close();
			}
		##<-- End :: Destructor
		
		####################################################################################
		
		##--> Begin Method :: Open
			sub Open() {
				my $this = shift;
				
				#make the connection
				$this->{Connection} = IO::Socket::INET->new(
					Proto => "tcp",
					PeerAddr => $this->{Host}, 
					PeerPort => $this->{Port}
				);
				
				#upgrade to ssl
				if($this->{Protocol} eq "ssl" || $this->{Protocol} eq "tls") {
					IO::Socket::SSL->start_SSL($this->{Connection}, SSL_verify_mode => 0);
				}
				
				#verify the connection was made
				unless($this->{Connection}) {
					die("Weblegs.SocketDriver.Open(): Failed connecting to '". $this->{Host} ."'.");
				};
				
				#should we set a timeout?
				if($this->{Timeout}) {
					$this->{Connection}->timeout($this->{Timeout}); 
				}
				
				#setup auto-flush
				$this->{Connection}->autoflush(1);
				
				#try setting the timeout again
				$this->{Connection}->timeout($this->{Timeout});
				
				return;
			}
		##<-- End Method :: Open
		
		####################################################################################
		
		##--> Begin Method :: Close
			sub Close() {
				my $this = shift;
				
				#was the connection ever opened?
				if(!defined($this->{Connection})) {
					return;
				}
				#see if there is an open connection
				elsif($this->IsOpen() == 0) {
					return;
				}
				else {
					close($this->{Connection});
					$this->{Connection} = undef;
				}
			}
		##<-- End Method :: Close
		
		####################################################################################
		
		##--> Begin Method :: ReadBytes
			sub ReadBytes() {
				my $this = shift;
				my $Bytes = shift;
				
				#container
				my $Data = "";
				
				#read x bytes of data from connection
				my $tmpSocket = $this->{Connection};
				$tmpSocket->recv($Data, $Bytes);
				
				return $Data;
			}
		##<-- End Method :: ReadBytes
		
		####################################################################################
		
		##--> Begin Method :: ReadLine
			sub ReadLine() {
				my $this = shift;
				
				#container
				my $Data = "";
				
				#read a line of data from connection
				my $tmpSocket = $this->{Connection};
				$Data = <$tmpSocket>;
				
				#remove \r\n - the developer can add it again if they want
				if($Data) {
					$Data =~ s/\r//;
					$Data =~ s/\n//;
				}
				
				return $Data;
			}
		##<-- End Method :: ReadLine
				 
		####################################################################################
		
		##--> Begin Method :: Read
			sub Read() {
				my $this = shift;
				
				#container
				my $Data = "";
				
				#create easy scalar name
				my $tmpSocket = $this->{Connection};
				
				#read data from socket
				while(<$tmpSocket>) {
					$Data .= $_;
				}
				
				return $Data;
			}
		##<-- End Method :: Read
		
		####################################################################################
		
		##--> Begin Method :: Write
			sub Write() {
				my $this = shift;
				my $Data = shift;
				
				#write data to connection
				my $tmpSocket = $this->{Connection};
				print $tmpSocket $Data
				
				or die(
					"Weblegs.SocketDriver.Write(): Failed to write. (Error: '". $! ."')"
				);
			}
		##<-- End Method :: Write
		
		####################################################################################
		
		##--> Begin Method :: IsOpen
			sub IsOpen() {
				my $this = shift;
				
				if($this->{Connection}) {
					if($this->{Connection}->connected()) {
						return 1;
					}
					else {
						return 0;
					}
				}
				else {
					return 0;
				}
			}
		##<-- End Method :: IsOpen
	}
##<-- End Class :: SocketDriver

############################################################################################
1;