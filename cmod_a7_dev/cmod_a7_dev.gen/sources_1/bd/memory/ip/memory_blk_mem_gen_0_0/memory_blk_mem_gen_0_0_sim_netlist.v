// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Sat Oct 28 17:42:49 2023
// Host        : LinuxBot running 64-bit Arch Linux
// Command     : write_verilog -force -mode funcsim -rename_top memory_blk_mem_gen_0_0 -prefix
//               memory_blk_mem_gen_0_0_ memory_blk_mem_gen_0_0_sim_netlist.v
// Design      : memory_blk_mem_gen_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a15tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "memory_blk_mem_gen_0_0,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module memory_blk_mem_gen_0_0
   (clka,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [3:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [31:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [31:0]addra;
  wire clka;
  wire [31:0]dina;
  wire [31:0]douta;
  wire [3:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [31:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "32" *) 
  (* C_ADDRB_WIDTH = "32" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "1" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.1437 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "NONE" *) 
  (* C_INIT_FILE_NAME = "memory_blk_mem_gen_0_0.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "4" *) 
  (* C_WEB_WIDTH = "4" *) 
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "1024" *) 
  (* C_WRITE_MODE_A = "READ_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  memory_blk_mem_gen_0_0_blk_mem_gen_v8_4_7 U0
       (.addra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,addra[11:2],1'b0,1'b0}),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[31:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[31:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web({1'b0,1'b0,1'b0,1'b0}));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2023.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jLV29U0rrfMIZhYJzdoUrPoqB9eHQ5NXmWyCdqnN3Wgm+GU4C3zthrN1m4QGiaj0thPCIynZbX+0
7yjtkv+T5ByJ6NhiofAwWseGLvPXlYu6ERAPvi4SAYpF2VUqQHtPAbPmnPubGdDRgIEpeobF7hsz
rEcpEru1pyiScUriyuo=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
vsoizVrOONWw/DhjRLEYrtRmtji+Ok63CbpSg/l9VnoKAi8tAzqRbQ57atGB2N6IGGbKHkbK2Uzh
EHgWvYZeyt4hE+bpQX91vc9PNxfjQMGzPoFD3jCWk30EmEk+AND39eWx+DhJ8xhFuucoOQ2GwyAk
B+Mjs15naPE7DvlHel8hnD4dfSdYhGKp96oozu8JeBto8aHG6poOuYkxSwaut7NCI+mabCkMxtMp
RrydgmRuTvhRTbJMyx5CxFSZTRDrS5aU1vaRlnMiqKCI7g2KY9pemYaJsFeVodBuo6IyKGynyEhs
wr+VtUhQDtaVhMkwB95WwmMoDk9F2L5Au1I+TQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
W081dPMCWhKs5YlQD7n3zvf7+PTcnb8eFWxoVs8+zHLkxDMA1klITbsfztGYvJFce8Yao5XQLLqZ
oUE5Pq2arq+zwICFUcLjdMsmP1WmL82znHOPHm83zNwrxWMloHkySAqzFbgJeHa973uZqj0M8ydc
sYmzCYVlGVjt0QX0xqA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Zpc3MmdLWaVOv+S4z2POuoyslYoAbWc+Npxq2UyQRtDwf566IId3uwAetolMAgfLo/G3ezuSOXMn
8NznS37h9XvmVrxA50SAux68P87WgkLtiUYqM3CMBKkxNlZ/TR8WzTuQyFdvzkOE9lp8HC7LXnk5
RDsnOM+su46FW7ysY01COslo9Xc7rhs6WFqx29+Xcqk8+ZMLSzaJfuwZdNmJFS3Q1vhlq3ZeYqMl
wMieB731KsPxjxp7VKNHpTbgFryC2isqc4ohBDOt52M/Bz4B/rIpFeHfZ7X3jWSiKtSuBsDN2NXf
EMjfAT248dlK7NxJ+NBNPhS5sLxTiGyQhta57A==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rPMYqnkKhJKV1wltOfDrKos9ZbucaoX3WGTuqsdLkGpcKObzslHBwlGrKtWV7bZYmS2SM+QuEMfa
CE+tCUdsSiprp+n5BuSQlJa6BJ8mlqccjoo/JLw2QEmUhyMXQ3TLGomGGoZdeTmMPXhUBAOyLPea
Ddc8mgtTN8Kpy117GOTXDKP+IKJqW01fLrPJpgEhFiJCbyElLgtCRWmI94gX+y4XNVS0Cd1YwNw6
4nHgnEdC7fXARDKcYO3VsWC/pdzPQgursXloNLrVYa6i2xr+8E1V0+nSWwNYQZP7XUIVqXKMU8Ea
bT4acXrRCF/5tJJ5B9JparYI0zxXSbaakn1dIw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mfroTgL8g2pyIXQ/mGO9YHm19cd5mOlJ++qpusOYeVxGmkIhvF4aKx+AyIUz2yGGAeCtOzIasHty
pyqKgZhibSqxcpHgR0m6GOxXXOXJiHaK8NzxUzXeRJovcBI/WjtDhXeb1LRMI1J97jVBtJPJQH0Y
fGOD7jWvkvQwxnrZdyLp6kPWgSIcavHHDbO7iJv4gnyGp6W3/FCDo2RKWNLoW+SNjSdLZ6YRP8a+
ldaGU8TYvJ03KWlmik7repuN6AwxCjg2KeQ+x1sBAEXzROXomuSbvX3ZAo8UiIKAQY1SJumHLG3L
QI/S4Wbl1Hz6LDTsttMwP480gq6+tb6s1E4oWw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QJIabgm8dx/gVHbOQFwt8maOKVHFgkpZTPR6dzD8fqoGo9M9oGPTqBqchtPZWgv2UYFF2KEUSlV4
L3SDXBKrLs+NsAVTcICaEMiEi6j82zj/C1LsPkQfS8RLrg0ab8lbDMb5YqJ7lkHs3iM65x2iN1Mf
66cTgCbkAdl3rDpab75btpTQt5ZKiq5CSY3RZfyIW0uWbTGTELm6liuRKM9+K8BQwTU7A+FFFQBA
/9eJwQYzNNA/iwoYJ2WTPd6pBlzXriNLu9M+/2bYicNBSuH1PBR9v2ESrTB6k7EiV1zvBXV9NuG/
sFt4MumWMuSNwP2W38bQATxxW/l0IrmaXGOC/w==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
lhKf/Vgj6pHpme1ji4HVe36BU8pMkam/2I9lFeyOiBnIbzgdEGfLJBcEvkL33A7s0hxa6LFbHnkT
upgMpPjmIghBz3xUQ13vpiY152thFec6qvlcdg1r+GTmnBOSFl6g/OfZ3eFUhfsve6ZjQHpXnKFo
a55hN2+eP1EG9+VxGeM7XkHaeFhEIry52qtnmg072KEFIwRiGs2d/TJ4AqupuIdIiP1kTN9k+oqa
2ta1vdtqPY0dDHqrf+5YSd0CejkhQeCqg/bauLP3755SwdOPRgooG5ANT8hUpTiFMFXtU+GC9NSp
evJtMHUy1NbgMmhFHO+w3URLEdjSaBxZPD7YLdWkF65jY526tJzoek+BzEKoBaGfCaY7O1nHKXm+
89k3rPUy0Xo4/0nHpno+N/Db09heJPbnGsCwN/l+KnR6Lz8kvWziBjZe0ijOkKI+T12y3T1VeOtY
H/aqtNlQt1mhFwrbw6ezaAiDPVbCQXnly6b4tbb8+nFsxWOGIGAfLozB

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PNsQ8uEcQYrl+GaDuBaq1tQ5br5aAdaqHnyrc0NVu/JnQUk53jaiLx8Oz5fNACvWelUUk2/C+P5I
b2rbU1bb/dC6TqC5J1N0yoMYRYw58u4Lrl8Kgqgt9Rlph5Qgzzfxp+oblXF/pO4mRyAXpZhpNkFT
0Ar9BUtPOTOtJ9/g53SRnZ6GjxzfeD+25J4fcXBNo2gCTgUkwiLSsJRwTB/cJmn+dZPwPdIOHEP9
TkfDK+OrbLYO3T+DFBTCMRNH2NB1J9sc5s+nPU8iYnjgPTo6HoGW+LIlCz6yNJMZzJzoeW708utc
0fJXkT7vLDVh7olvy3V9AAY8Do0YR1kiZlhVhQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zAz8RnGHFebkJFAS+gjC+mXHW7m7We+JgSmIz15mS01u/4+9Ng0sJfkeXOClmVPTQ2Mp2Yuv6/6f
ehzUTcANilWsqLM6Q1FToCPNX/NTqodlcHirGM7b5R9yevouNT/aqH12nmbunBQmBHmehNutdCjG
r6Z7kZgeZ2ZE7MMOF0rTy1XHEPkqgMNTRoS8R/pPWPTW4/j+bn3aJj0Q/fTz4Gi3mbSUKWs2fREQ
UKiuolNJkN6DiDvhlVYHUyytXNJG44ikmBXehoQQRLapkYaxnQmMRT1ok9uY6pKoy71CtvJ3Mt2x
EQv1GU2i4qQyAOwa0mkEohWXduicU6tDz3zQwQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TK3eE9V+v1z2P1KjG4GrjhA1n3qDOpNzLGXdtjnjhF0QBFPSuhC+nmNqTPOb3p2a9r5KD0miY3Cd
+KpjH6Ao09E2/LD2Go4aLQh6vP+9BldlSKEwCGfx2NjBQrXWVH21lQR7IRjOvyTOclpd7SgtUJLw
dvebETyLiKr9C6RfnIBeptuCA3iJlXfwkh6I0JfzD5WBizQkotioZmmrXv5105pCXQ4Ta1WThFsA
2ll9dZeSjEDHUxxhfyfjryv9m4VL89ZDU/rGITsdptwB1BC1jLqmPDymY05lyECnjA6NIR5GGfI4
K2y2f4GfikKoN5r9IOvFzw963Wm82ZZPtXOKGg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 29360)
`pragma protect data_block
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
OhRtpeE=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
