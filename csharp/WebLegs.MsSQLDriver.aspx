<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
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

//--> Begin Class :: MsSQLDriver
	public class MsSQLDriver {
		//--> Begin :: Properties
			//basic properties
			public SqlConnection MyConnection;
			public string SQLCommand;
			
			//c# specific properties
			public string ConnectionString;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public MsSQLDriver() {
				//properties
				this.MyConnection = new SqlConnection();
				this.SQLCommand = "";
				
				//c# specific properties
				this.ConnectionString = "";
			}
			public MsSQLDriver(string ConnectionString) {
				//properties
				this.MyConnection = new SqlConnection();
				this.SQLCommand = "";
				
				//c# specific properties
				this.ConnectionString = ConnectionString;
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin :: Destructor
			~MsSQLDriver() {
				this.Close();
			}
		//<-- End :: Destructor
		
		//##################################################################################
		
		//--> Begin Method :: Open
			public void Open() {
				if(this.MyConnection.State.ToString() == "Closed") {
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
			public string Escape(string InpString) {
				return InpString.Replace("'", "''").Replace("\\", "\\\\");
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
				SqlCommand MyCommand = new SqlCommand(this.SQLCommand, this.MyConnection);
				MyCommand.ExecuteNonQuery();
				MyCommand.Dispose();
			}
		//<-- End Method :: ExecuteNonQuery
		
		//##################################################################################
		
		//--> Begin Method :: GetDataString
			public string GetDataString(string RowSeperatedBy, string FieldsSeperatedBy, string FieldsEnclosedBy, bool ReturnHeaders) {
				SqlDataAdapter MyAdapter = new SqlDataAdapter(this.SQLCommand, this.MyConnection);
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
				SqlDataAdapter MyAdapter = new SqlDataAdapter("SELECT Scope_Identity() AS last_insert;", this.MyConnection);
				DataSet MyDataSet = new DataSet();
				MyAdapter.Fill(MyDataSet, "Results");
				MyAdapter.Dispose();
				return MyDataSet.Tables[0].Rows[0]["last_insert"].ToString();
			}
		//<-- End Method :: GetLastInsertID
		
		//##################################################################################
		
		//--> Begin Method :: GetFoundRows
			public int GetFoundRows() {
				SqlDataAdapter MyAdapter = new SqlDataAdapter("SELECT COUNT(*) AS TotalCount FROM ("+ this.SQLCommand +") AS CountTable;", this.MyConnection);
				DataSet MyDataSet = new DataSet();
				MyAdapter.Fill(MyDataSet, "Results");
				MyAdapter.Dispose();
				return Convert.ToInt32(MyDataSet.Tables[0].Rows[0]["TotalCount"].ToString());
			}
		//<-- End Method :: GetFoundRows
		
		//##################################################################################
		
		//--> Begin Method :: GetDataRow
			public DataRow GetDataRow() {
				SqlDataAdapter MyAdapter = new SqlDataAdapter(this.SQLCommand, this.MyConnection);
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
				SqlDataAdapter MyAdapter = new SqlDataAdapter(this.SQLCommand, this.MyConnection);
				DataSet MyDataSet = new DataSet();
				MyAdapter.Fill(MyDataSet);
				MyAdapter.Dispose();
				return MyDataSet;
			}
		//<-- End Method :: GetDataSet
		
		//##################################################################################
		
		//--> Begin Method :: GetDataTable
			public DataTable GetDataTable() {
				SqlDataAdapter MyAdapter = new SqlDataAdapter(this.SQLCommand, this.MyConnection);
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