<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<script language="vb" runat="server">
'/##########################################################################################

'/*
'Copyright (C) 2005-2010 WebLegs, Inc.
'This program is free software: you can redistribute it and/or modIfy it under the terms
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

'/--> Begin Class :: Codec
	Public Class Codec
		'/--> Begin :: Properties
			'no properties
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			'no constructor
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: URLEncode
			Public Shared Function URLEncode(Input As String) As String 
				Return System.Web.HttpContext.Current.Server.UrlEncode(Input)
			End Function
		'/<-- End Method :: URLEncode
		
		'/##################################################################################
		
		'/--> Begin Method :: URLDecode
			Public Shared Function URLDecode(Input As String) As String
				Return System.Web.HttpContext.Current.Server.UrlDecode(Input)
			End Function
		'/<-- End Method :: URLDecode
		
		'/##################################################################################
		
		'/--> Begin Method :: HTMLEncode
			Public Shared Function HTMLEncode(Input As String) As String
				Return System.Web.HttpContext.Current.Server.HtmlEncode(Input)
			End Function
		'/<-- End Method :: HTMLEncode
		
		'/##################################################################################
		
		'/--> Begin Method :: HTMLDecode
			Public Shared Function HTMLDecode(Input As String) As String 
				Return System.Web.HttpContext.Current.Server.HtmlDecode(Input)
			End Function
		'/<-- End Method :: HTMLDecode
		
		'/##################################################################################
		
		'/--> Begin Method :: XMLEncode
			Public Shared Function XMLEncode(Input As String) As String
				Return Input.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;").Replace("""", "&quot;").Replace("'", "&apos;")
			End Function
		'/<-- End Method :: XMLEncode
		
		'/##################################################################################
		
		'/--> Begin Method :: XMLDecode
			Public Shared Function XMLDecode(Input As String) As String
				Return Input.Replace("&amp;", "&").Replace("&lt;", "<").Replace("&gt;", ">").Replace("&quot;", """").Replace("&apos;", "'")
			End Function
		'/<-- End Method :: XMLDecode
		
		'/##################################################################################
		
		'/--> Begin Method :: Base64Encode
			Public Shared Function Base64Encode(Input As String) As String 
				Dim StringBytes() As Byte = System.Text.Encoding.UTF8.GetBytes(Input)
				Return Codec.Base64Encode(StringBytes)
			End Function
			Public Shared Function Base64Encode(Input As Byte()) As String
				Return System.Convert.ToBase64String(Input, Base64FormattingOptions.InsertLineBreaks)
			End Function
		'/<-- End Method :: Base64Encode
		
		'/##################################################################################
		
		'/--> Begin Method :: Base64Decode
			Public Shared Function Base64Decode(Input As String) As String
				Dim EncodedData() As Byte = System.Convert.FromBase64String(Input)
				Dim myUTFEncoder As UTF7Encoding = New UTF7Encoding()
				Return myUTFEncoder.GetString(EncodedData)
			End Function
		'/<-- End Method :: Base64Decode
		
		'/##################################################################################
		
		'/--> Begin Method :: Base64DecodeBytes
			Public Shared Function Base64DecodeBytes(Input As String) As Byte()
				Return System.Convert.FromBase64String(Input)
			End Function
		'/<-- End Method :: Base64DecodeBytes
		
		'/##################################################################################
		
		'/--> Begin Method :: QuotedPrintableEncode
			Public Shared Function QuotedPrintableEncode(Input As String) As String
				'create an ascii encoding object
				Dim ASCIIEncoding As ASCIIEncoding = New ASCIIEncoding()
				
				'get the byte version of this data
				Dim ByteArray As Byte() = ASCIIEncoding.GetBytes(Input)
				
				'container for our final string
				Dim tmpQPString As StringBuilder = New StringBuilder()
				
				'container for our current line length
				Dim CurrentLineLength As Integer = 0
				
				'loop over bytes and build New string
				For i As Integer = 0 To ByteArray.Length - 1
					'Get one character at a time
					Dim Current As Byte = ByteArray(i)
					
					'Keep track of the next character too... If its the last character
					'present return a CR character
					Dim NextChar As Byte
					If (i + 1) <> ByteArray.Length Then
						NextChar = ByteArray(i + 1)
					Else
						NextChar = CType(&H0D, Byte)
					End If
					
					'make hex-style string out of the current byte
					Dim CurrentEncoded As String = ""
					
					'If this is the '=' character just encode it and return
					If Current = CByte(Asc("=")) Then
						CurrentEncoded = String.Format("={0:X2}", Current)
					'if this is any of these characters, just encode them
					ElseIf Current = CByte(Asc("!")) Or Current = CByte(Asc("""")) Or Current = CByte(Asc("#")) Or Current = CByte(Asc("$")) Or Current = CByte(Asc("@")) Or Current = CByte(Asc("[")) Or Current = CByte(Asc("\\")) Or Current = CByte(Asc("]")) Or Current = CByte(Asc("^")) Or Current = CByte(Asc("`")) Or Current = CByte(Asc("{")) Or Current = CByte(Asc("|")) Or Current = CByte(Asc("}")) Or Current = CByte(Asc("~")) Or Current = CByte(Asc("\'")) Then
						CurrentEncoded = String.Format("={0:X2}", Current)
					'If we come across a tab or a space AND the next byte
					'represents CR or LF, we need to encode it too
					ElseIf ((Current = &H09 Or Current = &H20) And (NextChar = &H0A Or NextChar = &H0D)) Then
						CurrentEncoded = String.Format("={0:X2}", Current)
					'is this character ok as is?
					ElseIf ((Current >= 33 And Current <= 126) Or Current = &H0D Or Current = &H0A Or Current = &H09 Or Current = &H20) Then
						CurrentEncoded = Chr(Current)
					Else
						'If we get here, we've fell from above, ecode anything that gets here
						CurrentEncoded = String.Format("={0:X2}", Current)
					End If
					
					'let's make sure that we keep track of line length while
					'we append characters together for the final output
					
					'check for CR and LF to get away from double lines
					If Current = &H0D Or Current = &H0A Then
						'If we got here that means that we are at the end of the
						'line and we need to reset our line length tracking variable
						If Current = &H0A Then
							CurrentLineLength = 0
						End If
					End If
					
					'check to see If this pushes us past 74 characters
					'If so lets add a soft line break
					If (CurrentEncoded.Length + CurrentLineLength) > 74 Then
						tmpQPString.Append("="& vbNewLine)
						CurrentLineLength = 0
					End If
					
					'append this character and increase line length
					tmpQPString.Append(CurrentEncoded)
					CurrentLineLength += CurrentEncoded.Length
				Next
				
				'return our completed string
				Return tmpQPString.ToString()
			End Function
		'/<-- End Method :: QuotedPrintableEncode
		
		'/##################################################################################
		
		'/--> Begin Method :: QuotedPrintableDecode
			Public Shared Function QuotedPrintableDecode(Input As String) As String
				'normalize newlines
				Input = Input.Replace(vbCRLF, vbNewLine)
				'rule #3 trailing space must be deleted
				Input = Input.Replace("[ "& vbTab &"]+"& vbNewLine, vbNewLine)
				'rule #5 soft line breaks
				Input = Input.Replace("="& vbNewLine, "")
				'decode hex characters
				Dim HexMatcher As Regex = New Regex("(=([0-9A-F][0-9A-F]))", RegexOptions.IgnoreCase Or RegexOptions.Singleline)
				For Each HexMatch As Match In HexMatcher.Matches(Input)
					Dim HexCode As String = HexMatch.Groups(2).Value
					Dim HexInteger As Integer = Convert.ToInt32(HexCode, 16)
					Dim HexCharacter As Char = Chr(HexInteger)
					Input = Input.Replace(HexMatch.Groups(1).Value, HexCharacter.ToString())
				Next
				Return Input
			End Function
		'/<-- End Method :: QuotedPrintableDecode
		
		'/##################################################################################
		
		'/--> Begin Method :: MD5Encrypt
			Public Shared Function MD5Encrypt(Input As String) As String
				Dim MD5Crypto As MD5CryptoServiceProvider = New MD5CryptoServiceProvider()
				Dim InputBytes() As Byte = System.Text.Encoding.ASCII.GetBytes(Input)
				InputBytes = MD5Crypto.ComputeHash(InputBytes)
				Dim Output As String = ""
				For i As Integer = 0 To InputBytes.Length - 1
					Output &= InputBytes(i).ToString("x2").ToLower()
				Next
				Return Output
			End Function
		'/<-- End Method :: MD5Encrypt
		
		'/##################################################################################
		
		'/--> Begin Method :: HMACMD5Encrypt
			Public Shared Function HMACMD5Encrypt(Key As String, Input As String) As String
				Dim KeyBytes() As Byte = Encoding.ASCII.GetBytes(Key)
				Dim DataBytes() As Byte = Encoding.ASCII.GetBytes(Input)
				
				Dim MyHMACMD5 As HMACMD5 = New HMACMD5(KeyBytes)
				Dim HMACData() As Byte = MyHMACMD5.ComputeHash(DataBytes)
		
				Dim Digest As StringBuilder = New StringBuilder()
				For Each ThisByte As Byte In HMACData
					Digest.Append(ThisByte.ToString("x2"))
				Next
				Return Digest.ToString()
			End Function
		'/<-- End Method :: HMACMD5Encrypt
	End Class
'/<-- End Class :: Codec

'/##########################################################################################
</script>