#!/usr/bin/perl
use strict;
use File::Basename;
use POSIX qw(strftime);
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

##--> Begin Class :: SMTPClient
	{package SMTPClient;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $this = {
					"From" => ["",""], #[address,name]
					"ReplyTo" => ["",""], #[address,name]
					"To" => undef, #[ [address,name] ]
					"CC" => undef, #[ [address,name] ]
					"BCC" => undef, #[ [address,name] ]
					"Priority" => "3",
					"Subject" => "",
					"Message" => "",
					"IsHTML" => 0,
					"Attachments" => undef, #[filename]
					"Host" => "",
					"Port" => 25,
					"Protocol" => "tcp",
					"Timeout" => 10,
					"Username" => "",
					"Password" => "",
					"SMTPDriver" => SMTPDriver->new(),
					"MIMEMessage" => MIMEMessage->new(),
					"ContentTypeList" => undef,
					"OpenedManually" => 0
				};
				bless($this, ref($class) || $class);
				
				#initialize
				$this->{To} = [];
				$this->{CC} = [];
				$this->{BCC} = [];
				$this->{Attachments} = [];
				
				#content type list
				$this->{ContentTypeList} = $this->BuildContentTypeList();
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: Open
			sub Open() {
				my $this = shift;
				
				#setup the SMTPDriver
				$this->{SMTPDriver}->{Host} = $this->{Host};
				$this->{SMTPDriver}->{Port} = $this->{Port};
				$this->{SMTPDriver}->{Protocol} = $this->{Protocol};
				$this->{SMTPDriver}->{Timeout} = $this->{Timeout};
				$this->{OpenedManually} = 1;
				
				eval {
					$this->{SMTPDriver}->Open();
				};
				if($@) {
					die("Weblegs.SMTPClient.Open(): Failed to open connection. ". $@);
				}
			}
		##<-- End Method :: Open
		
		####################################################################################
		
		##--> Begin Method :: Close
			sub Close() {
				my $this = shift;
				
				eval {
					$this->{SMTPDriver}->Close();
				};
				if($@) {
					die("Weblegs.SMTPClient.Close(): Failed to close connection. ". $@);
				}
			}
		##<-- End Method :: Close
		
		####################################################################################
		
		##--> Begin Method :: SetFrom
			sub SetFrom() {
				my $this = shift;
				my $EmailAddress = shift;
				my $Name = shift || "";
				
				$this->{From}->[0] = $EmailAddress;
				$this->{From}->[1] = $Name;
			}
		##<-- End Method :: SetFrom
		
		####################################################################################
		
		##--> Begin Method :: SetReplyTo
			sub SetReplyTo() {
				my $this = shift;
				my $EmailAddress = shift;
				my $Name = shift || "";
				
				$this->{ReplyTo}->[0] = $EmailAddress;
				$this->{ReplyTo}->[1] = $Name;
			}
		##<-- End Method :: SetReplyTo
		
		####################################################################################
		
		##--> Begin Method :: AddTo
			sub AddTo() {
				my $this = shift;
				my $EmailAddress = shift;
				my $Name = shift || "";
				
				push(@{$this->{To}}, [$EmailAddress, $Name]);
			}
		##<-- End Method :: AddTo
		
		####################################################################################
		
		##--> Begin Method :: AddCC
			sub AddCC() {
				my $this = shift;
				my $EmailAddress = shift;
				my $Name = shift || "";
				
				push(@{$this->{CC}}, [$EmailAddress, $Name]);
			}
		##<-- End Method :: AddCC
		
		####################################################################################
		
		##--> Begin Method :: AddBCC
			sub AddBCC() {
				my $this = shift;
				my $EmailAddress = shift;
				my $Name = shift || "";
				
				push(@{$this->{BCC}}, [$EmailAddress, $Name]);
			}
		##<-- End Method :: AddBCC
		
		####################################################################################
		
		##--> Begin Method :: AddHeader
			sub AddHeader() {
				my $this = shift;
				my $Name = shift;
				my $Value = shift;
				
				$this->{MIMEMessage}->AddHeader($Name,$Value);
			}
		##<-- End Method :: AddHeader
		
		####################################################################################
		
		##--> Begin Method :: AttachFile
			sub AttachFile() {
				my $this = shift;
				my $FilePath = shift;
				
				push(@{$this->{Attachments}}, $FilePath);
			}
		##<-- End Method :: AttachFile
		
		####################################################################################
		
		##--> Begin Method :: CompileHeaders
			sub CompileHeaders() {
				my $this = shift;
				
				#add from header
				if($this->{From}->[1] eq "") {
					$this->{MIMEMessage}->AddHeader("From", $this->{From}->[0]);
				}
				else {
					$this->{MIMEMessage}->AddHeader("From", "\"". $this->{From}->[1] ."\" <". $this->{From}->[0] .">");
				}
				
				#add reply to
				if(!defined($this->{ReplyTo})) {
					#do nothing
				}
				elsif($this->{ReplyTo}->[0] ne "" && $this->{ReplyTo}->[1] eq "") {
					$this->{MIMEMessage}->AddHeader("ReplyTo", $this->{ReplyTo}->[0]);
				}
				elsif($this->{ReplyTo}->[0] ne "" && $this->{ReplyTo}->[1] ne "") {
					$this->{MIMEMessage}->AddHeader("ReplyTo", "\"". $this->{ReplyTo}->[1] ."\" <". $this->{ReplyTo}->[0] .">");
				}
				
				#add subject
				$this->{MIMEMessage}->AddHeader("Subject", $this->{Subject});
				
				#add to addresses
				my $ToAddresses = "";
				for(my $i = 0 ; $i < scalar(@{$this->{To}}) ; $i++) {
					if($this->{To}->[$i][1] eq "") {
						$ToAddresses .= $this->{To}->[$i][0];
					}
					else {
						$ToAddresses .= "\"". $this->{To}->[$i][1] ."\" <". $this->{To}->[$i][0] .">";
					}
					
					#add a comma? (,)
					if($i+1 != scalar(@{$this->{To}})) {
						$ToAddresses .= ", ";
					}
				}
				if($ToAddresses ne "") {
					$this->{MIMEMessage}->AddHeader("To", $ToAddresses);
				}
				
				#add cc addresses
				my $CCAddresses = "";
				for(my $i = 0 ; $i < scalar(@{$this->{CC}}) ; $i++) {
					if($this->{CC}->[$i][1] eq "") {
						$CCAddresses .= $this->{CC}->[$i][0];
					}
					else {
						$CCAddresses .= "\"". $this->{CC}->[$i][1] ."\" <". $this->{CC}->[$i][0] .">";
					}
					
					#add a comma? (,)
					if($i+1 != scalar(@{$this->{CC}})) {
						$CCAddresses .= ", ";
					}
				}
				if($CCAddresses ne "") {
					$this->{MIMEMessage}->AddHeader("Cc", $CCAddresses);
				}
				
				#add bcc addresses
				my $BCCAddresses = "";
				for(my $i = 0 ; $i < scalar(@{$this->{BCC}}) ; $i++) {
					if($this->{BCC}->[$i][1] eq "") {
						$BCCAddresses .= $this->{BCC}->[$i][0];
					}
					else {
						$BCCAddresses .= "\"". $this->{BCC}->[$i][1] ."\" <". $this->{BCC}->[$i][0] .">";
					}
					
					#add a comma? (,)
					if($i+1 != scalar(@{$this->{BCC}})) {
						$BCCAddresses .= ", ";
					}
				}
				if($BCCAddresses ne "") {
					$this->{MIMEMessage}->AddHeader("Bcc", $BCCAddresses);
				}
				
				#add date
				my $Date = gmtime;
				$this->{MIMEMessage}->AddHeader("Date", POSIX::strftime("%a, %d %b %Y %H:%M:%S %z", localtime(time())));
				
				#add message-id
				my $RandomID = Codec::Base64Encode(time * rand(time));
				$RandomID =~ s/^\s*//;
				$RandomID =~ s/\s*$//;
				$RandomID =~ s/=//;
				$this->{MIMEMessage}->AddHeader("Message-Id", "<". $RandomID ."\@". $this->{Host} .">");
				
				#add priority
				$this->{MIMEMessage}->AddHeader("X-Priority", $this->{Priority});
				
				#add x-mailer
				$this->{MIMEMessage}->AddHeader("X-Mailer", "WebLegs.SMTPClient (www.weblegs.org)");
				
				#add mime version
				$this->{MIMEMessage}->AddHeader("MIME-Version", "1.0");
			}
		##<-- End Method :: CompileHeaders
		
		####################################################################################
		
		##--> Begin Method :: CompileMessage
			sub CompileMessage() {
				my $this = shift;
				
				#setup our *empty* MIME objects for alternative message
				my $AlternativeMessage;
				my $HTMLMessage;
				my $TextMessage;
				
				#create the main boundry for this message (not always used)
				my $RandomID = Codec::Base64Encode(time * rand(time));
				$RandomID =~ s/^\s*//;
				$RandomID =~ s/\s*$//;
				$RandomID =~ s/=//;
				my $MainBoundary = "----=_Part_". $RandomID;
				
				#lets figure out how to handle this message
				if($this->{IsHTML} == 0 && scalar(@{$this->{Attachments}}) == 0) {
					#this is just a plain text message
					$this->{MIMEMessage}->AddHeader("Content-Type", "text/plain;\n\tcharset=US-ASCII;");
					$this->{MIMEMessage}->AddHeader("Content-Transfer-Encoding", "quoted-printable");
					#put the content into the message body
					$this->{MIMEMessage}->{Body} = $this->{Message};
				}
				elsif($this->{IsHTML} == 1 && scalar(@{$this->{Attachments}}) == 0) {
					#this is an alternative html/text based message
					$this->{MIMEMessage}->AddHeader("Content-Type", "multipart/alternative;\n\tboundary=\"". $MainBoundary ."\"");
					$this->{MIMEMessage}->{Preamble} = "This is a multi-part message in MIME format.";
					
					#build the html part of this message
					$HTMLMessage = MIMEMessage->new();
					$HTMLMessage->AddHeader("Content-Type", "text/html; charset=US-ASCII;");
					$HTMLMessage->AddHeader("Content-Transfer-Encoding", "quoted-printable");
					$HTMLMessage->{Body} = $this->{Message};
					
					#build the text part of this message
					$TextMessage = MIMEMessage->new();
					$TextMessage->AddHeader("Content-Type", "text/plain; charset=US-ASCII;");
					$TextMessage->AddHeader("Content-Transfer-Encoding", "quoted-printable");
					$TextMessage->{Body} = $this->HTMLToText($this->{Message});
					
					#add text/html parts to the main message
					push(@{$this->{MIMEMessage}->{Parts}}, $TextMessage);
					push(@{$this->{MIMEMessage}->{Parts}}, $HTMLMessage);
				}
				elsif(scalar(@{$this->{Attachments}}) != 0) {
					#this message is mixed
					$this->{MIMEMessage}->AddHeader("Content-Type", "multipart/mixed;\n\tboundary=\"". $MainBoundary ."\"");
					$this->{MIMEMessage}->{Preamble} = "This is a multi-part message in MIME format.";
					
					#is this an alternative message?
					if($this->{IsHTML} == 1) {
						#create the alternative boundry for this message
						$RandomID = Codec::Base64Encode(time * rand(time));
						$RandomID =~ s/^\s*//;
						$RandomID =~ s/\s*$//;
						$RandomID =~ s/=//;
						my $AlternativeBoundary = "----=_Part_". $RandomID;
						
						#build the Alternative part of this message
						$AlternativeMessage = MIMEMessage->new();
						$AlternativeMessage->AddHeader("Content-Type", "multipart/alternative;\n\tboundary=\"". $AlternativeBoundary ."\"");
						
						#build the html part of this message
						$HTMLMessage = MIMEMessage->new();
						$HTMLMessage->AddHeader("Content-Type", "text/html; charset=US-ASCII;");
						$HTMLMessage->AddHeader("Content-Transfer-Encoding", "quoted-printable");
						$HTMLMessage->{Body} = $this->{Message};
						
						#build the text part of this message
						$TextMessage = MIMEMessage->new();
						$TextMessage->AddHeader("Content-Type", "text/plain; charset=US-ASCII;");
						$TextMessage->AddHeader("Content-Transfer-Encoding", "quoted-printable");
						$TextMessage->{Body} = $this->HTMLToText($this->{Message});
						
						#add html/text parts to the alternative message
						push(@{$AlternativeMessage->{Parts}}, $TextMessage);
						push(@{$AlternativeMessage->{Parts}}, $HTMLMessage);
						
						#add the alternative message to the main message
						push(@{$this->{MIMEMessage}->{Parts}}, $AlternativeMessage);
					}
					else {
						#build a plain text message message
						$TextMessage = MIMEMessage->new();
						$TextMessage->AddHeader("Content-Type", "text/plain; charset=US-ASCII;");
						$TextMessage->AddHeader("Content-Transfer-Encoding", "quoted-printable");
						$TextMessage->{Body} = $this->{Message};
						
						#add the PlainTextMessage to the main message
						push(@{$this->{MIMEMessage}->{Parts}}, $TextMessage);
					}
					
					#add attachments to the main message
					for(my $i = 0 ; $i < scalar(@{$this->{Attachments}}) ; $i++) {
						#get file info
						my $FilePath = $this->{Attachments}->[$i];
						my ($FileName, $Path, $Suffix) = File::Basename::fileparse($FilePath);
						my $FileExtension = "";
						if($FileName =~ m/\.(.*?)$/) {
							$FileExtension = $1;
						}
						
						#get file data
						open(SOURCE, "<", $FilePath) or die("WebLegs.SMTPClient.CompileMessage(): File not found or not able to access.");
						my $thisByteData = undef;
						while(<SOURCE>){$thisByteData .= $_;}
						close SOURCE;
						
						#setup new MIME message for this attachment
						my $AttachmentMessage = MIMEMessage->new();
						$AttachmentMessage->AddHeader("Content-Type", $this->GetContentTypeByExtension($FileExtension) .";\n\tname=\"". $FileName ."\"");
						$AttachmentMessage->AddHeader("Content-Transfer-Encoding", "base64");
						$AttachmentMessage->AddHeader("Content-Disposition", "attachment;\n\tfilename=\"". $FileName ."\"");
						$AttachmentMessage->{FileBody} = $thisByteData;
						
						#add this attachment to the main message
						push(@{$this->{MIMEMessage}->{Parts}}, $AttachmentMessage);
					}
				}
			}
		##<-- End Method :: CompileMessage
		
		####################################################################################
		
		##--> Begin Method :: Send
			sub Send() {
				my $this = shift;
				
				#make sure host was supplied
				if($this->{Host} eq "") {
					die("Weblegs.SMTPClient.Send(): No host specified.");
				}
				
				#assign credentials if username is supplied
				if($this->{Username} ne "") {
					$this->{SMTPDriver}->{Username} = $this->{Username};
					$this->{SMTPDriver}->{Password} = $this->{Password};
				}
				
				#should we open the socket for them?
				if($this->{OpenedManually} == 0) {
					#setup the SMTPDriver
					$this->{SMTPDriver}->{Host} = $this->{Host};
					$this->{SMTPDriver}->{Port} = $this->{Port};
					$this->{SMTPDriver}->{Timeout} = $this->{Timeout};
					$this->{SMTPDriver}->{Protocol} = $this->{Protocol};
					
					#open up
					eval {
						$this->{SMTPDriver}->Open();
					};
					if($@) {
						die("Weblegs.SMTPClient.Send(): Could not open connection. ". $@);
					}
				}
				
				#set the from address
				$this->{SMTPDriver}->SetFrom($this->{From}->[0]);
				
				#add recipients
					#to addresses
					for(my $i = 0 ; $i < scalar(@{$this->{To}}) ; $i++) {
						$this->{SMTPDriver}->AddRecipient($this->{To}->[$i][0]);
					}
					
					#cc addresses
					for(my $i = 0 ; $i < scalar(@{$this->{CC}}) ; $i++) {
						$this->{SMTPDriver}->AddRecipient($this->{CC}->[$i][0]);
					}
					
					#bcc addresses
					for(my $i = 0 ; $i < scalar(@{$this->{BCC}}) ; $i++) {
						$this->{SMTPDriver}->AddRecipient($this->{BCC}->[$i][0]);
					}
				#end add recipients
				
				#prepare headers
				$this->CompileHeaders();
				
				#prepair message
				$this->CompileMessage();
				
				#try sending
				eval {
					$this->{SMTPDriver}->Send($this->{MIMEMessage}->ToString());
				};
				if($@) {
					die("Weblegs.SMTPClient.Send(): Failed to send message. ". $@);
				}
				
				#should we close the socket for them?
				if($this->{OpenedManually} == 0) {
					$this->Close();
					$this->Reset();
				}
			}
		##<-- End Method :: Send
		
		####################################################################################
		
		##--> Begin Method :: Reset
			sub Reset() {
				my $this = shift;
				
				$this->{From} = [];
				$this->{ReplyTo} = [];
				$this->{To} = [];
				$this->{CC} = [];
				$this->{BCC} = [];
				$this->{Priority} = "3";
				$this->{Subject} = "";
				$this->{Message} = "";
				$this->{IsHTML} = 0;
				$this->{Attachments} = [];
				$this->{MIMEMessage} = MIMEMessage->new();
			}
		##<-- End Method :: Reset
		
		####################################################################################
		
		##--> Begin Method :: GetContentTypeByExtension
			sub GetContentTypeByExtension() {
				my $this = shift;
				my $Extension = shift;
				
				if($this->{ContentTypeList}->{$Extension}) {
					return $this->{ContentTypeList}->{$Extension};
				}
				else {
					return "application/x-unknown-content-type";
				}
			}
		##<-- End Method :: GetContentTypeByExtension
		
		####################################################################################
		
		##--> Begin Method :: HTMLToText
			sub HTMLToText() {
				my $this = shift;
				my $HTML = shift;
				
				#keep copy of HTML
				my $TextOnly = $HTML;
				
				#trim it down
				$TextOnly =~ s/^\s*//;
				$TextOnly =~ s/\s*$//;
				
				#make custom mods to HTML
					#seperators (80 chars on purpose)
					my $HorizontalRule = "--------------------------------------------------------------------------------";
					my $TableTopBottom = "********************************************************************************";
					
					#remove all line breaks
					$TextOnly =~ s/\r//g;
					$TextOnly =~ s/\n//g;
					
					#remove head
					$TextOnly =~ s/<\s*(head|HEAD).*?\/(head|HEAD)>//g;
					
					#heading tags
					$TextOnly =~ s/<\/*(h|H)(1|2|3|4|5|6).*?>/\n/g;
					
					#paragraph tags
					$TextOnly =~ s/<(p|P).*?>/\n\n/g;
					
					#div tags
					$TextOnly =~ s/<(div|DIV).*?>/\n\n/g;
					
					#br tags
					$TextOnly =~ s/<(br|BR|bR|Br).*?>/\n/g;
					
					#hr tags
					$TextOnly =~ s/<(hr|HR|hR|Hr).*?>/\n$HorizontalRule/g;
					
					#table tags
					$TextOnly =~ s/<\/*(table|TABLE).*?>/\n$TableTopBottom/g;
					$TextOnly =~ s/<(tr|TR|tR|Tr).*?>/\n/g;
					$TextOnly =~ s/<\/(td|TD|tD|Td).*?>/\t/g;
					
					#list tags
					$TextOnly =~ s/<\/*(ol|OL|oL|Ol).*?>/\n/g;
					$TextOnly =~ s/<\/*(ul|UL|uL|Ul).*?>/\n/g;
					$TextOnly =~ s/<(li|LI|lI|Li).*?>/\n\t\(\*\) /g;
					
					#lets not lose our links
					$TextOnly =~ s/<a href="(.*?)">(.*?)<\/a>/$2 [$1]/g;
					$TextOnly =~ s/<a HREF="(.*?)">(.*?)<\/a>/$2 [$1]/g;
					
					#strip the remaining HTML out
					$TextOnly =~ s/<(.|\n)*?>//g;
					
					#loop over each line and truncate lines more than 74 characters
					my $tmpFixedText = "";
					my @TextOnlyLines = split(/\n/, $TextOnly);
					for(my $i = 0 ; $i < scalar(@TextOnlyLines) ; $i++) {
						my $tmpThisFixedLine = "";
						if(length($TextOnlyLines[$i]) > 74) {
							while(length($TextOnlyLines[$i]) > 74) {
								#find the next space character furthest to the end (or the 74th character)
								if(rindex(substr($TextOnlyLines[$i], 0, 73), " ") > -1) {
									$tmpThisFixedLine .= substr($TextOnlyLines[$i], 0, rindex(substr($TextOnlyLines[$i], 0, 73), " ")) ."\n";
									#remove from TextOnlyLines[i]
									$TextOnlyLines[$i] = substr($TextOnlyLines[$i], rindex(substr($TextOnlyLines[$i], 0, 73), " "));
									#trim it up (important)
									$TextOnlyLines[$i] =~ s/^\s*//;
									$TextOnlyLines[$i] =~ s/\s*$//;
								}
								else {
									#if there is a space in this line after the 74th character lets break at the first chance we get and continue
									if(index($TextOnlyLines[$i], " ") > -1) {
										$tmpThisFixedLine .= substr($TextOnlyLines[$i], 0, index($TextOnlyLines[$i], " ")+1) ."\n";
										$TextOnlyLines[$i] = substr($TextOnlyLines[$i], index($TextOnlyLines[$i], " ")+1);
									}
									else {
										#this is a long line w/ no breaking potential
										$tmpThisFixedLine .= $TextOnlyLines[$i];
										$TextOnlyLines[$i] = "";
									}
								}
							}
							#if there is still content in TextOnlyLines[i] ... append it w/ a new line
							if(length($TextOnlyLines[$i]) > 0) {
								$tmpThisFixedLine .= $TextOnlyLines[$i];
							}
						}
						else {
							$tmpThisFixedLine = $TextOnlyLines[$i];
						}
						$tmpThisFixedLine .= "\n";
						$tmpFixedText .= $tmpThisFixedLine;
					}
					$TextOnly = $tmpFixedText;
				#end make custom mods to HTML
				
				return $TextOnly;
			}
		##<-- End Method :: HTMLToText
		
		####################################################################################
		
		##--> Begin Method :: BuildContentTypeList
			sub BuildContentTypeList() {
				my $this = shift;
				
				my %tmpContentTypeList = ();
				$tmpContentTypeList{"hqx"} = "application/mac-binhex40";
				$tmpContentTypeList{"cpt"} = "application/mac-compactpro";
				$tmpContentTypeList{"doc"} = "application/msword";
				$tmpContentTypeList{"bin"} = "application/macbinary";
				$tmpContentTypeList{"dms"} = "application/octet-stream";
				$tmpContentTypeList{"lha"} = "application/octet-stream";
				$tmpContentTypeList{"lzh"} = "application/octet-stream";
				$tmpContentTypeList{"exe"} = "application/octet-stream";
				$tmpContentTypeList{"class"} = "application/octet-stream";
				$tmpContentTypeList{"psd"} = "application/octet-stream";
				$tmpContentTypeList{"so"} = "application/octet-stream";
				$tmpContentTypeList{"sea"} = "application/octet-stream";
				$tmpContentTypeList{"dll"} = "application/octet-stream";
				$tmpContentTypeList{"oda"} = "application/oda";
				$tmpContentTypeList{"pdf"} = "application/pdf";
				$tmpContentTypeList{"ai"} = "application/postscript";
				$tmpContentTypeList{"eps"} = "application/postscript";
				$tmpContentTypeList{"ps"} = "application/postscript";
				$tmpContentTypeList{"smi"} = "application/smil";
				$tmpContentTypeList{"smil"} = "application/smil";
				$tmpContentTypeList{"mif"} = "application/vnd.mif";
				$tmpContentTypeList{"xls"} = "application/vnd.ms-excel";
				$tmpContentTypeList{"ppt"} = "application/vnd.ms-powerpoint";
				$tmpContentTypeList{"wbxml"} = "application/vnd.wap.wbxml";
				$tmpContentTypeList{"wmlc"} = "application/vnd.wap.wmlc";
				$tmpContentTypeList{"dcr"} = "application/x-director";
				$tmpContentTypeList{"dir"} = "application/x-director";
				$tmpContentTypeList{"dxr"} = "application/x-director";
				$tmpContentTypeList{"dvi"} = "application/x-dvi";
				$tmpContentTypeList{"gtar"} = "application/x-gtar";
				$tmpContentTypeList{"php"} = "application/x-httpd-php";
				$tmpContentTypeList{"php4"} = "application/x-httpd-php";
				$tmpContentTypeList{"php3"} = "application/x-httpd-php";
				$tmpContentTypeList{"phtml"} = "application/x-httpd-php";
				$tmpContentTypeList{"phps"} = "application/x-httpd-php-source";
				$tmpContentTypeList{"js"} = "application/x-javascript";
				$tmpContentTypeList{"swf"} = "application/x-shockwave-flash";
				$tmpContentTypeList{"sit"} = "application/x-stuffit";
				$tmpContentTypeList{"tar"} = "application/x-tar";
				$tmpContentTypeList{"tgz"} = "application/x-tar";
				$tmpContentTypeList{"xhtml"} = "application/xhtml+xml";
				$tmpContentTypeList{"xht"} = "application/xhtml+xml";
				$tmpContentTypeList{"zip"} = "application/zip";
				$tmpContentTypeList{"data-id"} = "audio/midi";
				$tmpContentTypeList{"midi"} = "audio/midi";
				$tmpContentTypeList{"mpga"} = "audio/mpeg";
				$tmpContentTypeList{"mp2"} = "audio/mpeg";
				$tmpContentTypeList{"mp3"} = "audio/mpeg";
				$tmpContentTypeList{"aif"} = "audio/x-aiff";
				$tmpContentTypeList{"aiff"} = "audio/x-aiff";
				$tmpContentTypeList{"aifc"} = "audio/x-aiff";
				$tmpContentTypeList{"ram"} = "audio/x-pn-realaudio";
				$tmpContentTypeList{"rm"} = "audio/x-pn-realaudio";
				$tmpContentTypeList{"rpm"} = "audio/x-pn-realaudio-plugin";
				$tmpContentTypeList{"ra"} = "audio/x-realaudio";
				$tmpContentTypeList{"rv"} = "video/vnd.rn-realvideo";
				$tmpContentTypeList{"wav"} = "audio/x-wav";
				$tmpContentTypeList{"bmp"} = "image/bmp";
				$tmpContentTypeList{"gif"} = "image/gif";
				$tmpContentTypeList{"jpeg"} = "image/jpeg";
				$tmpContentTypeList{"jpg"} = "image/jpeg";
				$tmpContentTypeList{"jpe"} = "image/jpeg";
				$tmpContentTypeList{"png"} = "image/png";
				$tmpContentTypeList{"tiff"} = "image/tiff";
				$tmpContentTypeList{"tif"} = "image/tiff";
				$tmpContentTypeList{"css"} = "text/css";
				$tmpContentTypeList{"html"} = "text/html";
				$tmpContentTypeList{"htm"} = "text/html";
				$tmpContentTypeList{"shtml"} = "text/html";
				$tmpContentTypeList{"txt"} = "text/plain";
				$tmpContentTypeList{"text"} = "text/plain";
				$tmpContentTypeList{"log"} = "text/plain";
				$tmpContentTypeList{"rtx"} = "text/richtext";
				$tmpContentTypeList{"rtf"} = "text/rtf";
				$tmpContentTypeList{"xml"} = "text/xml";
				$tmpContentTypeList{"xsl"} = "text/xml";
				$tmpContentTypeList{"mpeg"} = "video/mpeg";
				$tmpContentTypeList{"mpg"} = "video/mpeg";
				$tmpContentTypeList{"mpe"} = "video/mpeg";
				$tmpContentTypeList{"qt"} = "video/quicktime";
				$tmpContentTypeList{"mov"} = "video/quicktime";
				$tmpContentTypeList{"avi"} = "video/x-msvideo";
				$tmpContentTypeList{"movie"} = "video/x-sgi-movie";
				$tmpContentTypeList{"word"} = "application/msword";
				$tmpContentTypeList{"xl"} = "application/excel";
				$tmpContentTypeList{"eml"} = "message/rfc822";
				return \%tmpContentTypeList;
			}
		##<-- End Method :: BuildContentTypeList
	}
##<-- End Class :: SMTPClient

############################################################################################
1;