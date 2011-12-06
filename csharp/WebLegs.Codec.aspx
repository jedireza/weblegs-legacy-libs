<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Security.Cryptography" %>
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

//--> Begin Class :: Codec
	public static class Codec {
		//--> Begin :: Properties
			//no properties
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			//no constructor
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: URLEncode
			public static string URLEncode(string Input) {
				return System.Web.HttpContext.Current.Server.UrlEncode(Input);
			}
		//<-- End Method :: URLEncode
		
		//##################################################################################
		
		//--> Begin Method :: URLDecode
			public static string URLDecode(string Input) {
				return System.Web.HttpContext.Current.Server.UrlDecode(Input);
			}
		//<-- End Method :: URLDecode
		
		//##################################################################################
		
		//--> Begin Method :: HTMLEncode
			public static string HTMLEncode(string Input) {
				return System.Web.HttpContext.Current.Server.HtmlEncode(Input);
			}
		//<-- End Method :: HTMLEncode
		
		//##################################################################################
		
		//--> Begin Method :: HTMLDecode
			public static string HTMLDecode(string Input) {
				return System.Web.HttpContext.Current.Server.HtmlDecode(Input);
			}
		//<-- End Method :: HTMLDecode
		
		//##################################################################################
		
		//--> Begin Method :: XMLEncode
			public static string XMLEncode(string Input) {
				return Input.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;").Replace("\"", "&quot;").Replace("'", "&apos;");
			}
		//<-- End Method :: XMLEncode
		
		//##################################################################################
		
		//--> Begin Method :: XMLDecode
			public static string XMLDecode(string Input) {
				return Input.Replace("&amp;", "&").Replace("&lt;", "<").Replace("&gt;", ">").Replace("&quot;", "\"").Replace("&apos;", "'");
			}
		//<-- End Method :: XMLDecode
		
		//##################################################################################
		
		//--> Begin Method :: Base64Encode
			public static string Base64Encode(string Input) {
				byte[] StringBytes = System.Text.Encoding.UTF8.GetBytes(Input);
				return Codec.Base64Encode(StringBytes);
			}
			public static string Base64Encode(byte[] Input) {
				return System.Convert.ToBase64String(Input, Base64FormattingOptions.InsertLineBreaks);
			}
		//<-- End Method :: Base64Encode
		
		//##################################################################################
		
		//--> Begin Method :: Base64Decode
			public static string Base64Decode(string Input) {
				byte[] EncodedData = System.Convert.FromBase64String(Input);
				UTF7Encoding myUTFEncoder = new UTF7Encoding();
				return myUTFEncoder.GetString(EncodedData);
			}
		//<-- End Method :: Base64Decode
		
		//##################################################################################
		
		//--> Begin Method :: Base64DecodeBytes
			public static byte[] Base64DecodeBytes(string Input) {
				return System.Convert.FromBase64String(Input);
			}
		//<-- End Method :: Base64DecodeBytes
		
		//##################################################################################
		
		//--> Begin Method :: QuotedPrintableEncode
			public static string QuotedPrintableEncode(string Input) {
				//create an ascii encoding object
				ASCIIEncoding ASCIIEncoding = new ASCIIEncoding();
				
				//get the byte version of this data
				byte[] ByteArray = ASCIIEncoding.GetBytes(Input);
				
				//container for our final string
				StringBuilder tmpQPString = new StringBuilder();
				
				//container for our current line length
				int CurrentLineLength = 0;
				
				//loop over bytes and build new string
				for(int i = 0; i < ByteArray.Length; i++) {
					//Get one character at a time
					byte Current = ByteArray[i];
					
					//Keep track of the next character too... if its the last character
					//present return a CR character
					byte Next = ((i + 1) != ByteArray.Length) ? ByteArray[i + 1] : (byte)0x0D;
					
					//make hex-style string out of the current byte
						string CurrentEncoded = "";
						
						//if this is the '=' character just encode it
						if(Current == '=') {
							CurrentEncoded = String.Format("={0:X2}", Current);
						}
						//if this is any of these characters, just encode them
						else if(Current == '!' || Current == '"' || Current == '#' || Current == '$' || Current == '@' || Current == '[' || Current == '\\' || Current == ']' || Current == '^' || Current == '`' || Current == '{' || Current == '|' || Current == '}' || Current == '~' || Current == '\'') {
							CurrentEncoded = String.Format("={0:X2}", Current);
						}
						//if we come across a tab or a space AND the next byte
						//represents CR or LF, we need to encode it too
						else if((Current == 0x09 || Current == 0x20) && (Next == 0x0A || Next == 0x0D)) {
							CurrentEncoded = String.Format("={0:X2}", Current);
						}
						//is this character ok as is?
						else if((Current >= 33 && Current <= 126) || Current == 0x0D || Current == 0x0A || Current == 0x09 || Current == 0x20) {
							CurrentEncoded = new string((char)Current, 1);
						}
						else {
							//if we get here, we've fell from above, ecode anything that gets here
							CurrentEncoded = String.Format("={0:X2}", Current);
						}
					//end make hex-style string out of the current byte
					
					//let's make sure that we keep track of line length while
					//we append characters together for the final output
					
					//check for CR and LF to get away from double lines
					if(Current == 0x0D || Current == 0x0A) {
						//if we got here that means that we are at the end of the
						//line and we need to reset our line length tracking variable
						if(Current == 0x0A) {
							CurrentLineLength = 0;
						}
					}
					
					//check to see if this pushes us past 74 characters
					//if so lets add a soft line break
					if(CurrentEncoded.Length + CurrentLineLength > 74) {
						tmpQPString.Append("=\n");
						CurrentLineLength = 0;
					}
					
					//append this character and increase line length
					tmpQPString.Append(CurrentEncoded);
					CurrentLineLength += CurrentEncoded.Length;
				}
				
				//return our completed string
				return tmpQPString.ToString();
			}
		//<-- End Method :: QuotedPrintableEncode
		
		//##################################################################################
		
		//--> Begin Method :: QuotedPrintableDecode
			public static string QuotedPrintableDecode(string Input) {
				//normalize newlines
				Input = Input.Replace("\r\n", "\n");
				//rule #3 trailing space must be deleted
				Input = Input.Replace("[ \t]+\n", "\n");
				//rule #5 soft line breaks
				Input = Input.Replace("=\n", "");
				//decode hex characters
				Regex HexMatcher = new Regex("(=([0-9A-F][0-9A-F]))", RegexOptions.IgnoreCase | RegexOptions.Singleline);
				foreach(Match HexMatch in HexMatcher.Matches(Input)) {
					string HexCode = HexMatch.Groups[2].Value;
					int HexInteger = Convert.ToInt32(HexCode, 16);
					char HexCharacter = (char)HexInteger;
					Input = Input.Replace(HexMatch.Groups[1].Value, HexCharacter.ToString());
				}
				return Input;
			}
		//<-- End Method :: QuotedPrintableDecode
		
		//##################################################################################
		
		//--> Begin Method :: MD5Encrypt
			public static string MD5Encrypt(string Input) {
				MD5CryptoServiceProvider MD5Crypto = new MD5CryptoServiceProvider();
				byte[] InputBytes = System.Text.Encoding.ASCII.GetBytes(Input);
				InputBytes = MD5Crypto.ComputeHash(InputBytes);
				string Output = "";
				for(int i = 0; i < InputBytes.Length; i++) {
					Output += InputBytes[i].ToString("x2").ToLower();
				}
				return Output;
			}
		//<-- End Method :: MD5Encrypt
		
		//##################################################################################
		
		//--> Begin Method :: HMACMD5Encrypt
			public static string HMACMD5Encrypt(string Key, string Input) {
				byte[] KeyBytes = Encoding.ASCII.GetBytes(Key);
				byte[] DataBytes = Encoding.ASCII.GetBytes(Input);
				
				HMACMD5 MyHMACMD5 = new HMACMD5(KeyBytes);
				byte[] HMACData = MyHMACMD5.ComputeHash(DataBytes);
		
				StringBuilder Digest = new StringBuilder();
				foreach(byte ThisByte in HMACData){
					Digest.Append(ThisByte.ToString("x2"));
				}
				return Digest.ToString();
			}
		//<-- End Method :: HMACMD5Encrypt
	}
//<-- End Class :: Codec

//##########################################################################################
</script>