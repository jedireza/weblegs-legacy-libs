#!/usr/bin/perl
use strict;
use GD;
use File::Basename;
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

##--> Begin Class :: Imager
	{package Imager;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $FilePath = shift;
				
				my $this = {
					"BackgroundColor" => "#000000",
					"OutputImage" => undef,
					"ContentType" => undef,
					"ImageName" => undef
				};
				bless($this, ref($class) || $class);
				
				#lets us work with photographs well too
				GD::Image->trueColor(1);
				
				#overload new(FilePath)
				if($FilePath) {
					$this->Load($FilePath);
				}
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: Load
			sub Load() {
				my $this = shift;
				my $FilePath = shift;
				
				if(!(-e $FilePath)) {
					die("WebLegs.Imager.Load(): File not found or not able to access.");
				}
				
				#load the image
				$this->{OutputImage} = $this->LoadImageFromFile($FilePath);
				
				#get file info
				my ($FileName, $Path, $Suffix) = File::Basename::fileparse($FilePath);
				my $FileExtension = "";
				if($FileName =~ m/(\..*?)$/) {
					$FileExtension = $1;
				}
				
				#find content type
				if($FileExtension eq ".png") {
					$this->{ContentType} = "image/png";
				}
				elsif($FileExtension eq ".jpg") {
					$this->{ContentType} = "image/jpeg";
				}
				elsif($FileExtension eq ".gif") {
					$this->{ContentType} = "image/gif";
				}
				else {
					$this->{ContentType} = "image/jpeg";
				}
				
				#get filename with out extension
				my $FileNameOnly = "";
				if($FileName =~ m/(.*?)\..*?$/) {
					$FileNameOnly = $1;
				}
				$this->{ImageName} = $FileNameOnly;
				
				return $this;
			}
		##<-- End Method :: Load
		
		####################################################################################
		
		##--> Begin Method :: Constrain
			sub Constrain() {
				my $this = shift;
				my $Height = shift;
				my $Width = shift;
				
				#original height and width
				my $SourceWidth = $this->GetWidth();
				my $SourceHeight = $this->GetHeight();
				
				#shrink calculations
					#calculation containers
					my $ShrinkPercentage = 0;
					my $ShrinkPercentageW = 0;
					my $ShrinkPercentageH = 0;
					
					#calculate height and width percentages
					$ShrinkPercentageH = ($Height / $SourceHeight);
					$ShrinkPercentageW = ($Width / $SourceWidth);
					
					#if we have to pad the image, pad evenly on top/bottom or left/right
					if($ShrinkPercentageH < $ShrinkPercentageW) {
						$ShrinkPercentage = $ShrinkPercentageH;
					}
					else {
						$ShrinkPercentage = $ShrinkPercentageW;
					}
				#end shrink percentages
				
				#output height and width
				my $OutputWidth  = ($SourceWidth * $ShrinkPercentage);
				my $OutputHeight = ($SourceHeight * $ShrinkPercentage);
				
				#adjust dimensions so that one dimension always matches the dimensions passed in
				my $DifferencePercent = 0;
				my $DifferenceWidth = $Width - $OutputWidth;
				my $DifferenceHeight = $Height - $OutputHeight;
	
				#use the dimension that needs to be asdjusted by the least pixels
				if($DifferenceHeight < $DifferenceWidth){
					$DifferencePercent = $Height / $OutputHeight;
				}
				else{
					$DifferencePercent = $Width / $OutputWidth;
				}
			   
				#adjust both dimensions by the same percentage
				$OutputWidth = ($OutputWidth * $DifferencePercent);
				$OutputHeight = ($OutputHeight * $DifferencePercent);
				
				#create new image and draw on new image
				my $NewImage = GD::Image->new($OutputWidth, $OutputHeight);
				$NewImage->copyResampled($this->{OutputImage}, 0, 0, 0, 0, $OutputWidth, $OutputHeight, $SourceWidth, $SourceHeight);
				
				#write over the OutputImage memory
				$this->{OutputImage} = $NewImage;
				
				return $this;
			}
		##<-- End Method :: Constrain
		
		####################################################################################
		
		##--> Begin Method :: ConstrainHeight
			sub ConstrainHeight() {
				my $this = shift;
				my $Height = shift;
				
				#original height and width
				my $SourceWidth = $this->GetWidth();
				my $SourceHeight = $this->GetHeight();
				
				#shrink calculations
					my $ShrinkPercentage = ($Height / $SourceHeight);
					my $OutputWidth = int($SourceWidth * $ShrinkPercentage);
					my $OutputHeight = int($SourceHeight * $ShrinkPercentage);
					
					#make the width exactly what we passed in
					if($OutputHeight < $Height) {
						my $Offset = $Height - $OutputHeight;
						$OutputWidth += $Offset;
						$OutputHeight += $Offset;
					}
				#end shrink percentages
				
				#create new image and draw on new image
				my $NewImage = GD::Image->new($OutputWidth, $OutputHeight);
				$NewImage->copyResampled($this->{OutputImage}, 0, 0, 0, 0, $OutputWidth, $OutputHeight, $SourceWidth, $SourceHeight);
				
				#write over the OutputImage memory
				$this->{OutputImage} = $NewImage;
				
				return $this;
			}
		##<-- End Method :: ConstrainHeight
		
		####################################################################################
		
		##--> Begin Method :: ConstrainWidth
			sub ConstrainWidth() {
				my $this = shift;
				my $Width = shift;
				
				#original height and width
				my $SourceWidth = $this->GetWidth();
				my $SourceHeight = $this->GetHeight();
				
				#shrink calculations
					my $ShrinkPercentage = ($Width / $SourceWidth);
					my $OutputWidth = int($SourceWidth * $ShrinkPercentage);
					my $OutputHeight = int($SourceHeight * $ShrinkPercentage);
					
					#make the width exactly what we passed in
					if($OutputWidth < $Width) {
						my $Offset = $Width - $OutputWidth;
						$OutputWidth += $Offset;
						$OutputHeight += $Offset;
					}
				#end shrink percentages
				
				#create new image and draw on new image
				my $NewImage = GD::Image->new($OutputWidth, $OutputHeight);
				$NewImage->copyResampled($this->{OutputImage}, 0, 0, 0, 0, $OutputWidth, $OutputHeight, $SourceWidth, $SourceHeight);
				
				#write over the OutputImage memory
				$this->{OutputImage} = $NewImage;
				
				return $this;
			}
		##<-- End Method :: ConstrainWidth
		
		####################################################################################
		
		##--> Begin Method :: ScaleByPercent
			sub ScaleByPercent() {
				my $this = shift;
				my $Percent = shift;
				
				#original height and width
				my $SourceWidth = $this->GetWidth();
				my $SourceHeight = $this->GetHeight();
				
				#shrink calculations
				my $ShrinkPercentage = ($Percent / 100);
				my $OutputWidth = int($SourceWidth * $ShrinkPercentage);
				my $OutputHeight = int($SourceHeight * $ShrinkPercentage);
				
				#create new image and draw on new image
				my $NewImage = GD::Image->new($OutputWidth, $OutputHeight);
				$NewImage->copyResampled($this->{OutputImage}, 0, 0, 0, 0, $OutputWidth, $OutputHeight, $SourceWidth, $SourceHeight);
				
				#write over the OutputImage memory
				$this->{OutputImage} = $NewImage;
				
				return $this;
			}
		##<-- End Method :: ScaleByPercent
		
		####################################################################################
		
		##--> Begin Method :: FixedSize
			sub FixedSize() {
				my $this = shift;
				my $Height = shift;
				my $Width = shift;
				
				#original height and width
				my $SourceWidth = $this->GetWidth();
				my $SourceHeight = $this->GetHeight();
				
				#shrink calculations
					#output x and y coords (for padding)
					my $OutputX = 0;
					my $OutputY = 0; 
					
					#calculation containers
					my $ShrinkPercentage = 0;
					my $ShrinkPercentageW = 0;
					my $ShrinkPercentageH = 0;
					
					#calculate height and width percentages
					$ShrinkPercentageH = ($Height / $SourceHeight);
					$ShrinkPercentageW = ($Width / $SourceWidth);
					
					#if we have to pad the image, pad evenly on top/bottom or left/right
					if($ShrinkPercentageH < $ShrinkPercentageW) {
						$ShrinkPercentage = $ShrinkPercentageH;
						$OutputX = int(($Width - ($SourceWidth * $ShrinkPercentage)) / 2);
					}
					else {
						$ShrinkPercentage = $ShrinkPercentageW;
						$OutputY = int(($Height - ($SourceHeight * $ShrinkPercentage)) / 2);
					}
				#end shrink percentages
				
				#output height and width
				my $OutputWidth  = int($SourceWidth * $ShrinkPercentage);
				my $OutputHeight = int($SourceHeight * $ShrinkPercentage);
				
				#create new image
				my $NewImage = GD::Image->new($Width, $Height);
				
				#set background color
				my $tmpHexCode = $this->{BackgroundColor};
				$tmpHexCode =~ s/\#//;
				my @RGB = $tmpHexCode =~ m/(\w{2})(\w{2})(\w{2})/;
				$RGB[0] = CORE::hex($RGB[0]);
				$RGB[1] = CORE::hex($RGB[1]);
				$RGB[2] = CORE::hex($RGB[2]);
				my $NewBackgroundColor = $NewImage->colorAllocate($RGB[0],$RGB[1],$RGB[2]);
				$NewImage->fill(0, 0, $NewBackgroundColor);
				
				#draw on new image
				$NewImage->copyResampled($this->{OutputImage}, $OutputX, $OutputY, 0, 0, $OutputWidth, $OutputHeight, $SourceWidth, $SourceHeight);
				
				#write over the OutputImage memory
				$this->{OutputImage} = $NewImage;
				
				return $this;
			}
		##<-- End Method :: FixedSize
		
		####################################################################################
		
		##--> Begin Method :: Crop
			sub Crop() {
				my $this = shift;
				
				#emulate overloading with argument count
				my $NumberOfArgs = scalar(@_);
				
				#argument variables
				my $Height = 0;
				my $Width = 0;
				my $Anchor = "";
				my $SourceX = 0;
				my $SourceY = 0;
				
				#Crop(Height, Width, Anchor) {
				if($NumberOfArgs == 3){
					$Height = $_[0];
					$Width = $_[1];
					$Anchor = $_[2];
				}
				#Crop(Height, Width, SourceX, SourceY)
				elsif($NumberOfArgs == 4){
					$Height = $_[0];
					$Width = $_[1];
					$SourceX = $_[2];
					$SourceY = $_[3];
				}
				#neither
				else{
					return;
				}
				
				#set default x y values for output image
				my $OutputX = 0;
				my $OutputY = 0;
				
				#calculate general points
				my $Center = int($this->GetWidth() / 2);
				my $Middle = int($this->GetHeight() / 2);
				
				#set x/y positions
				if($Anchor eq "top-left") {
					$OutputX = 0;
					$OutputY = 0;
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif($Anchor eq "top-center") {
					$OutputX = ($Center - ($Width / 2));
					$OutputY = 0;
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif($Anchor eq "top-right") {
					$OutputX = ($this->GetWidth() - $Width);
					$OutputY = 0;
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif($Anchor eq "middle-left") {
					$OutputX = 0;
					$OutputY = ($Middle - ($Height / 2));
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif($Anchor eq "middle") {
					$OutputX = ($Center - ($Width / 2));
					$OutputY = ($Middle - ($Height / 2));
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif($Anchor eq "middle-right") {
					$OutputX = ($this->GetWidth() - $Width);
					$OutputY = ($Middle - ($Height / 2));
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif($Anchor eq "bottom-left") {
					$OutputX = 0;
					$OutputY = ($this->GetHeight() - $Height);
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif($Anchor eq "bottom-center") {
					$OutputX = ($Center - ($Width / 2));
					$OutputY = ($this->GetHeight() - $Height);
				}
				#- - - - - - - - - - - - - - - - - -#
				elsif($Anchor eq "bottom-right") {
					$OutputX = ($this->GetWidth() - $Width);
					$OutputY = ($this->GetHeight() - $Height);
				}
				#- - - - - - - - - - - - - - - - - -#
				else {
					#do nothing
				}
				
				#create new image
				my $NewImage = GD::Image->new($Width, $Height);
				
				#set background color
				my $tmpHexCode = $this->{BackgroundColor};
				$tmpHexCode =~ s/\#//;
				my @RGB = $tmpHexCode =~ m/(\w{2})(\w{2})(\w{2})/;
				$RGB[0] = CORE::hex($RGB[0]);
				$RGB[1] = CORE::hex($RGB[1]);
				$RGB[2] = CORE::hex($RGB[2]);
				my $NewBackgroundColor = $NewImage->colorAllocate($RGB[0],$RGB[1],$RGB[2]);
				$NewImage->fill(0, 0, $NewBackgroundColor);
				
				#draw on new image
				$NewImage->copyResampled($this->{OutputImage}, -$SourceX, -$SourceY, $OutputX, $OutputY, $this->GetWidth(), $this->GetHeight(), $this->GetWidth(), $this->GetHeight());
				
				#write over the OutputImage memory
				$this->{OutputImage} = $NewImage;
				
				return $this;
			}
		##<-- End Method :: Crop
		
		####################################################################################
		
		##--> Begin Method :: GetHeight
			sub GetHeight() {
				my $this = shift;
				
				return ($this->{OutputImage}->getBounds())[1];
			}
		##<-- End Method :: GetHeight
		
		####################################################################################
		
		##--> Begin Method :: GetWidth
			sub GetWidth() {
				my $this = shift;
				
				return ($this->{OutputImage}->getBounds())[0];
			}
		##<-- End Method :: GetWidth
		
		####################################################################################
		
		##--> Begin Method :: SaveAs
			sub SaveAs() {
				my $this = shift;
				my $FullPath = shift;
				
				open(FILEHANDLE,">$FullPath") or die "WebLegs.Imager.SaveAs(): Unable to save file.";
				binmode(FILEHANDLE);
				#find content type
				if($this->{ContentType} eq "image/png") {
					print FILEHANDLE $this->{OutputImage}->png();
				}
				elsif($this->{ContentType} eq "image/jpeg") {
					print FILEHANDLE $this->{OutputImage}->jpeg();
				}
				elsif($this->{ContentType} eq "image/gif") {
					print FILEHANDLE $this->{OutputImage}->gif();
				}
				else {
					print FILEHANDLE $this->{OutputImage}->jpeg();
				}
				close(FILEHANDLE);
				
				return $this;
			}
		##<-- End Method :: SaveAs
		
		####################################################################################
		
		##--> Begin Method :: SaveHTTP
			sub SaveHTTP() {
				my $this = shift;
				my $FileName = shift;
				
				#overload SaveHTTP() (no filename passed)
				if(!defined($FileName)) {
					if($this->{ContentType} eq "image/png") {
						$FileName = $this->{ImageName} .".png";
					}
					elsif($this->{ContentType} eq "image/jpeg") {
						$FileName = $this->{ImageName} .".jpg";
					}
					elsif($this->{ContentType} eq "image/gif") {
						$FileName = $this->{ImageName} .".gif";
					}
					else {
						$FileName = $this->{ImageName} .".jpg";
					}
				}
				
				#save image to stream
				print("Status: 200 OK\n");
				print("Content-type: ". $this->{ContentType} ."\n");
				
				#find content type
				if($this->{ContentType} eq "image/png") {
					print("Content-Disposition: filename=". $FileName .";\n\n");
					print($this->{OutputImage}->png());
				}
				elsif($this->{ContentType} eq "image/jpeg") {
					print("Content-Disposition: filename=". $FileName .";\n\n");
					print($this->{OutputImage}->jpeg());
				}
				elsif($this->{ContentType} eq "image/gif") {
					print("Content-Disposition: filename=". $FileName .";\n\n");
					print($this->{OutputImage}->gif());
				}
				else {
					print("Content-Disposition: filename=". $FileName .";\n\n");
					print($this->{OutputImage}->jpeg());
				}
				
				#stop the execution of perl
				exit(0);
			}
		##<-- End Method :: SaveHTTP
		
		####################################################################################
		
		##--> Begin Method :: LoadImageFromFile
			sub LoadImageFromFile() {
				my $this = shift;
				my $FilePath = shift;
				
				my $VirtualImage = GD::Image->new($FilePath);
				return $VirtualImage;
			}
		##<-- End Method :: LoadImageFromFile
	}
##<-- End Class :: Imager

############################################################################################
1;