/* Verilog netlist generated by SCUBA Diamond (64-bit) 3.10.0.111.2 */
/* Module Version: 7.5 */
/* /opt/diamond/3.10_x64/ispfpga/bin/lin64/scuba -w -n ram_readfirst_regout_9x1024 -lang verilog -synth lse -bus_exp 7 -bb -arch xo2c00 -type bram -wp 11 -rp 1010 -data_width 9 -rdata_width 9 -num_rows 1024 -outdataA REGISTERED -outdataB REGISTERED -cascade -1 -resetmode SYNC -sync_reset -mem_init0 -writemodeA READBEFOREWRITE -writemodeB READBEFOREWRITE  */
/* Thu Mar 29 15:04:09 2018 */


`timescale 1 ns / 1 ps
module ram_readfirst_regout_9x1024 (DataInA, DataInB, AddressA, AddressB, 
    ClockA, ClockB, ClockEnA, ClockEnB, WrA, WrB, ResetA, ResetB, QA, QB)/* synthesis NGD_DRC_MASK=1 */;
    input wire [8:0] DataInA;
    input wire [8:0] DataInB;
    input wire [9:0] AddressA;
    input wire [9:0] AddressB;
    input wire ClockA;
    input wire ClockB;
    input wire ClockEnA;
    input wire ClockEnB;
    input wire WrA;
    input wire WrB;
    input wire ResetA;
    input wire ResetB;
    output wire [8:0] QA;
    output wire [8:0] QB;

    wire scuba_vlo;
    wire scuba_vhi;

    VLO scuba_vlo_inst (.Z(scuba_vlo));

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    defparam ram_readfirst_regout_9x1024_0_0_0.INIT_DATA = "STATIC" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.ASYNC_RESET_RELEASE = "SYNC" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_1F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_1E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_1D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_1C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_1B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_1A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_19 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_18 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_17 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_16 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_15 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_14 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_13 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_12 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_11 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_10 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_0F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_0E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_0D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_0C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_0B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_0A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_09 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_08 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_07 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_06 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_05 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_04 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_03 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_02 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_01 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.INITVAL_00 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.CSDECODE_B = "0b000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.CSDECODE_A = "0b000" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.WRITEMODE_B = "READBEFOREWRITE" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.WRITEMODE_A = "READBEFOREWRITE" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.GSR = "ENABLED" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.RESETMODE = "SYNC" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.REGMODE_B = "OUTREG" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.REGMODE_A = "OUTREG" ;
    defparam ram_readfirst_regout_9x1024_0_0_0.DATA_WIDTH_B = 9 ;
    defparam ram_readfirst_regout_9x1024_0_0_0.DATA_WIDTH_A = 9 ;
    DP8KC ram_readfirst_regout_9x1024_0_0_0 (.DIA8(DataInA[8]), .DIA7(DataInA[7]), 
        .DIA6(DataInA[6]), .DIA5(DataInA[5]), .DIA4(DataInA[4]), .DIA3(DataInA[3]), 
        .DIA2(DataInA[2]), .DIA1(DataInA[1]), .DIA0(DataInA[0]), .ADA12(AddressA[9]), 
        .ADA11(AddressA[8]), .ADA10(AddressA[7]), .ADA9(AddressA[6]), .ADA8(AddressA[5]), 
        .ADA7(AddressA[4]), .ADA6(AddressA[3]), .ADA5(AddressA[2]), .ADA4(AddressA[1]), 
        .ADA3(AddressA[0]), .ADA2(scuba_vlo), .ADA1(scuba_vlo), .ADA0(scuba_vhi), 
        .CEA(ClockEnA), .OCEA(ClockEnA), .CLKA(ClockA), .WEA(WrA), .CSA2(scuba_vlo), 
        .CSA1(scuba_vlo), .CSA0(scuba_vlo), .RSTA(ResetA), .DIB8(DataInB[8]), 
        .DIB7(DataInB[7]), .DIB6(DataInB[6]), .DIB5(DataInB[5]), .DIB4(DataInB[4]), 
        .DIB3(DataInB[3]), .DIB2(DataInB[2]), .DIB1(DataInB[1]), .DIB0(DataInB[0]), 
        .ADB12(AddressB[9]), .ADB11(AddressB[8]), .ADB10(AddressB[7]), .ADB9(AddressB[6]), 
        .ADB8(AddressB[5]), .ADB7(AddressB[4]), .ADB6(AddressB[3]), .ADB5(AddressB[2]), 
        .ADB4(AddressB[1]), .ADB3(AddressB[0]), .ADB2(scuba_vlo), .ADB1(scuba_vlo), 
        .ADB0(scuba_vhi), .CEB(ClockEnB), .OCEB(ClockEnB), .CLKB(ClockB), 
        .WEB(WrB), .CSB2(scuba_vlo), .CSB1(scuba_vlo), .CSB0(scuba_vlo), 
        .RSTB(ResetB), .DOA8(QA[8]), .DOA7(QA[7]), .DOA6(QA[6]), .DOA5(QA[5]), 
        .DOA4(QA[4]), .DOA3(QA[3]), .DOA2(QA[2]), .DOA1(QA[1]), .DOA0(QA[0]), 
        .DOB8(QB[8]), .DOB7(QB[7]), .DOB6(QB[6]), .DOB5(QB[5]), .DOB4(QB[4]), 
        .DOB3(QB[3]), .DOB2(QB[2]), .DOB1(QB[1]), .DOB0(QB[0]))
             /* synthesis MEM_LPC_FILE="ram_readfirst_regout_9x1024.lpc" */
             /* synthesis MEM_INIT_FILE="INIT_ALL_0s" */;



    // exemplar begin
    // exemplar attribute ram_readfirst_regout_9x1024_0_0_0 MEM_LPC_FILE ram_readfirst_regout_9x1024.lpc
    // exemplar attribute ram_readfirst_regout_9x1024_0_0_0 MEM_INIT_FILE INIT_ALL_0s
    // exemplar end

endmodule
