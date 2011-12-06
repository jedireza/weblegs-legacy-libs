<%@ Import Namespace="System.Text" %>
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

'/--> Begin Class :: SMTPDriver
	Public Class SMTPDriver 
		'/--> Begin :: Properties
			Public Username As String
			Public Password As String
			Public Host As String
			Public Port As Integer
			Public Protocol As String 'ssl/tls/tcp
			Public Timeout As Integer 
			Public Annoucement As String 
			Public ReplyCode As Integer 
			Public ReplyText As String 
			Public Reply As String 
			Public Command As String 
			Public Socket As SocketDriver
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New() 
				Me.Username = ""
				Me.Password = ""
				Me.Host = ""
				Me.Port = 25
				Me.Protocol = "tcp" 'ssl/tls/tcp
				Me.Timeout = 10
				Me.Annoucement = ""
				Me.ReplyCode = -1
				Me.ReplyText = ""
				Me.Reply = ""
				Me.Command = ""
				Me.Socket = New SocketDriver()
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: Open
			Public Sub Open() 
				'make sure we're not already connected
				If Me.Socket.IsOpen() Then
					Return
				End If
				
				'make sure the host was specIfied
				If Me.Host = "" Then
					Throw New Exception("Weblegs.SMTPDriver.Open(): No host specIfied.")
				End If
				
				'attempt to connect
				Me.Socket.Host = Me.Host
				Me.Socket.Port = Me.Port
				Me.Socket.Protocol = Me.Protocol
				Me.Socket.Timeout = Timeout
				Try 
					Me.Socket.Open()
				Catch e As Exception
					Throw New Exception("Weblegs.SMTPDriver.Open(): Failed to connect to host. "& e.ToString())
				End Try
				
				'retrieve announcements (also clears the response from socket)
				Me.Annoucement = Me.Socket.ReadLine()
				
				'Try "EHLO" command first
				Me.Request("EHLO "& Me.Host)
				
				If Me.ReplyCode <> 250 Then
					'Try "HELO" now
					Me.Request("HELO "& Me.Host)
					If Me.ReplyCode <> 250 Then
						Throw New Exception("Weblegs.SMTPDriver.Open(): 'HELO' and 'EHLO' command(s) were not accepted by the server (SMTP Error Number: "& Me.ReplyCode &". SMTP Error: "& Me.ReplyText &"). Full Text: "& Me.Reply &").")
					End If
				End If
				
				'If username is not blank this implies use of authentication
				If Me.Username <> "" Then
					If Me.Authenticate("AUTH LOGIN") = False Then
						If Me.Authenticate("AUTH PLAIN") = False Then
							If Me.Authenticate("AUTH CRAM-MD5") = False Then
								Throw New Exception("Weblegs.SMTPDriver.Open(): 'AUTH LOGIN, AUTH PLAIN & AUTH CRAM-MD5' commands were not accepted by the server (SMTP Error Number: "& Me.ReplyCode &". SMTP Error: "& Me.ReplyText &" Full Text: "& Me.Reply &").")
							End If
						End If
					End If
				End If
			End Sub
		'/<-- End Method :: Open
		
		'/##################################################################################
		
		'/--> Begin Method :: Close
			Public Sub Close() 
				'see If there is an open connection
				If Not Me.Socket.IsOpen() Then
					Return
				End If
				
				'finalize session
				Me.Request("QUIT")
				If Me.ReplyCode <> 221 Then
					Throw New Exception("Weblegs.SMTPDriver.Close(): '"& Me.Command &"' command was not accepted by the server (SMTP Error Number: "& Me.ReplyCode &". SMTP Error: "& Me.ReplyText &". Full Text: "& Me.Reply &").")
				End If
				
				'close socket
				Me.Socket.Close()
			End Sub
		'/<-- End Method :: Close
		
		'/##################################################################################
		
		'/--> Begin Method :: Authenticate
			Public Function Authenticate(Command As String) As Boolean
				Select Case Command
					'- - - - - - - - - - - - - -'
					Case "AUTH CRAM-MD5"
						'start authentication
						Me.Request("AUTH CRAM-MD5")
						
						IF Me.ReplyCode <> 334 Then
							Return False
						End If
						
						'begin generate hmac md5 hash
							Dim Key As String = Me.Password
							Dim Data As String = Codec.Base64Decode(Me.ReplyText)
							Dim Digest As String = Codec.HMACMD5Encrypt(Key, Data)
						'end generate hmac md5 hash
						
						Me.Request(Codec.Base64Encode(Me.Username &" "& Digest))
						
						If Me.ReplyCode <> 235 Then
							Return False
						End If
				
						'everything went through
						Return True
					'- - - - - - - - - - - - - -'
					Case "AUTH LOGIN"
						'start authentication
						Me.Request("AUTH LOGIN")
						If Me.ReplyCode <> 334 Then
							Return False
						End If
						
						'send encoded username
						Me.Request(Codec.Base64Encode(Me.Username))
						If Me.ReplyCode <> 334 Then
							Return False
						End If
						
						'send encoded password
						Me.Request(Codec.Base64Encode(Me.Password))
						If Me.ReplyCode <> 235 Then 
							Return False
						End If
						
						'everything went through
						Return True
					'- - - - - - - - - - - - - -'
					Case "AUTH PLAIN"
						'start authentication
						Me.Request("AUTH PLAIN")
						
						If Me.ReplyCode <> 334 Then
							Return False
						End If
						
						Me.Request(Codec.Base64Encode(Chr(0) & Me.Username & Chr(0) & Me.Password))
						
						If Me.ReplyCode <> 235 Then
							Return False
						End If

						Return False
					'- - - - - - - - - - - - - -'
				End Select
				
				'didn't make it
				Return False
			End Function
		'/<-- End Method :: Authenticate
		
		'/##################################################################################
		
		'/--> Begin Method :: SetFrom
			Public Sub SetFrom(FromAddress As String) 
				Me.Request("MAIL FROM:<"& FromAddress &">")
				If Me.ReplyCode <> 250 Then
					Throw New Exception("Weblegs.SMTPDriver.SetFrom(): '"& Me.Command &"' command was not accepted by the server (SMTP Error Number: "& Me.ReplyCode &". SMTP Error: "& Me.ReplyText &". Full Text: "& Me.Reply &").")
				End If
			End Sub
		'/<-- End Method :: SetFrom
		
		'/##################################################################################
		
		'/--> Begin Method :: AddRecipient
			Public Sub AddRecipient(EmailAddress As String) 
				Me.Request("RCPT TO:<"& EmailAddress &">")
				If Me.ReplyCode <> 251 And Me.ReplyCode <> 250 Then
					Throw New Exception("Weblegs.SMTPDriver.AddRecipient(): '"& Me.Command &"' command was not accepted by the server (SMTP Error Number: "& Me.ReplyCode &". SMTP Error: "& Me.ReplyText &". Full Text: "& Me.Reply &").")
				End If
			End Sub
		'/<-- End Method :: AddRecipient
		
		'/##################################################################################
		
		'/--> Begin Method :: Send
			Public Sub Send(Data As String) 
				'tell the server to get ready
				Me.Request("DATA")
				If Me.ReplyCode <> 354 Then
					Throw New Exception("Weblegs.SMTPDriver.Send(): '"& Me.Command &"' command was not accepted by the server (SMTP Error Number: "& Me.ReplyCode &". SMTP Error: "& Me.ReplyText &". Full Text: "& Me.Reply &").")		
				End If
				
				'split up the data
				Dim arrMessageData() As String = Data.Split(vbNewLine)
				
				'write lines to connection
				For i As Integer = 0 To arrMessageData.Length - 1
					Me.Socket.Write(arrMessageData(i).Replace(vbLf, "") & vbCrLf)
				Next
				
				'finalize DATA command
				Me.Request(vbCrLf &".")
				If Me.ReplyCode <> 250 Then
					Throw New Exception("Weblegs.SMTPDriver.Send(): '"& Me.Command &"' command was not accepted by the server (SMTP Error Number: "& Me.ReplyCode &". SMTP Error: "& Me.ReplyText &". Full Text: "& Me.Reply &").")
				End If
			End Sub
		'/<-- End Method :: Send
		
		'/##################################################################################
		
		'/--> Begin Method :: Request
			Public Function Request(Command As String) As String
				'clear the last reply
				Me.Reply = ""
				Me.ReplyText = ""
				Me.ReplyCode = -1
				
				'populate the command property
				Me.Command = Command
				
				'write to connection
				Me.Socket.Write(Me.Command & vbCrLf)
				
				'get reply
				Dim Line As String = Me.Socket.ReadLine()
				While Not IsNothing(Line)
					If Line.Substring(3, 1) = " " Then
						Me.Reply = Line
						Exit While
					End If
					Line = Me.Socket.ReadLine()
				End While
				
				'parse reply data
				Me.ReplyText = Me.Reply.SubString(4)
				Me.ReplyCode = CType(Me.Reply.SubString(0, 3), Integer)
				
				'Return the reply message (easier to dev w/)
				Return Me.Reply
			End Function
		'/<-- End Method :: Request
	End Class
'/<-- End Class :: SMTPDriver

'/##########################################################################################
</script>