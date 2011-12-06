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

'/--> Begin Class :: POPClient
	Public Class POPDriver 
		'/--> Begin :: Properties
			Public Username As String
			Public Password As String
			Public Host As String
			Public Port As Integer
			Public Protocol As String 'ssl/tls/tcp
			Public Timeout As Integer
			Public Command As String
			Public Reply As String
			Public IsError As Boolean
			Public Socket As SocketDriver
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New() 
				Me.Username = ""
				Me.Password = ""
				Me.Host = ""
				Me.Port = 110
				Me.Protocol = "tcp" 'ssl/tls/tcp
				Me.Timeout = 10
				Me.Command = ""
				Me.Reply = ""
				Me.IsError = False
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
					Throw New Exception("Weblegs.POPDriver.Open(): No host specIfied.")
				End If
				
				'make sure the username was specIfied
				If Me.Username = "" Then
					Throw New Exception("Weblegs.POPDriver.Open(): No username specIfied.")
				End If
				
				'make sure the password was specIfied
				If Me.Password = "" Then
					Throw New Exception("Weblegs.POPDriver.Open(): No password specIfied.")
				End If
				
				'attempt to connect
				Me.Socket.Host = Me.Host
				Me.Socket.Port = Me.Port
				Me.Socket.Protocol = Me.Protocol
				Me.Socket.Timeout = Me.Timeout
				Try 
					Me.Socket.Open()
				Catch e As Exception
					Throw New Exception("Weblegs.POPDriver.Open(): Failed to connect to host '"& Me.Host &"'. "& e.ToString())
				End Try
				
				'read to clear buffer
				Me.Socket.ReadLine()
				
				'send username
				Me.Request("USER "& Me.Username)
				If Me.IsError Then
					Throw New Exception("Weblegs.POPDriver.Open(): '"& Me.Command &"' command was not accepted by the server. (POP Error: "& Me.Reply &").")
				End If
				
				'send password
				Me.Request("PASS "& Me.Password)
				If Me.IsError Then
					Throw New Exception("Weblegs.POPDriver.Open(): '"& Me.Command &"' command was not accepted by the server. (POP Error: "& Me.Reply &").")
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
				If Me.IsError Then
					Throw New Exception("Weblegs.POPDriver.Close(): '"& Me.Command &"' command was not accepted by the server. (POP Error: "& Me.Reply &").")
				End If
				
				'close socket
				Me.Socket.Close()
			End Sub
		'/<-- End Method :: Close
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMessageCount
			Public Function GetMessageCount() As Integer
				Me.Request("STAT")
				If Me.IsError Then
					Throw New Exception("Weblegs.POPDriver.GetMessageCount(): '"& Me.Command &"' command was not accepted by the server. (POP Error: "& Me.Reply &").")
				End If
				
				Dim arrStats As String() = Me.Reply.Split(" ")
				
				'the second element is the number of messages
				Return Convert.ToInt32(arrStats(1))
			End Function
		'/<-- End Method :: GetMessageCount
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMailBoxSize
			Public Function GetMailBoxSize() As Integer
				Me.Request("STAT")
				If Me.IsError Then
					Throw New Exception("Weblegs.POPDriver.GetMailBoxSize(): '"& Me.Command &"' command was not accepted by the server. (POP Error: "& Me.Reply &").")
				End If
				
				Dim arrStats As String() = Me.Reply.Split(" ")
				
				'the third element is the number of messages
				Return Convert.ToInt32(arrStats(2))
			End Function
		'/<-- End Method :: GetMailBoxSize
		
		'/##################################################################################
		
		'/--> Begin Method :: GetHeaders
			Public Function GetHeaders(MessageNumber As Integer) As String
				Return Me.GetHeaders(MessageNumber.ToString())
			End Function
			Public Function GetHeaders(MessageNumber As String) As String
				'send command and collect response and read until eol
				Me.Request("TOP "& MessageNumber &" 0")
				If Me.IsError Then
					Throw New Exception("Weblegs.POPDriver.GetHeaders(): '"& Me.Command &"' command was not accepted by the server. (POP Error: "& Me.Reply &").")
				End If
				
				Return Me.Reply
			End Function
		'/<-- End Method :: GetHeaders
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMessage
			Public Function GetMessage(MessageNumber As Integer) As String
				Return Me.GetMessage(MessageNumber.ToString())
			End Function
			Public Function GetMessage(MessageNumber As String) As String
				'send command and collect response and read until eol
				Me.Request("RETR "& MessageNumber)
				If Me.IsError Then
					Throw New Exception("Weblegs.POPDriver.GetMessage(): '"& Me.Command &"' command was not accepted by the server. (POP Error: "& Me.Reply &").")
				End If
				
				Return Me.Reply
			End Function
		'/<-- End Method :: GetMessage
		
		'/##################################################################################
		
		'/--> Begin Method :: DeleteMessage
			Public Sub DeleteMessage(MessageNumber As Integer) 
				Me.DeleteMessage(MessageNumber.ToString())
			End Sub
			Public Sub DeleteMessage(MessageNumber As String) 
				'send command
				Me.Request("DELE "& MessageNumber)
				If Me.IsError Then
					Throw New Exception("Weblegs.POPDriver.DeleteMessage(): '"& Me.Command &"' command was not accepted by the server. (POP Error: "& Me.Reply &").")
				End If
			End Sub
		'/<-- End Method :: DeleteMessage
		
		'/##################################################################################
		
		'/--> Begin Method :: Request
			Public Function Request(Command As String) As String
				'populate the command property
				Me.Command = Command
				
				'write to connection
				Me.Socket.Write(Me.Command & vbNewLine)
				
				'read the response
				Dim ReturnData As String = ""
				Dim tmpData As String = Me.Socket.ReadLine()
				
				'check for error
				If tmpData.StartsWith("-") Then
					Me.IsError = True
					ReturnData = tmpData
				Else 
					Me.IsError = False
					
					'should we read a multi-line response?
					If (Me.Command.StartsWith("LIST") And Not Me.Command.StartsWith("LIST ")) Or Me.Command.StartsWith("RETR") Or Me.Command.StartsWith("TOP") Or Me.Command.StartsWith("UIDL") Then
						While tmpData <> "."
							ReturnData &= tmpData & vbNewLine
							tmpData = Me.Socket.ReadLine()
						End While
					Else 
						ReturnData = tmpData
					End If
				End If
				
				'populate reply message
				Me.Reply = ReturnData
				
				'Return the reply message (easier to dev w/)
				Return Me.Reply
			End Function
		'/<-- End Method :: Request
	End Class
'/<-- End Class :: POPDriver

'/##########################################################################################
</script>