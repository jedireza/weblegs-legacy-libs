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
	WebLegs.DateTimeDriver = function() {
		//core
		this.DateTime = null;
		this.Year = null;
		this.Month = null;
		this.Day = null;
		this.Hour = null;
		this.Minute = null;
		this.Second = null;
		
		//informational
		this.IsLeapYear = null;
		this.DayOfWeek = null;
		this.DayOfYear = null;
		this.DaysInYear = null;
		this.MonthOfYear = null;
		this.StartDayOfMonth = null;
		this.EndDayOfMonth = null;
		this.WeekOfYear = null;
		this.DaysInMonth = null;
		this.WeeksInYear = null;
		this.DayName = null;
		this.DayNameAbbr = null;
		this.MonthName = null;
		this.MonthNameAbbr = null;
		
		//helpers
		this.DayNameAbbrs = {};
		this.DayNameAbbrs[1] = "Sun";
		this.DayNameAbbrs[2] = "Mon";
		this.DayNameAbbrs[3] = "Tue";
		this.DayNameAbbrs[4] = "Wed";
		this.DayNameAbbrs[5] = "Thu";
		this.DayNameAbbrs[6] = "Fri";
		this.DayNameAbbrs[7] = "Sat";

		this.DayNames = {};
		this.DayNames[1] = "Sunday";
		this.DayNames[2] = "Monday";
		this.DayNames[3] = "Tuesday";
		this.DayNames[4] = "Wednesday";
		this.DayNames[5] = "Thursday";
		this.DayNames[6] = "Friday";
		this.DayNames[7] = "Saturday";

		this.MonthNameAbbrs = {};
		this.MonthNameAbbrs[1] = "Jan";
		this.MonthNameAbbrs[2] = "Feb";
		this.MonthNameAbbrs[3] = "Mar";
		this.MonthNameAbbrs[4] = "Apr";
		this.MonthNameAbbrs[5] = "May";
		this.MonthNameAbbrs[6] = "Jun";
		this.MonthNameAbbrs[7] = "Jul";
		this.MonthNameAbbrs[8] = "Aug";
		this.MonthNameAbbrs[9] = "Sep";
		this.MonthNameAbbrs[10] = "Oct";
		this.MonthNameAbbrs[11] = "Nov";
		this.MonthNameAbbrs[12] = "Dec";
		
		this.MonthNames = {};
		this.MonthNames[1] = "January";
		this.MonthNames[2] = "February";
		this.MonthNames[3] = "March";
		this.MonthNames[4] = "April";
		this.MonthNames[5] = "May";
		this.MonthNames[6] = "June";
		this.MonthNames[7] = "July";
		this.MonthNames[8] = "August";
		this.MonthNames[9] = "September";
		this.MonthNames[10] = "October";
		this.MonthNames[11] = "November";
		this.MonthNames[12] = "December";
		
		//create some static properties
		this.MinValue = "12/13/1901 12:00:00";
		this.MaxValue = "01/19/2038 03:14:07";
		
		
		var NumberOfArgs = arguments.length;
		var Args = arguments;

		//DateTimeDriver()
		if(NumberOfArgs == 0){
			this.DateTime = new Date();
			this.RefreshProperties();
		}
		//DateTimeDriver(Value)
		else if(NumberOfArgs == 1){
			this.Parse(Args[0]);			
		}
		//DateTimeDriver(Year, Month, Day)
		else if(NumberOfArgs == 3){
			this.Set(Args[0], Args[1], Args[2]);
		}
		//DateTimeDriver(Year, Month, Day, Hour, Minute, Second)
		else if(NumberOfArgs == 6){
			this.Set(Args[0], Args[1], Args[2], Args[3], Args[4], Args[5]);
		}
	}
//<-- End :: Constructor
		
//##################################################################################

//--> Begin Method :: Set
	WebLegs.DateTimeDriver.prototype.Set = function(){
		var NumberOfArgs = arguments.length;
		var Args = arguments;
		
		if(NumberOfArgs == 3){
			this.DateTime = new Date(Args[0], Args[1] - 1, Args[2]);
		}
		else if(NumberOfArgs == 6){
			this.DateTime = new Date(Args[0], Args[1] - 1, Args[2], Args[3], Args[4], Args[5]);
		}
		
		//refresh
		this.RefreshProperties();
		
		return this;
	}
//--> End Method :: Set

//##################################################################################

//--> Begin Method :: RefreshProperties
	WebLegs.DateTimeDriver.prototype.RefreshProperties = function() {
		if(this.DateTime == null){
			this.DateTime = new Date();	
		}
		
		//basic
		this.Year = this.DateTime.getFullYear();
		this.Month = this.DateTime.getMonth() + 1;//months start 0-11
		this.Day = this.DateTime.getDate();
		this.Hour = this.DateTime.getHours();
		this.Minute = this.DateTime.getMinutes();
		this.Second = this.DateTime.getSeconds();
		
		//informational
			this.EndDayOfMonth = null;
			this.WeekOfYear = null;
			
			//leap year
			var IsLeap = false;
			if(this.DateTime.Year % 4 == 0) { //years evenly divisible by 4 are leap years.
				IsLeap = true;
				
				//except years that are not evenly divisible by 400.
				if(this.Year % 100 == 0 && this.Year % 400 != 0) {
					IsLeap = false;
				}
			}
			this.IsLeapYear = IsLeap;
			
			//day of week
			this.DayOfWeek = this.DateTime.getDay() + 1;
			
			//day of year
			this.DayOfYear = Math.ceil((this.DateTime - (new Date(this.DateTime.getFullYear(), 0, 1))) / 86400000);
			
			//days in year
			this.DaysInYear = Math.ceil((new Date(this.DateTime.getFullYear(), 11, 31) - (new Date(this.DateTime.getFullYear(), 0, 1))) / 86400000) + 1; //why is this off by one??
			
			//start day of month (ie. mon = 1, tue = 2 etc..)
			this.StartDayOfMonth = (new Date(this.Year, this.Month - 1, 1, 0, 0, 0, 0)).getDay() + 1;
			
			//set end day of month (ie. mon = 1, tue = 2 etc..)
			this.EndDayOfMonth = (new Date(this.Year, this.Month - 1, this.DaysInMonth, 0, 0, 0, 0)).getDay() + 1;
			
			//week of year
			var WeekOfYearDate = new Date(this.DateTime.getFullYear(), this.DateTime.getMonth(), this.DateTime.getDate(), 0, 0, 0);
			var DayOfWeek = WeekOfYearDate.getDay();
			WeekOfYearDate.setDate(WeekOfYearDate.getDate() - (DayOfWeek + 6) % 7 + 3); // Nearest Thu
			var WeekOfYearValue = WeekOfYearDate.valueOf(); //GMT
			WeekOfYearDate.setMonth(0);
			WeekOfYearDate.setDate(4);
			this.WeekOfYear = Math.round((WeekOfYearValue - WeekOfYearDate.valueOf()) / (7 * 864e5));
			if(parseInt(this.WeekOfYear) == 0){
				this.WeekOfYear = 52;
			}
			
			//get the max days in this month
			this.DaysInMonth = (32 - new Date(this.Year, (this.Month - 1), 32).getDate());
			
			//weeks in year
			WeekOfYearDate = new Date(this.DateTime.getFullYear(), 11, 31, 0, 0, 0);
			DayOfWeek = WeekOfYearDate.getDay();
			WeekOfYearDate.setDate(WeekOfYearDate.getDate() - (DayOfWeek + 6) % 7 + 3); // Nearest Thu
			WeekOfYearValue = WeekOfYearDate.valueOf(); //GMT
			WeekOfYearDate.setMonth(0);
			WeekOfYearDate.setDate(4);
			this.WeeksInYear = Math.round((WeekOfYearValue - WeekOfYearDate.valueOf()) / (7 * 864e5));
			if(parseInt(this.WeekOfYear) == 0){
				this.WeeksInYear = 52;
			}
			
			//day name
			this.DayName = this.DayNames[this.DayOfWeek];
			
			//day name abr
			this.DayNameAbbr = this.DayNameAbbrs[this.DayOfWeek];
			
			//month name
			this.MonthName = this.MonthNames[this.Month];
			
			//month name abr
			this.MonthNameAbbr = this.MonthNameAbbrs[this.Month];
		//end informational
	}
//<-- End Method :: RefreshProperties

//##################################################################################

//--> Begin Method :: AddSeconds
	WebLegs.DateTimeDriver.prototype.AddSeconds = function(Value) {
		if(this.DateTime == null){
			this.DateTime = new Date();	
		}
		this.DateTime.setSeconds(this.DateTime.getSeconds() + Value);

		//refresh properties
		this.RefreshProperties();
		return this;
	}
//<-- End Method :: AddSeconds

//##################################################################################

//--> Begin Method :: AddMinutes
	WebLegs.DateTimeDriver.prototype.AddMinutes = function(Value) {
		if(this.DateTime == null){
			this.DateTime = new Date();	
		}
		this.DateTime.setMinutes(this.DateTime.getMinutes() + Value);
		
		//refresh properties
		this.RefreshProperties();
		return this;
	}
//<-- End Method :: AddMinutes

//##################################################################################

//--> Begin Method :: AddHours
	WebLegs.DateTimeDriver.prototype.AddHours = function(Value) {
		if(this.DateTime == null){
			this.DateTime = new Date();	
		}
		this.DateTime.setHours(this.DateTime.getHours() + Value);
		return this;
	}
//<-- End Method :: AddHours

//##################################################################################

//--> Begin Method :: AddDays
	WebLegs.DateTimeDriver.prototype.AddDays = function(Value) {
		if(this.DateTime == null){
			this.DateTime = new Date();	
		}
		this.DateTime.setDate(this.DateTime.getDate() + Value);
		
		//refresh properties
		this.RefreshProperties();
		return this;
	}
//<-- End Method :: AddDays

//##################################################################################

//--> Begin Method :: AddMonths
	WebLegs.DateTimeDriver.prototype.AddMonths = function(Value) {
		if(this.DateTime == null){
			this.DateTime = new Date();	
		}
		this.DateTime.setMonth(this.DateTime.getMonth() + Value);
		
		//refresh properties
		this.RefreshProperties();
		return this;
	}
//<-- End Method :: AddMonths

//##################################################################################

//--> Begin Method :: AddYears
	WebLegs.DateTimeDriver.prototype.AddYears = function(Value) {
		if(this.DateTime == null){
			this.DateTime = new Date();	
		}
		this.DateTime.setFullYear(this.DateTime.getFullYear() + Value);
		
		//refresh properties
		this.RefreshProperties();
		return this;
	}
//<-- End Method :: AddYears

//##################################################################################

//--> Begin Method :: Diff
	WebLegs.DateTimeDriver.prototype.Diff = function(ToCompare) {
		var Data = new Object();
		
		Data["Milliseconds"] = Math.abs(this.DateTime.getMilliseconds() - ToCompare.DateTime.getMilliseconds());
		Data["Seconds"] = Math.abs(this.DateTime.getSeconds() - ToCompare.DateTime.getSeconds());
		Data["Minutes"] = Math.abs(this.DateTime.getMinutes() - ToCompare.DateTime.getMinutes());
		Data["Hours"] = Math.abs(this.DateTime.getHours() - ToCompare.DateTime.getHours());
		Data["Days"] = Math.abs(this.DateTime.getDate() - ToCompare.DateTime.getDate());
		Data["TotalMilliseconds"] = Math.abs(this.DateTime.getMilliseconds() - ToCompare.DateTime.getMilliseconds() / (100));
		Data["TotalSeconds"] = Math.round(Math.abs(this.DateTime.getTime() - ToCompare.DateTime.getTime()) / (1000));
		Data["TotalMinutes"] = Math.round(Math.abs(this.DateTime.getTime() - ToCompare.DateTime.getTime()) / (1000 * 60));
		Data["TotalHours"] = Math.round(Math.abs(this.DateTime.getTime() - ToCompare.DateTime.getTime()) / (1000 * 60 * 60));
		Data["TotalDays"] = Math.round(Math.abs(this.DateTime.getTime() - ToCompare.DateTime.getTime()) / (1000 * 60 * 60 * 24));
		
		return Data;
	}
//<-- End Method :: Diff

//##################################################################################

//--> Begin Method :: Now
	WebLegs.DateTimeDriver.prototype.Now = function() {
		return new WebLegs.DateTimeDriver((new Date()).toString());
	}
//<-- End Method :: Now

//##################################################################################

//--> Begin Method :: SetMinValue
	WebLegs.DateTimeDriver.prototype.SetMinValue = function() {
		this.Parse(this.MinValue);
		return this;
	}
//<-- End Method :: SetMinValue

//##################################################################################

//--> Begin Method :: SetMaxValue
	WebLegs.DateTimeDriver.prototype.SetMaxValue = function() {
		this.Parse(this.MaxValue);
		return this;
	}
//<-- End Method :: SetMaxValue

//##################################################################################

//--> Begin Method :: Parse
	WebLegs.DateTimeDriver.prototype.Parse = function(Value) {
		//container for results
		var MatchResults;
		
		//ISO 8601 (YYYY-MM-ddThh:mm:ss) date and time
		if(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$/.test(Value)) {
			MatchResults = Value.match(/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})$/);
			this.Set(MatchResults[1], MatchResults[2], MatchResults[3], MatchResults[4], MatchResults[5], MatchResults[6]);
		}
		//mysql-ish (YYYY-MM-DD hh:mm:ss) time
		else if(/^\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{2}:\d{2}$/.test(Value)) {
			MatchResults = Value.match(/^(\d{4})-(\d{1,2})-(\d{1,2}) (\d{1,2}):(\d{2}):(\d{2})$/);
			this.Set(MatchResults[1], MatchResults[2], MatchResults[3], MatchResults[4], MatchResults[5], MatchResults[6]);
		}
		//ISO 8601 (YYYY-MM-dd) date
		else if(/^\d{4}-\d{2}-\d{2}$/.test(Value)) {
			MatchResults = Value.match(/^(\d{4})-(\d{2})-(\d{2})$/);
			this.Set(MatchResults[1], MatchResults[2], MatchResults[3]);
		}
		//mm[/.-]dd[/.-]yyyy hh:mm:ss
		else if(/^\d{1,2}[\/\.\-]\d{1,2}[\/\.\-]\d{4} \d{1,2}:\d{2}:\d{2}$/.test(Value)) {
			MatchResults = Value.match(/^(\d{1,2})[\/\.\-](\d{1,2})[\/\.\-](\d{4}) (\d{1,2}):(\d{2}):(\d{2})$/);
			this.Set(MatchResults[3], MatchResults[2], MatchResults[1], MatchResults[4], MatchResults[5], MatchResults[6]);
		}
		//mm[/.-]dd[/.-]yyyy
		else if(/^\d{1,2}[\/\.\-]\d{1,2}[\/\.\-]\d{4}$/.test(Value)) {
			MatchResults = Value.match(/^(\d{1,2})[\/\.\-](\d{1,2})[\/\.\-](\d{4})$/);
			this.Set(MatchResults[3], MatchResults[2], MatchResults[1]);
		}
		//hh:mm:ss
		else if(/^\d{2}:\d{2}:\d{2}$/.test(Value)) {
			MatchResults = Value.match(/^(\d{2}):(\d{2}):(\d{2})$/);
			this.Set(new Date().getFullYear(), (new Date().getMonth()+1), new Date().getDate(), MatchResults[1], MatchResults[2], MatchResults[3]);
		}
		else {
			//try feeding this to the built-in date object
			this.DateTime = new Date(Value);
		}
		
		//refresh properties
		this.RefreshProperties();
		return this;
	}
//<-- End Method :: Parse

//##################################################################################

//--> Begin Method :: ToString
	WebLegs.DateTimeDriver.prototype.ToString = function(Format) {
		if(Format == undefined) {
			Format = "yyyy-MM-dd HH:mm:ss";
		}
		
		//support for the [...content...] blocks
			var ValidKeyCharacters = new Array('a', 'b', 'c', 'e', 'f', 'g', 'i', 'j', 'k', 'l', 'p', 'q', 'r', 'u', 'v', 'w', 'x', 'z');
			var SavedText = new Array();
			var RegexPattern = /\[.*?\]/;
			var Matches = Format.match(RegexPattern);
			var Count = 0;
			while(Matches) {
				//document.write(Matches +"|"+  Matches.length +"<hr/>");
				for(var i = 0 ; i < Matches.length ; i++) {
					//generate random key
					var ThisKey = "";
					for(var j = 0 ; j < 20 ; j++) {
						ThisKey += ValidKeyCharacters[Math.floor(Math.random() * ValidKeyCharacters.length)];
					}
					
					var ThisMatch = Matches[i].replace(/\[/,"");
					ThisMatch = ThisMatch.replace(/\]/,"");
					SavedText[Count] = new Array(ThisKey, ThisMatch);
					
					Format = Format.replace(Matches[i], ThisKey);
				}
				
				Count++;
				Matches = Format.match(RegexPattern);
			}
		//end support for the [...content...] blocks
		
		
		//setup internal token translation
		Format = Format.replace(/dddd/g, "!!!!");
		Format = Format.replace(/ddd/g, "!!!");
		Format = Format.replace(/dd/g, "!!");
		Format = Format.replace(/do/g, "!@");
		Format = Format.replace(/d/g, "!");
		Format = Format.replace(/hh/g, "##");
		Format = Format.replace(/ho/g, "#@");
		Format = Format.replace(/h/g, "#");
		Format = Format.replace(/HH/g, "==");
		Format = Format.replace(/HO/g, "=@");
		Format = Format.replace(/H/g, "=");
		Format = Format.replace(/mm/g, "%%");
		Format = Format.replace(/mo/g, "%@");
		Format = Format.replace(/m/g, "%");
		Format = Format.replace(/MMMM/g, "^^^^");
		Format = Format.replace(/MMM/g, "^^^");
		Format = Format.replace(/MM/g, "^^");
		Format = Format.replace(/MO/g, "^@");
		Format = Format.replace(/M/g, "^");
		Format = Format.replace(/ss/g, "&&");
		Format = Format.replace(/so/g, "&@");
		Format = Format.replace(/s/g, "&");
		Format = Format.replace(/tt/g, "**");
		Format = Format.replace(/t/g, "*");
		Format = Format.replace(/TT/g, "__");
		Format = Format.replace(/T/g, "_");
		Format = Format.replace(/yyyyo/g, "~~~~@");
		Format = Format.replace(/yyyy/g, "~~~~");
		Format = Format.replace(/yy/g, "~~");
		
		//translate internal tokens
		Format = Format.replace(/!!!!/g, this.DayName);
		Format = Format.replace(/!!!/g, this.DayNameAbbr);
		Format = Format.replace(/!!/g, ((this.Day.toString()).length == 1 ? "0"+ this.Day : this.Day));
		Format = Format.replace(/!@/g, this.OrdinalSuffix(this.Day));
		Format = Format.replace(/!/g, this.Day);
		var Hour12 = this.Hour;
		if(Hour12 > 12){
			Hour12 = Hour12 - 12;
		}
		Format = Format.replace(/##/g, ((Hour12.toString()).length == 1 ? "0"+ Hour12 : Hour12));
		Format = Format.replace(/#@/g, this.OrdinalSuffix(Hour12));
		Format = Format.replace(/#/g, Hour12.toString());
		Format = Format.replace(/\=\=/g, ((this.Hour.toString()).length == 1 ? "0"+ this.Hour : this.Hour));
		Format = Format.replace(/\=\@/g, this.OrdinalSuffix(this.Hour));
		Format = Format.replace(/\=/g, this.Hour);
		Format = Format.replace(/%%/g, ((this.Minute.toString()).length == 1 ? "0"+ this.Minute : this.Minute));
		Format = Format.replace(/%@/g, this.OrdinalSuffix(this.Minute));
		Format = Format.replace(/%/g, this.Minute);
		Format = Format.replace(/\^\^\^\^/g, this.MonthName);
		Format = Format.replace(/\^\^\^/g, this.MonthNameAbbr);
		Format = Format.replace(/\^\^/g, ((this.Month.toString()).length == 1 ? "0"+ this.Month : this.Month));
		Format = Format.replace(/\^\@/g, this.OrdinalSuffix(this.Month));
		Format = Format.replace(/\^/g, this.Month);
		Format = Format.replace(/&&/g, ((this.Second.toString()).length == 1 ? "0"+ this.Second : this.Second));
		Format = Format.replace(/&@/g, this.OrdinalSuffix(this.Second));
		Format = Format.replace(/&/g, this.Second);
		var TimeOfDay12Hour = "AM";
		if(this.Hour >= 12) {
			TimeOfDay12Hour = "PM";
		}
		Format = Format.replace(/\*\*/g, TimeOfDay12Hour.toLowerCase());
		Format = Format.replace(/\*/g, TimeOfDay12Hour.substring(0, 1).toLowerCase());
		Format = Format.replace(/__/g, TimeOfDay12Hour);
		Format = Format.replace(/_/g, TimeOfDay12Hour.substring(0, 1));
		Format = Format.replace(/~~~~@/g, this.OrdinalSuffix(this.Year));
		Format = Format.replace(/~~~~/g, this.Year);
		Format = Format.replace(/~~/g, (this.Year.toString()).substring(2, 4));
		
		//replace keys in string
		for(var i = 0 ; i < SavedText.length ; i++) {
			Format = Format.replace(SavedText[i][0], SavedText[i][1]);
		}
		
		return Format;
	}
//<-- End Method :: ToString

//##################################################################################
//##################################################################################
//##################################################################################

//--> Begin Method :: OrdinalSuffix
	WebLegs.DateTimeDriver.prototype.OrdinalSuffix = function(Value) {
		//format numbers with 'st', 'nd', 'rd', 'th'
		var Abr = "";
		var strNumber = Value+"";
		
		var strLastNumber = strNumber.substring(strNumber.length - 1);
		var strLastTwoNumbers = strNumber.substring(strNumber.length - 1);
		if((strNumber+"").length >= 2) {
			strLastTwoNumbers = strNumber.substring(strNumber.length - 2);
		}
		else {
			strLastTwoNumbers = strLastNumber;
		}
		
		switch(strLastNumber+"") {
			case "1":
				if(strLastTwoNumbers+"" == "11") {Abr = "th";} else {Abr = "st";}
				break; //out of switch
			case "2":
				if(strLastTwoNumbers+"" == "12") {Abr = "th";} else {Abr = "nd";}
				break; //out of switch
			case "3":
				if(strLastTwoNumbers+"" == "13") {Abr = "th";} else {Abr = "rd";}
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

//##########################################################################################