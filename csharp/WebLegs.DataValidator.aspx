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

//--> Begin Class :: DataValidator
	public static class DataValidator {
		//--> Begin :: Properties
			//no properties
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			//no constructor
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: IsValidEmail
			public static bool IsValidEmail(string EmailAddress) {
				Match myEmailMatcher = Regex.Match(EmailAddress, @"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
				return myEmailMatcher.Success;
			}
		//<-- End Method :: IsValidEmail
		
		//##################################################################################
		
		//--> Begin Method :: IsValidURL
			public static bool IsValidURL(string URL) {
				Match myURLMatcher = Regex.Match(URL, @"^https?://[a-zA-Z0-9._%-]+\.[a-zA-Z0-9.-]+$");
				return myURLMatcher.Success;
			}
		//<-- End Method :: IsValidURL
		
		//##################################################################################
		
		//--> Begin Method :: IsPhone
			public static bool IsPhone(string Value) {
				return IsPhone(Value, "us");
			}
			public static bool IsPhone(string Value, string CountryCode) {
				switch(CountryCode.ToLower()) {
					case "us":
						Match myPhoneMatcher = Regex.Match(Value, @"^([01][\s\.-]?)?(\(\d{3}\)|\d{3})[\s\.-]?\d{3}[\s\.-]?\d{4}$");
						return myPhoneMatcher.Success;
					default:
						//do nothing
						return false;
				}
			}
		//<-- End Method :: IsPhone
		
		//##################################################################################
		
		//--> Begin Method :: IsPostalCode
			public static bool IsPostalCode(string Value) {
				return DataValidator.IsPostalCode(Value, "us");
			}
			public static bool IsPostalCode(string Value, string CountryCode) {
				switch(CountryCode.ToLower()) {
					case "us":
						Match myZipMatcher = Regex.Match(Value, @"^\d{5}(-?\d{4})?$");
						return myZipMatcher.Success;
					default:
						//do nothing
						return false;
				}
			}
		//<-- End Method :: IsPostalCode
		
		//##################################################################################
		
		//--> Begin Method :: IsAlpha
			public static bool IsAlpha(string Value) {
				Match myAlphaMatcher = Regex.Match(Value, @"^[a-zA-Z]+$");
				return myAlphaMatcher.Success;
			}
		//<-- End Method :: IsAlpha
		
		//##################################################################################
		
		//--> Begin Method :: IsIPv4
			public static bool IsIPv4(string Value) {
				Regex myRegEx = new Regex(@"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.) {3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");
				return myRegEx.IsMatch(Value);
			}
		//<-- End Method :: IsIPv4
		
		//##################################################################################
		
		//--> Begin Method :: IsInt
			public static bool IsInt(string Value) {
				try {
					int Test = Convert.ToInt32(Value);
					return true;
				}
				catch(Exception e) {
					return false;
				}
			}
		//<-- End Method :: IsInt
		
		//##################################################################################
		
		//--> Begin Method :: IsDouble
			public static bool IsDouble(string Value) {
				try {
					double Test = Convert.ToDouble(Value);
					return true;
				}
				catch(Exception e) {
					return false;
				}
			}
		//<-- End Method :: IsDouble
		
		//##################################################################################
		
		//--> Begin Method :: IsNumeric
			public static bool IsNumeric(string Value) {
				return DataValidator.IsDouble(Value);
			}
		//<-- End Method :: IsNumeric
		
		//##################################################################################
		
		//--> Begin Method :: IsDateTime
			public static bool IsDateTime(string Value) {
				try {
					DateTime Test = DateTime.Parse(Value);
					return true;
				}
				catch(Exception e) {
					return false;
				}
			}
		//<-- End Method :: IsDateTime
		
		//##################################################################################
		
		//--> Begin Method :: MinLength
			public static bool MinLength(string Value, int Length) {
				if(Value.Length >= Length){
					return true;
				}
				else{
					return false;
				}
			}
		//<-- End Method :: MinLength
		
		//##################################################################################
		
		//--> Begin Method :: MaxLength
			public static bool MaxLength(string Value, int Length) {
				if(Value.Length <= Length){
					return true;
				}
				else{
					return false;
				}
			}
		//<-- End Method :: MaxLength
		
		//##################################################################################
		
		//--> Begin Method :: Length
			public static bool Length(string Value, int Length) {
				if(Value.Length == Length){
					return true;
				}
				else{
					return false;
				}
			}
		//<-- End Method :: Length
	}
//<-- End Class :: DataValidator

//##########################################################################################
</script>