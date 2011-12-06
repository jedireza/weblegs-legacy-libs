<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Collections" %>
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

'/--> Begin Class :: SMTPClient
	Public Class SMTPClient 
		'/--> Begin :: Properties
			Public From As String() '(address, name)
			Public ReplyTo As String() '(address, name)
			Public [To] As List(Of String())
			Public CC As List(Of String())
			Public BCC As List(Of String())
			Public Priority As String 
			Public Subject As String 
			Public Message As String 
			Public IsHTML As Boolean
			Public Attachments As List(Of String) 
			Public Host As String 
			Public Port As Integer
			Public Protocol As String 
			Public Timeout As Integer
			Public Username As String 
			Public Password As String 
			Public SMTPDriver As SMTPDriver
			Public MIMEMessage As MIMEMessage
			Public ContentTypeList As Hashtable
			Public OpenedManually As Boolean
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New() 
				Me.From = New String(){"", ""}
				Me.ReplyTo = New String(){"", ""}
				Me.To = New List(Of String())()
				Me.CC = New List(Of String())()
				Me.BCC = New List(Of String())()
				Me.Priority = "3"
				Me.Subject = ""
				Me.Message = ""
				Me.IsHTML = False
				Me.Attachments = New List(Of String)()
				Me.Host = ""
				Me.Port = 25
				Me.Protocol = "tcp"
				Me.Timeout = 10
				Me.Username = ""
				Me.Password = ""
				Me.SMTPDriver = New SMTPDriver()
				Me.MIMEMessage = New MIMEMessage()
				Me.ContentTypeList = Me.BuildContentTypeList()
				Me.OpenedManually = False
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: Open
			Public Sub Open() 
				'setup the SMTPDriver
				Me.SMTPDriver.Host = Me.Host
				Me.SMTPDriver.Port = Me.Port
				Me.SMTPDriver.Protocol = Me.Protocol
				Me.SMTPDriver.Timeout = Me.Timeout
				Me.OpenedManually = True
				
				Try 
					Me.SMTPDriver.Open()
				Catch e As Exception 
					Throw New Exception("Weblegs.SMTPClient.Open(): Failed to open connection. "& e.ToString())
				End Try
			End Sub
		'/<-- End Method :: Open
		
		'/##################################################################################
		
		'/--> Begin Method :: Close
			Public Sub Close() 
				Try 
					Me.SMTPDriver.Close()
				Catch e As Exception 
					Throw New Exception("Weblegs.SMTPClient.Close(): Failed to close connection. "& e.ToString())
				End Try
			End Sub
		'/<-- End Method :: Close
		
		'/##################################################################################
		
		'/--> Begin Method :: SetFrom
			Public Sub SetFrom(EmailAddress As String, Name As String) 
				Me.From(0) = EmailAddress
				Me.From(1) = Name
			End Sub
			Public Sub SetFrom(EmailAddress As String) 
				Me.From(0) = EmailAddress
				Me.From(1) = ""
			End Sub
		'/<-- End Method :: SetFrom
		
		'/##################################################################################
		
		'/--> Begin Method :: SetReplyTo
			Public Sub SetReplyTo(EmailAddress As String, Name As String) 
				Me.ReplyTo(0) = EmailAddress
				Me.ReplyTo(1) = Name
			End Sub
			Public Sub SetReplyTo(EmailAddress As String) 
				Me.ReplyTo(0) = EmailAddress
				Me.ReplyTo(1) = ""
			End Sub
		'/<-- End Method :: SetReplyTo
		
		'/##################################################################################
		
		'/--> Begin Method :: AddTo
			Public Sub AddTo(EmailAddress As String, Name As String) 
				Me.To.Add(New String(){EmailAddress, Name})
			End Sub
			Public Sub AddTo(EmailAddress As String) 
				Me.To.Add(New String(){EmailAddress, ""})
			End Sub
		'/<-- End Method :: AddTo
		
		'/##################################################################################
		
		'/--> Begin Method :: AddCC
			Public Sub AddCC(EmailAddress As String, Name As String) 
				Me.CC.Add(New String(){EmailAddress,Name})
			End Sub
			Public Sub AddCC(EmailAddress As String) 
				Me.CC.Add(New String(){EmailAddress,""})
			End Sub
		'/<-- End Method :: AddCC
		
		'/##################################################################################
		
		'/--> Begin Method :: AddBCC
			Public Sub AddBCC(EmailAddress As String, Name As String) 
				Me.BCC.Add(New String(){EmailAddress,Name})
			End Sub
			Public Sub AddBCC(EmailAddress As String) 
				Me.BCC.Add(New String(){EmailAddress,""})
			End Sub
		'/<-- End Method :: AddBCC
		
		'/##################################################################################
		
		'/--> Begin Method :: AddHeader
			Public Sub AddHeader(Name As String, Value As String) 
				Me.MIMEMessage.AddHeader(Name,Value)
			End Sub
		'/<-- End Method :: AddHeader
		
		'/##################################################################################
		
		'/--> Begin Method :: AttachFile
			Public Sub AttachFile(FilePath As String) 
				Me.Attachments.Add(FilePath)
			End Sub
		'/<-- End Method :: AttachFile
		
		'/##################################################################################
		
		'/--> Begin Method :: CompileHeaders
			Public Sub CompileHeaders() 
				'add from header
				If Me.From(1) = "" Then
					Me.MIMEMessage.AddHeader("From", Me.From(0))
				Else 
					Me.MIMEMessage.AddHeader("From", """"& Me.From(1) &""" <"& Me.From(0) &">")
				End If
				
				'add reply to
				If Me.ReplyTo(0) = "" Or Me.ReplyTo(0) Is Nothing Then
					'do nothing
				ElseIf Me.ReplyTo(0) <> "" And Me.ReplyTo(1) = "" Then
					Me.MIMEMessage.AddHeader("ReplyTo", Me.ReplyTo(0))
				ElseIf Me.ReplyTo(0) <> "" And Me.ReplyTo(1) <> "" Then
					Me.MIMEMessage.AddHeader("ReplyTo", """"& Me.ReplyTo(1) &""" <"& Me.ReplyTo(0) &">")
				End If
				
				'add subject
				Me.MIMEMessage.AddHeader("Subject", Me.Subject)
				
				'add to addresses
				Dim ToAddresses As String = ""
				For i As Integer = 0 To Me.To.Count - 1
					If Me.To(i)(1) = "" Then
						ToAddresses &= Me.To(i)(0)
					Else 
						ToAddresses &= """"& Me.To(i)(1) &""" <"& Me.To(i)(0) &">"
					End If
					
					'add a comma? (,)
					If i + 1 <> Me.To.Count Then ToAddresses &= ", "
				Next
				
				If ToAddresses <> "" Then
					Me.MIMEMessage.AddHeader("To", ToAddresses)
				End If
				
				'add cc addresses
				Dim CCAddresses As String = ""
				For i As Integer = 0 To Me.CC.Count - 1
					If Me.CC(i)(1) = "" Then
						CCAddresses &= Me.CC(i)(0)
					Else 
						CCAddresses &= """"& Me.CC(i)(1) &""" <"& Me.CC(i)(0) &">"
					End If
					
					'add a comma? (,)
					If i + 1 <> Me.CC.Count Then CCAddresses &= ", "
				Next
				
				If CCAddresses <> "" Then
					Me.MIMEMessage.AddHeader("Cc", CCAddresses)
				End If
				
				'add date
				Me.MIMEMessage.AddHeader("Date", DateTime.Now.ToString("R"))
				
				'add message-id
				Me.MIMEMessage.AddHeader("Message-Id", "<"& System.Guid.NewGuid().ToString("N") &"@"& Me.Host &">")
				
				'add priority
				Me.MIMEMessage.AddHeader("X-Priority", Me.Priority)
				
				'add x-mailer
				Me.MIMEMessage.AddHeader("X-Mailer", "WebLegs.SMTPClient (www.weblegs.org)")
				
				'add mime version
				Me.MIMEMessage.AddHeader("MIME-Version", "1.0")
			End Sub
		'/<-- End Method :: CompileHeaders
		
		'/##################################################################################
		
		'/--> Begin Method :: CompileMessage
			Public Sub CompileMessage() 
				'setup our *empty* MIME objects for alternative message
				Dim AlternativeMessage As MIMEMessage
				Dim HTMLMessage As MIMEMessage 
				Dim TextMessage As MIMEMessage 
				
				'create the main boundry for this message (not always used)
				Dim MainBoundary As String = "----=_Part_"& System.Guid.NewGuid().ToString()
				
				'lets figure out how to handle this message
				If Me.IsHTML = False And Me.Attachments.Count = 0 Then
					'this is just a plain text message
					Me.MIMEMessage.AddHeader("Content-Type", "text/plain;"& vbNewLine & vbTab &"charset=US-ASCII;")
					Me.MIMEMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable")
					'put the content Integero the message body
					Me.MIMEMessage.Body = Me.Message
				ElseIf Me.IsHTML = True And Me.Attachments.Count = 0 Then
					'this is an alternative html/text based message
					Me.MIMEMessage.AddHeader("Content-Type", "multipart/alternative;"& vbNewLine & vbTab &"boundary="""& MainBoundary &"""")
					Me.MIMEMessage.Preamble = "This is a multi-part message in MIME format."
					
					'build the html part of this message
					HTMLMessage = New MIMEMessage()
					HTMLMessage.AddHeader("Content-Type", "text/html; charset=US-ASCII;")
					HTMLMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable")
					HTMLMessage.Body = Me.Message
					
					'build the text part of this message
					TextMessage = New MIMEMessage()
					TextMessage.AddHeader("Content-Type", "text/plain; charset=US-ASCII;")
					TextMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable")
					TextMessage.Body = Me.HTMLToText(Me.Message)
					
					'add text/html parts to the main message
					Me.MIMEMessage.Parts.Add(TextMessage)
					Me.MIMEMessage.Parts.Add(HTMLMessage)
				ElseIf Attachments.Count <> 0 Then
					'this message is mixed
					Me.MIMEMessage.AddHeader("Content-Type", "multipart/mixed;"& vbNewLine & vbTab &"boundary="""& MainBoundary &"""")
					Me.MIMEMessage.Preamble = "This is a multi-part message in MIME format."
					
					'is this an alternative message?
					If Me.IsHTML = True Then
						'create the alternative boundry for this message
						Dim AlternativeBoundary As String = "----=_Part_"& System.Guid.NewGuid().ToString()
						
						'build the Alternative part of this message
						AlternativeMessage = New MIMEMessage()
						AlternativeMessage.AddHeader("Content-Type", "multipart/alternative;"& vbNewLine & vbTab &"boundary="""& AlternativeBoundary &"""")
						
						'build the html part of this message
						HTMLMessage = New MIMEMessage()
						HTMLMessage.AddHeader("Content-Type", "text/html; charset=US-ASCII;")
						HTMLMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable")
						HTMLMessage.Body = Me.Message
						
						'build the text part of this message
						TextMessage = New MIMEMessage()
						TextMessage.AddHeader("Content-Type", "text/plain; charset=US-ASCII;")
						TextMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable")
						TextMessage.Body = Me.HTMLToText(Me.Message)
						
						'add html/text parts to the alternative message
						AlternativeMessage.Parts.Add(TextMessage)
						AlternativeMessage.Parts.Add(HTMLMessage)
						
						'add the alternative message to the main message
						Me.MIMEMessage.Parts.Add(AlternativeMessage)
					Else 
						'build a plain text message message
						TextMessage = New MIMEMessage()
						TextMessage.AddHeader("Content-Type", "text/plain; charset=US-ASCII;")
						TextMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable")
						TextMessage.Body = Me.Message
						
						'add the PlainTextMessage to the main message
						Me.MIMEMessage.Parts.Add(TextMessage)
					End If
					
					'add attachments to the main message
					For i As Integer = 0 To Me.Attachments.Count - 1
						'get file info
						Dim thisFileInfo As FileInfo = New FileInfo(Me.Attachments(i))
						
						'convert file Integero bytes
						Dim thisFileStream As FileStream = New FileStream(Me.Attachments(i), FileMode.Open, FileAccess.Read)
						Dim thisBinaryReader As BinaryReader = New BinaryReader(thisFileStream)
						Dim thisByteData() As Byte = thisBinaryReader.ReadBytes(CType(thisFileInfo.Length, Integer))
						thisBinaryReader.Close()
						thisFileStream.Close()
						
						'setup New MIME message for this attachment
						Dim AttachmentMessage As MIMEMessage = New MIMEMessage()
						AttachmentMessage.AddHeader("Content-Type", Me.GetContentTypeByExtension(thisFileInfo.Extension) &";"& vbNewLine & vbTab &"name="""& thisFileInfo.Name &"""")
						AttachmentMessage.AddHeader("Content-Transfer-Encoding", "base64")
						AttachmentMessage.AddHeader("Content-Disposition", "attachment;"& vbNewLine & vbTab &"filename="""& thisFileInfo.Name &"""")
						AttachmentMessage.FileBody = thisByteData
						
						'add this attachment to the main message
						Me.MIMEMessage.Parts.Add(AttachmentMessage)
					Next
				End If
			End Sub
		'/<-- End Method :: CompileMessage
		
		'/##################################################################################
		
		'/--> Begin Method :: Send
			Public Sub Send() 
				'make sure host was supplied
				If Me.Host = "" Then
					Throw New Exception("Weblegs.SMTPClient.Send(): No host specIfied.")
				End If
				
				'assign credentials If username is supplied
				If Me.Username <> "" Then
					Me.SMTPDriver.Username = Me.Username
					Me.SMTPDriver.Password = Me.Password
				End If
				
				'should we open the socket for them?
				If Not Me.OpenedManually Then
					'setup the SMTPDriver
					Me.SMTPDriver.Host = Me.Host
					Me.SMTPDriver.Port = Me.Port
					Me.SMTPDriver.Timeout = Me.Timeout
					Me.SMTPDriver.Protocol = Me.Protocol
					
					'open up
					Try 
						Me.SMTPDriver.Open()
					Catch e As Exception 
						Throw New Exception("Weblegs.SMTPClient.Send(): Could not open connection. "& e.ToString())
					End Try
				End If
				
				'set the from address
				Me.SMTPDriver.SetFrom(Me.From(0))
				
				'add recipients
					'to addresses
					For i As Integer = 0 To Me.To.Count - 1
						Me.SMTPDriver.AddRecipient(Me.To(i)(0))
					Next
					
					'cc addresses
					For i As Integer = 0 To Me.CC.Count - 1
						Me.SMTPDriver.AddRecipient(Me.CC(i)(0))
					Next
					
					'bcc addresses
					For i As Integer = 0 To Me.BCC.Count - 1
						Me.SMTPDriver.AddRecipient(Me.BCC(i)(0))
					Next
				'end add recipients
				
				'prepare headers
				Me.CompileHeaders()
				
				'prepair message
				Me.CompileMessage()
				
				'Try sending
				Try
					Me.SMTPDriver.Send(Me.MIMEMessage.ToString())
				Catch e As Exception 
					Throw New Exception("Weblegs.SMTPClient.Send(): Failed to send message. "& e.ToString())
				End Try
				
				'should we close the socket for them?
				If Not Me.OpenedManually Then
					Me.Close()
					Me.Reset()
				End If
			End Sub
		'/<-- End Method :: Send
		
		'/##################################################################################
		
		'/--> Begin Method :: Reset
			Public Sub Reset() 
				Me.From = New String(){"",""}
				Me.ReplyTo = New String(){"",""}
				Me.To = New List(Of String())()
				Me.CC = New List(Of String())()
				Me.BCC = New List(Of String())()
				Me.Priority = "3"
				Me.Subject = ""
				Me.Message = ""
				Me.IsHTML = False
				Me.Attachments = New List(Of String)()
				Me.MIMEMessage = New MIMEMessage()
			End Sub
		'/<-- End Method :: Reset
		
		'/##################################################################################
		
		'/--> Begin Method :: GetContentTypeByExtension
			Public Function GetContentTypeByExtension(Extension As String) As String
				If Me.ContentTypeList.Contains(Extension) Then
					Return Me.ContentTypeList(Extension).ToString()
				Else 
					Return "application/x-unknown-content-type"
				End If
			End Function
		'/<-- End Method :: GetContentTypeByExtension
		
		'/##################################################################################
			
		'/--> Begin Method :: HTMLToText
			Public Function HTMLToText(ByRef HTML As String) As String
				'keep copy of HTML
				Dim TextOnly As String = HTML
				
				'trim it down
				TextOnly = TextOnly.Trim()
				
				'make custom mods to HTML
					'seperators (80 chars on purpose)
					Dim HorizontalRule As String = "--------------------------------------------------------------------------------"
					Dim TableTopBottom As String = "********************************************************************************"
					
					'remove all line breaks
					TextOnly = Regex.Replace(TextOnly, vbCr, "")
					TextOnly = Regex.Replace(TextOnly, vbNewLine, "")
					
					'remove head
					TextOnly = Regex.Replace(TextOnly, "<\s*(head|HEAD).*?\/(head|HEAD)>", "")
					
					'heading tags
					TextOnly = Regex.Replace(TextOnly, "<\/*(h|H)(1|2|3|4|5|6).*?>", vbNewLine)
					
					'paragraph tags
					TextOnly = Regex.Replace(TextOnly, "<(p|P).*?>", vbNewLine & vbNewLine)
					
					'div tags
					TextOnly = Regex.Replace(TextOnly, "<(div|DIV).*?>", vbNewLine & vbNewLine)
					
					'br tags
					TextOnly = Regex.Replace(TextOnly, "<(br|BR|bR|Br).*?>", vbNewLine)
					
					'hr tags
					TextOnly = Regex.Replace(TextOnly, "<(hr|HR|hR|Hr).*?>", vbNewLine & HorizontalRule)
					
					'table tags
					TextOnly = Regex.Replace(TextOnly, "<\/*(table|TABLE).*?>", vbNewLine & TableTopBottom)
					TextOnly = Regex.Replace(TextOnly, "<(tr|TR|tR|Tr).*?>", vbNewLine)
					TextOnly = Regex.Replace(TextOnly, "<\/(td|TD|tD|Td).*?>", vbTab)
					
					'list tags
					TextOnly = Regex.Replace(TextOnly, "<\/*(ol|OL|oL|Ol).*?>", vbNewLine)
					TextOnly = Regex.Replace(TextOnly, "<\/*(ul|UL|uL|Ul).*?>", vbNewLine)
					TextOnly = Regex.Replace(TextOnly, "<(li|LI|lI|Li).*?>", vbNewLine & vbTab &"(*) ")
					
					'lets not lose our links
					TextOnly = Regex.Replace(TextOnly, "<a hByRef=""(.*?)"">(.*?)</a>", "$2 ($1)")
					TextOnly = Regex.Replace(TextOnly, "<a HREF=""(.*?)"">(.*?)</a>", "$2 ($1)")
					
					'strip the remaining HTML out
					TextOnly = Regex.Replace(TextOnly, "<(.|"& vbNewLine &")*?>", "")
					
					'loop over each line and truncate lines more than 74 characters
					Dim tmpFixedText As String = ""
					Dim TextOnlyLines() As String = Regex.Split(TextOnly, vbNewLine)
					For i As Integer = 0 To TextOnlyLines.Length - 1
						Dim tmpThisFixedLine As String = ""
						If TextOnlyLines(i).Length > 74 Then
							While TextOnlyLines(i).Length > 74
								'find the next space character furthest to the end (or the 74th character)
								If TextOnlyLines(i).SubString(0, 73).LastIndexOf(" ") > -1 Then
									tmpThisFixedLine += TextOnlyLines(i).SubString(0, TextOnlyLines(i).SubString(0, 73).LastIndexOf(" ")) & vbNewLine
									'remove from TextOnlyLines(i)
									TextOnlyLines(i) = TextOnlyLines(i).SubString(TextOnlyLines(i).SubString(0, 73).LastIndexOf(" ")).Trim()
								Else 
									'If there is a space in this line after the 74th character lets break at the first chance we get and continue
									If TextOnlyLines(i).IndexOf(" ") > -1 Then
										tmpThisFixedLine += TextOnlyLines(i).SubString(0, TextOnlyLines(i).IndexOf(" ")+1) & vbNewLine
										TextOnlyLines(i) = TextOnlyLines(i).SubString(TextOnlyLines(i).IndexOf(" ")+1)
									Else 
										'this is a long line w/ no breaking potential
										tmpThisFixedLine += TextOnlyLines(i)
										TextOnlyLines(i) = ""
									End If
								End If
							End While
							'If there is still content in TextOnlyLines(i) ... append it w/ a New line
							If TextOnlyLines(i).Length > 0 Then
								tmpThisFixedLine &= TextOnlyLines(i)
							End If
						Else 
							tmpThisFixedLine = TextOnlyLines(i)
						End If
						tmpThisFixedLine &= vbNewLine
						tmpFixedText &= tmpThisFixedLine
					Next
					TextOnly = tmpFixedText
				'end make custom mods to HTML
				
				Return TextOnly
			End Function
		'/<-- End Method :: HTMLToText
			
		'/##################################################################################
		
		'/--> Begin Method :: BuildContentTypeList
			Public Function BuildContentTypeList() As Hashtable
				Dim tmpContentTypeList As Hashtable = New Hashtable()
				tmpContentTypeList.Add("hqx", "application/mac-binhex40")
				tmpContentTypeList.Add("cpt", "application/mac-compactpro")
				tmpContentTypeList.Add("doc", "application/msword")
				tmpContentTypeList.Add("bin", "application/macbinary")
				tmpContentTypeList.Add("dms", "application/octet-stream")
				tmpContentTypeList.Add("lha", "application/octet-stream")
				tmpContentTypeList.Add("lzh", "application/octet-stream")
				tmpContentTypeList.Add("exe", "application/octet-stream")
				tmpContentTypeList.Add("Class", "application/octet-stream")
				tmpContentTypeList.Add("psd", "application/octet-stream")
				tmpContentTypeList.Add("so", "application/octet-stream")
				tmpContentTypeList.Add("sea", "application/octet-stream")
				tmpContentTypeList.Add("dll", "application/octet-stream")
				tmpContentTypeList.Add("oda", "application/oda")
				tmpContentTypeList.Add("pdf", "application/pdf")
				tmpContentTypeList.Add("ai", "application/postscript")
				tmpContentTypeList.Add("eps", "application/postscript")
				tmpContentTypeList.Add("ps", "application/postscript")
				tmpContentTypeList.Add("smi", "application/smil")
				tmpContentTypeList.Add("smil", "application/smil")
				tmpContentTypeList.Add("mIf", "application/vnd.mIf")
				tmpContentTypeList.Add("xls", "application/vnd.ms-excel")
				tmpContentTypeList.Add("ppt", "application/vnd.ms-powerpoInteger")
				tmpContentTypeList.Add("wbxml", "application/vnd.wap.wbxml")
				tmpContentTypeList.Add("wmlc", "application/vnd.wap.wmlc")
				tmpContentTypeList.Add("dcr", "application/x-director")
				tmpContentTypeList.Add("dir", "application/x-director")
				tmpContentTypeList.Add("dxr", "application/x-director")
				tmpContentTypeList.Add("dvi", "application/x-dvi")
				tmpContentTypeList.Add("gtar", "application/x-gtar")
				tmpContentTypeList.Add("php", "application/x-httpd-php")
				tmpContentTypeList.Add("php4", "application/x-httpd-php")
				tmpContentTypeList.Add("php3", "application/x-httpd-php")
				tmpContentTypeList.Add("phtml", "application/x-httpd-php")
				tmpContentTypeList.Add("phps", "application/x-httpd-php-source")
				tmpContentTypeList.Add("js", "application/x-javascript")
				tmpContentTypeList.Add("swf", "application/x-shockwave-flash")
				tmpContentTypeList.Add("sit", "application/x-stuffit")
				tmpContentTypeList.Add("tar", "application/x-tar")
				tmpContentTypeList.Add("tgz", "application/x-tar")
				tmpContentTypeList.Add("xhtml", "application/xhtml+xml")
				tmpContentTypeList.Add("xht", "application/xhtml+xml")
				tmpContentTypeList.Add("zip", "application/zip")
				tmpContentTypeList.Add("data-id", "audio/midi")
				tmpContentTypeList.Add("midi", "audio/midi")
				tmpContentTypeList.Add("mpga", "audio/mpeg")
				tmpContentTypeList.Add("mp2", "audio/mpeg")
				tmpContentTypeList.Add("mp3", "audio/mpeg")
				tmpContentTypeList.Add("aIf", "audio/x-aIff")
				tmpContentTypeList.Add("aIff", "audio/x-aIff")
				tmpContentTypeList.Add("aIfc", "audio/x-aIff")
				tmpContentTypeList.Add("ram", "audio/x-pn-realaudio")
				tmpContentTypeList.Add("rm", "audio/x-pn-realaudio")
				tmpContentTypeList.Add("rpm", "audio/x-pn-realaudio-plugin")
				tmpContentTypeList.Add("ra", "audio/x-realaudio")
				tmpContentTypeList.Add("rv", "video/vnd.rn-realvideo")
				tmpContentTypeList.Add("wav", "audio/x-wav")
				tmpContentTypeList.Add("bmp", "image/bmp")
				tmpContentTypeList.Add("gIf", "image/gIf")
				tmpContentTypeList.Add("jpeg", "image/jpeg")
				tmpContentTypeList.Add("jpg", "image/jpeg")
				tmpContentTypeList.Add("jpe", "image/jpeg")
				tmpContentTypeList.Add("png", "image/png")
				tmpContentTypeList.Add("tIff", "image/tIff")
				tmpContentTypeList.Add("tIf", "image/tIff")
				tmpContentTypeList.Add("css", "text/css")
				tmpContentTypeList.Add("html", "text/html")
				tmpContentTypeList.Add("htm", "text/html")
				tmpContentTypeList.Add("shtml", "text/html")
				tmpContentTypeList.Add("txt", "text/plain")
				tmpContentTypeList.Add("text", "text/plain")
				tmpContentTypeList.Add("log", "text/plain")
				tmpContentTypeList.Add("rtx", "text/richtext")
				tmpContentTypeList.Add("rtf", "text/rtf")
				tmpContentTypeList.Add("xml", "text/xml")
				tmpContentTypeList.Add("xsl", "text/xml")
				tmpContentTypeList.Add("mpeg", "video/mpeg")
				tmpContentTypeList.Add("mpg", "video/mpeg")
				tmpContentTypeList.Add("mpe", "video/mpeg")
				tmpContentTypeList.Add("qt", "video/quicktime")
				tmpContentTypeList.Add("mov", "video/quicktime")
				tmpContentTypeList.Add("avi", "video/x-msvideo")
				tmpContentTypeList.Add("movie", "video/x-sgi-movie")
				tmpContentTypeList.Add("word", "application/msword")
				tmpContentTypeList.Add("xl", "application/excel")
				tmpContentTypeList.Add("eml", "message/rfc822")
				Return tmpContentTypeList
			End Function
		'/<-- End Method :: BuildContentTypeList
	End Class
'/<-- End Class :: SMTPClient

'/##########################################################################################
</script>