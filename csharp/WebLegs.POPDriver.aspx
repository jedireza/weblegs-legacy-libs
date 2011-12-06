<%@ Import Namespace="System" %>
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

//--> Begin Class :: POPClient
	public class POPDriver {
		//--> Begin :: Properties
			public string Username;
			public string Password;
			public string Host;
			public int Port;
			public string Protocol;
			public int Timeout;
			public string Command;
			public string Reply;
			public bool IsError;
			public SocketDriver Socket;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public POPDriver() {
				this.Username = "";
				this.Password = "";
				this.Host = "";
				this.Port = 110;
				this.Protocol = "tcp"; //ssl/tls/tcp
				this.Timeout = 10;
				this.Command = "";
				this.Reply = "";
				this.IsError = false;
				this.Socket = new SocketDriver();
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Open
			public void Open() {
				//make sure we're not already connected
				if(this.Socket.IsOpen()) {
					return;
				}
				
				//make sure the host was specified
				if(this.Host == "") {
					throw new Exception("Weblegs.POPDriver.Open(): No host specified.");
				}
				
				//make sure the username was specified
				if(this.Username == "") {
					throw new Exception("Weblegs.POPDriver.Open(): No username specified.");
				}
				
				//make sure the password was specified
				if(this.Password == "") {
					throw new Exception("Weblegs.POPDriver.Open(): No password specified.");
				}
				
				//attempt to connect
				this.Socket.Host = this.Host;
				this.Socket.Port = this.Port;
				this.Socket.Protocol = this.Protocol;
				this.Socket.Timeout = this.Timeout;
				try {
					this.Socket.Open();
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPDriver.Open(): Failed to connect to host '"+ this.Host +"'. "+ e.ToString());
				}
				
				//read to clear buffer
				this.Socket.ReadLine();
				
				//send username
				this.Request("USER "+ this.Username);
				if(this.IsError) {
					throw new Exception("Weblegs.POPDriver.Open(): '"+ this.Command +"' command was not accepted by the server. (POP Error: "+ this.Reply +").");
				}
				
				//send password
				this.Request("PASS "+ this.Password);
				if(this.IsError) {
					throw new Exception("Weblegs.POPDriver.Open(): '"+ this.Command +"' command was not accepted by the server. (POP Error: "+ this.Reply +").");
				}
			}
		//<-- End Method :: Open
		
		//##################################################################################
		
		//--> Begin Method :: Close
			public void Close() {
				//see if there is an open connection
				if(!this.Socket.IsOpen()) {
					return;
				}
				
				//finalize session
				this.Request("QUIT");
				if(this.IsError) {
					throw new Exception("Weblegs.POPDriver.Close(): '"+ this.Command +"' command was not accepted by the server. (POP Error: "+ this.Reply +").");
				}
				
				//close socket
				this.Socket.Close();
			}
		//<-- End Method :: Close
		
		//##################################################################################
		
		//--> Begin Method :: GetMessageCount
			public int GetMessageCount() {
				this.Request("STAT");
				if(this.IsError) {
					throw new Exception("Weblegs.POPDriver.GetMessageCount(): '"+ this.Command +"' command was not accepted by the server. (POP Error: "+ this.Reply +").");
				}
				
				string[] arrStats = this.Reply.Split(' ');
				
				//the second element is the number of messages
				return Convert.ToInt32(arrStats[1]);
			}
		//<-- End Method :: GetMessageCount
		
		//##################################################################################
		
		//--> Begin Method :: GetMailBoxSize
			public int GetMailBoxSize() {
				this.Request("STAT");
				if(this.IsError) {
					throw new Exception("Weblegs.POPDriver.GetMailBoxSize(): '"+ this.Command +"' command was not accepted by the server. (POP Error: "+ this.Reply +").");
				}
				
				string[] arrStats = this.Reply.Split(' ');
				
				//the third element is the number of messages
				return Convert.ToInt32(arrStats[2]);
			}
		//<-- End Method :: GetMailBoxSize
		
		//##################################################################################
		
		//--> Begin Method :: GetHeaders
			public string GetHeaders(int MessageNumber) {
				return this.GetHeaders(MessageNumber.ToString());
			}
			public string GetHeaders(string MessageNumber) {
				//send command and collect response and read until eol
				this.Request("TOP "+ MessageNumber +" 0");
				if(this.IsError) {
					throw new Exception("Weblegs.POPDriver.GetHeaders(): '"+ this.Command +"' command was not accepted by the server. (POP Error: "+ this.Reply +").");
				}
				
				return this.Reply;
			}
		//<-- End Method :: GetHeaders
		
		//##################################################################################
		
		//--> Begin Method :: GetMessage
			public string GetMessage(int MessageNumber) {
				return this.GetMessage(MessageNumber.ToString());
			}
			public string GetMessage(string MessageNumber) {
				//send command and collect response and read until eol
				this.Request("RETR "+ MessageNumber);
				if(this.IsError) {
					throw new Exception("Weblegs.POPDriver.GetMessage(): '"+ this.Command +"' command was not accepted by the server. (POP Error: "+ this.Reply +").");
				}
				
				return this.Reply;
			}
		//<-- End Method :: GetMessage
		
		//##################################################################################
		
		//--> Begin Method :: DeleteMessage
			public void DeleteMessage(int MessageNumber) {
				this.DeleteMessage(MessageNumber.ToString());
			}
			public void DeleteMessage(string MessageNumber) {
				//send command
				this.Request("DELE "+ MessageNumber);
				if(IsError) {
					throw new Exception("Weblegs.POPDriver.DeleteMessage(): '"+ this.Command +"' command was not accepted by the server. (POP Error: "+ this.Reply +").");
				}
			}
		//<-- End Method :: DeleteMessage
		
		//##################################################################################
		
		//--> Begin Method :: Request
			public string Request(string Command) {
				//populate the command property
				this.Command = Command;
				
				//write to connection
				this.Socket.Write(this.Command +"\r\n");
				
				//read the response
				string ReturnData = "";
				string tmpData = this.Socket.ReadLine();
				
				//check for error
				if(tmpData.StartsWith("-")) {
					this.IsError = true;
					ReturnData = tmpData;
				}
				else {
					this.IsError = false;
					
					//should we read a multi-line response?
					if(
						(this.Command.StartsWith("LIST") && !this.Command.StartsWith("LIST ")) || 
						this.Command.StartsWith("RETR") || 
						this.Command.StartsWith("TOP") || 
						this.Command.StartsWith("UIDL")
					) {
						while(tmpData != ".") {
							ReturnData += tmpData + "\r\n";
							tmpData = this.Socket.ReadLine();
						}
					}
					else {
						ReturnData = tmpData;
					}
				}
				
				//populate reply message
				this.Reply = ReturnData;
				
				//return the reply message (easier to dev w/)
				return this.Reply;
			}
		//<-- End Method :: Request
	}
//<-- End Class :: POPDriver

//##########################################################################################
</script>