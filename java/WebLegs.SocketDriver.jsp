<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="javax.net.ssl.SSLSocket" %>
<%@ page import="javax.net.ssl.SSLSocketFactory" %>
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

//--> Begin Class :: SocketDriver
	public class SocketDriver {
		//--> Begin :: Properties
			//basic properties
			public Socket Connection;
			public SSLSocket SecureConnection;
			public String Host;
			public int Port;
			public String Protocol;
			public int Timeout;
			
			public BufferedReader SocketReader;
			public PrintWriter SocketWriter;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public SocketDriver() {
				this.Connection = null;
				this.SecureConnection = null;
				this.Host = "";
				this.Port = -1;
				this.Protocol = "tcp"; //ssl/tls/tcp
				this.Timeout = 10; //seconds
				this.SocketReader = null;
				this.SocketWriter = null;
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin :: Destructor
			protected void finalize() throws Exception {
				this.Close();
			}
		//<-- End :: Destructor
		
		//##################################################################################
		
		//--> Begin Method :: Open
			public void Open() throws Exception {
				//determine what protocol being used and set the socket type
				try{
					//create tcp sockect
					if(this.Protocol.equals("tcp")){
						
						//create socket
						this.Connection = new Socket(this.Host, this.Port);
     					
						//set up streams
						this.SocketWriter = new PrintWriter((OutputStream)this.Connection.getOutputStream());
		            	this.SocketReader = new BufferedReader(new InputStreamReader( (InputStream)this.Connection.getInputStream()));
					}
					//create ssl socket
					else if(this.Protocol.equals("ssl") || this.Protocol.equals("tls")){
						
						SSLSocketFactory MySSLSocketFactory = (SSLSocketFactory) SSLSocketFactory.getDefault();
						this.SecureConnection = (SSLSocket) MySSLSocketFactory.createSocket(this.Host, this.Port);
						
						this.SocketWriter = new PrintWriter((OutputStream)this.SecureConnection.getOutputStream());
		            	this.SocketReader = new BufferedReader(new InputStreamReader((InputStream)this.SecureConnection.getInputStream()));
						
					}
					//throw an exception because protocol is not supported
					else{
						throw new Exception("Weblegs.SocketDriver: Unsupported protocol.");
					}
				}
				//failed to connect
				catch(Exception e){
					throw new Exception("Weblegs.SocketDriver.Open(): Failed to connect."+ e.toString());
				}
				
			}
		//<-- End Method :: Open
		
		//##################################################################################
		
		//--> Begin Method :: Close
			public void Close() throws Exception {
				//no sockets open
				if(this.Connection == null && this.SecureConnection == null) {
					return;
				}
				//determine which socket is in use and determine if it is disconnected already
				else{
					if(this.Connection != null){
						if(!this.Connection.isConnected()){
							return;
						}
						else{
							this.Connection.close();
						}
					}
					else if(this.SecureConnection != null){
						if(!this.SecureConnection.isConnected()){
							return;
						}
						else{
							this.SecureConnection.close();
						}
					}
					
					//close streams
					this.SocketReader.close();
					this.SocketWriter.close();
				}
			}
		//<-- End Method :: Close
		
		//##################################################################################
		
		//--> Begin Method :: ReadBytes
			public String ReadBytes(int Bytes) throws Exception {
				char[] tmpRecieved = new char[Bytes];
				this.SocketReader.read(tmpRecieved, 0, Bytes);
				return new String(tmpRecieved);
			}
		//<-- End Method :: ReadBytes
		
		//##################################################################################
		
		//--> Begin Method :: ReadLine
			public String ReadLine() throws Exception {
				return this.SocketReader.readLine().replaceAll("\r", "").replaceAll("\n", "");
			}
		//<-- End Method :: ReadLine
		
		//##################################################################################
		
		//--> Begin Method :: Read
			public String Read() throws Exception {
				String tmpResult = "";
				int Continue = 0;
				
				while(Continue != -1) {
					char[] tmpRecieved = new char[1];
					Continue = this.SocketReader.read(tmpRecieved, 0, 1);
					tmpResult += new String(tmpRecieved);
				}
				
				return tmpResult;
			}
		//<-- End Method :: Read
		
		//##################################################################################
		
		//--> Begin Method :: Write
			public void Write(String Data) throws Exception {
				this.SocketWriter.write(Data);
				this.SocketWriter.flush();
			}
			public void Write(byte[] Data) throws Exception {
				this.Connection.getOutputStream().write(Data);
			}
		//<-- End Method :: Write
		
		//##################################################################################
		
		//--> Begin Method :: IsOpen
			public boolean IsOpen() throws Exception {
				if(this.Connection != null){
					return this.Connection.isConnected();
				}
				else if(this.SecureConnection != null){
					return this.SecureConnection.isConnected();
				}
				return false;
			}
		//<-- End Method :: IsOpen
	}
//<-- End Class :: SocketDriver

//##########################################################################################
%>