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
	WebLegs.Imager = function(Value) {
		this.BackgroundColor = "#000000";
		this.OutputImage;
		this.ContentType;
		this.ImageName;
		this.Canvas;
		this.FilePath;
		
		if(Value instanceof Image){
			this.OutputImage = Value;
		}
		else if(Value != undefined){
			this.FilePath = Value;
			this.OutputImage = new Image();
			this.OutputImage.src = Value; 
		}
	};
//<-- End Method :: Constructor

//##########################################################################################

//--> Begin Method :: Load
	WebLegs.Imager.prototype.Load = function(Value) {
		if(Value instanceof Image){
			this.OutputImage = Value;
		}
		else if(Value != undefined){
			this.FilePath = Value;
			this.OutputImage = new Image();
			this.OutputImage.src = Value; 
		}
	};
//<-- End Method :: Load

//##########################################################################################

//--> Begin Method :: Constrain
	WebLegs.Imager.prototype.Constrain = function(Height, Width) {	
		//original height and width
		var SourceWidth =  this.GetWidth();
		var SourceHeight = this.GetHeight();
		
		//shrink calculations
			//calculation containers
			var ShrinkPercentage = 0;
			var ShrinkPercentageW = 0;
			var ShrinkPercentageH = 0;
			
			//calculate height and width percentages
			ShrinkPercentageH = (Height / SourceHeight);
			ShrinkPercentageW = (Width / SourceWidth);
			
			//if we have to pad the image, pad evenly on top/bottom or left/right
			if(ShrinkPercentageH < ShrinkPercentageW) {
				ShrinkPercentage = ShrinkPercentageH;
			}
			else {
				ShrinkPercentage = ShrinkPercentageW;
			}
		//end shrink percentages
		
		//output height and width
		var OutputWidth  = (SourceWidth * ShrinkPercentage);
		var OutputHeight = (SourceHeight * ShrinkPercentage);
		
		//adjust dimensions so that one dimension always matches the dimensions passed in
		var DifferencePercent = 0;
		var DifferenceWidth = Width - OutputWidth;
		var DifferenceHeight = Height - OutputHeight;

		//use the dimension that needs to be asdjusted by the least pixels
		if(DifferenceHeight < DifferenceWidth){
			DifferencePercent = Height / OutputHeight;
		}
		else{
			DifferencePercent = Width / OutputWidth;
		}
	   
		//adjust both dimensions by the same percentage
		OutputWidth = (OutputWidth * DifferencePercent);
		OutputHeight = (OutputHeight * DifferencePercent);
		
		//create new canvas and context
		var Canvas = document.createElement("canvas");
		var Context = Canvas.getContext('2d');
		
		//adjust canvas height and width
		Canvas.setAttribute("height", OutputHeight +"px");
		Canvas.setAttribute("width", OutputWidth +"px");
		
		//draw on canvas
		Context.drawImage(this.OutputImage, 0, 0, SourceWidth, SourceHeight, 0, 0, OutputWidth, OutputHeight);
		
		//set canvas
		this.Canvas = Canvas;
		
		//retrun this
		return this;
	};
//<-- End Method :: Constrain

//##########################################################################################

//--> Begin Method :: ConstrainHeight
	WebLegs.Imager.prototype.ConstrainHeight = function(Height) {
		//original height and width
		var SourceWidth =  this.GetWidth();
		var SourceHeight = this.GetHeight();
		
		//output height and width
			var ShrinkPercentage = (Height / SourceHeight);
			var OutputWidth = (SourceWidth * ShrinkPercentage);
			var OutputHeight = (SourceHeight * ShrinkPercentage);
			
			//make the width exactly what we passed in
			if(OutputHeight < Height) {
				var Offset = Height - OutputHeight;
				OutputWidth += Offset;
				OutputHeight += Offset;
			}
		//end output height and width
		
		//create new canvas and context
		var Canvas = document.createElement("canvas");
		var Context = Canvas.getContext('2d');
		
		//adjust canvas height and width
		Canvas.setAttribute("height", OutputHeight +"px");
		Canvas.setAttribute("width", OutputWidth +"px");
		
		//draw on canvas
		Context.drawImage(this.OutputImage, 0, 0, SourceWidth, SourceHeight, 0, 0, OutputWidth, OutputHeight);
	
		//set canvas
		this.Canvas = Canvas;
		
		//retrun this
		return this;
	};
//<-- End Method :: ConstrainHeight

//##########################################################################################

//--> Begin Method :: ConstrainWidth
	WebLegs.Imager.prototype.ConstrainWidth = function(Width) {
		//original height and width
		var SourceWidth = this.GetWidth();
		var SourceHeight = this.GetHeight();
		
		//output height and width
			var ShrinkPercentage = (Width / SourceWidth);
			var OutputWidth = (SourceWidth * ShrinkPercentage);
			var OutputHeight = (SourceHeight * ShrinkPercentage);
			
			//make the width exactly what we passed in
			if(OutputWidth < Width) {
				Offset = Width - OutputWidth;
				OutputWidth += Offset;
				OutputHeight += Offset;
			}
		//end output height and width
		
		//create new canvas and context
		var Canvas = document.createElement("canvas");
		var Context = Canvas.getContext('2d');
		
		//adjust canvas height and width
		Canvas.setAttribute("height", OutputHeight +"px");
		Canvas.setAttribute("width", OutputWidth +"px");
		
		//draw on canvas
		Context.drawImage(this.OutputImage, 0, 0, SourceWidth, SourceHeight, 0, 0, OutputWidth, OutputHeight);
		
		//set canvas
		this.Canvas = Canvas;
		
		//retrun this
		return this;
	};
//<-- End Method :: ConstrainWidth

//##########################################################################################

//--> Begin Method :: ScaleByPercent
	WebLegs.Imager.prototype.ScaleByPercent = function(Percent) {
		//original height and width
		var SourceWidth = this.GetWidth();
		var SourceHeight = this.GetHeight();
		
		//output height and width
		var ShrinkPercentage = (Percent/100);
		var OutputWidth = (SourceWidth * ShrinkPercentage);
		var OutputHeight = (SourceHeight * ShrinkPercentage);
		
		//create new canvas and context
		var Canvas = document.createElement("canvas");
		var Context = Canvas.getContext('2d');
		
		//adjust canvas height and width
		Canvas.setAttribute("height", OutputHeight +"px");
		Canvas.setAttribute("width", OutputWidth +"px");
		
		//draw on canvas
		Context.drawImage(this.OutputImage, 0, 0, SourceWidth, SourceHeight, 0, 0, OutputWidth, OutputHeight);
		
		//set canvas
		this.Canvas = Canvas;
		
		//retrun this
		return this;
	};
//<-- End Method :: ScaleByPercent

//##########################################################################################

//--> Begin Method :: FixedSize
	WebLegs.Imager.prototype.FixedSize = function(Height, Width) {
		//original height and width
		var SourceWidth = this.GetWidth();
		var SourceHeight = this.GetHeight();
		
		//shrink calculations
			//output x and y coords (for padding)
			var OutputX = 0;
			var OutputY = 0; 
			
			//calculation containers
			var ShrinkPercentage = 0;
			var ShrinkPercentageW = 0;
			var ShrinkPercentageH = 0;
			
			//calculate height and width percentages
			var ShrinkPercentageH = (Height / SourceHeight);
			var ShrinkPercentageW = (Width / SourceWidth);
			
			//if we have to pad the image, pad evenly on top/bottom or left/right
			if(ShrinkPercentageH < ShrinkPercentageW) {
				var ShrinkPercentage = ShrinkPercentageH;
				OutputX = ((Width - (SourceWidth * ShrinkPercentage)) / 2);
			}
			else {
				ShrinkPercentage = ShrinkPercentageW;
				OutputY = ((Height - (SourceHeight * ShrinkPercentage)) / 2);
			}
		//end shrink percentages
		
		//output height and width
		OutputWidth  = (SourceWidth * ShrinkPercentage);
		OutputHeight = (SourceHeight * ShrinkPercentage);
		
		//create new canvas and context
		var Canvas = document.createElement("canvas");
		var Context = Canvas.getContext('2d');
		
		//adjust canvas height and width
		Canvas.setAttribute("height", Height +"px");
		Canvas.setAttribute("width", Width +"px");
		
		Canvas.style.backgroundColor = this.BackgroundColor;
		
		//draw on canvas
		Context.drawImage(this.OutputImage, 0, 0, SourceWidth, SourceHeight, OutputX, OutputY, OutputWidth, OutputHeight);
		
		//set canvas
		this.Canvas = Canvas;
		
		//retrun this
		return this;
	};
//<-- End Method :: FixedSize

//##########################################################################################

//--> Begin Method :: Crop
	WebLegs.Imager.prototype.Crop = function() {
		//emulate overloading with these argument count and vars
		var NumberOfArgs = arguments.length;
		var Args = arguments;		
		
		//argument variables
		var Height = 0;
		var Width = 0;
		var Anchor = "";
		var SourceX = 0;
		var SourceY = 0;
		
		//public void Crop(int Height, int Width, string Anchor) {
		if(NumberOfArgs == 3){
			Height = Args[0];
			Width = Args[1];
			Anchor = Args[2];
		}
		//public void Crop(int Height, int Width, int SourceX, int SourceY)
		else if(NumberOfArgs == 4){
			Height = Args[0];
			Width = Args[1];
			SourceX = Args[2];
			SourceY = Args[3];
		}
		//neither
		else{
			return;
		}
		
		//set default x y values for output image
		OutputX = 0;
		OutputY = 0;
		
		//calculate general points
		Center = (this.GetWidth() / 2);
		Middle = (this.GetHeight() / 2);
		
		//set x/y positions
		switch(Anchor) {
			//- - - - - - - - - - - - - - - - - -//
			case "top-left":
				OutputX = 0;
				OutputY = 0;
				break;
			//- - - - - - - - - - - - - - - - - -//
			case "top-center":
				OutputX = (Center - (Width / 2));
				OutputY = 0;
				break;
			//- - - - - - - - - - - - - - - - - -//
			case "top-right":
				OutputX = (this.GetWidth() - Width);
				OutputY = 0;
				break;
			//- - - - - - - - - - - - - - - - - -//
			case "middle-left":
				OutputX = 0;
				OutputY = (Middle - (Height / 2));
				break;
			//- - - - - - - - - - - - - - - - - -//
			case "middle":
				OutputX = (Center - (Width / 2));
				OutputY = (Middle - (Height / 2));
				break;
			//- - - - - - - - - - - - - - - - - -//
			case "middle-right":
				OutputX = (this.GetWidth() - Width);
				OutputY = (Middle - (Height / 2));
				break;
			//- - - - - - - - - - - - - - - - - -//
			case "bottom-left":
				OutputX = 0;
				OutputY = (this.GetHeight() - Height);
				break;
			//- - - - - - - - - - - - - - - - - -//
			case "bottom-center":
				OutputX = (Center - (Width / 2));
				OutputY = (this.GetHeight() - Height);
				break;
			//- - - - - - - - - - - - - - - - - -//
			case "bottom-right":
				OutputX = (this.GetWidth() - Width);
				OutputY = (this.GetHeight() - Height);
				break;
			//- - - - - - - - - - - - - - - - - -//
			default: 
				//do nothing
				break;
		}
		
		//create new canvas and context
		var Canvas = document.createElement("canvas");
		var Context = Canvas.getContext('2d');
		
		//adjust canvas height and width
		Canvas.setAttribute("height", Height +"px");
		Canvas.setAttribute("width", Width +"px");
		
		Canvas.style.backgroundColor = this.BackgroundColor;
		
		//draw on canvas
		Context.drawImage(this.OutputImage, SourceX, SourceY, this.GetWidth(), this.GetHeight(), OutputX, OutputY, this.GetWidth(), this.GetHeight());
			
		//set canvas
		this.Canvas = Canvas;
		
		//retrun this
		return this;
	};
//<-- End Method :: Crop

//##########################################################################################

//--> Begin Method :: GetHeight
	WebLegs.Imager.prototype.GetHeight = function() {
		return this.OutputImage.height;
	};
//<-- End Method :: GetHeight

//##########################################################################################

//--> Begin Method :: GetWidth
	WebLegs.Imager.prototype.GetWidth = function() {
		return this.OutputImage.width;
	};
//<-- End Method :: GetWidth

//##########################################################################################

//--> Begin Method :: GetCanvas
	WebLegs.Imager.prototype.GetCanvas = function() {
		return this.Canvas;
	};
//<-- End Method :: GetCanvas

//##########################################################################################