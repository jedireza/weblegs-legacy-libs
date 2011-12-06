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
	public class POPClient {
		//--> Begin :: Properties
			public String Username;
			public String Password;
			public String Host;
			public int Port;
			public String Protocol; //ssl/tls/tcp
			public int Timeout;
			public POPDriver POPDriver;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public POPClient() throws Exception {
				this.Username = "";
				this.Password = "";
				this.Host = "";
				this.Port = 110;
				this.Protocol = "tcp"; //ssl/tls/tcp
				this.Timeout = 10;
				this.POPDriver = new POPDriver();
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Open
			public void Open() throws Exception {
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
					throw new Exception("Weblegs.POPClient.Open(): Failed to connect to host '"+ this.POPDriver.Host +"'. "+ e.toString());
				}
			}
		//<-- End Method :: Open
		
		//##################################################################################
		
		//--> Begin Method :: Close
			public void Close() throws Exception {
				//try to connect
				try {
					this.POPDriver.Close();
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.Close(): Failed to close. "+ e.toString());
				}
			}
		//<-- End Method :: Close
		
		//##################################################################################
		
		//--> Begin Method :: GetMessageCount
			public int GetMessageCount() throws Exception {
				try {
					return this.POPDriver.GetMessageCount();
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.GetMessageCount(): Failed to get message count. "+ e.toString());
				}
			}
		//<-- End Method :: GetMessageCount
		
		//##################################################################################
		
		//--> Begin Method :: GetMailBoxSize
			public int GetMailBoxSize() throws Exception {
				//try to connect
				try {
					return this.POPDriver.GetMailBoxSize();
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.GetMailBoxSize(): Failed to get mailbox size. "+ e.toString());
				}
			}
		//<-- End Method :: GetMailBoxSize
		
		//##################################################################################
		
		//--> Begin Method :: DeleteMessage
			public void DeleteMessage(int MessageNumber) throws Exception {
				this.DeleteMessage(String.valueOf(MessageNumber));
			}
			public void DeleteMessage(String MessageNumber) throws Exception {
				//try to delete
				try {
					this.POPDriver.DeleteMessage(MessageNumber);
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.DeleteMessage(): Failed to delete message #"+ MessageNumber +". "+ e.toString());
				}
			}
		//<-- End Method :: DeleteMessage
		
		//##################################################################################
		
		//--> Begin Method :: DeleteMessages
			public void DeleteMessages(int Start, int End) throws Exception {
				for(int i = Start ; i <= End ; i++) {
					//try to delete
					try {
						this.POPDriver.DeleteMessage(i);
					}
					catch(Exception e) {
						throw new Exception("Weblegs.POPClient.DeleteMessages(): Failed to delete message #"+ String.valueOf(i) +". "+ e.toString());
					}
				}
			}
			public void DeleteMessages() throws Exception {
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
			public MIMEMessage GetMIMEMessage(int MessageNumber) throws Exception {
				return this.GetMIMEMessage(String.valueOf(MessageNumber));
			}
			public MIMEMessage GetMIMEMessage(String MessageNumber) throws Exception {
				String thisMIME = this.GetMessage(MessageNumber);
				return new MIMEMessage(thisMIME);
			}
		//<-- End Method :: GetMIMEMessage
		
		//##################################################################################
		
		//--> Begin Method :: GetMIMEMessages
			public MIMEMessage[] GetMIMEMessages(int Start, int End) throws Exception {
				//find our range
				int Range = End - Start + 1;
				
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
						throw new Exception("Weblegs.POPClient.GetMIMEMessages(): Failed to get message #"+ String.valueOf(i) +". "+ e.toString());
					}
				}
				
				//return
				return myMIMEMessages;
			}
			public MIMEMessage[] GetMIMEMessages() throws Exception {
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
			public String GetHeader(int MessageNumber) throws Exception {
				return this.GetHeader(String.valueOf(MessageNumber));
			}
			public String GetHeader(String MessageNumber) throws Exception {
				//try to get headers
				try {
					return this.POPDriver.GetHeaders(MessageNumber);
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.GetHeaders(): Failed to get headers for message #"+ MessageNumber +". "+ e.toString());
				}
			}
		//<-- End Method :: GetHeader
		
		//##################################################################################
		
		//--> Begin Method :: GetHeaders
			public String[] GetHeaders(int Start, int End) throws Exception {
				//find our range
				int Range = End - Start + 1;
				
				//setup array of MIMEMessages
				String[] myHeaders = new String[Range];
				
				//build array
				int RangeGuide = 0;
				for(int i = Start ; i <= End ; i++) {
					//try to delete
					try {
						myHeaders[RangeGuide] = GetHeader(i);
						RangeGuide++;
					}
					catch(Exception e) {
						throw new Exception("Weblegs.POPClient.GetHeaders(): Failed to get header for message #"+ String.valueOf(i) +". "+ e.toString());
					}
				}
				
				//return
				return myHeaders;
			}
			public String[] GetHeaders() throws Exception {
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
			public String GetMessage(int MessageNumber) throws Exception {
				return this.GetMessage(String.valueOf(MessageNumber));
			}
			public String GetMessage(String MessageNumber) throws Exception {
				//try to get headers
				try {
					return this.POPDriver.GetMessage(MessageNumber);
				}
				catch(Exception e) {
					throw new Exception("Weblegs.POPClient.GetMessage(): Failed to get message #"+ MessageNumber +". "+ e.toString());
				}
			}
		//<-- End Method :: GetMessage
		
		//##################################################################################
		
		//--> Begin Method :: GetMessages
			public String[] GetMessages(int Start, int End) throws Exception {
				//find our range
				int Range = End - Start + 1;
				
				//setup array of MIMEMessages
				String[] myMessages = new String[Range];
				
				//build array
				int RangeGuide = 0;
				for(int i = Start ; i <= End ; i++) {
					//try to delete
					try {
						myMessages[RangeGuide] = GetMessage(i);
						RangeGuide++;
					}
					catch(Exception e) {
						throw new Exception("Weblegs.POPClient.GetMessages(): Failed to get message #"+ String.valueOf(i) +". "+ e.toString());
					}
				}
				
				//return
				return myMessages;
			}
			public String[] GetMessages() throws Exception {
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
%>