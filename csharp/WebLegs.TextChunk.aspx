<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
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

//--> Begin Class :: TextChunk
	public class TextChunk {
		//--> Begin :: Properties
			public string Blank;
			public string Current;
			public string All;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public TextChunk() {
				this.Blank = "";
				this.Current = "";
				this.All = "";
			}
			public TextChunk(ref string Source, string Start, string End) {
				int MyStart = 0;
				int MyEnd = 0;
				
				if(Source.IndexOf(Start) > -1 && Source.LastIndexOf(End) > -1) {
					MyStart = (Source.IndexOf(Start)) + Start.Length;
					MyEnd = Source.LastIndexOf(End);
					
					try{
						this.Blank = Source.Substring(MyStart, MyEnd - MyStart);
					}
					catch {
						throw new Exception("WebLegs.TextChunk.Constructor(): Boundry string mismatch.");
					}
				}
				else {
					throw new Exception("WebLegs.TextChunk.Constructor(): Boundry strings not present in source string.");
				}
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Begin
			public void Begin() {
				this.Current = this.Blank;
			}
		//<-- End Method :: Begin
		
		//##################################################################################
		
		//--> Begin Method :: End
			public void End() {
				this.All += this.Current;
			}
		//<-- End Method :: End
		
		//##################################################################################
		
		//--> Begin Method :: Replace
			public TextChunk Replace(string This, string WithThis) {
				this.Current = this.Current.Replace(This, WithThis);
				return this;
			}
		//<-- End Method :: Replace
		
		//##################################################################################
		
		//--> Begin Method :: ToString
			public override string ToString() {
				return this.All;
			}
		//<-- End Method :: ToString
	}
//<-- End Class :: TextChunk

//##########################################################################################
</script>