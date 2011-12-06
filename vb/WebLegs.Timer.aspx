<%@ Import Namespace="System" %>
<script language="vb" runat="server">
'/##########################################################################################

'/*
'Copyright (C) 2005-2010 WebLegs, Inc.
'This program is free software: you can redistribute it and/or modIfy it under the terms
'of the GNU General Public License as published by the Free Software Foundation, either
'version 3 of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
'without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
'See the GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License along with this program.
'If not, see <http:'www.gnu.org/licenses/>.
'*/

'/##########################################################################################

'/--> Begin Class :: Timer
	Public Class Timer 
		'/--> Begin :: Properties
			Public TimeStart As DateTime
			Public TimeStop As DateTime
			Public TimeSpent As Double
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New() 
				Me.TimeStart = New DateTime()
				Me.TimeStop = New DateTime()
				Me.TimeSpent = 0
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin Method :: Start
			Public Sub Start() 
				Me.TimeStart = DateTime.Now
			End Sub
		'/<-- End Method :: Start
		
		'/##################################################################################
		
		'/--> Begin Method :: Stop
			Public Sub [Stop]() 
				Me.TimeStop = DateTime.Now
				'get the total time spent
				Me.TimeSpent = TimeSpan.FromTicks(Me.TimeStop.Ticks - Me.TimeStart.Ticks).TotalSeconds
			End Sub
		'/<-- End Method :: Stop
	End Class
'/<-- End Class :: Timer

'/##########################################################################################
</script>