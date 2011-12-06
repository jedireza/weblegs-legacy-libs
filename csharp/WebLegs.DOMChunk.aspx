<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Xml" %>
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

//--> Begin Class :: DOMChunk
	public class DOMChunk : DOMTemplate {
		//--> Begin :: Properties
			public XmlNode Blank;
			public List<XmlNode> All;
			public XmlNode Current;
			public XmlNode Original;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public DOMChunk(DOMTemplate ThisDOMTemplate){
				this.Blank = null;
				this.All = new List<XmlNode>();
				this.Current = null;
				
				//set base path
				this.BasePath = ThisDOMTemplate.XPathQuery;
				
				this.DOMXPath = ThisDOMTemplate.DOMXPath;
				this.DOMDocument = ThisDOMTemplate.DOMDocument;
				
				this.Original = ThisDOMTemplate.GetNode();
				this.Blank = this.Original.CloneNode(true);
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Root
			public DOMTemplate Root(){
				//clear out results nodes
				this.ResultNodes = null;
				
				//clear out xpath query
				this.XPathQuery = "";
				
				return this;
			}
		//--> Begin Method :: Root
		
		//##################################################################################
		
		//--> Begin Method :: Begin
			public void Begin() {
				//make a copy of blank
				this.Current = this.Blank.CloneNode(true);
				
				//put current in the tree
				this.Original.ParentNode.ReplaceChild(this.Current, this.Original); 
				
				//current is the new original
				this.Original = this.Current;	
			}
		//<-- End Method :: Begin
		
		//##################################################################################
		
		//--> Begin Method :: End
			public void End() {
				//save a copy of current now that its been edited
				this.All.Add(this.Current.CloneNode(true));
				
				//clear out results nodes
				this.ResultNodes = null;
				
				//clear out xpath query
				this.XPathQuery = "";
			}
		//<-- End Method :: End
		
		//##################################################################################
		
		//--> Begin Method :: Render
			public void Render() {
				for(int i = 0 ; i < this.All.Count ; i++) {
					//this.Original.ParentNode.AppendChild(this.All[i]);
					this.Original.ParentNode.InsertAfter(this.All[i], (i == 0 ? this.Original : this.All[i-1]));
				}
				this.Original.ParentNode.RemoveChild(this.Original);
			}
		//<-- End Method :: Render
	}
//<-- End Class :: DOMChunk

//##########################################################################################
</script>