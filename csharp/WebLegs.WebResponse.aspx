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

//--> Begin Class :: WebResponse
	public class WebResponse {
		//--> Begin :: Properties
			public string RedirectURL;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public WebResponse() {
				this.RedirectURL = "";
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Finalize
			public void Finalize(string Data) {
				//is there a redirect url?
				if(this.RedirectURL != null && this.RedirectURL != "") {
					this.Redirect(this.RedirectURL);
					this.End();
				}
				else {
					//write final data and end
					this.Write(Data);
					this.End();
				}
			}
			public void Finalize() {
				//is there a redirect url?
				if(this.RedirectURL != null && this.RedirectURL != "") {
					this.Redirect(this.RedirectURL);
					this.End();
				}
			}
		//<-- End Method :: Finalize
		
		//##################################################################################
		
		//--> Begin Method :: Write
			public void Write(string Value) {
				System.Web.HttpContext.Current.Response.Write(Value);
			}
		//<-- End Method :: Write
		
		//##################################################################################
		
		//--> Begin Method :: Redirect
			public void Redirect(string Value) {
				System.Web.HttpContext.Current.Response.Redirect(Value);
			}
		//<-- End Method :: Redirect
		
		//##################################################################################
		
		//--> Begin Method :: End
			public void End() {
				System.Web.HttpContext.Current.Response.End();
			}
		//<-- End Method :: End
		
		//##################################################################################
		
		//--> Begin Method :: AddHeader
			public void AddHeader(string Key, string Value) {
				if(Key == "Status") {
					System.Web.HttpContext.Current.Response.Status = Value;
				}
				else {
					System.Web.HttpContext.Current.Response.AddHeader(Key, Value);
				}
			}
		//<-- End Method :: AddHeader
		
		//##################################################################################
		
		//--> Begin Method :: Session
			public void Session(string Key, string Value) {
				System.Web.HttpContext.Current.Session[Key] = Value;
			}
		//<-- End Method :: Session
		
		//##################################################################################
		
		//--> Begin Method :: Cookies
			public void Cookies(string Key, string Value) {
				this.Cookies(Key, Value, -1, "/", "", false);
			}
			public void Cookies(string Key, string Value, int Minutes) {
				this.Cookies(Key, Value, Minutes, "/", "", false);
			}
			public void Cookies(string Key, string Value, int Minutes, string Path) {
				this.Cookies(Key, Value, Minutes, Path, "", false);
			}
			public void Cookies(string Key, string Value, int Minutes, string Path, string Domain) {
				this.Cookies(Key, Value, Minutes, Path, Domain, false);
			}
			public void Cookies(string Key, string Value, int Minutes, string Path, string Domain, bool Secure) {
				HttpCookie tmpCookie = new HttpCookie(Key);
				tmpCookie.Value = Value;
				if(Minutes != -1) {
					tmpCookie.Expires = DateTime.Now.AddMinutes(Minutes);
				}
				tmpCookie.Path = Path;
				if(Domain != "") {
					tmpCookie.Domain = Domain;
				}
				tmpCookie.Secure = Secure;
				System.Web.HttpContext.Current.Response.Cookies.Add(tmpCookie);
			}
		//<-- End Method :: Cookies
		
		//##################################################################################
		
		//--> Begin Method :: ClearCookies
			public void ClearCookies() {
				string[] CookieKeys = System.Web.HttpContext.Current.Request.Cookies.AllKeys;
				foreach(string ThisCookie in CookieKeys) {
					System.Web.HttpContext.Current.Response.Cookies[ThisCookie].Value = null;
					System.Web.HttpContext.Current.Response.Cookies[ThisCookie].Expires = DateTime.Now.AddDays(-10);
					System.Web.HttpContext.Current.Response.Cookies[ThisCookie].Path = "/";
					System.Web.HttpContext.Current.Response.Cookies[ThisCookie].Domain = System.Web.HttpContext.Current.Request.ServerVariables["SERVER_NAME"];
				}
			}
			public void ClearCookies(String Path) {
				string[] CookieKeys = System.Web.HttpContext.Current.Request.Cookies.AllKeys;
				foreach(string ThisCookie in CookieKeys) {
					System.Web.HttpContext.Current.Response.Cookies[ThisCookie].Value = null;
					System.Web.HttpContext.Current.Response.Cookies[ThisCookie].Expires = DateTime.Now.AddDays(-10);
					System.Web.HttpContext.Current.Response.Cookies[ThisCookie].Path = Path;
					System.Web.HttpContext.Current.Response.Cookies[ThisCookie].Domain = System.Web.HttpContext.Current.Request.ServerVariables["SERVER_NAME"];
				}
			}
			public void ClearCookies(String Path, String Domain) {
				string[] CookieKeys = System.Web.HttpContext.Current.Request.Cookies.AllKeys;
				foreach(string ThisCookie in CookieKeys) {
					System.Web.HttpContext.Current.Response.Cookies[ThisCookie].Value = null;
					System.Web.HttpContext.Current.Response.Cookies[ThisCookie].Expires = DateTime.Now.AddDays(-10);
					System.Web.HttpContext.Current.Response.Cookies[ThisCookie].Path = Path;
					System.Web.HttpContext.Current.Response.Cookies[ThisCookie].Domain = Domain;
				}
			}
		//<-- End Method :: ClearCookies
		
		//##################################################################################
		
		//--> Begin Method :: ClearSession
			public void ClearSession() {
				System.Web.HttpContext.Current.Session.Abandon();
				System.Web.HttpContext.Current.Session.Clear();
			}
		//<-- End Method :: ClearSession
	}
//<-- End Class :: WebResponse

//##########################################################################################
</script>