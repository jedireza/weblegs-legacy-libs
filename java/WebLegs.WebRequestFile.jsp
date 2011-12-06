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

//--> Begin Class :: WebRequestFile
	public class WebRequestFile {
		//--> Begin :: Properties
			public String FormName;
			public String FileName;
			public String ContentType;
			public String ContentLength;
			public ByteArrayOutputStream FileData;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public WebRequestFile(){
				this.FormName = new String();
				this.FileName = new String();
				this.ContentType = new String();
				this.ContentLength = new String();
				this.FileData = new ByteArrayOutputStream();
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: SaveAs
			public void SaveAs(String FilePath) throws Exception {
				java.io.FileOutputStream FileStream = new java.io.FileOutputStream(FilePath);
				FileData.writeTo(FileStream);
				FileStream.close();
			}
		//<-- End Method :: SaveAs
		
	}
//<-- End Class :: WebRequestFile

//##########################################################################################
%>