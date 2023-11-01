// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Tue Oct 31 23:17:41 2023
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
yakT73wGgWo=
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
