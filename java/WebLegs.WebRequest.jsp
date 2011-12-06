<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.ServletInputStream" %>
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

//--> Begin Class :: WebRequest
	public class WebRequest {
		//--> Begin :: Properties
			public Hashtable QueryStringHashTable;
			public String QueryString;
			public Hashtable FormDataHashTable;
			public String FormData;
			public int MaxRequestLength;
			public ArrayList<WebRequestFile> Files;
			public HttpServletRequest Request;
			public Hashtable ServerVariables;
			public HttpSession Session;
			public Hashtable Cookie;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public WebRequest(HttpServletRequest CurrentRequest) throws Exception {
				//set MaxRequestLength default - 5mb
				this.MaxRequestLength = 1024 * 5000;
				
				//set request object
				this.Request = CurrentRequest;
				
				//set session
				this.Session = this.Request.getSession(false);
				
				//set cookies
				this.Cookie =  new Hashtable();
				if(this.Request.getCookies() != null){
					Cookie[] tmpCookies = this.Request.getCookies();
					for(int i = 0; i < tmpCookies.length; i++){
						this.Cookie.put(tmpCookies[i].getName(), tmpCookies[i].getValue());
					}
				}
				
				//set enviroment variables
					this.ServerVariables = new Hashtable();
					if(this.Request.getAuthType() != null){
						this.ServerVariables.put("AUTH_TYPE", String.valueOf(this.Request.getAuthType()));
					}
					this.ServerVariables.put("CONTENT_LENGTH", String.valueOf(this.Request.getContentLength()));
					if(this.Request.getContentType() != null){
						this.ServerVariables.put("CONTENT_TYPE", String.valueOf(this.Request.getContentType()));
					}
					if(getServletContext().getRealPath("/") != null){
						this.ServerVariables.put("DOCUMENT_ROOT", getServletContext().getRealPath("/"));
					}
					if(this.Request.getPathInfo() != null && !String.valueOf(this.Request.getPathInfo()).equals("")){
						this.ServerVariables.put("PATH_INFO", String.valueOf(this.Request.getPathInfo()));
					}
					else if(this.Request.getContextPath() != null && !String.valueOf(this.Request.getContextPath()).equals("")){
						this.ServerVariables.put("PATH_INFO", String.valueOf(this.Request.getContextPath()));
					}
					if(this.Request.getPathTranslated() != null){
						this.ServerVariables.put("PATH_TRANSLATED", String.valueOf(this.Request.getPathTranslated()));
					}
					if(this.Request.getQueryString() != null){
						this.ServerVariables.put("QUERY_STRING", String.valueOf(this.Request.getQueryString()));
					}
					if(this.Request.getRemoteAddr() != null){
						this.ServerVariables.put("REMOTE_ADDR", String.valueOf(this.Request.getRemoteAddr()));
					}
					if(this.Request.getRemoteHost() != null){
						this.ServerVariables.put("REMOTE_HOST", String.valueOf(this.Request.getRemoteHost()));
					}
					if(this.Request.getRemoteUser() != null){
						this.ServerVariables.put("REMOTE_USER", String.valueOf(this.Request.getRemoteUser()));
					}
					if(this.Request.getMethod() != null){
						this.ServerVariables.put("REQUEST_METHOD", String.valueOf(this.Request.getMethod()));
					}
					if(this.Request.getServletPath() != null){
						this.ServerVariables.put("SCRIPT_NAME", String.valueOf(this.Request.getServletPath()));
					}
					if(this.Request.getServerName() != null){
						this.ServerVariables.put("SERVER_NAME", String.valueOf(this.Request.getServerName()));
					}
					this.ServerVariables.put("SERVER_PORT", String.valueOf(this.Request.getServerPort()));
					if(this.Request.getProtocol() != null){
						this.ServerVariables.put("SERVER_PROTOCOL", String.valueOf(this.Request.getProtocol()));
					}
					if(getServletContext().getServerInfo() != null){
						this.ServerVariables.put("SERVER_SOFTWARE", String.valueOf(getServletContext().getServerInfo()));
					}
					if(this.Request.getHeader("user-agent") != null){
						this.ServerVariables.put("HTTP_USER_AGENT", String.valueOf(this.Request.getHeader("user-agent")));
					}
				//end set enviroment variables
				
				//check content length - if its too large throw an error
				if(Integer.valueOf(ServerVariables("CONTENT_LENGTH")) > this.MaxRequestLength){
					throw new Exception("WebLegs.WebRequest.Constructor: Request length too large. Maximum request length is set to '"+ String.valueOf(this.MaxRequestLength) +"'. (413 Request entity too large)");
				}
				
				//set properties
				this.QueryString = "";
				this.QueryStringHashTable = new Hashtable();
				this.FormData = "";
				this.FormDataHashTable = new Hashtable();
				this.Files = new ArrayList<WebRequestFile>();
				
				if(this.Request.getQueryString() != null){
					
					//set querystring
					this.QueryString = this.Request.getQueryString();
								
					//split querystring by '&'
					String[] QueryStringItems = this.Request.getQueryString().split("&");
					
					for(int i = 0; i < QueryStringItems.length; i++){
						//split by '='
						String[] QueryStringItem = QueryStringItems[i].split("=");
						
						//get name and value
						String Name = QueryStringItem[0];
						String Value = (QueryStringItem.length == 2 ? QueryStringItem[1] : "");
						
						//decode
						Name = Codec.URLDecode(Name);
						Value = Codec.URLDecode(Value);
						
						if(this.QueryStringHashTable.containsKey(Name)){
							//get existing value and concat new value at the end
							String NewValue = this.QueryStringHashTable.get(Name) +", "+ Value;
							this.QueryStringHashTable.put(Name, NewValue);
						}
						else{
							this.QueryStringHashTable.put(Name, Value);
						}
					}
				}
				
				//make sure there is a content-type header
				if(this.Request.getHeader("content-type") != null){
					
					//make sure this is not an upload
					if(this.Request.getHeader("content-type").indexOf("multipart/form-data") == -1){
						
						try{
							BufferedReader FormBuffer = this.Request.getReader();
							StringBuffer BodyContent = new StringBuffer();
							String NextLine = FormBuffer.readLine();
							while(NextLine != null) {
							  BodyContent.append(NextLine);
							  NextLine = FormBuffer.readLine();
							}
							
							String[] FormDataItems = BodyContent.toString().split("&");
							
							//set formdata
							this.FormData = BodyContent.toString();
							
							for(int i = 0; i < FormDataItems.length; i++){
								//split by '='
								String[] FormDataItem = FormDataItems[i].split("=");
								
								//get name and value
								String Name = FormDataItem[0];
								String Value = (FormDataItem.length == 2 ? FormDataItem[1] : "");
								
								//decode
								Name = Codec.URLDecode(Name);
								Value = Codec.URLDecode(Value);
								
								try{
									if(this.FormDataHashTable.containsKey(Name)){
										//get existing value and concat new value at the end
										String NewValue = this.FormDataHashTable.get(Name) +","+ Value;
										this.FormDataHashTable.put(Name, NewValue);
									}
									else{
										this.FormDataHashTable.put(Name, Value);
									}
								}
								catch(Exception e){}
							}
						}
						catch(IOException e){
							//the body is empty
						}
					}
					//begin handle post file data & posted data
					else{
						
						int ThisLine = 0;
						String Name = null;
						String FileName = null;
						boolean IsFile = false;
						boolean ContinueRead = false;
						byte[] MyByteArray = new byte[1024];
						ServletInputStream MyInputStream = this.Request.getInputStream();
						String Boundary = "--" + this.Request.getContentType().substring(this.Request.getContentType().indexOf("boundary=") + "boundary=".length());
						
						while( (ThisLine = MyInputStream.readLine(MyByteArray, 0, 1024) ) > -1) {
							
							//get line as string
							String MyString = new String(MyByteArray, 0, ThisLine);
							
							//boundary line "-----------------------------1388398480255945058258844865"
							if(MyString.startsWith(Boundary)){
								//make sure we close last stream - if this is a file and it was currently reading
								if(ContinueRead && IsFile && FileName != null){
									this.Files.get(this.Files.size() - 1).ContentLength = String.valueOf(this.Files.get(this.Files.size() - 1).FileData.size());
									this.Files.get(this.Files.size() - 1).FileData.close();
								}
								
								ContinueRead = false;
								IsFile = false;
							}
							//content type line "Content-Type: image/jpeg"
							else if(MyString.startsWith("Content-Type") == true){
								//set the content type
								if(this.Files.size() != 0){
									this.Files.get(this.Files.size() - 1).ContentType = MyString.replaceAll("Content\\-Type\\: ", "").replace("\n", "").replace("\r", "");
								}
								ContinueRead = false;
							}
							//content-disposition line with filename "Content-Disposition: form-data; name="file"; filename="jon.satrom.gif""
							else if(MyString.startsWith("Content-Disposition") == true && MyString.indexOf("filename=") != -1){
								//get name
								Name = MyString.substring(MyString.indexOf("name=") + "name=".length(), MyString.lastIndexOf(";")).replace("\"", "").replace("\n", "").replace("\r", "");
								
								//get filename
									FileName = MyString.substring(MyString.indexOf("filename=") + "filename=\"".length(), MyString.length()).replace("\"", "").replace("\n", "").replace("\r", "");
									
									if(FileName.equals("\"\"")) {
										FileName = null;
									}
									else{
									
										//determine the file separator
										String UserAgent = this.Request.getHeader("User-Agent");
										String UserSeparator = "/";
										
										if(UserAgent.indexOf("Windows") != -1){
											UserSeparator="\\";
										}
										else{
											UserSeparator = "/";
										}
										
										if(FileName.length() != 0){
											FileName = FileName.substring(FileName.lastIndexOf(UserSeparator) + 1, FileName.length());
										}
									
										if(FileName.startsWith( "\"")){
											FileName = FileName.substring(1);
										}
									}
								//end get filename
								
								ContinueRead = false;
								
								//this is set to true, regardless if the browser sent a file - we dont inlcude file fields in FormData
								IsFile = true;
								
								if(FileName != null && FileName.length() != 0){
									
									//decode
									Name = Codec.URLDecode(Name);
									FileName = Codec.URLDecode(FileName);
									
									//create new file
									this.Files.add(new WebRequestFile());
									
									//set filename
									this.Files.get(this.Files.size() - 1).FileName = FileName;

									//set formname
									this.Files.get(this.Files.size() - 1).FormName = Name;
								}
								else{
									
									//set filename to null
									FileName = null;
								
									//decode
									Name =  Codec.URLDecode(Name);
								}
								
							}
							//content-disposition line "Content-Disposition: form-data; name="myhiddenfield""
							else if(MyString.startsWith("Content-Disposition") == true && MyString.indexOf("filename=") == -1){
								//get name
								Name = MyString.substring(MyString.indexOf("name=") + "name=".length(), MyString.length() - 1).replace("\"", "");
								
								ContinueRead = false;
								IsFile = false;
							}
							//detect carriage return and new line - now we can start reading
							else if((MyString.equals("\r\n") || MyString.equals("\n")) && !ContinueRead){
								ContinueRead = true;
							}
							else if(ContinueRead){
								
								if(IsFile && FileName != null){
									//write data to buffer
									this.Files.get(this.Files.size() - 1).FileData.write(MyByteArray, 0, ThisLine);
								}
								else if(IsFile == false){
									//decode
									MyString = Codec.URLDecode(MyString);
									Name = Codec.URLDecode(Name).trim();
									
									//if the value already exists in the hashtable then append it
									if(this.FormDataHashTable.containsKey(Name)){
										//get existing value and concat new value at the end
										String NewValue = this.FormDataHashTable.get(Name) +","+ MyString;
										this.FormDataHashTable.put(Name, NewValue);
									}
									else{
										this.FormDataHashTable.put(Name, MyString);
									}
									
								}
							}
						}
						
						//build FormData Property
							if(this.FormDataHashTable.size() > 0){
								Vector MyVector = new Vector(this.FormDataHashTable.keySet());
								Collections.sort(MyVector);
								for(Enumeration e = MyVector.elements(); e.hasMoreElements();) {
									String Key = (String)e.nextElement();
									String Value = (String)this.FormDataHashTable.get(Key);
									this.FormData += "&"+ Key +"="+ Value;
								}
								this.FormData = this.FormData.substring(1);
							}
						//end build FormData Property
						
						
						//close input stream
						MyInputStream.close();
					}
					//end handle post file data
				}
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Form
			public String Form() {
				return this.FormData;
			}
			public String Form(String Key) throws Exception {
				if(this.FormDataHashTable.containsKey(Key) == false){
					return null;
				}
				else{
					return this.FormDataHashTable.get(Key).toString();
				}
			}
			public String Form(String Key, String Default) throws Exception {
				if(this.FormDataHashTable.get(Key) == null){
					return Default;
				}
				else{
					return this.FormDataHashTable.get(Key).toString();
				}
			}
		//<-- End Method :: Form
		
		//##################################################################################

		//--> Begin Method :: QueryString
			public String QueryString() {
				return this.QueryString;
			}
			public String QueryString(String Key) {
				if(this.QueryStringHashTable.get(Key) == null){
					return null;
				}
				else{
					return this.QueryStringHashTable.get(Key).toString();
				}
			}
			public String QueryString(String Key, String Default) {
				if(this.QueryStringHashTable.get(Key) == null){
					return Default;
				}
				else{
					return this.QueryStringHashTable.get(Key).toString();
				}
			}
		//<-- End Method :: QueryString
		
		//##################################################################################
		
		//--> Begin Method :: Input
			public String Input(String Key) throws Exception {
				return this.Input(Key, "", true);
			}
			public String Input(String Key, String Default) throws Exception {
				return this.Input(Key, Default, true);
			}
			public String Input(String Key, String Default, boolean FormFirst) throws Exception {
				String Value;
				
				if(FormFirst) {
					Value = this.Form(Key);
					if(Value == null) {
						Value = this.QueryString(Key);
					}
				}
				else {
					Value = this.QueryString(Key);
					if(Value == null) {
						Value = this.Form(Key);
					}
				}
				
				if(Value == null) Value = Default;
				
				return Value;
			}
			public String Input(String Key, int Default) throws Exception {
				String NewDefault = String.valueOf(Default);
				return this.Input(Key, NewDefault);
			}
			public String Input(String Key, int Default, boolean FormFirst) throws Exception {
				String NewDefault = String.valueOf(Default);
				return this.Input(Key, NewDefault, FormFirst);
			}
			public String Input(String Key, double Default) throws Exception {
				String NewDefault = String.valueOf(Default);
				return this.Input(Key, NewDefault);
			}
			public String Input(String Key, double Default, boolean FormFirst) throws Exception {
				String NewDefault = String.valueOf(Default);
				return this.Input(Key, NewDefault, FormFirst);
			}
		//<-- End Method :: Input
		
		//##################################################################################
		
		//--> Begin Method :: File
			public WebRequestFile File(String Key) throws Exception {
				for(int i = 0; i < this.Files.size(); ++i ){
					if(this.Files.get(i).FormName.equals(Key)){
						return this.Files.get(i);
					}
				}
				return null;
			}
		//<-- End Method :: File
		
		//##################################################################################
		
		//--> Begin Method :: ServerVariables
			public String ServerVariables(String Key) {
				if(this.ServerVariables.containsKey(Key)){
					return this.ServerVariables.get(Key).toString();
				}
				else{
					return null;
				}
			}
		//<-- End Method :: ServerVariables
		
		//##################################################################################
		
		//--> Begin Method :: Session
			public String Session(String Key) {
				if(this.Session == null) {
					return null;
				}
				else {
					if(this.Session.getAttribute(Key) == null){
						return null;
					}
					else{
						return this.Session.getAttribute(Key).toString();
					}
				}
			}
		//<-- End Method :: Session

		//##################################################################################
		
		//--> Begin Method :: Cookies
			public String Cookies(String Key) {
				if(this.Cookie.containsKey(Key)) {
					return this.Cookie.get(Key).toString();
				}
				else {
					return null;
				}
			}
		//<-- End Method :: Cookies

		//##################################################################################
		
		//--> Begin Method :: Header
			public String Header(String Key) {
				return this.Request.getHeader(Key);
			}
		//<-- End Method :: Header
	}
//<-- End Class :: WebRequest

//##########################################################################################
%>