module sound_selector (

	input clk,
	input resetN,

	input logic [2:0] selector,
	input logic second,
	input logic goal,
	
	output logic [3:0] frequency,
	output logic enable
	);
	
	
	
	
enum logic [5:0] {s_idle, s_vic0, s_vic1, s_vic2, s_vic3, s_vic4, s_vic5, s_loss0, s_loss1, s_loss2, s_draw0, s_draw1, s_draw2, s_draw3, s_end} state_ps, state_ns;

always @(posedge clk or negedge resetN ) begin 

	if ( !resetN ) begin
		state_ps <= s_idle;
	end
	else begin
		state_ps <= state_ns;
	end
	
end 



always_comb begin

	state_ns = state_ps;
	frequency = 4'b0000;
	enable = 1'b0;
	
	case(state_ps) 
	
		s_idle: begin 
		
			frequency = 4'b0000;
			enable = 1'b0;
			
			if(selector == 3'b000) begin 
				state_ns = s_vic0;
			end
			
			if (selector == 3'b001) begin
				state_ns = s_loss0;
			end
			
			if (selector == 3'b010) begin
				state_ns = s_draw0;
			end
			
			/*
			if (goal) begin
				state_ns = s_goal0;
			end
			*/
		end //s_idle
		
		s_vic0: begin 
			
			frequency = 4'h9;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_vic1;
			end
			
		end // vic0
		
		s_vic1: begin 
			
			frequency = 4'h2;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_vic2;
			end

		end // vic1
		
		s_vic2: begin 
			
			frequency = 4'h6;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_vic3;
			end
		
		end // vic2
		
		s_vic3: begin 
			
			frequency = 4'h9;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_vic4;
			end
				
		end // vic3
		
		s_vic4: begin 
			
			frequency = 4'h6;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_vic5;
			end
				
		end // vic4
		
		s_vic5: begin 
			
			frequency = 4'h2;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_end;
			end
				
		end // vic5
		
		s_loss0: begin 
			frequency = 4'h5;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_loss1;
			end
						
		end //loss0
		
		s_loss1: begin 
			frequency = 4'h6;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_loss2;
			end
						
		end //loss1
		
		s_loss2: begin 
			frequency = 4'h7;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_end;
			end
						
		end //loss2
		
		s_draw0: begin 
			frequency = 4'h0;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_draw1;
			end
			
		end
		
		s_draw1: begin 
			frequency = 4'h5;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_draw2;
			end
						
		end 
		
		s_draw2: begin 
			frequency = 4'h10;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_draw3;
			end
						
		end 
		
		s_draw3: begin 
			
			frequency = 4'h0;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_end;
			end
				
		end
		
		s_end: begin 
			enable = 1'b0;
			state_ns = s_end;
		end //end
			
			
	endcase

end

endmodule

/*
		s_goal0: begin
	
			frequency = 4'h0;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_goal0;
			end
						
		end// s_goal0
		
		s_goal1: begin
			
			frequency = 4'h7;
			enable = 1'b1;
			
			if(second) begin
				state_ns = s_endGoal;
			end
			
		end// s_goal1
		
		s_endGoal: begin
			
			enable = 1'b0;
			state_ns = s_idle;
			
		end
		*/








