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

//--> Begin Class :: TextChunk
	public class TextChunk {
		//--> Begin :: Properties
			public String Blank;
			public String Current;
			public String All;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public TextChunk() {
				this.Blank = "";
				this.Current = "";
				this.All = "";
			}
			public TextChunk(String Source, String Begin, String End) throws Exception {
				this.Blank = "";
				this.Current = "";
				this.All = "";
				
				int MyStart = 0;
				int MyEnd = 0;
			
				if(Source.indexOf(Begin) > -1 && Source.lastIndexOf(End) > -1) {
					MyStart = (Source.indexOf(Begin)) + Begin.length();
					MyEnd = Source.lastIndexOf(End);
					
					try{
						this.Blank = Source.substring(MyStart, MyEnd);
					}
					catch(Exception e) {
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
			public void End(Hashtable MyDataRow, String KeyDelimiter) {
				Enumeration KeysEnum = MyDataRow.keys();		
				while(KeysEnum.hasMoreElements ()){
					String MyColumnName = (String) KeysEnum.nextElement();
					this.Current = this.Current.replace(KeyDelimiter + MyColumnName 		      + KeyDelimiter, MyDataRow.get(MyColumnName).toString());
					this.Current = this.Current.replace(KeyDelimiter + MyColumnName.toUpperCase() + KeyDelimiter, MyDataRow.get(MyColumnName).toString());
					this.Current = this.Current.replace(KeyDelimiter + MyColumnName.toLowerCase() + KeyDelimiter, MyDataRow.get(MyColumnName).toString());
				}
				this.All += this.Current;
			}
			public void End(Hashtable MyDataRow) {
				this.End(MyDataRow, "%");
			}
		//<-- End Method :: End
		
		//##################################################################################
		
		//--> Begin Method :: Replace
			public TextChunk Replace(String This, String WithThis) {
				this.Current = this.Current.replaceAll(This.replaceAll("([\\\\*+\\[\\](){}\\$.?\\^|])", "\\\\$1"), WithThis);
				return this;
			}
		//<-- End Method :: Replace
		
		//##################################################################################
		
		//--> Begin Method :: ToString
			public String ToString() {
				return this.All;
			}
		//<-- End Method :: ToString
	}
//<-- End Class :: TextChunk

//##########################################################################################
%>