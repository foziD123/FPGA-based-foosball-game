// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	players_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	Y_up,  //change the direction in Y to up  
					input logic Y_down,
					input	logic	pressed, 	//toggle the X direction 
					input logic collision_edge,  //collision if smiley hits an object
					input logic collision_ball,
					input logic second,
					input	logic	[3:0] HitEdgeCode, //one bit per edge 
					
					
					output	 logic kick,
					//output	 logic flipped,
					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 40;
parameter int INITIAL_Y = 0;
parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED = 150;
parameter int MAX_Y_SPEED = 230;
const int  Y_ACCEL = -1;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30 * FIXED_POINT_MULTIPLIER;
const int   OBJECT_WIDTH_X = 64;

int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;

logic flag;



//////////--------------------------------------------------------------------------------------------------------------=
//  calculation 0f Y Axis speed using gravity or colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed	<= 0;
		topLeftY_FixedPoint <= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		topLeftX_FixedPoint <= INITIAL_X * FIXED_POINT_MULTIPLIER;
		//kick <= 1'b0;
		//flipped <= 1'b0;
	end 
	else begin
	
			
			if(pressed) begin
				if(collision_ball && HitEdgeCode[1])
					kick <= 1'b1;
			end
			
				
			if(second)
				kick <= 1'b0;
				
			if (collision_edge == 1'b1) begin  
				if (Yspeed < 0 && HitEdgeCode[2])
					Yspeed <= 0;
					
				if(Yspeed > 0 && HitEdgeCode[0])
					Yspeed <= 0;
				
			end
				
			if (startOfFrame == 1'b1) begin 
				
				topLeftY_FixedPoint <= topLeftY_FixedPoint + Yspeed;
				Yspeed <= 0;
				if (Y_up)  begin 
					Yspeed <= -INITIAL_Y_SPEED; 
				end
		
				if (Y_down) begin
					Yspeed <= INITIAL_Y_SPEED;
			end
		end

	end
end 



//////////--------------------------------------------------------------------------------------------------------------=

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
