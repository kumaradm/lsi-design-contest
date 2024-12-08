module sreg_sipo_9x16_bit
    #(parameter N_IN=9,
        parameter WIDTH=16) (
        input clk, rst, load,
        input [WIDTH-1:0] in_serial,
        input [N_IN*WIDTH-1:0] in_parallel, // 9 * 16-bit parallel input (144 bits total)
        output reg [N_IN*WIDTH-1:0] out_parallel // 9 * 16-bit parallel output (144 bits total)
    );

    // Internal register to store 9 16-bit values (144 bits total)
    reg [N_IN*WIDTH-1:0] sreg;    // 9 16-bit registers (144 bits total)

    // Shift register operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sreg <= 144'b0;
            out_parallel <= 144'b0;
        end else if (load) begin
            out_parallel <= sreg;
        end else begin
            sreg <= {sreg[N_IN*WIDTH-WIDTH-1:0], in_serial[WIDTH-1:0]}; // Shift left and load in_serial
        end
    end

endmodule
