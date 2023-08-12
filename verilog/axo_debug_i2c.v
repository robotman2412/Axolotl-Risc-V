
module axo_debug_i2c#(
    // Number of bits in timers.
    parameter TBITS = 8,
    // I²C debounce time.
    parameter DEBOUNCE = 63,
    // I²C start/stop conndition time.
    parameter STARTSTOP = 255
)(
    // SDA input.
    input  wire sda_in,
    // Pull SDA to ground output.
    output wire sda_pulldown_en,
    // SCL input.
    input  wire scl,
    
    // Ungated core clock.
    input  wire clock,
    
    // Selected HART.
    output reg[31:0]  xrd_hart,
    // Selected HART is present.
    input  wire       xrd_present,
    // Debug register address.
    output wire[15:0] xrd_addr,
    // Debug data bus.
    inout  wire[7:0]  xrd_data,
    // Debug read enable.
    output wire       xrd_re,
    // Debug write enable.
    output wire       xrd_we
);
    // I²C bus is active.
    reg i2c_active = 0;
    // I²C bus is active and selected as I²C slave.
    reg i2c_sel    = 0;
    // Latched SDA state.
    reg            sda_reg = 1;
    // Latched SCL state.
    reg            scl_reg = 1;
    // SDA debounce timer.
    reg[TBITS-1:0] sda_timer = 0;
    // SCL debounce timer.
    reg[TBITS-1:0] scl_timer = 0;
    
    always @(posedge clock) begin
    end
    
endmodule
