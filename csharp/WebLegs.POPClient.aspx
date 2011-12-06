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
	public class POPClient {
		//--> Begin :: Properties
			public string Username;
			public string Password;
			public string Host;
			public int Port;
			public string Protocol;
			public int Timeout;
			public POPDriver POPDriver;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public POPClient() {
				this.Username = "";
				this.Password = "";
				this.Host = "";
				this.Port = 110;
				this.Protocol = "tcp";
				this.Timeout = 10;
				this.POPDriver = new POPDriver();
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Open
			public void Open() {
				this.POPDriver.Username = this.Username;
				this.POPDriver.Password = this.Password;
				this.POPDriver.Host = this.Host;
				this.POPDriver.Port = this.Port;
				this.POPDriver.Protocol = this.Protocol;
				this.POPDriver.Timeout = this.Timeout;
				
				//try to connect
				try {
					this.POPDriver.Open();
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.Open(): Failed to connect to host '"+ this.Host +"'. "+ e.ToString());
				}
			}
		//<-- End Method :: Open
		
		//##################################################################################
		
		//--> Begin Method :: Close
			public void Close() {
				//try to close
				try {
					this.POPDriver.Close();
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.Close(): Failed to close. "+ e.ToString());
				}
			}
		//<-- End Method :: Close
		
		//##################################################################################
		
		//--> Begin Method :: GetMessageCount
			public int GetMessageCount() {
				try {
					return this.POPDriver.GetMessageCount();
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.GetMessageCount(): Failed to get message count. "+ e.ToString());
				}
			}
		//<-- End Method :: GetMessageCount
		
		//##################################################################################
		
		//--> Begin Method :: GetMailBoxSize
			public int GetMailBoxSize() {
				try {
					return this.POPDriver.GetMailBoxSize();
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.GetMailBoxSize(): Failed to get mailbox size. "+ e.ToString());
				}
			}
		//<-- End Method :: GetMailBoxSize
		
		//##################################################################################
		
		//--> Begin Method :: DeleteMessage
			public void DeleteMessage(int MessageNumber) {
				this.DeleteMessage(MessageNumber.ToString());
			}
			public void DeleteMessage(string MessageNumber) {
				//try to delete
				try {
					this.POPDriver.DeleteMessage(MessageNumber);
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.DeleteMessage(): Failed to delete message #"+ MessageNumber +". "+ e.ToString());
				}
			}
		//<-- End Method :: DeleteMessage
		
		//##################################################################################
		
		//--> Begin Method :: DeleteMessages
			public void DeleteMessages(int Start, int End) {
				for(int i = Start ; i <= End ; i++) {
					//try to delete
					try {
						this.POPDriver.DeleteMessage(i);
					}
					catch(Exception e) {
						throw new Exception("Weblegs.POPClient.DeleteMessages(): Failed to delete message #"+ i.ToString() +". "+ e.ToString());
					}
				}
			}
			public void DeleteMessages() {
				//get the message count
				int MessageCount = this.GetMessageCount();
				
				//are there any messages?
				if(MessageCount > 0) {
					//lets call our other overload
					this.DeleteMessages(1, MessageCount);
				}
			}
		//<-- End Method :: DeleteMessages
		
		//##################################################################################
		
		//--> Begin Method :: GetMIMEMessage
			public MIMEMessage GetMIMEMessage(int MessageNumber) {
				return this.GetMIMEMessage(MessageNumber.ToString());
			}
			public MIMEMessage GetMIMEMessage(string MessageNumber) {
				string thisMIME = this.GetMessage(MessageNumber);
				return new MIMEMessage(ref thisMIME);
			}
		//<-- End Method :: GetMIMEMessage
		
		//##################################################################################
		
		//--> Begin Method :: GetMIMEMessages
			public MIMEMessage[] GetMIMEMessages(int Start, int End) {
				//find our range
				int Range = End - Start;
				
				//setup array of MIMEMessages
				MIMEMessage[] myMIMEMessages = new MIMEMessage[Range];
				
				//build array
				int RangeGuide = 0;
				for(int i = Start ; i <= End ; i++) {
					//try to delete
					try {
						myMIMEMessages[RangeGuide] = this.GetMIMEMessage(i);
						RangeGuide++;
					}
					catch(Exception e) {
						throw new Exception("Weblegs.POPClient.GetMIMEMessages(): Failed to get message #"+ i.ToString() +". "+ e.ToString());
					}
				}
				
				//return
				return myMIMEMessages;
			}
			public MIMEMessage[] GetMIMEMessages() {
				//get the message count
				int MessageCount = this.GetMessageCount();
				
				//are there any messages?
				if(MessageCount > 0) {
					//lets call our other overload
					return this.GetMIMEMessages(1, MessageCount);
				}
				else {
					return this.GetMIMEMessages(0, 0);
				}
			}
		//<-- End Method :: GetMIMEMessages
		
		//##################################################################################
		
		//--> Begin Method :: GetHeader
			public string GetHeader(int MessageNumber) {
				return this.GetHeader(MessageNumber.ToString());
			}
			public string GetHeader(string MessageNumber) {
				//try to get headers
				try {
					return this.POPDriver.GetHeaders(MessageNumber);
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.GetHeader(): Failed to get headers for message #"+ MessageNumber +". "+ e.ToString());
				}
			}
		//<-- End Method :: GetHeader
		
		//##################################################################################
		
		//--> Begin Method :: GetHeaders
			public string[] GetHeaders(int Start, int End) {
				//find our range
				int Range = End - Start;
				
				//setup array of MIMEMessages
				string[] myHeaders = new string[Range];
				
				//build array
				int RangeGuide = 0;
				for(int i = Start ; i <= End ; i++) {
					//try to delete
					try {
						myHeaders[RangeGuide] = this.GetHeader(i);
						RangeGuide++;
					}
					catch(Exception e) {
						throw new Exception("Weblegs.POPClient.GetHeaders(): Failed to get headers for message #"+ i.ToString() +". "+ e.ToString());
					}
				}
				
				//return
				return myHeaders;
			}
			public string[] GetHeaders() {
				//get the message count
				int MessageCount = this.GetMessageCount();
				
				//are there any messages?
				if(MessageCount > 0) {
					//lets call our other overload
					return this.GetHeaders(1, MessageCount);
				}
				else {
					return this.GetHeaders(0, 0);
				}
			}
		//<-- End Method :: GetHeaders
		
		//##################################################################################
		
		//--> Begin Method :: GetMessage
			public string GetMessage(int MessageNumber) {
				return this.GetMessage(MessageNumber.ToString());
			}
			public string GetMessage(string MessageNumber) {
				//try to get headers
				try {
					return this.POPDriver.GetMessage(MessageNumber);
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.GetMessage(): Failed to get message #"+ MessageNumber +". "+ e.ToString());
				}
			}
		//<-- End Method :: GetMessage
		
		//##################################################################################
		
		//--> Begin Method :: GetMessages
			public string[] GetMessages(int Start, int End) {
				//find our range
				int Range = End - Start;
				
				//setup array of MIMEMessages
				string[] myMessages = new string[Range];
				
				//build array
				int RangeGuide = 0;
				for(int i = Start ; i <= End ; i++) {
					//try to delete
					try {
						myMessages[RangeGuide] = GetMessage(i);
						RangeGuide++;
					}
					catch(Exception e) {
						throw new Exception("Weblegs.POPClient.GetMessages(): Failed to get message #"+ i.ToString() +". "+ e.ToString());
					}
				}
				
				//return
				return myMessages;
			}
			public string[] GetMessages() {
				//get the message count
				int MessageCount = this.GetMessageCount();
				
				//are there any messages?
				if(MessageCount > 0) {
					//lets call our other overload
					return this.GetMessages(1, MessageCount);
				}
				else {
					return this.GetMessages(0, 0);
				}
			}
		//<-- End Method :: GetMessages
	}
//<-- End Class :: POPClient

//##########################################################################################
</script>