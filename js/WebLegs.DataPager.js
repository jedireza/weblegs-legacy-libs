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

//--> Begin :: Namespace Check
	//define vars for needed objects
	var WebLegs;
	
	//is our namespace present?
	if(!WebLegs) {
		WebLegs = {};
	}
//<-- End :: Namespace Check

//##########################################################################################

//--> Begin Method :: Constructor
	WebLegs.DataPager = function() {
		//create our instance variables
		this.RecordsPerPage = 0;
		this.TotalRecords = 0;
		this.CurrentPage = 0;
		this.LinkLoopOffset = 3;
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: GetTotalPages
	WebLegs.DataPager.prototype.GetTotalPages = function() {
		var TotalPages = this.TotalRecords / this.RecordsPerPage;
		if(TotalPages % this.RecordsPerPage > 0) {
			TotalPages++;
		}
		return TotalPages;
	}
//<-- End Method :: GetTotalPages

//##########################################################################################

//--> Begin Method :: GetRecordToStart
	WebLegs.DataPager.prototype.GetRecordToStart = function() {
		var RecordToStart = 0;
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

//##########################################################################################

//--> Begin Method :: GetRecordToStop
	WebLegs.DataPager.prototype.GetRecordToStop = function() {
		var RecordToStop = this.GetRecordToStart() + this.RecordsPerPage;
		if(RecordToStop > this.TotalRecords) {
			RecordToStop = this.TotalRecords;
		}
		return RecordToStop;
	}
//<-- End Method :: GetRecordToStop

//##########################################################################################

//--> Begin Method :: GetPreviousPage
	WebLegs.DataPager.prototype.GetPreviousPage = function() {
		if(this.CurrentPage - 1 <= 0) {
			return 1;
		}
		else {
			return this.CurrentPage - 1;
		}
	}
//<-- End Method :: GetPreviousPage

//##########################################################################################

//--> Begin Method :: GetNextPage
	WebLegs.DataPager.prototype.GetNextPage = function() {
		if((this.CurrentPage + 1) > this.GetTotalPages()) {
			return this.GetTotalPages();
		}
		else {
			return this.CurrentPage + 1;
		}
	}
//<-- End Method :: GetNextPage

//##########################################################################################

//--> Begin Method :: HasPreviousPage
	WebLegs.DataPager.prototype.HasPreviousPage = function() {
		if(this.CurrentPage - 1 <= 0) {
			return false;
		}
		else {
			return true;
		}
	}
//<-- End Method :: HasPreviousPage

//##########################################################################################

//--> Begin Method :: HasNextPage
	WebLegs.DataPager.prototype.HasNextPage = function() {
		if(this.CurrentPage + 1 > this.GetTotalPages()) {
			return false;
		}
		else {
			return true;
		}
	}
//<-- End Method :: HasNextPage

//##########################################################################################

//--> Begin Method :: GetLinkLoopStart
	WebLegs.DataPager.prototype.GetLinkLoopStart = function() {
		if(this.CurrentPage - this.LinkLoopOffset < 1) {
			return 1;
		}
		else {
			return this.CurrentPage - this.LinkLoopOffset;
		}
	}
//<-- End Method :: GetLinkLoopStart

//##########################################################################################

//--> Begin Method :: GetLinkLoopStop
	WebLegs.DataPager.prototype.GetLinkLoopStop = function() {
		if(this.CurrentPage + this.LinkLoopOffset > this.GetTotalPages()) {
			return this.GetTotalPages();
		}
		else {
			return this.CurrentPage + this.LinkLoopOffset;
		}
	}
//<-- End Method :: GetLinkLoopStop

//##########################################################################################