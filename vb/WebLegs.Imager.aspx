<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Drawing.Imaging" %>
<%@ Import Namespace="System.Drawing.Drawing2D" %>
<script language="vb" runat="server">
'/##########################################################################################

'/*
'Copyright (C) 2005-2010 WebLegs, Inc.
'This program is free software: you can redistribute it and/or modIfy it under the terms
'of the GNU General Public License as published by the Free Software Foundation, either
'version 3 of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
'without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
'See the GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License along with this program.
'If not, see <http://www.gnu.org/licenses/>.
'*/

'/##########################################################################################

'/--> Begin Class :: Imager
	Public Class Imager
		'/--> Begin :: Properties
			Public BackgroundColor As String
			Public OutputImage As System.Drawing.Image
			Public ContentType As String
			Public ImageName As String
		'/<-- End :: Properties
		
		'/##################################################################################
		
		'/--> Begin :: Constructor
			Public Sub New() 
				'set default background color
				Me.BackgroundColor = "#000000"
			End Sub
			Public Sub New(FilePath As String) 
				'set default background color
				Me.BackgroundColor = "#000000"
				Me.Load(FilePath)
			End Sub
		'/<-- End :: Constructor
		
		'/##################################################################################
		
		'/--> Begin :: Load
			Public Function Load(FilePath As String) 
				If Not File.Exists(FilePath) Then
					Throw New Exception("WebLegs.Imager.Load(): File not found or not able to access.")
				End If
				
				Me.OutputImage = Me.LoadImageFromFile(FilePath)
				Select Case System.IO.Path.GetExtension(FilePath)
					Case ".png"
						Me.ContentType = "image/png"
					Case ".jpg"
						Me.ContentType = "image/jpeg"
					Case ".gIf"
						Me.ContentType = "image/gIf"
					Case Else
						Me.ContentType = "image/jpeg"
				End Select
				'get filename with out extension
				Me.ImageName = System.IO.Path.GetFileNameWithoutExtension(FilePath)
				
				'return me
				Return Me
			End Function
		'/<-- End :: Load
		
		'/##################################################################################
		
		'/--> Begin :: Constrain
			Public Function Constrain(Height As Integer, Width As Integer) As Imager
				'original height and width
				Dim SourceWidth As Integer = Me.GetWidth()
				Dim SourceHeight As Integer = Me.GetHeight()
				Dim SourceSize As Rectangle = New Rectangle(0, 0, SourceWidth, SourceHeight)
				
				'output height and width
					'calculation containers
					Dim ShrinkPercentage As Single = 0
					Dim ShrinkPercentageW As Single = 0
					Dim ShrinkPercentageH As Single = 0
					
					'calculate height and width percentages
					ShrinkPercentageH = (CType(Height, Single)/CType(SourceHeight, Single))
					ShrinkPercentageW = (CType(Width, Single)/CType(SourceWidth, Single))
					
					'If we have to pad the image, pad evenly on top/bottom or left/right
					If ShrinkPercentageH < ShrinkPercentageW Then
						ShrinkPercentage = ShrinkPercentageH
					Else 
						ShrinkPercentage = ShrinkPercentageW
					End If
					
					'calculate ouput height and width
					Dim OutputWidth As Integer = CType((SourceWidth * ShrinkPercentage), Integer)
					Dim OutputHeight As Integer = CType((SourceHeight * ShrinkPercentage), Integer)
					
					'adjust dimensions so that one dimension always matches the dimensions passed in
					Dim DifferencePercent As Double = 0
					Dim DifferenceWidth As Integer = Width - OutputWidth
					Dim DifferenceHeight As Integer = Height - OutputHeight
	
					'use the dimension that needs to be asdjusted by the least pixels
					If DifferenceHeight < DifferenceWidth Then
						DifferencePercent = CType(Height, Double) / CType(OutputHeight, Double)
					Else
						DifferencePercent = CType(Width, Double) / CType(OutputWidth, Double)
					End If
				   
					'adjust both dimensions by the same percentage
					OutputWidth = CType((OutputWidth * DifferencePercent), Integer)
					OutputHeight = CType((OutputHeight * DifferencePercent), Integer)
					
					Dim OutputSize As Rectangle = New Rectangle(0, 0, OutputWidth, OutputHeight)
				'end output height and width
				
				'create Bitmap and set formatting/resolution
				Dim BMPImage As Bitmap = New Bitmap(OutputWidth, OutputHeight, PixelFormat.Format32bppRgb)
				BMPImage.SetResolution(Me.OutputImage.HorizontalResolution, Me.OutputImage.VerticalResolution)
				
				'create Graphic image (from Bitmap) and set quality
				Dim GFXImage As Graphics = Graphics.FromImage(BMPImage)
				GFXImage.InterpolationMode = InterpolationMode.HighQualityBicubic
				GFXImage.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality
				GFXImage.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality
				
				'draw this Integero the BMPImage
				GFXImage.DrawImage(Me.OutputImage, OutputSize, SourceSize, GraphicsUnit.Pixel)
				GFXImage.Dispose()
				
				'write over the OutputImage memory
				Me.OutputImage = BMPImage
				
				'return me
				Return Me
			End Function
		'/<-- End :: Constrain
		
		'/##################################################################################
		
		'/--> Begin :: ConstrainHeight
			Public Function ConstrainHeight(Height As Integer) As Imager
				'original height and width
				Dim SourceWidth As Integer = Me.GetWidth()
				Dim SourceHeight As Integer = Me.GetHeight()
				Dim SourceSize As Rectangle = New Rectangle(0, 0, SourceWidth, SourceHeight)
				
				'output height and width
					Dim ShrinkPercentage As Single = (CType(Height, Single)/CType(SourceHeight, Single))
					Dim OutputWidth As Integer = CType((SourceWidth * ShrinkPercentage), Integer)
					Dim OutputHeight As Integer = CType((SourceHeight * ShrinkPercentage), Integer)
					
					'make the height exactly what was passed in
					If OutputHeight < Height Then
						Dim Offset As Integer = (Height - OutputHeight)
						OutputWidth += Offset
						OutputHeight += Offset
					End If
					
					Dim OutputSize As Rectangle = New Rectangle(0, 0, OutputWidth, OutputHeight)
				'end output height and width
				
				'create Bitmap and set formatting/resolution
				Dim BMPImage As Bitmap = New Bitmap(OutputWidth, OutputHeight, PixelFormat.Format32bppRgb)
				BMPImage.SetResolution(Me.OutputImage.HorizontalResolution, Me.OutputImage.VerticalResolution)
				
				'create Graphic image (from Bitmap) and set quality
				Dim GFXImage As Graphics = Graphics.FromImage(BMPImage)
				GFXImage.InterpolationMode = InterpolationMode.HighQualityBicubic
				GFXImage.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality
				GFXImage.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality
				
				'draw this Integero the BMPImage
				GFXImage.DrawImage(Me.OutputImage, OutputSize, SourceSize, GraphicsUnit.Pixel)
				GFXImage.Dispose()
				
				'write over the OutputImage memory
				Me.OutputImage = BMPImage
				
				'return me
				Return Me
			End Function
		'/<-- End :: ConstrainHeight
		
		'/##################################################################################
		
		'/--> Begin :: ConstrainWidth
			Public Function ConstrainWidth(Width As Integer) As Imager
				'original height and width
				Dim SourceWidth As Integer = Me.GetWidth()
				Dim SourceHeight As Integer = Me.GetHeight()
				Dim SourceSize As Rectangle = New Rectangle(0, 0, SourceWidth, SourceHeight)
				
				'output height and width
					Dim ShrinkPercentage As Single = (CType(Width, Single)/CType(SourceWidth, Single))
					Dim OutputWidth As Integer = CType((SourceWidth * ShrinkPercentage), Integer)
					Dim OutputHeight As Integer = CType((SourceHeight * ShrinkPercentage), Integer)
					
					'make the width exactly what was passed in
					If OutputWidth < Width Then
						Dim Offset As Integer = Width - OutputWidth
						OutputWidth += Offset
						OutputHeight += Offset
					End If
					
					Dim OutputSize As Rectangle = New Rectangle(0, 0, OutputWidth, OutputHeight)
				'end output height and width
				
				'create Bitmap and set formatting/resolution
				Dim BMPImage As Bitmap = New Bitmap(OutputWidth, OutputHeight, PixelFormat.Format32bppRgb)
				BMPImage.SetResolution(Me.OutputImage.HorizontalResolution, Me.OutputImage.VerticalResolution)
				
				'create Graphic image (from Bitmap) and set quality
				Dim GFXImage As Graphics = Graphics.FromImage(BMPImage)
				GFXImage.InterpolationMode = InterpolationMode.HighQualityBicubic
				GFXImage.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality
				GFXImage.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality
				
				'draw this Integero the BMPImage using the GFXImage
				GFXImage.DrawImage(Me.OutputImage, OutputSize, SourceSize, GraphicsUnit.Pixel)
				GFXImage.Dispose()
				
				'write over the OutputImage memory
				Me.OutputImage = BMPImage
				
				'return me
				Return Me
			End Function
		'/<-- End :: ConstrainWidth
		
		'/##################################################################################
		
		'/--> Begin Method :: ScaleByPercent
			Public Function ScaleByPercent(Percent As Integer) As Imager
				'original height and width
				Dim SourceWidth As Integer = Me.GetWidth()
				Dim SourceHeight As Integer = Me.GetHeight()
				Dim SourceSize As Rectangle = New Rectangle(0, 0, SourceWidth, SourceHeight)
				
				'output height and width
				Dim ShrinkPercentage As Single = (CType(Percent, Single)/100)
				Dim OutputWidth As Integer = CType((SourceWidth * ShrinkPercentage), Integer)
				Dim OutputHeight As Integer = CType((SourceHeight * ShrinkPercentage), Integer)
				Dim OutputSize As Rectangle = New Rectangle(0, 0, OutputWidth, OutputHeight)
				
				'create Bitmap and set formatting/resolution
				Dim BMPImage As Bitmap = New Bitmap(OutputWidth, OutputHeight, PixelFormat.Format32bppRgb)
				BMPImage.SetResolution(Me.OutputImage.HorizontalResolution, Me.OutputImage.VerticalResolution)
				
				'create Graphic image (from Bitmap) and set quality
				Dim GFXImage As Graphics = Graphics.FromImage(BMPImage)
				GFXImage.InterpolationMode = InterpolationMode.HighQualityBicubic
				GFXImage.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality
				GFXImage.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality
				
				'draw this Integero the BMPImage using the GFXImage
				GFXImage.DrawImage(Me.OutputImage, OutputSize, SourceSize, GraphicsUnit.Pixel)
				GFXImage.Dispose()
				
				'write over the OutputImage memory
				Me.OutputImage = BMPImage
				
				'return me
				Return Me
			End Function
		'/<-- End Method :: ScaleByPercent
		
		'/##################################################################################
		
		'/--> Begin Method :: FixedSize
			Public Function FixedSize(Height As Integer, Width As Integer) As Imager
				'original height and width
				Dim SourceWidth As Integer = Me.GetWidth()
				Dim SourceHeight As Integer = Me.GetHeight()
				Dim SourceSize As Rectangle = New Rectangle(0, 0, SourceWidth, SourceHeight)
				
				'shrink calculations
					'output x and y coords (for padding)
					Dim OutputX As Integer = 0
					Dim OutputY As Integer = 0 
					
					'calculation containers
					Dim ShrinkPercentage As Single = 0
					Dim ShrinkPercentageW As Single = 0
					Dim ShrinkPercentageH As Single = 0
					
					'calculate height and width percentages
					ShrinkPercentageH = (CType(Height, Single)/CType(SourceHeight, Single))
					ShrinkPercentageW = (CType(Width, Single)/CType(SourceWidth, Single))
					
					'If we have to pad the image, pad evenly on top/bottom or left/right
					If ShrinkPercentageH < ShrinkPercentageW Then
						ShrinkPercentage = ShrinkPercentageH
						OutputX = CType(((Width - (SourceWidth * ShrinkPercentage)) / 2), Integer)
					Else 
						ShrinkPercentage = ShrinkPercentageW
						OutputY = CType(((Height - (SourceHeight * ShrinkPercentage)) / 2), Integer)
					End If
				'end shrink percentages
				
				'output height and width
				Dim OutputWidth As Integer = CType((SourceWidth * ShrinkPercentage), Integer)
				Dim OutputHeight As Integer = CType((SourceHeight * ShrinkPercentage), Integer)
				'make the width exactly what was passed in
				If OutputWidth < Width Then
					Dim Offset As Integer = Width - OutputWidth
					OutputWidth += Offset
					OutputHeight += Offset
				End If
				Dim OutputSize As Rectangle = New Rectangle(OutputX, OutputY, OutputWidth, OutputHeight)
				
				'create Bitmap and set formatting/resolution
				Dim BMPImage As Bitmap = New Bitmap(Width, Height, PixelFormat.Format32bppRgb)
				BMPImage.SetResolution(Me.OutputImage.HorizontalResolution, Me.OutputImage.VerticalResolution)
				
				'create Graphic image (from Bitmap) and set quality
				Dim GFXImage As Graphics = Graphics.FromImage(BMPImage)
				GFXImage.Clear(System.Drawing.ColorTranslator.FromHtml(Me.BackgroundColor))
				GFXImage.InterpolationMode = InterpolationMode.HighQualityBicubic
				GFXImage.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality
				GFXImage.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality
				
				'draw this Integero the BMPImage using the GFXImage
				GFXImage.DrawImage(Me.OutputImage, OutputSize, SourceSize, GraphicsUnit.Pixel)
				GFXImage.Dispose()
				
				'write over the OutputImage memory
				Me.OutputImage = BMPImage
				
				'return me
				Return Me
			End Function
		'/<-- End Method :: FixedSize
		
		'/##################################################################################
		
		'/--> Begin Method :: Crop
			Public Function Crop(Height As Integer, Width As Integer, Anchor As String) As Imager
				Dim OutputX As Integer = 0
				Dim OutputY As Integer = 0
				
				'calculate general poIntegers
				Dim Center As Integer = CType((Me.GetWidth() / 2), Integer)
				Dim Middle As Integer = CType((Me.GetHeight() / 2), Integer)
				
				'set x/y positions
				Select Case Anchor
					'- - - - - - - - - - - - - - - - - -'
					Case "top-left"
						OutputX = 0
						OutputY = 0
					'- - - - - - - - - - - - - - - - - -'
					Case "top-center"
						OutputX = CType((Center - (Width / 2)), Integer)
						OutputY = 0
					'- - - - - - - - - - - - - - - - - -'
					Case "top-right"
						OutputX = CType((Me.GetWidth() - Width), Integer)
						OutputY = 0
					'- - - - - - - - - - - - - - - - - -'
					Case "middle-left"
						OutputX = 0
						OutputY = CType((Middle - (Height / 2)), Integer)
					'- - - - - - - - - - - - - - - - - -'
					Case "middle"
						OutputX = CType((Center - (Width / 2)), Integer)
						OutputY = CType((Middle - (Height / 2)), Integer)
					'- - - - - - - - - - - - - - - - - -'
					Case "middle-right"
						OutputX = CType((Me.GetWidth() - Width), Integer)
						OutputY = CType((Middle - (Height / 2)), Integer)
					'- - - - - - - - - - - - - - - - - -'
					Case "bottom-left"
						OutputX = 0
						OutputY = CType((Me.GetHeight() - Height), Integer)
					'- - - - - - - - - - - - - - - - - -'
					Case "bottom-center"
						OutputX = CType((Center - (Width / 2)), Integer)
						OutputY = CType((Me.GetHeight() - Height), Integer)
					'- - - - - - - - - - - - - - - - - -'
					Case "bottom-right"
						OutputX = CType((Me.GetWidth() - Width), Integer)
						OutputY = CType((Me.GetHeight() - Height), Integer)
					'- - - - - - - - - - - - - - - - - -'
					Case Else 
						'do nothing
				End Select
				
				'call the crop method
				Me.Crop(Height, Width, OutputX, OutputY)
				
				'return me
				Return Me
			End Function
			Public Function Crop(Height As Integer, Width As Integer, SourceX As Integer, SourceY As Integer) As Imager
				'original height and width
				Dim SourceWidth As Integer = Me.GetWidth()
				Dim SourceHeight As Integer = Me.GetHeight()
				Dim SourceSize As Rectangle = New Rectangle(SourceX, SourceY, SourceWidth, SourceHeight)
				
				'output height and width
				Dim OutputSize As Rectangle = New Rectangle(0, 0, SourceWidth, SourceHeight)
				
				'create Bitmap and set formatting/resolution
				Dim BMPImage As Bitmap = New Bitmap(Width, Height, PixelFormat.Format32bppRgb)
				BMPImage.SetResolution(Me.OutputImage.HorizontalResolution, Me.OutputImage.VerticalResolution)
				
				'create Graphic image (from Bitmap) and set quality
				Dim GFXImage As Graphics = Graphics.FromImage(BMPImage)
				GFXImage.Clear(System.Drawing.ColorTranslator.FromHtml(Me.BackgroundColor))
				GFXImage.InterpolationMode = InterpolationMode.HighQualityBicubic
				GFXImage.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality
				GFXImage.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality
				
				'draw this Integero the BMPImage using the GFXImage
				GFXImage.DrawImage(Me.OutputImage, OutputSize, SourceSize, GraphicsUnit.Pixel)
				GFXImage.Dispose()
				
				'write over the OutputImage memory
				Me.OutputImage = BMPImage
				
				'return me
				Return Me
			End Function
		'/<-- End Method :: Crop
		
		'/##################################################################################
		
		'/--> Begin Method :: GetHeight
			Public Function GetHeight() As Integer
				return Me.OutputImage.Height
			End Function
		'/<-- End Method :: GetHeight
		
		'/##################################################################################
		
		'/--> Begin Method :: GetWidth
			Public Function GetWidth() As Integer
				return Me.OutputImage.Width
			End Function
		'/<-- End Method :: GetWidth
		
		'/##################################################################################
		
		'/--> Begin Method :: SaveAs
			Public Function SaveAs(FullPath As String) As Imager
				Try
					'save bitmap to stream
					Select Case Me.ContentType
						'- - - - - - - - - - - - - - - - - -'
						Case "image/gIf"
							Me.OutputImage.Save(FullPath, ImageFormat.Gif)
						'- - - - - - - - - - - - - - - - - -'
						Case "image/jpeg"
							Me.OutputImage.Save(FullPath, ImageFormat.Jpeg)
						'- - - - - - - - - - - - - - - - - -'
						Case "image/png"
							Me.OutputImage.Save(FullPath, ImageFormat.Png)
						'- - - - - - - - - - - - - - - - - -'
						Case Else
							Me.OutputImage.Save(FullPath, ImageFormat.Jpeg)
					End Select
				Catch e As Exception
					Throw New Exception("WebLegs.Imager.SaveAs(): Unable to save file.")
				End Try
				
				'return me
				Return Me
			End Function
		'/<-- End Method :: SaveAs
		
		'/##################################################################################
		
		'/--> Begin Method :: SaveHTTP
			Public Sub SaveHTTP() 
				Select Case Me.ContentType
					Case "image/gif"
						Me.SaveHTTP(Me.ImageName &".gif")
					Case "image/jpeg"
						Me.SaveHTTP(Me.ImageName &".jpg")
					Case "image/png"
						Me.SaveHTTP(Me.ImageName &".png")
					Case Else
						Me.SaveHTTP(Me.ImageName &".jpg")
				End Select
			End Sub
			Public Sub SaveHTTP(FileName As String) 
				'create memory stream
				Dim MyMemoryStream As System.IO.MemoryStream = New System.IO.MemoryStream()
				
				'save image to stream
				Select Case Me.ContentType
					'- - - - - - - - - - - - - - - - - -'
					Case "image/gIf"
						System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition", "filename="& FileName &";")
						Me.OutputImage.Save(MyMemoryStream, ImageFormat.GIf)
					'- - - - - - - - - - - - - - - - - -'
					Case "image/jpeg"
						System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition", "filename="& FileName &";")
						Me.OutputImage.Save(MyMemoryStream, ImageFormat.Jpeg)
					'- - - - - - - - - - - - - - - - - -'
					Case "image/png"
						System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition", "filename="& FileName &";")
						Me.OutputImage.Save(MyMemoryStream, ImageFormat.Png)
					'- - - - - - - - - - - - - - - - - -'
					Case Else
						System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition", "filename="& FileName &";")
						Me.OutputImage.Save(MyMemoryStream, ImageFormat.Jpeg)
				End Select
				
				'set content type and write stream to the current Response.OutputStream
				System.Web.HttpContext.Current.Response.ContentType = Me.ContentType
				MyMemoryStream.WriteTo(System.Web.HttpContext.Current.Response.OutputStream)
				System.Web.HttpContext.Current.Response.End()
			End Sub
		'/<-- End Method :: SaveHTTP
		
		'/##################################################################################
		
		'/--> Begin Method :: LoadImageFromFile
			Public Function LoadImageFromFile(FilePath As String) As System.Drawing.Image
				Dim VirtualImage As System.Drawing.Image = Nothing
				Using myFileStream As FileStream = New FileStream(FilePath, FileMode.Open, FileAccess.Read)
					Dim ImageBytes(myFileStream.Length) As Byte
					myFileStream.Read(ImageBytes, 0, ImageBytes.Length)
					myFileStream.Close()
					VirtualImage = System.Drawing.Image.FromStream(New MemoryStream(ImageBytes))
					ImageBytes = Nothing
				End Using
				GC.Collect()
				Return VirtualImage
			End Function
		'/<-- End Method :: LoadImageFromFile
	End Class
'/<-- End Class :: Imager

'/##########################################################################################
</script>