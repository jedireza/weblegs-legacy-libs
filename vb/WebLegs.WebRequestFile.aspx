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

'/--> Begin Class :: WebRequestFile
	Public Class WebRequestFile
		'/--> Begin :: Properties
			Public FormName As String
			Public FileName As String
			Public ContentType As String
			Public ContentLength As Integer
			
			'vb specific
			Public File As HttpPostedFile
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New()
				'do nothing
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: SaveAs
			Public Sub SaveAs(FilePath As String)
				Me.File.SaveAs(FilePath)
			End Sub
		'/<-- End Method :: SaveAs
	End Class
'/<-- End Class :: WebRequestFile

'/##########################################################################################
</script>