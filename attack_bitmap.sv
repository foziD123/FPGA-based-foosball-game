// HartsMatrixBitMap File 
// A two level bitmap. dosplaying harts on the screen FWbruary  2021  
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	attack_bitmap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic random_hart,

					output	logic	[3:0] HitEdgeCode,
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;
 

// Size represented as Number of X and Y bits 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00 ;// RGB value in the bitmap representing a transparent pixel 
 /*  end generated by the tool */

 logic [0:3] [0:3] [3:0] hit_colors = 
		   {16'hC446,     
			16'h8C62,    
			16'h8932, 
			16'h9113}; 

// the screen is 640*480  or  20 * 15 squares of 32*32  bits ,  we wiil round up to 32*16 and use only the top left 20*15 pixels  
// this is the bitmap  of the maze , if there is a one  the na whole 32*32 rectange will be drawn on the screen 
// all numbers here are hard coded to simplify the  understanding 


logic [0:15] [0:15]  MazeBiMapMask= 
{16'b	0000000000000000,
16'b	0000000000000000,
16'b	0000000000000000,
16'b	0000000000100000,
16'b	0000000000000000,
16'b	0000000000000000,
16'b	0000000000000000,
16'b	0000000000100000,
16'b	0000000000000000,
16'b	0000000000000000,
16'b	0000000000000000,
16'b	0000000000100000,
16'b	0000000000000000,
16'b	0000000000000000,
16'b	0000000000000000,
16'b	0000000000000000};
 
 
 logic [0:1] [0:31] [0:31] [7:0]  object_colors  = 
 
 
 
{
	{
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h89,8'h92,8'hdb,8'hdb,8'hdb,8'h92,8'h51,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h89,8'h92,8'hdb,8'hdb,8'hdb,8'h92,8'h51,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h92,8'hdb,8'hdb,8'hdb,8'h92,8'h51,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h89,8'h0b,8'hdb,8'hdb,8'h0b,8'h0b,8'h51,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h9a,8'hd1,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h9a,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'hdb,8'hdb,8'h9a,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h51,8'h28,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h51,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h28,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h51,8'h88,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h51,8'h80,8'h28,8'h28,8'h28,8'h28,8'h28,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h09,8'h08,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h89,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h08,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h89,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h49,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h89,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h89,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h40,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h89,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h08,8'h08,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h40,8'h80,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'h40,8'h28,8'h40,8'h40,8'h80,8'h80,8'h80,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h49,8'h80,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h51,8'h88,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h88,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'h88,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h89,8'h88,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h49,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'hd1,8'h0b,8'h28,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h92,8'h89,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'hdb,8'hdb,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h92,8'h89,8'h80,8'h80,8'h0b,8'h0b,8'h0b,8'h0b,8'h88,8'h28,8'h9a,8'h9a,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h09,8'h49,8'h89,8'h28,8'h92,8'hd3,8'h0b,8'h28,8'h49,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h49,8'h28,8'h92,8'hdb,8'hdb,8'hdb,8'h92,8'h09,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h92,8'hdb,8'hdb,8'hdb,8'h92,8'h09,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h92,8'hdb,8'hdb,8'hdb,8'h92,8'h09,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h92,8'hdb,8'hdb,8'hdb,8'h92,8'h49,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h92,8'hdb,8'hdb,8'hdb,8'h92,8'h49,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00}
	},
	{
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h28,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h28,8'h28,8'h28,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h28,8'h28,8'h28,8'h28,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h49,8'h4a,8'h49,8'h49,8'h0b,8'h28,8'h28,8'h28,8'h28,8'h49,8'h49,8'h4a,8'h4a,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h49,8'h49,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h4a,8'h0b,8'h0b,8'h49,8'h89,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h89,8'h49,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h49,8'h48,8'h89,8'h89,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h92,8'h28,8'h28,8'h00,8'h00,8'h00,8'h00,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h48,8'h28,8'h89,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h49,8'h28,8'h89,8'h00,8'h00,8'h00,8'h00,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h49,8'h28,8'h28,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h89,8'h28,8'h00,8'h00,8'h00,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h28,8'h49,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h28,8'h28,8'h00,8'h00,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h28,8'h89,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h89,8'h28,8'h00,8'h00,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h49,8'h49,8'h89,8'h49,8'h40,8'h48,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h0b,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h92,8'h92,8'h0b,8'h0b,8'h0b,8'h0b,8'h92,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h92,8'h92,8'h92,8'h00,8'h00,8'h92,8'h92,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h40,8'h40,8'h48,8'h00,8'h00,8'h40,8'h40,8'h40,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'h40,8'h40,8'h00,8'h00,8'h40,8'h40,8'h49,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'h40,8'h40,8'h00,8'h00,8'h40,8'h40,8'hd3,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'h40,8'h40,8'h00,8'h00,8'h40,8'h40,8'h48,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h48,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h49,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00}
	}

};
 

// pipeline (ff) to get the pixel color from the array 	 

//==----------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
		HitEdgeCode <= 4'h0; 

	end
	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default 
		HitEdgeCode <= 4'h0; 


		if ((InsideRectangle == 1'b1)		& 	// only if inside the external bracket 
		   (MazeBiMapMask[offsetY[8:5] ][offsetX[8:5]] == 1'b1)) // take bits 5,6,7,8,9,10 from address to select  position in the maze 
			begin
					HitEdgeCode <= hit_colors[offsetY >> 3][offsetX >> 3];
					
					if(random_hart == 0)
							RGBout <= object_colors[random_hart][offsetY][offsetX]; 
					else
							RGBout <= object_colors[random_hart][offsetX][offsetY]; 
				end
		end 
end

//==----------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   
endmodule

