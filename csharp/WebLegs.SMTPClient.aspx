<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
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

//--> Begin Class :: SMTPClient
	public class SMTPClient {
		//--> Begin :: Properties
			public string[] From; //[address,name]
			public string[] ReplyTo; //[address,name]
			public List<string[]> To;
			public List<string[]> CC;
			public List<string[]> BCC;
			public string Priority;
			public string Subject;
			public string Message;
			public bool IsHTML;
			public List<string> Attachments;
			public string Host;
			public int Port;
			public string Protocol;
			public int Timeout;
			public string Username;
			public string Password;
			public SMTPDriver SMTPDriver;
			public MIMEMessage MIMEMessage;
			public Hashtable ContentTypeList;
			public bool OpenedManually;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public SMTPClient() {
				this.From = new string[2];
				this.ReplyTo = new string[2];
				this.To = new List<string[]>();
				this.CC = new List<string[]>();
				this.BCC = new List<string[]>();
				this.Priority = "3";
				this.Subject = "";
				this.Message = "";
				this.IsHTML = false;
				this.Attachments = new List<string>();
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
			public void Open() {
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
					throw new Exception("Weblegs.SMTPClient.Open(): Failed to open connection. "+ e.ToString());
				}
			}
		//<-- End Method :: Open
		
		//##################################################################################
		
		//--> Begin Method :: Close
			public void Close() {
				try {
					this.SMTPDriver.Close();
				}
				catch(Exception e) {
					throw new Exception("Weblegs.SMTPClient.Close(): Failed to close connection. "+ e.ToString());
				}
			}
		//<-- End Method :: Close
		
		//##################################################################################
		
		//--> Begin Method :: SetFrom
			public void SetFrom(string EmailAddress, string Name) {
				this.From[0] = EmailAddress;
				this.From[1] = Name;
			}
			public void SetFrom(string EmailAddress) {
				this.From[0] = EmailAddress;
				this.From[1] = "";
			}
		//<-- End Method :: SetFrom
		
		//##################################################################################
		
		//--> Begin Method :: SetReplyTo
			public void SetReplyTo(string EmailAddress, string Name) {
				this.ReplyTo[0] = EmailAddress;
				this.ReplyTo[1] = Name;
			}
			public void SetReplyTo(string EmailAddress) {
				this.ReplyTo[0] = EmailAddress;
				this.ReplyTo[1] = "";
			}
		//<-- End Method :: SetReplyTo
		
		//##################################################################################
		
		//--> Begin Method :: AddTo
			public void AddTo(string EmailAddress, string Name) {
				this.To.Add(new string[]{EmailAddress, Name});
			}
			public void AddTo(string EmailAddress) {
				this.To.Add(new string[]{EmailAddress, ""});
			}
		//<-- End Method :: AddTo
		
		//##################################################################################
		
		//--> Begin Method :: AddCC
			public void AddCC(string EmailAddress, string Name) {
				this.CC.Add(new string[]{EmailAddress, Name});
			}
			public void AddCC(string EmailAddress) {
				this.CC.Add(new string[]{EmailAddress, ""});
			}
		//<-- End Method :: AddCC
		
		//##################################################################################
		
		//--> Begin Method :: AddBCC
			public void AddBCC(string EmailAddress, string Name) {
				this.BCC.Add(new string[]{EmailAddress, Name});
			}
			public void AddBCC(string EmailAddress) {
				this.BCC.Add(new string[]{EmailAddress, ""});
			}
		//<-- End Method :: AddBCC
		
		//##################################################################################
		
		//--> Begin Method :: AddHeader
			public void AddHeader(string Name, string Value) {
				this.MIMEMessage.AddHeader(Name, Value);
			}
		//<-- End Method :: AddHeader
		
		//##################################################################################
		
		//--> Begin Method :: AttachFile
			public void AttachFile(string FilePath) {
				this.Attachments.Add(FilePath);
			}
		//<-- End Method :: AttachFile
		
		//##################################################################################
		
		//--> Begin Method :: CompileHeaders
			public void CompileHeaders() {
				//add from header
				if(this.From[1] == "") {
					this.MIMEMessage.AddHeader("From", this.From[0]);
				}
				else {
					this.MIMEMessage.AddHeader("From", "\""+ this.From[1] +"\" <"+ this.From[0] +">");
				}
				
				//add reply to
				if(this.ReplyTo[0] == "" || this.ReplyTo[0] == null) {
					//do nothing
				}
				else if(this.ReplyTo[0] != "" && this.ReplyTo[1] == "") {
					this.MIMEMessage.AddHeader("ReplyTo", this.ReplyTo[0]);
				}
				else if(this.ReplyTo[0] != "" && this.ReplyTo[1] != "") {
					this.MIMEMessage.AddHeader("ReplyTo", "\""+ this.ReplyTo[1] +"\" <"+ this.ReplyTo[0] +">");
				}
				
				//add subject
				this.MIMEMessage.AddHeader("Subject", this.Subject);
				
				//add to addresses
				string ToAddresses = "";
				for(int i = 0 ; i < this.To.Count ; i++) {
					if(this.To[i][1] == "") {
						ToAddresses += this.To[i][0];
					}
					else {
						ToAddresses += "\""+ this.To[i][1] +"\" <"+ this.To[i][0] +">";
					}
					
					//add a comma? (,)
					if(i+1 != this.To.Count) ToAddresses += ", ";
				}
				if(ToAddresses != "") {
					this.MIMEMessage.AddHeader("To", ToAddresses);
				}
				
				//add cc addresses
				string CCAddresses = "";
				for(int i = 0 ; i < this.CC.Count ; i++) {
					if(this.CC[i][1] == "") {
						CCAddresses += this.CC[i][0];
					}
					else {
						CCAddresses += "\""+ this.CC[i][1] +"\" <"+ this.CC[i][0] +">";
					}
					
					//add a comma? (,)
					if(i+1 != this.CC.Count) CCAddresses += ", ";
				}
				if(CCAddresses != "") {
					this.MIMEMessage.AddHeader("Cc", CCAddresses);
				}
				
				//add bcc addresses
				string BCCAddresses = "";
				for(int i = 0 ; i < this.BCC.Count ; i++) {
					if(this.BCC[i][1] == "") {
						BCCAddresses += this.BCC[i][0];
					}
					else {
						BCCAddresses += "\""+ this.BCC[i][1] +"\" <"+ this.BCC[i][0] +">";
					}
					
					//add a comma? (,)
					if(i+1 != this.BCC.Count) BCCAddresses += ", ";
				}
				if(BCCAddresses != "") {
					this.MIMEMessage.AddHeader("Bcc", BCCAddresses);
				}
				
				//add date
				this.MIMEMessage.AddHeader("Date", DateTime.Now.ToString("R"));
				
				//add message-id
				this.MIMEMessage.AddHeader("Message-Id", "<"+ System.Guid.NewGuid().ToString("N") +"@"+ this.Host +">");
				
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
			public void CompileMessage() {
				//setup our *empty* MIME objects for alternative message
				MIMEMessage AlternativeMessage;
				MIMEMessage HTMLMessage;
				MIMEMessage TextMessage;
				
				//create the main boundry for this message (not always used)
				string MainBoundary = "----=_Part_"+ System.Guid.NewGuid().ToString();
				
				//lets figure out how to handle this message
				if(this.IsHTML == false && this.Attachments.Count == 0) {
					//this is just a plain text message
					this.MIMEMessage.AddHeader("Content-Type", "text/plain;\n\tcharset=US-ASCII;");
					this.MIMEMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable");
					//put the content into the message body
					this.MIMEMessage.Body = this.Message;
				}
				else if(this.IsHTML == true && this.Attachments.Count == 0) {
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
					TextMessage.Body = this.HTMLToText(ref this.Message);
					
					//add text/html parts to the main message
					this.MIMEMessage.Parts.Add(TextMessage);
					this.MIMEMessage.Parts.Add(HTMLMessage);
				}
				else if(Attachments.Count != 0) {
					//this message is mixed
					this.MIMEMessage.AddHeader("Content-Type", "multipart/mixed;\n\tboundary=\""+ MainBoundary +"\"");
					this.MIMEMessage.Preamble = "This is a multi-part message in MIME format.";
					
					//is this an alternative message?
					if(this.IsHTML == true) {
						//create the alternative boundry for this message
						string AlternativeBoundary = "----=_Part_"+ System.Guid.NewGuid().ToString();
						
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
						TextMessage.Body = this.HTMLToText(ref this.Message);
						
						//add html/text parts to the alternative message
						AlternativeMessage.Parts.Add(TextMessage);
						AlternativeMessage.Parts.Add(HTMLMessage);
						
						//add the alternative message to the main message
						this.MIMEMessage.Parts.Add(AlternativeMessage);
					}
					else {
						//build a plain text message message
						TextMessage = new MIMEMessage();
						TextMessage.AddHeader("Content-Type", "text/plain; charset=US-ASCII;");
						TextMessage.AddHeader("Content-Transfer-Encoding", "quoted-printable");
						TextMessage.Body = this.Message;
						
						//add the PlainTextMessage to the main message
						this.MIMEMessage.Parts.Add(TextMessage);
					}
					
					//add attachments to the main message
					for(int i = 0 ; i < this.Attachments.Count ; i++) {
						//get file info
						FileInfo thisFileInfo = new FileInfo(this.Attachments[i]);
						
						//convert file into bytes
						FileStream thisFileStream = new FileStream(this.Attachments[i], FileMode.Open, FileAccess.Read);
						BinaryReader thisBinaryReader = new BinaryReader(thisFileStream);
						byte[] thisByteData = thisBinaryReader.ReadBytes((int)thisFileInfo.Length);
						thisBinaryReader.Close();
						thisFileStream.Close();
						
						//setup new MIME message for this attachment
						MIMEMessage AttachmentMessage = new MIMEMessage();
						AttachmentMessage.AddHeader("Content-Type", this.GetContentTypeByExtension(thisFileInfo.Extension) +";\n\tname=\""+ thisFileInfo.Name +"\"");
						AttachmentMessage.AddHeader("Content-Transfer-Encoding", "base64");
						AttachmentMessage.AddHeader("Content-Disposition", "attachment;\n\tfilename=\""+ thisFileInfo.Name +"\"");
						AttachmentMessage.FileBody = thisByteData;
						
						//add this attachment to the main message
						this.MIMEMessage.Parts.Add(AttachmentMessage);
					}
				}
			}
		//<-- End Method :: CompileMessage
		
		//##################################################################################
		
		//--> Begin Method :: Send
			public void Send() {
				//make sure host was supplied
				if(this.Host == "") {
					throw new Exception("Weblegs.SMTPClient.Send(): No host specified.");
				}
				
				//assign credentials if username is supplied
				if(this.Username != "") {
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
						throw new Exception("Weblegs.SMTPClient.Send(): Could not open connection. "+ e.ToString());
					}
				}
				
				//set the from address
				this.SMTPDriver.SetFrom(this.From[0]);
				
				//add recipients
					//to addresses
					for(int i = 0 ; i < this.To.Count ; i++) {
						this.SMTPDriver.AddRecipient(this.To[i][0]);
					}
					
					//cc addresses
					for(int i = 0 ; i < this.CC.Count ; i++) {
						this.SMTPDriver.AddRecipient(this.CC[i][0]);
					}
					
					//bcc addresses
					for(int i = 0 ; i < this.BCC.Count ; i++) {
						this.SMTPDriver.AddRecipient(this.BCC[i][0]);
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
					throw new Exception("Weblegs.SMTPClient.Send(): Failed to send message. "+ e.ToString());
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
			public void Reset() {
				this.From = new string[2];
				this.ReplyTo = new string[2];
				this.To = new List<string[]>();
				this.CC = new List<string[]>();
				this.BCC = new List<string[]>();
				this.Priority = "3";
				this.Subject = "";
				this.Message = "";
				this.IsHTML = false;
				this.Attachments = new List<string>();
				this.MIMEMessage = new MIMEMessage();
			}
		//<-- End Method :: Reset
		
		//##################################################################################
		
		//--> Begin Method :: GetContentTypeByExtension
			public string GetContentTypeByExtension(string Extension) {
				if(this.ContentTypeList.Contains(Extension)) {
					return this.ContentTypeList[Extension].ToString();
				}
				else {
					return "application/x-unknown-content-type";
				}
			}
		//<-- End Method :: GetContentTypeByExtension
		
		//##################################################################################
			
		//--> Begin Method :: HTMLToText
			public string HTMLToText(ref string HTML) {
				//keep copy of HTML
				string TextOnly = HTML;
				
				//trim it down
				TextOnly = TextOnly.Trim();
				
				//make custom mods to HTML
					//seperators (80 chars on purpose)
					string HorizontalRule = "--------------------------------------------------------------------------------";
					string TableTopBottom = "********************************************************************************";
					
					//remove all line breaks
					TextOnly = Regex.Replace(TextOnly, @"\r", "");
					TextOnly = Regex.Replace(TextOnly, @"\n", "");
					
					//remove head
					TextOnly = Regex.Replace(TextOnly, @"<\s*(head|HEAD).*?\/(head|HEAD)>", "");
					
					//heading tags
					TextOnly = Regex.Replace(TextOnly, @"<\/*(h|H)(1|2|3|4|5|6).*?>", "\n");
					
					//paragraph tags
					TextOnly = Regex.Replace(TextOnly, @"<(p|P).*?>", "\n\n");
					
					//div tags
					TextOnly = Regex.Replace(TextOnly, @"<(div|DIV).*?>", "\n\n");
					
					//br tags
					TextOnly = Regex.Replace(TextOnly, @"<(br|BR|bR|Br).*?>", "\n");
					
					//hr tags
					TextOnly = Regex.Replace(TextOnly, @"<(hr|HR|hR|Hr).*?>", "\n"+ HorizontalRule);
					
					//table tags
					TextOnly = Regex.Replace(TextOnly, @"<\/*(table|TABLE).*?>", "\n"+ TableTopBottom);
					TextOnly = Regex.Replace(TextOnly, @"<(tr|TR|tR|Tr).*?>", "\n");
					TextOnly = Regex.Replace(TextOnly, @"<\/(td|TD|tD|Td).*?>", "\t");
					
					//list tags
					TextOnly = Regex.Replace(TextOnly, @"<\/*(ol|OL|oL|Ol).*?>", "\n");
					TextOnly = Regex.Replace(TextOnly, @"<\/*(ul|UL|uL|Ul).*?>", "\n");
					TextOnly = Regex.Replace(TextOnly, @"<(li|LI|lI|Li).*?>", "\n\t(*) ");
					
					//lets not lose our links
					TextOnly = Regex.Replace(TextOnly, @"<a href=""(.*?)"">(.*?)</a>", @"$2 [$1]");
					TextOnly = Regex.Replace(TextOnly, @"<a HREF=""(.*?)"">(.*?)</a>", @"$2 [$1]");
					
					//strip the remaining HTML out
					TextOnly = Regex.Replace(TextOnly, @"<(.|\n)*?>", "");
					
					//loop over each line and truncate lines more than 74 characters
					string tmpFixedText = "";
					string[] TextOnlyLines = Regex.Split(TextOnly, "\n");
					for(int i = 0 ; i < TextOnlyLines.Length ; i++) {
						string tmpThisFixedLine = "";
						if(TextOnlyLines[i].Length > 74) {
							while(TextOnlyLines[i].Length > 74) {
								//find the next space character furthest to the end (or the 74th character)
								if(TextOnlyLines[i].Substring(0, 73).LastIndexOf(" ") > -1) {
									tmpThisFixedLine += TextOnlyLines[i].Substring(0, TextOnlyLines[i].Substring(0, 73).LastIndexOf(" ")) +"\n";
									//remove from TextOnlyLines[i]
									TextOnlyLines[i] = TextOnlyLines[i].Substring(TextOnlyLines[i].Substring(0, 73).LastIndexOf(" ")).Trim();
								}
								else {
									//if there is a space in this line after the 74th character lets break at the first chance we get and continue
									if(TextOnlyLines[i].IndexOf(" ") > -1) {
										tmpThisFixedLine += TextOnlyLines[i].Substring(0, TextOnlyLines[i].IndexOf(" ")+1) +"\n";
										TextOnlyLines[i] = TextOnlyLines[i].Substring(TextOnlyLines[i].IndexOf(" ")+1);
									}
									else {
										//this is a long line w/ no breaking potential
										tmpThisFixedLine += TextOnlyLines[i];
										TextOnlyLines[i] = "";
									}
								}
							}
							//if there is still content in TextOnlyLines[i] ... append it w/ a new line
							if(TextOnlyLines[i].Length > 0) {
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
			public Hashtable BuildContentTypeList() {
				Hashtable tmpContentTypeList = new Hashtable();
				tmpContentTypeList.Add("hqx", "application/mac-binhex40");
				tmpContentTypeList.Add("cpt", "application/mac-compactpro");
				tmpContentTypeList.Add("doc", "application/msword");
				tmpContentTypeList.Add("bin", "application/macbinary");
				tmpContentTypeList.Add("dms", "application/octet-stream");
				tmpContentTypeList.Add("lha", "application/octet-stream");
				tmpContentTypeList.Add("lzh", "application/octet-stream");
				tmpContentTypeList.Add("exe", "application/octet-stream");
				tmpContentTypeList.Add("class", "application/octet-stream");
				tmpContentTypeList.Add("psd", "application/octet-stream");
				tmpContentTypeList.Add("so", "application/octet-stream");
				tmpContentTypeList.Add("sea", "application/octet-stream");
				tmpContentTypeList.Add("dll", "application/octet-stream");
				tmpContentTypeList.Add("oda", "application/oda");
				tmpContentTypeList.Add("pdf", "application/pdf");
				tmpContentTypeList.Add("ai", "application/postscript");
				tmpContentTypeList.Add("eps", "application/postscript");
				tmpContentTypeList.Add("ps", "application/postscript");
				tmpContentTypeList.Add("smi", "application/smil");
				tmpContentTypeList.Add("smil", "application/smil");
				tmpContentTypeList.Add("mif", "application/vnd.mif");
				tmpContentTypeList.Add("xls", "application/vnd.ms-excel");
				tmpContentTypeList.Add("ppt", "application/vnd.ms-powerpoint");
				tmpContentTypeList.Add("wbxml", "application/vnd.wap.wbxml");
				tmpContentTypeList.Add("wmlc", "application/vnd.wap.wmlc");
				tmpContentTypeList.Add("dcr", "application/x-director");
				tmpContentTypeList.Add("dir", "application/x-director");
				tmpContentTypeList.Add("dxr", "application/x-director");
				tmpContentTypeList.Add("dvi", "application/x-dvi");
				tmpContentTypeList.Add("gtar", "application/x-gtar");
				tmpContentTypeList.Add("php", "application/x-httpd-php");
				tmpContentTypeList.Add("php4", "application/x-httpd-php");
				tmpContentTypeList.Add("php3", "application/x-httpd-php");
				tmpContentTypeList.Add("phtml", "application/x-httpd-php");
				tmpContentTypeList.Add("phps", "application/x-httpd-php-source");
				tmpContentTypeList.Add("js", "application/x-javascript");
				tmpContentTypeList.Add("swf", "application/x-shockwave-flash");
				tmpContentTypeList.Add("sit", "application/x-stuffit");
				tmpContentTypeList.Add("tar", "application/x-tar");
				tmpContentTypeList.Add("tgz", "application/x-tar");
				tmpContentTypeList.Add("xhtml", "application/xhtml+xml");
				tmpContentTypeList.Add("xht", "application/xhtml+xml");
				tmpContentTypeList.Add("zip", "application/zip");
				tmpContentTypeList.Add("data-id", "audio/midi");
				tmpContentTypeList.Add("midi", "audio/midi");
				tmpContentTypeList.Add("mpga", "audio/mpeg");
				tmpContentTypeList.Add("mp2", "audio/mpeg");
				tmpContentTypeList.Add("mp3", "audio/mpeg");
				tmpContentTypeList.Add("aif", "audio/x-aiff");
				tmpContentTypeList.Add("aiff", "audio/x-aiff");
				tmpContentTypeList.Add("aifc", "audio/x-aiff");
				tmpContentTypeList.Add("ram", "audio/x-pn-realaudio");
				tmpContentTypeList.Add("rm", "audio/x-pn-realaudio");
				tmpContentTypeList.Add("rpm", "audio/x-pn-realaudio-plugin");
				tmpContentTypeList.Add("ra", "audio/x-realaudio");
				tmpContentTypeList.Add("rv", "video/vnd.rn-realvideo");
				tmpContentTypeList.Add("wav", "audio/x-wav");
				tmpContentTypeList.Add("bmp", "image/bmp");
				tmpContentTypeList.Add("gif", "image/gif");
				tmpContentTypeList.Add("jpeg", "image/jpeg");
				tmpContentTypeList.Add("jpg", "image/jpeg");
				tmpContentTypeList.Add("jpe", "image/jpeg");
				tmpContentTypeList.Add("png", "image/png");
				tmpContentTypeList.Add("tiff", "image/tiff");
				tmpContentTypeList.Add("tif", "image/tiff");
				tmpContentTypeList.Add("css", "text/css");
				tmpContentTypeList.Add("html", "text/html");
				tmpContentTypeList.Add("htm", "text/html");
				tmpContentTypeList.Add("shtml", "text/html");
				tmpContentTypeList.Add("txt", "text/plain");
				tmpContentTypeList.Add("text", "text/plain");
				tmpContentTypeList.Add("log", "text/plain");
				tmpContentTypeList.Add("rtx", "text/richtext");
				tmpContentTypeList.Add("rtf", "text/rtf");
				tmpContentTypeList.Add("xml", "text/xml");
				tmpContentTypeList.Add("xsl", "text/xml");
				tmpContentTypeList.Add("mpeg", "video/mpeg");
				tmpContentTypeList.Add("mpg", "video/mpeg");
				tmpContentTypeList.Add("mpe", "video/mpeg");
				tmpContentTypeList.Add("qt", "video/quicktime");
				tmpContentTypeList.Add("mov", "video/quicktime");
				tmpContentTypeList.Add("avi", "video/x-msvideo");
				tmpContentTypeList.Add("movie", "video/x-sgi-movie");
				tmpContentTypeList.Add("word", "application/msword");
				tmpContentTypeList.Add("xl", "application/excel");
				tmpContentTypeList.Add("eml", "message/rfc822");
				return tmpContentTypeList;
			}
		//<-- End Method :: BuildContentTypeList
	}
//<-- End Class :: SMTPClient

//##########################################################################################
</script>