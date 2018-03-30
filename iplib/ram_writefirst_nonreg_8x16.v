/* Verilog netlist generated by SCUBA Diamond (64-bit) 3.10.0.111.2 */
/* Module Version: 3.9 */
/* /opt/diamond/3.10_x64/ispfpga/bin/lin64/scuba -w -n ram_writefirst_nonreg_8x16 -lang verilog -synth lse -bus_exp 7 -bb -arch xo2c00 -type sdpram -rdata_width 8 -data_width 8 -num_rows 16 -outData UNREGISTERED  */
/* Thu Mar 29 23:26:25 2018 */


`timescale 1 ns / 1 ps
module ram_writefirst_nonreg_8x16 (WrAddress, Data, WrClock, WE, 
    WrClockEn, RdAddress, Q)/* synthesis NGD_DRC_MASK=1 */;
    input wire [3:0] WrAddress;
    input wire [7:0] Data;
    input wire WrClock;
    input wire WE;
    input wire WrClockEn;
    input wire [3:0] RdAddress;
    output wire [7:0] Q;

    wire scuba_vhi;
    wire dec0_wre3;

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    defparam LUT4_0.initval =  16'h8000 ;
    ROM16X1A LUT4_0 (.AD3(WE), .AD2(WrClockEn), .AD1(scuba_vhi), .AD0(scuba_vhi), 
        .DO0(dec0_wre3));

    defparam mem_0_0.initval = "0x0000000000000000" ;
    DPR16X4C mem_0_0 (.DI0(Data[4]), .DI1(Data[5]), .DI2(Data[6]), .DI3(Data[7]), 
        .WCK(WrClock), .WRE(dec0_wre3), .RAD0(RdAddress[0]), .RAD1(RdAddress[1]), 
        .RAD2(RdAddress[2]), .RAD3(RdAddress[3]), .WAD0(WrAddress[0]), .WAD1(WrAddress[1]), 
        .WAD2(WrAddress[2]), .WAD3(WrAddress[3]), .DO0(Q[4]), .DO1(Q[5]), 
        .DO2(Q[6]), .DO3(Q[7]))
             /* synthesis MEM_INIT_FILE="(0-15)(0-3)" */
             /* synthesis MEM_LPC_FILE="ram_writefirst_nonreg_8x16.lpc" */
             /* synthesis COMP="mem_0_0" */;

    defparam mem_0_1.initval = "0x0000000000000000" ;
    DPR16X4C mem_0_1 (.DI0(Data[0]), .DI1(Data[1]), .DI2(Data[2]), .DI3(Data[3]), 
        .WCK(WrClock), .WRE(dec0_wre3), .RAD0(RdAddress[0]), .RAD1(RdAddress[1]), 
        .RAD2(RdAddress[2]), .RAD3(RdAddress[3]), .WAD0(WrAddress[0]), .WAD1(WrAddress[1]), 
        .WAD2(WrAddress[2]), .WAD3(WrAddress[3]), .DO0(Q[0]), .DO1(Q[1]), 
        .DO2(Q[2]), .DO3(Q[3]))
             /* synthesis MEM_INIT_FILE="(0-15)(4-7)" */
             /* synthesis MEM_LPC_FILE="ram_writefirst_nonreg_8x16.lpc" */
             /* synthesis COMP="mem_0_1" */;



    // exemplar begin
    // exemplar attribute mem_0_0 MEM_INIT_FILE (0-15)(0-3)
    // exemplar attribute mem_0_0 MEM_LPC_FILE ram_writefirst_nonreg_8x16.lpc
    // exemplar attribute mem_0_0 COMP mem_0_0
    // exemplar attribute mem_0_1 MEM_INIT_FILE (0-15)(4-7)
    // exemplar attribute mem_0_1 MEM_LPC_FILE ram_writefirst_nonreg_8x16.lpc
    // exemplar attribute mem_0_1 COMP mem_0_1
    // exemplar end

endmodule
