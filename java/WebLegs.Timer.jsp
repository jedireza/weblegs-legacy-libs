<%@ page import="java.util.*" %>
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

//--> Begin Class :: Timer
	public class Timer {
		//--> Begin :: Properties
			Calendar TimeStart;
			Calendar TimeStop;
			double TimeSpent;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public Timer() {
				this.TimeSpent = 0;
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Start
			public void Start() {
				this.TimeStart = Calendar.getInstance();
				this.TimeSpent = 0;
			}
		//<-- End Method :: Start
		
		//##################################################################################
		
		//--> Begin Method :: Stop
			public void Stop() {
				this.TimeStop = Calendar.getInstance();
				this.TimeSpent = (double)(TimeStop.getTimeInMillis() - TimeStart.getTimeInMillis()) / 1000;
			}
		//<-- End Method :: Stop
	}
//<-- End Class :: Timer

//##########################################################################################
%>