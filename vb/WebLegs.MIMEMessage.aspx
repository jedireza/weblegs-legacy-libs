<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<%@ Import Namespace="System.Xml.XPath" %>
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

'/--> Begin Class :: MIMEMessage
	Public Class MIMEMessage 
		'/--> Begin :: Properties
			Public Headers As List(Of String()) 
			Public Preamble As String
			Public Body As String
			Public FileBody() As Byte 
			Public Parts As List(Of MIMEMessage)
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New() 
				Me.Headers = New List(Of String())()
				Me.Preamble = ""
				Me.Body = ""
				Me.Parts = New List(Of MIMEMessage)()
			End Sub
			Public Sub New(ByRef Data As String) 
				Me.Headers = New List(Of String())()
				Me.Preamble = ""
				Me.Body = ""
				Me.Parts = New List(Of MIMEMessage)()
				Me.Parse(Data)
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: Parse
			Public Sub Parse(ByRef Data As String) 
				Data = Data.Replace("\r\n", vbNewLine)
				Data = Data.Replace("\r", vbNewLine)
				'parse the entire message
				Dim myMatch As Match = Regex.Match(Data, "(.*?)"& vbNewLine & vbNewLine &"(.*)", RegexOptions.IgnoreCase Or RegexOptions.Singleline)
				Dim tmpHeaders As String = myMatch.Groups(1).Value
				Dim tmpBody As String = myMatch.Groups(2).Value
				Me.ParseHeaders(tmpHeaders)
				Me.ParseBody(tmpBody, True)
			End Sub
		'/<-- End Method :: Parse
		
		'/##################################################################################
		
		'/--> Begin Method :: ParseHeaders
			Public Sub ParseHeaders(ByRef Data As String) 
				'parse raw headers into the properties
				Dim myPattern As String = "(?<="& vbNewLine &"|^)(\S*?): (.*?)(?="& vbNewLine &"\S*?: |$)"
				Dim myCollection As MatchCollection = Regex.Matches(Data, myPattern, RegexOptions.IgnoreCase Or RegexOptions.Singleline)
				For i As Integer = 0 To myCollection.Count - 1
					Dim myMatch As Match = myCollection(i)
					Me.AddHeader(myMatch.Groups(1).Value, Regex.Replace(myMatch.Groups(2).Value, "\s+", " "))
				Next
			End Sub
		'/<-- End Method :: ParseHeaders
		
		'/##################################################################################
		
		'/--> Begin Method :: ParseBody
			Public Sub ParseBody(ByRef Data As String, Decode As Boolean) 
				'parse just the message body
				Select Case Me.GetMediaType().ToLower()
					Case "application"
						'check for encoding
						If Me.GetContentTransferEncoding().IndexOf("base64") > -1 Then 
							If Decode Then
								Me.Body = Data.Trim()
								Me.FileBody = Codec.Base64DecodeBytes(Data)
							Else 
								Me.Body = Codec.Base64Encode(Me.FileBody)
							End If
						End If
						'- - - - - - - - - - - - - - - - - -'
					Case "audio"
						'check for encoding
						If Me.GetContentTransferEncoding().IndexOf("base64") > -1 Then
							If Decode Then
								Me.Body = Data.Trim()
								Me.FileBody = Codec.Base64DecodeBytes(Data)
							Else 
								Me.Body = Codec.Base64Encode(Me.FileBody)
							End If
						End If
						'- - - - - - - - - - - - - - - - - -'
					Case "image"
						'check for encoding
						If Me.GetContentTransferEncoding().IndexOf("base64") > -1 Then
							If Decode Then
								Me.Body = Data.Trim()
								Me.FileBody = Codec.Base64DecodeBytes(Data)
							Else 
								Me.Body = Codec.Base64Encode(Me.FileBody)
							End If
						End If
						'- - - - - - - - - - - - - - - - - -'
					Case "message"
						Select Case Me.GetMediaSubType().ToLower()
							Case "rfc822"
								'make the first part of this message
								'the parsed message
								Me.Parts.Add(New MIMEMessage(Data))
							Case Else
								'do nothing
						End Select
						'- - - - - - - - - - - - - - - - - -'
					Case "model"
						'not implemented
						'- - - - - - - - - - - - - - - - - -'
					Case "multipart"
						'the boundry is required for multipart messages
						Dim MultiPartBoundry As String = Me.GetMediaBoundary()
						
						'find the preamble
						Dim myPreableMatch As Match = Regex.Match(Data, "(.*?)--"& MultiPartBoundry,  RegexOptions.IgnoreCase Or RegexOptions.Singleline)
						Me.Preamble = myPreableMatch.Groups(1).Value.ToString().Trim()
						
						'get each part of the message
						Dim myPattern As String = "--"& MultiPartBoundry &"(.*?)(?=--"& MultiPartBoundry &")"
						Dim myPartCollection As MatchCollection = Regex.Matches(Data, myPattern, RegexOptions.IgnoreCase Or RegexOptions.Singleline)
						For i As Integer =  0 To myPartCollection.Count - 1
							Dim tmpPart As String = myPartCollection(i).Groups(1).Value
							Me.Parts.Add(New MIMEMessage(tmpPart))
						Next
						'- - - - - - - - - - - - - - - - - -'
					Case "text"
						'check for encoding
						If Me.GetContentTransferEncoding().IndexOf("base64") > -1 Then
							If Decode Then
								Me.Body = Codec.Base64Decode(Data)
							Else 
								Me.Body = Codec.Base64Encode(Data)
							End If
						ElseIf Me.GetContentTransferEncoding().IndexOf("quoted-printable") > -1 Then
							If Decode Then
								Me.Body = Codec.QuotedPrintableDecode(Data)
							Else 
								Me.Body = Codec.QuotedPrintableEncode(Data)
							End If
						Else 
							Me.Body = Data
						End If
						'- - - - - - - - - - - - - - - - - -'
					Case "video"
						'check for encoding
						If Me.GetContentTransferEncoding().IndexOf("base64") > -1 Then 
							If Decode Then
								Me.Body = Data
								Me.FileBody = Codec.Base64DecodeBytes(Data)
							Else 
								Me.Body = Codec.Base64Encode(Me.FileBody)
							End If
						End If
						'- - - - - - - - - - - - - - - - - -'
					Case Else
						'do nothing
				End Select
			End Sub
		'/<-- End Method :: ParseBody
		
		'/##################################################################################
		
		'/--> Begin Method :: AddHeader
			Public Sub AddHeader(Name As String, Value As String) 
				Me.Headers.Add(New String(){Name, Value})
			End Sub
		'/<-- End Method :: AddHeader
		
		'/##################################################################################
		
		'/--> Begin Method :: RemoveHeader
			Public Sub RemoveHeader(Name As String) 
				For i As Integer = 0 To Me.Headers.Count - 1
					If Me.Headers(i)(0).ToString().ToLower() = Name.ToLower() Then
						Me.Headers.RemoveAt(i)
					End If
				Next
			End Sub
		'/<-- End Method :: RemoveHeader
		
		'/##################################################################################
		
		'/--> Begin Method :: GetHeader
			Public Function GetHeader(Name As String) As String
				For i As Integer = 0 To Me.Headers.Count - 1
					If Me.Headers(i)(0).ToString().ToLower() = Name.ToLower() Then
						Return Me.Headers(i)(1).ToString()
					End If
				Next
				
				Return ""
			End Function
		'/<-- End Method :: GetHeader
		
		'/##################################################################################
		
		'/--> Begin Method :: GetContentTransferEncoding
			Public Function GetContentTransferEncoding() As String 
				If Me.GetHeader("Content-Transfer-Encoding") <> "" Then
					Return Me.GetHeader("Content-Transfer-Encoding")
				Else 
					Return ""
				End If
			End Function
		'/<-- End Method :: GetContentTransferEncoding
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMediaType
			Public Function GetMediaType() As String
				Dim tmpMediaType As String = ""
				Dim myMediaMatch As Match = Regex.Match(Me.GetHeader("Content-Type"), "^(.*?)/(.*?);|$")
				If myMediaMatch.Success Then
					tmpMediaType = myMediaMatch.Groups(1).Value
				End If
				If tmpMediaType = "" Then
					tmpMediaType = "text"
				End If
				Return tmpMediaType
			End Function
		'/<-- End Method :: GetMediaType
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMediaSubType
			Public Function GetMediaSubType() As String
				Dim tmpMediaSubType As String = ""
				Dim myMediaMatch As Match = Regex.Match(Me.GetHeader("Content-Type"), "^(.*?)/(.*?);|$")
				If myMediaMatch.Success Then
					tmpMediaSubType = myMediaMatch.Groups(2).Value
				End If
				If tmpMediaSubType = "" Then
					tmpMediaSubType = "plain"
				End If
				Return tmpMediaSubType
			End Function
		'/<-- End Method :: GetMediaSubType
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMediaFileName
			Public Function GetMediaFileName() As String
				Dim tmpMediaFile As String = ""
				Dim myMediaFile As Match = Regex.Match(Me.GetHeader("Content-Disposition"), "name=""{0,1}(.*?)(""|;|$)")
				If myMediaFile.Success Then
					tmpMediaFile = myMediaFile.Groups(1).Value
				End If
				Return tmpMediaFile
			End Function
		'/<-- End Method :: GetMediaFileName
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMediaCharacterSet
			Public Function GetMediaCharacterSet() As String
				Dim tmpMediaCharacterSet As String = ""
				Dim myMediaCharSetMatch As Match = Regex.Match(Me.GetHeader("Content-Type"), "charset=""{0,1}(.*?)(""|;|$)")
				If Not myMediaCharSetMatch.Success Then
					tmpMediaCharacterSet = "us-ascii"
				Else 
					tmpMediaCharacterSet = myMediaCharSetMatch.Groups(1).Value
				End If
				Return tmpMediaCharacterSet
			End Function
		'/<-- End Method :: GetMediaCharacterSet
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMediaBoundary
			Public Function GetMediaBoundary() As String
				Return Regex.Match(Me.GetHeader("Content-Type"), "boundary=""{0,1}(.*?)(?:""|$)").Groups(1).Value
			End Function
		'/<-- End Method :: GetMediaBoundary
		
		'/##################################################################################
		
		'/--> Begin Method :: IsAttachment
			Public Function IsAttachment() As Boolean
				Try 
					If (Me.GetHeader("Content-Disposition")).ToLower().IndexOf("attachment") > -1 Then
						Return True
					Else 
						Return False
					End If
				Catch 
					Return False
				End Try
			End Function
		'/<-- End Method :: IsAttachment
		
		'/##################################################################################
		
		'/--> Begin Method :: ToString
			Public Overrides Function ToString() As String
				Dim tmpMIMEMessage As String = ""
				
				'loop over the headers
				For i As Integer = 0 To Me.Headers.Count - 1
					Dim tmpThisHeader As String = Me.Headers(i)(0).ToString() &": "& Me.Headers(i)(1).ToString()
					Dim tmpThisFixedHeader As String = ""
					If tmpThisHeader.Length > 74 Then
						While tmpThisHeader.Length > 74
							'find the next space character furthest to the end (or the 74th character)
							If tmpThisHeader.SubString(0, 73).LastIndexOf(" ") > -1 Then
								tmpThisFixedHeader &= tmpThisHeader.SubString(0, tmpThisHeader.SubString(0, 73).LastIndexOf(" ")) & vbNewLine & vbTab
								'remove from tmpThisHeader
								tmpThisHeader = tmpThisHeader.SubString(tmpThisHeader.SubString(0, 73).LastIndexOf(" ")).Trim()
							Else If tmpThisHeader.IndexOf(" ") > -1 Then
								tmpThisFixedHeader &= tmpThisHeader.SubString(0, tmpThisHeader.IndexOf(" ")) & vbNewLine & vbTab
								'remove from tmpThisHeader
								tmpThisHeader = tmpThisHeader.SubString(tmpThisHeader.IndexOf(" ")).Trim()
							Else 
								'this is a long line w/ no breaking potential
								tmpThisFixedHeader &= tmpThisHeader
								tmpThisHeader = ""
							End If
						End While
						'If there is still content in tmpThisHeader ... append it w/ a New line
						If tmpThisHeader.Length > 0 Then
							tmpThisFixedHeader &= tmpThisHeader
						End If
					Else 
						tmpThisFixedHeader = tmpThisHeader
					End If
					tmpThisFixedHeader &= vbNewLine
					tmpMIMEMessage &= tmpThisFixedHeader
				Next
				
				'we should alrady have the first space from the last header
				'but fix it here If there are no headers (probably never happens)
				If Me.Headers.Count = 0 Then
					tmpMIMEMessage &= vbNewLine
				End If
				
				'add header/body space
				tmpMIMEMessage &= vbNewLine
				
				'add preamble
				If Me.Preamble <> "" Then
					tmpMIMEMessage &= Me.Preamble & vbNewLine
				End If
				
				'add body text
				If Me.Parts.Count = 0 Then
					'en/decode on the way out
					Me.ParseBody(Me.Body, False)
					tmpMIMEMessage &= Me.Body
				Else 
					'go through each part
					For i As Integer = 0 To Me.Parts.Count - 1
						'add boundary above
						If Me.GetMediaBoundary() <> "" Then
							tmpMIMEMessage &= vbNewLine & "--"& Me.GetMediaBoundary() & vbNewLine
						End If
						
						'add body content
						tmpMIMEMessage &= Me.Parts(i).ToString()
						
						'add boundary above
						If Me.GetMediaBoundary() <> "" And (i + 1) = Me.Parts.Count Then
							tmpMIMEMessage &= vbNewLine & "--"& Me.GetMediaBoundary() &"--"& vbNewLine & vbNewLine
						End If
					Next
				End If
				
				Return tmpMIMEMessage
			End Function
		'/<-- End Method :: ToString
		
		'/##################################################################################
		
		'/--> Begin Method :: SaveAs
			Public Sub SaveAs(FilePath As String)
				Try
					'try to write file
					File.WriteAllText(FilePath, Me.ToString(), Encoding.UTF8)
				Catch e As Exception
					Throw New Exception("WebLegs.MIMEMessage.SaveAs(): Was not able to save file. "& e.ToString())
				End Try
			End Sub
		'/<-- End Method :: SaveAs
		
		'/##################################################################################
		
		'/--> Begin Method :: SaveBodyAs
			Public Sub SaveBodyAs(FilePath As String)
				Try
					'try to write file
					File.WriteAllText(FilePath, Me.Body, Encoding.UTF8)
				Catch e As Exception
					Throw New Exception("WebLegs.MIMEMessage.SaveBodyAs(): Was not able to save file. "& e.ToString())
				End Try
			End Sub
		'/<-- End Method :: SaveBodyAs
		
		'/##################################################################################
		
		'/--> Begin Method :: SaveFileAs
			Public Sub SaveFileAs(FilePath As String)
				Try
					'try to write file
					File.WriteAllBytes(FilePath, Me.FileBody)
				Catch e As Exception
					Throw New Exception("WebLegs.MIMEMessage.SaveFileAs(): Was not able to save file. "& e.ToString())
				End Try
			End Sub
		'/<-- End Method :: SaveFileAs
	End Class
'/<-- End Class :: MIMEMessage

'/##########################################################################################
</script>