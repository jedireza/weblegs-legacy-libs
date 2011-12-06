<%@ Import Namespace="System" %>
<script language="vb" runat="server">
'/##########################################################################################

'/*
'Copyright (C) 2005-2010 WebLegs, Inc.
'This program is free software: you can redistribute it and/or modIfy it under the terms
'of the GNU General Public Shared License as published by the Free Software Foundation, either
'version 3 of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
'without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
'See the GNU General Public Shared License for more details.
'
'You should have received a copy of the GNU General Public Shared License along with this program.
'If not, see <http:'www.gnu.org/licenses/>.
'*/

'/##########################################################################################

'/--> Begin Class :: WebForm
	Public Class WebForm 
		'/--> Begin :: Properties
			'no properties
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			'no constructor
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: RadioButton
			Public Shared Function RadioButton(Name As String, Value As String, Checked As Boolean, Disabled As Boolean, Custom As String) As String
				Return "<input type=""radio"" name="""& Name &""" value="""& Codec.HTMLEncode(Value) &""" "& IIf(Disabled = True, "disabled=""disabled"" ", "") + IIf(Checked = True, "checked=""checked"" ", "") + IIf(Custom <> "", Custom, "") &" />"
			End Function
		'/<-- End Method :: RadioButton
		
		'/##################################################################################
		
		'/--> Begin Method :: CheckBox
			Public Shared Function CheckBox(Name As String, Value As String, Checked As Boolean, Disabled As Boolean, Custom As String) As String
				Return "<input type=""checkbox"" name="""& Name &""" value="""& Codec.HTMLEncode(Value) &""" "& IIf(Disabled = True, "disabled=""disabled"" ", "") + IIf(Checked = True, "checked=""checked"" ", "") + IIf(Custom <> "", Custom, "") &" />"
			End Function
		'/<-- End Method :: CheckBox
		
		'/##################################################################################
		
		'/--> Begin Method :: HiddenField
			Public Shared Function HiddenField(Name As String, Value As String) As String
				Return "<input type=""hidden"" name="""& Name &""" value="""& Codec.HTMLEncode(Value) &""" />"
			End Function
			Public Shared Function HiddenField(Name As String, Value As String, Custom As String) As String
				Return "<input type=""hidden"" name="""& Name &""" value="""& Codec.HTMLEncode(Value) &""" "& IIf(Custom <> "", Custom, "") &" />"
			End Function
		'/<-- End Method :: HiddenField
		
		'/##################################################################################
		
		'/--> Begin Method :: TextBox
			Public Shared Function TextBox(Name As String, Value As String, Size As Integer, MaxLength As Integer, Disabled As Boolean, Custom As String) As String
				Return "<input type=""text"" name="""& Name &""" size="""& Size &""" maxlength="""& MaxLength &""" value="""& Codec.HTMLEncode(Value) &""" "& IIf(Disabled = True, "disabled=""disabled"" ", "") + IIf(Custom <> "", Custom, "") &" />"
			End Function
		'/<-- End Method :: TextBox
		
		'/##################################################################################
		
		'/--> Begin Method :: PasswordBox
			Public Shared Function PasswordBox(Name As String, Value As String, Size As Integer, MaxLength As Integer, Disabled As Boolean, Custom As String) As String
				Return "<input type=""password"" name="""& Name &""" size="""& Size &""" maxlength="""& MaxLength &""" value="""& Codec.HTMLEncode(Value) &""" "& IIf(Disabled = True, "disabled=""disabled"" ", "") + IIf(Custom <> "", Custom, "") &" />"
			End Function
		'/<-- End Method :: PasswordBox
		
		'/##################################################################################
		
		'/--> Begin Method :: TextArea
			Public Shared Function TextArea(Name As String, Value As String, NumCols As Integer, NumRows As Integer, Disabled As Boolean, Custom As String) As String
				Return "<textarea name="""& Name &""" cols="""& NumCols &""" rows="""& NumRows &""" "& IIf(Disabled = True, "disabled=""disabled"" ", "") + IIf(Custom <> "", Custom, "") &">"& Codec.HTMLEncode(Value) &"</textarea>"
			End Function
		'/<-- End Method :: TextArea
		
		'/##################################################################################
		
		'/--> Begin Method :: FileField
			Public Shared Function FileField(Name As String, Size As Integer, Disabled As Boolean, Custom As String) As String
				Return "<input type=""file"" name="""& Name &""" size="""& Size &""" "& IIf(Disabled = True, "disabled=""disabled"" ", "") + IIf(Custom <> "", Custom, "") &" />"
			End Function
		'/<-- End Method :: FileField
		
		'/##################################################################################
		
		'/--> Begin Method :: Button
			Public Shared Function Button(Name As String, Value As String, Disabled As Boolean, Custom As String) As String
				Return "<input type=""button"" name="""& Name &""" value="""& Codec.HTMLEncode(Value) &""" "& IIf(Disabled = True, "disabled=""disabled"" ", "") + IIf(Custom <> "", Custom, "") &" />"
			End Function
		'/<-- End Method :: Button
		
		'/##################################################################################
		
		'/--> Begin Method :: SubmitButton
			Public Shared Function SubmitButton(Name As String, Value As String, Disabled As Boolean, Custom As String) As String
				Return "<input type=""submit"" name="""& Name &""" value="""& Codec.HTMLEncode(Value) &""" "& IIf(Disabled = True, "disabled=""disabled"" ", "") + IIf(Custom <> "", Custom, "") &" />"
			End Function
		'/<-- End Method :: SubmitButton
		
		'/##################################################################################
		
		'/--> Begin Method :: ResetButton
			Public Shared Function ResetButton(Name As String, Value As String, Disabled As Boolean, Custom As String) As String
				Return "<input type=""reset"" name="""& Name &""" value="""& Codec.HTMLEncode(Value) &""" "& IIf(Disabled = True, "disabled=""disabled"" ", "") + IIf(Custom <> "", Custom, "") &" />"
			End Function
		'/<-- End Method :: ResetButton
		
		'/##################################################################################
		
		'/--> Begin Method :: DropDown
			Public Shared Function DropDown(Name As String, CurrentValue As String, Size As Integer, Options As String, Values As String, Disabled As Boolean, Custom As String) As String
				'dd collection String
				Dim tmpDropDown As String = ""
		
				'check If values should be the same as options
				If Values = "" Then
					Values = Options
				End If
				
				'break-out arrays
				Dim OptionsArray As String() = Options.Split("|")
				Dim ValuesArray As String() = Values.Split("|")
				
				'check If options/values are the same length
				If OptionsArray.Length <> ValuesArray.Length Then 
					'options and values didn't match
					Throw New Exception("WebLegs.WebForm.DropDown(): Option count is different than value count.")
				Else 
					'build drop down
					tmpDropDown = "<select name="""& Name &""" size="""& Size &""" "& IIf(Disabled = True, "disabled=""True""", "") &" "& IIf(Custom <> "", Custom, "") &">"
					For i As Integer = 0 To OptionsArray.Length - 1
						If CurrentValue = ValuesArray(i) Then
							tmpDropDown &= "<option value="""& Codec.HTMLEncode(ValuesArray(i)) &""" selected=""selected"">"& Codec.HTMLEncode(OptionsArray(i)) &"</option>"
						Else 
							tmpDropDown &= "<option value="""& Codec.HTMLEncode(ValuesArray(i)) &""">"& Codec.HTMLEncode(OptionsArray(i)) &"</option>"
						End If
					Next
					tmpDropDown += "</select>"
				End If
				Return tmpDropDown
			End Function
		'/<-- End Method :: DropDown
	End Class
'/<-- End Class :: WebForm

'/##########################################################################################
</script>