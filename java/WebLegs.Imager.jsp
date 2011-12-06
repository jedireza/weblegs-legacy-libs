<%@ page import="java.io.*" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.awt.*" %>
<%@ page import="java.awt.image.*" %>
<%@ page import="javax.imageio.*" %>
<%@ page import="javax.imageio.stream.*" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="javax.servlet.GenericServlet.*" %>
<%@ page import="java.lang.System" %>
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

//--> Begin Class :: Imager
	public class Imager {
		//--> Begin :: Properties
			public String BackgroundColor;
			public BufferedImage OutputImage;
			public String ContentType;
			public String ImageName;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public Imager() throws Exception {
				//set default background color
				this.BackgroundColor = "#000000";
				this.ImageName = "";
			}
			public Imager(String FilePath) throws Exception {
				//set default background color
				this.BackgroundColor = "#000000";
				this.Load(FilePath);
				this.ImageName = "";
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin :: Load
			public Imager Load(String FilePath) throws Exception  {
				if(!(new File(FilePath)).exists()){
					throw new Exception("WebLegs.Imager.Load(): File not found or not able to access.");
				}
				
				//get filename with out extension
				String TmpFileName = (new File(FilePath)).getName();
				
				//loadfile
				this.OutputImage = this.LoadImageFromFile(FilePath);
				
				String FileExt = TmpFileName.substring(TmpFileName.lastIndexOf('.'), TmpFileName.length());
				if(FileExt.equals(".png")){
					this.ContentType = "image/png";
				}
				else if(FileExt.equals(".jpg")){
					this.ContentType = "image/jpeg";
				}
				else if(FileExt.equals(".gif")){
					this.ContentType = "image/gif";
				}
				else{
					this.ContentType = "image/jpeg";
				}
				
				//get filename with out extension
				this.ImageName = TmpFileName;
				
				//return this
				return this;
			}
		//<-- End :: Load
		
		//##################################################################################
		
		//--> Begin :: Constrain
			public Imager Constrain(int Height, int Width) throws Exception {
				//original height and width
				int SourceWidth = this.GetWidth();
				int SourceHeight = this.GetHeight();
				
				//output height and width
					//calculation containers
					float ShrinkPercentage = 0;
					float ShrinkPercentageW = 0;
					float ShrinkPercentageH = 0;
					
					//calculate height and width percentages
					ShrinkPercentageH = ((float)Height/(float)SourceHeight);
					ShrinkPercentageW = ((float)Width/(float)SourceWidth);
					
					//if we have to pad the image, pad evenly on top/bottom or left/right
					if(ShrinkPercentageH < ShrinkPercentageW) {
						ShrinkPercentage = ShrinkPercentageH;
					}
					else {
						ShrinkPercentage = ShrinkPercentageW;
					}
					
					//calculate ouput height and width
					int OutputWidth = (int)Math.round(SourceWidth * ShrinkPercentage);
					int OutputHeight = (int)Math.round(SourceHeight * ShrinkPercentage);
					
					//adjust dimensions so that one dimension always matches the dimensions passed in
					float DifferencePercent = 0;
					int DifferenceWidth = Width - OutputWidth;
					int DifferenceHeight = Height - OutputHeight;
					
					//use the dimension that needs to be asdjusted by the least pixels
					if(DifferenceHeight < DifferenceWidth){
						DifferencePercent = (float)Height / (float)OutputHeight;
					}
					else{
						DifferencePercent = (float)Width / (float)OutputWidth;
					}
					
					//adjust both dimensions by the same percentage
					OutputWidth = (int)(OutputWidth * DifferencePercent);
					OutputHeight = (int)(OutputHeight * DifferencePercent);
				//end output height and width
				
				//Create a new  BufferedImage
				BufferedImage NewImage = new BufferedImage(OutputWidth, OutputHeight, BufferedImage.TYPE_INT_RGB);
				
				//create graphics
				Graphics2D MyGraphics = NewImage.createGraphics();
				
				//set background
				MyGraphics.setBackground(Color.decode(this.BackgroundColor));
				
				//clear rect
				MyGraphics.clearRect(0, 0, OutputWidth, OutputHeight);
				
				//draw image
				MyGraphics.drawImage(this.OutputImage, 0, 0, OutputWidth, OutputHeight, null );
				
				//dispose graphics
				MyGraphics.dispose();
				
				//resassign as a buffered image
				this.OutputImage = NewImage;
				
				//return this
				return this;
			}
		//<-- End :: Constrain
		
		//##################################################################################
		
		//--> Begin :: ConstrainHeight
			public Imager ConstrainHeight(int Height) throws Exception {
				//original height and width
				int SourceWidth = this.GetWidth();
				int SourceHeight = this.GetHeight();
				int Width = SourceWidth;
				
				//output height and width
					float ShrinkPercentage = ((float)Height/(float)SourceHeight);
					int OutputWidth = (int)(SourceWidth * ShrinkPercentage);
					int OutputHeight = (int)(SourceHeight * ShrinkPercentage);
					
					//make the height exactly what was passed in
					if(OutputHeight < Height) {
						int Offset = Height - OutputHeight;
						OutputWidth += Offset;
						OutputHeight += Offset;
					}
				//end output height and width			
				
				//Create a new  BufferedImage
				BufferedImage NewImage = new BufferedImage(OutputWidth, OutputHeight, BufferedImage.TYPE_INT_RGB);
				
				//create graphics
				Graphics2D MyGraphics = NewImage.createGraphics();
				
				//set background
				MyGraphics.setBackground(Color.decode(this.BackgroundColor));
				
				//clear rect
				MyGraphics.clearRect(0, 0, OutputWidth, OutputHeight);
				
				//draw image
				MyGraphics.drawImage(this.OutputImage, 0, 0, OutputWidth, OutputHeight, null );
				
				//dispose of graphics
				MyGraphics.dispose();
				
				//resassign as a buffered image
				this.OutputImage = NewImage;
				
				//return this
				return this;
			}
		//<-- End :: ConstrainHeight
		
		//##################################################################################
		
		//--> Begin :: ConstrainWidth
			public Imager ConstrainWidth(int Width) throws Exception {
				//original height and width
				int SourceWidth = this.GetWidth();
				int SourceHeight = this.GetHeight();
				int Height = SourceHeight;
				
				//output height and width
					float ShrinkPercentage = ((float)Width/(float)SourceWidth);
					int OutputWidth = (int)(SourceWidth * ShrinkPercentage);
					int OutputHeight = (int)(SourceHeight * ShrinkPercentage);
					
					//make the width exactly what was passed in
					if(OutputWidth < Width) {
						int Offset = Width - OutputWidth;
						OutputWidth += Offset;
						OutputHeight += Offset;
					}
				//end output height and width
				
				//Create a new  BufferedImage
				BufferedImage NewImage = new BufferedImage(OutputWidth, OutputHeight, BufferedImage.TYPE_INT_RGB);
				
				//create graphics
				Graphics2D MyGraphics = NewImage.createGraphics();
				
				//set background
				MyGraphics.setBackground(Color.decode(this.BackgroundColor));
				
				//clear rect
				MyGraphics.clearRect(0, 0, OutputWidth, OutputHeight);
				
				//draw image
				MyGraphics.drawImage(this.OutputImage, 0, 0, OutputWidth, OutputHeight, null );
				
				//dispose graphics
				MyGraphics.dispose();
				
				//resassign as a buffered image
				this.OutputImage = NewImage;
				
				//return this
				return this;
			}
		//<-- End :: ConstrainWidth
		
		//##################################################################################
		
		//--> Begin Method :: ScaleByPercent
			public Imager ScaleByPercent(int Percent) throws Exception {
				//original height and width
				int SourceWidth = this.GetWidth();
				int SourceHeight = this.GetHeight();
				
				//output height and width
				float ShrinkPercentage = ((float)Percent/100);
				int OutputWidth = (int)(SourceWidth * ShrinkPercentage);
				int OutputHeight = (int)(SourceHeight * ShrinkPercentage);
				
				//Create a new  BufferedImage
				BufferedImage NewImage = new BufferedImage(OutputWidth, OutputHeight, BufferedImage.TYPE_INT_RGB);
				
				//create graphics
				Graphics2D MyGraphics = NewImage.createGraphics();
				
				//set background
				MyGraphics.setBackground(Color.decode(this.BackgroundColor));
				
				//clear rect
				MyGraphics.clearRect(0, 0, OutputWidth, OutputHeight);
				
				//draw image
				MyGraphics.drawImage(this.OutputImage, 0, 0, OutputWidth, OutputHeight, null );
				
				//dispose graphics
				MyGraphics.dispose();
				
				//resassign as a buffered image
				this.OutputImage = NewImage;
				
				//return this
				return this;
			}
		//<-- End Method :: ScaleByPercent
		
		//##################################################################################
		
		//--> Begin Method :: FixedSize
			public Imager FixedSize(int Height, int Width) throws Exception {
				//original height and width
				int SourceWidth = this.GetWidth();
				int SourceHeight = this.GetHeight();
				
				//shrink calculations
					//output x and y coords (for padding)
					int OutputX = 0;
					int OutputY = 0; 
					
					//calculation containers
					float ShrinkPercentage = 0;
					float ShrinkPercentageW = 0;
					float ShrinkPercentageH = 0;
					
					//calculate height and width percentages
					ShrinkPercentageH = ((float)Height/(float)SourceHeight);
					ShrinkPercentageW = ((float)Width/(float)SourceWidth);
					
					//if we have to pad the image, pad evenly on top/bottom or left/right
					if(ShrinkPercentageH < ShrinkPercentageW) {
						ShrinkPercentage = ShrinkPercentageH;
						OutputX = (int)((Width - (SourceWidth * ShrinkPercentage)) / 2);
					}
					else {
						ShrinkPercentage = ShrinkPercentageW;
						OutputY = (int)((Height - (SourceHeight * ShrinkPercentage)) / 2);
					}
				//end shrink percentages
				
				//output height and width
				int OutputWidth  = (int)(SourceWidth * ShrinkPercentage);
				int OutputHeight = (int)(SourceHeight * ShrinkPercentage);
				
				//Create a new  BufferedImage
				BufferedImage NewImage = new BufferedImage(Width, Height, BufferedImage.TYPE_INT_RGB);
				
				//create new graphics
				Graphics2D MyGraphics = NewImage.createGraphics();
				
				//set background
				MyGraphics.setBackground(Color.decode(this.BackgroundColor));
				
				//clear rect
				MyGraphics.clearRect(0, 0, Width, Height);
				
				//draw image
				MyGraphics.drawImage(this.OutputImage, OutputX, OutputY, OutputWidth, OutputHeight, null, null );
				
				//dispose image
				MyGraphics.dispose();
				
				//resassign as a buffered image
				this.OutputImage = NewImage;
				
				//return this
				return this;
			}
		//<-- End Method :: FixedSize
		
		//##################################################################################
		
		//--> Begin Method :: Crop
			public Imager Crop(int Height, int Width, String Anchor) throws Exception {
				int OutputX = 0;
				int OutputY = 0;
				
				//calculate general points
				int Center = (int)(this.GetWidth() / 2);
				int Middle = (int)(this.GetHeight() / 2);
				
				//set x/y positions
					//- - - - - - - - - - - - - - - - - -//
					if(Anchor.equals("top-left")){
						OutputX = 0;
						OutputY = 0;
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(Anchor.equals("top-center")){
						OutputX = (int)(Center - (Width / 2));
						OutputY = 0;
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(Anchor.equals("top-right")){
						OutputX = (int)(this.GetWidth() - Width);
						OutputY = 0;
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(Anchor.equals("middle-left")){
						OutputX = 0;
						OutputY = (int)(Middle - (Height / 2));
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(Anchor.equals("middle")){
						OutputX = (int)(Center - (Width / 2));
						OutputY = (int)(Middle - (Height / 2));
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(Anchor.equals("middle-right")){
						OutputX = (int)(this.GetWidth() - Width);
						OutputY = (int)(Middle - (Height / 2));
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(Anchor.equals("bottom-left")){
						OutputX = 0;
						OutputY = (int)(this.GetHeight() - Height);
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(Anchor.equals("bottom-center")){
						OutputX = (int)(Center - (Width / 2));
						OutputY = (int)(this.GetHeight() - Height);
					}
					//- - - - - - - - - - - - - - - - - -//
					else if(Anchor.equals("bottom-right")){
						OutputX = (int)(this.GetWidth() - Width);
						OutputY = (int)(this.GetHeight() - Height);
					}
					
				//call the crop method
				this.Crop(Height, Width, OutputX, OutputY);
				
				//return this
				return this;
			}
			public Imager Crop(int Height, int Width, int SourceX, int SourceY) throws Exception {
				//output height and width
				int OutputWidth = this.GetWidth();
				int OutputHeight = this.GetHeight();
				
				//Create a new  BufferedImage
				BufferedImage NewImage = new BufferedImage(Width, Height, BufferedImage.TYPE_INT_RGB);
				
				//create new grapics
				Graphics2D MyGraphics = NewImage.createGraphics();
				
				//set background
				MyGraphics.setBackground(Color.decode(this.BackgroundColor));
				
				//clear rect
				MyGraphics.clearRect(0, 0, Width, Height);
				
				//draw image
				MyGraphics.drawImage(this.OutputImage, -SourceX, -SourceY, OutputWidth, OutputHeight, null, null);
				
				//dispose graphics
				MyGraphics.dispose();
				
				//resassign as a buffered image
				this.OutputImage = NewImage;
				
				//return this
				return this;
			}
		//<-- End Method :: Crop
		
		//##################################################################################
		
		//--> Begin Method :: GetHeight
			public int GetHeight() throws Exception {
				return this.OutputImage.getHeight();
			}
		//<-- End Method :: GetHeight
		
		//##################################################################################
		
		//--> Begin Method :: GetWidth
			public int GetWidth() throws Exception {
				return this.OutputImage.getWidth();
			}
		//<-- End Method :: GetWidth
				
		//##################################################################################
		
		//--> Begin Method :: SaveAs
			public Imager SaveAs(String DirectoryPath) throws Exception {
				try{
					if(this.ContentType.equals("image/gif")){
						ImageIO.write(this.OutputImage, "gif", new File(DirectoryPath + this.ImageName));
					}
					else if(this.ContentType.equals("image/jpeg")){
						ImageIO.write(this.OutputImage, "jpg", new File(DirectoryPath + this.ImageName));
					}
					else if(this.ContentType.equals("image/png")){
						ImageIO.write(this.OutputImage, "png", new File(DirectoryPath + this.ImageName));
					}
					else if(this.ContentType.equals("image/bmp")){
						ImageIO.write(this.OutputImage, "bmp", new File(DirectoryPath + this.ImageName));
					}
					else{
						ImageIO.write(this.OutputImage, "jpg", new File(DirectoryPath + this.ImageName));
					}
				}
				catch(Exception e){
					throw new Exception("WebLegs.Imager.SaveAs(): Unable to save file. "+ e.toString());
				}
				
				//return this
				return this;
			}
		//<-- End Method :: SaveAs
		
		//##################################################################################
		
		//--> Begin Method :: SaveHTTP
			public void SaveHTTP(HttpServletResponse ThisResponse, JspWriter ThisSystemOutput) throws Exception {
				if(this.ContentType.equals("image/gif")){
					this.SaveHTTP(this.ImageName +".gif", ThisResponse, ThisSystemOutput);
				}
				else if(this.ContentType.equals("image/jpeg")){
					this.SaveHTTP(this.ImageName +".jpg", ThisResponse, ThisSystemOutput);
				}
				else if(this.ContentType.equals("image/png")){
					this.SaveHTTP(this.ImageName +".png", ThisResponse, ThisSystemOutput);
				}
				else{	
					this.SaveHTTP(this.ImageName +".jpg", ThisResponse, ThisSystemOutput);
				}
			}
			public void SaveHTTP(String FileName, HttpServletResponse ThisResponse, JspWriter ThisSystemOutput) throws Exception {
				//reset the buffer
				ThisResponse.reset();
				
				//set content type
				ThisResponse.setContentType(this.ContentType);
				
				//create output stream
				OutputStream MyOutputStream = ThisResponse.getOutputStream();
				
				if(this.ContentType.equals("image/gif")){
					ThisResponse.setHeader("Content-Disposition", "filename="+ FileName +".gif;");
					ImageIO.write(this.OutputImage, "gif", MyOutputStream);
				}
				else if(this.ContentType.equals("image/jpeg")){
					ThisResponse.setHeader("Content-Disposition", "filename="+ FileName +".jpg;");
					ImageIO.write(this.OutputImage, "jpg", MyOutputStream);
				}
				else if(this.ContentType.equals("image/png")){
					ThisResponse.setHeader("Content-Disposition", "filename="+ FileName +".png;");
					ImageIO.write(this.OutputImage, "png", MyOutputStream);
				}
				else if(this.ContentType.equals("image/bmp")){
					ThisResponse.setHeader("Content-Disposition", "filename="+ FileName +".bmp;");
					ImageIO.write(this.OutputImage, "bmp", MyOutputStream);
				}
				else{
					ThisResponse.setHeader("Content-Disposition", "filename="+ FileName +".jpg;");
					ImageIO.write(this.OutputImage, "jpg", MyOutputStream);
				}
				
				//close output stream
				MyOutputStream.close();
				
				//close out
				ThisSystemOutput.close();
			}
		//<-- End Method :: SaveHTTP
		
		//##################################################################################
		
		//--> Begin Method :: LoadImageFromFile
			public BufferedImage LoadImageFromFile(String FilePath) throws Exception {
				return ImageIO.read(new File(FilePath));
			}
		//<-- End Method :: LoadImageFromFile
	}
//<-- End Class :: Imager

//##########################################################################################
%>