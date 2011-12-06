<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Web" %>
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

//--> Begin Class :: WebRequest
	public class WebRequest {
		//--> Begin :: Properties
			public List<WebRequestFile> Files;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public WebRequest() {
				//handle uploaded files
					//initialize property
					this.Files = new List<WebRequestFile>();
					
					//loop over all uploaded files
					HttpFileCollection UploadedFiles = System.Web.HttpContext.Current.Request.Files;
					string[] FileKeys = UploadedFiles.AllKeys;
					for(int i = 0 ; i < FileKeys.Length ; i++) {
						if(UploadedFiles[i].FileName != "") {
							WebRequestFile tmpFile = new WebRequestFile();
							tmpFile.File = UploadedFiles[i];
							tmpFile.FormName = FileKeys[i];
							tmpFile.FileName = System.IO.Path.GetFileName(UploadedFiles[i].FileName);
							tmpFile.ContentType = UploadedFiles[i].ContentType;
							tmpFile.ContentLength = UploadedFiles[i].ContentLength;
							this.Files.Add(tmpFile);
						}
					}
				//end handle uploaded files
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Form
			public string Form() {
				return (System.Web.HttpContext.Current.Request.Form).ToString();
			}
			public string Form(string Key) {
				return System.Web.HttpContext.Current.Request.Form[Key];
			}
			public string Form(string Key, string Default) {
				string Return = System.Web.HttpContext.Current.Request.Form[Key];
				return (Return == null ? Default : Return);
			}
		//<-- End Method :: Form
		
		//##################################################################################
		
		//--> Begin Method :: QueryString
			public string QueryString() {
				return (System.Web.HttpContext.Current.Request.QueryString).ToString();
			}
			public string QueryString(string Key) {
				return System.Web.HttpContext.Current.Request.QueryString[Key];
			}
			public string QueryString(string Key, string Default) {
				string Return = System.Web.HttpContext.Current.Request.QueryString[Key];
				return (Return == null ? Default : Return);
			}
		//<-- End Method :: QueryString
		
		//##################################################################################
		
		//--> Begin Method :: Input
			public string Input(string Key) {
				return Input(Key, "", true);
			}
			public string Input(string Key, string Default) {
				return Input(Key, Default, true);
			}
			public string Input(string Key, string Default, bool FormFirst) {
				string Value;
				
				if(FormFirst) {
					Value = System.Web.HttpContext.Current.Request.Form[Key];
					if(Value == null) {
						Value = System.Web.HttpContext.Current.Request.QueryString[Key];
					}
				}
				else {
					Value = System.Web.HttpContext.Current.Request.QueryString[Key];
					if(Value == null) {
						Value = System.Web.HttpContext.Current.Request.Form[Key];
					}
				}
				
				if(Value == null) Value = Default;
				
				return Value;
			}
			public string Input(string Key, int Default) {
				string NewDefault = Convert.ToString(Default);
				return this.Input(Key, NewDefault);
			}
			public string Input(string Key, int Default, bool FormFirst) {
				string NewDefault = Convert.ToString(Default);
				return this.Input(Key, NewDefault, FormFirst);
			}
			public string Input(string Key, double Default) {
				string NewDefault = Convert.ToString(Default);
				return this.Input(Key, NewDefault);
			}
			public string Input(string Key, double Default, bool FormFirst) {
				string NewDefault = Convert.ToString(Default);
				return this.Input(Key, NewDefault, FormFirst);
			}
		//<-- End Method :: Input
		
		//##################################################################################
		
		//--> Begin Method :: File
			public WebRequestFile File(string Key) {
				for(int i = 0 ; i < this.Files.Count ; i++) {
					if(this.Files[i].FormName == Key) {
						return this.Files[i];
					}
				}
				return null;
			}
		//<-- End Method :: File
		
		//##################################################################################
		
		//--> Begin Method :: ServerVariables
			public string ServerVariables(string Key) {
				return System.Web.HttpContext.Current.Request.ServerVariables[Key];
			}
		//<-- End Method :: ServerVariables
		
		//##################################################################################
		
		//--> Begin Method :: Session
			public string Session(string Key) {
				if(System.Web.HttpContext.Current.Session[Key] == null) {
					return null;
				}
				else {
					return System.Web.HttpContext.Current.Session[Key].ToString();
				}
			}
		//<-- End Method :: Session
		
		//##################################################################################
		
		//--> Begin Method :: Cookies
			public string Cookies(string Key) {
				if(System.Web.HttpContext.Current.Request.Cookies[Key] == null) {
					return null;
				}
				else {
					return System.Web.HttpContext.Current.Request.Cookies[Key].Value.ToString();
				}
			}
		//<-- End Method :: Cookies
		
		//##################################################################################
		
		//--> Begin Method :: Header
			public string Header(string Key) {
				if(System.Web.HttpContext.Current.Request.Headers[Key] == null) {
					return null;
				}
				else {
					return System.Web.HttpContext.Current.Request.Headers[Key].ToString();
				}
			}
		//<-- End Method :: Header
	}
//<-- End Class :: WebRequest

//##########################################################################################
</script>