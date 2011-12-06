<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Globalization" %>
<script language="vb" runat="server">
'/##########################################################################################

'/*
'Copyright (C) 2005-2010 WebLegs, Inc.
'This program is free software: you can redistribute it and/or modify it under the terms
'of the GNU General Public License as published by the Free Software Foundation, either
'version 3 of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
'without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
'See the GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License along with this program.
'If not, see <http://www.gnu.org/licenses/>.
'*/

'/##########################################################################################

'/--> Begin Class :: DateTimeDriver
	Public Class DateTimeDriver 
		'/--> Begin :: Properties
			'core
			Public DateTime As DateTime
			Public Year As Integer
			Public Month As Integer
			Public Day As Integer
			Public Hour As Integer
			Public Minute As Integer
			Public Second As Integer
			
			'informational
			Public IsLeapYear As Boolean
			Public DayOfWeek As Integer
			Public DayOfYear As Integer
			Public DaysInYear As Integer
			Public MonthOfYear As Integer
			Public StartDayOfMonth As Integer
			Public EndDayOfMonth As Integer
			Public WeekOfYear As Integer
			Public DaysInMonth As Integer
			Public WeeksInYear As Integer
			Public DayName As String
			Public DayNameAbbr As String
			Public MonthName As String
			Public MonthNameAbbr As String
			
			'helpers
			Public DayNamesAbbr(7) As String
			Public DayNames(7) As String
			Public MonthNamesAbbr(12) As String
			Public MonthNames(12) As String
			Public MinValue As String
			Public MaxValue As String
		'<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New(Year As Integer, Month As Integer, Day As Integer)
				'//set
				Me.DateTime = new DateTime(Year, Month, Day)
				
				'//build data
				Me.BuildDateData()
				
				'//refresh properties
				Me.RefreshProperties()
				
				'min/max
				Me.MinValue = "1901-12-13 20:45:54"
				Me.MaxValue = "2038-01-19 03:14:07"
			End Sub
			Public Sub New(Year As Integer, Month As Integer, Day As Integer, Hour As Integer, Minute As Integer, Second As Integer)		
				'//set
				Me.DateTime = new DateTime(Year, Month, Day, Hour, Minute, Second)
				
				'//build data
				Me.BuildDateData()
				
				'//refresh properties
				Me.RefreshProperties()
				
				'min/max
				Me.MinValue = "1901-12-13 20:45:54"
				Me.MaxValue = "2038-01-19 03:14:07"
			End Sub
			Public Sub New(Year As String, Month As String, Day As String)
				'//set
				Me.DateTime = new DateTime(Convert.ToInt32(Year), Convert.ToInt32(Month), Convert.ToInt32(Day))
				
				'//build data
				Me.BuildDateData()
				
				'//refresh properties
				Me.RefreshProperties()
				
				'min/max
				Me.MinValue = "1901-12-13 20:45:54"
				Me.MaxValue = "2038-01-19 03:14:07"
			End Sub
			Public Sub New(Year As String, Month As String, Day As String, Hour As String, Minute As String, Second As String)
				'//set
				Me.DateTime = new DateTime(Convert.ToInt32(Year), Convert.ToInt32(Month), Convert.ToInt32(Day), Convert.ToInt32(Hour), Convert.ToInt32(Minute), Convert.ToInt32(Second))
				
				'//build data
				Me.BuildDateData()
				
				'//refresh properties
				Me.RefreshProperties()
				
				'min/max
				Me.MinValue = "1901-12-13 20:45:54"
				Me.MaxValue = "2038-01-19 03:14:07"
			End Sub
			Public Sub New(Value As String) 
				'build the date data
				Me.BuildDateData()
				
				'initial value
				Me.DateTime = DateTime.Parse(Value)
				Me.RefreshProperties()
				
				'min/max
				Me.MinValue = "1901-12-13 20:45:54"
				Me.MaxValue = "2038-01-19 03:14:07"
			End Sub
			Public Sub New() 
				'build the date data
				Me.BuildDateData()
				
				'initial value
				Me.DateTime = DateTime.Now
				Me.RefreshProperties()
				
				'min/max
				Me.MinValue = "1901-12-13 20:45:54"
				Me.MaxValue = "2038-01-19 03:14:07"
			End Sub
		'<-- End :: Constructor
		
		'//##################################################################################
		
		'//--> Begin Method :: Set
			Public Function [Set](Year As Integer, Month As Integer, Day As Integer) As DateTimeDriver
				Me.DateTime = new DateTime(Year, Month, Day)
				
				'//refresh properties
				Me.RefreshProperties()
				Return Me
			End Function
			Public Function [Set](Year As Integer, Month As Integer, Day As Integer, Hour As Integer, Minute As Integer, Second As Integer) As DateTimeDriver
				Me.DateTime = new DateTime(Year, Month, Day, Hour, Minute, Second)
				
				'//refresh properties
				Me.RefreshProperties()
				Return Me
			End Function
			Public Function [Set](Year As String, Month As String, Day As String) As DateTimeDriver
				Me.DateTime = new DateTime(Convert.ToInt32(Year), Convert.ToInt32(Month), Convert.ToInt32(Day))
				
				'//refresh properties
				Me.RefreshProperties()
				Return Me
			End Function
			Public Function [Set](Year As String, Month As String, Day As String, Hour As String, Minute As String, Second As String) As DateTimeDriver
				Me.DateTime = new DateTime(Convert.ToInt32(Year), Convert.ToInt32(Month), Convert.ToInt32(Day), Convert.ToInt32(Hour), Convert.ToInt32(Minute), Convert.ToInt32(Second))
				
				'//refresh properties
				Me.RefreshProperties()
				Return Me
			End Function	
		'//--> End Method :: Set
		
		'/##################################################################################
		
		'/--> Begin Method :: RefreshProperties
			Public Sub RefreshProperties()
				'setup Integerernal calendar
				Dim myCultureInfo As CultureInfo = New CultureInfo("en-US")
				Dim myCalendar As System.Globalization.Calendar = myCultureInfo.Calendar
				Dim myWeekRule As CalendarWeekRule = CalendarWeekRule.FirstFourDayWeek
				Dim myFirstDOW As DayOfWeek = 0
				
				'basic
				Me.Year = Me.DateTime.Year
				Me.Month = Me.DateTime.Month
				Me.Day = Me.DateTime.Day
				Me.Hour = Me.DateTime.Hour
				Me.Minute = Me.DateTime.Minute
				Me.Second = Me.DateTime.Second
				
				'informational
					Me.IsLeapYear = DateTime.IsLeapYear(Me.DateTime.Year)
					Me.DayOfWeek = CType(Me.DateTime.DayOfWeek, Integer)
					Me.DayOfYear = Me.DateTime.DayOfYear
					Me.DaysInYear = 0
					For i As Integer = 1  To 12
						Me.DaysInYear += DateTime.DaysInMonth(Me.DateTime.Year, i)
					Next
					Me.StartDayOfMonth = CType(DateTime.Parse(Me.Month &"/1/"& Me.Year).DayOfWeek, Integer)
					Me.EndDayOfMonth = CType(DateTime.Parse(Me.Month &"/1/"& Me.Year).AddMonths(1).AddDays(-1).DayOfWeek, Integer)
					
					'week of year
					Me.WeekOfYear = myCalendar.GetWeekOfYear(Me.DateTime, myWeekRule, myFirstDOW)
					Me.DaysInMonth = DateTime.DaysInMonth(Me.DateTime.Year, Me.DateTime.Month)
					
					Me.WeeksInYear = myCalendar.GetWeekOfYear(DateTime.Parse("12/31/"& Me.DateTime.Year.ToString()), myWeekRule, myFirstDOW)
					Me.DayName = Me.DayNames(Me.DayOfWeek)
					Me.DayNameAbbr = Me.DayNamesAbbr(Me.DayOfWeek)
					Me.MonthName = Me.MonthNames(Me.Month - 1)
					Me.MonthNameAbbr = Me.MonthNamesAbbr(Me.Month - 1)
				'end informational
			End Sub
		'<-- End Method :: RefreshProperties
		
		'/##################################################################################
		
		'/--> Begin Method :: AddSeconds
			Public Function AddSeconds(Value As Integer) As DateTimeDriver 
				Me.DateTime = Me.DateTime.AddSeconds(Value)
				Me.RefreshProperties()
				Return Me
			End Function
		'<-- End Method :: AddSeconds
		
		'/##################################################################################
		
		'/--> Begin Method :: AddMinutes
			Public Function AddMinutes(Value As Integer) As DateTimeDriver
				Me.DateTime = Me.DateTime.AddMinutes(Value)
				Me.RefreshProperties()
				Return Me
			End Function
		'<-- End Method :: AddMinutes
		
		'/##################################################################################
		
		'/--> Begin Method :: AddHours
			Public Function AddHours(Value As Integer) As DateTimeDriver 
				Me.DateTime = Me.DateTime.AddHours(Value)
				Me.RefreshProperties()
				Return Me
			End Function
		'<-- End Method :: AddHours
		
		'/##################################################################################
		
		'/--> Begin Method :: AddDays
			Public Function AddDays(Value As Integer) As DateTimeDriver 
				Me.DateTime = Me.DateTime.AddDays(Value)
				Me.RefreshProperties()
				Return Me
			End Function
		'<-- End Method :: AddDays
		
		'/##################################################################################
		
		'/--> Begin Method :: AddMonths
			Public Function AddMonths(Value As Integer) As DateTimeDriver
				Me.DateTime = Me.DateTime.AddMonths(Value)
				Me.RefreshProperties()
				Return Me
			End Function
		'<-- End Method :: AddMonths
		
		'/##################################################################################
		
		'/--> Begin Method :: AddYears
			Public Function AddYears(Value As Integer) As DateTimeDriver 
				Me.DateTime = Me.DateTime.AddYears(Value)
				Me.RefreshProperties()
				Return Me
			End Function
		'<-- End Method :: AddYears
		
		'/##################################################################################
		
		'/--> Begin Method :: Diff
			Public Function Diff(ToCompare As DateTimeDriver) As Hashtable 
				'get the difference
				Dim Difference As TimeSpan = Me.DateTime.Subtract(ToCompare.DateTime)
				
				'generate hash table
				Dim Data As Hashtable = New Hashtable()
				Data.Add("Milliseconds", Difference.Milliseconds)
				Data.Add("Seconds", Difference.Seconds)
				Data.Add("Minutes", Difference.Minutes)
				Data.Add("Hours", Difference.Hours)
				Data.Add("Days", Difference.Days)
				Data.Add("TotalMilliseconds", Difference.TotalMilliseconds)
				Data.Add("TotalSeconds", Difference.TotalSeconds)
				Data.Add("TotalMinutes", Difference.TotalMinutes)
				Data.Add("TotalHours", Difference.TotalHours)
				Data.Add("TotalDays", Difference.TotalDays)
				Return Data
			End Function
		'<-- End Method :: Diff
		
		'/##################################################################################
		
		'/--> Begin Method :: Now
			Public Function Now() As DateTimeDriver 
				Return New DateTimeDriver()
			End Function
		'<-- End Method :: Now
		
		'/##################################################################################
		
		'/--> Begin Method :: SetMinValue
			Public Sub SetMinValue() 
				Me.DateTime = DateTime.Parse(Me.MinValue)
				Me.RefreshProperties()
			End Sub
		'<-- End Method :: SetMinValue
		
		'/##################################################################################
		
		'/--> Begin Method :: SetMaxValue
			Public Sub SetMaxValue() 
				Me.DateTime = DateTime.Parse(Me.MaxValue)
				Me.RefreshProperties()
			End Sub
		'<-- End Method :: SetMaxValue
		
		'/##################################################################################
		
		'/--> Begin Method :: Parse
			Public Function Parse(Value As String) As DateTimeDriver 
				Try
					Me.DateTime = DateTime.Parse(Value)
					Me.RefreshProperties()
				Catch e As Exception 
					Throw New Exception("Weblegs.DateTimeDriver.Parse(): Failed to parse '"& Value &"' as valid DateTime. "& e.ToString())
				End Try
				
				Return Me
			End Function
		'<-- End Method :: Parse
		
		'/##################################################################################
		
		'/--> Begin Method :: ToString
			Public Overrides Function ToString() As String
				Return Me.ToString("yyyy-MM-dd HH:mm:ss")
			End Function
			Public Overloads Function ToString(Format As String) As String 
				'support for the (...content...) blocks
					Dim RandomGen As Random = New Random()
					Dim ValidKeyCharacters As Char() = {"a", "b", "c", "e", "f", "g", "i", "j", "k", "l", "p", "q", "r", "u", "v", "w", "x", "z"}
					Dim SavedText As Hashtable = New Hashtable()
					Dim RegexPattern As String = "(\[.*?\])"
					Dim Matches As MatchCollection = Regex.Matches(Format, RegexPattern, RegexOptions.IgnoreCase Or RegexOptions.Singleline)
					For i As Integer = 0 To Matches.Count - 1
						'generate random key
						Dim ThisKey As String = ""
						For j As Integer = 0  To 20 - 1
							ThisKey &= ValidKeyCharacters(RandomGen.Next(ValidKeyCharacters.Length))
						Next
						
						Dim ThisMatch As Match = Matches(i)
						SavedText.Add(ThisKey, ThisMatch.Groups(1).Value.Replace("[", "").Replace("]", ""))
						
						Format = Format.Replace(ThisMatch.Groups(1).Value, ThisKey)
					Next
				'end support for the (...content...) blocks
				
				'setup Integerernal token translation
				Format = Format.Replace("dddd", "!!!!")
				Format = Format.Replace("ddd", "!!!")
				Format = Format.Replace("dd", "!!")
				Format = Format.Replace("do", "!@")
				Format = Format.Replace("d", "!")
				Format = Format.Replace("hh", "##")
				Format = Format.Replace("ho", "#@")
				Format = Format.Replace("h", "#")
				Format = Format.Replace("HH", "==")
				Format = Format.Replace("HO", "=@")
				Format = Format.Replace("H", "=")
				Format = Format.Replace("mm", "%%")
				Format = Format.Replace("mo", "%@")
				Format = Format.Replace("m", "%")
				Format = Format.Replace("MMMM", "^^^^")
				Format = Format.Replace("MMM", "^^^")
				Format = Format.Replace("MM", "^^")
				Format = Format.Replace("MO", "^@")
				Format = Format.Replace("M", "^")
				Format = Format.Replace("ss", "&&")
				Format = Format.Replace("so", "&@")
				Format = Format.Replace("s", "&")
				Format = Format.Replace("tt", "**")
				Format = Format.Replace("t", "*")
				Format = Format.Replace("TT", "__")
				Format = Format.Replace("T", "_")
				Format = Format.Replace("yyyyo", "~~~~@")
				Format = Format.Replace("yyyy", "~~~~")
				Format = Format.Replace("yy", "~~")
				
				'translate Integerernal tokens
				Format = Format.Replace("!!!!", Me.DayName)
				Format = Format.Replace("!!!", Me.DayNameAbbr)
				Format = Format.Replace("!!", Me.DateTime.ToString("dd"))
				Format = Format.Replace("!@", Me.OrdinalSuffix(Me.Day))
				Format = Format.Replace("!", Me.DateTime.ToString("%d"))
				Format = Format.Replace("##", Me.DateTime.ToString("hh"))
				Format = Format.Replace("#@", Me.OrdinalSuffix(CType(Me.DateTime.ToString("hh"), Integer)))
				Format = Format.Replace("#", Me.DateTime.ToString("%h"))
				Format = Format.Replace("==", Me.DateTime.ToString("HH"))
				Format = Format.Replace("=@", Me.OrdinalSuffix(Me.Hour))
				Format = Format.Replace("=", Me.DateTime.ToString("%H"))
				Format = Format.Replace("%%", Me.DateTime.ToString("mm"))
				Format = Format.Replace("%@", Me.OrdinalSuffix(Me.Minute))
				Format = Format.Replace("%", Me.DateTime.ToString("%m"))
				Format = Format.Replace("^^^^", Me.DateTime.ToString("MMMM"))
				Format = Format.Replace("^^^", Me.DateTime.ToString("MMM"))
				Format = Format.Replace("^^", Me.DateTime.ToString("MM"))
				Format = Format.Replace("^@", Me.OrdinalSuffix(Me.Month))
				Format = Format.Replace("^", Me.DateTime.ToString("%M"))
				Format = Format.Replace("&&", Me.DateTime.ToString("ss"))
				Format = Format.Replace("&@", Me.OrdinalSuffix(Me.Second))
				Format = Format.Replace("&", Me.DateTime.ToString("%s"))
				Format = Format.Replace("**", Me.DateTime.ToString("tt").ToLower())
				Format = Format.Replace("*", Me.DateTime.ToString("%t").ToLower())
				Format = Format.Replace("__", Me.DateTime.ToString("tt"))
				Format = Format.Replace("_", Me.DateTime.ToString("%t"))
				Format = Format.Replace("~~~~@", Me.OrdinalSuffix(Me.Year))
				Format = Format.Replace("~~~~", Me.DateTime.ToString("yyyy"))
				Format = Format.Replace("~~", Me.DateTime.ToString("yy"))
				
				'replace keys in String
				For Each Key As String In SavedText.Keys
					Format = Format.Replace(Key.ToString(), SavedText(Key).ToString())
				Next
				
				Return Format
			End Function
		'<-- End Method :: ToString
		
		'/##################################################################################
		'/##################################################################################
		'/##################################################################################
		
		'/--> Begin Method :: OrdinalSuffix
			Public Function OrdinalSuffix(Value As Integer) As String 
				'format numbers with 'st', 'nd', 'rd', 'th'
				Dim Abr As String = ""
				Dim strNumber As String = Value.ToString()
				
				Dim strLastNumber As String = strNumber.SubString(strNumber.Length -1)
				Dim strLastTwoNumbers As String = strNumber.SubString(strNumber.Length -1)
				If strNumber.Length >= 2 Then
					strLastTwoNumbers = strNumber.SubString(strNumber.Length -2)
				Else 
					strLastTwoNumbers = strLastNumber
				End If
				
				Select Case strLastNumber
					Case "1"
						If strLastTwoNumbers = "11" Then Abr = "th" Else Abr = "st"
					Case "2"
						If strLastTwoNumbers = "12" Then Abr = "th" Else Abr = "nd"
					Case "3"
						If strLastTwoNumbers = "13" Then Abr = "th" Else Abr = "rd"
					Case "4", "5", "6", "7", "8", "9", "0"
						Abr = "th"
					Case Else
						Abr = ""
				End Select
				
				Return strNumber & Abr
			End Function
		'<-- End Method :: OrdinalSuffix
		
		'/##################################################################################
		
		'/--> Begin Method :: BuildDateData
			Public Sub BuildDateData() 
				'day name abbrs
				Me.DayNamesAbbr(0) = "Sun"
				Me.DayNamesAbbr(1) = "Mon"
				Me.DayNamesAbbr(2) = "Tue"
				Me.DayNamesAbbr(3) = "Wed"
				Me.DayNamesAbbr(4) = "Thu"
				Me.DayNamesAbbr(5) = "Fri"
				Me.DayNamesAbbr(6) = "Sat"
				
				'day names
				Me.DayNames(0) = "Sunday"
				Me.DayNames(1) = "Monday"
				Me.DayNames(2) = "Tuesday"
				Me.DayNames(3) = "Wednesday"
				Me.DayNames(4) = "Thursday"
				Me.DayNames(5) = "Friday"
				Me.DayNames(6) = "Saturday"
				
				'month name abbrs
				Me.MonthNamesAbbr(0) = "Jan"
				Me.MonthNamesAbbr(1) = "Feb"
				Me.MonthNamesAbbr(2) = "Mar"
				Me.MonthNamesAbbr(3) = "Apr"
				Me.MonthNamesAbbr(4) = "May"
				Me.MonthNamesAbbr(5) = "Jun"
				Me.MonthNamesAbbr(6) = "Jul"
				Me.MonthNamesAbbr(7) = "Aug"
				Me.MonthNamesAbbr(8) = "Sep"
				Me.MonthNamesAbbr(9) = "Oct"
				Me.MonthNamesAbbr(10) = "Nov"
				Me.MonthNamesAbbr(11) = "Dec"
				
				'month names
				Me.MonthNames(0) = "January"
				Me.MonthNames(1) = "February"
				Me.MonthNames(2) = "March"
				Me.MonthNames(3) = "April"
				Me.MonthNames(4) = "May"
				Me.MonthNames(5) = "June"
				Me.MonthNames(6) = "July"
				Me.MonthNames(7) = "August"
				Me.MonthNames(8) = "September"
				Me.MonthNames(9) = "October"
				Me.MonthNames(10) = "November"
				Me.MonthNames(11) = "December"
			End Sub
		'<-- End Method :: BuildDateData
		
	End Class
'/<-- End Class :: DateTimeDriver

'/##########################################################################################
</script>