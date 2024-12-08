module sreg_piso_9_bit
    #(parameter WIDTH=9) (
        input clk, rst, load,
        input [WIDTH-1:0] in_parallel,
        output out_serial
    );

    reg [WIDTH-1:0] sreg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sreg <= 1'b0;
        end else if (load) begin
            sreg <= in_parallel;
        end else begin
            sreg <= {1'b0, sreg[WIDTH-1:1]};
        end
    end

    assign out_serial = sreg[0];
endmodule