// AstroTinker Bot : Task 2A : UART Transmitter
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to generate UART Tx data packet to transmit the messages based on the input data.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Transmitter

Input:  clk_50M - 50 MHz clock
        data    - 8-bit data line to transmit
Output: tx      - UART Transmission Line
*/

// module declaration
module uart_tx(
    input  clk_50M,
    input  [7:0] data,
    output reg tx
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

initial begin
	 tx = 0;
end

////////// Add your code here ///////////////////

reg[1:0] state=2'b01;
reg[24:0] counter=0;
reg[3:0] bitpos=3'h0;

parameter IDLE=2'b00;
parameter START_BIT=2'b01;
parameter DATA=2'b10;
parameter STOP_BIT=2'b11;

always @(posedge clk_50M) begin
	case(state)
		START_BIT: begin
			tx<=0;
			if(counter<433) counter<=counter+1;
			else begin
				counter<=0;
				state<=DATA;
			end
		end
		DATA: begin
			tx<=data[bitpos];
			if(counter<433) counter<=counter+1;
			else begin
				if(bitpos==3'h7) begin
					state<=STOP_BIT;
				end
				else begin
					bitpos<=bitpos+1;
					tx<=data[bitpos];
				end
				counter<=0;
			end
		end
		STOP_BIT: begin
			tx<=1;
			if(counter<433) counter<=counter+1;
			else begin
				state<=START_BIT;
				bitpos<=0;
				counter<=0;
			end
		end
	endcase
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule