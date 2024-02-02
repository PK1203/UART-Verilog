// AstroTinker Bot : Task 2A : UART Receiver
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to receive UART Rx data packet from receiver line and then update the rx_msg and rx_complete data lines.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Receiver

Input:  clk_50M - 50 MHz clock
        rx      - UART Receiver

Output: rx_msg      - read incoming message
        rx_complete - message received flag
*/

// module declaration
module uart_rx (
  input clk_50M, rx,
  output reg [7:0] rx_msg,
  output reg rx_complete
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

////////////////////////// Add your code here


initial begin

rx_msg = 0; rx_complete = 0;

end

reg[1:0] state=2'b00;
reg[24:0] counter=0;
reg[3:0] bitpos=7;
reg[7:0] dataset=0;

parameter IDLE=2'b00;
parameter START_BIT=2'b01;
parameter DATA=2'b10;
parameter STOP_BIT=2'b11;

reg flag=0;
reg flag1=0;

always @(posedge clk_50M) begin
	case(state)
		IDLE: begin
			if(flag1==1) begin
				rx_msg<=dataset;
				rx_complete<=1;
				flag1<=0;
				end
			else begin
				rx_msg<=dataset;
				rx_complete<=0;
				end
				
			if(rx==0) state<=START_BIT;
			else state<=IDLE;
			end
		START_BIT: begin
			rx_msg<=dataset;
			rx_complete<=0;
			if(counter<432) begin
				counter<=counter+1;
			end
			else begin
				counter<=0;
				state<=DATA;
				dataset<=0;
				flag<=1;
				end
			end
		DATA: begin
			dataset[bitpos]<=rx;
			if(counter<433) begin
				counter<=counter+1;
			end
			else begin
				if(bitpos==0) state<=STOP_BIT;
				else begin
					bitpos<=bitpos-1;
				end
				counter<=0;
			end
		end
		STOP_BIT: begin
			if(counter<433) counter<=counter+1;
			else begin
				rx_complete<=0;
				bitpos<=7;
				counter<=0;
				state<=IDLE;
				flag1<=1;
				end
		end
	endcase
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule