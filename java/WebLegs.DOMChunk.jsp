<%@ page import="org.w3c.dom.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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

//--> Begin Class :: DOMChunk
	public class DOMChunk extends DOMTemplate {
		//--> Begin :: Properties
			public Node Blank;
			public ArrayList<Node> All;
			public Node Current;
			public Node Original;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public DOMChunk(DOMTemplate ThisDOMTemplate) throws Exception {
				this.Blank = null;
				this.All = new ArrayList<Node>();
				this.Current = null;
				
				//set base path
				this.BasePath = ThisDOMTemplate.XPathQuery;
				
				this.DOMXPath = ThisDOMTemplate.DOMXPath;
				this.DOMDocument = ThisDOMTemplate.DOMDocument;
				
				this.Original = ThisDOMTemplate.GetNode();
				this.Blank = this.Original.cloneNode(true);
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Root
			public DOMTemplate Root() throws Exception {
				//clear out results nodes
				this.ResultNodes = null;
				
				//clear out xpath query
				this.XPathQuery = "";
				
				return this;
			}
		//--> Begin Method :: Root
		
		//##################################################################################
		
		//--> Begin Method :: Begin
			public void Begin() throws Exception {
				//make a copy of blank
				this.Current = this.Blank.cloneNode(true);
				
				//put current in the tree
				this.Original.getParentNode().replaceChild(this.Current, this.Original); 
				
				//current is the new original
				this.Original = this.Current;
			}
		//<-- End Method :: Begin
		
		//##################################################################################
		
		//--> Begin Method :: End
			public void End() throws Exception {
				//save a copy of current now that its been edited
				this.All.add(this.Current.cloneNode(true));
			}
		//<-- End Method :: End
		
		//##################################################################################
		
		//--> Begin Method :: Render
			public void Render() throws Exception {
				for(int i = 0 ; i < this.All.size() ; i++) {
					this.Original.getParentNode().appendChild(this.All.get(i));
				}
				this.Original.getParentNode().removeChild(this.Original);
			}
		//<-- End Method :: Render
	}
//<-- End Class :: DOMChunk

//##########################################################################################
%>