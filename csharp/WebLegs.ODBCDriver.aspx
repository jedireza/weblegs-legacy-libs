<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Odbc" %>
<script language="c#" runat="server">
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

//--> Begin Class :: ODBCDriver
	public class ODBCDriver {
		//--> Begin :: Properties
			public OdbcConnection MyConnection;
			public string SQLCommand;
			public string ConnectionString;
			public string Host;
			public string Username;
			public string Password;
			public string Schema;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public ODBCDriver() {
				this.MyConnection = new OdbcConnection();
				this.SQLCommand = "";
				this.ConnectionString = "";
				this.Host = "";
				this.Username = "";
				this.Password = "";
				this.Schema = "";
			}
			public ODBCDriver(string ConnectionString) {
				this.MyConnection = new OdbcConnection();
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
			~ODBCDriver() {
				this.Close();
			}
		//<-- End :: Destructor
		
		//##################################################################################
		
		//--> Begin Method :: Open
			public void Open() {
				if(this.MyConnection.State.ToString() == "Closed") {
					if(this.ConnectionString.Length == 0) {
						this.ConnectionString += "server="+ this.Host +";";
						this.ConnectionString += "uid="+ this.Username +";";
						this.ConnectionString += "pwd="+ this.Password +";";
						this.ConnectionString += "database="+ this.Schema +";";
					}
					
					this.MyConnection.ConnectionString = this.ConnectionString;
					this.MyConnection.Open();
				}
			}
		//<-- End Method :: Open
		
		//##################################################################################
		
		//--> Begin Method :: Close
			public void Close() {
				if(this.MyConnection.State.ToString() != "Closed") {
					this.MyConnection.Close();
					this.MyConnection.Dispose();
				}
			}
		//<-- End Method :: Close
		
		//##################################################################################
		
		//--> Begin Method :: Escape
			public string Escape(string Value) {
				return Value.Replace("'", "''").Replace("\\", "\\\\");
			}
		//<-- End Method :: Escape
		
		//##################################################################################
		
		//--> Begin Method :: SQLKey
			public void SQLKey(string Key, string Value) {
				this.SQLCommand = this.SQLCommand.Replace(Key, this.Escape(Value));
			}
		//<-- End Method :: SQLKey
		
		//##################################################################################
		
		//--> Begin Method :: ExecuteNonQuery
			public void ExecuteNonQuery() {
				OdbcCommand MyCommand = new OdbcCommand(this.SQLCommand, this.MyConnection);
				MyCommand.ExecuteNonQuery();
				MyCommand.Dispose();
			}
		//<-- End Method :: ExecuteNonQuery
		
		//##################################################################################
		
		//--> Begin Method :: GetDataString
			public string GetDataString(string RowSeperatedBy, string FieldsSeperatedBy, string FieldsEnclosedBy, bool ReturnHeaders) {
				OdbcDataAdapter MyAdapter = new OdbcDataAdapter(this.SQLCommand, this.MyConnection);
				DataSet MyDataSet = new DataSet();
				MyAdapter.Fill(MyDataSet, "Results");
				MyAdapter.Dispose();
				DataTable myDataTable = MyDataSet.Tables[0];
				
				string MyResult = "";
				
				//header row
				if(ReturnHeaders) {
					for(int i = 0 ; i < myDataTable.Columns.Count ; i++) {
						MyResult += FieldsEnclosedBy + myDataTable.Columns[i].ColumnName + FieldsEnclosedBy;
						if(i + 1 != myDataTable.Columns.Count) {
							MyResult += FieldsSeperatedBy;
						}
					}
					MyResult += RowSeperatedBy;
				}
				
				//data rows
				for(int i = 0 ; i < myDataTable.Rows.Count ; i++) {
					for(int j = 0 ; j < myDataTable.Columns.Count ; j++) {
						string MyData = myDataTable.Rows[i][myDataTable.Columns[j].ColumnName].ToString();
						if(FieldsEnclosedBy != "") MyData = MyData.Replace(FieldsEnclosedBy, FieldsEnclosedBy + FieldsEnclosedBy);
						MyResult += FieldsEnclosedBy + MyData + FieldsEnclosedBy;
						if(j + 1 != myDataTable.Columns.Count) {
							MyResult += FieldsSeperatedBy;
						}
					}
					if(i + 1 != myDataTable.Rows.Count) {
						MyResult += RowSeperatedBy;
					}
				}
				
				return MyResult;
			}
			public string GetDataString() {
				return this.GetDataString("", "", "", false);
			}
			public string GetDataString(string RowSeperatedBy) {
				return this.GetDataString(RowSeperatedBy, "", "", false);
			}
			public string GetDataString(string RowSeperatedBy, string FieldsSeperatedBy) {
				return this.GetDataString(RowSeperatedBy, FieldsSeperatedBy, "", false);
			}
			public string GetDataString(string RowSeperatedBy, string FieldsSeperatedBy, string FieldsEnclosedBy) {
				return this.GetDataString(RowSeperatedBy, FieldsSeperatedBy, FieldsEnclosedBy, false);
			}		
		//<-- End Method :: GetDataString
		
		//##################################################################################
		
		//--> Begin Method :: GetLastInsertID
			public string GetLastInsertID() {
				OdbcDataAdapter MyAdapter = new OdbcDataAdapter("SELECT LAST_INSERT_ID();", this.MyConnection);
				DataSet MyDataSet = new DataSet();
				MyAdapter.Fill(MyDataSet, "Results");
				MyAdapter.Dispose();
				return MyDataSet.Tables[0].Rows[0]["LAST_INSERT_ID()"].ToString();
			}
		//<-- End Method :: GetLastInsertID
		
		//##################################################################################
		
		//--> Begin Method :: GetFoundRows
			public int GetFoundRows() {
				OdbcDataAdapter MyAdapter = new OdbcDataAdapter("SELECT FOUND_ROWS() AS TotalCount;", this.MyConnection);
				DataSet MyDataSet = new DataSet();
				MyAdapter.Fill(MyDataSet, "Results");
				MyAdapter.Dispose();
				return Convert.ToInt32(MyDataSet.Tables[0].Rows[0]["TotalCount"].ToString());
			}
		//<-- End Method :: GetFoundRows
		
		//##################################################################################
		
		//--> Begin Method :: GetDataRow
			public DataRow GetDataRow() {
				OdbcDataAdapter MyAdapter = new OdbcDataAdapter(this.SQLCommand, this.MyConnection);
				DataSet MyDataSet = new DataSet();
				MyAdapter.Fill(MyDataSet, "Results");
				MyAdapter.Dispose();
				DataTable tblMyDT = MyDataSet.Tables[0];
				if(tblMyDT.Rows.Count > 0) {
					return tblMyDT.Rows[0];
				}
				else {
					return null;
				}
			}
		//<-- End Method :: GetDataRow
		
		//##################################################################################
		
		//--> Begin Method :: GetDataSet
			public DataSet GetDataSet() {
				OdbcDataAdapter MyAdapter = new OdbcDataAdapter(this.SQLCommand, this.MyConnection);
				DataSet MyDataSet = new DataSet();
				MyAdapter.Fill(MyDataSet);
				MyAdapter.Dispose();
				return MyDataSet;
			}
		//<-- End Method :: GetDataSet
		
		//##################################################################################
		
		//--> Begin Method :: GetDataTable
			public DataTable GetDataTable() {
				OdbcDataAdapter MyAdapter = new OdbcDataAdapter(this.SQLCommand, this.MyConnection);
				DataSet MyDataSet = new DataSet();
				MyAdapter.Fill(MyDataSet, "Results");
				MyAdapter.Dispose();
				return MyDataSet.Tables[0];
			}
		//<-- End Method :: GetDataTable
	}
//<-- End Class :: MsSQLDriver

//##########################################################################################
</script>