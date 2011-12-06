<%@ page import="java.util.Date" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.Math" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.util.Enumeration" %>
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

//--> Begin Class :: DateTimeDriver
	public class DateTimeDriver{
		//--> Begin :: Properties
			//core
			public Calendar DateTime;
			public int Year;
			public int Month;
			public int Day;
			public int Hour;
			public int Minute;
			public int Second;
			
			//informational
			public boolean IsLeapYear;
			public int DayOfWeek;
			public int DayOfYear;
			public int DaysInYear;
			public int StartDayOfMonth;
			public int EndDayOfMonth;
			public int WeekOfYear;
			public int DaysInMonth;
			public int WeeksInYear;
			public String DayName;
			public String DayNameAbbr;
			public String MonthName;
			public String MonthNameAbbr;
			
			//helpers
			public String[] DayNamesAbbr;
			public String[] DayNames;
			public String[] MonthNamesAbbr;
			public String[] MonthNames;
			public String MinValue;
			public String MaxValue;
			
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public DateTimeDriver(int Year, int Month, int Day) throws Exception {
				//create new calendar
				this.DateTime = Calendar.getInstance();
				
				//set
				this.DateTime.set(Year, Month -1, Day, 0, 0, 0);
								
				//build data
				this.BuildDateData();
				
				//set max value and min value
					Calendar tmpCal = this.DateTime;
					this.SetMaxValue();
					this.MaxValue = this.ToString();
					this.SetMinValue();
					this.MinValue = this.ToString();
					
					//reset
					this.DateTime = tmpCal;
				//end set max value and min value
				
				//refresh properties
				this.RefreshProperties();
			}
			public DateTimeDriver(int Year, int Month, int Day, int Hour, int Minute, int Second) throws Exception {
				//create new calendar
				this.DateTime = Calendar.getInstance();
								
				//set
				this.DateTime.set(Year, Month - 1, Day, Hour, Minute, Second);
				
				//build data
				this.BuildDateData();
				
				//set max value and min value
					Calendar tmpCal = this.DateTime;
					this.SetMaxValue();
					this.MaxValue = this.ToString();
					this.SetMinValue();
					this.MinValue = this.ToString();
					
					//reset
					this.DateTime = tmpCal;
				//end set max value and min value
				
				//refresh properties
				this.RefreshProperties();
			}
			public DateTimeDriver(String Year, String Month, String Day) throws Exception {
				//create new calendar
				this.DateTime = Calendar.getInstance();
				
				//set
				this.DateTime.set(Integer.valueOf(Year), Integer.valueOf(Month) - 1, Integer.valueOf(Day));
				
				//build data
				this.BuildDateData();
				
				//set max value and min value
					Calendar tmpCal = this.DateTime;
					this.SetMaxValue();
					this.MaxValue = this.ToString();
					this.SetMinValue();
					this.MinValue = this.ToString();
					
					//reset
					this.DateTime = tmpCal;
				//end set max value and min value
				
				//refresh properties
				this.RefreshProperties();
			}
			public DateTimeDriver(String Year, String Month, String Day, String Hour, String Minute, String Second) throws Exception {
				//create new calendar
				this.DateTime = Calendar.getInstance();
				
				//set
				this.DateTime.set(Integer.valueOf(Year), Integer.valueOf(Month) - 1, Integer.valueOf(Day), Integer.valueOf(Hour), Integer.valueOf(Minute), Integer.valueOf(Second));
				
				//build data
				this.BuildDateData();
				
				//set max value and min value
					Calendar tmpCal = this.DateTime;
					this.SetMaxValue();
					this.MaxValue = this.ToString();
					this.SetMinValue();
					this.MinValue = this.ToString();
					
					//reset
					this.DateTime = tmpCal;
				//end set max value and min value
				
				//refresh properties
				this.RefreshProperties();
			}
			public DateTimeDriver(String Value) throws Exception {
				//create new calendar
				this.DateTime = Calendar.getInstance();
				
				//build data
				this.BuildDateData();
				
				//set max value and min value
					Calendar tmpCal = this.DateTime;
					this.SetMaxValue();
					this.MaxValue = this.ToString();
					this.SetMinValue();
					this.MinValue = this.ToString();
					
					//reset
					this.DateTime = tmpCal;
				//end set max value and min value
				
				//parse
				this.Parse(Value);
			}
			public DateTimeDriver() throws Exception {
				//create new calendar
				this.DateTime = Calendar.getInstance();
				
				//build data
				this.BuildDateData();
				
				//set max value and min value
					Calendar tmpCal = this.DateTime;
					this.SetMaxValue();
					this.MaxValue = this.ToString();
					this.SetMinValue();
					this.MinValue = this.ToString();
					
					//reset
					this.DateTime = tmpCal;
				//end set max value and min value
				
				//refresh properties
				this.RefreshProperties();
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: Set
			public DateTimeDriver Set(int Year, int Month, int Day) {
				this.DateTime.set(Year, Month - 1, Day);
				
				//refresh properties
				this.RefreshProperties();
				return this;
			}
			public DateTimeDriver Set(int Year, int Month, int Day, int Hour, int Minute, int Second) {
				this.DateTime.set(Year, Month - 1, Day, Hour, Minute, Second);
				
				//refresh properties
				this.RefreshProperties();
				return this;
			}
			public DateTimeDriver Set(String Year, String Month, String Day) {
				this.DateTime.set(Integer.valueOf(Year), Integer.valueOf(Month) - 1, Integer.valueOf(Day));
				
				//refresh properties
				this.RefreshProperties();
				return this;
			}
			public DateTimeDriver Set(String Year, String Month, String Day, String Hour, String Minute, String Second) {
				this.DateTime.set(Integer.valueOf(Year), Integer.valueOf(Month) - 1, Integer.valueOf(Day), Integer.valueOf(Hour), Integer.valueOf(Minute), Integer.valueOf(Second));
				
				//refresh properties
				this.RefreshProperties();
				return this;
			}	
		//--> End Method :: Set
		
		//##################################################################################
		
		//--> Begin Method :: RefreshProperties
			public void RefreshProperties() {
				//set properties
				this.Year = this.DateTime.get(this.DateTime.YEAR);
				this.Month = this.DateTime.get(this.DateTime.MONTH) + 1;
				this.Day = this.DateTime.get(this.DateTime.DAY_OF_MONTH);
				this.Hour = this.DateTime.get(this.DateTime.HOUR_OF_DAY);
				this.Minute = this.DateTime.get(this.DateTime.MINUTE);
				this.Second = this.DateTime.get(this.DateTime.SECOND);
				
				//get start day of month
				Calendar TmpCal = Calendar.getInstance();
				TmpCal.set(this.Year, this.DateTime.get(this.DateTime.MONTH), 1);
				this.StartDayOfMonth = TmpCal.get(TmpCal.DAY_OF_WEEK);
				
				//get end day of month
				TmpCal.set(this.Year, this.DateTime.get(this.DateTime.MONTH), this.DateTime.getActualMaximum(this.DateTime.DAY_OF_MONTH));
				this.EndDayOfMonth = TmpCal.get(TmpCal.DAY_OF_WEEK);
				
				this.DaysInYear = this.DateTime.getActualMaximum(this.DateTime.DAY_OF_YEAR);
				this.WeekOfYear = this.DateTime.get(this.DateTime.WEEK_OF_YEAR);
				this.DaysInMonth = this.DateTime.getActualMaximum(this.DateTime.DAY_OF_MONTH);
				this.WeeksInYear = this.DateTime.getActualMaximum(Calendar.WEEK_OF_YEAR);
				this.DayOfWeek = this.DateTime.get(this.DateTime.DAY_OF_WEEK);
				this.DayOfYear = this.DateTime.get(this.DateTime.DAY_OF_YEAR);
				this.DayName = this.DayNames[this.DateTime.get(this.DateTime.DAY_OF_WEEK) - 1];
				this.DayNameAbbr = this.DayNamesAbbr[this.DateTime.get(this.DateTime.DAY_OF_WEEK) - 1];
				this.MonthName = this.MonthNames[this.Month - 1];
				this.MonthNameAbbr = this.MonthNamesAbbr[this.Month - 1];
				
				//determine if this is a leap year
				if(this.Year % 4 == 0){
					if(this.Year % 100 != 0){
						this.IsLeapYear = true;
					}
					else if(this.Year % 400 == 0){
						this.IsLeapYear = true;
					}
					else{
						this.IsLeapYear = false;
					}
				}
				else{
					this.IsLeapYear = false;
				}
			}
		//<-- End Method :: RefreshProperties
		
		//##################################################################################
		
		//--> Begin Method :: AddSeconds
			public DateTimeDriver AddSeconds(int Value) {
				//modify date
				this.DateTime.add(Calendar.SECOND, Value);
				
				//refresh properties
				this.RefreshProperties();
				
				return this;
			}
		//<-- End Method :: AddSeconds
		
		//##################################################################################
		
		//--> Begin Method :: AddMinutes
			public DateTimeDriver AddMinutes(int Value) {
				//modify date
				this.DateTime.add(Calendar.MINUTE, Value);
				
				//refresh properties
				this.RefreshProperties();
				
				return this;
			}
		//<-- End Method :: AddMinutes
		
		//##################################################################################
		
		//--> Begin Method :: AddHours
			public DateTimeDriver AddHours(int Value) {
				//modify date
				this.DateTime.add(Calendar.HOUR, Value);
				
				//refresh properties
				this.RefreshProperties();
				
				return this;
			}
		//<-- End Method :: AddHours
		
		//##################################################################################
		
		//--> Begin Method :: AddDays
			public DateTimeDriver AddDays(int Value) {
				//modify date
				this.DateTime.add(Calendar.DATE, Value);
				
				//refresh properties
				this.RefreshProperties();
				
				return this;
			}
		//<-- End Method :: AddDays
		
		//##################################################################################
		
		//--> Begin Method :: AddMonths
			public DateTimeDriver AddMonths(int Value) {
				//modify date
				this.DateTime.add(Calendar.MONTH, Value);
				
				//refresh properties
				this.RefreshProperties();
				
				return this;
			}
		//<-- End Method :: AddMonths
		
		//##################################################################################
		
		//--> Begin Method :: AddYears
			public DateTimeDriver AddYears(int Value) {
				//modify date
				this.DateTime.add(Calendar.YEAR, Value);
				
				//refresh properties
				this.RefreshProperties();
				
				return this;
			}
		//<-- End Method :: AddYears
			
		//##################################################################################
		
		//--> Begin Method :: Diff
			public Hashtable Diff(DateTimeDriver ToCompare) {
				//create new hashtable
				Hashtable Data = new Hashtable();
				
				//create container calendars
				Calendar StartCal = ToCompare.DateTime;
				Calendar EndCal = this.DateTime;
							
				//add exact fields
				Data.put("Milliseconds", Math.abs(StartCal.getTimeInMillis() 	- EndCal.getTimeInMillis()));
				Data.put("Seconds", 	Math.abs(StartCal.get(Calendar.SECOND) 	- EndCal.get(Calendar.SECOND)));
				Data.put("Minutes", 	Math.abs(StartCal.get(Calendar.MINUTE) 	- EndCal.get(Calendar.MINUTE)));
				Data.put("Hours", 		Math.abs(StartCal.get(Calendar.HOUR) 	- EndCal.get(Calendar.HOUR)));
				Data.put("Days", 		Math.abs(StartCal.get(Calendar.DATE) 	- EndCal.get(Calendar.DATE)));
				
				//add total fields
				Data.put("TotalMilliseconds", Math.abs(StartCal.getTimeInMillis() - EndCal.getTimeInMillis()));
				Data.put("TotalSeconds",	Math.abs(StartCal.getTimeInMillis() - EndCal.getTimeInMillis()) / (1000));
				Data.put("TotalMinutes",	Math.abs(StartCal.getTimeInMillis() - EndCal.getTimeInMillis()) / (1000 * 60));
				Data.put("TotalHours", 	Math.abs(StartCal.getTimeInMillis() - EndCal.getTimeInMillis()) / (1000 * 60 * 60));
				Data.put("TotalDays", 		Math.abs(StartCal.getTimeInMillis() - EndCal.getTimeInMillis()) / (1000 * 60 * 60 * 24));
			
				return Data;
			}
		//<-- End Method :: Diff
		
		//##################################################################################
		
		//--> Begin Method :: Now
			public DateTimeDriver Now() {
				//create new calendar
				this.DateTime = Calendar.getInstance();
				
				//refresh properties
				this.RefreshProperties();
				
				return this;
			}
		//<-- End Method :: Now
		
		//##################################################################################
		
		//--> Begin Method :: SetMaxValue
			public DateTimeDriver SetMaxValue() {
				//create new formatter
				DateFormat MyDateFormatter = new SimpleDateFormat("G yyyy-MM-dd HH:mm:ss.SSS");
				
				//format min date
				MyDateFormatter.format(new Date(Long.MAX_VALUE));

				//set new date to calendar
				this.DateTime = MyDateFormatter.getCalendar();
				
				//refresh properties
				this.RefreshProperties();
				
				return this;
			}
		//<-- End Method :: SetMaxValue
		
		//##################################################################################
		
		//--> Begin Method :: SetMinValue
			public DateTimeDriver SetMinValue() {
				//create new formatter
				DateFormat MyDateFormatter = new SimpleDateFormat("G yyyy-MM-dd HH:mm:ss.SSS");
				
				//format min date
				MyDateFormatter.format(new Date(Long.MIN_VALUE));

				//set new date to calendar
				this.DateTime = MyDateFormatter.getCalendar();
				
				//refresh properties
				this.RefreshProperties();
				
				return this;
			}
		//<-- End Method :: SetMinValue
		
		//##################################################################################
		
		//--> Begin Method :: Parse
			public DateTimeDriver Parse(String Value, String Pattern) throws Exception {
				//create new formatter
				DateFormat MyDateFormat = new SimpleDateFormat(Pattern); 
				
				//parse date
				Date NewDate = (Date)MyDateFormat.parse(Value);
				
				//create new calendar
				this.DateTime = Calendar.getInstance();
				
				//set new date to calendar
				this.DateTime.setTime(NewDate);
				
				//refresh properties
				this.RefreshProperties();
				
				return this;
			}
			public DateTimeDriver Parse(String Value) throws Exception {
				//ISO 8601 (YYYY-MM-ddThh:mm:ss) date and time
				if(Value.matches("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}$")) {
					//get matches
					Pattern MyPattern = Pattern.compile("^(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2}):(\\d{2}):(\\d{2})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
					Matcher MyMatcher = MyPattern.matcher(Value);
					
					while(MyMatcher.find()) {
						this.Set(Integer.valueOf(MyMatcher.group(1)), Integer.valueOf(MyMatcher.group(2)), Integer.valueOf(MyMatcher.group(3)), Integer.valueOf(MyMatcher.group(4)), Integer.valueOf(MyMatcher.group(5)), Integer.valueOf(MyMatcher.group(6)));
					}
				}
				//mysql-ish (YYYY-MM-DD hh:mm:ss) time
				else if(Value.matches("^\\d{4}-\\d{1,2}-\\d{1,2} \\d{1,2}:\\d{2}:\\d{2}$")) {
					//get matches
					Pattern MyPattern = Pattern.compile("^(\\d{4})-(\\d{1,2})-(\\d{1,2}) (\\d{1,2}):(\\d{2}):(\\d{2})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
					Matcher MyMatcher = MyPattern.matcher(Value);
					while(MyMatcher.find()) {
						this.Set(Integer.valueOf(MyMatcher.group(1)), Integer.valueOf(MyMatcher.group(2)), Integer.valueOf(MyMatcher.group(3)), Integer.valueOf(MyMatcher.group(4)), Integer.valueOf(MyMatcher.group(5)), Integer.valueOf(MyMatcher.group(6)));
					}
				}
				//mysql-ish (YYYY-MM-DD hh:mm:ss) time w/milliseconds
				else if(Value.matches("^\\d{4}-\\d{1,2}-\\d{1,2} \\d{1,2}:\\d{2}:\\d{2}\\.\\d{1}$")) {
					//get matches
					Pattern MyPattern = Pattern.compile("^(\\d{4})-(\\d{1,2})-(\\d{1,2}) (\\d{1,2}):(\\d{2}):(\\d{2})(\\.\\d{1})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
					Matcher MyMatcher = MyPattern.matcher(Value);
					while(MyMatcher.find()) {
						this.Set(Integer.valueOf(MyMatcher.group(1)), Integer.valueOf(MyMatcher.group(2)), Integer.valueOf(MyMatcher.group(3)), Integer.valueOf(MyMatcher.group(4)), Integer.valueOf(MyMatcher.group(5)), Integer.valueOf(MyMatcher.group(6)));
					}
				}
				//ISO 8601 (YYYY-MM-dd) date
				else if(Value.matches("^\\d{4}-\\d{2}-\\d{2}$")) {			
					//get matches
					Pattern MyPattern = Pattern.compile("^(\\d{4})-(\\d{2})-(\\d{2})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
					Matcher MyMatcher = MyPattern.matcher(Value);
				
					while(MyMatcher.find()) {
						this.Set(Integer.valueOf(MyMatcher.group(1)), Integer.valueOf(MyMatcher.group(2)), Integer.valueOf(MyMatcher.group(3)));
					}
				}
				//mm[/.-]dd[/.-]yyyy hh:mm:ss
				else if(Value.matches("^\\d{1,2}[\\/\\.\\-]\\d{1,2}[\\/\\.\\-]\\d{4} \\d{1,2}:\\d{2}:\\d{2}$")) {
					//get matches
					Pattern MyPattern = Pattern.compile("^(\\d{1,2})[\\/\\.\\-](\\d{1,2})[\\/\\.\\-](\\d{4}) (\\d{1,2}):(\\d{2}):(\\d{2})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
					Matcher MyMatcher = MyPattern.matcher(Value);
					
					while(MyMatcher.find()) {
						this.Set(Integer.valueOf(MyMatcher.group(3)), Integer.valueOf(MyMatcher.group(2)), Integer.valueOf(MyMatcher.group(1)), Integer.valueOf(MyMatcher.group(4)), Integer.valueOf(MyMatcher.group(5)), Integer.valueOf(MyMatcher.group(6)));
					}
				}
				//mm[/.-]dd[/.-]yyyy
				else if(Value.matches("^\\d{1,2}[\\/\\.\\-]\\d{1,2}[\\/\\.\\-]\\d{4}$")) {
					//get matches
					Pattern MyPattern = Pattern.compile("^(\\d{1,2})[\\/\\.\\-](\\d{1,2})[\\/\\.\\-](\\d{4})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
					Matcher MyMatcher = MyPattern.matcher(Value);
					
					while(MyMatcher.find()) {
						this.Set(Integer.valueOf(MyMatcher.group(3)), Integer.valueOf(MyMatcher.group(1)), Integer.valueOf(MyMatcher.group(2)));
					}
				}
				//hh:mm:ss
				else if(Value.matches("^\\d{2}:\\d{2}:\\d{2}$")) {
					//get matches
					Pattern MyPattern = Pattern.compile("^(\\d{2}):(\\d{2}):(\\d{2})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
					Matcher MyMatcher = MyPattern.matcher(Value);
					
					while(MyMatcher.find()) {
						//create tmpCal to get todays Date
						Calendar tmpCal = Calendar.getInstance();
						this.Set(tmpCal.get(tmpCal.YEAR), (tmpCal.get(tmpCal.MONTH) + 1), tmpCal.get(tmpCal.DAY_OF_MONTH), Integer.valueOf(MyMatcher.group(1)), Integer.valueOf(MyMatcher.group(2)), Integer.valueOf(MyMatcher.group(3)));
					}
				}
				
				//refresh properties
				this.RefreshProperties();
				
				return this;
			}
		//<-- End Method :: Parse
		
		//##################################################################################
		
		//--> Begin Method :: ToString
			public String ToString() {
				return this.ToString("yyyy-MM-dd HH:mm:ss");
			}
			public String ToString(String Format) {
				//turn all special chars into literals
				Format = Matcher.quoteReplacement(Format);
					
				//support for the [...content...] blocks
					char ValidKeyCharacters[] = {'a','b','c','e','f','g','i','j','k','l','p','q','r','u','v','w','x','z'};
					Hashtable SavedText = new Hashtable();
					String RegexPattern = "(\\[.*?\\])";
					Pattern MyPattern = Pattern.compile(RegexPattern, Pattern.CASE_INSENSITIVE | Pattern.DOTALL );
					Matcher MyMatcher = MyPattern.matcher(Format);
					
					while(MyMatcher.find()) {
						
						String ThisGroup = Matcher.quoteReplacement(MyMatcher.group());
						
						//generate random key
						String ThisKey = "";
						for(int j = 0 ; j < 20 ; j++) {
							ThisKey += ValidKeyCharacters[new Random().nextInt(ValidKeyCharacters.length)];
						}

						SavedText.put(ThisKey, ThisGroup.replaceAll("\\[", "").replaceAll("\\]", ""));
						Format = Format.replaceAll(ThisGroup.replaceAll("\\[", "").replaceAll("\\]", ""), ThisKey);
					}
				//end support for the [...content...] blocks
				
				//setup internal token translation
				Format = Format.replaceAll("dddd", "!!!!");
				Format = Format.replaceAll("ddd", "!!!");
				Format = Format.replaceAll("dd", "!!");
				Format = Format.replaceAll("do", "!@");
				Format = Format.replaceAll("d", "!");
				Format = Format.replaceAll("hh", "##");
				Format = Format.replaceAll("ho", "#@");
				Format = Format.replaceAll("h", "#");
				Format = Format.replaceAll("HH", "\\=\\=");
				Format = Format.replaceAll("HO", "\\=@");
				Format = Format.replaceAll("H", "\\=");
				Format = Format.replaceAll("mm", "%%");
				Format = Format.replaceAll("mo", "%@");
				Format = Format.replaceAll("m", "%");
				Format = Format.replaceAll("MMMM", "\\^\\^\\^\\^");
				Format = Format.replaceAll("MMM", "\\^\\^\\^");
				Format = Format.replaceAll("MM", "\\^\\^");
				Format = Format.replaceAll("MO", "\\^\\@");
				Format = Format.replaceAll("M", "\\^");
				Format = Format.replaceAll("ss", "&&");
				Format = Format.replaceAll("so", "&@");
				Format = Format.replaceAll("s", "&");
				Format = Format.replaceAll("tt", "\\*\\*");
				Format = Format.replaceAll("t", "\\*");
				Format = Format.replaceAll("TT", "__");
				Format = Format.replaceAll("T", "_");
				Format = Format.replaceAll("yyyyo", "\\~\\~\\~\\~\\@");
				Format = Format.replaceAll("yyyy", "\\~\\~\\~\\~");
				Format = Format.replaceAll("yy", "\\~\\~");
				
				/*
					* dddd 	- !!!!	= Day name (Sunday..Saturday): Friday
					* ddd 	- !!! 	= Day name abreviation (Sun..Sat): Fri
					* dd 	- !! 	= Day of month (01-31): 22
					* do 	- !@ 	= Day of month with ordinal (1st-31st): 22nd
					* d 	- ! 	= Day of month (1-31): 22
					* hh 	- ## 	= 12 hour clock, hour (01-12): 02
					* ho 	- #@	= 12 hour clock, hour with ordinal (1st-12th): 2nd
					* h 	- #		= 12 hour clock, hour (1-12): 2
					* HH 	- ==	= 24 hour clock, hour (01-24): 14
					* HO 	- =@	= 24 hour clock, hour with ordinal (1st-24th): 14th
					* H 	- ==		= 24 hour clock, hour (1-24): 14
					* mm 	- %%	= Minutes (00-59): 30
					* mo 	- %@	= Minutes with ordinal (0th-59th): 30th
					* m 	- %		= Minutes (0-59): 30
					* MMMM 	- ^^^^	= Month name (January..December): May
					* MMM 	- ^^^	= Month name abreviation (Jan..Dec): May
					* MM 	- ^^	= Month number (01-12): 05
					* MO 	- ^@	= Month number with ordinal (1st-12th): 5th
					* M 	- ^		= Month number (1-12): 5
					* ss 	- &&	= Seconds (00-59): 12
					* so 	- &@	= Seconds with ordinal (0st-59th): 12th
					* s 	- &		= Seconds (1-59): 12
					* tt 	- **	= am/pm: pm
					* t 	- *		= am/pm abreviation (a/p): p
					* TT 	- __	= AM/PM: PM
					* T 	- _		= AM/PM abreviation (A/P): P
					* yyyyo - ~~~~@	= Year 4-digits with ordinal (2009th): 2009th
					* yyyy 	- ~~~~	= Year 4-digits (2009): 2009
					* yy 	- ~~	= Year 2-digits (09): 09
				*/
				
				//translate internal tokens
				Format = Format.replaceAll("!!!!", 				this.DayName);
				Format = Format.replaceAll("!!!", 				this.DayNameAbbr);
				Format = Format.replaceAll("!!", 				new SimpleDateFormat("dd").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("!@", 				this.OrdinalSuffix((int)this.Day));
				Format = Format.replaceAll("!",					new SimpleDateFormat("d").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("##",				new SimpleDateFormat("hh").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("#@",				this.OrdinalSuffix(Integer.valueOf(new SimpleDateFormat("h").format(this.DateTime.getTime()).toString())));
				Format = Format.replaceAll("#",					new SimpleDateFormat("h").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("\\=\\=",			new SimpleDateFormat("kk").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("\\=@", 				this.OrdinalSuffix(Integer.valueOf(new SimpleDateFormat("k").format(this.DateTime.getTime()).toString())));
				Format = Format.replaceAll("\\=", 				new SimpleDateFormat("k").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("%%", 				new SimpleDateFormat("m").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("%@", 				this.OrdinalSuffix(Integer.valueOf(new SimpleDateFormat("m").format(this.DateTime.getTime()).toString())));
				Format = Format.replaceAll("%", 				new SimpleDateFormat("mm").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("\\^\\^\\^\\^",		new SimpleDateFormat("MMMM").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("\\^\\^\\^", 		new SimpleDateFormat("MMM").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("\\^\\^", 			new SimpleDateFormat("MM").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("\\^\\@", 			this.OrdinalSuffix(Integer.valueOf(new SimpleDateFormat("M").format(this.DateTime.getTime()).toString())));
				Format = Format.replaceAll("\\^", 				new SimpleDateFormat("M").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("&&", 				new SimpleDateFormat("ss").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("&@", 				this.OrdinalSuffix(Integer.valueOf(new SimpleDateFormat("s").format(this.DateTime.getTime()).toString())));
				Format = Format.replaceAll("&",					new SimpleDateFormat("s").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("\\*\\*", 			new SimpleDateFormat("a").format(this.DateTime.getTime()).toString().toLowerCase());
				Format = Format.replaceAll("\\*", 				new SimpleDateFormat("a").format(this.DateTime.getTime()).toString().toLowerCase().substring(0, 1));
				Format = Format.replaceAll("__", 				new SimpleDateFormat("a").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("_", 				new SimpleDateFormat("a").format(this.DateTime.getTime()).toString().substring(0, 1));
				Format = Format.replaceAll("\\~\\~\\~\\~\\@",	this.OrdinalSuffix(Integer.valueOf(new SimpleDateFormat("yyyy").format(this.DateTime.getTime()).toString())));
				Format = Format.replaceAll("\\~\\~\\~\\~", 		new SimpleDateFormat("yyyy").format(this.DateTime.getTime()).toString());
				Format = Format.replaceAll("\\~\\~", 			new SimpleDateFormat("yy").format(this.DateTime.getTime()).toString());
				
				Enumeration SavedKeys = SavedText.keys();
				while(SavedKeys.hasMoreElements()) {
					String key = String.valueOf(SavedKeys.nextElement());
					String value = String.valueOf(SavedText.get(key));
					Format = Format.replaceAll("\\["+ key +"\\]", value);
				}
				return Format;
			}
		//<-- End Method :: ToString
		
		//##################################################################################
		//##################################################################################
		//##################################################################################
		
		//--> Begin Method :: OrdinalSuffix
			public String OrdinalSuffix(int Value) {
				//format numbers with 'st', 'nd', 'rd', 'th'
				String Abr = "";
				String strNumber = String.valueOf(Value);
				
				String strLastNumber = strNumber.substring(strNumber.length() -1, strNumber.length());
				String strLastTwoNumbers = strNumber.substring(strNumber.length() - 1, strNumber.length());

				if(strNumber.length() >= 2) {
					strLastTwoNumbers = strNumber.substring(strNumber.length() -2, strNumber.length());
				}
				else {
					strLastTwoNumbers = strLastNumber;
				}	
				
				if(strLastNumber.equals("1")){
					if(strLastTwoNumbers.equals("11")){
						Abr = "th";
					}
					else {
						Abr = "st";
					}
				}
				else if(strLastNumber.equals("2")){
					if(strLastTwoNumbers.equals("12")) {
						Abr = "th";
					} 
					else {
						Abr = "nd";
					}
				}
				else if(strLastNumber.equals("3")){
					if(strLastTwoNumbers.equals("13")) {
						Abr = "th";
					} 
					else {
						Abr = "rd";
					}
				}
				else if(strLastNumber.equals("4") || strLastNumber.equals("5") || strLastNumber.equals("6") || strLastNumber.equals("7") || strLastNumber.equals("8") || strLastNumber.equals("9") || strLastNumber.equals("0")){
					Abr = "th";
				}
				else{
					Abr = "";
				}
				
				return strNumber + Abr;
			}
		//<-- End Method :: OrdinalSuffix
		
		//##################################################################################
		
		//--> Begin Method :: BuildDateData
			public void BuildDateData() {
				//day name abbrs
				this.DayNamesAbbr = new String[7];
				this.DayNamesAbbr[0] = "Sun";
				this.DayNamesAbbr[1] = "Mon";
				this.DayNamesAbbr[2] = "Tue";
				this.DayNamesAbbr[3] = "Wed";
				this.DayNamesAbbr[4] = "Thu";
				this.DayNamesAbbr[5] = "Fri";
				this.DayNamesAbbr[6] = "Sat";
				
				//day names
				this.DayNames = new String[7];
				this.DayNames[0] = "Sunday";
				this.DayNames[1] = "Monday";
				this.DayNames[2] = "Tuesday";
				this.DayNames[3] = "Wednesday";
				this.DayNames[4] = "Thursday";
				this.DayNames[5] = "Friday";
				this.DayNames[6] = "Saturday";
				
				//month name abbrs
				this.MonthNamesAbbr = new String[12];
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
				this.MonthNames = new String[12];
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
%>