<%@ page import="java.math.BigInteger" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
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

//--> Begin Class :: Codec
	public static class Codec {
		//--> Begin :: Properties
			//no properties
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			//no constructor
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: URLEncode
			static String URLEncode(String Input) throws Exception {
				return URLEncoder.encode(Input, "UTF-8");
			}
		//<-- End Method :: URLEncode
		
		//##################################################################################
		
		//--> Begin Method :: URLDecode
			static String URLDecode(String Input) throws Exception {
				return URLDecoder.decode(Input, "UTF-8");
			}
		//<-- End Method :: URLDecode
		
		//##################################################################################
		
		//--> Begin Method :: HTMLEncode
			static String HTMLEncode(String Input) {
				String Output = "";
				char MyCharArray[] = Input.toCharArray();
				for(int i = 0; i < MyCharArray.length ; i++){
					char Char = MyCharArray[i];
					String OutChar = "";
					
					if(Char == (char)0x00c1){ OutChar = "&Aacute;"; }
					else if(Char == (char)0x00e1){ OutChar = "&aacute;"; }
					else if(Char == (char)0x00c2){ OutChar = "&Acirc;"; }
					else if(Char == (char)0x00e2){ OutChar = "&acirc;"; }
					else if(Char == (char)0x00b4){ OutChar = "&acute;"; }
					else if(Char == (char)0x00c6){ OutChar = "&AElig;"; }
					else if(Char == (char)0x00e6){ OutChar = "&aelig;"; }
					else if(Char == (char)0x00c0){ OutChar = "&Agrave;"; }
					else if(Char == (char)0x00e0){ OutChar = "&agrave;"; }
					else if(Char == (char)0x2135){ OutChar = "&alefsym;"; }
					else if(Char == (char)0x0391){ OutChar = "&Alpha;"; }
					else if(Char == (char)0x03b1){ OutChar = "&alpha;"; }
					else if(Char == (char)0x0026){ OutChar = "&amp;"; }
					else if(Char == (char)0x2227){ OutChar = "&and;"; }
					else if(Char == (char)0x2220){ OutChar = "&ang;"; }
					else if(Char == (char)0x00c5){ OutChar = "&Aring;"; }
					else if(Char == (char)0x00e5){ OutChar = "&aring;"; }
					else if(Char == (char)0x2248){ OutChar = "&asymp;"; }
					else if(Char == (char)0x00c3){ OutChar = "&Atilde;"; }
					else if(Char == (char)0x00e3){ OutChar = "&atilde;"; }
					else if(Char == (char)0x00c4){ OutChar = "&Auml;"; }
					else if(Char == (char)0x00e4){ OutChar = "&auml;"; }
					else if(Char == (char)0x201e){ OutChar = "&bdquo;"; }
					else if(Char == (char)0x0392){ OutChar = "&Beta;"; }
					else if(Char == (char)0x03b2){ OutChar = "&beta;"; }
					else if(Char == (char)0x00a6){ OutChar = "&brvbar;"; }
					else if(Char == (char)0x2022){ OutChar = "&bull;"; }
					else if(Char == (char)0x2229){ OutChar = "&cap;"; }
					else if(Char == (char)0x00c7){ OutChar = "&Ccedil;"; }
					else if(Char == (char)0x00e7){ OutChar = "&ccedil;"; }
					else if(Char == (char)0x00b8){ OutChar = "&cedil;"; }
					else if(Char == (char)0x00a2){ OutChar = "&cent;"; }
					else if(Char == (char)0x03a7){ OutChar = "&Chi;"; }
					else if(Char == (char)0x03c7){ OutChar = "&chi;"; }
					else if(Char == (char)0x02c6){ OutChar = "&circ;"; }
					else if(Char == (char)0x2663){ OutChar = "&clubs;"; }
					else if(Char == (char)0x2245){ OutChar = "&cong;"; }
					else if(Char == (char)0x00a9){ OutChar = "&copy;"; }
					else if(Char == (char)0x21b5){ OutChar = "&crarr;"; }
					else if(Char == (char)0x222a){ OutChar = "&cup;"; }
					else if(Char == (char)0x00a4){ OutChar = "&curren;"; }
					else if(Char == (char)0x2020){ OutChar = "&dagger;"; }
					else if(Char == (char)0x2021){ OutChar = "&Dagger;"; }
					else if(Char == (char)0x2193){ OutChar = "&darr;"; }
					else if(Char == (char)0x21d3){ OutChar = "&dArr;"; }
					else if(Char == (char)0x00b0){ OutChar = "&deg;"; }
					else if(Char == (char)0x0394){ OutChar = "&Delta;"; }
					else if(Char == (char)0x03b4){ OutChar = "&delta;"; }
					else if(Char == (char)0x2666){ OutChar = "&diams;"; }
					else if(Char == (char)0x00f7){ OutChar = "&divide;"; }
					else if(Char == (char)0x00c9){ OutChar = "&Eacute;"; }
					else if(Char == (char)0x00e9){ OutChar = "&eacute;"; }
					else if(Char == (char)0x00ca){ OutChar = "&Ecirc;"; }
					else if(Char == (char)0x00ea){ OutChar = "&ecirc;"; }
					else if(Char == (char)0x00c8){ OutChar = "&Egrave;"; }
					else if(Char == (char)0x00e8){ OutChar = "&egrave;"; }
					else if(Char == (char)0x2205){ OutChar = "&empty;"; }
					else if(Char == (char)0x2003){ OutChar = "&emsp;"; }
					else if(Char == (char)0x2002){ OutChar = "&ensp;"; }
					else if(Char == (char)0x0395){ OutChar = "&Epsilon;"; }
					else if(Char == (char)0x03b5){ OutChar = "&epsilon;"; }
					else if(Char == (char)0x2261){ OutChar = "&equiv;"; }
					else if(Char == (char)0x0397){ OutChar = "&Eta;"; }
					else if(Char == (char)0x03b7){ OutChar = "&eta;"; }
					else if(Char == (char)0x00d0){ OutChar = "&ETH;"; }
					else if(Char == (char)0x00f0){ OutChar = "&eth;"; }
					else if(Char == (char)0x00cb){ OutChar = "&Euml;"; }
					else if(Char == (char)0x00eb){ OutChar = "&euml;"; }
					else if(Char == (char)0x20ac){ OutChar = "&euro;"; }
					else if(Char == (char)0x2203){ OutChar = "&exist;"; }
					else if(Char == (char)0x0192){ OutChar = "&fnof;"; }
					else if(Char == (char)0x2200){ OutChar = "&forall;"; }
					else if(Char == (char)0x00bd){ OutChar = "&frac12;"; }
					else if(Char == (char)0x00bc){ OutChar = "&frac14;"; }
					else if(Char == (char)0x00be){ OutChar = "&frac34;"; }
					else if(Char == (char)0x2044){ OutChar = "&frasl;"; }
					else if(Char == (char)0x0393){ OutChar = "&Gamma;"; }
					else if(Char == (char)0x03b3){ OutChar = "&gamma;"; }
					else if(Char == (char)0x2265){ OutChar = "&ge;"; }
					else if(Char == (char)0x003e){ OutChar = "&gt;"; }
					else if(Char == (char)0x2194){ OutChar = "&harr;"; }
					else if(Char == (char)0x21d4){ OutChar = "&hArr;"; }
					else if(Char == (char)0x2665){ OutChar = "&hearts;"; }
					else if(Char == (char)0x2026){ OutChar = "&hellip;"; }
					else if(Char == (char)0x00cd){ OutChar = "&Iacute;"; }
					else if(Char == (char)0x00ed){ OutChar = "&iacute;"; }
					else if(Char == (char)0x00ce){ OutChar = "&Icirc;"; }
					else if(Char == (char)0x00ee){ OutChar = "&icirc;"; }
					else if(Char == (char)0x00a1){ OutChar = "&iexcl;"; }
					else if(Char == (char)0x00cc){ OutChar = "&Igrave;"; }
					else if(Char == (char)0x00ec){ OutChar = "&igrave;"; }
					else if(Char == (char)0x2111){ OutChar = "&image;"; }
					else if(Char == (char)0x221e){ OutChar = "&infin;"; }
					else if(Char == (char)0x222b){ OutChar = "&int;"; }
					else if(Char == (char)0x0399){ OutChar = "&Iota;"; }
					else if(Char == (char)0x03b9){ OutChar = "&iota;"; }
					else if(Char == (char)0x00bf){ OutChar = "&iquest;"; }
					else if(Char == (char)0x2208){ OutChar = "&isin;"; }
					else if(Char == (char)0x00cf){ OutChar = "&Iuml;"; }
					else if(Char == (char)0x00ef){ OutChar = "&iuml;"; }
					else if(Char == (char)0x039a){ OutChar = "&Kappa;"; }
					else if(Char == (char)0x03ba){ OutChar = "&kappa;"; }
					else if(Char == (char)0x039b){ OutChar = "&Lambda;"; }
					else if(Char == (char)0x03bb){ OutChar = "&lambda;"; }
					else if(Char == (char)0x2329){ OutChar = "&lang;"; }
					else if(Char == (char)0x00ab){ OutChar = "&laquo;"; }
					else if(Char == (char)0x2190){ OutChar = "&larr;"; }
					else if(Char == (char)0x21d0){ OutChar = "&lArr;"; }
					else if(Char == (char)0x2308){ OutChar = "&lceil;"; }
					else if(Char == (char)0x201c){ OutChar = "&ldquo;"; }
					else if(Char == (char)0x2264){ OutChar = "&le;"; }
					else if(Char == (char)0x230a){ OutChar = "&lfloor;"; }
					else if(Char == (char)0x2217){ OutChar = "&lowast;"; }
					else if(Char == (char)0x25ca){ OutChar = "&loz;"; }
					else if(Char == (char)0x200e){ OutChar = "&lrm;"; }
					else if(Char == (char)0x2039){ OutChar = "&lsaquo;"; }
					else if(Char == (char)0x2018){ OutChar = "&lsquo;"; }
					else if(Char == (char)0x003c){ OutChar = "&lt;"; }
					else if(Char == (char)0x00af){ OutChar = "&macr;"; }
					else if(Char == (char)0x2014){ OutChar = "&mdash;"; }
					else if(Char == (char)0x00b5){ OutChar = "&micro;"; }
					else if(Char == (char)0x00b7){ OutChar = "&middot;"; }
					else if(Char == (char)0x2212){ OutChar = "&minus;"; }
					else if(Char == (char)0x039c){ OutChar = "&Mu;"; }
					else if(Char == (char)0x03bc){ OutChar = "&mu;"; }
					else if(Char == (char)0x2207){ OutChar = "&nabla;"; }
					else if(Char == (char)0x00a0){ OutChar = "&nbsp;"; }
					else if(Char == (char)0x2013){ OutChar = "&ndash;"; }
					else if(Char == (char)0x2260){ OutChar = "&ne;"; }
					else if(Char == (char)0x220b){ OutChar = "&ni;"; }
					else if(Char == (char)0x00ac){ OutChar = "&not;"; }
					else if(Char == (char)0x2209){ OutChar = "&notin;"; }
					else if(Char == (char)0x2284){ OutChar = "&nsub;"; }
					else if(Char == (char)0x00d1){ OutChar = "&Ntilde;"; }
					else if(Char == (char)0x00f1){ OutChar = "&ntilde;"; }
					else if(Char == (char)0x039d){ OutChar = "&Nu;"; }
					else if(Char == (char)0x03bd){ OutChar = "&nu;"; }
					else if(Char == (char)0x00d3){ OutChar = "&Oacute;"; }
					else if(Char == (char)0x00f3){ OutChar = "&oacute;"; }
					else if(Char == (char)0x00d4){ OutChar = "&Ocirc;"; }
					else if(Char == (char)0x00f4){ OutChar = "&ocirc;"; }
					else if(Char == (char)0x0152){ OutChar = "&OElig;"; }
					else if(Char == (char)0x0153){ OutChar = "&oelig;"; }
					else if(Char == (char)0x00d2){ OutChar = "&Ograve;"; }
					else if(Char == (char)0x00f2){ OutChar = "&ograve;"; }
					else if(Char == (char)0x203e){ OutChar = "&oline;"; }
					else if(Char == (char)0x03a9){ OutChar = "&Omega;"; }
					else if(Char == (char)0x03c9){ OutChar = "&omega;"; }
					else if(Char == (char)0x039f){ OutChar = "&Omicron;"; }
					else if(Char == (char)0x03bf){ OutChar = "&omicron;"; }
					else if(Char == (char)0x2295){ OutChar = "&oplus;"; }
					else if(Char == (char)0x2228){ OutChar = "&or;"; }
					else if(Char == (char)0x00aa){ OutChar = "&ordf;"; }
					else if(Char == (char)0x00ba){ OutChar = "&ordm;"; }
					else if(Char == (char)0x00d8){ OutChar = "&Oslash;"; }
					else if(Char == (char)0x00f8){ OutChar = "&oslash;"; }
					else if(Char == (char)0x00d5){ OutChar = "&Otilde;"; }
					else if(Char == (char)0x00f5){ OutChar = "&otilde;"; }
					else if(Char == (char)0x2297){ OutChar = "&otimes;"; }
					else if(Char == (char)0x00d6){ OutChar = "&Ouml;"; }
					else if(Char == (char)0x00f6){ OutChar = "&ouml;"; }
					else if(Char == (char)0x00b6){ OutChar = "&para;"; }
					else if(Char == (char)0x2202){ OutChar = "&part;"; }
					else if(Char == (char)0x2030){ OutChar = "&permil;"; }
					else if(Char == (char)0x22a5){ OutChar = "&perp;"; }
					else if(Char == (char)0x03a6){ OutChar = "&Phi;"; }
					else if(Char == (char)0x03c6){ OutChar = "&phi;"; }
					else if(Char == (char)0x03a0){ OutChar = "&Pi;"; }
					else if(Char == (char)0x03c0){ OutChar = "&pi;"; }
					else if(Char == (char)0x03d6){ OutChar = "&piv;"; }
					else if(Char == (char)0x00b1){ OutChar = "&plusmn;"; }
					else if(Char == (char)0x00a3){ OutChar = "&pound;"; }
					else if(Char == (char)0x2032){ OutChar = "&prime;"; }
					else if(Char == (char)0x2033){ OutChar = "&Prime;"; }
					else if(Char == (char)0x220f){ OutChar = "&prod;"; }
					else if(Char == (char)0x221d){ OutChar = "&prop;"; }
					else if(Char == (char)0x03a8){ OutChar = "&Psi;"; }
					else if(Char == (char)0x03c8){ OutChar = "&psi;"; }
					else if(Char == (char)0x0022){ OutChar = "&quot;"; }
					else if(Char == (char)0x221a){ OutChar = "&radic;"; }
					else if(Char == (char)0x232a){ OutChar = "&rang;"; }
					else if(Char == (char)0x00bb){ OutChar = "&raquo;"; }
					else if(Char == (char)0x2192){ OutChar = "&rarr;"; }
					else if(Char == (char)0x21d2){ OutChar = "&rArr;"; }
					else if(Char == (char)0x2309){ OutChar = "&rceil;"; }
					else if(Char == (char)0x201d){ OutChar = "&rdquo;"; }
					else if(Char == (char)0x211c){ OutChar = "&real;"; }
					else if(Char == (char)0x00ae){ OutChar = "&reg;"; }
					else if(Char == (char)0x230b){ OutChar = "&rfloor;"; }
					else if(Char == (char)0x03a1){ OutChar = "&Rho;"; }
					else if(Char == (char)0x03c1){ OutChar = "&rho;"; }
					else if(Char == (char)0x200f){ OutChar = "&rlm;"; }
					else if(Char == (char)0x203a){ OutChar = "&rsaquo;"; }
					else if(Char == (char)0x2019){ OutChar = "&rsquo;"; }
					else if(Char == (char)0x201a){ OutChar = "&sbquo;"; }
					else if(Char == (char)0x0160){ OutChar = "&Scaron;"; }
					else if(Char == (char)0x0161){ OutChar = "&scaron;"; }
					else if(Char == (char)0x22c5){ OutChar = "&sdot;"; }
					else if(Char == (char)0x00a7){ OutChar = "&sect;"; }
					else if(Char == (char)0x00ad){ OutChar = "&shy;"; }
					else if(Char == (char)0x03a3){ OutChar = "&Sigma;"; }
					else if(Char == (char)0x03c3){ OutChar = "&sigma;"; }
					else if(Char == (char)0x03c2){ OutChar = "&sigmaf;"; }
					else if(Char == (char)0x223c){ OutChar = "&sim;"; }
					else if(Char == (char)0x2660){ OutChar = "&spades;"; }
					else if(Char == (char)0x2282){ OutChar = "&sub;"; }
					else if(Char == (char)0x2286){ OutChar = "&sube;"; }
					else if(Char == (char)0x2211){ OutChar = "&sum;"; }
					else if(Char == (char)0x2283){ OutChar = "&sup;"; }
					else if(Char == (char)0x00b9){ OutChar = "&sup1;"; }
					else if(Char == (char)0x00b2){ OutChar = "&sup2;"; }
					else if(Char == (char)0x00b3){ OutChar = "&sup3;"; }
					else if(Char == (char)0x2287){ OutChar = "&supe;"; }
					else if(Char == (char)0x00df){ OutChar = "&szlig;"; }
					else if(Char == (char)0x03a4){ OutChar = "&Tau;"; }
					else if(Char == (char)0x03c4){ OutChar = "&tau;"; }
					else if(Char == (char)0x2234){ OutChar = "&there4;"; }
					else if(Char == (char)0x0398){ OutChar = "&Theta;"; }
					else if(Char == (char)0x03b8){ OutChar = "&theta;"; }
					else if(Char == (char)0x03d1){ OutChar = "&thetasym;"; }
					else if(Char == (char)0x2009){ OutChar = "&thinsp;"; }
					else if(Char == (char)0x00de){ OutChar = "&THORN;"; }
					else if(Char == (char)0x00fe){ OutChar = "&thorn;"; }
					else if(Char == (char)0x02dc){ OutChar = "&tilde;"; }
					else if(Char == (char)0x00d7){ OutChar = "&times;"; }
					else if(Char == (char)0x2122){ OutChar = "&trade;"; }
					else if(Char == (char)0x00da){ OutChar = "&Uacute;"; }
					else if(Char == (char)0x00fa){ OutChar = "&uacute;"; }
					else if(Char == (char)0x2191){ OutChar = "&uarr;"; }
					else if(Char == (char)0x21d1){ OutChar = "&uArr;"; }
					else if(Char == (char)0x00db){ OutChar = "&Ucirc;"; }
					else if(Char == (char)0x00fb){ OutChar = "&ucirc;"; }
					else if(Char == (char)0x00d9){ OutChar = "&Ugrave;"; }
					else if(Char == (char)0x00f9){ OutChar = "&ugrave;"; }
					else if(Char == (char)0x00a8){ OutChar = "&uml;"; }
					else if(Char == (char)0x03d2){ OutChar = "&upsih;"; }
					else if(Char == (char)0x03a5){ OutChar = "&Upsilon;"; }
					else if(Char == (char)0x03c5){ OutChar = "&upsilon;"; }
					else if(Char == (char)0x00dc){ OutChar = "&Uuml;"; }
					else if(Char == (char)0x00fc){ OutChar = "&uuml;"; }
					else if(Char == (char)0x2118){ OutChar = "&weierp;"; }
					else if(Char == (char)0x039e){ OutChar = "&Xi;"; }
					else if(Char == (char)0x03be){ OutChar = "&xi;"; }
					else if(Char == (char)0x00dd){ OutChar = "&Yacute;"; }
					else if(Char == (char)0x00fd){ OutChar = "&yacute;"; }
					else if(Char == (char)0x00a5){ OutChar = "&yen;"; }
					else if(Char == (char)0x00ff){ OutChar = "&yuml;"; }
					else if(Char == (char)0x0178){ OutChar = "&Yuml;"; }
					else if(Char == (char)0x0396){ OutChar = "&Zeta;"; }
					else if(Char == (char)0x03b6){ OutChar = "&zeta;"; }
					else if(Char == (char)0x200d){ OutChar = "&zwj;"; }
					else if(Char == (char)0x200c){ OutChar = "&zwnj;"; }
					else{
						OutChar = new Character(Char).toString();
					}
					Output += OutChar;
				}
				return Output;
				
			}
		//<-- End Method :: HTMLEncode
		
		//##################################################################################
		
		//--> Begin Method :: HTMLDecode
			static String HTMLDecode(String Input) throws Exception {
				String Output = "";
				char MyCharArray[] = Input.toCharArray();
				for(int i = 0; i < MyCharArray.length ; i++){
					char Char = MyCharArray[i];
					String OutChar = new Character(Char).toString();
					if(Char == '&') {
						int SemicolonIndex = Input.indexOf(';', i + 1);
						if(SemicolonIndex > 0) {
							String Entity = Input.substring(i + 1, SemicolonIndex);
							if(Entity.length() > 1 && Entity.charAt(0) == '#') {
								if(Entity.charAt(1) == 'x' || Entity.charAt(1) == 'X') {
									OutChar = new Character((char)Integer.valueOf("0"+Entity.substring(1)).intValue()).toString();
								}
								else {
									OutChar = new Character((char)Integer.valueOf(Entity.substring(1)).intValue()).toString();
								}
							}
							else{
								if(Entity.equals("Aacute")){ OutChar = new Character((char)0x00c1).toString(); }
								else if(Entity.equals("aacute")){ OutChar = new Character((char)0x00e1).toString(); }
								else if(Entity.equals("Acirc")){ OutChar = new Character((char)0x00c2).toString(); }
								else if(Entity.equals("acirc")){ OutChar = new Character((char)0x00e2).toString(); }
								else if(Entity.equals("acute")){ OutChar = new Character((char)0x00b4).toString(); }
								else if(Entity.equals("AElig")){ OutChar = new Character((char)0x00c6).toString(); }
								else if(Entity.equals("aelig")){ OutChar = new Character((char)0x00e6).toString(); }
								else if(Entity.equals("Agrave")){ OutChar = new Character((char)0x00c0).toString(); }
								else if(Entity.equals("agrave")){ OutChar = new Character((char)0x00e0).toString(); }
								else if(Entity.equals("alefsym")){ OutChar = new Character((char)0x2135).toString(); }
								else if(Entity.equals("Alpha")){ OutChar = new Character((char)0x0391).toString(); }
								else if(Entity.equals("alpha")){ OutChar = new Character((char)0x03b1).toString(); }
								else if(Entity.equals("amp")){ OutChar = new Character((char)0x0026).toString(); }
								else if(Entity.equals("and")){ OutChar = new Character((char)0x2227).toString(); }
								else if(Entity.equals("ang")){ OutChar = new Character((char)0x2220).toString(); }
								else if(Entity.equals("Aring")){ OutChar = new Character((char)0x00c5).toString(); }
								else if(Entity.equals("aring")){ OutChar = new Character((char)0x00e5).toString(); }
								else if(Entity.equals("asymp")){ OutChar = new Character((char)0x2248).toString(); }
								else if(Entity.equals("Atilde")){ OutChar = new Character((char)0x00c3).toString(); }
								else if(Entity.equals("atilde")){ OutChar = new Character((char)0x00e3).toString(); }
								else if(Entity.equals("Auml")){ OutChar = new Character((char)0x00c4).toString(); }
								else if(Entity.equals("auml")){ OutChar = new Character((char)0x00e4).toString(); }
								else if(Entity.equals("bdquo")){ OutChar = new Character((char)0x201e).toString(); }
								else if(Entity.equals("Beta")){ OutChar = new Character((char)0x0392).toString(); }
								else if(Entity.equals("beta")){ OutChar = new Character((char)0x03b2).toString(); }
								else if(Entity.equals("brvbar")){ OutChar = new Character((char)0x00a6).toString(); }
								else if(Entity.equals("bull")){ OutChar = new Character((char)0x2022).toString(); }
								else if(Entity.equals("cap")){ OutChar = new Character((char)0x2229).toString(); }
								else if(Entity.equals("Ccedil")){ OutChar = new Character((char)0x00c7).toString(); }
								else if(Entity.equals("ccedil")){ OutChar = new Character((char)0x00e7).toString(); }
								else if(Entity.equals("cedil")){ OutChar = new Character((char)0x00b8).toString(); }
								else if(Entity.equals("cent")){ OutChar = new Character((char)0x00a2).toString(); }
								else if(Entity.equals("Chi")){ OutChar = new Character((char)0x03a7).toString(); }
								else if(Entity.equals("chi")){ OutChar = new Character((char)0x03c7).toString(); }
								else if(Entity.equals("circ")){ OutChar = new Character((char)0x02c6).toString(); }
								else if(Entity.equals("clubs")){ OutChar = new Character((char)0x2663).toString(); }
								else if(Entity.equals("cong")){ OutChar = new Character((char)0x2245).toString(); }
								else if(Entity.equals("copy")){ OutChar = new Character((char)0x00a9).toString(); }
								else if(Entity.equals("crarr")){ OutChar = new Character((char)0x21b5).toString(); }
								else if(Entity.equals("cup")){ OutChar = new Character((char)0x222a).toString(); }
								else if(Entity.equals("curren")){ OutChar = new Character((char)0x00a4).toString(); }
								else if(Entity.equals("dagger")){ OutChar = new Character((char)0x2020).toString(); }
								else if(Entity.equals("Dagger")){ OutChar = new Character((char)0x2021).toString(); }
								else if(Entity.equals("darr")){ OutChar = new Character((char)0x2193).toString(); }
								else if(Entity.equals("dArr")){ OutChar = new Character((char)0x21d3).toString(); }
								else if(Entity.equals("deg")){ OutChar = new Character((char)0x00b0).toString(); }
								else if(Entity.equals("Delta")){ OutChar = new Character((char)0x0394).toString(); }
								else if(Entity.equals("delta")){ OutChar = new Character((char)0x03b4).toString(); }
								else if(Entity.equals("diams")){ OutChar = new Character((char)0x2666).toString(); }
								else if(Entity.equals("divide")){ OutChar = new Character((char)0x00f7).toString(); }
								else if(Entity.equals("Eacute")){ OutChar = new Character((char)0x00c9).toString(); }
								else if(Entity.equals("eacute")){ OutChar = new Character((char)0x00e9).toString(); }
								else if(Entity.equals("Ecirc")){ OutChar = new Character((char)0x00ca).toString(); }
								else if(Entity.equals("ecirc")){ OutChar = new Character((char)0x00ea).toString(); }
								else if(Entity.equals("Egrave")){ OutChar = new Character((char)0x00c8).toString(); }
								else if(Entity.equals("egrave")){ OutChar = new Character((char)0x00e8).toString(); }
								else if(Entity.equals("empty")){ OutChar = new Character((char)0x2205).toString(); }
								else if(Entity.equals("emsp")){ OutChar = new Character((char)0x2003).toString(); }
								else if(Entity.equals("ensp")){ OutChar = new Character((char)0x2002).toString(); }
								else if(Entity.equals("Epsilon")){ OutChar = new Character((char)0x0395).toString(); }
								else if(Entity.equals("epsilon")){ OutChar = new Character((char)0x03b5).toString(); }
								else if(Entity.equals("equiv")){ OutChar = new Character((char)0x2261).toString(); }
								else if(Entity.equals("Eta")){ OutChar = new Character((char)0x0397).toString(); }
								else if(Entity.equals("eta")){ OutChar = new Character((char)0x03b7).toString(); }
								else if(Entity.equals("ETH")){ OutChar = new Character((char)0x00d0).toString(); }
								else if(Entity.equals("eth")){ OutChar = new Character((char)0x00f0).toString(); }
								else if(Entity.equals("Euml")){ OutChar = new Character((char)0x00cb).toString(); }
								else if(Entity.equals("euml")){ OutChar = new Character((char)0x00eb).toString(); }
								else if(Entity.equals("euro")){ OutChar = new Character((char)0x20ac).toString(); }
								else if(Entity.equals("exist")){ OutChar = new Character((char)0x2203).toString(); }
								else if(Entity.equals("fnof")){ OutChar = new Character((char)0x0192).toString(); }
								else if(Entity.equals("forall")){ OutChar = new Character((char)0x2200).toString(); }
								else if(Entity.equals("frac12")){ OutChar = new Character((char)0x00bd).toString(); }
								else if(Entity.equals("frac14")){ OutChar = new Character((char)0x00bc).toString(); }
								else if(Entity.equals("frac34")){ OutChar = new Character((char)0x00be).toString(); }
								else if(Entity.equals("frasl")){ OutChar = new Character((char)0x2044).toString(); }
								else if(Entity.equals("Gamma")){ OutChar = new Character((char)0x0393).toString(); }
								else if(Entity.equals("gamma")){ OutChar = new Character((char)0x03b3).toString(); }
								else if(Entity.equals("ge")){ OutChar = new Character((char)0x2265).toString(); }
								else if(Entity.equals("gt")){ OutChar = new Character((char)0x003e).toString(); }
								else if(Entity.equals("harr")){ OutChar = new Character((char)0x2194).toString(); }
								else if(Entity.equals("hArr")){ OutChar = new Character((char)0x21d4).toString(); }
								else if(Entity.equals("hearts")){ OutChar = new Character((char)0x2665).toString(); }
								else if(Entity.equals("hellip")){ OutChar = new Character((char)0x2026).toString(); }
								else if(Entity.equals("Iacute")){ OutChar = new Character((char)0x00cd).toString(); }
								else if(Entity.equals("iacute")){ OutChar = new Character((char)0x00ed).toString(); }
								else if(Entity.equals("Icirc")){ OutChar = new Character((char)0x00ce ).toString(); }
								else if(Entity.equals("icirc")){ OutChar = new Character((char)0x00ee).toString(); }
								else if(Entity.equals("iexcl")){ OutChar = new Character((char)0x00a1).toString(); }
								else if(Entity.equals("Igrave")){ OutChar = new Character((char)0x00cc).toString(); }
								else if(Entity.equals("igrave")){ OutChar = new Character((char)0x00ec).toString(); }
								else if(Entity.equals("image")){ OutChar = new Character((char)0x2111).toString(); }
								else if(Entity.equals("infin")){ OutChar = new Character((char)0x221e).toString(); }
								else if(Entity.equals("int")){ OutChar = new Character((char)0x222b).toString(); }
								else if(Entity.equals("Iota")){ OutChar = new Character((char)0x0399).toString(); }
								else if(Entity.equals("iota")){ OutChar = new Character((char)0x03b9).toString(); }
								else if(Entity.equals("iquest")){ OutChar = new Character((char)0x00bf).toString(); }
								else if(Entity.equals("isin")){ OutChar = new Character((char)0x2208).toString(); }
								else if(Entity.equals("Iuml")){ OutChar = new Character((char)0x00cf).toString(); }
								else if(Entity.equals("iuml")){ OutChar = new Character((char)0x00ef).toString(); }
								else if(Entity.equals("Kappa")){ OutChar = new Character((char)0x039a).toString(); }
								else if(Entity.equals("kappa")){ OutChar = new Character((char)0x03ba).toString(); }
								else if(Entity.equals("Lambda")){ OutChar = new Character((char)0x039b).toString(); }
								else if(Entity.equals("lambda")){ OutChar = new Character((char)0x03bb).toString(); }
								else if(Entity.equals("lang")){ OutChar = new Character((char)0x2329).toString(); }
								else if(Entity.equals("laquo")){ OutChar = new Character((char)0x00ab).toString(); }
								else if(Entity.equals("larr")){ OutChar = new Character((char)0x2190).toString(); }
								else if(Entity.equals("lArr")){ OutChar = new Character((char)0x21d0).toString(); }
								else if(Entity.equals("lceil")){ OutChar = new Character((char)0x2308).toString(); }
								else if(Entity.equals("ldquo")){ OutChar = new Character((char)0x201c).toString(); }
								else if(Entity.equals("le")){ OutChar = new Character((char)0x2264).toString(); }
								else if(Entity.equals("lfloor")){ OutChar = new Character((char)0x230a).toString(); }
								else if(Entity.equals("lowast")){ OutChar = new Character((char)0x2217).toString(); }
								else if(Entity.equals("loz")){ OutChar = new Character((char)0x25ca).toString(); }
								else if(Entity.equals("lrm")){ OutChar = new Character((char)0x200e).toString(); }
								else if(Entity.equals("lsaquo")){ OutChar = new Character((char)0x2039).toString(); }
								else if(Entity.equals("lsquo")){ OutChar = new Character((char)0x2018).toString(); }
								else if(Entity.equals("lt")){ OutChar = new Character((char)0x003c).toString(); }
								else if(Entity.equals("macr")){ OutChar = new Character((char)0x00af).toString(); }
								else if(Entity.equals("mdash")){ OutChar = new Character((char)0x2014).toString(); }
								else if(Entity.equals("micro")){ OutChar = new Character((char)0x00b5).toString(); }
								else if(Entity.equals("middot")){ OutChar = new Character((char)0x00b7).toString(); }
								else if(Entity.equals("minus")){ OutChar = new Character((char)0x2212).toString(); }
								else if(Entity.equals("Mu")){ OutChar = new Character((char)0x039c).toString(); }
								else if(Entity.equals("mu")){ OutChar = new Character((char)0x03bc).toString(); }
								else if(Entity.equals("nabla")){ OutChar = new Character((char)0x2207).toString(); }
								else if(Entity.equals("nbsp")){ OutChar = new Character((char)0x00a0).toString(); }
								else if(Entity.equals("ndash")){ OutChar = new Character((char)0x2013).toString(); }
								else if(Entity.equals("ne")){ OutChar = new Character((char)0x2260).toString(); }
								else if(Entity.equals("ni")){ OutChar = new Character((char)0x220b).toString(); }
								else if(Entity.equals("not")){ OutChar = new Character((char)0x00ac).toString(); }
								else if(Entity.equals("notin")){ OutChar = new Character((char)0x2209).toString(); }
								else if(Entity.equals("nsub")){ OutChar = new Character((char)0x2284).toString(); }
								else if(Entity.equals("Ntilde")){ OutChar = new Character((char)0x00d1).toString(); }
								else if(Entity.equals("ntilde")){ OutChar = new Character((char)0x00f1).toString(); }
								else if(Entity.equals("Nu")){ OutChar = new Character((char)0x039d).toString(); }
								else if(Entity.equals("nu")){ OutChar = new Character((char)0x03bd).toString(); }
								else if(Entity.equals("Oacute")){ OutChar = new Character((char)0x00d3).toString(); }
								else if(Entity.equals("oacute")){ OutChar = new Character((char)0x00f3).toString(); }
								else if(Entity.equals("Ocirc")){ OutChar = new Character((char)0x00d4).toString(); }
								else if(Entity.equals("ocirc")){ OutChar = new Character((char)0x00f4).toString(); }
								else if(Entity.equals("OElig")){ OutChar = new Character((char)0x0152).toString(); }
								else if(Entity.equals("oelig")){ OutChar = new Character((char)0x0153).toString(); }
								else if(Entity.equals("Ograve")){ OutChar = new Character((char)0x00d2).toString(); }
								else if(Entity.equals("ograve")){ OutChar = new Character((char)0x00f2).toString(); }
								else if(Entity.equals("oline")){ OutChar = new Character((char)0x203e).toString(); }
								else if(Entity.equals("Omega")){ OutChar = new Character((char)0x03a9).toString(); }
								else if(Entity.equals("omega")){ OutChar = new Character((char)0x03c9).toString(); }
								else if(Entity.equals("Omicron")){ OutChar = new Character((char)0x039f).toString(); }
								else if(Entity.equals("omicron")){ OutChar = new Character((char)0x03bf).toString(); }
								else if(Entity.equals("oplus")){ OutChar = new Character((char)0x2295).toString(); }
								else if(Entity.equals("or")){ OutChar = new Character((char)0x2228).toString(); }
								else if(Entity.equals("ordf")){ OutChar = new Character((char)0x00aa).toString(); }
								else if(Entity.equals("ordm")){ OutChar = new Character((char)0x00ba).toString(); }
								else if(Entity.equals("Oslash")){ OutChar = new Character((char)0x00d8).toString(); }
								else if(Entity.equals("oslash")){ OutChar = new Character((char)0x00f8).toString(); }
								else if(Entity.equals("Otilde")){ OutChar = new Character((char)0x00d5).toString(); }
								else if(Entity.equals("otilde")){ OutChar = new Character((char)0x00f5).toString(); }
								else if(Entity.equals("otimes")){ OutChar = new Character((char)0x2297).toString(); }
								else if(Entity.equals("Ouml")){ OutChar = new Character((char)0x00d6).toString(); }
								else if(Entity.equals("ouml")){ OutChar = new Character((char)0x00f6).toString(); }
								else if(Entity.equals("para")){ OutChar = new Character((char)0x00b6).toString(); }
								else if(Entity.equals("part")){ OutChar = new Character((char)0x2202).toString(); }
								else if(Entity.equals("permil")){ OutChar = new Character((char)0x2030).toString(); }
								else if(Entity.equals("perp")){ OutChar = new Character((char)0x22a5).toString(); }
								else if(Entity.equals("Phi")){ OutChar = new Character((char)0x03a6).toString(); }
								else if(Entity.equals("phi")){ OutChar = new Character((char)0x03c6).toString(); }
								else if(Entity.equals("Pi")){ OutChar = new Character((char)0x03a0).toString(); }
								else if(Entity.equals("pi")){ OutChar = new Character((char)0x03c0).toString(); }
								else if(Entity.equals("piv")){ OutChar = new Character((char)0x03d6).toString(); }
								else if(Entity.equals("plusmn")){ OutChar = new Character((char)0x00b1).toString(); }
								else if(Entity.equals("pound")){ OutChar = new Character((char)0x00a3).toString(); }
								else if(Entity.equals("prime")){ OutChar = new Character((char)0x2032).toString(); }
								else if(Entity.equals("Prime")){ OutChar = new Character((char)0x2033).toString(); }
								else if(Entity.equals("prod")){ OutChar = new Character((char)0x220f).toString(); }
								else if(Entity.equals("prop")){ OutChar = new Character((char)0x221d).toString(); }
								else if(Entity.equals("Psi")){ OutChar = new Character((char)0x03a8).toString(); }
								else if(Entity.equals("psi")){ OutChar = new Character((char)0x03c8).toString(); }
								else if(Entity.equals("quot")){ OutChar = new Character((char)0x0022).toString(); }
								else if(Entity.equals("radic")){ OutChar = new Character((char)0x221a).toString(); }
								else if(Entity.equals("rang")){ OutChar = new Character((char)0x232a).toString(); }
								else if(Entity.equals("raquo")){ OutChar = new Character((char)0x00bb).toString(); }
								else if(Entity.equals("rarr")){ OutChar = new Character((char)0x2192).toString(); }
								else if(Entity.equals("rArr")){ OutChar = new Character((char)0x21d2).toString(); }
								else if(Entity.equals("rceil")){ OutChar = new Character((char)0x2309).toString(); }
								else if(Entity.equals("rdquo")){ OutChar = new Character((char)0x201d).toString(); }
								else if(Entity.equals("real")){ OutChar = new Character((char)0x211c).toString(); }
								else if(Entity.equals("reg")){ OutChar = new Character((char)0x00ae).toString(); }
								else if(Entity.equals("rfloor")){ OutChar = new Character((char)0x230b).toString(); }
								else if(Entity.equals("Rho")){ OutChar = new Character((char)0x03a1).toString(); }
								else if(Entity.equals("rho")){ OutChar = new Character((char)0x03c1).toString(); }
								else if(Entity.equals("rlm")){ OutChar = new Character((char)0x200f).toString(); }
								else if(Entity.equals("rsaquo")){ OutChar = new Character((char)0x203a).toString(); }
								else if(Entity.equals("rsquo")){ OutChar = new Character((char)0x2019).toString(); }
								else if(Entity.equals("sbquo")){ OutChar = new Character((char)0x201a).toString(); }
								else if(Entity.equals("Scaron")){ OutChar = new Character((char)0x0160).toString(); }
								else if(Entity.equals("scaron")){ OutChar = new Character((char)0x0161).toString(); }
								else if(Entity.equals("sdot")){ OutChar = new Character((char)0x22c5).toString(); }
								else if(Entity.equals("sect")){ OutChar = new Character((char)0x00a7).toString(); }
								else if(Entity.equals("shy")){ OutChar = new Character((char)0x00ad).toString(); }
								else if(Entity.equals("Sigma")){ OutChar = new Character((char)0x03a3).toString(); }
								else if(Entity.equals("sigma")){ OutChar = new Character((char)0x03c3).toString(); }
								else if(Entity.equals("sigmaf")){ OutChar = new Character((char)0x03c2).toString(); }
								else if(Entity.equals("sim")){ OutChar = new Character((char)0x223c).toString(); }
								else if(Entity.equals("spades")){ OutChar = new Character((char)0x2660).toString(); }
								else if(Entity.equals("sub")){ OutChar = new Character((char)0x2282).toString(); }
								else if(Entity.equals("sube")){ OutChar = new Character((char)0x2286).toString(); }
								else if(Entity.equals("sum")){ OutChar = new Character((char)0x2211).toString(); }
								else if(Entity.equals("sup")){ OutChar = new Character((char)0x2283).toString(); }
								else if(Entity.equals("sup1")){ OutChar = new Character((char)0x00b9).toString(); }
								else if(Entity.equals("sup2")){ OutChar = new Character((char)0x00b2).toString(); }
								else if(Entity.equals("sup3")){ OutChar = new Character((char)0x00b3).toString(); }
								else if(Entity.equals("supe")){ OutChar = new Character((char)0x2287).toString(); }
								else if(Entity.equals("szlig")){ OutChar = new Character((char)0x00df).toString(); }
								else if(Entity.equals("Tau")){ OutChar = new Character((char)0x03a4).toString(); }
								else if(Entity.equals("tau")){ OutChar = new Character((char)0x03c4).toString(); }
								else if(Entity.equals("there4")){ OutChar = new Character((char)0x2234).toString(); }
								else if(Entity.equals("Theta")){ OutChar = new Character((char)0x0398).toString(); }
								else if(Entity.equals("theta")){ OutChar = new Character((char)0x03b8).toString(); }
								else if(Entity.equals("thetasym")){ OutChar = new Character((char)0x03d1).toString(); }
								else if(Entity.equals("thinsp")){ OutChar = new Character((char)0x2009).toString(); }
								else if(Entity.equals("THORN")){ OutChar = new Character((char)0x00de).toString(); }
								else if(Entity.equals("thorn")){ OutChar = new Character((char)0x00fe).toString(); }
								else if(Entity.equals("tilde")){ OutChar = new Character((char)0x02dc).toString(); }
								else if(Entity.equals("times")){ OutChar = new Character((char)0x00d7).toString(); }
								else if(Entity.equals("trade")){ OutChar = new Character((char)0x2122).toString(); }
								else if(Entity.equals("Uacute")){ OutChar = new Character((char)0x00da).toString(); }
								else if(Entity.equals("uacute")){ OutChar = new Character((char)0x00fa).toString(); }
								else if(Entity.equals("uarr")){ OutChar = new Character((char)0x2191).toString(); }
								else if(Entity.equals("uArr")){ OutChar = new Character((char)0x21d1).toString(); }
								else if(Entity.equals("Ucirc")){ OutChar = new Character((char)0x00db).toString(); }
								else if(Entity.equals("ucirc")){ OutChar = new Character((char)0x00fb).toString(); }
								else if(Entity.equals("Ugrave")){ OutChar = new Character((char)0x00d9).toString(); }
								else if(Entity.equals("ugrave")){ OutChar = new Character((char)0x00f9).toString(); }
								else if(Entity.equals("uml")){ OutChar = new Character((char)0x00a8).toString(); }
								else if(Entity.equals("upsih")){ OutChar = new Character((char)0x03d2).toString(); }
								else if(Entity.equals("Upsilon")){ OutChar = new Character((char)0x03a5).toString(); }
								else if(Entity.equals("upsilon")){ OutChar = new Character((char)0x03c5).toString(); }
								else if(Entity.equals("Uuml")){ OutChar = new Character((char)0x00dc).toString(); }
								else if(Entity.equals("uuml")){ OutChar = new Character((char)0x00fc).toString(); }
								else if(Entity.equals("weierp")){ OutChar = new Character((char)0x2118).toString(); }
								else if(Entity.equals("Xi")){ OutChar = new Character((char)0x039e).toString(); }
								else if(Entity.equals("xi")){ OutChar = new Character((char)0x03be).toString(); }
								else if(Entity.equals("Yacute")){ OutChar = new Character((char)0x00dd).toString(); }
								else if(Entity.equals("yacute")){ OutChar = new Character((char)0x00fd).toString(); }
								else if(Entity.equals("yen")){ OutChar = new Character((char)0x00a5).toString(); }
								else if(Entity.equals("yuml")){ OutChar = new Character((char)0x00ff).toString(); }
								else if(Entity.equals("Yuml")){ OutChar = new Character((char)0x0178).toString(); }
								else if(Entity.equals("Zeta")){ OutChar = new Character((char)0x0396).toString(); }
								else if(Entity.equals("zeta")){ OutChar = new Character((char)0x03b6).toString(); }
								else if(Entity.equals("zwj")){ OutChar = new Character((char)0x200d).toString(); }
								else if(Entity.equals("zwnj")){ OutChar = new Character((char)0x200c).toString(); }
								else{
									OutChar = "";
								}
							}
							i = SemicolonIndex;
						}
					}
					Output += OutChar;
				}
				return Output;
			}
		//<-- End Method :: HTMLDecode
		
		//##################################################################################
		
		//--> Begin Method :: XMLEncode
			static String XMLEncode(String Input) {
				return Input.replaceAll("\\&", "&amp;").replaceAll("\\<", "&lt;").replaceAll("\\>", "&gt;").replaceAll("\\\"", "&quot;").replaceAll("\\'", "&apos;");
			}
		//<-- End Method :: XMLEncode
		
		//##################################################################################
		
		//--> Begin Method :: XMLDecode
			static String XMLDecode(String Input) {
				return Input.replaceAll("&amp;", "&").replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replaceAll("&apos;", "'");
			}
		//<-- End Method :: XMLDecode
		
		//##################################################################################
		
		//--> Begin Method :: Base64Encode
			static String Base64Encode(String Input) throws Exception{
				return Codec.Base64Encode(Input.getBytes());
			}
			static String Base64Encode(byte[] Input) throws Exception {
				//create the mapping of valid base64 characters
				char[] CharacterMap = {
					'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
					'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
					'0','1','2','3','4','5','6','7','8','9','+','/'
				};
				
				//math for optimal processing
					//get the InputLength
					int InputLength = Input.length;
					
					//get the EvenLength - ie. 40 / 3 = 13.333 | 13 * 3 = 39
					int EvenLength = (InputLength / 3) * 3; 
					
					//get the CharacterCount of what the output will be after encoding
					int CharacterCount = (((InputLength - 1) / 3) + 1) * 4;
					
					//set the DataLength to CharacterCount by default
					int DataLength = CharacterCount + (CharacterCount - 1) / 76; //76 characters per line
					if(CharacterCount < 76) {
						DataLength = CharacterCount;
					}
					
					//we want to pre-allocate the output size so its not done on each iteration
					byte[] DataArray = new byte[DataLength];
				//end math for optimal processing
				
				//define loop iterators
				int InputIterator = 0;
				int DataIterator = 0;
				int SeparatorIterator = 0;
				
				//loop over input until EvenLength
				while(InputIterator < EvenLength) {
					//take a byte and shift it into bits 24-16
					int MaskedCharacters = (Input[InputIterator++] & 0xff) << 0x10;
					//take the next byte and shift it into bits 15-8
					MaskedCharacters |= (Input[InputIterator++] & 0xff) << 0x8;
					//take the next byte and shift it into bits 7-0
					MaskedCharacters |= (Input[InputIterator++] & 0xff);
					
					//map 6 bits at a time to corresponding items in the CharacterMap
					DataArray[DataIterator++] = (byte) CharacterMap[(MaskedCharacters >>> 0x12) & 0x3f];//bits 24 - 18
					DataArray[DataIterator++] = (byte) CharacterMap[(MaskedCharacters >>> 0xC) & 0x3f];//bits 17 -12
					DataArray[DataIterator++] = (byte) CharacterMap[(MaskedCharacters >>> 0x6) & 0x3f];//bits 11-6
					DataArray[DataIterator++] = (byte) CharacterMap[MaskedCharacters & 0x3f];//bits 5-0
					
					//increment the SeperatorIterator by 4 since we're processing 4 characters per iteration
					SeparatorIterator += 4;
					
					if(SeparatorIterator == 76){
						if(DataIterator < (DataLength - 1)) {
							DataArray[DataIterator++] = '\n';
							
							//restart SeparatorIterator
							SeparatorIterator = 0;
						}
					}
				}
				
				//get remainder length
				int RemainderLength = InputLength - EvenLength;
				
				//determine if padding is required
				if(RemainderLength > 0) {
					//set padding bits container
					int MaskedCharacters = (Input[EvenLength] & 0xff) << 0xA;
					if(RemainderLength == 2){
						MaskedCharacters |= (Input[InputLength - 1] & 0xff) << 0x2;
					}
	
					//map 6 padding bits at a time to corresponding items in the CharacterMap to the last bytes
					DataArray[DataLength - 4] = (byte) CharacterMap[MaskedCharacters >> 0xC];//bits 18 - 12
					DataArray[DataLength - 3] = (byte) CharacterMap[(MaskedCharacters >>> 0x6) & 0x3f];//bits 11 - 6
					
					if(RemainderLength == 2){
						DataArray[DataLength - 2] = (byte) CharacterMap[MaskedCharacters & 0x3f];//bits 5 - 0
					}
					else{
						DataArray[DataLength - 2] = (byte) '=';
					}
					DataArray[DataLength - 1] = '=';
				}
				return new String(DataArray);
			}
		//<-- End Method :: Base64Encode
		
		//##################################################################################
		
		//--> Begin Method :: Base64Decode
			static String Base64Decode(String Input) throws Exception {
				return new String(Codec.Base64DecodeBytes(Input));
			}
		//<-- End Method :: Base64Decode
		
		//##################################################################################
		
		//--> Begin Method :: Base64DecodeBytes
			static byte[] Base64DecodeBytes(String Input) throws Exception {
				//create the mapping of valid base64 characters as integers
				int[] CharacterIntegerMap = {
					-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
					-1, -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,62,-1,-1,-1, 63, 52,53,54, 55,56,57,58,59,60,61,-1,-1,-1,0,-1,
					-1,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1,-1,26,
					27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-1,-1,-1,-1,-1,-1,-1,
					-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
					-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
					-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
					-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
				};
				
				//remove all illegal characters
				Input = Input.replaceAll("[^a-zA-Z0-9\\+\\/\\=]", "");
				
				//get the count of all the padding characters
				int PaddingCount = 0;
				if(Input.indexOf("=") != -1) {
					PaddingCount = Input.length() - Input.indexOf("=");
				}
				
				//get input as bytes
				byte[] InputData = Input.getBytes();
				
				//make sure inputdata is divisable by 4
				if(InputData.length % 4 != 0){
					throw new Exception("WebLegs.Codec.Base64Decode(): Input is not divisible by four. Cannot decode invalid input.");
				}
				
				//get length of output
				int DataLength = (InputData.length * 6 >> 0x3) - PaddingCount;
		
				//create new bytearray for output data
				byte[] DataArray = new byte[DataLength];
				
				//create iterators
				int InputIterator = 0;
				int DataIterator = 0;
				
				while(DataIterator < DataLength) {
					//get three bytes into MaskedCharacters
					int MaskedCharacters = CharacterIntegerMap[InputData[InputIterator++] & 0xff] << 0x12;
					MaskedCharacters |= CharacterIntegerMap[InputData[InputIterator++] & 0xff] << 0xC;
					MaskedCharacters |= CharacterIntegerMap[InputData[InputIterator++] & 0xff] << 0x6;
					MaskedCharacters |= CharacterIntegerMap[InputData[InputIterator++] & 0xff];
					
					//copy first byte
					DataArray[DataIterator++] = (byte) (MaskedCharacters >> 0x10);
					//check to make sure that there is any more data
					if(DataIterator < DataLength) {
						//copy second byte
						DataArray[DataIterator++]= (byte) (MaskedCharacters >> 0x8);
						//check to make sure that there is any more data
						if(DataIterator < DataLength){
							//copy final byte
							DataArray[DataIterator++] = (byte) MaskedCharacters;
						}
					}
				}
				return DataArray;
			}
		//<-- End Method :: Base64DecodeBytes
		
		//##################################################################################
		
		//--> Begin Method :: QuotedPrintableEncode
			static String QuotedPrintableEncode(String Input) {
				//hex containers
				String HexChars = "0123456789ABCDEF";
				int HexLow = 0;
				int HexHigh = 0;
				
				//container for our final string
				String tmpQPString = "";
				
				//container for our current line length
				int CurrentLineLength = 0;
				
				//loop over bytes and build new string
				for(int i = 0; i < Input.length(); i++) {
					//Get one character at a time
					char Current = Input.charAt(i);
					
					//Keep track of the next character too... if its the last character
					//present return a CR character
					char Next = ((i + 1) != Input.length()) ? Input.charAt(i + 1) : (char)0x0D;
					
					//make hex-style string out of the current byte
					String CurrentEncoded = "";
					
					//if this is the '=' character just encode it and return
					if(Current == '=') {
						HexLow = (int)Input.charAt(i) % 16;
						HexHigh = ((int)Input.charAt(i) - HexLow) / 16;
						CurrentEncoded = "="+ HexChars.charAt(HexHigh) + HexChars.charAt(HexLow);
					}
					else if(Current == '!' || Current == '"' || Current == '#' || Current == '$' || Current == '@' || Current == '[' || Current == '\\' || Current == ']' || Current == '^' || Current == '`' || Current == '{' || Current == '|' || Current == '}' || Current == '~' || Current == '\'') {
						HexLow = (int)Input.charAt(i) % 16;
						HexHigh = ((int)Input.charAt(i) - HexLow) / 16;
						CurrentEncoded = "="+ HexChars.charAt(HexHigh) + HexChars.charAt(HexLow);
					}
					//if we come across a tab or a space AND the next byte
					//represents CR or LF, we need to encode it too
					else if((Current == (char)0x09 || Current == (char)0x20) && (Next == (char)0x0A || Next == (char)0x0D)) {
						HexLow = (int)Input.charAt(i) % 16;
						HexHigh = ((int)Input.charAt(i) - HexLow) / 16;
						CurrentEncoded = "="+ HexChars.charAt(HexHigh) + HexChars.charAt(HexLow);
					}
					//is this character ok as is?
					else if(((int)Current >= 33 && (int)Current <= 126) || Current == (char)0x0D || Current == (char)0x0A || Current == (char)0x09 || Current == (char)0x20) {
						CurrentEncoded = String.valueOf(Current);
					}
					else {
						//if we get here, we've fell from above, ecode anything that gets here
						HexLow = (int)Input.charAt(i) % 16;
						HexHigh = ((int)Input.charAt(i) - HexLow) / 16;
						CurrentEncoded = "="+ (int)HexChars.charAt(HexHigh) + (int)HexChars.charAt(HexLow);
					}
					
					//let's make sure that we keep track of line length while
					//we append characters together for the final output
					
					//check for CR and LF to get away from double lines
					if(Current == (char)0x0D || Current == (char)0x0A) {
						//if we got here that means that we are at the end of the
						//line and we need to reset our line length tracking variable
						if(Current == (char)0x0A) {
							CurrentLineLength = 0;
						}
					}
					
					//check to see if this pushes us past 74 characters
					//if so lets add a soft line break
					if(CurrentEncoded.length() + CurrentLineLength > 74) {
						tmpQPString += "=\n";
						CurrentLineLength = 0;
					}
					
					//append this character and increase line length
					tmpQPString += CurrentEncoded;
					CurrentLineLength += CurrentEncoded.length();
				}
				
				//return our completed string
				return tmpQPString;
			}
		//<-- End Method :: QuotedPrintableEncode
		
		//##################################################################################
		
		//--> Begin Method :: QuotedPrintableDecode
			static String QuotedPrintableDecode(String Input) {
				//replace end of line =
				Input = Input.replace("\\r\\n", "\\n");
				//rule #3 trailing space must be deleted
				Input = Input.replace("[ \\t]+\\n", "\\n");
				//rule #5 soft line breaks
				Input = Input.replace("=\\n", "");
				
				//hex containers
				String HexChars = "0123456789ABCDEF";
				int HexCharCode = 0;
				int HexLow = 0;
				int HexHigh = 0;
				
				String Output = Input;
				Pattern MyPattern = Pattern.compile("(=([0-9A-F][0-9A-F]))", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
				Matcher MyMatcher = MyPattern.matcher(Output);
				while(MyMatcher.find()) {
					HexLow = HexChars.indexOf(MyMatcher.group(2).charAt(1));
					HexHigh = 16 * HexChars.indexOf(MyMatcher.group(2).charAt(0));
					HexCharCode = HexLow + HexHigh;
					Output = Output.replace(String.valueOf(MyMatcher.group(1)), String.valueOf((char)HexCharCode));
					
					//get next match
					MyMatcher = MyPattern.matcher(Output);
				}
				return Output;
			}
		//<-- End Method :: QuotedPrintableDecode
		
		//##################################################################################
		
		//--> Begin Method :: MD5Encrypt
			static String MD5Encrypt(String Input) throws Exception {
				MessageDigest MyMessageDigest = MessageDigest.getInstance("MD5");
				MyMessageDigest.reset();
				MyMessageDigest.update(Input.getBytes());
				byte[] Digest = MyMessageDigest.digest();
				BigInteger MyBigInt = new BigInteger(1, Digest);
				String ReturnData = MyBigInt.toString(16);
				while(ReturnData.length() < 32 ){
				  ReturnData = "0"+ ReturnData;
				}
				return ReturnData;
			}
		//<-- End Method :: MD5Encrypt
		
		//##################################################################################
		
		//--> Begin Method :: HMACMD5Encrypt
			static String HMACMD5Encrypt(String Key, String Input) throws Exception {
				byte[] KeyByteArray  = Key.getBytes();
				byte[] DataByteArray = Input.getBytes();
				
				MessageDigest ThisMD5 = MessageDigest.getInstance("MD5");
				ThisMD5.reset();
				
				if(KeyByteArray.length > 64){
					KeyByteArray = ThisMD5.digest(KeyByteArray);
				}
				
				byte[] Kipad = new byte[64];
				byte[] Kopad = new byte[64];
				
				System.arraycopy(KeyByteArray, 0, Kipad, 0, KeyByteArray.length);
				System.arraycopy(KeyByteArray, 0, Kopad, 0, KeyByteArray.length);
				
				for(int i = 0; i < 64; i++){
					Kipad[i] ^= 0x36;
					Kopad[i] ^= 0x5c;
				}
				
				byte[] Itemp = new byte[Kipad.length + DataByteArray.length];
				
				System.arraycopy(Kipad, 0, Itemp, 0, Kipad.length);
				System.arraycopy(DataByteArray, 0, Itemp, Kipad.length, DataByteArray.length);
				
				Itemp = ThisMD5.digest(Itemp);
				
				byte[] Otemp = new byte[Kopad.length + Itemp.length];
				
				System.arraycopy(Kopad, 0, Otemp, 0, Kopad.length);
				System.arraycopy(Itemp, 0, Otemp, Kopad.length, Itemp.length);
				
				byte[] MD5Result = ThisMD5.digest(Otemp);
				StringBuffer Digest = new StringBuffer();
				
				for(int i = 0; i < MD5Result.length; i++) {
					Digest.append(Integer.toHexString((MD5Result[i] >>> 4) & 0x0F));
					Digest.append(Integer.toHexString(0x0F & MD5Result[i]));
				}
				
				return Digest.toString();
			}
		//<-- End Method :: HMACMD5Encrypt
	}
//<-- End Class :: Codec

//##########################################################################################
%>