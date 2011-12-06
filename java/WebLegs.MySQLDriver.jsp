<%@ page import="com.mysql.jdbc.Driver" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.util.Hashtable" %>
<%!
//##########################################################################################

/*
Copyright (C) 2005-2010 WebLegs, Inc.
This program is free software: you can redistribute it and/or modify it under the terms
of the GNU General Public License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.
If not, see <http://www.gnu.org/licenses/>.
*/

//##########################################################################################

//--> Begin Class :: MySQLDriver
	public class MySQLDriver {
	
		//--> Begin :: Properties
			public Connection MyConnection;
			public String SQLCommand;
			public String ConnectionString;
			public String Host;
			public String Username;
			public String Password;
			public String Schema;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public MySQLDriver() throws SQLException {
				//register the driver
				DriverManager.registerDriver(new com.mysql.jdbc.Driver());
				
				this.MyConnection = null;
				this.SQLCommand = "";
				this.ConnectionString = "";
				this.Host = "";
				this.Username = "";
				this.Password = "";
				this.Schema = "";
			}
			public MySQLDriver(String ConnectionString) throws SQLException {
				//register the driver
				DriverManager.registerDriver(new com.mysql.jdbc.Driver());
				
				this.MyConnection = null;
				this.SQLCommand = "";
				this.ConnectionString = ConnectionString;
				this.Host = "";
				this.Username = "";
				this.Password = "";
				this.Schema = "";
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin :: Destructor
			protected void finalize() throws Exception {
				this.Close();
			}
		//<-- End :: Destructor
		
		//##################################################################################
		
		//--> Begin Method :: Open
			public void Open() throws SQLException {
				if(this.MyConnection == null){
					if(this.ConnectionString.equals("")){
						this.ConnectionString = "jdbc:mysql://"+ this.Host +":3306"+ (this.Schema.length() == 0 ? "" : "/"+ this.Schema);
					}
					
					//open connection
					this.MyConnection = DriverManager.getConnection(this.ConnectionString, this.Username, this.Password);
				}
			}
		//<-- End Method :: Open
		
		//##################################################################################
		
		//--> Begin Method :: Close
			public void Close() throws SQLException {
				if(this.MyConnection != null){
					this.MyConnection.close();
					this.MyConnection = null;
				}
			}
		//<-- End Method :: Close
		
		//##################################################################################
		
		//--> Begin Method :: Escape
			public String Escape(String Value) {
				return Value.replace("'", "''").replace("\\", "\\\\");
			}
		//<-- End Method :: Escape
		
		//##################################################################################
		
		//--> Begin Method :: SQLKey
			public void SQLKey(String Key, String Value) {
				this.SQLCommand = this.SQLCommand.replace(Key, this.Escape(Value));
			}
		//<-- End Method :: SQLKey
		
		//##################################################################################
		
		//--> Begin Method :: ExecuteNonQuery
			public void ExecuteNonQuery() throws SQLException {
				Statement MyStatement = MyConnection.createStatement();
				MyStatement.executeUpdate(this.SQLCommand);
			}
		//<-- End Method :: ExecuteNonQuery
		
		//##################################################################################
		
		//--> Begin Method :: GetDataString
			public String GetDataString(String RowSeperatedBy, String FieldsSeperatedBy, String FieldsEnclosedBy, boolean ReturnHeaders) throws SQLException {
				//get result
				String MyResult = "";
				
				//get datatable
				Hashtable myDataTable[] = this.GetDataTable();
				
				if(myDataTable.length > 0){
					
					//get column names
					Object ColumnNames[] = myDataTable[0].keySet().toArray();
					
					//header row
					if(ReturnHeaders) {
						for(int i = 0; i < ColumnNames.length; i++) {
							MyResult += FieldsEnclosedBy + ColumnNames[i].toString() + FieldsEnclosedBy;
							if(i + 1 != ColumnNames.length) {
								MyResult += FieldsSeperatedBy;
							}
						}
						MyResult += RowSeperatedBy;
					}
					
					//data rows
					for(int i = 0 ; i < myDataTable.length ; i++) {
						for(int j = 0 ; j < ColumnNames.length ; j++) {
							String MyData = myDataTable[i].get(ColumnNames[j].toString()).toString();
							if(!FieldsEnclosedBy.equals("")) MyData = MyData.replace(FieldsEnclosedBy, FieldsEnclosedBy + FieldsEnclosedBy);
							MyResult += FieldsEnclosedBy + MyData + FieldsEnclosedBy;
							if(j + 1 != ColumnNames.length){
								MyResult += FieldsSeperatedBy;
							}
						}
						if(i + 1 != myDataTable.length) {
							MyResult += RowSeperatedBy;
						}
					}
					
				}
				return MyResult;
			}
			public String GetDataString() throws SQLException {
				return this.GetDataString("", "", "", false);
			}
			public String GetDataString(String RowSeperatedBy) throws SQLException {
				return this.GetDataString(RowSeperatedBy, "", "", false);
			}
			public String GetDataString(String RowSeperatedBy, String FieldsSeperatedBy) throws SQLException {
				return this.GetDataString(RowSeperatedBy, FieldsSeperatedBy, "", false);
			}
			public String GetDataString(String RowSeperatedBy, String FieldsSeperatedBy, String FieldsEnclosedBy) throws SQLException {
				return this.GetDataString(RowSeperatedBy, FieldsSeperatedBy, FieldsEnclosedBy, false);
			}
		//<-- End Method :: GetDataString
		
		//##################################################################################
		
		//--> Begin Method :: GetLastInsertID
			public String GetLastInsertID() throws SQLException {
				Statement MyStatement = MyConnection.createStatement();
				ResultSet MyResultSet = MyStatement.executeQuery("SELECT LAST_INSERT_ID();");
				
				//get first row
				MyResultSet.next();
				return MyResultSet.getString("LAST_INSERT_ID()");
			}
		//<-- End Method :: GetLastInsertID
		
		//##################################################################################
		
		//--> Begin Method :: GetFoundRows
			public int GetFoundRows() throws SQLException {
				Statement MyStatement = MyConnection.createStatement();
				ResultSet MyResultSet = MyStatement.executeQuery("SELECT FOUND_ROWS() AS TotalCount;");
				
				//get first row
				MyResultSet.next();
				return MyResultSet.getInt("TotalCount");
			}
		//<-- End Method :: GetFoundRows
		
		//##################################################################################
		
		//--> Begin Method :: GetDataRow
			public Hashtable GetDataRow() throws SQLException {
				//execute query
				Statement MyStatement = MyConnection.createStatement();
				ResultSet MyResultSet = MyStatement.executeQuery(this.SQLCommand);
				
				//create container
				Hashtable ReturnData = new Hashtable();
				
				//get row count - i think this is kind of crazy...basic shi*
				MyResultSet.last();
				int RowCount = MyResultSet.getRow();
				MyResultSet.beforeFirst();
				
				if(RowCount > 0){
					//get column count
					int ColumnCount = MyResultSet.getMetaData().getColumnCount();
					
					//get first row
					MyResultSet.next();
				
					//index starts at 1
					for(int i = 1; i < ColumnCount + 1; i++) {
						
						//get column name
						String ColumnName = MyResultSet.getMetaData().getColumnLabel(i);
						
						//set key values
						ReturnData.put(ColumnName, MyResultSet.getString(ColumnName));
					}
					
					return ReturnData;
				}
				else{
					return null;
				}
			}
		//<-- End Method :: GetDataRow
		
		//##################################################################################
		
		//--> Begin Method :: GetResultSet
			public ResultSet GetResultSet() throws SQLException {
				Statement MyStatement = MyConnection.createStatement();
				return MyStatement.executeQuery(this.SQLCommand);
			}
		//<-- End Method :: GetResultSet
		
		//##################################################################################
		
		//--> Begin Method :: GetDataTable
			public Hashtable[] GetDataTable() throws SQLException {
				//execute query
				Statement MyStatement = MyConnection.createStatement();
				ResultSet MyResultSet = MyStatement.executeQuery(this.SQLCommand);
				
				//get row count
				MyResultSet.last();
				int RowCount = MyResultSet.getRow();
				MyResultSet.beforeFirst();
	
				//create container
				Hashtable ReturnData[] = new Hashtable[RowCount];

				if(RowCount > 0){
					//get column count
					int ColumnCount = MyResultSet.getMetaData().getColumnCount();
									
					//keep track of rows
					int MyIterator = 0;
					
					//iterate through each row
					while(MyResultSet.next()) {
						
						//create new hashtable
						ReturnData[MyIterator] = new Hashtable();
						
						//index starts at 1
						for(int i = 1; i < ColumnCount + 1; i++) {
							
							//get column name
							String ColumnName = MyResultSet.getMetaData().getColumnLabel(i);
							
							if(ColumnName != null && MyResultSet.getString(ColumnName) != null){
								//set key values
								ReturnData[MyIterator].put(ColumnName, MyResultSet.getString(ColumnName));
							}
						}
						
						MyIterator++;
					}
				}
				return ReturnData;
			}
		//<-- End Method :: GetDataTable
	}
//<-- End Class :: MySQLDriver

//##########################################################################################
%>