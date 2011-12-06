#!/usr/bin/perl
use DBI;
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

##--> Begin Class :: MySQLDriver
	{package MySQLDriver;
		##--> Begin :: Constructor
			sub new() {
				my $class = shift;
				my $this = {
					"MyConnection" => undef,
					"SQLCommand" => undef,
					"Host" => undef,
					"Username" => undef,
					"Password" => undef,
					"Schema" => undef,
					"ConnectionString" => undef
				};
				bless($this, ref($class) || $class);
				
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
				
				if(!defined($this->{MyConnection})) {
					$this->{MyConnection} = DBI->connect("dbi:ODBC:".$this->{ConnectionString},$this->{Username},$this->{Password})
						or die("WebLegs.ODBCDriver.Open(): Can't connect to mysql db: (". $DBI::errstr .").");
				}
			}
		##<-- End Method :: Open
		
		####################################################################################
		
		##--> Begin Method :: Close
			sub Close() {
				my $this = shift;
				
				if(defined($this->{MyConnection})) {
					$this->{MyConnection}->disconnect()
						or warn("WebLegs.MySQLDriver.Close(): Error closing connection: (". $DBI::errstr .").");
					
					$this->{MyConnection} = undef;
				}
			}
		##<-- End Method :: Close
		
		####################################################################################
		
		##--> Begin Method :: Escape
			sub Escape() {
				my $this = shift;
				my $Value = shift;
				
				#escape (') and (\)
				$Value =~ s/\'/\'\'/g; #'(code coloring comment)
				$Value =~ s/\\/\\\\/g;
				
				return $Value;
			}
		##<-- End Method :: Escape
		
		####################################################################################
		
		##--> Begin Method :: SQLKey
			sub SQLKey() {
				my $this = shift;
				my $Key = shift;
				my $Value = shift;
				
				#escape value
				$Value = $this->Escape($Value);
				
				#replace in sql command
				$this->{SQLCommand} =~ s/$Key/$Value/g;
			}
		##<-- End Method :: SQLKey
		
		####################################################################################
		
		##--> Begin Method :: ExecuteNonQuery
			sub ExecuteNonQuery() {
				my $this = shift;
				
				my $StatementHandle = $this->{MyConnection}->prepare($this->{SQLCommand});
				$StatementHandle->execute()
					or die("WebLegs.ODBCDriver.ExecuteNonQuery(): Error executing statement: (". $DBI::errstr .").");
			}
		##<-- End Method :: ExecuteNonQuery
		
		####################################################################################
		
		##--> Begin Method :: GetDataString
			sub GetDataString() {
				my $this = shift;
				my $RowSeperatedBy = shift || "";
				my $FieldsSeperatedBy = shift || "";
				my $FieldsEnclosedBy = shift || "";
				my $ReturnHeaders = shift || 0;
				
				my $MyResult = "";
				
				my $StatementHandle = $this->{MyConnection}->prepare($this->{SQLCommand});
				$StatementHandle->execute()
					or die("WebLegs.ODBCDriver.GetDataString(): Error executing statement: (". $DBI::errstr .").");
				
				#header row
				my @Headers = @{$StatementHandle->{NAME}};
				if($ReturnHeaders) {
					#get the headers
					for(my $i = 0 ; $i < scalar(@Headers) ; $i++) {
						$MyResult .= $FieldsEnclosedBy . $Headers[$i] . $FieldsEnclosedBy;
						if($i + 1 != scalar(@Headers)) {
							$MyResult .= $FieldsSeperatedBy;
						}
					}
					$MyResult .= $RowSeperatedBy;
				}
				
				#data rows
				my @Rows = ();
				while(my $Row = $StatementHandle->fetchrow_hashref()) {
					#add hash to results array
					push(@Rows, $Row);
				}
				for(my $i = 0 ; $i < scalar(@Rows) ; $i++) {
					for(my $j = 0 ; $j < scalar(@Headers) ; $j++) {
						my $MyData = $Rows[$i]{$Headers[$j]};
						if($FieldsEnclosedBy ne "") {
							$MyData =~ s/$FieldsEnclosedBy/$FieldsEnclosedBy.$FieldsEnclosedBy/g;
						}
						$MyResult .= $FieldsEnclosedBy . $MyData . $FieldsEnclosedBy;
						if($j + 1 != scalar(@Headers)) {
							$MyResult .= $FieldsSeperatedBy;
						}
					}
					if($i + 1 != scalar(@Rows)) {
						$MyResult .= $RowSeperatedBy;
					}
				}
				
				return $MyResult;
			}
		##<-- End Method :: GetDataString
		
		####################################################################################
		
		##--> Begin Method :: GetLastInsertID
			sub GetLastInsertID() {
				my $this = shift;
				
				my $StatementHandle = $this->{MyConnection}->prepare("SELECT LAST_INSERT_ID();");
				$StatementHandle->execute()
					or die("WebLegs.ODBCDriver.GetLastInsertID(): Error executing statement: (". $DBI::errstr .").");
				
				#retrieve the returned row of data
				my @row = $StatementHandle->fetchrow_array();
				
				return "@row";
			}
		##<-- End Method :: GetLastInsertID
		
		####################################################################################
		
		##--> Begin Method :: GetFoundRows
			sub GetFoundRows() {
				my $this = shift;
				
				my $StatementHandle = $this->{MyConnection}->prepare("SELECT FOUND_ROWS();");
				$StatementHandle->execute()
					or die("WebLegs.ODBCDriver.GetFoundRows(): Error executing statement: (". $DBI::errstr .").");
				
				###retrieve the returned row of data
				my @row = $StatementHandle->fetchrow_array();
				
				return "@row";
			}
		##<-- End Method :: GetFoundRows
		
		####################################################################################
		
		##--> Begin Method :: GetDataRow
			sub GetDataRow() {
				my $this = shift;
				
				my $StatementHandle = $this->{MyConnection}->prepare($this->{SQLCommand});
				
				$StatementHandle->execute()
					or die("WebLegs.ODBCDriver.GetDataRow(): Error executing statement: (". $DBI::errstr .").");
				
				#retrieve one row
				my $row = $StatementHandle->fetchrow_hashref();
				if($row) {
					return %{$row};
				}
				else {
					return undef;
				}
			}
		##<-- End Method :: GetDataRow
		
		####################################################################################
		
		##--> Begin Method :: GetDataTable
			sub GetDataTable() {
				my $this = shift;
				
				my $StatementHandle = $this->{MyConnection}->prepare($this->{SQLCommand});
				
				$StatementHandle->execute()
					or die("WebLegs.ODBCDriver.GetDataTable(): Error executing statement: (". $DBI::errstr .").");
				
				#retrieve the returned rows of data
				my @rows = ();
				while(my $row = $StatementHandle->fetchrow_hashref()) {
					#add hash to results array
					push(@rows, $row);
				}
				
				return @rows;
			}
		##<-- End Method :: GetDataTable
		
		####################################################################################
		
		##--> Begin Method :: GetDataArray
			sub GetDataArray() {
				my $this = shift;
				
				my $StatementHandle = $this->{MyConnection}->prepare($this->{SQLCommand});
				
				$StatementHandle->execute()
					or die("WebLegs.ODBCDriver.GetDataArray(): Error executing statement: (". $DBI::errstr .").");
				
				#retrieve the returned rows of data
				my @rows = ();
				while(my $row = $StatementHandle->fetchrow_array()) {
					#add hash to results array
					push(@rows, $row);
				}

				return @rows;
			}
		##<-- End Method :: GetDataArray
	}
##<-- End Class :: MySQLDriver

############################################################################################
1;