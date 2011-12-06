<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<%@ Import Namespace="System.Xml.XPath" %>
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

//--> Begin Class :: MIMEMessage
	public class MIMEMessage {
		//--> Begin :: Properties
			public List<string[]> Headers;
			public string Preamble;
			public string Body;
			public byte[] FileBody;
			public List<MIMEMessage> Parts;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public MIMEMessage() {
				this.Headers = new List<string[]>();
				this.Preamble = "";
				this.Body = "";
				this.Parts = new List<MIMEMessage>();
			}
			public MIMEMessage(ref string Data) {
				this.Headers = new List<string[]>();
				this.Preamble = "";
				this.Body = "";
				this.Parts = new List<MIMEMessage>();
				this.Parse(ref Data);
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Parse
			public void Parse(ref string Data) {
				Data = Data.Replace("\r\n", "\n");
				Data = Data.Replace("\r", "\n");
				//parse the entire message
				Match myMatch = Regex.Match(Data, "(.*?)\n\n(.*)", RegexOptions.IgnoreCase | RegexOptions.Singleline);
				string tmpHeaders = myMatch.Groups[1].Value;
				string tmpBody = myMatch.Groups[2].Value;
				this.ParseHeaders(ref tmpHeaders);
				this.ParseBody(ref tmpBody, true);
			}
		//<-- End Method :: Parse
		
		//##################################################################################
		
		//--> Begin Method :: ParseHeaders
			public void ParseHeaders(ref string Data) {
				//parse raw headers into the properties
				string myPattern = @"(?<=\n|^)(\S*?): (.*?)(?=\n\S*?: |$)";
				MatchCollection myCollection = Regex.Matches(Data, myPattern, RegexOptions.IgnoreCase | RegexOptions.Singleline);
				for(int i = 0 ; i < myCollection.Count ; i++) {
					Match myMatch = myCollection[i];
					this.AddHeader(myMatch.Groups[1].Value, Regex.Replace(myMatch.Groups[2].Value, @"\s+", " "));
				}
			}
		//<-- End Method :: ParseHeaders
		
		//##################################################################################
		
		//--> Begin Method :: ParseBody
			public void ParseBody(ref string Data, bool Decode) {
				//parse just the message body
				switch(this.GetMediaType().ToLower()) {
					case "application":
						//check for encoding
						if(this.GetContentTransferEncoding().IndexOf("base64") > -1) {
							if(Decode) {
								this.Body = Data;
								this.FileBody = Codec.Base64DecodeBytes(Data);
							}
							else {
								this.Body = Codec.Base64Encode(this.FileBody);
							}
						}
						break;
						//- - - - - - - - - - - - - - - - - -//
					case "audio":
						//check for encoding
						if(this.GetContentTransferEncoding().IndexOf("base64") > -1) {
							if(Decode) {
								this.Body = Data;
								this.FileBody = Codec.Base64DecodeBytes(Data);
							}
							else {
								this.Body = Codec.Base64Encode(this.FileBody);
							}
						}
						break;
						//- - - - - - - - - - - - - - - - - -//
					case "image":
						//check for encoding
						if(this.GetContentTransferEncoding().IndexOf("base64") > -1) {
							if(Decode) {
								this.Body = Data;
								this.FileBody = Codec.Base64DecodeBytes(Data);
							}
							else {
								this.Body = Codec.Base64Encode(this.FileBody);
							}
						}
						break;
						//- - - - - - - - - - - - - - - - - -//
					case "message":
						switch(this.GetMediaSubType().ToLower()) {
							case "rfc822":
								//make the first part of this message
								//the parsed message
								this.Parts.Add(new MIMEMessage(ref Data));
								break;
							default:
								//do nothing
								break;
						}
						break;
						//- - - - - - - - - - - - - - - - - -//
					case "model":
						//not implemented
						break;
						//- - - - - - - - - - - - - - - - - -//
					case "multipart":
							//the boundry is required for multipart messages
							string MultiPartBoundry = this.GetMediaBoundary();
							
							//find the preamble
							Match myPreableMatch = Regex.Match(Data, "(.*?)--"+ MultiPartBoundry,  RegexOptions.IgnoreCase | RegexOptions.Singleline);
							this.Preamble = myPreableMatch.Groups[1].Value.ToString();
							
							//get each part of the message
							string myPattern = "--"+ MultiPartBoundry +"(.*?)(?=--"+ MultiPartBoundry +")";
							MatchCollection myPartCollection = Regex.Matches(Data, myPattern, RegexOptions.IgnoreCase | RegexOptions.Singleline);
							for(int i =  0 ; i < myPartCollection.Count ; i++) {
								string tmpPart = myPartCollection[i].Groups[1].Value;
								this.Parts.Add(new MIMEMessage(ref tmpPart));
							}
							break;
							//- - - - - - - - - - - - - - - - - -//
						case "text":
							//check for encoding
						if(this.GetContentTransferEncoding().IndexOf("base64") > -1) {
							if(Decode) {
								this.Body = Codec.Base64Decode(Data);
							}
							else {
								this.Body = Codec.Base64Encode(Data);
							}
						}
						else if(this.GetContentTransferEncoding().IndexOf("quoted-printable") > -1) {
							if(Decode) {
								this.Body = Codec.QuotedPrintableDecode(Data);
							}
							else {
								this.Body = Codec.QuotedPrintableEncode(Data);
							}
						}
						else {
							this.Body = Data;
						}
						break;
						//- - - - - - - - - - - - - - - - - -//
					case "video":
						//check for encoding
						if(this.GetContentTransferEncoding().IndexOf("base64") > -1) {
							if(Decode) {
								this.Body = Data;
								this.FileBody = Codec.Base64DecodeBytes(Data);
							}
							else {
								this.Body = Codec.Base64Encode(this.FileBody);
							}
						}
						break;
						//- - - - - - - - - - - - - - - - - -//
					default:
						//do nothing
						break;
				}
			}
		//<-- End Method :: ParseBody
		
		//##################################################################################
		
		//--> Begin Method :: AddHeader
			public void AddHeader(string Name, string Value) {
				this.Headers.Add(new string[]{Name, Value});
			}
		//<-- End Method :: AddHeader
		
		//##################################################################################
		
		//--> Begin Method :: RemoveHeader
			public void RemoveHeader(string Name) {
				for(int i = 0 ; i < this.Headers.Count ; i++) {
					if(this.Headers[i][0].ToString().ToLower() == Name.ToLower()) {
						this.Headers.RemoveAt(i);
					}
				}
			}
		//<-- End Method :: RemoveHeader
		
		//##################################################################################
		
		//--> Begin Method :: GetHeader
			public string GetHeader(string Name) {
				for(int i = 0 ; i < this.Headers.Count ; i++) {
					if(this.Headers[i][0].ToString().ToLower() == Name.ToLower()) {
						return this.Headers[i][1].ToString();
					}
				}
				
				return "";
			}
		//<-- End Method :: GetHeader
		
		//##################################################################################
		
		//--> Begin Method :: GetContentTransferEncoding
			public string GetContentTransferEncoding() {
				if(this.GetHeader("Content-Transfer-Encoding") != "") {
					return this.GetHeader("Content-Transfer-Encoding");
				}
				else {
					return "";
				}
			}
		//<-- End Method :: GetContentTransferEncoding
		
		//##################################################################################
		
		//--> Begin Method :: GetMediaType
			public string GetMediaType() {
				string tmpMediaType = "";
				Match myMediaMatch = Regex.Match(this.GetHeader("Content-Type"), "^(.*?)/(.*?);|$");
				if(myMediaMatch.Success) {
					tmpMediaType = myMediaMatch.Groups[1].Value;
				}
				if(tmpMediaType == "") {
					tmpMediaType = "text";
				}
				return tmpMediaType;
			}
		//<-- End Method :: GetMediaType
		
		//##################################################################################
		
		//--> Begin Method :: GetMediaSubType
			public string GetMediaSubType() {
				string tmpMediaSubType = "";
				Match myMediaMatch = Regex.Match(this.GetHeader("Content-Type"), "^(.*?)/(.*?);|$");
				if(myMediaMatch.Success) {
					tmpMediaSubType = myMediaMatch.Groups[2].Value;
				}
				if(tmpMediaSubType == "") {
					tmpMediaSubType = "plain";
				}
				return tmpMediaSubType;
			}
		//<-- End Method :: GetMediaSubType
		
		//##################################################################################
		
		//--> Begin Method :: GetMediaFileName
			public string GetMediaFileName() {
				string tmpMediaFile = "";
				Match myMediaFile = Regex.Match(this.GetHeader("Content-Disposition"), "name=\"{0,1}(.*?)(\"|;|$)");
				if(myMediaFile.Success) {
					tmpMediaFile = myMediaFile.Groups[1].Value;
				}
				return tmpMediaFile;
			}
		//<-- End Method :: GetMediaFileName
		
		//##################################################################################
		
		//--> Begin Method :: GetMediaCharacterSet
			public string GetMediaCharacterSet() {
				string tmpMediaCharacterSet = "";
				Match myMediaCharSetMatch = Regex.Match(this.GetHeader("Content-Type"), "charset=\"{0,1}(.*?)(\"|;|$)");
				if(!myMediaCharSetMatch.Success) {
					tmpMediaCharacterSet = "us-ascii";
				}
				else {
					tmpMediaCharacterSet = myMediaCharSetMatch.Groups[1].Value;
				}
				return tmpMediaCharacterSet;
			}
		//<-- End Method :: GetMediaCharacterSet
		
		//##################################################################################
		
		//--> Begin Method :: GetMediaBoundary
			public string GetMediaBoundary() {
				return Regex.Match(this.GetHeader("Content-Type"), "boundary=\"{0,1}(.*?)(?:\"|$)").Groups[1].Value;
			}
		//<-- End Method :: GetMediaBoundary
		
		//##################################################################################
		
		//--> Begin Method :: IsAttachment
			public bool IsAttachment() {
				try {
					if((this.GetHeader("Content-Disposition")).ToLower().IndexOf("attachment") > -1) {
						return true;
					}
					else {
						return false;
					}
				}
				catch {
					return false;
				}
			}
		//<-- End Method :: IsAttachment
		
		//##################################################################################
		
		//--> Begin Method :: ToString
			public override string ToString() {
				string tmpMIMEMessage = "";
				
				//loop over the headers
				for(int i = 0 ; i < this.Headers.Count ; i++) {
					string tmpThisHeader = this.Headers[i][0].ToString() +": "+ this.Headers[i][1].ToString();
					string tmpThisFixedHeader = "";
					if(tmpThisHeader.Length > 74) {
						while(tmpThisHeader.Length > 74) {
							//find the next space character furthest to the end (or the 74th character)
							if(tmpThisHeader.Substring(0, 73).LastIndexOf(" ") > -1) {
								tmpThisFixedHeader += tmpThisHeader.Substring(0, tmpThisHeader.Substring(0, 73).LastIndexOf(" ")) +"\n\t";
								//remove from tmpThisHeader
								tmpThisHeader = tmpThisHeader.Substring(tmpThisHeader.Substring(0, 73).LastIndexOf(" ")).Trim();
							}
							else if(tmpThisHeader.IndexOf(" ") > -1) {
								tmpThisFixedHeader += tmpThisHeader.Substring(0, tmpThisHeader.IndexOf(" ")) +"\n\t";
								//remove from tmpThisHeader
								tmpThisHeader = tmpThisHeader.Substring(tmpThisHeader.IndexOf(" ")).Trim();
							}
							else {
								//this is a long line w/ no breaking potential
								tmpThisFixedHeader += tmpThisHeader;
								tmpThisHeader = "";
							}
						}
						//if there is still content in tmpThisHeader ... append it w/ a new line
						if(tmpThisHeader.Length > 0) {
							tmpThisFixedHeader += tmpThisHeader;
						}
					}
					else {
						tmpThisFixedHeader = tmpThisHeader;
					}
					tmpThisFixedHeader += "\n";
					tmpMIMEMessage += tmpThisFixedHeader;
				}
				
				//we should alrady have the first space from the last header
				//but fix it here if there are no headers (probably never happens)
				if(this.Headers.Count == 0) {
					tmpMIMEMessage += "\n";
				}
				
				//add header/body space
				tmpMIMEMessage += "\n";
				
				//add preamble
				if(this.Preamble != "") {
					tmpMIMEMessage += this.Preamble +"\n";
				}
				
				//add body text
				if(this.Parts.Count == 0) {
					//en/decode on the way out
					this.ParseBody(ref this.Body, false);
					tmpMIMEMessage += this.Body;
				}
				else {
					//go through each part
					for(int i = 0 ; i < this.Parts.Count ; i++) {
						//add boundary above
						if(this.GetMediaBoundary() != "") {
							tmpMIMEMessage += "\n--"+ this.GetMediaBoundary() +"\n";
						}
						
						//add body content
						tmpMIMEMessage += this.Parts[i].ToString();
						
						//add boundary above
						if(this.GetMediaBoundary() != "" && (i + 1) == this.Parts.Count) {
							tmpMIMEMessage += "\n--"+ this.GetMediaBoundary() +"--\n\n";
						}
					}
				}
				
				return tmpMIMEMessage;
			}
		//<-- End Method :: ToString
		
		//##################################################################################
		
		//--> Begin Method :: SaveAs
			public void SaveAs(string FilePath) {
				try{
					//try to write file
					File.WriteAllText(FilePath, this.ToString(), Encoding.UTF8);
				}
				catch(Exception e) {
					throw new Exception("WebLegs.MIMEMessage.SaveAs(): Unable to save file to '"+ FilePath +"'. "+ e.ToString());
				}
			}
		//<-- End Method :: SaveAs
		
		//##################################################################################
		
		//--> Begin Method :: SaveBodyAs
			public void SaveBodyAs(string FilePath) {
				try{
					//try to write file
					File.WriteAllText(FilePath, this.Body, Encoding.UTF8);
				}
				catch(Exception e) {
					throw new Exception("WebLegs.MIMEMessage.SaveBodyAs(): Unable to save file to '"+ FilePath +"'. "+ e.ToString());
				}
			}
		//<-- End Method :: SaveBodyAs
		
		//##################################################################################
		
		//--> Begin Method :: SaveFileAs
			public void SaveFileAs(string FilePath) {
				try{
					//try to write file
					File.WriteAllBytes(FilePath, this.FileBody);
				}
				catch(Exception e) {
					throw new Exception("WebLegs.SaveFileAs.SaveAs(): Unable to save file to '"+ FilePath +"'. "+ e.ToString());
				}
			}
		//<-- End Method :: SaveFileAs
	}
//<-- End Class :: MIMEMessage

//##########################################################################################
</script>