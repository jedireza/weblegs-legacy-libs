<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Net.Sockets" %>
<%@ Import Namespace="System.Net.Security" %>
<%@ Import Namespace="System.Text" %>
<script language="c#" runat="server">
//##########################################################################################

/*
Copyright (C) 2005-2010 WebLegs, Inc.
This program is free software: you can redistribute it and/or modify it under the terms
of the GNU General Public License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.
If not, see <http://www.gnu.org/licenses/>.
*/

//##########################################################################################

//--> Begin Class :: SocketDriver
	public class SocketDriver {
		//--> Begin :: Properties
			//basic properties
			public Socket Connection;
			public string Host;
			public int Port;
			public string Protocol;
			public int Timeout;
			
			//c# specific properties
			SslStream SecureStream;
			NetworkStream SocketStream;
			StreamReader SocketReader;
			StreamWriter SocketWriter;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public SocketDriver() {
				this.Connection = null;
				this.Host = "";
				this.Port = -1;
				this.Protocol = "tcp"; //ssl/tls/tcp
				this.Timeout = 10; //seconds
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin :: Destructor
			~SocketDriver() {
				this.Close();
			}
		//<-- End :: Destructor
		
		//##################################################################################
		
		//--> Begin Method :: Open
			public void Open() {
				//get host entries
				IPHostEntry tmpHostEntry = Dns.GetHostEntry(this.Host);
				
				//loop through the host entries
				foreach(IPAddress tmpIP in tmpHostEntry.AddressList) {
					//find end-point (IPv6 support) and try to connect
					IPEndPoint tmpIPE = new IPEndPoint(tmpIP, this.Port);
					Socket tmpConnection = new Socket(tmpIPE.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
					tmpConnection.ReceiveTimeout = this.Timeout * 1000; //convert seconds to miliseconds
					tmpConnection.Connect(tmpIPE);
					
					//check if we're connected
					if(tmpConnection.Connected) {
						//populate property and stop looping
						this.Connection = tmpConnection;
						break;
					}
					else {
						//keep trying
						continue;
					}
				}
				
				//did we connect?
				if(this.Connection == null) {
					throw new Exception("Weblegs.SocketDriver.Open(): Failed to connect.");
				}
				
				//setup streamers
				this.SocketStream = new NetworkStream(Connection);
				if(this.Protocol == "ssl" || this.Protocol == "tls") {
					this.SecureStream = new SslStream(this.SocketStream);
					this.SecureStream.AuthenticateAsClient(this.Host);
					this.SocketReader = new StreamReader(this.SecureStream);
					this.SocketWriter = new StreamWriter(this.SecureStream);
				}
				else {
					this.SocketReader = new StreamReader(this.SocketStream);
					this.SocketWriter = new StreamWriter(this.SocketStream);
				}
			}
		//<-- End Method :: Open
		
		//##################################################################################
		
		//--> Begin Method :: Close
			public void Close() {
				if(this.Connection == null) {
					return;
				}
				else if(!this.Connection.Connected) {
					return;
				}
				else {
					if(this.Protocol == "ssl" || this.Protocol == "tls") {
						this.SecureStream.Close();
					}
					this.SocketReader.Close();
					this.SocketWriter.Close();
					this.SocketStream.Close();
					this.Connection.Close();
				}
			}
		//<-- End Method :: Close
		
		//##################################################################################
		
		//--> Begin Method :: ReadBytes
			public string ReadBytes(int Bytes) {
				Char[] tmpBytesRecieved = new Char[Bytes];
				this.SocketReader.Read(tmpBytesRecieved, 0, tmpBytesRecieved.Length);
				return new string(tmpBytesRecieved);
			}
		//<-- End Method :: ReadBytes
		
		//##################################################################################
		
		//--> Begin Method :: ReadLine
			public string ReadLine() {
				return this.SocketReader.ReadLine();
			}
		//<-- End Method :: ReadLine
		
		//##################################################################################
		
		//--> Begin Method :: Read
			public string Read() {
				string tmpResult = "";
				string tmpThisLine = "";
				
				while((tmpThisLine = this.SocketReader.ReadLine()) != null) {
					tmpResult += tmpThisLine + "\r\n";
				}
				
				return tmpResult;
			}
		//<-- End Method :: Read
		
		//##################################################################################
		
		//--> Begin Method :: Write
			public void Write(string Data) {
				this.SocketWriter.Write(Data);
				this.SocketWriter.Flush();
			}
			public void Write(Byte[] Data) {
				string tmpData = Encoding.ASCII.GetString(Data);
				this.SocketWriter.Write(tmpData);
				this.SocketWriter.Flush();
			}
		//<-- End Method :: Write
		
		//##################################################################################
		
		//--> Begin Method :: IsOpen
			public bool IsOpen() {
				if(this.Connection == null) {
					return false;
				}
				else if(this.Connection.Connected) {
					return true;
				}
				else {
					return false;
				}
			}
		//<-- End Method :: IsOpen
	}
//<-- End Class :: SocketDriver

//##########################################################################################
</script>