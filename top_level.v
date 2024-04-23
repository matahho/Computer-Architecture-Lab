module TopLevel(
    input clock, rst

);
    wire clk;

    assign clk = clock;


    // IF
    wire [31:0] pcOutIf, instOutIf;
    // IF-ID
    wire [31:0] pcOutIfId, instOutIfId;

    // ID
    wire [31:0] pcOutId;
    wire [3:0] aluCmdOutId;
    wire memReadOutId, memWriteOutId, wbEnOutId, branchOutId, sOutId;
    wire [31:0] reg1OutId, reg2OutId;
    wire immOutId;
    wire [11:0] shiftOperandOutId;
    wire [23:0] imm24OutId;
    wire [3:0] destOutId;
    wire [3:0] src1OutId, src2OutId;
    // ID-EX
    wire [31:0] pcOutIdEx;
    wire [3:0] aluCmdOutIdEx;
    wire memReadOutIdEx, memWriteOutIdEx, wbEnOutIdEx, branchOutIdEx, sOutIdEx;
    wire [31:0] reg1OutIdEx, reg2OutIdEx;
    wire [3:0] src1OutIdEx, src2OutIdEx;
    wire immOutIdEx;
    wire [11:0] shiftOperandOutIdEx;
    wire [23:0] imm24OutIdEx;
    wire [3:0] destOutIdEx;
    wire carryOut;

  

       // EX
    wire memReadOutEx, memWriteOutEx, wbEnOutEx;
    wire branchTaken;
    wire [31:0] branchAddr;
    wire [31:0] aluResOutEx, reg2OutEx;
    wire [3:0] destOutEx;
    wire [3:0] status; // N Z C V
    wire carryIn;
    assign carryIn = status[1];
    // EX-MEM
    wire memReadOutExMem, memWriteOutExMem, wbEnOutExMem;
    wire [31:0] aluResOutExMem, reg2OutExMem;
    wire [3:0] destOutExMem;


    StageIf stIf(
        .clk(clk), .rst(rst),
        .branchTaken(branchTaken), .freeze(hazard | ramFreeze),
        .branchAddr(branchAddr),
        .pc(pcOutIf), .instruction(instOutIf)
    );
    RegsIfId regsIf(
        .clk(clk), .rst(rst),
        .freeze(hazard | ramFreeze), .flush(branchTaken),
        .pcIn(pcOutIf), .instructionIn(instOutIf),
        .pcOut(pcOutIfId), .instructionOut(instOutIfId)
    );

    StageId stId(
        .clk(clk), .rst(rst),
        .pcIn(pcOutIfId), .inst(instOutIfId),
        .status(status),
        .wbWbEn(wbEn), .wbValue(wbValue), .wbDest(wbDest),
        .hazard(hazard),
        .pcOut(pcOutId),
        .aluCmd(aluCmdOutId), .memRead(memReadOutId), .memWrite(memWriteOutId),
        .wbEn(wbEnOutId), .branch(branchOutId), .s(sOutId),
        .val_Rn(reg1OutId), .val_Rm(reg2OutId),
        .imm(immOutId), .shiftOperand(shiftOperandOutId), .imm24(imm24OutId), .dest(destOutId),
        .src1(src1OutId), .src2(src2OutId), .hazardTwoSrc(hazardTwoSrc)
    );
    RegsIdEx regsId(
        .clk(clk), .rst(rst),
        .pcIn(pcOutId),
        .aluCmdIn(aluCmdOutId), .memReadIn(memReadOutId), .memWriteIn(memWriteOutId),
        .wbEnIn(wbEnOutId), .branchIn(branchOutId), .sIn(sOutId),
        .reg1In(reg1OutId), .reg2In(reg2OutId),
        .immIn(immOutId), .shiftOperandIn(shiftOperandOutId), .imm24In(imm24OutId), .destIn(destOutId),
        .carryIn(carryIn), .src1In(src1OutId), .src2In(src2OutId),
        .flush(branchTaken), .freeze(ramFreeze),
        .pcOut(pcOutIdEx),
        .aluCmdOut(aluCmdOutIdEx), .memReadOut(memReadOutIdEx), .memWriteOut(memWriteOutIdEx),
        .wbEnOut(wbEnOutIdEx), .branchOut(branchOutIdEx), .sOut(sOutIdEx),
        .reg1Out(reg1OutIdEx), .reg2Out(reg2OutIdEx),
        .immOut(immOutIdEx), .shiftOperandOut(shiftOperandOutIdEx), .imm24Out(imm24OutIdEx), .destOut(destOutIdEx),
        .src1Out(src1OutIdEx), .src2Out(src2OutIdEx),
        .carryOut(carryOut)
    );

    StageEx stEx(
        .clk(clk), .rst(rst),
        .wbEnIn(wbEnOutIdEx), .memREnIn(memReadOutIdEx), .memWEnIn(memWriteOutIdEx),
        .branchTakenIn(branchOutIdEx), .ldStatus(sOutIdEx), .imm(immOutIdEx), .carryIn(carryOut),
        .exeCmd(aluCmdOutIdEx), .val1(reg1OutIdEx), .valRm(reg2OutIdEx), .pc(pcOutIdEx),
        .shifterOperand(shiftOperandOutIdEx), .signedImm24(imm24OutIdEx), .dest(destOutIdEx),
        .selSrc1(selSrc1), .selSrc2(selSrc2), .valMem(aluResOutExMem), .valWb(wbValue),
        .wbEnOut(wbEnOutEx), .memREnOut(memReadOutEx), .memWEnOut(memWriteOutEx),
        .branchTakenOut(branchTaken), .aluRes(aluResOutEx), .exeValRm(reg2OutEx), .branchAddr(branchAddr),
        .exeDest(destOutEx), .status(status)
    );
    RegsExMem regsEx(
        .clk(clk), .rst(rst),
        .wbEnIn(wbEnOutEx), .memREnIn(memReadOutEx), .memWEnIn(memWriteOutEx),
        .aluResIn(aluResOutEx), .valRmIn(reg2OutEx), .destIn(destOutEx),
        .freeze(ramFreeze),
        .wbEnOut(wbEnOutExMem), .memREnOut(memReadOutExMem), .memWEnOut(memWriteOutExMem),
        .aluResOut(aluResOutExMem), .valRmOut(reg2OutExMem), .destOut(destOutExMem)
    );


endmodule
