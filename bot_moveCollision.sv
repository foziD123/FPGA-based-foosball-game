// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	bot_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic collision,  //collision if ball hits an object
					
					input logic collision1, //coll with ball
					
					input logic second,
					
					input	logic	[3:0] HitEdgeCode, //one bit per edge 
					input logic [10:0] ballTLX,
					input logic [10:0] ballTLY,
					
					output logic kick,
					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 120;
parameter int INITIAL_Y = 0;
parameter int INITIAL_Y_SPEED = 50;
parameter int MAX_Y_SPEED = 230;

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

const int line1 = 162 * FIXED_POINT_MULTIPLIER;
const int line2 = 318 * FIXED_POINT_MULTIPLIER;

int TLY ;

int topPlayerfixedY = 96 * FIXED_POINT_MULTIPLIER;
int midPlayerfixedY = 224 * FIXED_POINT_MULTIPLIER;
int bottomPlayerfixedY = 352 * FIXED_POINT_MULTIPLIER;


//////////--------------------------------------------------------------------------------------------------------------=
//  calculation 0f Y Axis speed using gravity or colision

always_ff@(posedge clk or negedge resetN)
begin
	
	if(!resetN) begin 
		Yspeed	<= 0;
		kick <= 0;
		topLeftY_FixedPoint <= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		topLeftX_FixedPoint <= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topPlayerfixedY <= 96 * FIXED_POINT_MULTIPLIER;
		midPlayerfixedY <= 224 * FIXED_POINT_MULTIPLIER;
		bottomPlayerfixedY <= 352 * FIXED_POINT_MULTIPLIER;
	
	end 
	
	else begin
						
			if (collision1 && (HitEdgeCode[0] || HitEdgeCode[2] || HitEdgeCode[3])) begin
				kick <= 1'b1;
			end
			
			if (second)
				kick <= 1'b0;
			
			if (collision == 1'b1) begin  
				
				if (Yspeed < 0 && HitEdgeCode[2])
					Yspeed <= 0;
					
				if(Yspeed > 0 && HitEdgeCode[0])
					Yspeed <= 0;
							
			end
				
			if (startOfFrame == 1'b1) begin 
				TLY <= ballTLY * FIXED_POINT_MULTIPLIER;
				topLeftY_FixedPoint <= topLeftY_FixedPoint + Yspeed;
				Yspeed <= 0;
				
				if((TLY < line1 || TLY == line1)) begin
				
					if(TLY < topPlayerfixedY ) begin
						Yspeed <= -INITIAL_Y_SPEED;
					end
					
					else begin //if(TLY > topPlayerfixedY) begin
						Yspeed <= INITIAL_Y_SPEED;
					end
					
					topPlayerfixedY <= topPlayerfixedY + Yspeed;
					midPlayerfixedY <= midPlayerfixedY + Yspeed;
					bottomPlayerfixedY <= bottomPlayerfixedY + Yspeed;
					
				end
				
				
				else if(TLY > line1 && TLY < line2) begin
				
					if(TLY < midPlayerfixedY) begin
						Yspeed <= -INITIAL_Y_SPEED;
					end
					
					else begin //if(TLY > midPlayerfixedY) begin
						Yspeed <= INITIAL_Y_SPEED;
					end
					
					topPlayerfixedY <= topPlayerfixedY + Yspeed;
					midPlayerfixedY <= midPlayerfixedY + Yspeed;
					bottomPlayerfixedY <= bottomPlayerfixedY + Yspeed;
				
				end
				
				
				else begin //if((TLY > line2 || TLY == line2)) begin
				
					if(TLY < bottomPlayerfixedY) begin
						Yspeed <= -INITIAL_Y_SPEED;
					end
					
					else begin //if(TLY > bottomPlayerfixedY) begin
						Yspeed <= INITIAL_Y_SPEED;
					end
					
					topPlayerfixedY <= topPlayerfixedY + Yspeed;
					midPlayerfixedY <= midPlayerfixedY + Yspeed;
					bottomPlayerfixedY <= bottomPlayerfixedY + Yspeed;
				
				end
			
			end
			
			

end 

end



//////////--------------------------------------------------------------------------------------------------------------=

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
