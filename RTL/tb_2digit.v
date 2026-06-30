
`timescale 1ns / 1ps

module tb_display_2digit_cross();

    // Inputs
    reg [7:0] in_A;
    reg [7:0] in_B;

    // Outputs
    wire [6:0] seg_ch_A, seg_dv_A;
    wire [6:0] seg_ch_B, seg_dv_B;

    // Instantiate the Unit Under Test (UUT)
    display_2digit_cross uut (
        .in_A(in_A), 
        .in_B(in_B), 
        .seg_ch_A(seg_ch_A), 
        .seg_dv_A(seg_dv_A), 
        .seg_ch_B(seg_ch_B), 
        .seg_dv_B(seg_dv_B)
    );

    initial begin
        // Initialize Inputs
        in_A = 0;
        in_B = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Test Case 1: Simple values
        in_A = 8'd25; // Expect A: Tens=2, Units=5
        in_B = 8'd48; // Expect B: Tens=4, Units=8
        #20;
        
        // Test Case 2: Boundary values (Single digits)
        in_A = 8'd09; // Expect A: Tens=0, Units=9
        in_B = 8'd03; // Expect B: Tens=0, Units=3
        #20;

        // Test Case 3: High values
        in_A = 8'd99; // Expect A: Tens=9, Units=9
        in_B = 8'd70; // Expect B: Tens=7, Units=0
        #20;

        // Test Case 4: Zero
        in_A = 8'd0;
        in_B = 8'd0;
        #20;

        // Test Case 5: Random mix
        in_A = 8'd51;
        in_B = 8'd12;
        #20;

        $display("Simulation Finished");
        $stop;
    end
      
    // Monitor the changes in the console
    initial begin
        $monitor("Time=%0t | InA=%d (SegA: %b %b) | InB=%d (SegB: %b %b)", 
                 $time, in_A, seg_ch_A, seg_dv_A, in_B, seg_ch_B, seg_dv_B);
    end

endmodule