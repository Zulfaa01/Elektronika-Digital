`timescale 1ns/1ps

module tb_fsm();

    reg clk, rst_n;
    reg I1, I0;
    wire pump, aerator, valve, heater, uv, feeder;
    wire [1:0] state;

    // DUT
    fsm_aquaculture dut (
        .clk(clk),
        .rst_n(rst_n),
        .I1(I1), .I0(I0),
        .pump(pump),
        .aerator(aerator),
        .valve(valve),
        .heater(heater),
        .uv(uv),
        .feeder(feeder),
        .state(state)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("fsm.vcd");
        $dumpvars(0, tb_fsm);

        rst_n = 0; I1 = 0; I0 = 0;
        #20 rst_n = 1;

        // Normal
        #20 I1 = 0; I0 = 0;

        // Warning
        #40 I1 = 0; I0 = 1;

        // Critical
        #40 I1 = 1; I0 = 0;

        // Normal lagi
        #40 I1 = 0; I0 = 0;

        #100 $finish;
    end

endmodule
