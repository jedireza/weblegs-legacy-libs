<%@ Import Namespace="System" %>
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

'/--> Begin Class :: DataPager
	Public Class DataPager
		'/--> Begin :: Properties
			Public RecordsPerPage AS Integer
			Public TotalRecords AS Integer
			Public CurrentPage AS Integer
			Public LinkLoopOffset AS Integer
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New()
				Me.RecordsPerPage = 0
				Me.TotalRecords = 0
				Me.CurrentPage = 0
				Me.LinkLoopOffset = 0
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: GetTotalPages
			Public Function GetTotalPages() As Integer
				Dim TotalPages As Integer = Math.Floor(Me.TotalRecords / Me.RecordsPerPage)
				If (TotalRecords Mod Me.RecordsPerPage) > 0 Then
					TotalPages += 1
				End If
				Return TotalPages
			End Function
		'/<-- End Method :: GetTotalPages
		
		'/##################################################################################
		
		'/--> Begin Method :: GetRecordToStart
			Public Function GetRecordToStart() As Integer
				Dim RecordToStart As Integer = 0
				If Me.CurrentPage > Me.GetTotalPages() Then
					Me.CurrentPage = Me.GetTotalPages()
				End If
				RecordToStart = (Me.CurrentPage - 1) * Me.RecordsPerPage
				If RecordToStart < 0 Then
					RecordToStart = 0
				End If
				Return RecordToStart
			End Function
		'/<-- End Method :: GetRecordToStart
		
		'/##################################################################################
		
		'/--> Begin Method :: GetRecordToStop
			Public Function GetRecordToStop() As Integer
				Dim RecordToStop As Integer = Me.GetRecordToStart() + Me.RecordsPerPage
				If RecordToStop > Me.TotalRecords Then
					RecordToStop = Me.TotalRecords
				End If
				Return RecordToStop
			End Function
		'/<-- End Method :: GetRecordToStop
		
		'/##################################################################################
		
		'/--> Begin Method :: GetPreviousPage
			Public Function GetPreviousPage() As Integer
				If (Me.CurrentPage - 1) <= 0 Then
					Return 1
				Else
					Return Me.CurrentPage - 1
				End If
			End Function
		'/<-- End Method :: GetPreviousPage
		
		'/##################################################################################
		
		'/--> Begin Method :: GetNextPage
			Public Function GetNextPage() As Integer
				If (Me.CurrentPage + 1) > Me.GetTotalPages() Then
					Return Me.GetTotalPages()
				Else
					Return Me.CurrentPage + 1
				End If
			End Function
		'/<-- End Method :: GetNextPage
		
		'/##################################################################################
		
		'/--> Begin Method :: HasPreviousPage
			Public Function HasPreviousPage() As Boolean
				If (Me.CurrentPage - 1) <= 0 Then
					Return False
				Else
					Return True
				End If
			End Function
		'/<-- End Method :: HasPreviousPage
		
		'/##################################################################################
		
		'/--> Begin Method :: HasNextPage
			Public function HasNextPage() AS Boolean
				If (Me.CurrentPage + 1) > Me.GetTotalPages() Then
					Return False
				Else
					Return True
				End If
			End Function
		'/<-- End Method :: HasNextPage
		
		'/##################################################################################
		
		'/--> Begin Method :: GetLinkLoopStart
			Public Function GetLinkLoopStart() As Integer
				If (Me.CurrentPage - Me.LinkLoopOffset) < 1 Then
					Return 1
				Else
					Return Me.CurrentPage - Me.LinkLoopOffset
				End If
			End Function
		'/<-- End Method :: GetLinkLoopStart
		
		'/##################################################################################
		
		'/--> Begin Method :: GetLinkLoopStop
			Public Function GetLinkLoopStop() As Integer
				If (Me.CurrentPage + Me.LinkLoopOffset) > Me.GetTotalPages() Then
					Return Me.GetTotalPages()
				Else
					Return Me.CurrentPage + Me.LinkLoopOffset
				End If
			End Function
		'/<-- End Method :: GetLinkLoopStop
	End Class
'/<-- End Class :: DataPager

'/##########################################################################################
</script>