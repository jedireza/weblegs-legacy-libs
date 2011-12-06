<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
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

//--> Begin Class :: SMTPClient
	public class SMTPClient {
		//--> Begin :: Properties
			public String[] From; //[address,name]
			public String[] ReplyTo; //[address,name]
			public ArrayList<String[]> To;
			public ArrayList<String[]> CC;
			public ArrayList<String[]> BCC;
			public String Priority;
			public String Subject;
			public String Message;
			public boolean IsHTML;
			public ArrayList<String> Attachments;
			public String Host;
			public int Port;
			public String Protocol;
			public int Timeout;
			public String Username;
			public String Password;
			public SMTPDriver SMTPDriver;
			public MIMEMessage MIMEMessage;
			public Hashtable ContentTypeList;
			public boolean OpenedManually;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public SMTPClient() throws Exception {
				this.From = new String[2];
				this.ReplyTo = new String[2];
				this.To = new ArrayList<String[]>();
				this.CC = new ArrayList<String[]>();
				this.BCC = new ArrayList<String[]>();
				this.Priority = "3";
				this.Subject = "";
				this.Message = "";
				this.IsHTML = false;
				this.Attachments = new ArrayList<String>();
				this.Host = "";
				this.Port = 25;
				this.Protocol = "tcp";
				this.Timeout = 10;
				this.Username = "";
				this.Password = "";
				this.SMTPDriver = new SMTPDriver();
				this.MIMEMessage = new MIMEMessage();
				this.ContentTypeList = BuildContentTypeList();
				this.OpenedManually = false;
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Open
			public void Open() throws Exception {
				//setup the SMTPDriver
				this.SMTPDriver.Host = this.Host;
				this.SMTPDriver.Port = this.Port;
				this.SMTPDriver.Protocol = this.Protocol;
				this.SMTPDriver.Timeout = this.Timeout;
				this.OpenedManually = true;
				
				try {
					this.SMTPDriver.Open();
				}
				catch(Exception e) {
					throw new Exception("Weblegs.SMTPClient.Open(): Failed to open connection. "+ e.toString());
				}
			}
		//<-- End Method :: Open
		
		//##################################################################################
		
		//--> Begin Method :: Close
			public void Close() throws Exception {
				try {
					this.SMTPDriver.Close();
				}
				catch(Exception e) {
					throw new Exception("Weblegs.SMTPClient.Close(): Failed to close connection. "+ e.toString());
				}
			}
		//<-- End Method :: Close
		
		//##################################################################################
		
		//--> Begin Method :: SetFrom
			public void SetFrom(String EmailAddress, String Name) throws Exception {
				this.From[0] = EmailAddress;
				this.From[1] = Name;
			}
			public void SetFrom(String EmailAddress) throws Exception {
				this.From[0] = EmailAddress;
				this.From[1] = "";
			}
		//<-- End Method :: SetFrom
		
		//##################################################################################
		
		//--> Begin Method :: SetReplyTo
			public void SetReplyTo(String EmailAddress, String Name) throws Exception {
				this.ReplyTo[0] = EmailAddress;
				this.ReplyTo[1] = Name;
			}
			public void SetReplyTo(String EmailAddress) throws Exception {
				this.ReplyTo[0] = EmailAddress;
				this.ReplyTo[1] = "";
			}
		//<-- End Method :: SetReplyTo
		
		//##################################################################################
		
		//--> Begin Method :: AddTo
			public void AddTo(String EmailAddress, String Name) throws Exception {
				this.To.add(new String[]{EmailAddress, Name});
			}
			public void AddTo(String EmailAddress) throws Exception {
				this.To.add(new String[]{EmailAddress, ""});
			}
		//<-- End Method :: AddTo
		
		//##################################################################################
		
		//--> Begin Method :: AddCC
			public void AddCC(String EmailAddress, String Name) throws Exception {
				this.CC.add(new String[]{EmailAddress, Name});
			}
			public void AddCC(String EmailAddress) throws Exception {
				this.CC.add(new String[]{EmailAddress, ""});
			}
		//<-- End Method :: AddCC
		
		//##################################################################################
		
		//--> Begin Method :: AddBCC
			public void AddBCC(String EmailAddress, String Name) throws Exception {
				this.BCC.add(new String[]{EmailAddress, Name});
			}
			public void AddBCC(String EmailAddress) {
				this.BCC.add(new String[]{EmailAddress, ""});
			}
		//<-- End Method :: AddBCC
		
		//##################################################################################
		
		//--> Begin Method :: AddHeader
			public void AddHeader(String Name, String Value) throws Exception {
				this.MIMEMessage.AddHeader(Name, Value);
			}
		//<-- End Method :: AddHeader
		
		//##################################################################################
		
		//--> Begin Method :: AttachFile
			public void AttachFile(String FilePath) throws Exception {
				this.Attachments.add(FilePath);
			}
		//<-- End Method :: AttachFile
		
		//##################################################################################
		
		//--> Begin Method :: CompileHeaders
			public void CompileHeaders() throws Exception {
				//add from header
				if(this.From[1].equals("")) {
					this.MIMEMessage.AddHeader("From", this.From[0]);
				}
				else {
					this.MIMEMessage.AddHeader("From", "\""+ this.From[1] +"\" <"+ this.From[0] +">");
				}
				
				//add reply to
				if(this.ReplyTo[0] == null || this.ReplyTo[0].equals("")) {
					//do nothing
				}
				else if(this.ReplyTo[0] != null && this.ReplyTo[1] == null) {
					this.MIMEMessage.AddHeader("ReplyTo", this.ReplyTo[0]);
				}
				else if(this.ReplyTo[0] != null && this.ReplyTo[1] != null) {
					this.MIMEMessage.AddHeader("ReplyTo", "\""+ this.ReplyTo[1] +"\" <"+ this.ReplyTo[0] +">");
				}
				
				//add subject
				this.MIMEMessage.AddHeader("Subject", this.Subject);
				
				//add to addresses
				String ToAddresses = "";
				for(int i = 0 ; i < this.To.size(); i++) {
					if(this.To.get(i)[1].equals("")) {
						ToAddresses += this.To.get(i)[0];
					}
					else {
						ToAddresses += "\""+ this.To.get(i)[1] +"\" <"+ this.To.get(i)[0] +">";
					}
					
					//add a comma? (,)
					if(i+1 != this.To.size()) ToAddresses += ", ";
				}
				if(!ToAddresses.equals("")) {
					this.MIMEMessage.AddHeader("To", ToAddresses);
				}
				
				//add cc addresses
				String CCAddresses = "";
				for(int i = 0 ; i < this.CC.size(); i++) {
					if(this.CC.get(i)[1].equals("")) {
						CCAddresses += this.CC.get(i)[0];
					}
					else {
						CCAddresses += "\""+ this.CC.get(i)[1] +"\" <"+ this.CC.get(i)[0] +">";
					}
					
					//add a comma? (,)
					if(i+1 != this.CC.size()) CCAddresses += ", ";
				}
				if(!CCAddresses.equals("")) {
					this.MIMEMessage.AddHeader("Cc", CCAddresses);
				}
				
				//add bcc addresses
				String BCCAddresses = "";
				for(int i = 0 ; i < this.BCC.size() ; i++) {
					if(this.BCC.get(i)[1].equals("")) {
						BCCAddresses += this.BCC.get(i)[0];
					}
					else {
						BCCAddresses += "\""+ this.BCC.get(i)[1] +"\" <"+ this.BCC.get(i)[0] +">";
					}
					
					//add a comma? (,)
					if(i+1 != this.BCC.size()) BCCAddresses += ", ";
				}
				if(!BCCAddresses.equals("")) {
					this.MIMEMessage.AddHeader("Bcc", BCCAddresses);
				}

				//add date - Date: Fri, 17 Jul 2009 02:36:44 -0700 (PDT)
				Calendar tmpCalendar = Calendar.getInstance();
				SimpleDateFormat tmpSimpleDateFormat = new SimpleDateFormat("EEE', 'dd' 'MMM' 'yyyy' 'HH:mm:ss' 'Z");
				this.MIMEMessage.AddHeader("Date", tmpSimpleDateFormat.format(tmpCalendar.getTime()));
				
				//add message-id
				this.MIMEMessage.AddHeader("Message-Id", "<"+ String.valueOf((new Random().nextInt())) +"@"+ this.Host +">");
				
				//add priority
				this.MIMEMessage.AddHeader("X-Priority", this.Priority);
				
				//add x-mailer
				this.MIMEMessage.AddHeader("X-Mailer", "WebLegs.SMTPClient (www.weblegs.org)");
				
				//add mime version
				this.MIMEMessage.AddHeader("MIME-Version", "1.0");
			}
		//<-- End Method :: CompileHeaders
		
		//##################################################################################
		
		//--> Begin Method :: CompileMessage
			public void CompileMessage() throws Exception {
				//setup our *empty* MIME objects for alternative message
				MIMEMessage AlternativeMessage;
				MIMEMessage HTMLMessage;
				MIMEMessage TextMessage;
				
				//create the main boundry for this message (not always used)
				String MainBoundary = "----=_Part_"+ String.valueOf((new Random().nextInt()));
				
				//lets figure out how to handle this message
				if(this.IsHTML == false && this.Attachments.size() == 0) {				
					//this is just a plain text message
					this.MIMEMessage.AddHeader("Content-Type", "text/plain;\n\tcharset=US-ASCII;");
					this.MIMEMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable");
					//put the content into the message body
					this.MIMEMessage.Body = this.Message;
				}
				else if(this.IsHTML == true && this.Attachments.size() == 0) {
					//this is an alternative html/text based message
					this.MIMEMessage.AddHeader("Content-Type", "multipart/alternative;\n\tboundary=\""+ MainBoundary +"\"");
					this.MIMEMessage.Preamble = "This is a multi-part message in MIME format.";
					
					//build the html part of this message
					HTMLMessage = new MIMEMessage();
					HTMLMessage.AddHeader("Content-Type", "text/html; charset=US-ASCII;");
					HTMLMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable");
					HTMLMessage.Body = this.Message;
					
					//build the text part of this message
					TextMessage = new MIMEMessage();
					TextMessage.AddHeader("Content-Type", "text/plain; charset=US-ASCII;");
					TextMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable");
					TextMessage.Body = this.HTMLToText(this.Message);
					
					//add text/html parts to the main message
					this.MIMEMessage.Parts.add(TextMessage);
					this.MIMEMessage.Parts.add(HTMLMessage);
				}
				else if(Attachments.size() != 0) {
					//this message is mixed
					this.MIMEMessage.AddHeader("Content-Type", "multipart/mixed;\n\tboundary=\""+ MainBoundary +"\"");
					this.MIMEMessage.Preamble = "This is a multi-part message in MIME format.";
					
					//is this an alternative message?
					if(this.IsHTML == true) {
						//create the alternative boundry for this message
						String AlternativeBoundary = "----=_Part_"+ String.valueOf((new Random().nextInt()));
						
						//build the Alternative part of this message
						AlternativeMessage = new MIMEMessage();
						AlternativeMessage.AddHeader("Content-Type", "multipart/alternative;\n\tboundary=\""+ AlternativeBoundary +"\"");
						
						//build the html part of this message
						HTMLMessage = new MIMEMessage();
						HTMLMessage.AddHeader("Content-Type", "text/html; charset=US-ASCII;");
						HTMLMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable");
						HTMLMessage.Body = this.Message;
						
						//build the text part of this message
						TextMessage = new MIMEMessage();
						TextMessage.AddHeader("Content-Type", "text/plain; charset=US-ASCII;");
						TextMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable");
						TextMessage.Body = this.HTMLToText(this.Message);
						
						//add html/text parts to the alternative message
						AlternativeMessage.Parts.add(TextMessage);
						AlternativeMessage.Parts.add(HTMLMessage);
						
						//add the alternative message to the main message
						this.MIMEMessage.Parts.add(AlternativeMessage);
					}
					else {
						//this is just a plain text message
						this.MIMEMessage.AddHeader("Content-Type", "text/plain;\n\tcharset=US-ASCII;");
						
						//put the content into the message body
						this.MIMEMessage.Body = this.Message;
					}
					
					//add attachments to the main message
					for(int i = 0 ; i < this.Attachments.size() ; i++) {
						
						//create input stream to read file
						InputStream MyInputStream = new FileInputStream(this.Attachments.get(i));
						
						//get file info
						File thisFileInfo = new File(this.Attachments.get(i));
						
						// Create the byte array to hold the data
						byte[] thisByteData = new byte[(int)thisFileInfo.length()];
						
						// Read in the bytes
						int ThisOffset = 0;
						int NumRead = 0;
						while(ThisOffset < thisByteData.length && ( NumRead = MyInputStream.read(thisByteData, ThisOffset, thisByteData.length - ThisOffset)) >= 0) {
							ThisOffset += NumRead;
						}
						
						// Close the input stream
						MyInputStream.close();
						
						//setup new MIME message for this attachment
						MIMEMessage AttachmentMessage = new MIMEMessage();
						AttachmentMessage.AddHeader("Content-Type", this.GetContentTypeByExtension(thisFileInfo.getName().substring(thisFileInfo.getName().lastIndexOf("."))) +";\n\tname=\""+ thisFileInfo.getName() +"\"");
						AttachmentMessage.AddHeader("Content-Transfer-Encoding", "base64");
						AttachmentMessage.AddHeader("Content-Disposition", "attachment;\n\tfilename=\""+ thisFileInfo.getName() +"\"");
						AttachmentMessage.FileBody = thisByteData;
						
						//add this attachment to the main message
						this.MIMEMessage.Parts.add(AttachmentMessage);
					}
				}
			}
		//<-- End Method :: CompileMessage
		
		//##################################################################################
		
		//--> Begin Method :: Send
			public void Send() throws Exception {
				//make sure host was supplied
				if(this.Host.equals("")) {
					throw new Exception("Weblegs.SMTPClient.Send(): No host specified.");
				}
				
				//assign credentials if username is supplied
				if(!this.Username.equals("")) {
					this.SMTPDriver.Username = this.Username;
					this.SMTPDriver.Password = this.Password;
				}
				
				//should we open the socket for them?
				if(!this.OpenedManually) {
					//setup the SMTPDriver
					this.SMTPDriver.Host = this.Host;
					this.SMTPDriver.Port = this.Port;
					this.SMTPDriver.Timeout = this.Timeout;
					this.SMTPDriver.Protocol = this.Protocol;
					
					//open up
					try {
						this.SMTPDriver.Open();
					}
					catch(Exception e) {
						throw new Exception("Weblegs.SMTPClient.Send(): Could not open connection. "+ e.toString());
					}
				}
				
				//set the from address
				this.SMTPDriver.SetFrom(this.From[0]);
				
				//add recipients
					//to addresses
					for(int i = 0 ; i < this.To.size() ; i++) {
						this.SMTPDriver.AddRecipient(this.To.get(i)[0]);
					}
					
					//cc addresses
					for(int i = 0 ; i < this.CC.size() ; i++) {
						this.SMTPDriver.AddRecipient(this.CC.get(i)[0]);
					}
					
					//bcc addresses
					for(int i = 0 ; i < this.BCC.size() ; i++) {
						this.SMTPDriver.AddRecipient(this.BCC.get(i)[0]);
					}
				//end add recipients
				
				//prepare headers
				this.CompileHeaders();
				
				//prepair message
				this.CompileMessage();
				
				//try sending
				try{
					this.SMTPDriver.Send(this.MIMEMessage.ToString());
				}
				catch(Exception e) {
					throw new Exception("Weblegs.SMTPClient.Send(): Failed to send message. "+ e.toString());
				}
				
				//should we close the socket for them?
				if(!this.OpenedManually) {
					this.Close();
					this.Reset();
				}
			}
		//<-- End Method :: Send
		
		//##################################################################################
		
		//--> Begin Method :: Reset
			public void Reset() throws Exception {
				this.From = new String[2];
				this.ReplyTo = new String[2];
				this.To = new ArrayList<String[]>();
				this.CC = new ArrayList<String[]>();
				this.BCC = new ArrayList<String[]>();
				this.Priority = "3";
				this.Subject = "";
				this.Message = "";
				this.IsHTML = false;
				this.Attachments = new ArrayList<String>();
				this.MIMEMessage = new MIMEMessage();
			}
		//<-- End Method :: Reset
		
		//##################################################################################
		
		//--> Begin Method :: GetContentTypeByExtension
			public String GetContentTypeByExtension(String Extension) throws Exception {
				if(this.ContentTypeList.contains(Extension)) {
					return this.ContentTypeList.get(Extension).toString();
				}
				else {
					return "application/x-unknown-content-type";
				}
			}
		//<-- End Method :: GetContentTypeByExtension
		
		//##################################################################################
			
		//--> Begin Method :: HTMLToText
			public String HTMLToText(String HTML) throws Exception {
				//keep copy of HTML
				String TextOnly = HTML;
				
				//trim it down
				TextOnly = TextOnly.trim();
				
				//make custom mods to HTML
					//seperators (80 chars on purpose)
					String HorizontalRule = "--------------------------------------------------------------------------------";
					String TableTopBottom = "********************************************************************************";
					
					//remove all line breaks
					TextOnly = TextOnly.replaceAll("\r", "");
					TextOnly = TextOnly.replaceAll("\n", "");
					
					//remove head
					TextOnly = TextOnly.replaceAll("<\\s*(head|HEAD).*?\\/(head|HEAD)>", "");
					
					//heading tags
					TextOnly = TextOnly.replaceAll("<\\/*(h|H)(1|2|3|4|5|6).*?>", "\n");
					
					//paragraph tags
					TextOnly = TextOnly.replaceAll("<(p|P).*?>", "\n\n");
					
					//div tags
					TextOnly = TextOnly.replaceAll("<(div|DIV).*?>", "\n\n");
					
					//br tags
					TextOnly = TextOnly.replaceAll("<(br|BR|bR|Br).*?>", "\n");
					
					//hr tags
					TextOnly = TextOnly.replaceAll("<(hr|HR|hR|Hr).*?>", "\n"+ HorizontalRule);
					
					//table tags
					TextOnly = TextOnly.replaceAll("<\\/*(table|TABLE).*?>", "\n"+ TableTopBottom);
					TextOnly = TextOnly.replaceAll("<(tr|TR|tR|Tr).*?>", "\n");
					TextOnly = TextOnly.replaceAll("<\\/(td|TD|tD|Td).*?>", "\t");
					
					//list tags
					TextOnly = TextOnly.replaceAll("<\\/*(ol|OL|oL|Ol).*?>", "\n");
					TextOnly = TextOnly.replaceAll("<\\/*(ul|UL|uL|Ul).*?>", "\n");
					TextOnly = TextOnly.replaceAll("<(li|LI|lI|Li).*?>", "\n\t(*) ");
					
					//lets not lose our links
					TextOnly = TextOnly.replaceAll("<a href=\"\"(.*?)\"\">(.*?)</a>", "$2 [$1]");
					TextOnly = TextOnly.replaceAll("<a HREF=\"\"(.*?)\"\">(.*?)</a>", "$2 [$1]");
					
					//strip the remaining HTML out
					TextOnly = TextOnly.replaceAll("<(.|\n)*?>", "");
					
					//loop over each line and truncate lines more than 74 characters
					String tmpFixedText = "";
					String[] TextOnlyLines = TextOnly.split("\n");
					for(int i = 0 ; i < TextOnlyLines.length ; i++) {
						String tmpThisFixedLine = "";
						if(TextOnlyLines[i].length() > 74) {
							while(TextOnlyLines[i].length() > 74) {
								//find the next space character furthest to the end (or the 74th character)
								if(TextOnlyLines[i].substring(0, 73).lastIndexOf(" ") > -1) {
									tmpThisFixedLine += TextOnlyLines[i].substring(0, TextOnlyLines[i].substring(0, 73).lastIndexOf(" ")) +"\n";
									//remove from TextOnlyLines[i]
									TextOnlyLines[i] = TextOnlyLines[i].substring(TextOnlyLines[i].substring(0, 73).lastIndexOf(" ")).trim();
								}
								else {
									//if there is a space in this line after the 74th character lets break at the first chance we get and continue
									if(TextOnlyLines[i].indexOf(" ") > -1) {
										tmpThisFixedLine += TextOnlyLines[i].substring(0, TextOnlyLines[i].indexOf(" ")+1) +"\n";
										TextOnlyLines[i] = TextOnlyLines[i].substring(TextOnlyLines[i].indexOf(" ")+1);
									}
									else {
										//this is a long line w/ no breaking potential
										tmpThisFixedLine += TextOnlyLines[i];
										TextOnlyLines[i] = "";
									}
								}
							}
							//if there is still content in TextOnlyLines[i] ... append it w/ a new line
							if(TextOnlyLines[i].length() > 0) {
								tmpThisFixedLine += TextOnlyLines[i];
							}
						}
						else {
							tmpThisFixedLine = TextOnlyLines[i];
						}
						tmpThisFixedLine += "\n";
						tmpFixedText += tmpThisFixedLine;
					}
					TextOnly = tmpFixedText;
				//end make custom mods to HTML
				return TextOnly;
			}
		//<-- End Method :: HTMLToText
			
		//##################################################################################
		
		//--> Begin Method :: BuildContentTypeList
			public Hashtable BuildContentTypeList() throws Exception {
				Hashtable tmpContentTypeList = new Hashtable();
				tmpContentTypeList.put("hqx", "application/mac-binhex40");
				tmpContentTypeList.put("cpt", "application/mac-compactpro");
				tmpContentTypeList.put("doc", "application/msword");
				tmpContentTypeList.put("bin", "application/macbinary");
				tmpContentTypeList.put("dms", "application/octet-stream");
				tmpContentTypeList.put("lha", "application/octet-stream");
				tmpContentTypeList.put("lzh", "application/octet-stream");
				tmpContentTypeList.put("exe", "application/octet-stream");
				tmpContentTypeList.put("class", "application/octet-stream");
				tmpContentTypeList.put("psd", "application/octet-stream");
				tmpContentTypeList.put("so", "application/octet-stream");
				tmpContentTypeList.put("sea", "application/octet-stream");
				tmpContentTypeList.put("dll", "application/octet-stream");
				tmpContentTypeList.put("oda", "application/oda");
				tmpContentTypeList.put("pdf", "application/pdf");
				tmpContentTypeList.put("ai", "application/postscript");
				tmpContentTypeList.put("eps", "application/postscript");
				tmpContentTypeList.put("ps", "application/postscript");
				tmpContentTypeList.put("smi", "application/smil");
				tmpContentTypeList.put("smil", "application/smil");
				tmpContentTypeList.put("mif", "application/vnd.mif");
				tmpContentTypeList.put("xls", "application/vnd.ms-excel");
				tmpContentTypeList.put("ppt", "application/vnd.ms-powerpoint");
				tmpContentTypeList.put("wbxml", "application/vnd.wap.wbxml");
				tmpContentTypeList.put("wmlc", "application/vnd.wap.wmlc");
				tmpContentTypeList.put("dcr", "application/x-director");
				tmpContentTypeList.put("dir", "application/x-director");
				tmpContentTypeList.put("dxr", "application/x-director");
				tmpContentTypeList.put("dvi", "application/x-dvi");
				tmpContentTypeList.put("gtar", "application/x-gtar");
				tmpContentTypeList.put("php", "application/x-httpd-php");
				tmpContentTypeList.put("php4", "application/x-httpd-php");
				tmpContentTypeList.put("php3", "application/x-httpd-php");
				tmpContentTypeList.put("phtml", "application/x-httpd-php");
				tmpContentTypeList.put("phps", "application/x-httpd-php-source");
				tmpContentTypeList.put("js", "application/x-javascript");
				tmpContentTypeList.put("swf", "application/x-shockwave-flash");
				tmpContentTypeList.put("sit", "application/x-stuffit");
				tmpContentTypeList.put("tar", "application/x-tar");
				tmpContentTypeList.put("tgz", "application/x-tar");
				tmpContentTypeList.put("xhtml", "application/xhtml+xml");
				tmpContentTypeList.put("xht", "application/xhtml+xml");
				tmpContentTypeList.put("zip", "application/zip");
				tmpContentTypeList.put("data-id", "audio/midi");
				tmpContentTypeList.put("midi", "audio/midi");
				tmpContentTypeList.put("mpga", "audio/mpeg");
				tmpContentTypeList.put("mp2", "audio/mpeg");
				tmpContentTypeList.put("mp3", "audio/mpeg");
				tmpContentTypeList.put("aif", "audio/x-aiff");
				tmpContentTypeList.put("aiff", "audio/x-aiff");
				tmpContentTypeList.put("aifc", "audio/x-aiff");
				tmpContentTypeList.put("ram", "audio/x-pn-realaudio");
				tmpContentTypeList.put("rm", "audio/x-pn-realaudio");
				tmpContentTypeList.put("rpm", "audio/x-pn-realaudio-plugin");
				tmpContentTypeList.put("ra", "audio/x-realaudio");
				tmpContentTypeList.put("rv", "video/vnd.rn-realvideo");
				tmpContentTypeList.put("wav", "audio/x-wav");
				tmpContentTypeList.put("bmp", "image/bmp");
				tmpContentTypeList.put("gif", "image/gif");
				tmpContentTypeList.put("jpeg", "image/jpeg");
				tmpContentTypeList.put("jpg", "image/jpeg");
				tmpContentTypeList.put("jpe", "image/jpeg");
				tmpContentTypeList.put("png", "image/png");
				tmpContentTypeList.put("tiff", "image/tiff");
				tmpContentTypeList.put("tif", "image/tiff");
				tmpContentTypeList.put("css", "text/css");
				tmpContentTypeList.put("html", "text/html");
				tmpContentTypeList.put("htm", "text/html");
				tmpContentTypeList.put("shtml", "text/html");
				tmpContentTypeList.put("txt", "text/plain");
				tmpContentTypeList.put("text", "text/plain");
				tmpContentTypeList.put("log", "text/plain");
				tmpContentTypeList.put("rtx", "text/richtext");
				tmpContentTypeList.put("rtf", "text/rtf");
				tmpContentTypeList.put("xml", "text/xml");
				tmpContentTypeList.put("xsl", "text/xml");
				tmpContentTypeList.put("mpeg", "video/mpeg");
				tmpContentTypeList.put("mpg", "video/mpeg");
				tmpContentTypeList.put("mpe", "video/mpeg");
				tmpContentTypeList.put("qt", "video/quicktime");
				tmpContentTypeList.put("mov", "video/quicktime");
				tmpContentTypeList.put("avi", "video/x-msvideo");
				tmpContentTypeList.put("movie", "video/x-sgi-movie");
				tmpContentTypeList.put("word", "application/msword");
				tmpContentTypeList.put("xl", "application/excel");
				tmpContentTypeList.put("eml", "message/rfc822");
				return tmpContentTypeList;
			}
		//<-- End Method :: BuildContentTypeList
	}
//<-- End Class :: SMTPClient

//##########################################################################################
%>