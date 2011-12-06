<%!
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
			public String Username;
			public String Password;
			public String Host;
			public int Port;
			public String Protocol; //ssl/tls/tcp
			public int Timeout;
			public String Command;
			public String Reply;
			public boolean IsError;
			public SocketDriver Socket;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public POPDriver() throws Exception {
				this.Username = "";
				this.Password = "";
				this.Host = "";
				this.Port = 110;
				this.Protocol = "tcp"; //ssl/tls/tcp
				this.Timeout = 10;
				this.Reply = "";
				this.Command = "";
				this.IsError = false;
				this.Socket = new SocketDriver();
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Open
			public void Open() throws Exception {
				//make sure we're not already connected
				if(this.Socket.IsOpen()) {
					return;
				}
				
				//make sure the host was specified
				if(this.Host.equals("")) {
					throw new Exception("Weblegs.POPDriver.Open(): No host specified.");
				}
				
				//make sure the username was specified
				if(this.Username.equals("")) {
					throw new Exception("Weblegs.POPDriver.Open(): No username specified.");
				}
				
				//make sure the password was specified
				if(this.Password.equals("")) {
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
					throw new Exception("Weblegs.POPDriver.Open(): Failed to connect to host '"+ this.Host +"'. "+ e.toString());
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
			public void Close() throws Exception {
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
			public int GetMessageCount() throws Exception {
				this.Request("STAT");
				if(this.IsError) {
					throw new Exception("Weblegs.POPDriver.GetMessageCount(): '"+ this.Command +"' command was not accepted by the server. (POP Error: "+ this.Reply +").");
				}
				
				String[] arrStats = this.Reply.split(" ");
				
				//the second element is the number of messages
				return Integer.valueOf(arrStats[1]);
			}
		//<-- End Method :: GetMessageCount
		
		//##################################################################################
		
		//--> Begin Method :: GetMailBoxSize
			public int GetMailBoxSize() throws Exception {
				this.Request("STAT");
				if(this.IsError) {
					throw new Exception("Weblegs.POPDriver.GetMessageCount(): '"+ this.Command +"' command was not accepted by the server. (POP Error: "+ this.Reply +").");
				}
				
				String[] arrStats = this.Reply.split(" ");
				
				//the third element is the number of messages
				return Integer.valueOf(arrStats[2]);
			}
		//<-- End Method :: GetMailBoxSize
		
		//##################################################################################
		
		//--> Begin Method :: GetHeaders
			public String GetHeaders(int MessageNumber) throws Exception {
				return this.GetHeaders(String.valueOf(MessageNumber));
			}
			public String GetHeaders(String MessageNumber) throws Exception {
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
			public String GetMessage(int MessageNumber) throws Exception {
				return this.GetMessage(String.valueOf(MessageNumber));
			}
			public String GetMessage(String MessageNumber) throws Exception {
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
			public void DeleteMessage(int MessageNumber) throws Exception {
				this.DeleteMessage(String.valueOf(MessageNumber));
			}
			public void DeleteMessage(String MessageNumber) throws Exception {
				//send command
				this.Request("DELE "+ MessageNumber);
				if(IsError) {
					throw new Exception("Weblegs.POPDriver.DeleteMessage(): '"+ this.Command +"' command was not accepted by the server. (POP Error: "+ this.Reply +").");
				}
			}
		//<-- End Method :: DeleteMessage
		
		//##################################################################################
		
		//--> Begin Method :: Request
			public String Request(String Command) throws Exception {
				//populate the command property
				this.Command = Command;
				
				//write to connection
				this.Socket.Write(this.Command +"\r\n");
				
				//read the response
				String ReturnData = "";
				String tmpData = this.Socket.ReadLine();
				
				//check for error
				if(tmpData.startsWith("-")) {
					this.IsError = true;
					ReturnData = tmpData;
				}
				else {
					this.IsError = false;
					
					//should we read a multi-line response?
					if(
						(this.Command.startsWith("LIST") && !this.Command.startsWith("LIST ")) || 
						this.Command.startsWith("RETR") || 
						this.Command.startsWith("TOP") || 
						this.Command.startsWith("UIDL")
					) {
						while(true) {
							ReturnData += tmpData + "\r\n";
							tmpData = this.Socket.ReadLine();
							
							if(tmpData.length() == 1){
								if(tmpData.charAt(0) == '.'){
									break;
								}
							}
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
%>