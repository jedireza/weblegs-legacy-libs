<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Xml" %>
<script language="vb" runat="server">
'/##########################################################################################

'/*
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
'If not, see <http://www.gnu.org/licenses/>.
'*/

'/##########################################################################################

'/--> Begin Class :: DOMChunk
	Public Class DOMChunk 
		Inherits DOMTemplate 
		'/--> Begin :: Properties
			Public Blank As XmlNode
			Public All As List(Of XmlNode)
			Public Current As XmlNode
			Public Original As XmlNode
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New(ThisDOMTemplate As DOMTemplate)
				Me.Blank = Nothing
				Me.All = New List(Of XmlNode)()
				Me.Current = Nothing
				
				'set base path
				Me.BasePath = ThisDOMTemplate.XPathQuery
				
				Me.DOMXPath = ThisDOMTemplate.DOMXPath
				Me.DOMDocument = ThisDOMTemplate.DOMDocument
				
				Me.Original = ThisDOMTemplate.GetNode()
				Me.Blank = Me.Original.CloneNode(True)
			End Sub
		'/<-- End :: Constructor
			
		'/##################################################################################
		
		'/--> Begin Method :: Root
			Public Function Root() As DOMTemplate 
				'clear out results nodes
				Me.ResultNodes = Nothing
				
				'clear out xpath query
				Me.XPathQuery = ""
				
				Return Me
			End Function
		'/--> Begin Method :: Root
		
		'/##################################################################################
		
		'/--> Begin Method :: Begin
			Public Sub Begin() 
				'make a copy of blank
				Me.Current = Me.Blank.CloneNode(True)
				
				'put current in the tree
				Me.Original.ParentNode.ReplaceChild(Me.Current, Me.Original) 
				
				'current is the New original
				Me.Original = Me.Current	
			End Sub
		'/<-- End Method :: Begin
		
		'/##################################################################################
		
		'/--> Begin Method :: End
			Public Sub [End]() 
				'save a copy of current now that its been edited
				Me.All.Add(Me.Current.CloneNode(True))
			End Sub
		'/<-- End Method :: End
		
		'/##################################################################################
		
		'/--> Begin Method :: Render
			Public Sub Render() 
				For i As Integer = 0 To Me.All.Count - 1
					If i = 0 Then
						Me.Original.ParentNode.InsertAfter(Me.All(i), Me.Original)
					Else 
						Me.Original.ParentNode.InsertAfter(Me.All(i), Me.All(i-1))
					End If
				Next
				Me.Original.ParentNode.RemoveChild(Me.Original)
			End Sub
		'/<-- End Method :: Render
	End Class
'/<-- End Class :: DOMChunk

'/##########################################################################################
</script>