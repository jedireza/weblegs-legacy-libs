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

//--> Begin Class :: DataPager
	public class DataPager {
		//--> Begin :: Properties
			public int RecordsPerPage;
			public int TotalRecords;
			public int CurrentPage;
			public int LinkLoopOffset;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public DataPager() {
				this.RecordsPerPage = 0;
				this.TotalRecords = 0;
				this.CurrentPage = 0;
				this.LinkLoopOffset = 0;
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: GetTotalPages
			public int GetTotalPages() {
				int TotalPages = this.TotalRecords / this.RecordsPerPage;
				if(TotalRecords % this.RecordsPerPage > 0) {
					TotalPages++;
				}
				return TotalPages;
			}
		//<-- End Method :: GetTotalPages
		
		//##################################################################################
		
		//--> Begin Method :: GetRecordToStart
			public int GetRecordToStart() {
				int RecordToStart = 0;
				if(this.CurrentPage > this.GetTotalPages()) {
					this.CurrentPage = this.GetTotalPages();
				}
				RecordToStart = (this.CurrentPage - 1) * this.RecordsPerPage;
				if(RecordToStart < 0) {
					RecordToStart = 0;
				}
				return RecordToStart;
			}
		//<-- End Method :: GetRecordToStart
		
		//##################################################################################
		
		//--> Begin Method :: GetRecordToStop
			public int GetRecordToStop() {
				int RecordToStop = this.GetRecordToStart() + this.RecordsPerPage;
				if(RecordToStop > this.TotalRecords) {
					RecordToStop = this.TotalRecords;
				}
				return RecordToStop;
			}
		//<-- End Method :: GetRecordToStop
		
		//##################################################################################
		
		//--> Begin Method :: GetPreviousPage
			public int GetPreviousPage() {
				if(this.CurrentPage - 1 <= 0) {
					return 1;
				}
				else {
					return this.CurrentPage - 1;
				}
			}
		//<-- End Method :: GetPreviousPage
		
		//##################################################################################
		
		//--> Begin Method :: GetNextPage
			public int GetNextPage() {
				if(this.CurrentPage + 1 > this.GetTotalPages()) {
					return this.GetTotalPages();
				}
				else {
					return this.CurrentPage + 1;
				}
			}
		//<-- End Method :: GetNextPage
		
		//##################################################################################
		
		//--> Begin Method :: HasPreviousPage
			public bool HasPreviousPage() {
				if(this.CurrentPage - 1 <= 0) {
					return false;
				}
				else {
					return true;
				}
			}
		//<-- End Method :: HasPreviousPage
		
		//##################################################################################
		
		//--> Begin Method :: HasNextPage
			public bool HasNextPage() {
				if(this.CurrentPage + 1 > this.GetTotalPages()) {
					return false;
				}
				else {
					return true;
				}
			}
		//<-- End Method :: HasNextPage
		
		//##################################################################################
		
		//--> Begin Method :: GetLinkLoopStart
			public int GetLinkLoopStart() {
				if(this.CurrentPage - this.LinkLoopOffset < 1) {
					return 1;
				}
				else {
					return this.CurrentPage - this.LinkLoopOffset;
				}
			}
		//<-- End Method :: GetLinkLoopStart
		
		//##################################################################################
		
		//--> Begin Method :: GetLinkLoopStop
			public int GetLinkLoopStop() {
				if(this.CurrentPage + this.LinkLoopOffset > this.GetTotalPages()) {
					return this.GetTotalPages();
				}
				else {
					return this.CurrentPage + this.LinkLoopOffset;
				}
			}
		//<-- End Method :: GetLinkLoopStop
	}
//<-- End Class :: DataPager

//##########################################################################################
</script>