`timescale 1ns/1ns

module TopLevelTB();
    

    reg clk, rst;




    TopLevel tl(
        .clock(clk), .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        {clk, rst} = 2'b01;
        #10 rst = 1'b0;
        #30000 $stop;
    end
endmodule
