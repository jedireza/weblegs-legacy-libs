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
	WebLegs.Codec = function() {
		//no constructor, no properties
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: URLEncode
	WebLegs.Codec.URLEncode = function(Input) {
		return encodeURIComponent(Input);
	};
//<-- End Method :: URLEncode

//##########################################################################################

//--> Begin Method :: URLDecode
	WebLegs.Codec.URLDecode = function(Input) {
		return decodeURIComponent(Input);
	};
//<-- End Method :: URLDecode

//##########################################################################################

//--> Begin Method :: HTMLEncode
	WebLegs.Codec.HTMLEncode = function(Input) {
		var Output = "";
	
		for(var i = 0; i < Input.length ; i++)	{
			var Char = Input.charAt(i);
			
			switch(Char) {
				case String.fromCharCode(0x00c1): Char = "&Aacute;"; break;
				case String.fromCharCode(0x00e1): Char = "&aacute;"; break;
				case String.fromCharCode(0x00c2): Char = "&Acirc;"; break;
				case String.fromCharCode(0x00e2): Char = "&acirc;"; break;
				case String.fromCharCode(0x00b4): Char = "&acute;"; break;
				case String.fromCharCode(0x00c6): Char = "&AElig;"; break;
				case String.fromCharCode(0x00e6): Char = "&aelig;"; break;
				case String.fromCharCode(0x00c0): Char = "&Agrave;"; break;
				case String.fromCharCode(0x00e0): Char = "&agrave;"; break;
				case String.fromCharCode(0x2135): Char = "&alefsym;"; break;
				case String.fromCharCode(0x0391): Char = "&Alpha;"; break;
				case String.fromCharCode(0x03b1): Char = "&alpha;"; break;
				case String.fromCharCode(0x0026): Char = "&amp;"; break;
				case String.fromCharCode(0x2227): Char = "&and;"; break;
				case String.fromCharCode(0x2220): Char = "&ang;"; break;
				case String.fromCharCode(0x00c5): Char = "&Aring;"; break;
				case String.fromCharCode(0x00e5): Char = "&aring;"; break;
				case String.fromCharCode(0x2248): Char = "&asymp;"; break;
				case String.fromCharCode(0x00c3): Char = "&Atilde;"; break;
				case String.fromCharCode(0x00e3): Char = "&atilde;"; break;
				case String.fromCharCode(0x00c4): Char = "&Auml;"; break;
				case String.fromCharCode(0x00e4): Char = "&auml;"; break;
				case String.fromCharCode(0x201e): Char = "&bdquo;"; break;
				case String.fromCharCode(0x0392): Char = "&Beta;"; break;
				case String.fromCharCode(0x03b2): Char = "&beta;"; break;
				case String.fromCharCode(0x00a6): Char = "&brvbar;"; break;
				case String.fromCharCode(0x2022): Char = "&bull;"; break;
				case String.fromCharCode(0x2229): Char = "&cap;"; break;
				case String.fromCharCode(0x00c7): Char = "&Ccedil;"; break;
				case String.fromCharCode(0x00e7): Char = "&ccedil;"; break;
				case String.fromCharCode(0x00b8): Char = "&cedil;"; break;
				case String.fromCharCode(0x00a2): Char = "&cent;"; break;
				case String.fromCharCode(0x03a7): Char = "&Chi;"; break;
				case String.fromCharCode(0x03c7): Char = "&chi;"; break;
				case String.fromCharCode(0x02c6): Char = "&circ;"; break;
				case String.fromCharCode(0x2663): Char = "&clubs;"; break;
				case String.fromCharCode(0x2245): Char = "&cong;"; break;
				case String.fromCharCode(0x00a9): Char = "&copy;"; break;
				case String.fromCharCode(0x21b5): Char = "&crarr;"; break;
				case String.fromCharCode(0x222a): Char = "&cup;"; break;
				case String.fromCharCode(0x00a4): Char = "&curren;"; break;
				case String.fromCharCode(0x2020): Char = "&dagger;"; break;
				case String.fromCharCode(0x2021): Char = "&Dagger;"; break;
				case String.fromCharCode(0x2193): Char = "&darr;"; break;
				case String.fromCharCode(0x21d3): Char = "&dArr;"; break;
				case String.fromCharCode(0x00b0): Char = "&deg;"; break;
				case String.fromCharCode(0x0394): Char = "&Delta;"; break;
				case String.fromCharCode(0x03b4): Char = "&delta;"; break;
				case String.fromCharCode(0x2666): Char = "&diams;"; break;
				case String.fromCharCode(0x00f7): Char = "&divide;"; break;
				case String.fromCharCode(0x00c9): Char = "&Eacute;"; break;
				case String.fromCharCode(0x00e9): Char = "&eacute;"; break;
				case String.fromCharCode(0x00ca): Char = "&Ecirc;"; break;
				case String.fromCharCode(0x00ea): Char = "&ecirc;"; break;
				case String.fromCharCode(0x00c8): Char = "&Egrave;"; break;
				case String.fromCharCode(0x00e8): Char = "&egrave;"; break;
				case String.fromCharCode(0x2205): Char = "&empty;"; break;
				case String.fromCharCode(0x2003): Char = "&emsp;"; break;
				case String.fromCharCode(0x2002): Char = "&ensp;"; break;
				case String.fromCharCode(0x0395): Char = "&Epsilon;"; break;
				case String.fromCharCode(0x03b5): Char = "&epsilon;"; break;
				case String.fromCharCode(0x2261): Char = "&equiv;"; break;
				case String.fromCharCode(0x0397): Char = "&Eta;"; break;
				case String.fromCharCode(0x03b7): Char = "&eta;"; break;
				case String.fromCharCode(0x00d0): Char = "&ETH;"; break;
				case String.fromCharCode(0x00f0): Char = "&eth;"; break;
				case String.fromCharCode(0x00cb): Char = "&Euml;"; break;
				case String.fromCharCode(0x00eb): Char = "&euml;"; break;
				case String.fromCharCode(0x20ac): Char = "&euro;"; break;
				case String.fromCharCode(0x2203): Char = "&exist;"; break;
				case String.fromCharCode(0x0192): Char = "&fnof;"; break;
				case String.fromCharCode(0x2200): Char = "&forall;"; break;
				case String.fromCharCode(0x00bd): Char = "&frac12;"; break;
				case String.fromCharCode(0x00bc): Char = "&frac14;"; break;
				case String.fromCharCode(0x00be): Char = "&frac34;"; break;
				case String.fromCharCode(0x2044): Char = "&frasl;"; break;
				case String.fromCharCode(0x0393): Char = "&Gamma;"; break;
				case String.fromCharCode(0x03b3): Char = "&gamma;"; break;
				case String.fromCharCode(0x2265): Char = "&ge;"; break;
				case String.fromCharCode(0x003e): Char = "&gt;"; break;
				case String.fromCharCode(0x2194): Char = "&harr;"; break;
				case String.fromCharCode(0x21d4): Char = "&hArr;"; break;
				case String.fromCharCode(0x2665): Char = "&hearts;"; break;
				case String.fromCharCode(0x2026): Char = "&hellip;"; break;
				case String.fromCharCode(0x00cd): Char = "&Iacute;"; break;
				case String.fromCharCode(0x00ed): Char = "&iacute;"; break;
				case String.fromCharCode(0x00ce ): Char = "&Icirc;"; break;
				case String.fromCharCode(0x00ee): Char = "&icirc;"; break;
				case String.fromCharCode(0x00a1): Char = "&iexcl;"; break;
				case String.fromCharCode(0x00cc): Char = "&Igrave;"; break;
				case String.fromCharCode(0x00ec): Char = "&igrave;"; break;
				case String.fromCharCode(0x2111): Char = "&image;"; break;
				case String.fromCharCode(0x221e): Char = "&infin;"; break;
				case String.fromCharCode(0x222b): Char = "&int;"; break;
				case String.fromCharCode(0x0399): Char = "&Iota;"; break;
				case String.fromCharCode(0x03b9): Char = "&iota;"; break;
				case String.fromCharCode(0x00bf): Char = "&iquest;"; break;
				case String.fromCharCode(0x2208): Char = "&isin;"; break;
				case String.fromCharCode(0x00cf): Char = "&Iuml;"; break;
				case String.fromCharCode(0x00ef): Char = "&iuml;"; break;
				case String.fromCharCode(0x039a): Char = "&Kappa;"; break;
				case String.fromCharCode(0x03ba): Char = "&kappa;"; break;
				case String.fromCharCode(0x039b): Char = "&Lambda;"; break;
				case String.fromCharCode(0x03bb): Char = "&lambda;"; break;
				case String.fromCharCode(0x2329): Char = "&lang;"; break;
				case String.fromCharCode(0x00ab): Char = "&laquo;"; break;
				case String.fromCharCode(0x2190): Char = "&larr;"; break;
				case String.fromCharCode(0x21d0): Char = "&lArr;"; break;
				case String.fromCharCode(0x2308): Char = "&lceil;"; break;
				case String.fromCharCode(0x201c): Char = "&ldquo;"; break;
				case String.fromCharCode(0x2264): Char = "&le;"; break;
				case String.fromCharCode(0x230a): Char = "&lfloor;"; break;
				case String.fromCharCode(0x2217): Char = "&lowast;"; break;
				case String.fromCharCode(0x25ca): Char = "&loz;"; break;
				case String.fromCharCode(0x200e): Char = "&lrm;"; break;
				case String.fromCharCode(0x2039): Char = "&lsaquo;"; break;
				case String.fromCharCode(0x2018): Char = "&lsquo;"; break;
				case String.fromCharCode(0x003c): Char = "&lt;"; break;
				case String.fromCharCode(0x00af): Char = "&macr;"; break;
				case String.fromCharCode(0x2014): Char = "&mdash;"; break;
				case String.fromCharCode(0x00b5): Char = "&micro;"; break;
				case String.fromCharCode(0x00b7): Char = "&middot;"; break;
				case String.fromCharCode(0x2212): Char = "&minus;"; break;
				case String.fromCharCode(0x039c): Char = "&Mu;"; break;
				case String.fromCharCode(0x03bc): Char = "&mu;"; break;
				case String.fromCharCode(0x2207): Char = "&nabla;"; break;
				case String.fromCharCode(0x00a0): Char = "&nbsp;"; break;
				case String.fromCharCode(0x2013): Char = "&ndash;"; break;
				case String.fromCharCode(0x2260): Char = "&ne;"; break;
				case String.fromCharCode(0x220b): Char = "&ni;"; break;
				case String.fromCharCode(0x00ac): Char = "&not;"; break;
				case String.fromCharCode(0x2209): Char = "&notin;"; break;
				case String.fromCharCode(0x2284): Char = "&nsub;"; break;
				case String.fromCharCode(0x00d1): Char = "&Ntilde;"; break;
				case String.fromCharCode(0x00f1): Char = "&ntilde;"; break;
				case String.fromCharCode(0x039d): Char = "&Nu;"; break;
				case String.fromCharCode(0x03bd): Char = "&nu;"; break;
				case String.fromCharCode(0x00d3): Char = "&Oacute;"; break;
				case String.fromCharCode(0x00f3): Char = "&oacute;"; break;
				case String.fromCharCode(0x00d4): Char = "&Ocirc;"; break;
				case String.fromCharCode(0x00f4): Char = "&ocirc;"; break;
				case String.fromCharCode(0x0152): Char = "&OElig;"; break;
				case String.fromCharCode(0x0153): Char = "&oelig;"; break;
				case String.fromCharCode(0x00d2): Char = "&Ograve;"; break;
				case String.fromCharCode(0x00f2): Char = "&ograve;"; break;
				case String.fromCharCode(0x203e): Char = "&oline;"; break;
				case String.fromCharCode(0x03a9): Char = "&Omega;"; break;
				case String.fromCharCode(0x03c9): Char = "&omega;"; break;
				case String.fromCharCode(0x039f): Char = "&Omicron;"; break;
				case String.fromCharCode(0x03bf): Char = "&omicron;"; break;
				case String.fromCharCode(0x2295): Char = "&oplus;"; break;
				case String.fromCharCode(0x2228): Char = "&or;"; break;
				case String.fromCharCode(0x00aa): Char = "&ordf;"; break;
				case String.fromCharCode(0x00ba): Char = "&ordm;"; break;
				case String.fromCharCode(0x00d8): Char = "&Oslash;"; break;
				case String.fromCharCode(0x00f8): Char = "&oslash;"; break;
				case String.fromCharCode(0x00d5): Char = "&Otilde;"; break;
				case String.fromCharCode(0x00f5): Char = "&otilde;"; break;
				case String.fromCharCode(0x2297): Char = "&otimes;"; break;
				case String.fromCharCode(0x00d6): Char = "&Ouml;"; break;
				case String.fromCharCode(0x00f6): Char = "&ouml;"; break;
				case String.fromCharCode(0x00b6): Char = "&para;"; break;
				case String.fromCharCode(0x2202): Char = "&part;"; break;
				case String.fromCharCode(0x2030): Char = "&permil;"; break;
				case String.fromCharCode(0x22a5): Char = "&perp;"; break;
				case String.fromCharCode(0x03a6): Char = "&Phi;"; break;
				case String.fromCharCode(0x03c6): Char = "&phi;"; break;
				case String.fromCharCode(0x03a0): Char = "&Pi;"; break;
				case String.fromCharCode(0x03c0): Char = "&pi;"; break;
				case String.fromCharCode(0x03d6): Char = "&piv;"; break;
				case String.fromCharCode(0x00b1): Char = "&plusmn;"; break;
				case String.fromCharCode(0x00a3): Char = "&pound;"; break;
				case String.fromCharCode(0x2032): Char = "&prime;"; break;
				case String.fromCharCode(0x2033): Char = "&Prime;"; break;
				case String.fromCharCode(0x220f): Char = "&prod;"; break;
				case String.fromCharCode(0x221d): Char = "&prop;"; break;
				case String.fromCharCode(0x03a8): Char = "&Psi;"; break;
				case String.fromCharCode(0x03c8): Char = "&psi;"; break;
				case String.fromCharCode(0x0022): Char = "&quot;"; break;
				case String.fromCharCode(0x221a): Char = "&radic;"; break;
				case String.fromCharCode(0x232a): Char = "&rang;"; break;
				case String.fromCharCode(0x00bb): Char = "&raquo;"; break;
				case String.fromCharCode(0x2192): Char = "&rarr;"; break;
				case String.fromCharCode(0x21d2): Char = "&rArr;"; break;
				case String.fromCharCode(0x2309): Char = "&rceil;"; break;
				case String.fromCharCode(0x201d): Char = "&rdquo;"; break;
				case String.fromCharCode(0x211c): Char = "&real;"; break;
				case String.fromCharCode(0x00ae): Char = "&reg;"; break;
				case String.fromCharCode(0x230b): Char = "&rfloor;"; break;
				case String.fromCharCode(0x03a1): Char = "&Rho;"; break;
				case String.fromCharCode(0x03c1): Char = "&rho;"; break;
				case String.fromCharCode(0x200f): Char = "&rlm;"; break;
				case String.fromCharCode(0x203a): Char = "&rsaquo;"; break;
				case String.fromCharCode(0x2019): Char = "&rsquo;"; break;
				case String.fromCharCode(0x201a): Char = "&sbquo;"; break;
				case String.fromCharCode(0x0160): Char = "&Scaron;"; break;
				case String.fromCharCode(0x0161): Char = "&scaron;"; break;
				case String.fromCharCode(0x22c5): Char = "&sdot;"; break;
				case String.fromCharCode(0x00a7): Char = "&sect;"; break;
				case String.fromCharCode(0x00ad): Char = "&shy;"; break;
				case String.fromCharCode(0x03a3): Char = "&Sigma;"; break;
				case String.fromCharCode(0x03c3): Char = "&sigma;"; break;
				case String.fromCharCode(0x03c2): Char = "&sigmaf;"; break;
				case String.fromCharCode(0x223c): Char = "&sim;"; break;
				case String.fromCharCode(0x2660): Char = "&spades;"; break;
				case String.fromCharCode(0x2282): Char = "&sub;"; break;
				case String.fromCharCode(0x2286): Char = "&sube;"; break;
				case String.fromCharCode(0x2211): Char = "&sum;"; break;
				case String.fromCharCode(0x2283): Char = "&sup;"; break;
				case String.fromCharCode(0x00b9): Char = "&sup1;"; break;
				case String.fromCharCode(0x00b2): Char = "&sup2;"; break;
				case String.fromCharCode(0x00b3): Char = "&sup3;"; break;
				case String.fromCharCode(0x2287): Char = "&supe;"; break;
				case String.fromCharCode(0x00df): Char = "&szlig;"; break;
				case String.fromCharCode(0x03a4): Char = "&Tau;"; break;
				case String.fromCharCode(0x03c4): Char = "&tau;"; break;
				case String.fromCharCode(0x2234): Char = "&there4;"; break;
				case String.fromCharCode(0x0398): Char = "&Theta;"; break;
				case String.fromCharCode(0x03b8): Char = "&theta;"; break;
				case String.fromCharCode(0x03d1): Char = "&thetasym;"; break;
				case String.fromCharCode(0x2009): Char = "&thinsp;"; break;
				case String.fromCharCode(0x00de): Char = "&THORN;"; break;
				case String.fromCharCode(0x00fe): Char = "&thorn;"; break;
				case String.fromCharCode(0x02dc): Char = "&tilde;"; break;
				case String.fromCharCode(0x00d7): Char = "&times;"; break;
				case String.fromCharCode(0x2122): Char = "&trade;"; break;
				case String.fromCharCode(0x00da): Char = "&Uacute;"; break;
				case String.fromCharCode(0x00fa): Char = "&uacute;"; break;
				case String.fromCharCode(0x2191): Char = "&uarr;"; break;
				case String.fromCharCode(0x21d1): Char = "&uArr;"; break;
				case String.fromCharCode(0x00db): Char = "&Ucirc;"; break;
				case String.fromCharCode(0x00fb): Char = "&ucirc;"; break;
				case String.fromCharCode(0x00d9): Char = "&Ugrave;"; break;
				case String.fromCharCode(0x00f9): Char = "&ugrave;"; break;
				case String.fromCharCode(0x00a8): Char = "&uml;"; break;
				case String.fromCharCode(0x03d2): Char = "&upsih;"; break;
				case String.fromCharCode(0x03a5): Char = "&Upsilon;"; break;
				case String.fromCharCode(0x03c5): Char = "&upsilon;"; break;
				case String.fromCharCode(0x00dc): Char = "&Uuml;"; break;
				case String.fromCharCode(0x00fc): Char = "&uuml;"; break;
				case String.fromCharCode(0x2118): Char = "&weierp;"; break;
				case String.fromCharCode(0x039e): Char = "&Xi;"; break;
				case String.fromCharCode(0x03be): Char = "&xi;"; break;
				case String.fromCharCode(0x00dd): Char = "&Yacute;"; break;
				case String.fromCharCode(0x00fd): Char = "&yacute;"; break;
				case String.fromCharCode(0x00a5): Char = "&yen;"; break;
				case String.fromCharCode(0x00ff): Char = "&yuml;"; break;
				case String.fromCharCode(0x0178): Char = "&Yuml;"; break;
				case String.fromCharCode(0x0396): Char = "&Zeta;"; break;
				case String.fromCharCode(0x03b6): Char = "&zeta;"; break;
				case String.fromCharCode(0x200d): Char = "&zwj;"; break;
				case String.fromCharCode(0x200c): Char = "&zwnj;"; break;
				default: Char = Char; break;
			}
			
			Output += Char;
		}
		return Output;
	};
//<-- End Method :: HTMLEncode

//##########################################################################################

//--> Begin Method :: HTMLDecode
	WebLegs.Codec.HTMLDecode = function(Input) {
		var Output = "";
	
		for(var i = 0; i < Input.length ; i++)	{
			var Char = Input.charAt(i);
			if(Char == "&") {
				var SemicolonIndex = Input.indexOf(";", i + 1);
				if(SemicolonIndex > 0) {
					var Entity = Input.substring(i + 1, SemicolonIndex);
					if(Entity.length > 1 && Entity.charAt(0) == "#") {
						if(Entity.charAt(1) == "x" || Entity.charAt(1) == "X") {
							Char = String.fromCharCode(eval("0"+ Entity.substring(1)));
						}
						else {
							Char = String.fromCharCode(eval(Entity.substring(1)));
						}
					}
					else{
						switch(Entity) {
							case "Aacute": Char = String.fromCharCode(0x00c1); break;
							case "aacute": Char = String.fromCharCode(0x00e1); break;
							case "Acirc": Char = String.fromCharCode(0x00c2); break;
							case "acirc": Char = String.fromCharCode(0x00e2); break;
							case "acute": Char = String.fromCharCode(0x00b4); break;
							case "AElig": Char = String.fromCharCode(0x00c6); break;
							case "aelig": Char = String.fromCharCode(0x00e6); break;
							case "Agrave": Char = String.fromCharCode(0x00c0); break;
							case "agrave": Char = String.fromCharCode(0x00e0); break;
							case "alefsym": Char = String.fromCharCode(0x2135); break;
							case "Alpha": Char = String.fromCharCode(0x0391); break;
							case "alpha": Char = String.fromCharCode(0x03b1); break;
							case "amp": Char = String.fromCharCode(0x0026); break;
							case "and": Char = String.fromCharCode(0x2227); break;
							case "ang": Char = String.fromCharCode(0x2220); break;
							case "Aring": Char = String.fromCharCode(0x00c5); break;
							case "aring": Char = String.fromCharCode(0x00e5); break;
							case "asymp": Char = String.fromCharCode(0x2248); break;
							case "Atilde": Char = String.fromCharCode(0x00c3); break;
							case "atilde": Char = String.fromCharCode(0x00e3); break;
							case "Auml": Char = String.fromCharCode(0x00c4); break;
							case "auml": Char = String.fromCharCode(0x00e4); break;
							case "bdquo": Char = String.fromCharCode(0x201e); break;
							case "Beta": Char = String.fromCharCode(0x0392); break;
							case "beta": Char = String.fromCharCode(0x03b2); break;
							case "brvbar": Char = String.fromCharCode(0x00a6); break;
							case "bull": Char = String.fromCharCode(0x2022); break;
							case "cap": Char = String.fromCharCode(0x2229); break;
							case "Ccedil": Char = String.fromCharCode(0x00c7); break;
							case "ccedil": Char = String.fromCharCode(0x00e7); break;
							case "cedil": Char = String.fromCharCode(0x00b8); break;
							case "cent": Char = String.fromCharCode(0x00a2); break;
							case "Chi": Char = String.fromCharCode(0x03a7); break;
							case "chi": Char = String.fromCharCode(0x03c7); break;
							case "circ": Char = String.fromCharCode(0x02c6); break;
							case "clubs": Char = String.fromCharCode(0x2663); break;
							case "cong": Char = String.fromCharCode(0x2245); break;
							case "copy": Char = String.fromCharCode(0x00a9); break;
							case "crarr": Char = String.fromCharCode(0x21b5); break;
							case "cup": Char = String.fromCharCode(0x222a); break;
							case "curren": Char = String.fromCharCode(0x00a4); break;
							case "dagger": Char = String.fromCharCode(0x2020); break;
							case "Dagger": Char = String.fromCharCode(0x2021); break;
							case "darr": Char = String.fromCharCode(0x2193); break;
							case "dArr": Char = String.fromCharCode(0x21d3); break;
							case "deg": Char = String.fromCharCode(0x00b0); break;
							case "Delta": Char = String.fromCharCode(0x0394); break;
							case "delta": Char = String.fromCharCode(0x03b4); break;
							case "diams": Char = String.fromCharCode(0x2666); break;
							case "divide": Char = String.fromCharCode(0x00f7); break;
							case "Eacute": Char = String.fromCharCode(0x00c9); break;
							case "eacute": Char = String.fromCharCode(0x00e9); break;
							case "Ecirc": Char = String.fromCharCode(0x00ca); break;
							case "ecirc": Char = String.fromCharCode(0x00ea); break;
							case "Egrave": Char = String.fromCharCode(0x00c8); break;
							case "egrave": Char = String.fromCharCode(0x00e8); break;
							case "empty": Char = String.fromCharCode(0x2205); break;
							case "emsp": Char = String.fromCharCode(0x2003); break;
							case "ensp": Char = String.fromCharCode(0x2002); break;
							case "Epsilon": Char = String.fromCharCode(0x0395); break;
							case "epsilon": Char = String.fromCharCode(0x03b5); break;
							case "equiv": Char = String.fromCharCode(0x2261); break;
							case "Eta": Char = String.fromCharCode(0x0397); break;
							case "eta": Char = String.fromCharCode(0x03b7); break;
							case "ETH": Char = String.fromCharCode(0x00d0); break;
							case "eth": Char = String.fromCharCode(0x00f0); break;
							case "Euml": Char = String.fromCharCode(0x00cb); break;
							case "euml": Char = String.fromCharCode(0x00eb); break;
							case "euro": Char = String.fromCharCode(0x20ac); break;
							case "exist": Char = String.fromCharCode(0x2203); break;
							case "fnof": Char = String.fromCharCode(0x0192); break;
							case "forall": Char = String.fromCharCode(0x2200); break;
							case "frac12": Char = String.fromCharCode(0x00bd); break;
							case "frac14": Char = String.fromCharCode(0x00bc); break;
							case "frac34": Char = String.fromCharCode(0x00be); break;
							case "frasl": Char = String.fromCharCode(0x2044); break;
							case "Gamma": Char = String.fromCharCode(0x0393); break;
							case "gamma": Char = String.fromCharCode(0x03b3); break;
							case "ge": Char = String.fromCharCode(0x2265); break;
							case "gt": Char = String.fromCharCode(0x003e); break;
							case "harr": Char = String.fromCharCode(0x2194); break;
							case "hArr": Char = String.fromCharCode(0x21d4); break;
							case "hearts": Char = String.fromCharCode(0x2665); break;
							case "hellip": Char = String.fromCharCode(0x2026); break;
							case "Iacute": Char = String.fromCharCode(0x00cd); break;
							case "iacute": Char = String.fromCharCode(0x00ed); break;
							case "Icirc": Char = String.fromCharCode(0x00ce ); break;
							case "icirc": Char = String.fromCharCode(0x00ee); break;
							case "iexcl": Char = String.fromCharCode(0x00a1); break;
							case "Igrave": Char = String.fromCharCode(0x00cc); break;
							case "igrave": Char = String.fromCharCode(0x00ec); break;
							case "image": Char = String.fromCharCode(0x2111); break;
							case "infin": Char = String.fromCharCode(0x221e); break;
							case "int": Char = String.fromCharCode(0x222b); break;
							case "Iota": Char = String.fromCharCode(0x0399); break;
							case "iota": Char = String.fromCharCode(0x03b9); break;
							case "iquest": Char = String.fromCharCode(0x00bf); break;
							case "isin": Char = String.fromCharCode(0x2208); break;
							case "Iuml": Char = String.fromCharCode(0x00cf); break;
							case "iuml": Char = String.fromCharCode(0x00ef); break;
							case "Kappa": Char = String.fromCharCode(0x039a); break;
							case "kappa": Char = String.fromCharCode(0x03ba); break;
							case "Lambda": Char = String.fromCharCode(0x039b); break;
							case "lambda": Char = String.fromCharCode(0x03bb); break;
							case "lang": Char = String.fromCharCode(0x2329); break;
							case "laquo": Char = String.fromCharCode(0x00ab); break;
							case "larr": Char = String.fromCharCode(0x2190); break;
							case "lArr": Char = String.fromCharCode(0x21d0); break;
							case "lceil": Char = String.fromCharCode(0x2308); break;
							case "ldquo": Char = String.fromCharCode(0x201c); break;
							case "le": Char = String.fromCharCode(0x2264); break;
							case "lfloor": Char = String.fromCharCode(0x230a); break;
							case "lowast": Char = String.fromCharCode(0x2217); break;
							case "loz": Char = String.fromCharCode(0x25ca); break;
							case "lrm": Char = String.fromCharCode(0x200e); break;
							case "lsaquo": Char = String.fromCharCode(0x2039); break;
							case "lsquo": Char = String.fromCharCode(0x2018); break;
							case "lt": Char = String.fromCharCode(0x003c); break;
							case "macr": Char = String.fromCharCode(0x00af); break;
							case "mdash": Char = String.fromCharCode(0x2014); break;
							case "micro": Char = String.fromCharCode(0x00b5); break;
							case "middot": Char = String.fromCharCode(0x00b7); break;
							case "minus": Char = String.fromCharCode(0x2212); break;
							case "Mu": Char = String.fromCharCode(0x039c); break;
							case "mu": Char = String.fromCharCode(0x03bc); break;
							case "nabla": Char = String.fromCharCode(0x2207); break;
							case "nbsp": Char = String.fromCharCode(0x00a0); break;
							case "ndash": Char = String.fromCharCode(0x2013); break;
							case "ne": Char = String.fromCharCode(0x2260); break;
							case "ni": Char = String.fromCharCode(0x220b); break;
							case "not": Char = String.fromCharCode(0x00ac); break;
							case "notin": Char = String.fromCharCode(0x2209); break;
							case "nsub": Char = String.fromCharCode(0x2284); break;
							case "Ntilde": Char = String.fromCharCode(0x00d1); break;
							case "ntilde": Char = String.fromCharCode(0x00f1); break;
							case "Nu": Char = String.fromCharCode(0x039d); break;
							case "nu": Char = String.fromCharCode(0x03bd); break;
							case "Oacute": Char = String.fromCharCode(0x00d3); break;
							case "oacute": Char = String.fromCharCode(0x00f3); break;
							case "Ocirc": Char = String.fromCharCode(0x00d4); break;
							case "ocirc": Char = String.fromCharCode(0x00f4); break;
							case "OElig": Char = String.fromCharCode(0x0152); break;
							case "oelig": Char = String.fromCharCode(0x0153); break;
							case "Ograve": Char = String.fromCharCode(0x00d2); break;
							case "ograve": Char = String.fromCharCode(0x00f2); break;
							case "oline": Char = String.fromCharCode(0x203e); break;
							case "Omega": Char = String.fromCharCode(0x03a9); break;
							case "omega": Char = String.fromCharCode(0x03c9); break;
							case "Omicron": Char = String.fromCharCode(0x039f); break;
							case "omicron": Char = String.fromCharCode(0x03bf); break;
							case "oplus": Char = String.fromCharCode(0x2295); break;
							case "or": Char = String.fromCharCode(0x2228); break;
							case "ordf": Char = String.fromCharCode(0x00aa); break;
							case "ordm": Char = String.fromCharCode(0x00ba); break;
							case "Oslash": Char = String.fromCharCode(0x00d8); break;
							case "oslash": Char = String.fromCharCode(0x00f8); break;
							case "Otilde": Char = String.fromCharCode(0x00d5); break;
							case "otilde": Char = String.fromCharCode(0x00f5); break;
							case "otimes": Char = String.fromCharCode(0x2297); break;
							case "Ouml": Char = String.fromCharCode(0x00d6); break;
							case "ouml": Char = String.fromCharCode(0x00f6); break;
							case "para": Char = String.fromCharCode(0x00b6); break;
							case "part": Char = String.fromCharCode(0x2202); break;
							case "permil": Char = String.fromCharCode(0x2030); break;
							case "perp": Char = String.fromCharCode(0x22a5); break;
							case "Phi": Char = String.fromCharCode(0x03a6); break;
							case "phi": Char = String.fromCharCode(0x03c6); break;
							case "Pi": Char = String.fromCharCode(0x03a0); break;
							case "pi": Char = String.fromCharCode(0x03c0); break;
							case "piv": Char = String.fromCharCode(0x03d6); break;
							case "plusmn": Char = String.fromCharCode(0x00b1); break;
							case "pound": Char = String.fromCharCode(0x00a3); break;
							case "prime": Char = String.fromCharCode(0x2032); break;
							case "Prime": Char = String.fromCharCode(0x2033); break;
							case "prod": Char = String.fromCharCode(0x220f); break;
							case "prop": Char = String.fromCharCode(0x221d); break;
							case "Psi": Char = String.fromCharCode(0x03a8); break;
							case "psi": Char = String.fromCharCode(0x03c8); break;
							case "quot": Char = String.fromCharCode(0x0022); break;
							case "radic": Char = String.fromCharCode(0x221a); break;
							case "rang": Char = String.fromCharCode(0x232a); break;
							case "raquo": Char = String.fromCharCode(0x00bb); break;
							case "rarr": Char = String.fromCharCode(0x2192); break;
							case "rArr": Char = String.fromCharCode(0x21d2); break;
							case "rceil": Char = String.fromCharCode(0x2309); break;
							case "rdquo": Char = String.fromCharCode(0x201d); break;
							case "real": Char = String.fromCharCode(0x211c); break;
							case "reg": Char = String.fromCharCode(0x00ae); break;
							case "rfloor": Char = String.fromCharCode(0x230b); break;
							case "Rho": Char = String.fromCharCode(0x03a1); break;
							case "rho": Char = String.fromCharCode(0x03c1); break;
							case "rlm": Char = String.fromCharCode(0x200f); break;
							case "rsaquo": Char = String.fromCharCode(0x203a); break;
							case "rsquo": Char = String.fromCharCode(0x2019); break;
							case "sbquo": Char = String.fromCharCode(0x201a); break;
							case "Scaron": Char = String.fromCharCode(0x0160); break;
							case "scaron": Char = String.fromCharCode(0x0161); break;
							case "sdot": Char = String.fromCharCode(0x22c5); break;
							case "sect": Char = String.fromCharCode(0x00a7); break;
							case "shy": Char = String.fromCharCode(0x00ad); break;
							case "Sigma": Char = String.fromCharCode(0x03a3); break;
							case "sigma": Char = String.fromCharCode(0x03c3); break;
							case "sigmaf": Char = String.fromCharCode(0x03c2); break;
							case "sim": Char = String.fromCharCode(0x223c); break;
							case "spades": Char = String.fromCharCode(0x2660); break;
							case "sub": Char = String.fromCharCode(0x2282); break;
							case "sube": Char = String.fromCharCode(0x2286); break;
							case "sum": Char = String.fromCharCode(0x2211); break;
							case "sup": Char = String.fromCharCode(0x2283); break;
							case "sup1": Char = String.fromCharCode(0x00b9); break;
							case "sup2": Char = String.fromCharCode(0x00b2); break;
							case "sup3": Char = String.fromCharCode(0x00b3); break;
							case "supe": Char = String.fromCharCode(0x2287); break;
							case "szlig": Char = String.fromCharCode(0x00df); break;
							case "Tau": Char = String.fromCharCode(0x03a4); break;
							case "tau": Char = String.fromCharCode(0x03c4); break;
							case "there4": Char = String.fromCharCode(0x2234); break;
							case "Theta": Char = String.fromCharCode(0x0398); break;
							case "theta": Char = String.fromCharCode(0x03b8); break;
							case "thetasym": Char = String.fromCharCode(0x03d1); break;
							case "thinsp": Char = String.fromCharCode(0x2009); break;
							case "THORN": Char = String.fromCharCode(0x00de); break;
							case "thorn": Char = String.fromCharCode(0x00fe); break;
							case "tilde": Char = String.fromCharCode(0x02dc); break;
							case "times": Char = String.fromCharCode(0x00d7); break;
							case "trade": Char = String.fromCharCode(0x2122); break;
							case "Uacute": Char = String.fromCharCode(0x00da); break;
							case "uacute": Char = String.fromCharCode(0x00fa); break;
							case "uarr": Char = String.fromCharCode(0x2191); break;
							case "uArr": Char = String.fromCharCode(0x21d1); break;
							case "Ucirc": Char = String.fromCharCode(0x00db); break;
							case "ucirc": Char = String.fromCharCode(0x00fb); break;
							case "Ugrave": Char = String.fromCharCode(0x00d9); break;
							case "ugrave": Char = String.fromCharCode(0x00f9); break;
							case "uml": Char = String.fromCharCode(0x00a8); break;
							case "upsih": Char = String.fromCharCode(0x03d2); break;
							case "Upsilon": Char = String.fromCharCode(0x03a5); break;
							case "upsilon": Char = String.fromCharCode(0x03c5); break;
							case "Uuml": Char = String.fromCharCode(0x00dc); break;
							case "uuml": Char = String.fromCharCode(0x00fc); break;
							case "weierp": Char = String.fromCharCode(0x2118); break;
							case "Xi": Char = String.fromCharCode(0x039e); break;
							case "xi": Char = String.fromCharCode(0x03be); break;
							case "Yacute": Char = String.fromCharCode(0x00dd); break;
							case "yacute": Char = String.fromCharCode(0x00fd); break;
							case "yen": Char = String.fromCharCode(0x00a5); break;
							case "yuml": Char = String.fromCharCode(0x00ff); break;
							case "Yuml": Char = String.fromCharCode(0x0178); break;
							case "Zeta": Char = String.fromCharCode(0x0396); break;
							case "zeta": Char = String.fromCharCode(0x03b6); break;
							case "zwj": Char = String.fromCharCode(0x200d); break;
							case "zwnj": Char = String.fromCharCode(0x200c); break;
							default: Char = ''; break;
						}
					}
					i = SemicolonIndex;
				}
			}
			Output += Char;
		}
		return Output;
	};
//<-- End Method :: HTMLDecode

//##########################################################################################

//--> Begin Method :: XMLEncode
	WebLegs.Codec.XMLEncode = function(Input) {
		return Input.replace(/\&/g,'&'+'amp;').replace(/</g,'&'+'lt;').replace(/>/g,'&'+'gt;').replace(/\'/g,'&'+'apos;').replace(/\"/g,'&'+'quot;');;
	};
//<-- End Method :: URLEncode

//##########################################################################################

//--> Begin Method :: XMLDecode
	WebLegs.Codec.XMLDecode = function(Input) {
		return Input.replace(/\&amp\;/g, "&").replace(/\&lt\;/g, "<").replace(/\&gt\;/g, ">").replace(/\&quot\;/g, "\"").replace(/\&apos\;/g, "'");
	};
//<-- End Method :: XMLDecode

//##########################################################################################

//--> Begin Method :: Base64Encode
	WebLegs.Codec.Base64Encode = function(Input) {
		//create the mapping of valid base64 characters
		var CharacterMap = new Array(
			'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
			'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
			'0','1','2','3','4','5','6','7','8','9','+','/'
		);
		
		//math for optimal processing
			//get the InputLength
			var InputLength = Input.length;
			
			//get the EvenLength - ie. 40 / 3 = 13.333 | 13 * 3 = 39
			var EvenLength = parseInt(InputLength / 3) * 3; 
			
			//get the CharacterCount of what the output will be after encoding
			var CharacterCount = (parseInt((InputLength - 1) / 3) + 1) * 4;
			
			//set the DataLength to CharacterCount by default
			var DataLength = parseInt((CharacterCount + (CharacterCount - 1)) / 76); //76 characters per line
			if(CharacterCount < 76) {
				DataLength = CharacterCount;
			}
			
			//we want to pre-allocate the output size so its not done on each iteration
			var DataArray = new Array(DataLength);
		//end math for optimal processing
		
		//define loop iterators
		var InputIterator = 0;
		var DataIterator = 0;
		var SeparatorIterator = 0;
		
		//loop over input until EvenLength
		while(InputIterator < EvenLength) {
			//take a byte and shift it into bits 24-16
			var MaskedCharacters = (Input.charCodeAt(InputIterator++)) << 0x10;
			//take the next byte and shift it into bits 15-8
			MaskedCharacters |= (Input.charCodeAt(InputIterator++)) << 0x8;
			//take the next byte and shift it into bits 7-0
			MaskedCharacters |= (Input.charCodeAt(InputIterator++));
			
			//map 6 bits at a time to corresponding items in the CharacterMap
			DataArray[DataIterator++] = CharacterMap[(MaskedCharacters >> 0x12) & 0x3f];//bits 24 - 18
			DataArray[DataIterator++] = CharacterMap[(MaskedCharacters >> 0xC) & 0x3f];//bits 17 -12
			DataArray[DataIterator++] = CharacterMap[(MaskedCharacters >> 0x6) & 0x3f];//bits 11-6
			DataArray[DataIterator++] = CharacterMap[MaskedCharacters & 0x3f];//bits 5-0
			
			//increment the SeperatorIterator by 4 since we're processing 4 characters per iteration
			SeparatorIterator += 4;
			
			if(SeparatorIterator == 76){
				if(DataIterator < (DataLength - 1)) {
					DataArray[DataIterator++] = "\n";
					
					//restart SeparatorIterator
					SeparatorIterator = 0;
				}
			}
		}
		
		//get remainder length
		var RemainderLength = InputLength - EvenLength;
		
		//determine if padding is required
		if(RemainderLength > 0) {
			//set padding bits container
			var MaskedCharacters = (Input.charCodeAt(EvenLength)) << 0xA;
			if(RemainderLength == 2){
				MaskedCharacters |= (Input.charCodeAt(InputLength - 1)) << 0x2;
			}

			//map 6 padding bits at a time to corresponding items in the CharacterMap to the last bytes
			DataArray[DataLength - 4] = CharacterMap[MaskedCharacters >> 0xC];//bits 18 - 12
			DataArray[DataLength - 3] = CharacterMap[(MaskedCharacters >> 0x6) & 0x3f];//bits 11 - 6
			
			if(RemainderLength == 2){
				DataArray[DataLength - 2] = CharacterMap[MaskedCharacters & 0x3f];//bits 5 - 0
			}
			else{
				DataArray[DataLength - 2] = '=';
			}
			DataArray[DataLength - 1] = '=';
		}
		
		return DataArray.join("");
	};
//<-- End Method :: Base64Encode

//##########################################################################################

//--> Begin Method :: Base64Decode
	WebLegs.Codec.Base64Decode = function(Input) {
		//create the mapping of valid base64 characters as integers
		var CharacterIntegerMap = new Array(
			-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
			-1, -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,62,-1,-1,-1, 63, 52,53,54, 55,56,57,58,59,60,61,-1,-1,-1,0,-1,
			-1,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1,-1,26,
			27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-1,-1,-1,-1,-1,-1,-1,
			-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
			-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
			-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
			-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
		);
		
		//remove all illegal characters
		Input = Input.replace(/[^a-zA-Z0-9\+\/\=]/g, "");
		
		//get the count of all the padding characters
		var PaddingCount = 0;
		if(Input.indexOf("=") != -1) {
			PaddingCount = Input.length - Input.indexOf("=");
		}
		
		//if input is not divisible by 4, it's invalid
		if(Input.length % 4 != 0){
			throw("WebLegs.Codec.Base64Decode(): Input is not divisible by four. Cannot decode invalid input.");
		}
		
		//get length of output
		var DataLength = parseInt((Input.length * 6 >> 3) - PaddingCount);

		//create new bytearray for output data
		var DataArray = new Array(DataLength);

		//create iterators
		var InputIterator = 0;
		var DataIterator = 0;
		
		while(DataIterator < DataLength) {
			//get three bytes into MaskedCharacters
			var MaskedCharacters = CharacterIntegerMap[Input.charCodeAt(InputIterator++)] << 0x12;
			MaskedCharacters |= CharacterIntegerMap[Input.charCodeAt(InputIterator++)] << 0xC;
			MaskedCharacters |= CharacterIntegerMap[Input.charCodeAt(InputIterator++)] << 0x6;
			MaskedCharacters |= CharacterIntegerMap[Input.charCodeAt(InputIterator++)];
			
			//copy first byte
			DataArray[DataIterator++] = String.fromCharCode((MaskedCharacters >> 0x10) & 0xff);
			
			//check to make sure that there is any more data
			if(DataIterator < DataLength) {
				//copy second byte
				DataArray[DataIterator++] = String.fromCharCode((MaskedCharacters >> 0x8) & 0xff);
				
				//check to make sure that there is any more data
				if(DataIterator < DataLength){
					//copy final byte
					DataArray[DataIterator++] = String.fromCharCode((MaskedCharacters) & 0xff);
				}
			}
		}
		
		return DataArray.join("");
	};
//<-- End Method :: Base64Decode

//##########################################################################################

//--> Begin Method :: QuotedPrintableEncode
	WebLegs.Codec.QuotedPrintableEncode = function(Input) {
		//hex containers
		var HexChars = "0123456789ABCDEF";
		var HexLow = 0;
		var HexHigh = 0;
		
		//container for our final string
		var tmpQPString = "";
		
		//container for our current line length
		var CurrentLineLength = 0;
		
		//loop over bytes and build new string
		for(var i = 0 ; i < Input.length ; i++) {
			//Get one character at a time
			var Current = Input.charAt(i);
			
			//Keep track of the next character too... if its the last character
			//present return a CR character
			var Next = ((i + 1) != Input.length) ? Input.charAt(i + 1) : String.fromCharCode(0x0D);
			
			//make hex-style string out of the current byte
			var CurrentEncoded = "";
			
			//if this is the '=' character just encode it and return
			if(Current == '=') {
				HexLow = Input.charCodeAt(i) % 16;
				HexHigh = (Input.charCodeAt(i) - HexLow) / 16;
				CurrentEncoded = "="+ HexChars.charAt(HexHigh) + HexChars.charAt(HexLow);
			}
			//if this is any of these characters, just encode them
			else if(Current == '!' || Current == '"' || Current == '#' || Current == '$' || Current == '@' || Current == '[' || Current == '\\' || Current == ']' || Current == '^' || Current == '`' || Current == '{' || Current == '|' || Current == '}' || Current == '~' || Current == '\'') {
				HexLow = Input.charCodeAt(i) % 16;
				HexHigh = (Input.charCodeAt(i) - HexLow) / 16;
				CurrentEncoded = "="+ HexChars.charAt(HexHigh) + HexChars.charAt(HexLow);
			}
			//if we come across a tab or a space AND the next byte
			//represents CR or LF, we need to encode it too
			else if((Current == String.fromCharCode(0x09) || Current == String.fromCharCode(0x20)) && (Next == String.fromCharCode(0x0A) || Next == String.fromCharCode(0x0D))) {
				HexLow = Input.charCodeAt(i) % 16;
				HexHigh = (Input.charCodeAt(i) - HexLow) / 16;
				CurrentEncoded = "="+ HexChars.charAt(HexHigh) + HexChars.charAt(HexLow);
			}
			//is this character ok as is?
			else if((Current.charCodeAt(0) >= 33 && Current.charCodeAt(0) <= 126) || Current == String.fromCharCode(0x0D) || Current == String.fromCharCode(0x0A) || Current == String.fromCharCode(0x09) || Current == String.fromCharCode(0x20)) {
				CurrentEncoded = Current;
			}
			else {
				//if we get here, we've fell from above, ecode anything that gets here
				HexLow = Input.charCodeAt(i) % 16;
				HexHigh = (Input.charCodeAt(i) - HexLow) / 16;
				CurrentEncoded = "="+ HexChars.charAt(HexHigh) + HexChars.charAt(HexLow);
			}
			
			//let's make sure that we keep track of line length while
			//we append characters together for the final output
			
			//check for CR and LF to get away from double lines
			if(Current == String.fromCharCode(0x0D) || Current == String.fromCharCode(0x0A)) {
				//if we got here that means that we are at the end of the
				//line and we need to reset our line length tracking variable
				if(Current == String.fromCharCode(0x0A)) {
					CurrentLineLength = 0;
				}
			}
			
			//check to see if this pushes us past 76 characters
			//if so lets add a soft line break
			if(CurrentEncoded.length + CurrentLineLength > 76) {
				tmpQPString += "=\n";
				CurrentLineLength = 0;
			}
			
			//append this character and increase line length
			tmpQPString += CurrentEncoded;
			CurrentLineLength += CurrentEncoded.length;
		}
		
		//return our completed string
		return tmpQPString;
	};
//<-- End Method :: QuotedPrintableEncode

//##########################################################################################

//--> Begin Method :: QuotedPrintableDecode
	WebLegs.Codec.QuotedPrintableDecode = function(Input) {
		//hex containers
		var HexChars = "0123456789ABCDEF";
		var HexCharCode = 0;
		var HexLow = 0;
		var HexHigh = 0;
		
		//normalize newlines
		Input = Input.replace(/\r\n/g, "\n");
		//rule #3 trailing space must be deleted
		Input = Input.replace(/[ \t]+\n/g, "\n");
		//rule #5 soft line breaks
		Input = Input.replace(/=\n/g, "");
		//decode hex characters
		var HexMatcher = /(=([0-9A-F][0-9A-F]))/;
		var Matches = Output.match(HexMatcher);
		while(Matches) {
			//alert(Matches[1] +" | "+ Matches[2]);
			HexLow = HexChars.indexOf(Matches[2].charAt(1));
			HexHigh = 16 * HexChars.indexOf(Matches[2].charAt(0));
			HexCharCode = HexLow + HexHigh;
			Input = Input.replace(Matches[1], String.fromCharCode(HexCharCode));
			
			//get next match
			Matches = Input.match(HexMatcher);
		}
		return Input;
	};
//<-- End Method :: QuotedPrintableDecode

//##########################################################################################