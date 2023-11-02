// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Thu Nov  2 16:49:45 2023
// Host        : Robot running 64-bit Ubuntu 22.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/julian/the_cpu/axo32/cmod_a7_dev/cmod_a7_dev.gen/sources_1/bd/memory/ip/memory_blk_mem_gen_0_0/memory_blk_mem_gen_0_0_sim_netlist.v
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 29648)
`pragma protect data_block
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
YTdDGNi2bPw=
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
