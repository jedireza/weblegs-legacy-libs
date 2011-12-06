#!/usr/bin/perl
use strict;
use XML::LibXML;
use XML::LibXSLT;
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

##--> Begin Class :: DOMTemplate
	{package DOMTemplate;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $this = {
					"XPathQuery" => "",
					"DOMDocument" => undef,
					"DOMXPath" => undef,
					"ResultNodes" => undef,
					"BasePath" => "",
					"DTD" => ""
				};
				bless($this, ref($class) || $class);
				
				#setup the DOM doc
				$this->{DOMDocument} = XML::LibXML::Document->new();
				
				#return this
				return $this;
			}
		##<-- End :: Constructor
		
		####################################################################################
		
		##--> Begin Method :: Traverse
			sub Traverse() {
				my $this = shift;
				my $Value = shift;
				
				#clear out results nodes
				$this->{ResultNodes} = undef;
		
				#set the xpath query
				$this->{XPathQuery} .= $Value;
				
				return $this;
			}
		##<-- End Method :: Traverse
		
		####################################################################################
		
		##--> Begin Method :: GetDOMChunk
			sub GetDOMChunk() {
				my $this = shift;
				
				my $ReturnData = DOMChunk->new($this);
				$this->{XPathQuery} = "";
				return $ReturnData;
			}
		##<-- End Method :: GetDOMChunk
		
		####################################################################################
		
		##--> Begin Method :: LoadFile
			sub LoadFile() {
				my $this = shift;
				my $Path = shift;
				my $RootPath = shift;
				
				#load up file
				open(SOURCE, "<", $Path) or die("WebLegs.DOMTemplate.FilePath(): File not found or not able to access.");
				my $FileSource = "";
				while(<SOURCE>){$FileSource .= $_;}
				close SOURCE;
				$this->Load($FileSource, $RootPath);
				
				#return this reference
				return $this;
			}
		##<-- End Method :: LoadFile
		
		####################################################################################
		
		##--> Begin Method :: Load
			sub Load() {
				my $this = shift;
				my $Source = shift;
				my $RootPath = shift;
				
				#clear out results nodes
				$this->{ResultNodes} = undef;
				
				#set the xpath query
				$this->{XPathQuery} = "";
				
				#turn off tag compression
				$XML::LibXML::setTagCompression = 1;
				
				#setup our parser
				my $Parser = XML::LibXML->new();
				
				#do we expect XSLT?
				if(defined($RootPath)) {
					#find the xsl style sheet path in our document
					my $XSLTFilePath = undef;
					if($Source =~ m/xml-stylesheet.*?href=[\"|\'](.*?)[\"|\']/) { #"comment for code coloring
						$XSLTFilePath = $1;
						
						#grab the DTD and strip it out for later
						if($Source =~ m/(<!DOCTYPE.*?>)/) {
							my $DTD = $1;
							$Source =~ s/$DTD//;
							$this->{DTD} = $DTD;
						}
						
						#parse and transform
						my $XSLT = XML::LibXSLT->new();
						my $SourceDocument = $Parser->parse_string($Source);
						my $StyleDocument = $Parser->parse_file($RootPath.$XSLTFilePath);
						my $StylesheetDocument = $XSLT->parse_stylesheet($StyleDocument);
						my $Results = $StylesheetDocument->transform($SourceDocument);
						
						#grab the result
						$this->{DOMDocument} = $Parser->parse_string($Results->toString());
						

						#set XPATH doc
						$this->{DOMXPath} = XML::LibXML::XPathContext->new($this->{DOMDocument});
					}
					else {
						#didn't find a style sheet, just load up the DOM doc
						#grab the DTD and strip it out for later
						if($Source =~ m/(<!DOCTYPE.*?>)/) {
							my $DTD = $1;
							$Source =~ s/$DTD//;
							$this->{DTD} = $DTD;
						}
						$this->{DOMDocument} = $Parser->parse_string($Source);
						
						#set XPATH doc
						$this->{DOMXPath} = XML::LibXML::XPathContext->new($this->{DOMDocument});
					}
				}
				#nope, just a basic DOM doc from the get go
				else {
					#load up our DOM doc
					#grab the DTD and strip it out for later
					if($Source =~ m/(<!DOCTYPE.*?>)/) {
						my $DTD = $1;
						$Source =~ s/$DTD//;
						$this->{DTD} = $DTD;
					}
					$this->{DOMDocument} = $Parser->parse_string($Source);
					
					#set XPATH doc
					$this->{DOMXPath} = XML::LibXML::XPathContext->new($this->{DOMDocument});
				}
			}
		##<-- End Method :: Load
		
		####################################################################################
		
		##--> Begin Method :: ExecuteQuery
			sub ExecuteQuery() {
				my $this = shift;
				my $XPathQuery = shift;
				
				#check for empty document
				#DOMXPath is only instantiated when we LoadFile() or Load()
				#these functions were never called if this is the case
				if(!defined($this->{DOMXPath})) {
					return $this;
				}
				
				#this is the overload
				if(defined($XPathQuery)) {
					my @ReturnNodes = $this->{DOMXPath}->findnodes($this->{BasePath} . $XPathQuery);
					return @ReturnNodes;
				}
				
				#if its blank default to whole document
				if($this->{BasePath} eq "" && $this->{XPathQuery} eq "") {
					$this->{XPathQuery} = "//*";
				}
				#this accomodates for the duplicate queries in both the basepath and XPathquery
				#this can happen when attempting to access the parent node in a DOMChunk
				elsif($this->{BasePath} eq $this->{XPathQuery}){
					$this->{XPathQuery} = "";
				}
				
				my @ReturnNodes = $this->{DOMXPath}->findnodes($this->{BasePath} . $this->{XPathQuery});
				
				#clear XPathQuery
				$this->{XPathQuery} = "";
				
				#set node results
				$this->{ResultNodes} = \@ReturnNodes;
				
				return $this;
			}
		##<-- End Method :: ExecuteQuery
		
		####################################################################################
		
		##--> Begin Method :: ToString
			sub ToString() {
				my $this = shift;
				
				my $NumberOfArgs = scalar(@_);
				
				#ToString entire document - ToString()
				if($NumberOfArgs == 0){
					#check for empty document
					#DOMXPath is only instantiated when we LoadFile() or Load()
					#these functions were never called if this is the case
					if(!defined($this->{DOMXPath})) {
						return "";
					}
					
					#return output
					my $Output = $this->{DTD}.$this->{DOMDocument}->toString();
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
				#ToString an array of Nodes - ToString(NodeList ThisNodeList)
				elsif(ref($_[0]) eq "XML::LibXML::NodeList") {
					my $ReturnData = "";
					my $ThisNodeList = $_[0];
					while($ThisNodeList->size() > 0) {
						$ReturnData .= $this->ToString($ThisNodeList->shift());
					}
					return $ReturnData;
				}
				elsif(ref($_[0]) eq "ARRAY") {
					my $ReturnData = "";
					while(my $Node = shift(@{$_[0]})) {
						$ReturnData .= $this->ToString($Node);
					}
					return $ReturnData;
				}
				#ToString single Nodes - ToString(Node ThisNode)
				elsif(ref($_[0]) eq "XML::LibXML::Node") {
					return $_[0]->toString();
				}
				elsif(ref($_[0]) eq "XML::LibXML::Element") {
					return $_[0]->toString();
				}
				elsif(ref($_[0]) eq "XML::LibXML::Document") {
			        return $_[0]->documentElement()->toString();
				}
				elsif(ref($_[0]) eq "XML::LibXML::Text") {
			        return $_[0]->toString();
				}
				elsif(ref($_[0]) eq "XML::LibXML::Comment") {
			        return $_[0]->toString();
				}
			}
		##<-- End Method :: ToString
		
		####################################################################################
		
		##--> Begin Method :: GetNodesByTagName
			sub GetNodesByTagName() {
				my $this = shift;
				my $TagName = shift;
				
				#clear out results nodes
				$this->{ResultNodes} = undef;
			
				#set the xpath query
				$this->{XPathQuery} .= "//". $TagName;
		
				return $this;
			}
		##<-- End Method :: GetNodesByTagName
		
		####################################################################################
		
		##--> Begin Method :: GetNodeByID
			sub GetNodeByID() {
				my $this = shift;
				my $Value = shift;
				
				#clear out results nodes
				$this->{ResultNodes} = undef;
				
				#set the xpath query
				$this->{XPathQuery} .= "//*[\@id='". $Value ."']";
		
				return $this;
			}
		##<-- End Method :: GetNodeByID
		
		####################################################################################
		
		##--> Begin Method :: GetNodesByAttribute
			sub GetNodesByAttribute() {
				my $this = shift;
				my $Attribute = shift;
				my $Value = shift;
				
				#clear out results nodes
				$this->{ResultNodes} = undef;
				
				#GetNodesByAttribute($Attribute)
				if(!defined($Value)) {
					#set the xpath query
					$this->{XPathQuery} .= "//*[\@". $Attribute ."]";
				}
				#GetNodesByAttribute($Attribute, $Value)
				else{
					#set the xpath query
					$this->{XPathQuery} .= "//*[\@". $Attribute ."='". $Value ."']";
				}
		
				return $this;
			}
		##<-- End Method :: GetNodesByAttribute
		
		####################################################################################
		
		##--> Begin Method :: GetNodesByDataSet
			sub GetNodesByDataSet() {
				my $this = shift;
				my $Attribute = shift;
				my $Value = shift;
				
				#clear out results nodes
				$this->{ResultNodes} = undef;
				
				#use GetNodesByAttribute
				$this->GetNodesByAttribute("data-". $Attribute, $Value);
				
				return $this;
			}
		##<-- End Method :: GetNodesByDataSet
		
		####################################################################################
		
		##--> Begin Method :: GetNodesByAttributes
			sub GetNodesByAttributes() {
				my $this = shift;
				my $Attributes = shift;
				
				#clear out results nodes
				$this->{ResultNodes} = undef;
				
				my $Query = "";
				my $Counter = 0;
				my $Count = keys %{$Attributes};
				foreach my $Key (keys %{$Attributes}) {
					$Query .= "@". $Key ."='". $Attributes->{$Key} ."'";
					
					if(($Counter + 1) != $Count) {
						$Query .= " and ";
					}
		
					$Counter++;
				}
				
				#set the xpath query
				$this->{XPathQuery} .= "//*[". $Query ."]";
				
				#execute query
				return $this;
			}
		##<-- End Method :: GetNodesByAttributes
		
		####################################################################################
		
		##--> Begin Method :: SetAttribute
			sub SetAttribute() {
				my $this = shift;
				
				#emulate overloading with these argument count and vars
				my $Nodes = "";
				my $Attribute = "";
				my $Value = "";
				my $NumberOfArgs = scalar(@_);
				
				#SetAttribute(string $Attribute, string $Value)
				if($NumberOfArgs == 2) {		
					#execute query if is_null(ResultNodes)
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
				
					#set argument vars
					$Attribute = $_[0];
					$Value = $_[1];
					
					for(my $i = 0; $i < scalar(@{$this->{ResultNodes}}); $i++) {
						$this->{ResultNodes}->[$i]->setAttribute($Attribute, $Value);
					}
				
				}
				elsif($NumberOfArgs == 3) {
					#set argument vars
					$Nodes = $_[0];
					$Attribute = $_[1];
					$Value = $_[2];
					
					#SetAttribute(array $Nodes, string $Attribute, string $Value)
					if(ref($Nodes) eq "ARRAY") {
						for(my $i = 0; $i < scalar(@{$Nodes}); $i++) {
							$Nodes->[$i]->setAttribute($Attribute, $Value);
						}
					}
					#SetAttribute(node $Node, string $Attribute, string $Value)
					else{
						$Nodes->setAttribute($Attribute, $Value);
					}
				}
				
				return $this;
			}
		##<-- End Method :: SetAttribute
		
		####################################################################################
		
		##--> Begin Method :: GetAttribute
			sub GetAttribute() {
				my $this = shift;
				
				#emulate overloading with these argument count and vars
				my $Nodes = "";
				my $Attribute = "";
				my $NumberOfArgs = scalar(@_);
				my $ReturnValue = "";
				
				#GetAttribute(string $Attribute)
				if($NumberOfArgs == 1) {
					#execute query if is_null(ResultNodes)
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
				
					$Attribute = $_[0];
					$ReturnValue = $this->{ResultNodes}->[0]->getAttribute($Attribute);
				}
				#GetAttribute(node $Node, string $Attribute)
				elsif($NumberOfArgs == 2) {
					$Nodes = $_[0];
					$Attribute = $_[1];
					$ReturnValue = $Nodes->getAttribute($Attribute);
				}
				
				#this is a termination method clear out properties
				$this->{XPathQuery} = "";
				$this->{ResultNodes} = undef;
				
				return $ReturnValue;
			}
		##<-- End Method :: GetAttribute
		
		####################################################################################
		
		##--> Begin Method :: SetInnerHTML
			sub SetInnerHTML() {
				my $this = shift;
				
				#emulate overloading with these argument count and vars
				my $Nodes = undef;
				my $Value = undef;
				my $NumberOfArgs = scalar(@_);
				
				#SetInnerHTML(string $Value)
				if($NumberOfArgs == 1) {
					#execute query if is_null(ResultNodes)
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					
					#get value arg
					$Value = $_[0];
					for(my $i = 0; $i < scalar(@{$this->{ResultNodes}}); $i++) {
						$this->SetInnerHTML($this->{ResultNodes}->[$i], $Value);
					}
				}
				elsif($NumberOfArgs == 2) {
					$Nodes = $_[0];
					$Value = $_[1];
					
					#SetInnerHTML(array $Nodes, string $Value)
					if(ref($Nodes) eq "ARRAY") {
						for(my $i = 0; $i < scalar(@{$Nodes}) ; $i++) {
							$this->SetInnerHTML($Nodes->[$i], $Value);
						}
					}
					#SetInnerHTML(node $Node, string $Value)
					else{
						$Nodes = $_[0];
						$Nodes->removeChildNodes();
						
						#load source
						my $Parser = XML::LibXML->new();
						my $tmpDOMDocument = undef;
						
						if($Nodes->nodeName eq "html"){
							$tmpDOMDocument = $Parser->parse_string($Value);
						}
						else{
							$tmpDOMDocument = $Parser->parse_string("<container-root>". $Value ."</container-root>");
						}
						
						my $NewNode = $this->{DOMDocument}->importNode($tmpDOMDocument->documentElement());

						for(my $i = 0; $i < scalar(@{$NewNode->childNodes()}) ; $i++) {
							#accomodate for textnodes
							if(ref($Nodes) eq "XML::LibXML::Text") {
								$Nodes->appendTextNode($NewNode->childNodes()->[$i]);
							}
							else{
								$Nodes->appendChild($NewNode->childNodes()->[$i]->cloneNode(1));
							}
						}
					}
				}
				return $this;
			}
		##<-- End Method :: SetInnerHTML
		
		####################################################################################
		
		##--> Begin Method :: GetOuterHTML
			sub GetOuterHTML() {
				my $this = shift;
				
				#emulate overloading with these argument count and vars
				my $Node = undef;
				my $NumberOfArgs = scalar(@_);
				my $ReturnValue = undef;
				
				#GetOuterHTML()
				if($NumberOfArgs == 0) {
					#execute query if is_null(ResultNodes)
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					
					$ReturnValue = $this->GetOuterHTML($this->{ResultNodes}->[0]);
				}
				#GetOuterHTML(node $Node)
				elsif($NumberOfArgs == 1) {
					$ReturnValue = $this->ToString($_[0]);
				}
				
				#this is a termination method clear out properties
				$this->{XPathQuery} = "";
				$this->{ResultNodes} = undef;
				
				return $ReturnValue;
			}
		##<-- End Method :: GetOuterHTML
		
		####################################################################################
		
		##--> Begin Method :: GetInnerHTML
			sub GetInnerHTML() {
				my $this = shift;
				
				#emulate overloading with these argument count and vars
				my $Node = undef;
				my $NumberOfArgs = scalar(@_);
				my $ReturnValue = "";
				
				#GetInnerHTML()
				if($NumberOfArgs == 0) {
					#execute query if is_null(ResultNodes)
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					
					$ReturnValue = $this->GetInnerHTML($this->{ResultNodes}->[0]);
				}
				#GetInnerHTML(node $Node)
				elsif($NumberOfArgs == 1) {
					my @Children = $_[0]->childNodes();
					$ReturnValue = $this->ToString(\@Children);
				}
				
				#this is a termination method clear out properties
				$this->{XPathQuery} = "";
				$this->{ResultNodes} = undef;
				
				return $ReturnValue;
			}
		##<-- End Method :: GetInnerHTML
		
		####################################################################################
		
		##--> Begin Method :: SetInnerText
			sub SetInnerText() {
				my $this = shift;
				
				#emulate overloading with these argument count and vars
				my $Nodes = undef;
				my $Value = undef;
				my $NumberOfArgs = scalar(@_);
				
				#SetInnerText($Value)
				if($NumberOfArgs == 1) {
					#execute query if is_null(ResultNodes)
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					
					#set argument
					$Value = $_[0];
					
					for(my $i = 0; $i < scalar(@{$this->{ResultNodes}}); $i++) {
						$this->{ResultNodes}->[$i]->removeChildNodes();
						$this->{ResultNodes}->[$i]->appendTextNode($Value);
					}
				}
				elsif($NumberOfArgs == 2) {
					$Nodes = $_[0];
					$Value = $_[1];
					
					#SetInnerText(array $Nodes, string $Value)
					if(ref($Nodes) eq "ARRAY") {
						for(my $i = 0 ; $i < scalar(@{$Nodes}); $i++) {
							$Nodes->[$i]->removeChildNodes();
							$Nodes->[$i]->appendTextNode($Value);
						}
					}
					#SetInnerText(node $Nodes, string $Value)
					else{
						$Nodes->removeChildNodes();
						$Nodes->appendTextNode($Value);
					}
				}
				
				return $this;
			}
		##<-- End Method :: SetInnerText
		
		####################################################################################
		
		##--> Begin Method :: GetInnerText
			sub GetInnerText() {
				my $this = shift;
				
				#emulate overloading with these argument count and vars
				my $Node = undef;
				my $NumberOfArgs = scalar(@_);
				my $ReturnValue = "";
				
				#GetInnerText()
				if($NumberOfArgs == 0) {
					#execute query if is_null(ResultNodes)
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					
					$ReturnValue = $this->{ResultNodes}->[0]->textContent();
				}
				#GetInnerText(node $Node)
				elsif($NumberOfArgs == 1) {
					$Node = $_[0];
					$ReturnValue = $Node->textContent();
				}
				
				#this is a termination method clear out properties
				$this->{XPathQuery} = "";
				$this->{ResultNodes} = undef;
				
				return $ReturnValue;
			}
		##<-- End Method :: GetInnerText
		
		####################################################################################
		
		##--> Begin Method :: Remove
			sub Remove() {
				my $this = shift;
				
				#emulate overloading with these argument count and vars
				my $Nodes = "";
				my $NumberOfArgs = scalar(@_);
				
				#Remove()
				if($NumberOfArgs == 0) {
					#execute query if is_null(ResultNodes)
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					
					for(my $i = 0; $i < scalar(@{$this->{ResultNodes}}); $i++) {
						if($this->{ResultNodes}->[$i]->parentNode()){
							$this->{ResultNodes}->[$i]->parentNode()->removeChild($this->{ResultNodes}->[$i]);
						}
					}
				}
				elsif($NumberOfArgs == 1) {
					$Nodes = $_[0];
					
					#Remove(array $Nodes)
					if(ref($Nodes) eq "ARRAY") {
						for(my $i = 0; $i < scalar(@{$Nodes}); $i++) {
							$Nodes->[$i]->parentNode()->removeChild($Nodes->[$i]);
						}
					}
					#Remove(node $Nodes)
					else{
						$Nodes->parentNode()->removeChild($Nodes);
					}
				}
				
				#this is a termination method clear out properties
				$this->{XPathQuery} = "";
				$this->{ResultNodes} = undef;
				
				#return this reference
				return $this;
			}
		##<-- End Method :: Remove
		
		####################################################################################
		
		##--> Begin Method :: RemoveAttribute
			sub RemoveAttribute() {
				my $this = shift;
				
				#emulate overloading with these argument count and vars
				my $Nodes = "";
				my $Attribute = "";
				my $NumberOfArgs = scalar(@_);
				
				#RemoveAttribute($Attribute)
				if($NumberOfArgs == 1) {
					#execute query if is_null(ResultNodes)
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					
					$Attribute = $_[0];
		
					for(my $i = 0; $i < scalar(@{$this->{ResultNodes}}); $i++) {
						$this->{ResultNodes}->[$i]->removeAttribute($Attribute);
					}
				}
				elsif($NumberOfArgs == 2) {
					$Nodes = $_[0];
					$Attribute = $_[1];
					
					#RemoveAttribute(array $Nodes, string $Attribute)
					if(ref($Nodes) eq "ARRAY") {
						for(my $i = 0; $i < scalar(@{$Nodes}); $i++) {
							$Nodes->[$i]->removeAttribute($Attribute);
						}
					}
					#RemoveAttribute(node $Nodes, string $Attribute)
					else{
						$Nodes->removeAttribute($Attribute);
					}
				}
				
				return $this;
			}
		##<-- End Method :: RemoveAttribute
		
		####################################################################################
		
		##--> Begin Method :: RemoveAllAttributes
			sub RemoveAllAttributes() {
				my $this = shift;
				
				#emulate overloading with these argument count and vars
				my $Nodes = "";
				my $NumberOfArgs = scalar(@_);
				
				#RemoveAllAttributes()
				if($NumberOfArgs == 0) {
					#execute query if is_null(ResultNodes)
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					
					for(my $i = 0 ; $i < scalar(@{$this->{ResultNodes}}); $i++) {
						if($this->{ResultNodes}->[$i]->hasAttributes()) {
							while(my @Attributes = $this->{ResultNodes}->[$i]->attributes()) {
								$this->{ResultNodes}->[$i]->removeAttribute($Attributes[0]->nodeName);
							}
						}
					}
				}
				elsif($NumberOfArgs == 1) {
					$Nodes = $_[0];
					
					#RemoveAllAttributes(array $Nodes)
					if(ref($Nodes) eq "ARRAY") {
						for(my $i = 0; $i < scalar(@{$Nodes}); $i++) {
							while(scalar(@{$Nodes->[$i]->attributes()}) > 0) {
								$Nodes->[$i]->removeAttribute($Nodes->[$i]->attributes()->[0]->nodeName);
							}
						}
					}
					#RemoveAllAttributes(node $Nodes)
					else{
						while(scalar(@{$Nodes->attributes()}) > 0) {
							$Nodes->removeAttribute($Nodes->attributes()->[0]->nodeName);
						}
					}
				}
				
				return $this;
			}
		##<-- End Method :: RemoveAllAttributes
		
		####################################################################################
		
		##--> Begin Method :: GetNodes
			sub GetNodes() {
				my $this = shift;
				
				#execute query
				$this->ExecuteQuery();
				
				my $ReturnValue = $this->{ResultNodes};
				
				#this is a termination method clear out properties
				$this->{XPathQuery} = "";
				$this->{ResultNodes} = undef;
				
				return $ReturnValue;
			}
		##<-- End Method :: GetNodes
		
		####################################################################################
		
		##--> Begin Method :: GetNodesAsString
			sub GetNodesAsString() {
				my $this = shift;
				
				#execute query
				$this->ExecuteQuery();
				
				#get the node array
				my @XMLNodes = $this->{ResultNodes};
				
				#this is a termination method clear out properties
				$this->{XPathQuery} = "";
				$this->{ResultNodes} = undef;
				
				#output container
				my $ReturnValue = "";
				
				#loop over items and build string
				for(my $i = 0 ; $i < scalar(@XMLNodes); $i++) {
					$ReturnValue .= $this->ToString($XMLNodes[$i]);
				}
				
				return $ReturnValue;
			}
		##<-- End Method :: GetNodesAsString
		
		####################################################################################
		
		##--> Begin Method :: GetNode
			sub GetNode() {
				my $this = shift;
				
				#execute query
				$this->ExecuteQuery();
				
				my $ReturnValue = undef;
				if(scalar(@{$this->{ResultNodes}}) > 0){
					$ReturnValue = $this->{ResultNodes}->[0];
				}
		
				#this is a termination method clear out properties
				$this->{XPathQuery} = "";
				$this->{ResultNodes} = undef;
				
				return $ReturnValue;
			}
		##<-- End Method :: GetNode
		
		####################################################################################
		
		##--> Begin Method :: ReplaceNode
			sub ReplaceNode() {
				my $this = shift;
				
				my $NumberOfArgs = scalar(@_);
				
				if($NumberOfArgs == 2){
					$_[0]->parentNode()->replaceChild($_[1], $_[0]);
				}
				elsif($NumberOfArgs == 1){
					#execute query if ResultNodes == null
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					$this->ReplaceNode($this->{ResultNodes}->[0], $_[0]);
				}
				
				return $this;
			}
		##<-- End Method :: ReplaceNode
		
		####################################################################################
		
		##--> Begin Method :: RenameNode
			sub RenameNode() {
				my $this = shift;
				
				my $NumberOfArgs = scalar(@_);
				
				#RenameNode(NodeType)
				if($NumberOfArgs == 1){
					#execute query if ResultNodes == null
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					$this->RenameNodes($this->{ResultNodes}->[0], $_[0]);
				}
				#RenameNodes(Node, NodeType)
				elsif($NumberOfArgs == 2){
					$this->RenameNodes($_[0], $_[1]);
				}
				return $this;
			}
		##<-- End Method :: RenameNode
		
		####################################################################################
		
		##--> Begin Method :: RenameNodes
			sub RenameNodes() {
				my $this = shift;
				
				my $NumberOfArgs = scalar(@_);
				
				#RenameNodes(NodeType)
				if($NumberOfArgs == 1){
					#execute query if ResultNodes == null
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					 
					for(my $i = 0 ; $i < scalar(@{$this->{ResultNodes}}) ; $i++) {
						$this->RenameNodes($this->{ResultNodes}->[$i], $_[0]);
					}
				}
				elsif($NumberOfArgs == 2){
					#RenameNodes(Nodes[], NodeType)
					if(ref($_[0]) eq "ARRAY") {
						for(my $i = 0; $i < scalar(@{$_[0]}); $i++){
							$this->RenameNodes($_[0], $_[1]);
						}
					}
					#RenameNodes(Nodes, NodeType)
					else{
						my $ThisNode = $_[0];
						my $NewNode = $this->{DOMDocument}->createElement($_[1]);
						
						#set attributes
						if($ThisNode->hasAttributes()) {
							my @OldAttributes = $ThisNode->attributes();
							for(my $i = 0 ; $i < scalar(@OldAttributes) ; $i++) {
								$NewNode->setAttribute($OldAttributes[$i]->nodeName, $OldAttributes[$i]->nodeValue);
							}
						}
						
						#set children
						my @OldChildren = $ThisNode->childNodes();
						for(my $i = 0; $i < scalar(@OldChildren) ; $i++) {
							#accomodate for textnodes
							if(ref($NewNode) eq "XML::LibXML::Text") {
								$NewNode->appendTextNode($OldChildren[$i]);
							}
							else{
								$NewNode->appendChild($OldChildren[$i]->cloneNode(1));
							}
						}
						
						#replace nodes
						$this->ReplaceNode($ThisNode, $NewNode);
					}
				}
				return $this;
			}
		##<-- End Method :: RenameNodes
		
		####################################################################################
		
		##--> Begin Method :: ReplaceInnerString
			sub ReplaceInnerString() {
				my $this = shift;
				my $This = shift;
				my $WithThat = shift;
				
				#default to html
				if($this->{XPathQuery} eq ""){
					$this->{XPathQuery} = "/html";
				}
				
				#execute query if ResultNodes == null
				if(!defined($this->{ResultNodes})) {
					#execute query
					$this->ExecuteQuery();
				}
				
				my $ThisNode = $this->{ResultNodes}->[0];
				my $Source = $this->GetInnerHTML($ThisNode);
				$Source =~ s/\Q$This/$WithThat/g;;
				$this->SetInnerHTML($ThisNode, $Source);
				
				#return this reference
				return $this;
			}
		##<-- End Method :: ReplaceInnerString
		
		####################################################################################
		
		##--> Begin Method :: GetInnerSubString
			sub GetInnerSubString() {
				my $this = shift;
				my $Start = shift;
				my $End = shift;
				
				#execute query if ResultNodes == null
				if(!defined($this->{ResultNodes})) {
					#execute query
					$this->ExecuteQuery();
				}
				
				my $Source = $this->GetInnerHTML($this->{ResultNodes}->[0]);
				my $MyStart = 0;
				my $MyEnd = 0;
				
				if(index($Source, $Start) > -1 && rindex($Source, $End) > -1) {
					$MyStart = index($Source, $Start) + length($Start);
					$MyEnd = rindex($Source, $End);
					if(substr($Source, $MyStart, $MyEnd - $MyStart)) {
						return substr($Source, $MyStart, $MyEnd - $MyStart);
					}
					else {
						die("WebLegs.DOMTemplate.GetInnerSubString(): Boundry string mismatch.");
					}
				}
				else {
					die("WebLegs.DOMTemplate.GetInnerSubString(): Boundry strings not present in source string.");
				}
			}
		##<-- End Method :: GetInnerSubString
		
		####################################################################################
		
		##--> Begin Method :: RemoveInnerSubString
			sub RemoveInnerSubString() {
				my $this = shift;
				my $Start = shift;
				my $End = shift;
				my $RemoveKeys = shift || 0;
				
				#default to html
				if($this->{XPathQuery} eq ""){
					$this->{XPathQuery} = "/html";
				}
				
				#execute query if ResultNodes == null
				if(!defined($this->{ResultNodes})) {
					#execute query
					$this->ExecuteQuery();
				}
				
				my $ThisNode = $this->{ResultNodes}->[0];
				my $Source = $this->GetInnerHTML($ThisNode);
				my $SubString = "";
				
				#try to get the sub string and remove
				eval {
					$SubString = $this->GetInnerSubString($Start, $End);
					$Source =~ s/\Q$SubString//g;
				};
				if(@$) {
					die("WebLegs.DOMTemplate.RemoveInnerSubString(): Boundry string mismatch.");
				}
				
				#should we remove the keys too?
				if($RemoveKeys) {
					$Source =~ s/\Q$Start//g;
					$Source =~ s/\Q$End//g;
				}
				
				#load this back into the dom
				$this->SetInnerHTML($ThisNode, $Source);

				#return this reference
				return $this;
			}
		##<-- End Method :: RemoveInnerSubString
		
		####################################################################################
		
		##--> Begin Method :: SaveAs
			sub SaveAs() {
				my $this = shift;
				my $FilePath = shift;
				
				open(FILEHANDLE,">$FilePath") or die "WebLegs.DOMTemplate.SaveAs(): Unable to save file.";
				binmode(FILEHANDLE);
				print FILEHANDLE $this->ToString();
				close(FILEHANDLE);
			}
		##<-- End Method :: SaveAs
		
		####################################################################################
		
		##--> Begin Method :: AppendChild
			sub AppendChild() {
				my $this = shift;
				
				my $NumberOfArgs = scalar(@_);
				
				#AppendChild(Node ParentNode, Node ThisNode)
				if($NumberOfArgs == 2){
					$_[0]->appendChild($_[1]);
				}
				#AppendChild(Node ThisNode)
				else{
					#execute query if ResultNodes == null
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					$this->AppendChild($this->{ResultNodes}->[0], $_[0]);
				}
				return $this;
			}
		##<-- End Method :: AppendChild
		
		####################################################################################
		
		##--> Begin Method :: PrependChild
			sub PrependChild() {
				my $this = shift;
				
				my $NumberOfArgs = scalar(@_);
				
				#PrependChild(Node ParentNode, Node ThisNode)
				if($NumberOfArgs == 2){
					$_[0]->insertBefore($_[1], $_[0]->firstChild());
				}
				#PrependChild(Node ThisNode)
				else{
					#execute query if ResultNodes == null
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					$this->PrependChild($this->{ResultNodes}->[0], $_[0]);
				}
				
				return $this;
			}
		##<-- End Method :: PrependChild
		
		####################################################################################
		
		##--> Begin Method :: InsertAfter
			sub InsertAfter() {
				my $this = shift;
				
				my $NumberOfArgs = scalar(@_);
				
				#InsertAfter(Node RefNode, Node ThisNode)
				if($NumberOfArgs == 2){
					#determine if the ref node is the last node
					if($_[0]->parentNode()->lastChild() eq $_[0]){
						$_[0]->parentNode()->appendChild($_[1]);
					}
					#its not the last node
					else{
						$_[0]->parentNode()->insertBefore($_[1], $_[0]->nextSibling());
					}
				}
				#InsertAfter(Node ThisNode)
				else{
					#execute query if ResultNodes == null
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					$this->InsertAfter($this->{ResultNodes}->[0], $_[0]);
				}
				
				return $this;
			}
		##<-- End Method :: InsertAfter
		
		####################################################################################
		
		##--> Begin Method :: InsertBefore
			sub InsertBefore() {
				my $this = shift;
				
				my $NumberOfArgs = scalar(@_);
				
				#InsertBefore(Node RefNode, Node ThisNode)
				if($NumberOfArgs == 2){
					$_[0]->parentNode()->insertBefore($_[1], $_[0]);
				}
				#InsertBefore(Node ThisNode)
				else{
					#execute query if ResultNodes == null
					if(!defined($this->{ResultNodes})) {
						#execute query
						$this->ExecuteQuery();
					}
					$this->InsertBefore($this->{ResultNodes}->[0], $_[0]);
				}
				return $this;
			}
		##<-- End Method :: InsertBefore
	}
##<-- End Class :: DOMTemplate

############################################################################################
1;