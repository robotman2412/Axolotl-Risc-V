
module axo32_debug(
    // Ungated core clock.
    input  wire clock,
    
    // Data bus: CPU core side.
    inout  wire[31:0] cpu_data,
    // Address bus: CPU core side.
    input  wire[31:0] cpu_addr,
    // Access size: CPU core side.
    input  wire[1:0]  cpu_asize,
    // Read enable: CPU core side.
    input  wire       cpu_re,
    // Write enable: CPU core side.
    input  wire       cpu_we,
    // Memory ready: CPU core side.
    output wire       cpu_ready,
    
    // Data bus: memory bus side.
    inout  wire[31:0] bus_data,
    // Address bus: memory bus side.
    output wire[31:0] bus_addr,
    // Access size: memory bus side.
    output wire[1:0]  bus_asize,
    // Read enable: memory bus side.
    output wire       bus_re,
    // Write enable: memory bus side.
    output wire       bus_we,
    // Memory ready: memory bus side.
    input  wire       bus_ready,
    
    // Debug address.
    output wire[12:0]     xrd_addr,
    // Debug data.
    inout  wire[XLEN-1:0] xrd_data,
    // Debug read enable.
    output wire           xrd_re,
    // Debug write enable.
    output wire           xrd_we,
    // Debug clock.
    output wire           xrd_clock,
    // Debug select and enable.
    output wire           xrd_sel,
    // Run enable; core clock enable.
    output wire           xrd_run_en,
    // Reset enable.
    output wire           xrd_reset_en,
    // Available status.
    input  wire           xrd_available
);
    // Memory bus override enable.
    wire      mem_override = xrd_sel && !xrd_run_en;
    // Memory access address.
    reg[31:0] mem_addr = 0;
    // Memory access temporary register.
    reg[7:0]  mem_temp = 0;
    // Memory access read enable.
    reg       mem_re   = 0;
    // Memory access write enable.
    reg       mem_we   = 0;
    
    // Memory bus passthrough logic.
    assign bus_data  = mem_override 
                     ? (mem_we ? mem_temp : 'bz)
                     : (cpu_we ? cpu_data : 'bz);
    assign cpu_data  = mem_override
                     ? 'bz
                     : (cpu_re ? bus_data : 'bz);
    assign bus_addr  = mem_override ? mem_addr : cpu_addr;
    assign bus_re    = mem_override ? mem_re   : cpu_re;
    assign bus_we    = mem_override ? mem_we   : cpu_we;
    assign bus_asize = mem_override ? 0        : cpu_asize;
    assign cpu_ready = mem_ready && !mem_override;
    
endmodule
