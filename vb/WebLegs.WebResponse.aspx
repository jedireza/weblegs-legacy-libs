<%@ Import Namespace="System" %>
<script language="vb" runat="server">
'/##########################################################################################

'*
'Copyright (C) 2005-2010 WebLegs, Inc.
'This program is free software: you can redistribute it and/or modIfy it under the terms
'of the GNU General Public License as published by the Free Software Foundation, either
'version 3 of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
'without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
'See the GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License along with this program.
'If not, see <http:'www.gnu.org/licenses/>.
'*/

'/##########################################################################################

'/--> Begin Class :: WebResponse
	Public Class WebResponse 
		'/--> Begin :: Properties
			Public RedirectURL As String
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New() 
				Me.RedirectURL = ""	
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: Finalize
			Public Overloads Sub Finalize(Data As String) 
				'is there a redirect url?
				If Me.RedirectURL <> Nothing And Me.RedirectURL <> "" Then
					Me.Redirect(Me.RedirectURL)
					Me.End()
				Else 
					'write final data and end
					Me.Write(Data)
					Me.End()
				End If
			End Sub
			Public Overloads Sub Finalize() 
				'is there a redirect url?
				If Me.RedirectURL <> Nothing And Me.RedirectURL <> "" Then
					Me.Redirect(Me.RedirectURL)
					Me.End()
				End If
			End Sub
		'/<-- End Method :: Finalize
		
		'/##################################################################################
		
		'/--> Begin Method :: Write
			Public Sub Write(Value As String) 
				System.Web.HttpContext.Current.Response.Write(Value)
			End Sub
		'/<-- End Method :: Write
		
		'/##################################################################################
		
		'/--> Begin Method :: Redirect
			Public Sub Redirect(Value As String) 
				System.Web.HttpContext.Current.Response.Redirect(Value)
			End Sub
		'/<-- End Method :: Redirect
		
		'/##################################################################################
		
		'/--> Begin Method :: End
			Public Overloads Sub [End]() 
				System.Web.HttpContext.Current.Response.End()
			End Sub
		'/<-- End Method :: End
		
		'/##################################################################################
		
		'/--> Begin Method :: AddHeader
			Public Sub AddHeader(Key As String, Value As String) 
				If Key = "Status" Then
					System.Web.HttpContext.Current.Response.Status = Value
				Else
					System.Web.HttpContext.Current.Response.AddHeader(Key, Value)
				End If
			End Sub
		'/<-- End Method :: AddHeader
		
		'/##################################################################################
		
		'/--> Begin Method :: Session
			Public Sub Session(Key As String, Value As String) 
				System.Web.HttpContext.Current.Session(Key) = Value
			End Sub
		'/<-- End Method :: Session
		
		'/##################################################################################
		
		'/--> Begin Method :: Cookies
			Public Sub Cookies(Key As String, Value As String) 
				Me.Cookies(Key, Value, -1, "/", "", False)
			End Sub 
			Public Sub Cookies(Key As String, Value As String, Minutes As Integer) 
				Me.Cookies(Key, Value, Minutes, "/", "", False)
			End Sub
			Public Sub Cookies(Key As String, Value As String, Minutes As Integer, Path As String) 
				Me.Cookies(Key, Value, Minutes, Path, "", False)
			End Sub 
			Public Sub Cookies(Key As String, Value As String, Minutes As Integer, Path As String, Domain As String) 
				Me.Cookies(Key, Value, Minutes, Path, Domain, False)
			End Sub 
			Public Sub Cookies(Key As String, Value As String, Minutes As Integer, Path As String, Domain As String, Secure As Boolean) 
				Dim tmpCookie As HttpCookie = New HttpCookie(Key)
				tmpCookie.Value = Value
				If Minutes <> -1 Then
					tmpCookie.Expires = DateTime.Now.AddMinutes(Minutes)
				End If
				tmpCookie.Path = Path
				If Domain <> "" Then
					tmpCookie.Domain = Domain
				End If
				tmpCookie.Secure = Secure
				System.Web.HttpContext.Current.Response.Cookies.Add(tmpCookie)
			End Sub
		'/<-- End Method :: Cookies
		
		'/##################################################################################
		
		'/--> Begin Method :: ClearCookies
			Public Sub ClearCookies()
				Dim CookieKeys As String() = System.Web.HttpContext.Current.Request.Cookies.AllKeys
				For Each ThisCookie As String In CookieKeys
					System.Web.HttpContext.Current.Response.Cookies(ThisCookie).Value = Nothing
					System.Web.HttpContext.Current.Response.Cookies(ThisCookie).Expires = DateTime.Now.AddDays(-10)
					System.Web.HttpContext.Current.Response.Cookies(ThisCookie).Path = "/"
					System.Web.HttpContext.Current.Response.Cookies(ThisCookie).Domain = System.Web.HttpContext.Current.Request.ServerVariables("SERVER_NAME")
				Next
			End Sub
			Public Sub ClearCookies(Path As String)
				Dim CookieKeys As String() = System.Web.HttpContext.Current.Request.Cookies.AllKeys
				For Each ThisCookie As String In CookieKeys
					System.Web.HttpContext.Current.Response.Cookies(ThisCookie).Value = Nothing
					System.Web.HttpContext.Current.Response.Cookies(ThisCookie).Expires = DateTime.Now.AddDays(-10)
					System.Web.HttpContext.Current.Response.Cookies(ThisCookie).Path = Path
					System.Web.HttpContext.Current.Response.Cookies(ThisCookie).Domain = System.Web.HttpContext.Current.Request.ServerVariables("SERVER_NAME")
				Next
			End Sub
			Public Sub ClearCookies(Path As String, Domain As String)
				Dim CookieKeys As String() = System.Web.HttpContext.Current.Request.Cookies.AllKeys
				For Each ThisCookie As String In CookieKeys
					System.Web.HttpContext.Current.Response.Cookies(ThisCookie).Value = Nothing
					System.Web.HttpContext.Current.Response.Cookies(ThisCookie).Expires = DateTime.Now.AddDays(-10)
					System.Web.HttpContext.Current.Response.Cookies(ThisCookie).Path = Path
					System.Web.HttpContext.Current.Response.Cookies(ThisCookie).Domain = Domain
				Next
			End Sub
		'/<-- End Method :: ClearCookies
		
		'/##################################################################################
		
		'/--> Begin Method :: ClearSession
			Public Sub ClearSession() 
				System.Web.HttpContext.Current.Session.Abandon()
				System.Web.HttpContext.Current.Session.Clear()
			End Sub
		'/<-- End Method :: ClearSession
	End Class
'/<-- End Class :: WebResponse

'/##########################################################################################
</script>