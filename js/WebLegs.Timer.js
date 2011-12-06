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
	WebLegs.Timer = function() {
		this.TimeStart = null;
		this.TimeStop = null;
		this.TimeSpent = null;
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: Start
	WebLegs.Timer.prototype.Start = function() {
		var TmpDate = new Date();
		this.TimeStart = TmpDate.getTime();
		this.TimeSpent = 0;
	};
//<-- End Method :: Start

//##########################################################################################

//--> Begin Method :: Stop
	WebLegs.Timer.prototype.Stop = function() {
		var TmpDate = new Date();
		this.TimeStop = TmpDate.getTime();
		this.TimeSpent = (this.TimeStop - this.TimeStart) / 1000;
	};
//<-- End Method :: Stop

//##########################################################################################