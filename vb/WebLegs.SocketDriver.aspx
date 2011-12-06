<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Net.Sockets" %>
<%@ Import Namespace="System.Net.Security" %>
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

'/--> Begin Class :: SocketDriver
	Public Class SocketDriver 
		'/--> Begin :: Properties
			'basic properties
			Public Connection As Socket
			Public Host As String 
			Public Port As Integer 
			Public Protocol As String 
			Public Timeout As Integer 
			
			'vb specIfic properties
			Public SecureStream As SslStream
			Public SocketStream As NetworkStream
			Public SocketReader As StreamReader
			Public SocketWriter As StreamWriter 
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New() 
				Me.Connection = Nothing
				Me.Host = ""
				Me.Port = -1
				Me.Protocol = "tcp" 'ssl/tls/tcp
				Me.Timeout = 10 'seconds
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin :: Destructor
			Protected Overrides Sub Finalize()
				Me.Close()
			End Sub
		'/<-- End :: Destructor
		
		'/##################################################################################
		
		'/--> Begin Method :: Open
			Public Sub Open() 
				'get host entries
				Dim tmpHostEntry As IPHostEntry = Dns.GetHostEntry(Me.Host)
				
				'loop through the host entries
				For Each tmpIP As IPAddress in tmpHostEntry.AddressList 
					'find end-poInteger (IPv6 support) and try to connect
					Dim tmpIPE As IPEndPoint = New IPEndPoint(tmpIP, Me.Port)
					Dim tmpConnection As Socket = New Socket(tmpIPE.AddressFamily, SocketType.Stream, ProtocolType.Tcp)
					tmpConnection.ReceiveTimeout = Me.Timeout * 1000 'convert seconds to miliseconds
					tmpConnection.Connect(tmpIPE)
					
					'check If we're connected
					If tmpConnection.Connected Then
						'populate property and stop looping
						Me.Connection = tmpConnection
						Exit For
					Else 
						'keep trying
						Continue For
					End If
				Next
				
				'did we connect?
				If IsNothing(Me.Connection) Then
					Throw New Exception("Weblegs.SocketDriver.Open(): Failed to connect.")
				End If
				
				'setup streamers
				Me.SocketStream = New NetworkStream(Connection)
				If Me.Protocol = "ssl" Or Me.Protocol = "tls" Then
					Me.SecureStream = new SslStream(Me.SocketStream)
					Me.SecureStream.AuthenticateAsClient(Me.Host)
					Me.SocketReader = new StreamReader(Me.SecureStream)
					Me.SocketWriter = new StreamWriter(Me.SecureStream)
				Else
					Me.SocketReader = new StreamReader(Me.SocketStream)
					Me.SocketWriter = new StreamWriter(Me.SocketStream)
				End If
			End Sub
		'/<-- End Method :: Open
		
		'/##################################################################################
		
		'/--> Begin Method :: Close
			Public Sub Close() 
				If IsNothing(Me.Connection) Then
					Return
				ElseIf Not Me.Connection.Connected Then
					Return
				Else 
					If Me.Protocol = "ssl" Or Me.Protocol = "tls" Then
						Me.SecureStream.Close()
					End If
					Me.SocketReader.Close()
					Me.SocketWriter.Close()
					Me.SocketStream.Close()
					Me.Connection.Close()
				End If
			End Sub
		'/<-- End Method :: Close
		
		'/##################################################################################
		
		'/--> Begin Method :: ReadBytes
			Public Function ReadBytes(Bytes As Integer) As String 
				Dim tmpBytesRecieved(Bytes) As Char
				Me.SocketReader.Read(tmpBytesRecieved, 0, tmpBytesRecieved.Length)
				Return New String(tmpBytesRecieved)
			End Function
		'/<-- End Method :: ReadBytes
		
		'/##################################################################################
		
		'/--> Begin Method :: ReadLine
			Public Function ReadLine() As String 
				Return Me.SocketReader.ReadLine()
			End Function
		'/<-- End Method :: ReadLine
		
		'/##################################################################################
		
		'/--> Begin Method :: Read
			Public Function Read() As String 
				Dim tmpResult As String = ""
				Dim tmpThisLine As String = ""
				
				tmpThisLine = Me.SocketReader.ReadLine()
				While Not IsNothing(tmpThisLine)
					tmpResult &= tmpThisLine & vbCrLf
					tmpThisLine = Me.SocketReader.ReadLine()
				End While
				
				Return tmpResult
			End Function
		'/<-- End Method :: Read
		
		'/##################################################################################
		
		'/--> Begin Method :: Write
			Public Sub Write(Data As String) 
				Me.SocketWriter.Write(Data)
				Me.SocketWriter.Flush()
			End Sub
			Public Sub Write(Data As Byte()) 
				Dim tmpData As String = Encoding.ASCII.GetString(Data)
				Me.SocketWriter.Write(tmpData)
				Me.SocketWriter.Flush()
			End Sub
		'/<-- End Method :: Write
		
		'/##################################################################################
		
		'/--> Begin Method :: IsOpen
			Public Function IsOpen() As Boolean 
				If IsNothing(Me.Connection) Then
					Return False
				ElseIf Me.Connection.Connected Then
					Return True
				Else 
					Return False
				End If
			End Function
		'/<-- End Method :: IsOpen
	End Class
'/<-- End Class :: SocketDriver

'/##########################################################################################
</script>