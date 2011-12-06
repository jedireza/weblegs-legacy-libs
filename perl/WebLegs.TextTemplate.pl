#!/usr/bin/perl
use strict;
use XML::LibXSLT;
use XML::LibXML;
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

##--> Begin Class :: TextTemplate
	{package TextTemplate;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $this = {
					"Source" => "",
					"DTD" => ""
				};
				bless($this, ref($class) || $class);
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: LoadFile
			sub LoadFile() {
				my $this = shift;
				my $Path = shift;
				my $RootPath = shift;
				
				#LoadFile(Path) overload
				if(defined($Path) && !defined($RootPath)) {
					if(-e $Path) {
						open(SOURCE, "<", $Path) or die("WebLegs.TextTemplate.FilePath(): File not found or not able to access.");
						my $FileSource = "";
						while(<SOURCE>){$FileSource .= $_;}
						close SOURCE;
						
						#grab the DTD and strip it out for later
						if($FileSource =~ m/(<!DOCTYPE.*?>)/) {
							my $DTD = $1;
							$FileSource =~ s/$DTD//;
							$this->{DTD} = $DTD;
						}
						
						#load up the source
						$this->{Source} = $FileSource;
					}
					else {
						die("WebLegs.TextTemplate.LoadFile(): File not found or not able to access.");
					}
				}
				#LoadFile(Path, RootPath) overload
				else {
					#get the html file source
					open(HTML, "<", $Path) or die("WebLegs.TextTemplate.LoadFile(): Data file not found or not able to access.");
					my $HTMLSource = "";
					while(<HTML>){$HTMLSource .= $_;}
					close HTML;
					
					#find the xsl style sheet path in our document
					my $XSLTFilePath = undef;
					if($HTMLSource =~ m/xml-stylesheet.*?href=[\"|\'](.*?)[\"|\']/) { #"comment for code coloring
						$XSLTFilePath = $1;
						
						#grab the DTD and strip it out for later
						if($HTMLSource =~ m/(<!DOCTYPE.*?>)/) {
							my $DTD = $1;
							$HTMLSource =~ s/$DTD//;
							$this->{DTD} = $DTD;
						}
						
						#turn off tag compression
						$XML::LibXML::setTagCompression = 1;
						
						#parse and transform
						my $Parser = XML::LibXML->new();
						my $XSLT = XML::LibXSLT->new();
						my $SourceDocument = $Parser->parse_string($HTMLSource);
						my $StyleDocument = $Parser->parse_file($RootPath.$XSLTFilePath);
						my $StylesheetDocument = $XSLT->parse_stylesheet($StyleDocument);
						my $Results = $StylesheetDocument->transform($SourceDocument);
						
						#grab the result
						$this->{Source} = $Results->toString();
					}
					else {
						#didn't find a style sheet, just return the source
						$this->{Source} = $HTMLSource;
					}
				}
				
				return $this;
			}
		##<-- End Method :: LoadFile
		
		####################################################################################
		
		##--> Begin Method :: Load
			sub Load() {
				my $this = shift;
				my $Source = shift;
				
				#grab the DTD and strip it out for later
				if($Source =~ m/(<!DOCTYPE.*?>)/) {
					my $DTD = $1;
					$Source =~ s/$DTD//;
					$this->{DTD} = $DTD;
				}
				
				#string container
				$this->{Source} = $Source;
				
				return $this;
			}
		##<-- End Method :: Load
		
		####################################################################################
		
		##--> Begin Method :: Replace
			sub Replace() {
				my $this = shift;			
				my $This = shift;
				my $WithThis = shift;
				
				$this->{Source} =~ s/\Q$This/$WithThis/g;
				return $this;
			}
		##<-- End Method :: Replace
		
		####################################################################################
		
		##--> Begin Method :: GetSubString
			sub GetSubString() {
				my $this = shift;
				my $Start = shift;
				my $End = shift;
				
				my $MyStart = 0;
				my $MyEnd = 0;
				
				if(index($this->{Source}, $Start) > -1 && rindex($this->{Source}, $End) > -1) {
					$MyStart = index($this->{Source}, $Start) + length($Start);
					$MyEnd = rindex($this->{Source}, $End);
					if(substr($this->{Source}, $MyStart, $MyEnd - $MyStart)) {
						return substr($this->{Source}, $MyStart, $MyEnd - $MyStart);
					}
					else {
						die("WebLegs.TextTemplate.GetSubString(): Boundry string mismatch. String.Substring method failed.");
					}
				}
				else {
					die("WebLegs.TextTemplate.GetSubString(): Boundry strings not present in source string.");
				}
			}
		##<-- End Method :: GetSubString
		
		####################################################################################
		
		##--> Begin Method :: RemoveSubString
			sub RemoveSubString() {
				my $this = shift;
				my $Start = shift;
				my $End = shift;
				my $RemoveKeys = shift || 0;
				
				#try to get the sub string and remove
				eval {
					my $SubString = $this->GetSubString($Start, $End);
					$this->{Source} =~ s/\Q$SubString//g;
				};
				if($@) {
					die("WebLegs.TextTemplate.RemoveSubString(): Boundry string mismatch. String.Substring method failed.");
				}
				
				#should we remove the keys too?
				if($RemoveKeys) {
					$this->Replace($Start, "");
					$this->Replace($End, "");
				}
			}
		##<-- End Method :: RemoveSubString
		
		####################################################################################
		
		##--> Begin Method :: ToString
			sub ToString() {
				my $this = shift;
				
				my $Output = $this->{DTD}.$this->{Source};
				$Output =~ s/(<\?xml.*?>)//;
				
				#clean up tags that got un-compressed (we want a better solution for this)
				#area, base, basefont, br, col, frame, hr, img, input, isindex, link, meta, param
				$Output =~ s/<area(.*?)><\/area>/<area$1\/>/gi;
				$Output =~ s/<base(.*?)><\/base>/<base$1\/>/gi;
				$Output =~ s/<basefont(.*?)><\/basefont>/<basefont$1\/>/gi;
				$Output =~ s/<br(.*?)><\/br>/<br$1\/>/gi;
				$Output =~ s/<col(.*?)><\/col>/<col$1\/>/gi;
				$Output =~ s/<frame(.*?)><\/frame>/<frame$1\/>/gi;
				$Output =~ s/<hr(.*?)><\/hr>/<hr$1\/>/gi;
				$Output =~ s/<img(.*?)><\/img>/<img$1\/>/gi;
				$Output =~ s/<input(.*?)><\/input>/<input$1\/>/gi;
				$Output =~ s/<isindex(.*?)><\/isindex>/<isindex$1\/>/gi;
				$Output =~ s/<link(.*?)><\/link>/<link$1\/>/gi;
				$Output =~ s/<meta(.*?)><\/meta>/<meta$1\/>/gi;
				$Output =~ s/<param(.*?)><\/param>/<param$1\/>/gi;
				
				return $Output;
			}
		##<-- End Method :: ToString
		
		####################################################################################
		
		##--> Begin Method :: SaveAs
			sub SaveAs() {
				my $this = shift;
				my $FilePath = shift;
				
				open(FILEHANDLE,">$FilePath") or die "WebLegs.TextTemplate.SaveAs(): Unable to save file.";
				binmode(FILEHANDLE);
				print FILEHANDLE $this->{Source};
				close(FILEHANDLE);
			}
		##<-- End Method :: SaveAs
	}
##<-- End Class :: TextTemplate

############################################################################################
1;