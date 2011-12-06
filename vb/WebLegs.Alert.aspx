<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
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

'/--> Begin Class :: Alert
	Public Class Alert
		'/--> Begin :: Properties
			Public Alerts As List(Of String)
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New()
				Me.Alerts = New List(Of String)
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: Add
			Public Sub Add(Value As String)
				Me.Alerts.Add(Value)
			End Sub
		'/<-- End Method :: Add
		
		'/##################################################################################
		
		'/--> Begin Method :: Count
			Public Function Count() As Integer
				Return Me.Alerts.Count
			End Function
		'/<-- End Method :: Count
		
		'/##################################################################################
		
		'/--> Begin Method :: Item
			Public Function Item(Index As String) As String
				Return Item(Convert.ToInt32(Index))
			End Function
			Public Function Item(Index As Integer) As String
				Return Me.Alerts.Item(Index)
			End Function
		'/<-- End Method :: Item
		
		'/##################################################################################
		
		'/--> Begin Method :: ToJSON
			Public Function ToJSON() As String
				Dim AlertJSON As String = ""
				AlertJSON &= "{"
				
				'build the json
				For i As Integer = 0 To Me.Alerts.Count - 1
					AlertJSON &= """"& (i+1) &""":"""& Me.Alerts.Item(i).Replace("""", "\\""") &""""
					If i+1 <> Me.Alerts.Count Then
						AlertJSON &= ","
					End If
				Next
				
				AlertJSON &= "}"
				Return AlertJSON
			End Function
		'/<-- End Method :: ToJSON
		
		'/##################################################################################
		
		'/--> Begin Method :: ToArray
			Public Function ToArray() As String()
				'how man items?
				Dim AlertArray(Me.Alerts.Count) As String
				
				'build the array
				For i As Integer = 0 To Me.Alerts.Count - 1
					AlertArray(i) = Me.Alerts.Item(i)
				Next
				
				'Return the new array
				Return AlertArray
			End Function
		'/<-- End Method :: ToArray
	End Class
'/<-- End Class :: Alert

'/##########################################################################################
</script>