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
'If not, see <http://www.gnu.org/licenses/>.
'*/

'/##########################################################################################

'/--> Begin Class :: DataValidator
	Public Class DataValidator 
		'/--> Begin :: Properties
			'no properties
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			'no constructor
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: IsValidEmail
			Public Shared Function IsValidEmail(EmailAddress As String) As Boolean
				Dim myEmailMatcher As Match = Regex.Match(EmailAddress, "^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
				Return myEmailMatcher.Success
			End Function 
		'/<-- End Method :: IsValidEmail
		
		'/##################################################################################
		
		'/--> Begin Method :: IsValidURL
			Public Shared Function IsValidURL(URL As String) As Boolean
				Dim myURLMatcher As Match = Regex.Match(URL, "^s?https?:\/\/[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+$")
				Return myURLMatcher.Success
			End Function
		'/<-- End Method :: IsValidURL
		
		'/##################################################################################
		
		'/--> Begin Method :: IsPhone
			Public Shared Function IsPhone(Value As String) As Boolean
				Return IsPhone(Value, "us")
			End Function
			Public Shared Function IsPhone(Value As String, CountryCode As String) As Boolean
				Select Case CountryCode.ToLower()
					Case "us"
						Dim myPhoneMatcher As Match = Regex.Match(Value, "^([01][\s\.-]?)?(\(\d{3}\)|\d{3})[\s\.-]?\d{3}[\s\.-]?\d{4}$")
						Return myPhoneMatcher.Success
					Case Else
						'do nothing
						Return False
				End Select
			End Function
		'/<-- End Method :: IsPhone
		
		'/##################################################################################
		
		'/--> Begin Method :: IsPostalCode
			Public Shared Function IsPostalCode(Value As String) As Boolean
				Return DataValidator.IsPostalCode(Value, "us")
			End Function
			Public Shared Function IsPostalCode(Value As String, CountryCode As String) As Boolean
				Select Case CountryCode.ToLower()
					Case "us"
						Dim myZipMatcher As Match = Regex.Match(Value, "^\d{5}(-?\d{4})?$")
						Return myZipMatcher.Success
					Case Else
						'do nothing
						Return False
				End Select
			End Function
		'/<-- End Method :: IsPostalCode
		
		'/##################################################################################
		
		'/--> Begin Method :: IsAlpha
			Public Shared Function IsAlpha(Value As String) As Boolean
				Dim myAlphaMatcher As Match = Regex.Match(Value, "^[a-zA-Z]+$")
				Return myAlphaMatcher.Success
			End Function
		'/<-- End Method :: IsAlpha
		
		'/##################################################################################
		
		'/--> Begin Method :: IsIPv4
			Public Shared Function IsIPv4(Value As String) As Boolean
				Dim myRegEx As Regex = new Regex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$")
				Return myRegEx.IsMatch(Value)
			End Function
		'/<-- End Method :: IsIPv4
		
		'/##################################################################################
		
		'/--> Begin Method :: IsInt
			Public Shared Function IsInt(Value As String) As Boolean
				Try 
					Dim Test As Integer = Convert.ToInt32(Value)
					Return True
				Catch e As Exception
					Return False
				End Try
			End Function
		'/<-- End Method :: IsInt
		
		'/##################################################################################
		
		'/--> Begin Method :: IsDouble
			Public Shared Function IsDouble(Value As String) As Boolean
				Try 
					Dim Test As Double = Convert.ToDouble(Value)
					Return True
				Catch e As Exception 
					Return False
				End Try
			End Function
		'/<-- End Method :: IsDouble
		
		'/##################################################################################
		
		'/--> Begin Method :: IsNumeric
			Public Shared Function IsNumeric(Value As String) As Boolean
				Return DataValidator.IsDouble(Value)
			End Function
		'/<-- End Method :: IsNumeric
		
		'/##################################################################################
		
		'/--> Begin Method :: IsDateTime
			Public Shared Function IsDateTime(Value As String) As Boolean
				Try 
					Dim Test As DateTIme = DateTime.Parse(Value)
					Return True
				Catch e As Exception 
					Return False
				End Try
			End Function
		'/<-- End Method :: IsDateTime
		
		'/##################################################################################
		
		'/--> Begin Method :: MinLength
			Public Shared Function MinLength(Value As String, Length As Integer) As Boolean
				If Value.Length >= Length Then
					Return True
				Else
					Return False
				End If
			End Function
		'/<-- End Method :: MinLength
		
		'/##################################################################################
		
		'/--> Begin Method :: MaxLength
			Public Shared Function MaxLength(Value As String, Length As Integer) As Boolean
				If Value.Length <= Length Then
					Return True
				Else
					Return False
				End If
			End Function
		'/<-- End Method :: MaxLength
		
		'/##################################################################################
		
		'/--> Begin Method :: Length
			Public Shared Function Length(Value As String, InpLength As Integer) As Boolean
				If Value.Length = InpLength
					Return True
				Else
					Return False
				End If
			End Function
		'/<-- End Method :: Length
	End Class
'/<-- End Class :: DataValidator

'/##########################################################################################
</script>