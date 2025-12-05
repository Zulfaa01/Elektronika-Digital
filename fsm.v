module fsm_aquaculture (
    input clk,
    input rst_n,
    input I1, I0,              // input kondisi sensor
    output reg pump,
    output reg aerator,
    output reg valve,
    output reg heater,
    output reg uv,
    output reg feeder,
    output reg [1:0] state     // 00=SN, 01=SW, 10=SC
);

    // State encoding
    localparam SN = 2'b00;   // Normal
    localparam SW = 2'b01;   // Warning
    localparam SC = 2'b10;   // Critical

    reg [1:0] next_state;

    // ======================
    // STATE REGISTER (DFF)
    // ======================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= SN;         // reset ke Normal
        else
            state <= next_state;
    end

    // ======================
    // NEXT STATE LOGIC
    // ======================
    always @(*) begin
        case (state)
            SN: begin
                case ({I1, I0})
                    2'b00: next_state = SN; // Normal → Normal
                    2'b01: next_state = SW; // Minor issue → Warning
                    2'b10: next_state = SC; // Critical → SC
                    2'b11: next_state = SC; // Default → Critical
                    default: next_state = SN;
                endcase
            end

            SW: begin
                case ({I1, I0})
                    2'b00: next_state = SN; 
                    2'b01: next_state = SW; 
                    2'b10: next_state = SC; 
                    2'b11: next_state = SC; 
                    default: next_state = SW;
                endcase
            end

            SC: begin
                case ({I1, I0})
                    2'b00: next_state = SN;
                    2'b01: next_state = SW;
                    2'b10: next_state = SC;
                    2'b11: next_state = SC;
                    default: next_state = SC;
                endcase
            end

            default: next_state = SN;
        endcase
    end

    // ======================
    // OUTPUT LOGIC (MOORE)
    // ======================
    always @(*) begin
        // Default OFF semua
        pump   = 0;
        aerator = 0;
        valve  = 0;
        heater = 0;
        uv     = 0;
        feeder = 0;

        case (state)
            SN: begin
                aerator = 1;    // suplai oksigen rutin
                feeder  = 1;    // kasih makan normal
            end

            SW: begin
                pump   = 1; 
                aerator = 1;
                valve  = 1;
                feeder = 1;    // tetap memberi makan
            end

            SC: begin
                pump   = 1;
                aerator = 1;
                valve  = 1;
                heater = 1;
                uv     = 1;
                feeder = 0;    // OFF saat darurat
            end
        endcase
    end

endmodule
