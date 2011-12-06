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
	Public Class POPClient 
		'/--> Begin :: Properties
			Public Username As String
			Public Password As String
			Public Host As String
			Public Port As Integer
			Public Protocol As String 'ssl/tls/tcp
			Public Timeout As Integer
			Public POPDriver As POPDriver 
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
				Me.POPDriver = New POPDriver()
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: Open
			Public Sub Open() 
				Me.POPDriver.Username = Me.Username
				Me.POPDriver.Password = Me.Password
				Me.POPDriver.Host = Me.Host
				Me.POPDriver.Port = Me.Port
				Me.POPDriver.Protocol = Me.Protocol
				Me.POPDriver.Timeout = Me.Timeout
				
				'Try to connect
				Try 
					Me.POPDriver.Open()
				Catch e As Exception
					Throw New Exception("Weblegs.POPClient.Open(): Failed to connect to host '"& Me.Host &"'. "& e.ToString())
				End Try
			End Sub
		'/<-- End Method :: Open
		
		'/##################################################################################
		
		'/--> Begin Method :: Close
			Public Sub Close() 
				'Try to connect
				Try 
					Me.POPDriver.Close()
				Catch e As Exception
					Throw New Exception("Weblegs.POPClient.Close(): Failed to close. "& e.ToString())
				End Try
			End Sub
		'/<-- End Method :: Close
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMessageCount
			Public Function GetMessageCount() As Integer
				Try 
					Return Me.POPDriver.GetMessageCount()
				Catch e As Exception
					Throw New Exception("Weblegs.POPClient.GetMessageCount(): Failed to get message count. "& e.ToString())
				End Try
			End Function
		'/<-- End Method :: GetMessageCount
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMailBoxSize
			Public Function GetMailBoxSize() As Integer
				'Try to connect
				Try 
					Return Me.POPDriver.GetMailBoxSize()
				Catch e As Exception
					Throw New Exception("Weblegs.POPClient.GetMailBoxSize(): Failed to get mailbox size. "& e.ToString())
				End Try
			End Function
		'/<-- End Method :: GetMailBoxSize
		
		'/##################################################################################
		
		'/--> Begin Method :: DeleteMessage
			Public Sub DeleteMessage(MessageNumber As Integer) 
				Me.DeleteMessage(MessageNumber.ToString())
			End Sub
			Public Sub DeleteMessage(MessageNumber As String) 
				'Try to delete
				Try 
					Me.POPDriver.DeleteMessage(MessageNumber)
				Catch e As Exception
					Throw New Exception("Weblegs.POPClient.DeleteMessage(): Failed to delete message #"& MessageNumber &". "& e.ToString())
				End Try
			End Sub
		'/<-- End Method :: DeleteMessage
		
		'/##################################################################################
		
		'/--> Begin Method :: DeleteMessages
			Public Sub DeleteMessages(Start As Integer, [End] As Integer) 
				For i As Integer = Start To [End] - 1
					'Try to delete
					Try 
						Me.POPDriver.DeleteMessage(i)
					Catch e As Exception
						Throw New Exception("Weblegs.POPClient.DeleteMessages(): Failed to delete message #"& i.ToString() &". "& e.ToString())
					End Try
				Next
			End Sub
			Public Sub DeleteMessages() 
				'get the message count
				Dim MessageCount As Integer = Me.GetMessageCount()
				
				'are there any messages?
				If MessageCount > 0 Then
					'lets call our other overload
					Me.DeleteMessages(1, MessageCount)
				End If
			End Sub
		'/<-- End Method :: DeleteMessages
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMIMEMessage
			Public Function GetMIMEMessage(MessageNumber As Integer) As MIMEMessage
				Return Me.GetMIMEMessage(MessageNumber.ToString())
			End Function
			Public Function GetMIMEMessage(MessageNumber As String) As MIMEMessage
				Dim thisMIME As String = Me.GetMessage(MessageNumber)
				Return New MIMEMessage(thisMIME)
			End Function
		'/<-- End Method :: GetMIMEMessage
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMIMEMessages
			Public Function GetMIMEMessages(Start As Integer, [End] As Integer) As MIMEMessage()
				'find our range
				Dim Range As Integer = [End] - Start
				
				'setup array of MIMEMessages
				Dim myMIMEMessages(Range) As MIMEMessage
				
				'build array
				Dim RangeGuide As Integer = 0
				For i As Integer = Start To [End] - 1
					'Try to delete
					Try 
						myMIMEMessages(RangeGuide) = Me.GetMIMEMessage(i)
						RangeGuide = RangeGuide + 1
					Catch e As Exception
						Throw New Exception("Weblegs.POPClient.GetMIMEMessages(): Failed to get message #"& i.ToString() &". "& e.ToString())
					End Try
				Next
				
				'Return
				Return myMIMEMessages
			End Function
			Public Function GetMIMEMessages() As MIMEMessage()
				'get the message count
				Dim MessageCount As Integer = Me.GetMessageCount()
				
				'are there any messages?
				If MessageCount > 0 Then
					'lets call our other overload
					Return Me.GetMIMEMessages(1, MessageCount)
				Else 
					Return Me.GetMIMEMessages(0, 0)
				End If
			End Function
		'/<-- End Method :: GetMIMEMessages
		
		'/##################################################################################
		
		'/--> Begin Method :: GetHeader
			Public Function GetHeader(MessageNumber As Integer) As String
				Return Me.GetHeader(MessageNumber.ToString())
			End Function
			Public Function GetHeader(MessageNumber As String) As String
				'Try to get headers
				Try 
					Return Me.POPDriver.GetHeaders(MessageNumber)
				Catch e As Exception
					Throw New Exception("Weblegs.POPClient.GetHeader(): Failed to get headers for message #"& MessageNumber &". "& e.ToString())
				End Try
			End Function
		'/<-- End Method :: GetHeader
		
		'/##################################################################################
		
		'/--> Begin Method :: GetHeaders
			Public Function GetHeaders(Start As Integer, [End] As Integer) As String()
				'find our range
				Dim Range As Integer = [End] - Start
				
				'setup array of MIMEMessages
				Dim myHeaders(Range) As String
				
				'build array
				Dim RangeGuide As Integer = 0
				For i As Integer = Start To [End] - 1
					'Try to delete
					Try 
						myHeaders(RangeGuide) = Me.GetHeader(i)
						RangeGuide = RangeGuide + 1
					Catch e As Exception
						Throw New Exception("Weblegs.POPClient.GetHeaders(): Failed to get message #"& i.ToString() &". "& e.ToString())
					End Try
				Next
				
				'Return
				Return myHeaders
			End Function
			Public Function GetHeaders() As String()
				'get the message count
				Dim MessageCount As Integer = Me.GetMessageCount()
				
				'are there any messages?
				If MessageCount > 0 Then
					'lets call our other overload
					Return Me.GetHeaders(1, MessageCount)
				Else 
					Return Me.GetHeaders(0, 0)
				End If
			End Function
		'/<-- End Method :: GetHeaders
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMessage
			Public Function GetMessage(MessageNumber As Integer) As String
				Return Me.GetMessage(MessageNumber.ToString())
			End Function
			Public Function GetMessage(MessageNumber As String) As String
				'Try to get headers
				Try 
					Return Me.POPDriver.GetMessage(MessageNumber)
				Catch e As Exception
					Throw New Exception("Weblegs.POPClient.GetMessage(): Failed to get message #"& MessageNumber &". "& e.ToString())
				End Try
			End Function
		'/<-- End Method :: GetMessage
		
		'/##################################################################################
		
		'/--> Begin Method :: GetMessages
			Public Function GetMessages(Start As Integer, [End] As Integer) As String()
				'find our range
				Dim Range As Integer = [End] - Start
				
				'setup array of MIMEMessages
				Dim myMessages(Range) As String
				
				'build array
				Dim RangeGuide As Integer = 0
				For i As Integer = Start To [End] - 1
					'Try to delete
					Try 
						myMessages(RangeGuide) = GetMessage(i)
						RangeGuide = RangeGuide + 1
					Catch e As Exception
						Throw New Exception("Weblegs.POPClient.GetMessages(): Failed to get message #"& i.ToString() &". "& e.ToString())
					End Try
				Next
				
				'Return
				Return myMessages
			End Function
			Public Function GetMessages() As String()
				'get the message count
				Dim MessageCount As Integer = Me.GetMessageCount()
				
				'are there any messages?
				If MessageCount > 0 Then 
					'lets call our other overload
					Return Me.GetMessages(1, MessageCount)
				Else 
					Return Me.GetMessages(0, 0)
				End If
			End Function
		'/<-- End Method :: GetMessages
	End Class
'/<-- End Class :: POPClient

'/##########################################################################################
</script>