//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
//Date        : Thu Nov  2 16:48:45 2023
//Host        : Robot running 64-bit Ubuntu 22.04.3 LTS
//Command     : generate_target memory.bd
//Design      : memory
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "memory,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=memory,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "memory.hwdef" *) 
module memory
   (addra_0,
    clka_0,
    dina_0,
    douta_0,
    wea_0);
  input [31:0]addra_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLKA_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLKA_0, CLK_DOMAIN memory_clka_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clka_0;
  input [31:0]dina_0;
  output [31:0]douta_0;
  input [3:0]wea_0;

  wire [31:0]addra_0_1;
  wire [31:0]blk_mem_gen_0_douta;
  wire clka_0_1;
  wire [31:0]dina_0_1;
  wire [3:0]wea_0_1;

  assign addra_0_1 = addra_0[31:0];
  assign clka_0_1 = clka_0;
  assign dina_0_1 = dina_0[31:0];
  assign douta_0[31:0] = blk_mem_gen_0_douta;
  assign wea_0_1 = wea_0[3:0];
  memory_blk_mem_gen_0_0 blk_mem_gen_0
       (.addra(addra_0_1),
        .clka(clka_0_1),
        .dina(dina_0_1),
        .douta(blk_mem_gen_0_douta),
        .wea(wea_0_1));
endmodule
