//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
//Date        : Thu Nov  2 16:48:46 2023
//Host        : Robot running 64-bit Ubuntu 22.04.3 LTS
//Command     : generate_target memory_wrapper.bd
//Design      : memory_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module memory_wrapper
   (addra_0,
    clka_0,
    dina_0,
    douta_0,
    wea_0);
  input [31:0]addra_0;
  input clka_0;
  input [31:0]dina_0;
  output [31:0]douta_0;
  input [3:0]wea_0;

  wire [31:0]addra_0;
  wire clka_0;
  wire [31:0]dina_0;
  wire [31:0]douta_0;
  wire [3:0]wea_0;

  memory memory_i
       (.addra_0(addra_0),
        .clka_0(clka_0),
        .dina_0(dina_0),
        .douta_0(douta_0),
        .wea_0(wea_0));
endmodule
