
module display_2digit_cross (
    input      [7:0] in_A,
    input      [7:0] in_B,
    output     [6:0] seg_ch_A,
    output     [6:0] seg_dv_A,
    output     [6:0] seg_ch_B,
    output     [6:0] seg_dv_B
);

display_2digit u_A (
    .in     (in_A),
    .seg_ch (seg_ch_A),
    .seg_dv (seg_dv_A)
);

display_2digit u_B (
    .in     (in_B),
    .seg_ch (seg_ch_B),
    .seg_dv (seg_dv_B)
);

endmodule

// ================================================================
module display_2digit (
    input      [7:0] in,
    output     [6:0] seg_ch,
    output     [6:0] seg_dv
);
wire [3:0] t_ch, t_dv;

sep2    u_sep2 (.in(in),    .ch(t_ch),      .dv(t_dv));
seg7dec u_ch   (.in(t_ch),  .out_hex(seg_ch));
seg7dec u_dv   (.in(t_dv),  .out_hex(seg_dv));

endmodule

// ================================================================
module sep2 (
    input      [7:0] in,
    output reg [3:0] ch,
    output reg [3:0] dv
);
always @(*) begin
    if      (in >= 90) begin ch = 4'd9; dv = in - 90; end
    else if (in >= 80) begin ch = 4'd8; dv = in - 80; end
    else if (in >= 70) begin ch = 4'd7; dv = in - 70; end
    else if (in >= 60) begin ch = 4'd6; dv = in - 60; end
    else if (in >= 50) begin ch = 4'd5; dv = in - 50; end
    else if (in >= 40) begin ch = 4'd4; dv = in - 40; end
    else if (in >= 30) begin ch = 4'd3; dv = in - 30; end
    else if (in >= 20) begin ch = 4'd2; dv = in - 20; end
    else if (in >= 10) begin ch = 4'd1; dv = in - 10; end
    else               begin ch = 4'd0; dv = in;       end
end
endmodule

module seg7dec (
    input      [3:0] in,
    output reg [6:0] out_hex
);
always @(*) begin
    case (in)
        4'd0: out_hex = 7'b1000000;
        4'd1: out_hex = 7'b1111001;
        4'd2: out_hex = 7'b0100100;
        4'd3: out_hex = 7'b0110000;
        4'd4: out_hex = 7'b0011001;
        4'd5: out_hex = 7'b0010010;
        4'd6: out_hex = 7'b0000010;
        4'd7: out_hex = 7'b1111000;
        4'd8: out_hex = 7'b0000000;
        4'd9: out_hex = 7'b0010000;
        default: out_hex = 7'b1111111;
    endcase
end
endmodule
