<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Globalization" %>
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

//--> Begin Class :: DateTimeDriver
	public class DateTimeDriver {
		//--> Begin :: Properties
			//core
			public DateTime DateTime;
			public int Year;
			public int Month;
			public int Day;
			public int Hour;
			public int Minute;
			public int Second;
			
			//informational
			public bool IsLeapYear;
			public int DayOfWeek;
			public int DayOfYear;
			public int DaysInYear;
			public int StartDayOfMonth;
			public int EndDayOfMonth;
			public int WeekOfYear;
			public int DaysInMonth;
			public int WeeksInYear;
			public string DayName;
			public string DayNameAbbr;
			public string MonthName;
			public string MonthNameAbbr;
			
			//helpers
			public string[] DayNamesAbbr;
			public string[] DayNames;
			public string[] MonthNamesAbbr;
			public string[] MonthNames;
			public string MinValue;
			public string MaxValue;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public DateTimeDriver(int Year, int Month, int Day) {
				//set
				this.DateTime = new DateTime(Year, Month, Day);
				
				//build data
				this.BuildDateData();
				
				//refresh properties
				this.RefreshProperties();
				
				//min/max
				this.MinValue = "1901-12-13 20:45:54";
				this.MaxValue = "2038-01-19 03:14:07";
			}
			public DateTimeDriver(int Year, int Month, int Day, int Hour, int Minute, int Second) {
				//set
				this.DateTime = new DateTime(Year, Month, Day, Hour, Minute, Second);
				
				//build data
				this.BuildDateData();
				
				//refresh properties
				this.RefreshProperties();
				
				//min/max
				this.MinValue = "1901-12-13 20:45:54";
				this.MaxValue = "2038-01-19 03:14:07";
			}
			public DateTimeDriver(string Year, string Month, string Day) {
				//set
				this.DateTime = new DateTime(Convert.ToInt32(Year), Convert.ToInt32(Month), Convert.ToInt32(Day));
				
				//build data
				this.BuildDateData();
				
				//refresh properties
				this.RefreshProperties();
				
				//min/max
				this.MinValue = "1901-12-13 20:45:54";
				this.MaxValue = "2038-01-19 03:14:07";			
			}
			public DateTimeDriver(string Year, string Month, string Day, string Hour, string Minute, string Second) {
				//set
				this.DateTime = new DateTime(Convert.ToInt32(Year), Convert.ToInt32(Month), Convert.ToInt32(Day), Convert.ToInt32(Hour), Convert.ToInt32(Minute), Convert.ToInt32(Second));
				
				//build data
				this.BuildDateData();
				
				//refresh properties
				this.RefreshProperties();
				
				//min/max
				this.MinValue = "1901-12-13 20:45:54";
				this.MaxValue = "2038-01-19 03:14:07";
			}
			public DateTimeDriver(string Value) {
				//build the date data
				this.BuildDateData();
				
				//initial value
				this.DateTime = DateTime.Parse(Value);
				this.RefreshProperties();
				
				//min/max
				this.MinValue = "1901-12-13 20:45:54";
				this.MaxValue = "2038-01-19 03:14:07";
			}
			public DateTimeDriver() {
				//build the date data
				this.BuildDateData();
				
				//initial value
				this.DateTime = DateTime.Now;
				this.RefreshProperties();
				
				//min/max
				this.MinValue = "1901-12-13 20:45:54";
				this.MaxValue = "2038-01-19 03:14:07";
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Set
			public DateTimeDriver Set(int Year, int Month, int Day) {
				this.DateTime = new DateTime(Year, Month, Day);
				
				//refresh properties
				this.RefreshProperties();
				return this;
			}
			public DateTimeDriver Set(int Year, int Month, int Day, int Hour, int Minute, int Second) {
				this.DateTime = new DateTime(Year, Month, Day, Hour, Minute, Second);
				
				//refresh properties
				this.RefreshProperties();
				return this;
			}
			public DateTimeDriver Set(string Year, string Month, string Day) {
				this.DateTime = new DateTime(Convert.ToInt32(Year), Convert.ToInt32(Month), Convert.ToInt32(Day));
				
				//refresh properties
				this.RefreshProperties();
				return this;
			}
			public DateTimeDriver Set(string Year, string Month, string Day, string Hour, string Minute, string Second) {
				this.DateTime = new DateTime(Convert.ToInt32(Year), Convert.ToInt32(Month), Convert.ToInt32(Day), Convert.ToInt32(Hour), Convert.ToInt32(Minute), Convert.ToInt32(Second));
				
				//refresh properties
				this.RefreshProperties();
				return this;
			}	
		//--> End Method :: Set
		
		//##################################################################################
		
		//--> Begin Method :: RefreshProperties
			public void RefreshProperties() {
				//setup internal calendar
				CultureInfo myCultureInfo = new CultureInfo("en-US");
				System.Globalization.Calendar myCalendar = myCultureInfo.Calendar;
				CalendarWeekRule myWeekRule = CalendarWeekRule.FirstFourDayWeek;
				DayOfWeek myFirstDOW = 0;
				
				//basic
				this.Year = this.DateTime.Year;
				this.Month = this.DateTime.Month;
				this.Day = this.DateTime.Day;
				this.Hour = this.DateTime.Hour;
				this.Minute = this.DateTime.Minute;
				this.Second = this.DateTime.Second;
				
				//informational
					this.IsLeapYear = DateTime.IsLeapYear(this.DateTime.Year);
					this.DayOfWeek = (int)this.DateTime.DayOfWeek;
					this.DayOfYear = this.DateTime.DayOfYear;
					this.DaysInYear = 0;
					for(int i = 1 ; i < 13 ; i++) {
						this.DaysInYear += DateTime.DaysInMonth(this.DateTime.Year, i);
					}
					this.StartDayOfMonth = (int)DateTime.Parse(this.Month +"/1/"+ this.Year).DayOfWeek;
					this.EndDayOfMonth = (int)DateTime.Parse(this.Month +"/1/"+ this.Year).AddMonths(1).AddDays(-1).DayOfWeek;
					
					//week of year
					this.WeekOfYear = myCalendar.GetWeekOfYear(this.DateTime, myWeekRule, myFirstDOW);
					this.DaysInMonth = DateTime.DaysInMonth(this.DateTime.Year, this.DateTime.Month);
					this.WeeksInYear = myCalendar.GetWeekOfYear(DateTime.Parse("12/31/"+ this.DateTime.Year.ToString()), myWeekRule, myFirstDOW);
					this.DayName = this.DayNames[this.DayOfWeek];
					this.DayNameAbbr = this.DayNamesAbbr[this.DayOfWeek];
					this.MonthName = this.MonthNames[this.Month - 1];
					this.MonthNameAbbr = this.MonthNamesAbbr[this.Month - 1];
				//end informational
			}
		//<-- End Method :: RefreshProperties
		
		//##################################################################################
		
		//--> Begin Method :: AddSeconds
			public DateTimeDriver AddSeconds(int Value) {
				this.DateTime = this.DateTime.AddSeconds(Value);
				this.RefreshProperties();
				return this;
			}
		//<-- End Method :: AddSeconds
		
		//##################################################################################
		
		//--> Begin Method :: AddMinutes
			public DateTimeDriver AddMinutes(int Value) {
				this.DateTime = this.DateTime.AddMinutes(Value);
				this.RefreshProperties();
				return this;
			}
		//<-- End Method :: AddMinutes
		
		//##################################################################################
		
		//--> Begin Method :: AddHours
			public DateTimeDriver AddHours(int Value) {
				this.DateTime = this.DateTime.AddHours(Value);
				this.RefreshProperties();
				return this;
			}
		//<-- End Method :: AddHours
		
		//##################################################################################
		
		//--> Begin Method :: AddDays
			public DateTimeDriver AddDays(int Value) {
				this.DateTime = this.DateTime.AddDays(Value);
				this.RefreshProperties();
				return this;
			}
		//<-- End Method :: AddDays
		
		//##################################################################################
		
		//--> Begin Method :: AddMonths
			public DateTimeDriver AddMonths(int Value) {
				this.DateTime = this.DateTime.AddMonths(Value);
				this.RefreshProperties();
				return this;
			}
		//<-- End Method :: AddMonths
		
		//##################################################################################
		
		//--> Begin Method :: AddYears
			public DateTimeDriver AddYears(int Value) {
				this.DateTime = this.DateTime.AddYears(Value);
				this.RefreshProperties();
				return this;
			}
		//<-- End Method :: AddYears
		
		//##################################################################################
		
		//--> Begin Method :: Diff
			public Hashtable Diff(DateTimeDriver ToCompare) {
				//get the difference
				TimeSpan Difference = this.DateTime.Subtract(ToCompare.DateTime);
				
				//generate hash table
				Hashtable Data = new Hashtable();
				Data.Add("Milliseconds", Difference.Milliseconds);
				Data.Add("Seconds", Difference.Seconds);
				Data.Add("Minutes", Difference.Minutes);
				Data.Add("Hours", Difference.Hours);
				Data.Add("Days", Difference.Days);
				Data.Add("TotalMilliseconds", Difference.TotalMilliseconds);
				Data.Add("TotalSeconds", Difference.TotalSeconds);
				Data.Add("TotalMinutes", Difference.TotalMinutes);
				Data.Add("TotalHours", Difference.TotalHours);
				Data.Add("TotalDays", Difference.TotalDays);
				return Data;
			}
		//<-- End Method :: Diff
		
		//##################################################################################
		
		//--> Begin Method :: Now
			public DateTimeDriver Now() {
				return new DateTimeDriver();
			}
		//<-- End Method :: Now
		
		//##################################################################################
		
		//--> Begin Method :: SetMinValue
			public void SetMinValue() {
				this.DateTime = DateTime.Parse(this.MinValue);
				this.RefreshProperties();
			}
		//<-- End Method :: SetMinValue
		
		//##################################################################################
		
		//--> Begin Method :: SetMaxValue
			public void SetMaxValue() {
				this.DateTime = DateTime.Parse(this.MaxValue);
				this.RefreshProperties();
			}
		//<-- End Method :: SetMaxValue
		
		//##################################################################################
		
		//--> Begin Method :: Parse
			public DateTimeDriver Parse(string Value) {
				try{
					this.DateTime = DateTime.Parse(Value);
					this.RefreshProperties();
				}
				catch(Exception e) {
					throw new Exception("Weblegs.DateTimeDriver.Parse(): Failed to parse '"+ Value +"' as valid DateTime. "+ e.ToString());
				}
				
				return this;
			}
		//<-- End Method :: Parse
		
		//##################################################################################
		
		//--> Begin Method :: ToString
			public override string ToString() {
				return this.ToString("yyyy-MM-dd HH:mm:ss");
			}
			public string ToString(string Format) {
				//support for the [...content...] blocks
					Random RandomGen = new Random();
					char[] ValidKeyCharacters = {'a','b','c','e','f','g','i','j','k','l','p','q','r','u','v','w','x','z'};
					Hashtable SavedText = new Hashtable();
					string RegexPattern = @"(\[.*?\])";
					MatchCollection Matches = Regex.Matches(Format, RegexPattern, RegexOptions.IgnoreCase | RegexOptions.Singleline);
					for(int i = 0 ; i < Matches.Count ; i++) {
						//generate random key
						string ThisKey = "";
						for(int j = 0 ; j < 20 ; j++) {
							ThisKey += ValidKeyCharacters[RandomGen.Next(ValidKeyCharacters.Length)];
						}
						
						Match ThisMatch = Matches[i];
						SavedText.Add(ThisKey, ThisMatch.Groups[1].Value.Replace("[", "").Replace("]", ""));
						
						Format = Format.Replace(ThisMatch.Groups[1].Value, ThisKey);
					}
				//end support for the [...content...] blocks
				
				//setup internal token translation
				Format = Format.Replace("dddd", "!!!!");
				Format = Format.Replace("ddd", "!!!");
				Format = Format.Replace("dd", "!!");
				Format = Format.Replace("do", "!@");
				Format = Format.Replace("d", "!");
				Format = Format.Replace("hh", "##");
				Format = Format.Replace("ho", "#@");
				Format = Format.Replace("h", "#");
				Format = Format.Replace("HH", "==");
				Format = Format.Replace("HO", "=@");
				Format = Format.Replace("H", "=");
				Format = Format.Replace("mm", "%%");
				Format = Format.Replace("mo", "%@");
				Format = Format.Replace("m", "%");
				Format = Format.Replace("MMMM", "^^^^");
				Format = Format.Replace("MMM", "^^^");
				Format = Format.Replace("MM", "^^");
				Format = Format.Replace("MO", "^@");
				Format = Format.Replace("M", "^");
				Format = Format.Replace("ss", "&&");
				Format = Format.Replace("so", "&@");
				Format = Format.Replace("s", "&");
				Format = Format.Replace("tt", "**");
				Format = Format.Replace("t", "*");
				Format = Format.Replace("TT", "__");
				Format = Format.Replace("T", "_");
				Format = Format.Replace("yyyyo", "~~~~@");
				Format = Format.Replace("yyyy", "~~~~");
				Format = Format.Replace("yy", "~~");
				
				//translate internal tokens
				Format = Format.Replace("!!!!", this.DayName);
				Format = Format.Replace("!!!", this.DayNameAbbr);
				Format = Format.Replace("!!", this.DateTime.ToString("dd"));
				Format = Format.Replace("!@", this.OrdinalSuffix(this.Day));
				Format = Format.Replace("!", this.DateTime.ToString("%d"));
				Format = Format.Replace("##", this.DateTime.ToString("hh"));
				Format = Format.Replace("#@", this.OrdinalSuffix(Convert.ToInt32(this.DateTime.ToString("hh"))));
				Format = Format.Replace("#", this.DateTime.ToString("%h"));
				Format = Format.Replace("==", this.DateTime.ToString("HH"));
				Format = Format.Replace("=@", this.OrdinalSuffix(this.Hour));
				Format = Format.Replace("=", this.DateTime.ToString("%H"));
				Format = Format.Replace("%%", this.DateTime.ToString("mm"));
				Format = Format.Replace("%@", this.OrdinalSuffix(this.Minute));
				Format = Format.Replace("%", this.DateTime.ToString("%m"));
				Format = Format.Replace("^^^^", this.DateTime.ToString("MMMM"));
				Format = Format.Replace("^^^", this.DateTime.ToString("MMM"));
				Format = Format.Replace("^^", this.DateTime.ToString("MM"));
				Format = Format.Replace("^@", this.OrdinalSuffix(this.Month));
				Format = Format.Replace("^", this.DateTime.ToString("%M"));
				Format = Format.Replace("&&", this.DateTime.ToString("ss"));
				Format = Format.Replace("&@", this.OrdinalSuffix(this.Second));
				Format = Format.Replace("&", this.DateTime.ToString("%s"));
				Format = Format.Replace("**", this.DateTime.ToString("tt").ToLower());
				Format = Format.Replace("*", this.DateTime.ToString("%t").ToLower());
				Format = Format.Replace("__", this.DateTime.ToString("tt"));
				Format = Format.Replace("_", this.DateTime.ToString("%t"));
				Format = Format.Replace("~~~~@", this.OrdinalSuffix(this.Year));
				Format = Format.Replace("~~~~", this.DateTime.ToString("yyyy"));
				Format = Format.Replace("~~", this.DateTime.ToString("yy"));
				
				//replace keys in string
				foreach(string Key in SavedText.Keys) {
					Format = Format.Replace(Key.ToString(), SavedText[Key].ToString());
				}
				
				return Format;
			}
		//<-- End Method :: ToString
		
		//##################################################################################
		//##################################################################################
		//##################################################################################
		
		//--> Begin Method :: OrdinalSuffix
			public string OrdinalSuffix(int Value) {
				//format numbers with 'st', 'nd', 'rd', 'th'
				string Abr = "";
				string strNumber = Value.ToString();
				
				string strLastNumber = strNumber.Substring(strNumber.Length -1);
				string strLastTwoNumbers = strNumber.Substring(strNumber.Length -1);
				if(strNumber.Length >= 2) {
					strLastTwoNumbers = strNumber.Substring(strNumber.Length -2);
				}
				else {
					strLastTwoNumbers = strLastNumber;
				}
				
				switch(strLastNumber) {
					case "1":
						if(strLastTwoNumbers == "11") {Abr = "th";} else {Abr = "st";}
						break; //out of switch
					case "2":
						if(strLastTwoNumbers == "12") {Abr = "th";} else {Abr = "nd";}
						break; //out of switch
					case "3":
						if(strLastTwoNumbers == "13") {Abr = "th";} else {Abr = "rd";}
						break; //out of switch
					case "4": case "5": case "6": case "7": case "8": case "9": case "0":
						Abr = "th";
						break; //out of switch
					default:
						Abr = "";
						break; //out of switch
				}
				
				return strNumber + Abr;
			}
		//<-- End Method :: OrdinalSuffix
		
		//##################################################################################
		
		//--> Begin Method :: BuildDateData
			public void BuildDateData() {
				//day name abbrs
				this.DayNamesAbbr = new string[7];
				this.DayNamesAbbr[0] = "Sun";
				this.DayNamesAbbr[1] = "Mon";
				this.DayNamesAbbr[2] = "Tue";
				this.DayNamesAbbr[3] = "Wed";
				this.DayNamesAbbr[4] = "Thu";
				this.DayNamesAbbr[5] = "Fri";
				this.DayNamesAbbr[6] = "Sat";
				
				//day names
				this.DayNames = new string[7];
				this.DayNames[0] = "Sunday";
				this.DayNames[1] = "Monday";
				this.DayNames[2] = "Tuesday";
				this.DayNames[3] = "Wednesday";
				this.DayNames[4] = "Thursday";
				this.DayNames[5] = "Friday";
				this.DayNames[6] = "Saturday";
				
				//month name abbrs
				this.MonthNamesAbbr = new string[12];
				this.MonthNamesAbbr[0] = "Jan";
				this.MonthNamesAbbr[1] = "Feb";
				this.MonthNamesAbbr[2] = "Mar";
				this.MonthNamesAbbr[3] = "Apr";
				this.MonthNamesAbbr[4] = "May";
				this.MonthNamesAbbr[5] = "Jun";
				this.MonthNamesAbbr[6] = "Jul";
				this.MonthNamesAbbr[7] = "Aug";
				this.MonthNamesAbbr[8] = "Sep";
				this.MonthNamesAbbr[9] = "Oct";
				this.MonthNamesAbbr[10] = "Nov";
				this.MonthNamesAbbr[11] = "Dec";
				
				//month names
				this.MonthNames = new string[12];
				this.MonthNames[0] = "January";
				this.MonthNames[1] = "February";
				this.MonthNames[2] = "March";
				this.MonthNames[3] = "April";
				this.MonthNames[4] = "May";
				this.MonthNames[5] = "June";
				this.MonthNames[6] = "July";
				this.MonthNames[7] = "August";
				this.MonthNames[8] = "September";
				this.MonthNames[9] = "October";
				this.MonthNames[10] = "November";
				this.MonthNames[11] = "December";
			}
		//<-- End Method :: BuildDateData
		
	}
//<-- End Class :: DateTimeDriver

//##########################################################################################
</script>