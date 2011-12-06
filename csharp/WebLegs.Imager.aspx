<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Drawing.Imaging" %>
<%@ Import Namespace="System.Drawing.Drawing2D" %>
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

//--> Begin Class :: Imager
	public class Imager {
		//--> Begin :: Properties
			public string BackgroundColor;
			public System.Drawing.Image OutputImage;
			public string ContentType;
			public string ImageName;
		//<-- End :: Properties
		
		//##################################################################################
		
		//--> Begin :: Constructor
			public Imager() {
				//set default background color
				this.BackgroundColor = "#000000";
			}
			
			public Imager(string FilePath) {
				//set default background color
				this.BackgroundColor = "#000000";
				this.Load(FilePath);
			}
		//<-- End :: Constructor
		
		//##################################################################################
		
		//--> Begin :: Load
			public Imager Load(string FilePath) {
				if(!File.Exists(FilePath)) {
					throw new Exception("WebLegs.Imager.Load(): The file '"+ FilePath +"' was not found or is inaccessable.");
				}
				
				this.OutputImage = this.LoadImageFromFile(FilePath);
				switch(System.IO.Path.GetExtension(FilePath)) {
					case ".png":
						this.ContentType = "image/png";
						break;
					case ".jpg":
						this.ContentType = "image/jpeg";
						break;
					case ".gif":
						this.ContentType = "image/gif";
						break;
					default:
						this.ContentType = "image/jpeg";
						break;
					
				}
				//get filename with out extension
				this.ImageName = System.IO.Path.GetFileNameWithoutExtension(FilePath);
				
				//return this
				return this;
			}
		//<-- End :: Load
		
		//##################################################################################
		
		//--> Begin :: Constrain
			public Imager Constrain(int Height, int Width) {
				//original height and width
				int SourceWidth = this.GetWidth();
				int SourceHeight = this.GetHeight();
				Rectangle SourceSize = new Rectangle(0, 0, SourceWidth, SourceHeight);
				
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
					int OutputWidth = (int)(SourceWidth * ShrinkPercentage);
					int OutputHeight = (int)(SourceHeight * ShrinkPercentage);
					
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
					
					Rectangle OutputSize = new Rectangle(0, 0, OutputWidth, OutputHeight);
				//end output height and width
				
				//create Bitmap and set formatting/resolution
				Bitmap BMPImage = new Bitmap(OutputWidth, OutputHeight, PixelFormat.Format32bppRgb);
				BMPImage.SetResolution(this.OutputImage.HorizontalResolution, this.OutputImage.VerticalResolution);
				
				//create Graphic image (from Bitmap) and set quality
				Graphics GFXImage = Graphics.FromImage(BMPImage);
				GFXImage.InterpolationMode = InterpolationMode.HighQualityBicubic;
				GFXImage.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
				GFXImage.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
				
				//draw this into the BMPImage
				GFXImage.DrawImage(this.OutputImage, OutputSize, SourceSize, GraphicsUnit.Pixel);
				GFXImage.Dispose();
				
				//write over the OutputImage memory
				this.OutputImage = BMPImage;
				
				//return this
				return this;
			}
		//<-- End :: Constrain
		
		//##################################################################################
		
		//--> Begin :: ConstrainHeight
			public Imager ConstrainHeight(int Height) {
				//original height and width
				int SourceWidth = this.GetWidth();
				int SourceHeight = this.GetHeight();
				Rectangle SourceSize = new Rectangle(0, 0, SourceWidth, SourceHeight);
				
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
					
					Rectangle OutputSize = new Rectangle(0, 0, OutputWidth, OutputHeight);
				//end output height and width
				
				//create Bitmap and set formatting/resolution
				Bitmap BMPImage = new Bitmap(OutputWidth, OutputHeight, PixelFormat.Format32bppRgb);
				BMPImage.SetResolution(this.OutputImage.HorizontalResolution, this.OutputImage.VerticalResolution);
				
				//create Graphic image (from Bitmap) and set quality
				Graphics GFXImage = Graphics.FromImage(BMPImage);
				GFXImage.InterpolationMode = InterpolationMode.HighQualityBicubic;
				GFXImage.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
				GFXImage.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
				
				//draw this into the BMPImage
				GFXImage.DrawImage(this.OutputImage, OutputSize, SourceSize, GraphicsUnit.Pixel);
				GFXImage.Dispose();
				
				//write over the OutputImage memory
				this.OutputImage = BMPImage;
				
				//return this
				return this;
			}
		//<-- End :: ConstrainHeight
		
		//##################################################################################
		
		//--> Begin :: ConstrainWidth
			public Imager ConstrainWidth(int Width) {
				//original height and width
				int SourceWidth = this.GetWidth();
				int SourceHeight = this.GetHeight();
				Rectangle SourceSize = new Rectangle(0, 0, SourceWidth, SourceHeight);
				
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
					
					Rectangle OutputSize = new Rectangle(0, 0, OutputWidth, OutputHeight);
				//end output height and width
				
				//create Bitmap and set formatting/resolution
				Bitmap BMPImage = new Bitmap(OutputWidth, OutputHeight, PixelFormat.Format32bppRgb);
				BMPImage.SetResolution(this.OutputImage.HorizontalResolution, this.OutputImage.VerticalResolution);
				
				//create Graphic image (from Bitmap) and set quality
				Graphics GFXImage = Graphics.FromImage(BMPImage);
				GFXImage.InterpolationMode = InterpolationMode.HighQualityBicubic;
				GFXImage.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
				GFXImage.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
				
				//draw this into the BMPImage using the GFXImage
				GFXImage.DrawImage(this.OutputImage, OutputSize, SourceSize, GraphicsUnit.Pixel);
				GFXImage.Dispose();
				
				//write over the OutputImage memory
				this.OutputImage = BMPImage;
				
				//return this
				return this;
			}
		//<-- End :: ConstrainWidth
		
		//##################################################################################
		
		//--> Begin Method :: ScaleByPercent
			public Imager ScaleByPercent(int Percent) {
				//original height and width
				int SourceWidth = this.GetWidth();
				int SourceHeight = this.GetHeight();
				Rectangle SourceSize = new Rectangle(0, 0, SourceWidth, SourceHeight);
				
				//output height and width
				float ShrinkPercentage = ((float)Percent/100);
				int OutputWidth = (int)(SourceWidth * ShrinkPercentage);
				int OutputHeight = (int)(SourceHeight * ShrinkPercentage);
				Rectangle OutputSize = new Rectangle(0, 0, OutputWidth, OutputHeight);
				
				//create Bitmap and set formatting/resolution
				Bitmap BMPImage = new Bitmap(OutputWidth, OutputHeight, PixelFormat.Format32bppRgb);
				BMPImage.SetResolution(this.OutputImage.HorizontalResolution, this.OutputImage.VerticalResolution);
				
				//create Graphic image (from Bitmap) and set quality
				Graphics GFXImage = Graphics.FromImage(BMPImage);
				GFXImage.InterpolationMode = InterpolationMode.HighQualityBicubic;
				GFXImage.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
				GFXImage.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
				
				//draw this into the BMPImage using the GFXImage
				GFXImage.DrawImage(this.OutputImage, OutputSize, SourceSize, GraphicsUnit.Pixel);
				GFXImage.Dispose();
				
				//write over the OutputImage memory
				this.OutputImage = BMPImage;
				
				//return this
				return this;
			}
		//<-- End Method :: ScaleByPercent
		
		//##################################################################################
		
		//--> Begin Method :: FixedSize
			public Imager FixedSize(int Height, int Width) {
				//original height and width
				int SourceWidth = this.GetWidth();
				int SourceHeight = this.GetHeight();
				Rectangle SourceSize = new Rectangle(0, 0, SourceWidth, SourceHeight);
				
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
				//make the width exactly what was passed in
				if(OutputWidth < Width) {
					int Offset = Width - OutputWidth;
					OutputWidth += Offset;
					OutputHeight += Offset;
				}
				Rectangle OutputSize = new Rectangle(OutputX, OutputY, OutputWidth, OutputHeight);
				
				//create Bitmap and set formatting/resolution
				Bitmap BMPImage = new Bitmap(Width, Height, PixelFormat.Format32bppRgb);
				BMPImage.SetResolution(this.OutputImage.HorizontalResolution, this.OutputImage.VerticalResolution);
				
				//create Graphic image (from Bitmap) and set quality
				Graphics GFXImage = Graphics.FromImage(BMPImage);
				GFXImage.Clear(System.Drawing.ColorTranslator.FromHtml(this.BackgroundColor));
				GFXImage.InterpolationMode = InterpolationMode.HighQualityBicubic;
				GFXImage.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
				GFXImage.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
				
				//draw this into the BMPImage using the GFXImage
				GFXImage.DrawImage(this.OutputImage, OutputSize, SourceSize, GraphicsUnit.Pixel);
				GFXImage.Dispose();
				
				//write over the OutputImage memory
				this.OutputImage = BMPImage;
				
				//return this
				return this;
			}
		//<-- End Method :: FixedSize
		
		//##################################################################################
		
		//--> Begin Method :: Crop
			public Imager Crop(int Height, int Width, string Anchor) {
				int OutputX = 0;
				int OutputY = 0;
				
				//calculate general points
				int Center = (int)(this.GetWidth() / 2);
				int Middle = (int)(this.GetHeight() / 2);
				
				//set x/y positions
				switch(Anchor) {
					//- - - - - - - - - - - - - - - - - -//
					case "top-left":
						OutputX = 0;
						OutputY = 0;
						break;
					//- - - - - - - - - - - - - - - - - -//
					case "top-center":
						OutputX = (int)(Center - (Width / 2));
						OutputY = 0;
						break;
					//- - - - - - - - - - - - - - - - - -//
					case "top-right":
						OutputX = (int)(this.GetWidth() - Width);
						OutputY = 0;
						break;
					//- - - - - - - - - - - - - - - - - -//
					case "middle-left":
						OutputX = 0;
						OutputY = (int)(Middle - (Height / 2));
						break;
					//- - - - - - - - - - - - - - - - - -//
					case "middle":
						OutputX = (int)(Center - (Width / 2));
						OutputY = (int)(Middle - (Height / 2));
						break;
					//- - - - - - - - - - - - - - - - - -//
					case "middle-right":
						OutputX = (int)(this.GetWidth() - Width);
						OutputY = (int)(Middle - (Height / 2));
						break;
					//- - - - - - - - - - - - - - - - - -//
					case "bottom-left":
						OutputX = 0;
						OutputY = (int)(this.GetHeight() - Height);
						break;
					//- - - - - - - - - - - - - - - - - -//
					case "bottom-center":
						OutputX = (int)(Center - (Width / 2));
						OutputY = (int)(this.GetHeight() - Height);
						break;
					//- - - - - - - - - - - - - - - - - -//
					case "bottom-right":
						OutputX = (int)(this.GetWidth() - Width);
						OutputY = (int)(this.GetHeight() - Height);
						break;
					//- - - - - - - - - - - - - - - - - -//
					default: 
						//do nothing
						break;
				}
				
				//call the crop method
				this.Crop(Height, Width, OutputX, OutputY);
				
				//return this
				return this;
			}
			public Imager Crop(int Height, int Width, int SourceX, int SourceY) {
				//original height and width
				int SourceWidth = this.GetWidth();
				int SourceHeight = this.GetHeight();
				Rectangle SourceSize = new Rectangle(SourceX, SourceY, SourceWidth, SourceHeight);
				
				//output height and width
				Rectangle OutputSize = new Rectangle(0, 0, SourceWidth, SourceHeight);
				
				//create Bitmap and set formatting/resolution
				Bitmap BMPImage = new Bitmap(Width, Height, PixelFormat.Format32bppRgb);
				BMPImage.SetResolution(this.OutputImage.HorizontalResolution, this.OutputImage.VerticalResolution);
				
				//create Graphic image (from Bitmap) and set quality
				Graphics GFXImage = Graphics.FromImage(BMPImage);
				GFXImage.Clear(System.Drawing.ColorTranslator.FromHtml(this.BackgroundColor));
				GFXImage.InterpolationMode = InterpolationMode.HighQualityBicubic;
				GFXImage.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
				GFXImage.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
				
				//draw this into the BMPImage using the GFXImage
				GFXImage.DrawImage(this.OutputImage, OutputSize, SourceSize, GraphicsUnit.Pixel);
				GFXImage.Dispose();
				
				//write over the OutputImage memory
				this.OutputImage = BMPImage;
				
				//return this
				return this;
			}
		//<-- End Method :: Crop
		
		//##################################################################################
		
		//--> Begin Method :: GetHeight
			public int GetHeight() {
				return this.OutputImage.Height;
			}
		//<-- End Method :: GetHeight
		
		//##################################################################################
		
		//--> Begin Method :: GetWidth
			public int GetWidth() {
				return this.OutputImage.Width;
			}
		//<-- End Method :: GetWidth
				
		//##################################################################################
		
		//--> Begin Method :: SaveAs
			public Imager SaveAs(string FullPath) {
				//save bitmap to stream
				try {
					switch(this.ContentType) {
						//- - - - - - - - - - - - - - - - - -//
						case "image/gif":
							this.OutputImage.Save(FullPath, ImageFormat.Gif);
							break;
						//- - - - - - - - - - - - - - - - - -//
						case "image/jpeg":
							this.OutputImage.Save(FullPath, ImageFormat.Jpeg);
							break;
						//- - - - - - - - - - - - - - - - - -//
						case "image/png":
							this.OutputImage.Save(FullPath, ImageFormat.Png);
							break;
						//- - - - - - - - - - - - - - - - - -//
						default:
							this.OutputImage.Save(FullPath, ImageFormat.Jpeg);
							break;
					}
				}
				catch(Exception e) {
					throw new Exception("WebLegs.Imager.SaveAs(): Unable to save file to '"+ FullPath +"'.");
				}
				
				//return this
				return this;
			}
		//<-- End Method :: SaveAs
		
		//##################################################################################
		
		//--> Begin Method :: SaveHTTP
			public void SaveHTTP() {
				switch(this.ContentType) {
					case "image/gif":
						this.SaveHTTP(this.ImageName +".gif");
						break;
					case "image/jpeg":
						this.SaveHTTP(this.ImageName +".jpg");
						break;
					case "image/png":
						this.SaveHTTP(this.ImageName +".png");
						break;
					default:
						this.SaveHTTP(this.ImageName +".jpg");
						break;
				}
			}
			public void SaveHTTP(string FileName) {
				//create memory stream
				System.IO.MemoryStream MyMemoryStream = new System.IO.MemoryStream();
				
				//save image to stream
				switch(this.ContentType) {
					//- - - - - - - - - - - - - - - - - -//
					case "image/gif":
						System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition", "filename="+ FileName +";");
						this.OutputImage.Save(MyMemoryStream, ImageFormat.Gif);
						break;
					//- - - - - - - - - - - - - - - - - -//
					case "image/jpeg":
						System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition", "filename="+ FileName +";");
						this.OutputImage.Save(MyMemoryStream, ImageFormat.Jpeg);
						break;
					//- - - - - - - - - - - - - - - - - -//
					case "image/png":
						System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition", "filename="+ FileName +";");
						this.OutputImage.Save(MyMemoryStream, ImageFormat.Png);
						break;
					//- - - - - - - - - - - - - - - - - -//
					default:
						System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition", "filename="+ FileName +";");
						this.OutputImage.Save(MyMemoryStream, ImageFormat.Jpeg);
						break;
				}
				
				//set content type and write stream to the current Response.OutputStream
				System.Web.HttpContext.Current.Response.ContentType = this.ContentType;
				MyMemoryStream.WriteTo(System.Web.HttpContext.Current.Response.OutputStream);
				System.Web.HttpContext.Current.Response.End();
			}
		//<-- End Method :: SaveHTTP
		
		//##################################################################################
		
		//--> Begin Method :: LoadImageFromFile
			public System.Drawing.Image LoadImageFromFile(string FilePath) {
				System.Drawing.Image VirtualImage = null;
				using(FileStream myFileStream = new FileStream(FilePath, FileMode.Open, FileAccess.Read)) {
					byte[] ImageBytes;
					ImageBytes = new byte[myFileStream.Length];
					myFileStream.Read(ImageBytes, 0, ImageBytes.Length);
					myFileStream.Close();
					VirtualImage = System.Drawing.Image.FromStream(new MemoryStream(ImageBytes));
					ImageBytes = null;
				}
				GC.Collect();
				return VirtualImage;
			}
		//<-- End Method :: LoadImageFromFile
	}
//<-- End Class :: Imager

//##########################################################################################
</script>