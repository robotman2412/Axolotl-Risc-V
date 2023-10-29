// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Sat Oct 28 20:23:20 2023
// Host        : LinuxBot running 64-bit Arch Linux
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
zWlVRjmAZf4=
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
