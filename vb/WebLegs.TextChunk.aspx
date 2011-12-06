<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
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

'/--> Begin Class :: TextChunk
	Public Class TextChunk 
		'/--> Begin :: Properties
			Public Blank As String
			Public Current As String 
			Public All As String 
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New() 
				Me.Blank = ""
				Me.Current = ""
				Me.All = ""
			End Sub
			Public Sub New(ByRef Source As String, Start As String, EndHere As String) 
				Dim MyStart As Integer = 0
				Dim MyEnd As Integer = 0
				
				If Source.IndexOf(Start) > -1 And Source.LastIndexOf(EndHere) > -1 Then
					MyStart = (Source.IndexOf(Start)) + Start.Length
					MyEnd = Source.LastIndexOf(EndHere)
					
					Try
						Me.Blank = Source.SubString(MyStart, MyEnd - MyStart)
					Catch 
						Throw New Exception("WebLegs.TextChunk.Constructor(): Boundry String mismatch.")
					End Try
				Else 
					Throw New Exception("WebLegs.TextChunk.Constructor(): Boundry Strings not present in source String.")
				End If
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: Begin
			Public Sub Begin() 
				Me.Current = Me.Blank
			End Sub
		'/<-- End Method :: Begin
		
		'/##################################################################################
		
		'/--> Begin Method :: End
			Public Sub [End]() 
				Me.All &= Me.Current
			End Sub
		'/<-- End Method :: End
		
		'/##################################################################################
		
		'/--> Begin Method :: Replace
			Public Function Replace(This As String, WithThis As String) 
				Me.Current = Me.Current.Replace(This, WithThis)
				Return Me
			End Function
		'/<-- End Method :: Replace
		
		'/##################################################################################
		
		'/--> Begin Method :: ToString
			Public Overrides Function ToString() As String 
				Return Me.All
			End Function
		'/<-- End Method :: ToString
	End Class
'/<-- End Class :: TextChunk

'/##########################################################################################
</script>