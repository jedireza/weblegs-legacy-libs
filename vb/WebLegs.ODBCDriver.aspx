<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Odbc" %>
<script language="vb" runat="server">
'/##########################################################################################

'/*
'Copyright (C) 2005-2010 WebLegs, Inc.
'This program is free software: you can redistribute it and/or modify it under the terms
'of the GNU General Public License as published by the Free Software Foundation, either
'version 3 of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
'without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
'See the GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License along with this program.
'If not, see <http://www.gnu.org/licenses/>.
'*/

'/##########################################################################################

'/--> Begin Class :: ODBCDriver
	Public Class ODBCDriver 
		'/--> Begin :: Properties
			Public MyConnection As OdbcConnection 
			Public SQLCommand As String 
			Public ConnectionString As String 
			Public Host As String 
			Public Username As String 
			Public Password As String 
			Public Schema As String 
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New() 
				Me.MyConnection = New OdbcConnection()
				Me.SQLCommand = ""
				Me.ConnectionString = ""
				Me.Host = ""
				Me.Username = ""
				Me.Password = ""
				Me.Schema = ""
			End Sub
			Public Sub New(ConnectionString As String) 
				Me.MyConnection = New OdbcConnection()
				Me.SQLCommand = ""
				Me.ConnectionString = ConnectionString
				Me.Host = ""
				Me.Username = ""
				Me.Password = ""
				Me.Schema = ""
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin :: Destructor
			Protected Overrides Sub Finalize()
				Me.Close()
			End Sub
		'/<-- End :: Destructor
		
		'/##################################################################################
		
		'/--> Begin Method :: Open
			Public Sub Open() 
				If Me.MyConnection.State.ToString() = "Closed" Then
					If Me.ConnectionString.Length = 0 Then
						Me.ConnectionString &= "server="& Me.Host &""
						Me.ConnectionString &= "uid="& Me.Username &""
						Me.ConnectionString &= "pwd="& Me.Password &""
						Me.ConnectionString &= "database="& Me.Schema &""
					End If
					
					Me.MyConnection.ConnectionString = Me.ConnectionString
					Me.MyConnection.Open()
				End If
			End Sub
		'/<-- End Method :: Open
		
		'/##################################################################################
		
		'/--> Begin Method :: Close
			Public Sub Close() 
				If Not Me.MyConnection.State.ToString() = "Closed" Then
					Me.MyConnection.Close()
					Me.MyConnection.Dispose()
				End If
			End Sub
		'/<-- End Method :: Close
		
		'/##################################################################################
		
		'/--> Begin Method :: Escape
			Public Function Escape(Value As String) As String
				Return Value.Replace("'", "''").Replace("\\", "\\\\")
			End Function
		'/<-- End Method :: Escape
		
		'/##################################################################################
		
		'/--> Begin Method :: SQLKey
			Public Sub SQLKey(Key As String, Value As String) 
				Me.SQLCommand = Me.SQLCommand.Replace(Key, Me.Escape(Value))
			End Sub
		'/<-- End Method :: SQLKey
		
		'/##################################################################################
		
		'/--> Begin Method :: ExecuteNonQuery
			Public Sub ExecuteNonQuery() 
				Dim MyCommand As OdbcCommand = New OdbcCommand(Me.SQLCommand, Me.MyConnection)
				MyCommand.ExecuteNonQuery()
				MyCommand.Dispose()
			End Sub
		'/<-- End Method :: ExecuteNonQuery
		
		'/##################################################################################
		
		'/--> Begin Method :: GetDataString
			Public Function GetDataString(RowSeperatedBy As String, FieldsSeperatedBy As String, FieldsEnclosedBy As String, ReturnHeaders As Boolean) As String
				Dim MyAdapter As OdbcDataAdapter = New OdbcDataAdapter(Me.SQLCommand, Me.MyConnection)
				Dim MyDataSet As DataSet = New DataSet()
				MyAdapter.Fill(MyDataSet, "Results")
				MyAdapter.Dispose()
				Dim myDataTable As DataTable = MyDataSet.Tables(0)
				
				Dim MyResult As String = ""
				
				'header row
				If ReturnHeaders Then
					For i As Integer = 0 To myDataTable.Columns.Count - 1
						MyResult &= FieldsEnclosedBy & myDataTable.Columns(i).ColumnName & FieldsEnclosedBy
						If i + 1 <> myDataTable.Columns.Count - 1
							MyResult &= FieldsSeperatedBy
						End if
					Next
					MyResult &= RowSeperatedBy
				End If
				
				'data rows
				For i As Integer = 0 To myDataTable.Rows.Count - 1
					For j As Integer = 0 To myDataTable.Columns.Count - 1
						Dim MyData As String = myDataTable.Rows(i)(myDataTable.Columns(j).ColumnName).ToString()
						If FieldsEnclosedBy <> "" Then MyData = MyData.Replace(FieldsEnclosedBy, FieldsEnclosedBy & FieldsEnclosedBy)
						MyResult &= FieldsEnclosedBy & MyData & FieldsEnclosedBy
						If j + 1 <> myDataTable.Columns.Count Then
							MyResult &= FieldsSeperatedBy
						End If
					Next
					If i + 1 <> myDataTable.Rows.Count Then
						MyResult &= RowSeperatedBy
					End If
				Next
				
				Return MyResult
			End Function
			Public Function GetDataString() As String
				Return Me.GetDataString("", "", "", False)
			End Function
			Public Function GetDataString(RowSeperatedBy As String) As String
				Return Me.GetDataString(RowSeperatedBy, "", "", False)
			End Function
			Public Function GetDataString(RowSeperatedBy As String, FieldsSeperatedBy As String) As String
				Return Me.GetDataString(RowSeperatedBy, FieldsSeperatedBy, "", False)
			End Function
			Public Function GetDataString(RowSeperatedBy As String, FieldsSeperatedBy As String, FieldsEnclosedBy As String) As String
				Return Me.GetDataString(RowSeperatedBy, FieldsSeperatedBy, FieldsEnclosedBy, False)
			End Function
		'/<-- End Method :: GetDataString
		
		'/##################################################################################
		
		'/--> Begin Method :: GetLastInsertID
			Public Function GetLastInsertID() As String
				Dim MyAdapter As OdbcDataAdapter = New OdbcDataAdapter("SELECT LAST_INSERT_ID()", Me.MyConnection)
				Dim MyDataSet As DataSet = New DataSet()
				MyAdapter.Fill(MyDataSet, "Results")
				MyAdapter.Dispose()
				Return MyDataSet.Tables(0).Rows(0)("LAST_INSERT_ID()").ToString()
			End Function
		'/<-- End Method :: GetLastInsertID
		
		'/##################################################################################
		
		'/--> Begin Method :: GetFoundRows
			Public Function GetFoundRows() As Integer
				Dim MyAdapter As OdbcDataAdapter = New OdbcDataAdapter("SELECT FOUND_ROWS() AS TotalCount", Me.MyConnection)
				Dim MyDataSet As DataSet = New DataSet()
				MyAdapter.Fill(MyDataSet, "Results")
				MyAdapter.Dispose()
				Return Convert.ToInt32(MyDataSet.Tables(0).Rows(0)("TotalCount").ToString())
			End Function
		'/<-- End Method :: GetFoundRows
		
		'/##################################################################################
		
		'/--> Begin Method :: GetDataRow
			Public Function GetDataRow() As DataRow
				Dim MyAdapter As OdbcDataAdapter = New OdbcDataAdapter(Me.SQLCommand, Me.MyConnection)
				Dim MyDataSet As DataSet = New DataSet()
				MyAdapter.Fill(MyDataSet, "Results")
				MyAdapter.Dispose()
				Dim tblMyDT As DataTable = MyDataSet.Tables(0)
				If tblMyDT.Rows.Count > 0 Then
					Return tblMyDT.Rows(0)
				Else 
					Return Nothing
				End If
			End Function
		'/<-- End Method :: GetDataRow
		
		'/##################################################################################
		
		'/--> Begin Method :: GetDataSet
			Public Function GetDataSet() As DataSet
				Dim MyAdapter As OdbcDataAdapter = New OdbcDataAdapter(Me.SQLCommand, Me.MyConnection)
				Dim MyDataSet As DataSet = New DataSet()
				MyAdapter.Fill(MyDataSet)
				MyAdapter.Dispose()
				Return MyDataSet
			End Function
		'/<-- End Method :: GetDataSet
		
		'/##################################################################################
		
		'/--> Begin Method :: GetDataTable
			Public Function GetDataTable() As DataTable
				Dim MyAdapter As OdbcDataAdapter = New OdbcDataAdapter(Me.SQLCommand, Me.MyConnection)
				Dim MyDataSet As DataSet = New DataSet()
				MyAdapter.Fill(MyDataSet, "Results")
				MyAdapter.Dispose()
				Return MyDataSet.Tables(0)
			End Function
		'/<-- End Method :: GetDataTable
	End Class
'/<-- End Class :: MsSQLDriver

'/##########################################################################################
</script>