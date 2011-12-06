<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<%@ Import Namespace="System.Xml.XPath" %>
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

//--> Begin Class :: TextTemplate
	public class TextTemplate {
		//--> Begin :: Properties
			public string Source;
			public string DTD;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public TextTemplate() {
				this.Source = "";
				this.DTD = "";
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: LoadFile
			public TextTemplate LoadFile(string Path) {
				if(!File.Exists(Path)) {
					throw new Exception("WebLegs.TextTemplate.LoadFile(): The file '"+ Path +"' was not found or is inaccessable.");
				}
				
				//get the file source
				StreamReader myFile;
				myFile = File.OpenText(Path);
				string Source = myFile.ReadToEnd();
				myFile.Close();
				
				//load source
				this.Load(Source);
				
				return this;
			}
			public TextTemplate LoadFile(string Path, string RootPath) {
				if(!File.Exists(Path)) {
					throw new Exception("WebLegs.TextTemplate.LoadFile(): The file '"+ Path +"' was not found or is inaccessable.");
				}
				
				//get the file source
				StreamReader myFile = File.OpenText(Path);
				string Source = myFile.ReadToEnd();
				myFile.Close();
				
				//load source
				this.Load(Source, RootPath);
				
				//return this reference
				return this;
			}
		//<-- End Method :: LoadFile
		
		//##################################################################################
		
		//--> Begin Method :: Load
			public TextTemplate Load(string Source) {
				//strip out the DTD if we find one
				Match myDTDMatch = Regex.Match(Source, "(<!DOCTYPE.*?>)");
				if(myDTDMatch.Success) {
					this.DTD = myDTDMatch.Groups[1].Value;
					Source = Source.Replace(myDTDMatch.Groups[1].Value, "");
				}
				
				//string container
				this.Source = Source;
				return this;
			}
			public TextTemplate Load(string Source, string RootPath) {
				//strip out the DTD if we find one
				Match myDTDMatch = Regex.Match(Source, "(<!DOCTYPE.*?>)");
				if(myDTDMatch.Success) {
					this.DTD = myDTDMatch.Groups[1].Value;
					Source = Source.Replace(myDTDMatch.Groups[1].Value, "");
				}
				
				//setup the reader and writer
				XmlTextReader myXmlReader = null;
				TextXHTMLWriter myXmlWriter = null;
				
				try {
					//create the XslCompiledTransform object
					XslCompiledTransform myXslt = new XslCompiledTransform();
					
					//create a resolver
					XmlSecureResolver myResolver = new XmlSecureResolver(new XmlUrlResolver(), RootPath);
					
					//crate an xml reader
					myXmlReader = new XmlTextReader(new System.IO.MemoryStream(System.Text.Encoding.Default.GetBytes(Source)));
					myXmlReader.XmlResolver = null;
					
					//get the xpath document
					XPathDocument myXPathDoc = new XPathDocument(myXmlReader);
					
					//create a xml doc navigator
					XPathNavigator myNavigator = myXPathDoc.CreateNavigator();
					
					//dynamically load the xml-stylesheet
					if(myNavigator.MoveToChild(XPathNodeType.ProcessingInstruction)) {
						if(myNavigator.Name == "xml-stylesheet") {
							string myTarget = myNavigator.Value;
							Match myHrefMatch = Regex.Match(myTarget, "href=[\"|'](.*?)[\"|']");
							if(myHrefMatch.Success) {
								myXslt.Load(RootPath + myHrefMatch.Groups[1].Value, XsltSettings.TrustedXslt, myResolver);
								myHrefMatch = myHrefMatch.NextMatch();
							}
						}
					}
					//end dynamically load the xml-stylesheet
					
					//create memorty stream
					System.IO.MemoryStream myMemoryStream = new System.IO.MemoryStream();
					
					//create XmlTextWriter
					myXmlWriter = new TextXHTMLWriter(myMemoryStream);
					
					//transform the document
					myXslt.Transform(myXPathDoc, myXmlWriter);
					
					//resulting string
					this.Source = System.Text.Encoding.UTF8.GetString(myMemoryStream.ToArray());
				}
				finally {
					//close our reader and writer
					if(!(myXmlReader == null)) {
						myXmlReader.Close();
					}
					if(!(myXmlWriter == null)) {
						myXmlWriter.Close();
					}
				}
				return this;
			}
		//<-- End Method :: Load
		
		//##################################################################################
		
		//--> Begin Method :: Replace
			public TextTemplate Replace(string This, string WithThis) {
				this.Source = this.Source.Replace(This, WithThis);
				return this;
			}
		//<-- End Method :: Replace
		
		//##################################################################################
		
		//--> Begin Method :: GetSubString
			public string GetSubString(string Start, string End) {
				int MyStart = 0;
				int MyEnd = 0;
				
				if(this.Source.IndexOf(Start) > -1 && this.Source.LastIndexOf(End) > -1) {
					MyStart = (this.Source.IndexOf(Start)) + Start.Length;
					MyEnd = this.Source.LastIndexOf(End);
					try{
						return this.Source.Substring(MyStart, MyEnd - MyStart);
					}
					catch {
						throw new Exception("WebLegs.TextTemplate.GetSubString(): Boundry string mismatch.");
					}
				}
				else {
					throw new Exception("WebLegs.TextTemplate.GetSubString(): Boundry strings not present in source string.");
				} 
			}
		//<-- End Method :: GetSubString
		
		//##################################################################################
		
		//--> Begin Method :: RemoveSubString
			public TextTemplate RemoveSubString(string Start, string End) {
				this.RemoveSubString(Start, End, false);
				return this;
			}
			public TextTemplate RemoveSubString(string Start, string End, bool RemoveKeys) {
				string SubString = "";
				
				//try to get the sub string and remove
				try {
					SubString = this.GetSubString(Start, End);
					this.Source = this.Source.Replace(SubString, "");
				}
				catch {
					throw new Exception("WebLegs.TextTemplate.RemoveSubString(): Boundry string mismatch.");
				}
				
				//should we remove the keys too?
				if(RemoveKeys) {
					this.Replace(Start, "");
					this.Replace(End, "");
				}
				return this;
			}
		//<-- End Method :: RemoveSubString
		
		//##################################################################################
		
		//--> Begin Method :: ToString
			public override string ToString() {
				return this.DTD + this.Source;
			}
		//<-- End Method :: ToString
		
		//##################################################################################
		
		//--> Begin Method :: SaveAs
			public void SaveAs(string FilePath) {
				try{
					//try to write file
					File.WriteAllText(FilePath, this.Source, Encoding.UTF8);
				}
				catch(Exception e) {
					throw new Exception("WebLegs.TextTemplate.SaveAs(): Unable to save file to '"+ FilePath +"'. "+ e.ToString());
				}
			}
		//<-- End Method :: SaveAs
	}
//<-- End Class :: TextTemplate

//##########################################################################################
//##########################################################################################
//##########################################################################################

//--> Begin Class :: TextXHTMLWriter
	//overload the XmlTextWriter (hacked)
	public class TextXHTMLWriter : XmlTextWriter  {
		//--> Begin :: Properties
			//elements that should be closed
			private string[] FullEndElements = new string[]{"script", "title", "textarea", "div", "span", "select"};
			//container/flag
			private string LastStartElement = null;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public TextXHTMLWriter(System.IO.Stream stream) : base(stream, Encoding.UTF8) { }
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin Method :: WriteStartElement
			public override void WriteStartElement(string Prefix, string LocalName, string Namespace) {
				LastStartElement = LocalName;
				base.WriteStartElement(Prefix, LocalName, Namespace);
			}
		//<-- End Method :: WriteStartElement
		
		//##################################################################################
		
		//--> Begin Method :: WriteEndElement
			public override void WriteEndElement() {
				//if the last opened element is in the full end elements array, then write a full end element for it
				if(Array.IndexOf(FullEndElements, LastStartElement) > -1) {
					WriteFullEndElement();
				}
				else {
					base.WriteEndElement();
				}
			}
		//<-- End Method :: WriteEndElement
	}
//<-- End Class :: TextXHTMLWriter

//##########################################################################################
</script>