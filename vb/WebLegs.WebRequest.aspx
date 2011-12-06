<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<script language="vb" runat="server">
'/##########################################################################################

'/*
'Copyright (C) 2005-2010 WebLegs, Inc.
'This program is free software: you can redistribute it and/or modify it under the terms
'of the GNU General Public License as published by the Free Software Foundation, either
'version 3 of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
'without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
'See the GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License along with this program.
'If not, see <http://www.gnu.org/licenses/>.
'*/

'/##########################################################################################

'/--> Begin Class :: WebRequest
	Public Class WebRequest
		'/--> Begin :: Properties
			Public Files As List(Of WebRequestFile)
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New()
				'handle uploaded files
					'initialize property
					Me.Files = New List(Of WebRequestFile)
					
					'loop over all uploaded files
					Dim UploadedFiles As HttpFileCollection = System.Web.HttpContext.Current.Request.Files
					Dim FileKeys() As String = UploadedFiles.AllKeys
					For i As Integer = 0 To FileKeys.Length - 1
						If UploadedFiles(i).FileName <> "" Then
							Dim tmpFile As WebRequestFile = New WebRequestFile()
							tmpFile.File = UploadedFiles(i)
							tmpFile.FormName = FileKeys(i)
							tmpFile.FileName = System.IO.Path.GetFileName(UploadedFiles(i).FileName)
							tmpFile.ContentType = UploadedFiles(i).ContentType
							tmpFile.ContentLength = UploadedFiles(i).ContentLength
							Me.Files.Add(tmpFile)
						End If
					Next
				'end handle uploaded files
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: Form
			Public Overloads Function Form() As String
				Return System.Web.HttpContext.Current.Request.Form.ToString()
			End Function
			Public Overloads Function Form(Key As String) As String
				Return System.Web.HttpContext.Current.Request.Form(Key)
			End Function
			Public Overloads Function Form(Key As String, [Default] As String) As String
				Dim ReturnValue As String = System.Web.HttpContext.Current.Request.Form(Key)
				If ReturnValue = Nothing Then
					ReturnValue = [Default]
				End If
				Return [Default]
			End Function
		'/<-- End Method :: Form
		
		'/##################################################################################
		
		'/--> Begin Method :: QueryString
			Public Overloads Function QueryString() As String
				Return System.Web.HttpContext.Current.Request.QueryString.ToString()
			End Function
			Public Overloads Function QueryString(Key As String) As String
				Return System.Web.HttpContext.Current.Request.QueryString(Key)
			End Function
			Public Overloads Function QueryString(Key As String, [Default] As String) As String
				Dim ReturnValue As String = System.Web.HttpContext.Current.Request.QueryString(Key)
				If ReturnValue = Nothing Then
					ReturnValue = [Default]
				End If
				Return [Default]
			End Function
		'/<-- End Method :: QueryString
		
		'/##################################################################################
		
		'/--> Begin Method :: Input
			Public Overloads Function Input(Key As String) As String
				Return Me.Input(Key, "", true)
			End Function
			Public Overloads Function Input(Key As String, [Default] As String) As String
				Return Me.Input(Key, [Default], true)
			End Function
			Public Overloads Function Input(Key As String, [Default] As String, FormFirst As Boolean) As String
				
				Dim Value As String
				If FormFirst = true Then
					Value = System.Web.HttpContext.Current.Request.Form(Key)
					If Value = Nothing Then
						Value = System.Web.HttpContext.Current.Request.QueryString(Key)
					End If
				Else
					Value = System.Web.HttpContext.Current.Request.QueryString(Key)
					If Value = Nothing Then
						Value = System.Web.HttpContext.Current.Request.Form(Key)
					End If
				End If
				
				If Value = Nothing Then
					Value = [Default]
				End If
				
				Return Value
			End Function
			Public Overloads Function Input(Key As String, [Default] As Integer) As String
				Dim NewDefault As String = Convert.ToString([Default])
				Return Me.Input(Key, NewDefault)
			End Function
			Public Overloads Function Input(Key As String, [Default] As Integer, FormFirst As Boolean) As String
				Dim NewDefault As String = Convert.ToString([Default])
				Return Me.Input(Key, NewDefault, FormFirst)
			End Function
			Public Overloads Function Input(Key As String, [Default] As Double) As String
				Dim NewDefault As String = Convert.ToString([Default])
				Return Me.Input(Key, NewDefault)
			End Function
			Public Overloads Function Input(Key As String, [Default] As Double, FormFirst As Boolean) As String
				Dim NewDefault As String = Convert.ToString([Default])
				Return Me.Input(Key, NewDefault, FormFirst)
			End Function
		'/<-- End Method :: Input
		
		'/##################################################################################
		
		'/--> Begin Method :: File
			Public Function File(Key As String) As WebRequestFile 
				For i As Integer = 0 To Me.Files.Count - 1
					If Me.Files(i).FormName = Key Then
						Return Me.Files(i)
					End If
				Next
				Return Nothing
			End Function
		'/<-- End Method :: File
		
		'/##################################################################################
		
		'/--> Begin Method :: ServerVariables
			Public Function ServerVariables(ThisKey As String) As String
				Return System.Web.HttpContext.Current.Request.ServerVariables(ThisKey)
			End Function
		'/<-- End Method :: ServerVariables
		
		'/##################################################################################
		
		'/--> Begin Method :: Session
			Public Function Session(ThisKey As String) As String
				If System.Web.HttpContext.Current.Session(ThisKey) Is Nothing Then
					Return Nothing
				Else
					Return System.Web.HttpContext.Current.Session(ThisKey).ToString()
				End If
			End Function
		'/<-- End Method :: Session
		
		'/##################################################################################
		
		'/--> Begin Method :: Cookies
			Public Function Cookies(ThisKey As String) As String
				If System.Web.HttpContext.Current.Request.Cookies(ThisKey) Is Nothing Then
					Return Nothing
				Else
					Return System.Web.HttpContext.Current.Request.Cookies(ThisKey).Value.ToString()
				End If
			End Function
		'/<-- End Method :: Cookies
		
		'/##################################################################################
		
		'/--> Begin Method :: Header
			Public Function Header(Key As String) As String
				If System.Web.HttpContext.Current.Request.Headers(Key) Is Nothing Then
					Return Nothing
				Else
					Return System.Web.HttpContext.Current.Request.Headers(Key).ToString()
				End If
			End Function
		'/<-- End Method :: Header
		
	End Class
'/<-- End Class :: WebRequest

'/##########################################################################################
</script>