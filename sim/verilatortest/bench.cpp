
#include "Vtop.h"
#include "verilated.h"
#include "verilated_fst_c.h"

int main(int argc, char** argv) {
    // Create contexts.
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);
    Vtop* top = new Vtop{contextp};
    VerilatedFstC *trace = new VerilatedFstC();
    
    // Set up the trace.
    top->trace(trace, 5);
    
    // Run a number of clock cycles.
    contextp->traceEverOn(true);
    for (int i = 0; i < 50 && !contextp->gotFinish(); i++) {
        top->clk ^= 1;
        top->eval();
        trace->dump(i);
    }
    // while (!contextp->gotFinish()) { top->eval(); }
    
    // Clean up.
    delete top;
    delete contextp;
    return 0;
}
