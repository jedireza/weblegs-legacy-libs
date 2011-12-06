<%@ page import="java.security.*" %>
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

//--> Begin Class :: SMTPDriver
	public class SMTPDriver {
		//--> Begin :: Properties
			public String Username;
			public String Password;
			public String Host;
			public int Port;
			public String Protocol; //ssl/tls/tcp
			public int Timeout;
			public String Annoucement;
			public int ReplyCode;
			public String ReplyText;
			public String Reply;
			public String Command;
			public SocketDriver Socket;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public SMTPDriver() throws Exception {
				this.Username = "";
				this.Password = "";
				this.Host = "";
				this.Port = 25;
				this.Protocol = "tcp"; //ssl/tls/tcp
				this.Timeout = 10;
				this.Annoucement = "";
				this.ReplyCode = -1;
				this.ReplyText = "";
				this.Reply = "";
				this.Command = "";
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
					throw new Exception("Weblegs.SMTPDriver.Open(): No host specified.");
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
					throw new Exception("Weblegs.SMTPDriver.Open(): Failed to connect to host. "+ e.toString());
				}
				
				//retrieve announcements (also clears the response from socket)
				this.Annoucement = this.Socket.ReadLine();
				
				//try "EHLO" command first
				this.Request("EHLO "+ this.Host);
				
				if(this.ReplyCode != 250) {
					//try "HELO" now
					this.Request("HELO "+ this.Host);
					if(this.ReplyCode != 250) {
						throw new Exception("Weblegs.SMTPDriver.Connect(): 'HELO' and 'EHLO' command(s) were not accepted by the server (SMTP Error Number: "+ this.ReplyCode +". SMTP Error: "+ this.ReplyText +"). Full Text: "+ this.Reply +").");
					}
				}
				
				//if username is not blank this implies use of authentication
				if(!this.Username.equals("")) {
					if(this.Authenticate("AUTH LOGIN") == false) {
						if(this.Authenticate("AUTH PLAIN") == false) {
							if(this.Authenticate("AUTH CRAM-MD5") == false) {
								throw new Exception("Weblegs.SMTPDriver.Open(): 'AUTH LOGIN, AUTH PLAIN & AUTH CRAM-MD5' commands were not accepted by the server (SMTP Error Number: "+ this.ReplyCode +". SMTP Error: "+ this.ReplyText +" Full Text: "+ this.Reply +").");
							}
						}
					}
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
				if(this.ReplyCode != 221) {
					throw new Exception("Weblegs.SMTPDriver.Close(): '"+ this.Command +"' command was not accepted by the server (SMTP Error Number: "+ this.ReplyCode +". SMTP Error: "+ this.ReplyText +". Full Text: "+ this.Reply +").");
				}
				
				//close socket
				this.Socket.Close();
			}
		//<-- End Method :: Close
		
		//##################################################################################
		
		//--> Begin Method :: Authenticate
			public boolean Authenticate(String Command) throws Exception {
					//- - - - - - - - - - - - - -//
					if(Command.equals("AUTH CRAM-MD5")){
						//start authentication
						this.Request("AUTH CRAM-MD5");
						
						if(this.ReplyCode != 334) {
							return false;
						}
						
						String Digest = Codec.HMACMD5Encrypt(this.Password, Codec.Base64Decode(this.ReplyText));
						
						this.Request(Codec.Base64Encode((this.Username +" "+ Digest)));
						
						if(this.ReplyCode != 235) {
							return false;
						}
				
						//everything went through
						return true;
					}
					//- - - - - - - - - - - - - -//
					else if(Command.equals("AUTH LOGIN")){
						//start authentication
						this.Request("AUTH LOGIN");
						if(this.ReplyCode != 334) {
							return false;
						}
						
						//send encoded username
						this.Request(Codec.Base64Encode(this.Username));
						if(this.ReplyCode != 334) {
							return false;
						}
						
						//send encoded password
						this.Request(Codec.Base64Encode(this.Password));
						if(this.ReplyCode != 235) {
							return false;
						}
						
						//everything went through
						return true;
					}
					//- - - - - - - - - - - - - -//
					else if(Command.equals("AUTH PLAIN")){
						//start authentication
						this.Request("AUTH PLAIN");
						
						if(this.ReplyCode != 334) {
							return false;
						}
						
						String NullChar = "\u0000";
						this.Request(Codec.Base64Encode(NullChar + this.Username + NullChar + this.Password));
						
						if(this.ReplyCode != 235) {
							return false;
						}
						
						//everything went through
						return true;
					}
				
				//didn't make it
				return false;
			}
		//<-- End Method :: Authenticate
		
		//##################################################################################
		
		//--> Begin Method :: SetFrom
			public void SetFrom(String FromAddress) throws Exception {
				this.Request("MAIL FROM:<"+ FromAddress +">");
				if(this.ReplyCode != 250) {
					throw new Exception("Weblegs.SMTPDriver.SetFrom(): '"+ this.Command +"' command was not accepted by the server (SMTP Error Number: "+ this.ReplyCode +". SMTP Error: "+ this.ReplyText +". Full Text: "+ this.Reply +").");	
				}
			}
		//<-- End Method :: SetFrom
		
		//##################################################################################
		
		//--> Begin Method :: AddRecipient
			public void AddRecipient(String EmailAddress) throws Exception {
				this.Request("RCPT TO:<"+ EmailAddress +">");
				if(this.ReplyCode != 251 && this.ReplyCode != 250) {
					throw new Exception("Weblegs.SMTPDriver.AddRecipient(): '"+ this.Command +"' command was not accepted by the server (SMTP Error Number: "+ this.ReplyCode +". SMTP Error: "+ this.ReplyText +". Full Text: "+ this.Reply +").");
				}
			}
		//<-- End Method :: AddRecipient
		
		//##################################################################################
		
		//--> Begin Method :: Send
			public void Send(String Data) throws Exception {
				//tell the server to get ready
				this.Request("DATA");
				if(this.ReplyCode != 354) {
					throw new Exception("Weblegs.SMTPDriver.SendMessage(): '"+ this.Command +"' command was not accepted by the server (SMTP Error Number: "+ this.ReplyCode +". SMTP Error: "+ this.ReplyText +". Full Text: "+ this.Reply +").");		
				}
				
				//split up the data
				String[] arrMessageData = Data.split("\n");
				
				//write lines to connection
				for(int i = 0 ; i < arrMessageData.length ; i++) {
					this.Socket.Write(arrMessageData[i] +"\r\n");
				}
				
				//finalize DATA command
				this.Request("\r\n.");
				if(this.ReplyCode != 250) {
					throw new Exception("Weblegs.SMTPDriver.SendMessage(): '"+ this.Command +"' command was not accepted by the server (SMTP Error Number: "+ this.ReplyCode +". SMTP Error: "+ this.ReplyText +". Full Text: "+ this.Reply +").");
				}
			}
		//<-- End Method :: Send
		
		//##################################################################################
		
		//--> Begin Method :: Request
			public String Request(String Command) throws Exception {
				//clear the last reply
				this.Reply = "";
				this.ReplyText = "";
				this.ReplyCode = -1;
				
				//populate the command property
				this.Command = Command;
				
				//send command
				this.Socket.Write(this.Command +"\r\n");
				
				//get reply
				String Line = "";
				while((Line = this.Socket.ReadLine()) != null) {
					if(Line.charAt(3) == ' ') {	
						this.Reply = Line;
						break;
					}
				}
				
				//parse reply data
				this.ReplyText = this.Reply.substring(4);
				this.ReplyCode = Integer.valueOf(this.Reply.substring(0, 3));
				
				//return the reply message (easier to dev w/)
				return this.Reply;
			}
		//<-- End Method :: Request
	   
	   //##################################################################################
	}
//<-- End Class :: SMTPDriver

//##########################################################################################
%>