<%@ page import="java.util.regex.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
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

//--> Begin Class :: MIMEMessage
	public class MIMEMessage {
		//--> Begin :: Properties
			public ArrayList<String[]> Headers;
			public String Preamble;
			public String Body;
			public byte[] FileBody;
			public ArrayList<MIMEMessage> Parts;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public MIMEMessage() throws Exception {
				this.Headers = new ArrayList<String[]>();
				this.Preamble = "";
				this.Body = "";
				this.Parts = new ArrayList<MIMEMessage>();
			}
			public MIMEMessage(String Data) throws Exception {
				this.Headers = new ArrayList<String[]>();
				this.Preamble = "";
				this.Body = "";
				this.Parts = new ArrayList<MIMEMessage>();
				this.Parse(Data);
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Parse
			public void Parse(String Data) throws Exception {
				Data = Data.replaceAll("\r\n", "\n");
				Data = Data.replaceAll("\r", "\n");
				
				//get groups
				Pattern MyPattern = Pattern.compile("(.*?)\n\n(.*)", Pattern.CASE_INSENSITIVE | Pattern.DOTALL );
				Matcher MyMatcher = MyPattern.matcher(Data);
				
				String tmpHeaders = "";
				String tmpBody = "";
				
				//parse the entire message
				if(MyMatcher.find()) {
					tmpHeaders = MyMatcher.group(1);
					tmpBody = MyMatcher.group(2);
				}
				
				this.ParseHeaders(tmpHeaders);
				this.ParseBody(tmpBody, true);
			}
		//<-- End Method :: Parse
		
		//##################################################################################
		
		//--> Begin Method :: ParseHeaders
			public void ParseHeaders(String Data) throws Exception {
				//parse raw headers into the properties
				Pattern MyPattern = Pattern.compile("(?<=\n|^)(\\S*?): (.*?)(?=\n\\S*?: |$)", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
				Matcher MyMatcher = MyPattern.matcher(Data);
				
				while(MyMatcher.find()) {
					String ThisGroup = MyMatcher.group();					
					
					//add to headers
					this.AddHeader(ThisGroup.substring(0, ThisGroup.indexOf(":")), ThisGroup.substring(ThisGroup.indexOf(":") + 2, ThisGroup.length()).replaceAll("\\s+", " "));
				}
			}
		//<-- End Method :: ParseHeaders
		
		//##################################################################################
		
		//--> Begin Method :: ParseBody
			public void ParseBody(String Data, boolean Decode) throws Exception {
				//parse just the message body
					if(this.GetMediaType().toLowerCase().equals("application")){
						//check for encoding
						if(this.GetContentTransferEncoding().indexOf("base64") > -1) {
							if(Decode) {
								this.Body = Data;
								this.FileBody = Codec.Base64DecodeBytes(Data);
							}
							else {
								this.Body = Codec.Base64Encode(this.FileBody);
							}
						}
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(this.GetMediaType().toLowerCase().equals("audio")){
						//check for encoding
						if(this.GetContentTransferEncoding().indexOf("base64") > -1) {
							if(Decode) {
								this.Body = Data;
								this.FileBody = Codec.Base64DecodeBytes(Data);
							}
							else {
								this.Body = Codec.Base64Encode(this.FileBody);
							}
						}
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(this.GetMediaType().toLowerCase().equals("image")){
						//check for encoding
						if(this.GetContentTransferEncoding().indexOf("base64") > -1) {
							if(Decode) {
								this.Body = Data;
								this.FileBody = Codec.Base64DecodeBytes(Data);
							}
							else {
								this.Body = Codec.Base64Encode(this.FileBody);
							}
						}
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(this.GetMediaType().toLowerCase().equals("message")){
						if(this.GetMediaSubType().toLowerCase().equals("rfc822")){
							//make the first part of this message
							//the parsed message
							this.Parts.add(new MIMEMessage(Data));
						}
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(this.GetMediaType().toLowerCase().equals("model")){
						//not implemented
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(this.GetMediaType().toLowerCase().equals("multipart")){
						String MultiPartBoundry = this.GetMediaBoundary();
						
						//find the preamble
						Pattern MyPattern = Pattern.compile("(.*?)--"+ MultiPartBoundry, Pattern.CASE_INSENSITIVE | Pattern.DOTALL );
						Matcher MyMatcher = MyPattern.matcher(Data);
						if(MyMatcher.find()) {
							this.Preamble = MyMatcher.group(1);
						}
						
						//get each part of the message
						MyPattern = Pattern.compile("--"+ MultiPartBoundry +"(.*?)(?=--"+ MultiPartBoundry +")", Pattern.CASE_INSENSITIVE | Pattern.DOTALL );
						MyMatcher = MyPattern.matcher(Data);
						
						while(MyMatcher.find()) {
							this.Parts.add(new MIMEMessage(MyMatcher.group(1)));
						}
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(this.GetMediaType().toLowerCase().equals("text")){
						//check for encoding
						if(this.GetContentTransferEncoding().indexOf("base64") > -1) {
							if(Decode) {
								this.Body = Codec.Base64Decode(Data);
								this.Body = this.Body;
							}
							else {
								this.Body = Codec.Base64Encode(Data.getBytes());
							}
						}
						else if(this.GetContentTransferEncoding().indexOf("quoted-printable") > -1) {
							if(Decode) {
								this.Body = Codec.QuotedPrintableDecode(Data);
								this.Body = this.Body;
							}
							else {
								this.Body = Codec.QuotedPrintableEncode(Data);
								this.Body = this.Body;
							}
						}
						else {
							this.Body = Data;
						}
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(this.GetMediaType().toLowerCase().equals("video")){
						//check for encoding
						if(this.GetContentTransferEncoding().indexOf("base64") > -1) {
							if(Decode) {
								this.Body = Data;
								this.FileBody = Codec.Base64DecodeBytes(Data);
							}
							else {
								this.Body = Codec.Base64Encode(this.FileBody);
							}
						}
					}
			}
		//<-- End Method :: ParseBody
		
		//##################################################################################
		
		//--> Begin Method :: AddHeader
			public void AddHeader(String Name, String Value)  throws Exception {
				this.Headers.add(new String[]{Name, Value});
			}
		//<-- End Method :: AddHeader
		
		//##################################################################################
		
		//--> Begin Method :: RemoveHeader
			public void RemoveHeader(String Name) throws Exception {
				for(int i = 0 ; i < this.Headers.size(); i++) {
					if(this.Headers.get(i)[0].toLowerCase().equals(Name.toLowerCase())) {
						this.Headers.remove(i);
					}
				}
			}
		//<-- End Method :: RemoveHeader
		
		//##################################################################################
		
		//--> Begin Method :: GetHeader
			public String GetHeader(String Name) throws Exception {	
				for(int i = 0 ; i < this.Headers.size() ; i++) {
					if(this.Headers.get(i)[0].toLowerCase().equals(Name.toLowerCase())) {
						return this.Headers.get(i)[1];
					}
				}
				return "";
			}
		//<-- End Method :: GetHeader
		
		//##################################################################################
		
		//--> Begin Method :: GetContentTransferEncoding
			public String GetContentTransferEncoding() throws Exception {
				if(!this.GetHeader("Content-Transfer-Encoding").equals("")) {
					return this.GetHeader("Content-Transfer-Encoding");
				}
				else {
					return "";
				}
			}
		//<-- End Method :: GetContentTransferEncoding
		
		//##################################################################################
		
		//--> Begin Method :: GetMediaType
			public String GetMediaType() throws Exception {
				String tmpMediaType = "";		
				Pattern MyPattern = Pattern.compile("^(.*?)/(.*?);|$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL );
				Matcher MyMatcher = MyPattern.matcher(this.GetHeader("Content-Type"));
				
				if(MyMatcher.find()) {
					tmpMediaType = MyMatcher.group(1);
				}
				if(tmpMediaType.equals("")) {
					tmpMediaType = "text";
				}
				return tmpMediaType;
			}
		//<-- End Method :: GetMediaType
		
		//##################################################################################
		
		//--> Begin Method :: GetMediaSubType
			public String GetMediaSubType() throws Exception {
				String tmpMediaSubType = "";
				Pattern MyPattern = Pattern.compile("^(.*?)/(.*?);|$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL );
				Matcher MyMatcher = MyPattern.matcher(this.GetHeader("Content-Type"));
				
				if(MyMatcher.find()) {
					tmpMediaSubType = MyMatcher.group(2);
				}
				if(tmpMediaSubType.equals("")) {
					tmpMediaSubType = "plain";
				}
				return tmpMediaSubType;
			}
		//<-- End Method :: GetMediaSubType
		
		//##################################################################################
		
		//--> Begin Method :: GetMediaFileName
			public String GetMediaFileName() throws Exception {
				String tmpMediaFile = "";
				Pattern MyPattern = Pattern.compile("name=\"{0,1}(.*?)(\"|;|$)", Pattern.CASE_INSENSITIVE | Pattern.DOTALL );
				Matcher MyMatcher = MyPattern.matcher(this.GetHeader("Content-Disposition"));
				
				if(MyMatcher.find()) {
					tmpMediaFile = MyMatcher.group(1);
				}
				return tmpMediaFile;
			}
		//<-- End Method :: GetMediaFileName
		
		//##################################################################################
		
		//--> Begin Method :: GetMediaCharacterSet
			public String GetMediaCharacterSet() throws Exception {
				String tmpMediaCharacterSet = "";
				Pattern MyPattern = Pattern.compile("charset=\"{0,1}(.*?)(\"|;|$)", Pattern.CASE_INSENSITIVE | Pattern.DOTALL );
				Matcher MyMatcher = MyPattern.matcher(this.GetHeader("Content-Type"));

				if(!MyMatcher.find()) {
					tmpMediaCharacterSet = "us-ascii";
				}
				else {
					tmpMediaCharacterSet = MyMatcher.group(1);
				}
				return tmpMediaCharacterSet;
			}
		//<-- End Method :: GetMediaCharacterSet
		
		//##################################################################################
		
		//--> Begin Method :: GetMediaBoundary
			public String GetMediaBoundary() throws Exception {
				Pattern MyPattern = Pattern.compile("boundary=(.*?)$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL );
				Matcher MyMatcher = MyPattern.matcher(this.GetHeader("Content-Type"));
				
				while(MyMatcher.find()) {
					return MyMatcher.group(1).replaceAll("\"", "").replaceAll("\'", "").trim();
				}
				
				return "";
			}
		//<-- End Method :: GetMediaBoundary
		
		//##################################################################################
		
		//--> Begin Method :: IsAttachment
			public boolean IsAttachment() throws Exception {
				try {
					if((this.GetHeader("Content-Disposition")).toLowerCase().indexOf("attachment") > -1) {
						return true;
					}
					else {
						return false;
					}
				}
				catch(Exception e) {
					return false;
				}
			}
		//<-- End Method :: IsAttachment
		
		//##################################################################################
		
		//--> Begin Method :: ToString
			public String ToString() throws Exception {
				
				String tmpMIMEMessage = "";

				//loop over the headers
				for(int i = 0 ; i < this.Headers.size() ; i++) {
					
					String tmpThisHeader = this.Headers.get(i)[0] +": "+ this.Headers.get(i)[1];
					String tmpThisFixedHeader = "";
					
					if(tmpThisHeader.length() > 74) {
						while(tmpThisHeader.length() > 74) {
							//find the next space character furthest to the end (or the 74th character)
							if(tmpThisHeader.substring(0, 73).lastIndexOf(" ") > -1) {
								tmpThisFixedHeader += tmpThisHeader.substring(0, tmpThisHeader.substring(0, 73).lastIndexOf(" ")) +"\n\t";
								//remove from tmpThisHeader
								tmpThisHeader = tmpThisHeader.substring(tmpThisHeader.substring(0, 73).lastIndexOf(" ")).trim();
							}
							else if(tmpThisHeader.indexOf(" ") > -1) {
								tmpThisFixedHeader += tmpThisHeader.substring(0, tmpThisHeader.indexOf(" ")) +"\n\t";
								//remove from tmpThisHeader
								tmpThisHeader = tmpThisHeader.substring(tmpThisHeader.indexOf(" ")).trim();
							}
							else {
								//this is a long line w/ no breaking potential
								tmpThisFixedHeader += tmpThisHeader;
								tmpThisHeader = "";
							}
						}
						//if there is still content in tmpThisHeader ... append it
						if(tmpThisHeader.length() > 0) {
							tmpThisFixedHeader += tmpThisHeader;
						}
					}
					else {
						tmpThisFixedHeader = tmpThisHeader;
					}
					tmpThisFixedHeader += "\n";
					tmpMIMEMessage += tmpThisFixedHeader;
				}
				
				//we should already have the first space from the last header
				//but fix it here if there are no headers (probably never happens)
				if(this.Headers.size() == 0) {
					tmpMIMEMessage += "\n";
				}
				
				//add header/body space
				tmpMIMEMessage += "\n";
				
				//add preamble
				if(this.Preamble.length() != 0) {
					tmpMIMEMessage += this.Preamble +"\n";
				}
				
				//add body text
				if(this.Parts.size() == 0) {
					//en/decode on the way out
					this.ParseBody(this.Body, false);
					tmpMIMEMessage += this.Body;
				}
				else {
					//go through each part
					for(int i = 0 ; i < this.Parts.size() ; i++) {
						//add boundary above
						if(this.GetMediaBoundary().length() != 0) {
							tmpMIMEMessage += "\n--"+ this.GetMediaBoundary() +"\n";
						}
						
						//add body content
						tmpMIMEMessage += this.Parts.get(i).ToString();
						
						//add boundary above
						if(this.GetMediaBoundary().length() != 0 && (i + 1) == this.Parts.size()) {
							tmpMIMEMessage += "\n--"+ this.GetMediaBoundary() +"--\n\n";
						}
					}
				}
				
				return tmpMIMEMessage;
			}
		//<-- End Method :: ToString
		
		//##################################################################################
		
		//--> Begin Method :: SaveAs
			public void SaveAs(String FilePath) throws Exception {
				File tmpFile = new File(FilePath);
				BufferedWriter OutputBuffer = new BufferedWriter(new FileWriter(tmpFile));
				
				try {
					OutputBuffer.write(this.ToString());
				}
				catch(Exception e){
					throw new Exception("WebLegs.MIMEMessage.SaveAs(): Was not able to save file.");
				}
				finally {
					OutputBuffer.close();
				}
			}
		//<-- End Method :: SaveAs
		
		//##################################################################################
		
		//--> Begin Method :: SaveBodyAs
			public void SaveBodyAs(String FilePath) throws Exception {
				File tmpFile = new File(FilePath);
				BufferedWriter OutputBuffer = new BufferedWriter(new FileWriter(tmpFile));
				
				try {
					OutputBuffer.write(this.Body);
				}
				catch(Exception e){
					throw new Exception("WebLegs.MIMEMessage.SaveBodyAs(): Was not able to save file.");
				}
				finally {
					OutputBuffer.close();
				}
			}
		//<-- End Method :: SaveBodyAs
		
		//##################################################################################
		
		//--> Begin Method :: SaveFileAs
			public void SaveFileAs(String FilePath) throws Exception {
				File tmpFile = new File(FilePath);
				FileOutputStream MyFileOutputStream = new FileOutputStream(tmpFile);
				
				try {
					MyFileOutputStream.write(this.FileBody);
				}
				catch(Exception e){
					throw new Exception("WebLegs.MIMEMessage.SaveFileAs(): Was not able to save file.");
				}
				finally {
					MyFileOutputStream.close();
				}
			}
		//<-- End Method :: SaveFileAs
	}
//<-- End Class :: MIMEMessage

//##########################################################################################
%>