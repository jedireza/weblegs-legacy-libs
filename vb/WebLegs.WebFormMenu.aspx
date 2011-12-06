<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
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

'/--> Begin Class :: WebFormMenu
	Public Class WebFormMenu 
		'/--> Begin :: Properties
			Public Name As String
			Public Size As Integer
			Public SelectMultiple As Boolean
			Public Attributes As List(Of String())
			Public SelectedValues As StringCollection
			Public Options As List(Of String())
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: WebFormMenu
			Public Sub New() 
				Me.Name = ""
				Me.Size = 1
				Me.SelectMultiple = False
				Me.Attributes = New List(Of String())()
				Me.SelectedValues = New StringCollection()
				Me.Options = New List(Of String())()
			End Sub
			Public Sub New(Name As String, Size As Integer, SelectMultiple As Boolean) 
				Me.Name = Name
				Me.Size = Size
				Me.SelectMultiple = SelectMultiple
				Me.Attributes = New List(Of String())()
				Me.SelectedValues = New StringCollection()
				Me.Options = New List(Of String())()
			End Sub
		'/<-- End :: WebFormMenu
		
		'/##################################################################################
		
		'/--> Begin Method :: AddAttribute
			Public Sub AddAttribute(Name As String, Value As String) 
				Me.Attributes.Add(New String(){Name,Value})
				'Me.Attributes.Add(Name, Value)
			End Sub
		'/<-- End Method :: AddAttribute
		
		'/##################################################################################
		
		'/--> Begin Method :: AddOption
			Public Sub AddOption(Label As String, Value As String) 
				Me.Options.Add(New String(){Label,Value})
			End Sub
			Public Sub AddOption(Label As String, Value As String, Custom As String) 
				Me.Options.Add(New String(){Label,Value,Custom})
			End Sub
			Public Sub AddOption(Label As String, Value As String, Custom As String, GroupFlag As String) 
				Me.Options.Add(New String(){Label,Value,Custom,GroupFlag})
			End Sub
		'/<-- End Method :: AddOption
		
		'/##################################################################################
		
		'/--> Begin Method :: AddOptionGroup
			Public Sub AddOptionGroup(Label As String) 
				Me.Options.Add(New String(){Label,"","","group"})
			End Sub
			Public Sub AddOptionGroup(Label As String, Custom As String) 
				Me.Options.Add(New String(){Label,"",Custom,"group"})
			End Sub
		'/<-- End Method :: AddOptionGroup
		
		'/##################################################################################
		
		'/--> Begin Method :: AddSelectedValue
			Public Sub AddSelectedValue(Value As String) 
				Me.SelectedValues.Add(Value)
			End Sub
		'/<-- End Method :: AddSelectedValue
		
		'/##################################################################################
		
		'/--> Begin Method :: GetOptionTags
			Public Function GetOptionTags() As String
				'main container
				Dim tmpOptionTags As String = ""
				
				'last group ByReference
				Dim LastGroupReference As Integer = Nothing
				
				'build options
				For i As Integer = 0 To Me.Options.Count - 1
					'check for groups
					If(Me.Options(i).Length = 4) 
						'was there a group before this
						If LastGroupReference = Nothing Then
							LastGroupReference = i
						Else 
							tmpOptionTags &= "</optgroup>"
							LastGroupReference = i
						End If
						tmpOptionTags &= "<optgroup label="""& Codec.HTMLEncode(Me.Options.Item(i)(0)) &""" "& Me.Options.Item(i)(2) &">"
					'normal option
					Else 
						Dim Custom As String = ""
						If Me.Options.Item(i).Length = 3 Then Custom = " "& Me.Options.Item(i)(2)
						tmpOptionTags &= "<option value="""& Codec.HTMLEncode(Me.Options.Item(i)(1)) &""""& IIf(Me.SelectedValues.Contains(Me.Options.Item(i)(1)), " selected=""selected""", "") & Custom &">"& Codec.HTMLEncode(Me.Options.Item(i)(0)) &"</option>"
					End If
					
					'should end a group
					If LastGroupReference <> Nothing And ((i + 1) = Me.Options.Count) Then
						tmpOptionTags &= "</optgroup>"
					End If
				Next
				Return tmpOptionTags
			End Function
		'/<-- End Method :: GetOptionTags
		
		'/##################################################################################
		
		'/--> Begin Method :: ToString
			Public Overrides Function ToString() As String
				Dim tmpDropDown As String = ""
				
				'start the beginning select tag
				tmpDropDown &= "<select name="""& Me.Name &""" size="""& Me.Size.ToString() &""""& IIf(Me.SelectMultiple, " multiple=""multiple""", "")
					
				'add any custom attributes
				For i As Integer = 0 To Me.Attributes.Count - 1
					tmpDropDown &= " "& Me.Attributes.Item(i)(0) &"="""& Me.Attributes.Item(i)(1) &""""
				Next
				
				'finish the begining select tag
				tmpDropDown &= ">"
				
				'add the options
				tmpDropDown &= Me.GetOptionTags()
				
				'finish building the select tag
				tmpDropDown &= "</select>"
				
				Return tmpDropDown
			End Function
		'/<-- End Method :: ToString
	End Class
'/<-- End Class :: WebFormMenu

'/##########################################################################################
</script>