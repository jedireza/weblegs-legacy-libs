<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.GenericServlet.*" %>
<%@ page import="java.lang.System" %>
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

//--> Begin Class :: WebResponse
	public class WebResponse {
		//--> Begin :: Properties
			public String RedirectURL;
			public JspWriter SystemOutput;
			public HttpServletResponse Response;
			public HttpServletRequest Request;
			public PrintWriter OutputWriter;
			public Hashtable Cookie;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public WebResponse(HttpServletRequest CurrentRequest, HttpServletResponse CurrentResponse, JspWriter CurrentSystemOutput) {
				this.Request = CurrentRequest;
				this.Response = CurrentResponse;
				this.SystemOutput = CurrentSystemOutput;
				this.RedirectURL = "";
				
				//set cookies
				this.Cookie =  new Hashtable();
				if(this.Request.getCookies() != null){
					Cookie[] tmpCookies = this.Request.getCookies();
					for(int i = 0; i < tmpCookies.length; i++){
						this.Cookie.put((String)tmpCookies[i].getName(), (String)tmpCookies[i].getValue());
					}
				}
				
				//get output writer
				try{
					this.OutputWriter = this.Response.getWriter();
				}
				catch(Exception e){}
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Finalize
			public void Finalize(String Data) throws Exception {
				//is there a redirect url?
				if(this.RedirectURL != null && !this.RedirectURL.equals("")) {
					this.Redirect(this.RedirectURL);
					//no need to End() here - the servlet takes care of the rest
				}
				else {
					//write final data and end
					this.Write(Data);
					this.End();
				}
			}
			public void Finalize() throws Exception {
				//is there a redirect url?
				if(this.RedirectURL != null && !this.RedirectURL.equals("")) {
					this.Redirect(this.RedirectURL);
					//no need to End() here - the servlet takes care of the rest
				}
			}
		//<-- End Method :: Finalize
		
		//##################################################################################
		
		//--> Begin Method :: Write
			public void Write(String Value) {
				this.OutputWriter.print(Value);
			}
		//<-- End Method :: Write
		
		//##################################################################################
		
		//--> Begin Method :: Redirect
			public void Redirect(String Value) throws Exception {
				//clear current buffer
				this.SystemOutput.clearBuffer();
				
				//send redirect headers
				this.Response.sendRedirect(Value);
			}
		//<-- End Method :: Redirect
		
		//##################################################################################
		
		//--> Begin Method :: End
			public void End() throws Exception {
				this.SystemOutput.close();
			}
		//<-- End Method :: End
		
		//##################################################################################
		
		//--> Begin Method :: AddHeader
			public void AddHeader(String Key, String Value) throws Exception {
				this.Response.addHeader(Key, Value);
			}
		//<-- End Method :: AddHeader
		
		//##################################################################################
		
		//--> Begin Method :: Session
			public void Session(String Key, String Value) {
				HttpSession tmpSession = this.Request.getSession(true);
				tmpSession.setAttribute(Key, Value);
			}
		//<-- End Method :: Session
		
		//##################################################################################
		
		//--> Begin Method :: Cookies
			public void Cookies(String Key, String Value) {
				this.Cookies(Key, Value, -1, "/", "", false);
			}
			public void Cookies(String Key, String Value, int Minutes) {
				this.Cookies(Key, Value, Minutes, "/", "", false);
			}
			public void Cookies(String Key, String Value, int Minutes, String Path) {
				this.Cookies(Key, Value, Minutes, Path, "", false);
			}
			public void Cookies(String Key, String Value, int Minutes, String Path, String Domain) {
				this.Cookies(Key, Value, Minutes, Path, Domain, false);
			}
			public void Cookies(String Key, String Value, int Minutes, String Path, String Domain, boolean Secure) {
				//create new cookie
				Cookie tmpCookie = new Cookie (Key, Value);
				
				//set minutes
				if(Minutes != -1) {
					tmpCookie.setMaxAge(Minutes * 60);
				}
				
				//set path
				tmpCookie.setPath(Path);
				
				//set domain
				if(!Domain.equals("")) {
					tmpCookie.setDomain(Domain);
				}
				
				//add cookie
				this.Response.addCookie(tmpCookie);
			}
		//<-- End Method :: Cookies
		
		//##################################################################################
		
		//--> Begin Method :: ClearCookies
			public void ClearCookies() {
				if(this.Request.getCookies() != null){
					Cookie[] AllCookies = this.Request.getCookies();
					for(Enumeration e = this.Cookie.keys(); e.hasMoreElements();){ 
						//get key
						String Key = (String)e.nextElement(); 
						Cookie tmpCookie = new Cookie(Key, "null");
						tmpCookie.setMaxAge(0);
						tmpCookie.setPath("/");
						tmpCookie.setDomain(this.Request.getServerName());
						this.Response.addCookie(tmpCookie);
					}
				}
			}
			public void ClearCookies(String Path) {
				if(this.Request.getCookies() != null){
					Cookie[] AllCookies = this.Request.getCookies();
					for(Enumeration e = this.Cookie.keys(); e.hasMoreElements();){ 
						//get key
						String Key = (String)e.nextElement(); 
						Cookie tmpCookie = new Cookie(Key, "null");
						tmpCookie.setMaxAge(0);
						tmpCookie.setPath(Path);
						tmpCookie.setDomain(this.Request.getServerName());
						this.Response.addCookie(tmpCookie);
					}
				}
			}
			public void ClearCookies(String Path, String Domain) {
				if(this.Request.getCookies() != null){
					Cookie[] AllCookies = this.Request.getCookies();
					for(Enumeration e = this.Cookie.keys(); e.hasMoreElements();){ 
						//get key
						String Key = (String)e.nextElement(); 
						Cookie tmpCookie = new Cookie(Key, "null");
						tmpCookie.setMaxAge(0);
						tmpCookie.setPath(Path);
						tmpCookie.setDomain(Domain);
						this.Response.addCookie(tmpCookie);
					}
				}
			}
		//<-- End Method :: ClearCookies
		
		//##################################################################################
		
		//--> Begin Method :: ClearSession
			public void ClearSession() {
				HttpSession tmpSession = this.Request.getSession(false);
				if(tmpSession != null){
					tmpSession.invalidate();
				}
			}
		//<-- End Method :: ClearSession
	}
//<-- End Class :: WebResponse

//##########################################################################################
%>