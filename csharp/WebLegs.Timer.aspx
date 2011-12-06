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

//--> Begin Class :: Timer
	public class Timer {
		//--> Begin :: Properties
			public DateTime TimeStart;
			public DateTime TimeStop;
			public double TimeSpent;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public Timer() {
				this.TimeStart = new DateTime();
				this.TimeStop = new DateTime();
				this.TimeSpent = 0;
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Start
			public void Start() {
				this.TimeStart = DateTime.Now;
			}
		//<-- End Method :: Start
		
		//##################################################################################
		
		//--> Begin Method :: Stop
			public void Stop() {
				this.TimeStop = DateTime.Now;
				//get the total time spent
				this.TimeSpent = TimeSpan.FromTicks(this.TimeStop.Ticks - this.TimeStart.Ticks).TotalSeconds;
			}
		//<-- End Method :: Stop
	}
//<-- End Class :: Timer

//##########################################################################################
</script>