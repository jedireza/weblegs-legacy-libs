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
	WebLegs.XHRDriver = function() {
		//headers array
		this.Headers = new Array();
		
		//asynchronously?
		this.IsAsync = true;
		
		//Busy?
		this.IsBusy = false;
		
		//this appends a random id to the querysting 
		//so that the document is cached
		this.NoCache = true;
		
		//username && password
		this.Username = null;
		this.Password = null;
		
		//containers for url and postdata
		this.URL = null;
		this.PostData = null;
		
		//initialize (W3C) XMLHttpRequest object
		if(window.XMLHttpRequest) {
			this.Request =  new XMLHttpRequest();
		}
		else {
			var MsXMLEngines = [
				'Msxml2.XMLHTTP.5.0',
				'Msxml2.XMLHTTP.4.0',
				'Msxml2.XMLHTTP.3.0',
				'Msxml2.XMLHTTP',
				'Microsoft.XMLHTTP'
			];
			for(var i = 0 ; i < MsXMLEngines.length ; i++) {
				try{
					this.Request = new ActiveXObject(MsXMLEngines[i]);
				}
				catch(e) {
					//do nothing
				}
			}
		}
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: Get
	WebLegs.XHRDriver.prototype.Get = function(URL) {
		//get current instance
		var Instance = this;
		Instance.URL = URL;
		
		//turn on no cache?
		if(this.NoCache == true) {
			var Random = new Date().getTime();
			if(Instance.URL.indexOf("?") > 0) {
				Instance.URL += "&_no_cache="+ Random;
			}
			else {
				Instance.URL += "?_no_cache="+ Random;
			}
		}
		
		//setup the state handler
		this.Request.onreadystatechange = function() {
			switch(Instance.Request.readyState) {
				//- - - - - - - - - - - - - - - - - - - -//
				case 1:
					Instance.IsBusy = true;
					Instance.Loading();
					break;
				//- - - - - - - - - - - - - - - - - - - -//
				case 2:
					Instance.IsBusy = true;
					Instance.Loaded();
					break;
				//- - - - - - - - - - - - - - - - - - - -//
				case 3:
					Instance.IsBusy = true;
					Instance.Interactive();
					break;
				//- - - - - - - - - - - - - - - - - - - -//
				case 4:
					Instance.IsBusy = false;
					
					//return the response or bail out
					try {
						Instance.Complete({
							"status"		: Instance.Request.status,
							"statusText"	: Instance.Request.statusText,
							"responseText"	: Instance.Request.responseText,
							"responseXML"	: Instance.Request.responseXML
						});
					}
					catch(Error) {
						Instance.Error(Error);
					}
					
					//save us from memory leaks
					Instance.onreadystatechange = null;
					break;
				//- - - - - - - - - - - - - - - - - - - -//
				default:
					//do nothing
					break;
			}
		};
		
		//are we authenticating?
		if(this.Username != null) {
			this.Request.open("GET", Instance.URL, this.IsAsync, this.Username, this.Password);
		}
		else{
			this.Request.open("GET", Instance.URL, this.IsAsync);
		}
	
		//set specified request headers
		for(Key in this.Headers) {
			this.Request.setRequestHeader(Key, this.Headers[Key]);
		}
		
		//send request
		this.Request.send(null);
	};
//<-- End Method :: Get

//##########################################################################################

//--> Begin Method :: Post
	WebLegs.XHRDriver.prototype.Post = function(URL, PostData) {
		//get current instance
		var Instance = this;
		Instance.URL = URL;
		Instance.PostData = PostData;
		
		//turn on no cache?
		if(this.NoCache == true) {
			var Random = new Date().getTime();
			if(Instance.URL.indexOf("?") > 0) {
				Instance.URL += "&_no_cache="+ Random;
			}
			else {
				Instance.URL += "?_no_cache="+ Random;
			}
		}
	
		//setup the state handler
		this.Request.onreadystatechange = function() {
			switch(Instance.Request.readyState) {
				//- - - - - - - - - - - - - - - - - - - -//
				case 1:
					Instance.IsBusy = true;
					Instance.Loading();
					break;
				//- - - - - - - - - - - - - - - - - - - -//
				case 2:
					Instance.IsBusy = true;
					Instance.Loaded();
					break;
				//- - - - - - - - - - - - - - - - - - - -//
				case 3:
					Instance.IsBusy = true;
					Instance.Interactive();
					break;
				//- - - - - - - - - - - - - - - - - - - -//
				case 4:
					Instance.IsBusy = false;
					
					//return the response or bail out
					try {
						Instance.Complete({
							"status"		: Instance.Request.status,
							"statusText"	: Instance.Request.statusText,
							"responseText"	: Instance.Request.responseText,
							"responseXML"	: Instance.Request.responseXML
						});
					}
					catch(Error) {
						Instance.Error(Error);
					}
					
					//save us from memory leaks
					Instance.onreadystatechange = null;
					break;
				//- - - - - - - - - - - - - - - - - - - -//
				default:
					//do nothing
					break;
			}
		};
		
		//are we authenticating?
		if(this.Username != null) {
			this.Request.open("POST", Instance.URL, this.IsAsync, this.Username, this.Password);
		}
		else{
			this.Request.open("POST", Instance.URL, this.IsAsync);
		}
		
		//set specified request headers
		for(Key in this.Headers) {
			this.Request.setRequestHeader(Key, this.Headers[Key]);
		}
		
		//set the content type request header for POSTing
		this.Request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;");
		
		//send request
		this.Request.send(Instance.PostData);
	};
//<-- End Method :: Post

//##########################################################################################

//--> Begin Method :: AddRequestHeader
	WebLegs.XHRDriver.prototype.AddRequestHeader = function(Name, Value) {
		this.Headers[Name] = Value;
	};
//<-- End Method :: AddRequestHeader

//##########################################################################################

//--> Begin Method :: RemoveRequestHeader
	WebLegs.XHRDriver.prototype.RemoveRequestHeader = function(Name) {
		//create new header container
		var NewHeaders = new Array();
		for(Key in this.Headers) {
			if(Name != this.Headers[Key]) {
				NewHeaders[Key] = this.Headers[Key];
			}
		}
		
		//set new headers
		this.Headers = NewHeaders[Key];
	};
//<-- End Method :: RemoveRequestHeader

//##########################################################################################

//--> Begin Method :: GetRequestHeader
	WebLegs.XHRDriver.prototype.GetRequestHeader = function(Name) {
		if(this.Headers[Name] == undefined) {
			return null;
		}
		return this.Headers[Name];
	};
//<-- End Method :: GetRequestHeader

//##########################################################################################

//--> Begin Method :: GetResponseHeader
	WebLegs.XHRDriver.prototype.GetResponseHeader = function(Name) {
		var Instance = this;
		if(this.Request.readyState == 4) {
			if(Name != undefined) {
				return Instance.Request.getResponseHeader(Name)
			}
			return Instance.Request.getAllResponseHeaders();
		}
		else {
			return null;
		}
	};
//<-- End Method :: GetResponseHeader

//##########################################################################################

//--> Begin Method :: Abort
	WebLegs.XHRDriver.prototype.Abort = function() {
		this.Request.abort();
	};
//<-- End Method :: Abort

//##########################################################################################

//--> Begin Method :: IsSuccess
	WebLegs.XHRDriver.prototype.IsSuccess = function() {
		var Instance = this;
		if(Instance.Request.readyState == 4) {
			return Instance.Request.status == 200 ? true : false;
		}
		else {
			return false;
		}
	};
//<-- End Method :: IsSuccess

//##########################################################################################

//--> Begin Method :: Loading
	WebLegs.XHRDriver.prototype.Loading = function() {};
//<-- End Method :: Loading

//##########################################################################################

//--> Begin Method :: Loaded
	WebLegs.XHRDriver.prototype.Loaded = function() {};
//<-- End Method :: Loaded

//##########################################################################################

//--> Begin Method :: Interactive
	WebLegs.XHRDriver.prototype.Interactive = function() {};
//<-- End Method :: Interactive

//##########################################################################################

//--> Begin Method :: Complete
	WebLegs.XHRDriver.prototype.Complete = function(Response) {};
//<-- End Method :: Complete

//##########################################################################################

//--> Begin Method :: Error
	WebLegs.XHRDriver.prototype.Error = function(Error) {};
//<-- End Method :: Error

//##########################################################################################