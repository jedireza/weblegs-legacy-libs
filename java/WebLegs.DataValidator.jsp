<%@ page import="java.util.regex.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
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
			static boolean IsValidEmail(String EmailAddress) {				
				Pattern MyPattern = Pattern.compile("^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$");
				Matcher MyMatch = MyPattern.matcher(EmailAddress);
				return MyMatch.find();				
			}
		//<-- End Method :: IsValidEmail
		
		//##################################################################################
		
		//--> Begin Method :: IsValidURL
			static boolean IsValidURL(String URL) {
				Pattern MyPattern = Pattern.compile("^https?://[a-zA-Z0-9._%-]+\\.[a-zA-Z0-9.-]+$");
				Matcher MyMatch = MyPattern.matcher(URL);
				return MyMatch.find();	
			}
		//<-- End Method :: IsValidURL
		
		//##################################################################################
		
		//--> Begin Method :: IsPhone
			static boolean IsPhone(String Value) {
				return IsPhone(Value, "us");
			}
			static boolean IsPhone(String Value, String CountryCode) {
				CountryCode = CountryCode.toLowerCase();
				if(CountryCode.equals("us")) {
					Pattern MyPattern = Pattern.compile("(\\d-)?(\\d{3}-)?\\d{3}-\\d{4}");
					Matcher MyMatch = MyPattern.matcher(Value);
					return MyMatch.find();
				}
				return false;
			}
		//<-- End Method :: IsPhone
		
		//##################################################################################
		
		//--> Begin Method :: IsPostalCode
			static boolean IsPostalCode(String Value) {
				return IsPostalCode(Value, "us");
			}
			static boolean IsPostalCode(String Value, String CountryCode) {
				CountryCode = CountryCode.toLowerCase();
				if(CountryCode.equals("us")) {
					Pattern MyPattern = Pattern.compile("^\\d{5}(-?\\d{4})?$");
					Matcher MyMatch = MyPattern.matcher(Value);
					return MyMatch.find();
				}
				return false;
			}
		//<-- End Method :: IsPostalCode
		
		//##################################################################################
		
		//--> Begin Method :: IsAlpha
			static boolean IsAlpha(String Value) {
				Pattern MyPattern = Pattern.compile("^[a-zA-Z]+$");
				Matcher MyMatch = MyPattern.matcher(Value);
				return MyMatch.find();
			}
		//<-- End Method :: IsAlpha
		
		//##################################################################################
		
		//--> Begin Method :: IsIPv4
			static boolean IsIPv4(String Value) {
				String [] Parts = Value.split ("\\.");
				for(String Part : Parts){
					int i = Integer.parseInt(Part);
					if(i < 0 || i > 255){
						return false;
					}
				}
				return true;
			}
		//<-- End Method :: IsIPv4
		
		//##################################################################################
		
		//--> Begin Method :: IsInt
			static boolean IsInt(String Value) {
				try {
					Integer.parseInt(Value);
					return true;
				}
				catch(Exception e) {
					return false;
				}
			}
		//<-- End Method :: IsInt
		
		//##################################################################################
		
		//--> Begin Method :: IsDouble
			static boolean IsDouble(String Value) {
				try {
					Double.parseDouble(Value);
					return true;
				}
				catch(Exception e) {
					return false;
				}
			}
		//<-- End Method :: IsDouble
		
		//##################################################################################
		
		//--> Begin Method :: IsNumeric
			static boolean IsNumeric(String Value) {
				return DataValidator.IsDouble(Value);
			}
		//<-- End Method :: IsNumeric
		
		//##################################################################################
		
		//--> Begin Method :: IsDateTime
			static boolean IsDateTime(String Value) throws Exception {
				//try and parse some basic formats
				try{
					//create test calendar
					Calendar testCal = Calendar.getInstance();
					
					//ISO 8601 (YYYY-MM-ddThh:mm:ss) date and time
					if(Value.matches("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}$")) {
						//get matches
						Pattern MyPattern = Pattern.compile("^(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2}):(\\d{2}):(\\d{2})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
						Matcher MyMatcher = MyPattern.matcher(Value);
						
						while(MyMatcher.find()) {
							testCal.set(Integer.valueOf(MyMatcher.group(1)), (Integer.valueOf(MyMatcher.group(2)) - 1), Integer.valueOf(MyMatcher.group(3)), Integer.valueOf(MyMatcher.group(4)), Integer.valueOf(MyMatcher.group(5)), Integer.valueOf(MyMatcher.group(6)));
						}
						return true;
					}
					//mysql-ish (YYYY-MM-DD hh:mm:ss) time
					else if(Value.matches("^\\d{4}-\\d{1,2}-\\d{1,2} \\d{1,2}:\\d{2}:\\d{2}$")) {
						//get matches
						Pattern MyPattern = Pattern.compile("^(\\d{4})-(\\d{1,2})-(\\d{1,2}) (\\d{1,2}):(\\d{2}):(\\d{2})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
						Matcher MyMatcher = MyPattern.matcher(Value);
						while(MyMatcher.find()) {
							testCal.set(Integer.valueOf(MyMatcher.group(1)), (Integer.valueOf(MyMatcher.group(2)) - 1), Integer.valueOf(MyMatcher.group(3)), Integer.valueOf(MyMatcher.group(4)), Integer.valueOf(MyMatcher.group(5)), Integer.valueOf(MyMatcher.group(6)));
						}
						return true;
					}
					//mysql-ish (YYYY-MM-DD hh:mm:ss) time w/milliseconds
					else if(Value.matches("^\\d{4}-\\d{1,2}-\\d{1,2} \\d{1,2}:\\d{2}:\\d{2}\\.\\d{1}$")) {
						//get matches
						Pattern MyPattern = Pattern.compile("^(\\d{4})-(\\d{1,2})-(\\d{1,2}) (\\d{1,2}):(\\d{2}):(\\d{2})(\\.\\d{1})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
						Matcher MyMatcher = MyPattern.matcher(Value);
						while(MyMatcher.find()) {
							testCal.set(Integer.valueOf(MyMatcher.group(1)), (Integer.valueOf(MyMatcher.group(2)) - 1), Integer.valueOf(MyMatcher.group(3)), Integer.valueOf(MyMatcher.group(4)), Integer.valueOf(MyMatcher.group(5)), Integer.valueOf(MyMatcher.group(6)));
						}
						return true;
					}
					//ISO 8601 (YYYY-MM-dd) date
					else if(Value.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
						//get matches
						Pattern MyPattern = Pattern.compile("^(\\d{4})-(\\d{2})-(\\d{2})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
						Matcher MyMatcher = MyPattern.matcher(Value);
					
						while(MyMatcher.find()) {
							testCal.set(Integer.valueOf(MyMatcher.group(1)), (Integer.valueOf(MyMatcher.group(2)) - 1), Integer.valueOf(MyMatcher.group(3)));
						}
						return true;
					}
					//mm[/.-]dd[/.-]yyyy hh:mm:ss
					else if(Value.matches("^\\d{1,2}[\\/\\.\\-]\\d{1,2}[\\/\\.\\-]\\d{4} \\d{1,2}:\\d{2}:\\d{2}$")) {
						//get matches
						Pattern MyPattern = Pattern.compile("^(\\d{1,2})[\\/\\.\\-](\\d{1,2})[\\/\\.\\-](\\d{4}) (\\d{1,2}):(\\d{2}):(\\d{2})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
						Matcher MyMatcher = MyPattern.matcher(Value);
						
						while(MyMatcher.find()) {
							testCal.set(Integer.valueOf(MyMatcher.group(3)), (Integer.valueOf(MyMatcher.group(2)) - 1), Integer.valueOf(MyMatcher.group(1)), Integer.valueOf(MyMatcher.group(4)), Integer.valueOf(MyMatcher.group(5)), Integer.valueOf(MyMatcher.group(6)));
						}
						return true;
					}
					//mm[/.-]dd[/.-]yyyy
					else if(Value.matches("^\\d{1,2}[\\/\\.\\-]\\d{1,2}[\\/\\.\\-]\\d{4}$")) {
						//get matches
						Pattern MyPattern = Pattern.compile("^(\\d{1,2})[\\/\\.\\-](\\d{1,2})[\\/\\.\\-](\\d{4})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
						Matcher MyMatcher = MyPattern.matcher(Value);
						
						while(MyMatcher.find()) {
							testCal.set(Integer.valueOf(MyMatcher.group(3)), (Integer.valueOf(MyMatcher.group(2)) - 1), Integer.valueOf(MyMatcher.group(1)));
						}
						return true;
					}
					//hh:mm:ss
					else if(Value.matches("^\\d{2}:\\d{2}:\\d{2}$")) {
						//get matches
						Pattern MyPattern = Pattern.compile("^(\\d{2}):(\\d{2}):(\\d{2})$", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
						Matcher MyMatcher = MyPattern.matcher(Value);
						
						while(MyMatcher.find()) {
							//create tmpCal to get todays Date
							Calendar tmpCal = Calendar.getInstance();
							testCal.set(tmpCal.get(tmpCal.YEAR), tmpCal.get(tmpCal.MONTH), tmpCal.get(tmpCal.DAY_OF_MONTH), Integer.valueOf(MyMatcher.group(1)), Integer.valueOf(MyMatcher.group(2)), Integer.valueOf(MyMatcher.group(3)));
						}
						return true;
					}
				}
				catch(Exception e){
					throw new Exception(e.toString());
				}
				return false;
			}
		//<-- End Method :: IsDateTime
		
		//##################################################################################
		
		//--> Begin Method :: MinLength
			static boolean MinLength(String Value, int Length) {
				if(Value.length() >= Length){
					return true;
				}
				else{
					return false;
				}
			}
		//<-- End Method :: MinLength
		
		//##################################################################################
		
		//--> Begin Method :: MaxLength
			static boolean MaxLength(String Value, int Length) {
				if(Value.length() <= Length){
					return true;
				}
				else{
					return false;
				}
			}
		//<-- End Method :: MaxLength
		
		//##################################################################################
		
		//--> Begin Method :: Length
			static boolean Length(String Value, int Length) {
				if(Value.length() == Length){
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
%>