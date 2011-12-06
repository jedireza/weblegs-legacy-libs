<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="javax.xml.transform.OutputKeys" %>
<%@ page import="javax.xml.transform.stream.*" %>
<%@ page import="javax.xml.transform.Transformer" %>
<%@ page import="javax.xml.transform.TransformerFactory" %>
<%@ page import="javax.xml.transform.stream.StreamSource" %>
<%@ page import="javax.xml.transform.stream.StreamResult" %>
<%@ page import="javax.xml.parsers.DocumentBuilderFactory" %>
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

//--> Begin Class :: TextTemplate
	public class TextTemplate {
		//--> Begin :: Properties
			public String Source;
			public String DTD;
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
			public TextTemplate LoadFile(String Path) throws Exception {
				//create new string builder
				StringBuilder Contents = new StringBuilder();
				
				//creat new buffer reader
				BufferedReader Reader =  new BufferedReader(new FileReader(new File(Path)));
				
				//read file in
				try{
					String Line = "";
					while(( Line = Reader.readLine()) != null){
						Contents.append(Line);
						Contents.append(System.getProperty("line.separator"));
					}
				}
				catch(Exception e){
					throw new Exception("WebLegs.TextTemplate.LoadFile(): File not found or not able to access.");
				}
				finally{
					Reader.close();
				}
				this.Source = Contents.toString();
				return this;
			}
			public TextTemplate LoadFile(String Path, String RootPath) throws Exception {
				//read in xml file into a string
				int NumberRead = 0;
				char[] Buffer = null;
				StringBuffer FileData = null;
				BufferedReader XMLSourceReader = null;			
				try{
					NumberRead = 0;
					Buffer = new char[1024];
					FileData = new StringBuffer(1000);
					XMLSourceReader = new BufferedReader(new FileReader(Path));
					while((NumberRead = XMLSourceReader.read(Buffer)) != -1){
						FileData.append(Buffer, 0, NumberRead);
					}
				}
				catch(Exception e){
					throw new Exception("WebLegs.TextTemplate.LoadFile(): File not found or not able to access.");
				}
				finally{
					//close buffer reader
					XMLSourceReader.close();
				}
				
				return this.Load(String.valueOf(FileData), RootPath);
			}
		//<-- End Method :: LoadFile
		
		//##################################################################################
		
		//--> Begin Method :: Load
			public TextTemplate Load(String Source) {
				//string container
				this.Source = Source;
				return this;
			}
			public TextTemplate Load(String Source, String RootPath) throws Exception {
				//get xsl file path from <?xml-stylesheet type="text/xml" href="_XSL/templates/www_main.xsl"?>
				String XSLTFilePath = "";
				Pattern MyPattern = Pattern.compile("xml-stylesheet.*href=[\"|\'](.*?)[\"|\']");
				Matcher MyMatcher = MyPattern.matcher(Source);
				
				//if we found the stylesheet then set the filepath
				if(MyMatcher.find()){
					XSLTFilePath = MyMatcher.group(1);
				}
				
				//get the dtd
				MyPattern = Pattern.compile("(<!DOCTYPE.*?>)");
				MyMatcher = MyPattern.matcher(Source);
				if(MyMatcher.find()){
					this.DTD = MyMatcher.group(1);
				}
				
				//strip out dtd
				Source = Source.replaceAll("<!DOCTYPE.*?>", "");
						
				//get the system ids for both the file and stylesheet
				//String XMLSystemID = new File(Path).toURL().toExternalForm();
				String XSLTSystemID = new File(RootPath + XSLTFilePath).toURL().toExternalForm();
				
				//create stream sources
				//StreamSource XMLSource = new StreamSource(XMLSystemID); 
				StreamSource XMLSource = new StreamSource(new StringReader(Source));
				StreamSource XSLTSource = new StreamSource(XSLTSystemID);

				//send result to a writer
				StringWriter MyStringWriter = new StringWriter();
				StreamResult MyResult = new StreamResult(MyStringWriter);
				
				//create transformer factory
				TransformerFactory MyTransformerFactory = TransformerFactory.newInstance();
				
				//create new transformer
				Transformer MyTransformer = MyTransformerFactory.newTransformer(XSLTSource);
				
				//set output properties
				MyTransformer.setOutputProperty(OutputKeys.CDATA_SECTION_ELEMENTS, "yes");
				MyTransformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "no");
				//MyTransformer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"); //I have not found the option to turn remote download off
				MyTransformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
				//MyTransformer.setOutputProperty(OutputKeys.INDENT, "yes");
				MyTransformer.setOutputProperty(OutputKeys.MEDIA_TYPE, "text/xml");
				MyTransformer.setOutputProperty(OutputKeys.METHOD, "xml");
				MyTransformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
				MyTransformer.setOutputProperty(OutputKeys.STANDALONE, "yes");
				MyTransformer.setOutputProperty(OutputKeys.VERSION, "1.0"); 
	
				//transform document
				MyTransformer.transform(XMLSource, MyResult);
				
				//create a document builder factory
				DocumentBuilderFactory MyDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
				
				//turn off validation
				MyDocumentBuilderFactory.setValidating(false);
				
				//set the transformed text to the source
				this.Source = MyStringWriter.toString();
				
				return this;
			}
		//<-- End Method :: Load
		
		//##################################################################################
		
		//--> Begin Method :: Replace
			public TextTemplate Replace(String This, String WithThis) {
				this.Source = this.Source.replaceAll(This.replaceAll("([\\\\*+\\[\\](){}\\$.?\\^|])", "\\\\$1"), WithThis);
				return this;
			}
		//<-- End Method :: Replace
		
		//##################################################################################
		
		//--> Begin Method :: GetSubString
			public String GetSubString(String Start, String End) throws Exception {
				int MyStart = 0;
				int MyEnd = 0;
				
				if(this.Source.indexOf(Start) > -1 && this.Source.lastIndexOf(End) > -1) {
					MyStart = (this.Source.indexOf(Start)) + Start.length();
					MyEnd = this.Source.lastIndexOf(End);

					try{
						return this.Source.substring(MyStart, MyEnd);
					}
					catch(Exception e) {
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
			public TextTemplate RemoveSubString(String Start, String End) throws Exception {
				this.RemoveSubString(Start, End, false);
				return this;
			}
			public TextTemplate RemoveSubString(String Start, String End, boolean RemoveKeys) throws Exception {
				String SubString = "";
				
				//try to get the sub string and remove
				try {
					SubString = GetSubString(Start, End);
				}
				catch(Exception e){
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
			public String ToString() {
				return this.DTD + this.Source;
			}
		//<-- End Method :: ToString	
		
		//##################################################################################
		
		//--> Begin Method :: SaveAs
			public void SaveAs(String FilePath) throws Exception {
				Writer OutputBuffer = null;
				try {
					OutputBuffer = new BufferedWriter(new FileWriter(new File(FilePath)));
					OutputBuffer.write(this.ToString());
				}
				catch(Exception e){
					throw new Exception("WebLegs.TextTemplate.SaveAs(): Unable to save file.");
				}
				finally {
					OutputBuffer.close();
				}
			}
		//<-- End Method :: ToString
	}
//<-- End Class :: TextTemplate

//##########################################################################################
%>