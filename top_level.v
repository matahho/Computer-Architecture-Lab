module TopLevel(
    input clock, rst
    );
	 
	 
    wire clk;
    assign clk = clock;

    
    // IF
    wire [31:0] pcOutIf, instOutIf;
    // IF-ID
    wire [31:0] pcOutIfId, instOutIfId;

	 
	// IF stage  
	StageIf stageIf(
    .clk(clock), .rst(rst),
    .branchTaken(1'b0),
	 .freeze(1'b0),
    .branchAddr(32'b0),
    .pc(pcOutIf),
	 .instruction(instOutIf)
	);
	
	// regs between If & Id
	RegsIfId regsIf(
		.clk(clock), .rst(rst),
		.freeze(1'b0),
		.flush(1'b1),
		.pcIn(pcOutif), .instructionIn(instoutIf),
		.pcOut(pcOutIfId) , .instructionOut(instOutIfId)
	
	);
	
	
	 
endmodule
