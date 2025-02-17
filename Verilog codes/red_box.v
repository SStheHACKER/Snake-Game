`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2025 11:54:27
// Design Name: 
// Module Name: red_box
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module red_box(
input clk,
input reset,restart,lengthincrease,
input right,left,down,up,
output h_sync,v_sync,
output[11:0] red_colour
    );
    
    parameter r=0,u=1,d=2,l=3;
    parameter box_size = 5;
    parameter max_length = 50;
    
    
    reg[1:0] current_state;
    wire h_disp,v_disp;
    wire[10:0] h_loc;
    wire [9:0]v_loc;
    reg[11:0] red_colour_reg;
    reg[24:0] counter;
//    reg[10:0] initial_hloc;
//    reg[9:0] initial_vloc;

    reg [10:0] snake_x[0:max_length-1];
    reg [9:0] snake_y[0:max_length-1];
    reg [5:0] snake_length;
    
    reg lengthincrease_sync0,lengthincrease_sync1;
    reg lengthincrease_flag;
 
    clk_wiz_0 inst1(.clk_in1(clk),.reset(reset),.clk_out1(clk_100MHz),.clk_out2(clk_40MHz),.locked(locked));
    display inst2(.clk(clk_40MHz),.reset(reset),.h_sync(h_sync),.v_sync(v_sync),.v_disp(v_disp),.h_disp(h_disp),.v_loc(v_loc),.h_loc(h_loc));
    
    integer i;
    always @(posedge clk_100MHz) begin
    
        lengthincrease_sync0 <= lengthincrease;
        lengthincrease_sync1 <= lengthincrease_sync1;
        
        if(lengthincrease_sync0 && ~lengthincrease_sync1)
            lengthincrease_flag <= 1'b1;
        
        if(reset || restart) begin
            counter <= 25'b0;
            current_state <= r;
            snake_length <= 6'b1;
            //red_colour_reg <= 12'b000011110000; // Reset color
            snake_x[0] <= 11'b00110001100;   // Initial location
            snake_y[0] <= 10'b0100101000;    
            lengthincrease_flag <= 1'b0;        
            //red_colour_reg <= 12'b000011110000;
        end else
        begin
            case(current_state)
                r:
                begin
                    if(up)
                        current_state <= u;
                    else if(down)
                        current_state <= d;
                    else
                        current_state <= r;
                      
                    /*if(counter == 25'b1110010011100001110000000) begin
                        if(initial_hloc < 11'b01100100000) begin
                            initial_hloc = initial_hloc + 3'b101;
                            initial_vloc = initial_vloc;
                        end else
                        begin
                            red_colour_reg = 12'b000000001111;
                        end
                    end */
                end
                l:
                begin
                    if(up)
                        current_state <= u;
                    else if(down)
                        current_state <= d;
                    else
                        current_state <= l;
                        
                    /*if(counter == 25'b1110010011100001110000000) begin
                        if(initial_hloc > 11'b0) begin
                            initial_hloc = initial_hloc - 3'b101;
                            initial_vloc = initial_vloc;
                        end else
                        begin
                            red_colour_reg = 12'b000000001111;
                        end 
                    end*/
                end
                u:
                begin
                    if(right)
                        current_state <= r;
                    else if(left)
                        current_state <= l;
                    else
                        current_state <= u;
                        
                    /*if(counter == 25'b1110010011100001110000000) begin
                        if(v_loc > 10'b0) begin
                            initial_vloc = initial_vloc - 3'b101;
                            initial_hloc = initial_hloc;
                        end else
                        begin
                            red_colour_reg = 12'b000000001111;
                        end 
                    end*/
                end
                
                
                d:
                begin
                    if(right)
                        current_state <= r;
                    else if(left)
                        current_state <= l;
                    else
                        current_state <= d;
                    
                    /*if(counter == 25'b1110010011100001110000000) begin
                        if(v_loc < 10'b1001011000) begin
                            initial_vloc = initial_vloc + 3'b101;
                            initial_hloc = initial_hloc;
                        end else
                        begin
                            red_colour_reg = 12'b000000001111;
                        end
                    end*/
                end
                default: current_state <= r;
            endcase
            if(counter > 25'b1110010011100001110000000) begin
                counter <= 25'b0;
                
                for (i = max_length - 1; i > 0; i = i - 1) begin
                        if (i < snake_length)
                            begin
                                snake_x[i] <= snake_x[i-1];
                                snake_y[i] <= snake_y[i-1];
                            end
                end

                 
                case(current_state)
                    r:
                    begin
                        if(snake_x[0] <= 11'b01100100000)
                            snake_x[0] <= snake_x[0] + box_size;
                    end
                    l:
                    begin
                        if(snake_x[0] >= box_size)
                            snake_x[0] <= snake_x[0] - box_size;
                    end
                    u:
                    begin
                        if(snake_y[0] >= box_size)
                            snake_y[0] <= snake_y[0] - box_size;
                    end
                    d:
                    begin
                        if(snake_y[0] <= 10'b1001011000)
                            snake_y[0] <= snake_y[0] + box_size;
                    end
                endcase
                
                if(lengthincrease_flag && (snake_length < max_length)) begin
                    snake_x[snake_length] <= snake_x[snake_length-1];
                    snake_y[snake_length] <= snake_y[snake_length-1];
                    snake_length <= snake_length + 1;
                end
                
                lengthincrease_flag <= 1'b0;
            end      
            else
                counter <= counter + 1'b1;
        end
    end
    
    integer j;
    reg snake_appear;
    always @(*) begin
        snake_appear = 1'b0;
        if(h_disp && v_disp) begin
            for(j=0;j<snake_length;j=j+1) begin
                if((h_loc <= snake_x[j] && h_loc > snake_x[j] - box_size) && (v_loc <= snake_y[j] && v_loc > snake_y[j] - box_size))
                    snake_appear = 1'b1;
            end
            
            if(snake_appear)
                red_colour_reg =12'b111100000000;
            else
                red_colour_reg = 12'b000011110000;
                
            if(snake_x[0] > 11'b01100100000 || snake_x[0] < box_size || snake_y[0] > 10'b1001011000 || snake_y[0] < box_size)
                red_colour_reg = 12'b000000001111;                
        end
        
        else
            red_colour_reg = 12'b000000000000;
    end
    
    assign red_colour = (h_disp && v_disp)?red_colour_reg:12'b0; 
endmodule