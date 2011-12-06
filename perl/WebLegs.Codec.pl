#!/usr/bin/perl
use strict;
use HTML::Entities;
use MIME::Base64;
use MIME::QuotedPrint;
use Digest::HMAC_MD5 qw(hmac_md5_hex);
use Digest::MD5 qw(md5_hex);
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

##--> Begin Class :: Codec
	{package Codec;
		##--> Begin :: Constructor
			#no constructor
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: URLEncode
			sub URLEncode($) {
				my $Input = shift;
				
				my $Output = $Input;
				$Output =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
				return $Output;
			}
		##<-- End Method :: URLEncode
		
		####################################################################################
		
		##--> Begin Method :: URLDecode
			sub URLDecode($) {
				my $Input = shift;
				
				my $Output = $Input;
				$Output =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
				$Output =~ s/\+/" "/seg;
				return $Output;
			}
		##<-- End Method :: URLDecode
		
		####################################################################################
		
		##--> Begin Method :: HTMLEncode
			sub HTMLEncode($) {
				my $Input = shift;
				return HTML::Entities::encode($Input);
			}
		##<-- End Method :: HTMLEncode
		
		####################################################################################
		
		##--> Begin Method :: HTMLDecode
			sub HTMLDecode($) {
				my $Input = shift;
				return HTML::Entities::decode($Input);
			}
		##<-- End Method :: HTMLDecode
		
		####################################################################################
		
		##--> Begin Method :: XMLEncode
			sub XMLEncode($) {
				my $Input = shift;
				$Input =~ s/&/&amp;/g;
				$Input =~ s/</&lt;/g;
				$Input =~ s/>/&gt;/g;
				$Input =~ s/"/&quote;/g; #" code coloring comment
				$Input =~ s/'/&apos;/g; #' code coloring comment
				return $Input;
			}
		##<-- End Method :: XMLEncode
		
		####################################################################################
		
		##--> Begin Method :: XMLDecode
			sub XMLDecode($) {
				my $Input = shift;
				$Input =~ s/&amp;/&/g;
				$Input =~ s/&lt;/</g;
				$Input =~ s/&gt;/>/g;
				$Input =~ s/&quote;/"/g; #" code coloring comment
				$Input =~ s/&apos;/'/g; #' code coloring comment
				return $Input;
			}
		##<-- End Method :: XMLDecode
		
		####################################################################################
		
		##--> Begin Method :: Base64Encode
			sub Base64Encode($) {
				my $Input = shift;
				return MIME::Base64::encode($Input);
			}
		##<-- End Method :: Base64Encode
		
		####################################################################################
		
		##--> Begin Method :: Base64Decode
			sub Base64Decode($) {
				my $Input = shift;
				return MIME::Base64::decode($Input);
			}
		##<-- End Method :: Base64Decode
		
		####################################################################################
		
		##--> Begin Method :: QuotedPrintableEncode
			sub QuotedPrintableEncode($) {
				my $Input = shift;
				return MIME::QuotedPrint::encode($Input);
			}
		##<-- End Method :: QuotedPrintableEncode
		
		####################################################################################
		
		##--> Begin Method :: QuotedPrintableDecode
			sub QuotedPrintableDecode($) {
				my $Input = shift;
				return MIME::QuotedPrint::decode($Input);
			}
		##<-- End Method :: QuotedPrintableDecode
		
		####################################################################################
		
		##--> Begin Method :: MD5Encrypt
			sub MD5Encrypt($) {
				my $Input = shift;
				return Digest::MD5::md5_hex($Input);
			}
		##<-- End Method :: MD5Encrypt
		
		####################################################################################
		
		##--> Begin Method :: HMACMD5Encrypt
			sub HMACMD5Encrypt($$) {
				my $Key = shift;
				my $Input = shift;
				return Digest::HMAC_MD5::hmac_md5_hex($Input, $Key);
			}
		##<-- End Method :: HMACMD5Encrypt
	}
##<-- End Class :: Codec

############################################################################################
1;