// 1 Hz freq contains 32'h17D7840 (or 25000000) clock cycles (periods/peaks).
parameter do_cycle_count = 32'hBAB9; // Freq divider for 523 Hz requires 25000000/523 =  47801 => 32'hBAB9
parameter re_cycle_count = 32'hA65D; // Freq divider for 587 Hz requires 25000000/587 =  42589 => 32'hA65D
parameter mi_cycle_count = 32'h9430; // Freq divider for 659 Hz requires 25000000/659 =  37936 => 32'h9430
parameter fa_cycle_count = 32'h8BE8; // Freq divider for 698 Hz requires 25000000/698 =  35816 => 32'h8BE8
parameter so_cycle_count = 32'h7CB8; // Freq divider for 783 Hz requires 25000000/783 =  31928 => 32'h7CB8
parameter la_cycle_count = 32'h6EF9; // Freq divider for 880 Hz requires 25000000/880 =  28409 => 32'h6EF9
parameter si_cycle_count = 32'h62F1; // Freq divider for 987 Hz requires 25000000/987 =  25329 => 32'h62F1
parameter do2_cycle_count = 32'h5D5D; // Freq divider for 1046 Hz requires 25000000/1046 = 23901 => 32'h5D5D


// Calculates the number of cycles for the clk_divider module depending on input from SW[3:1]
module clock_cycle_calc (switch_input, clk_count);
    input logic [2:0] switch_input;
    output logic [31:0] clk_count;

    always_comb begin
        case(switch_input)
            3'b000: clk_count = do_cycle_count;
            3'b001: clk_count = re_cycle_count;
            3'b010: clk_count = mi_cycle_count;
            3'b011: clk_count = fa_cycle_count;
            3'b100: clk_count = so_cycle_count;
            3'b101: clk_count = la_cycle_count;
            3'b110: clk_count = si_cycle_count;
            3'b111: clk_count = do2_cycle_count;
            default: clk_count = 32'hFFFF; // High by default, for debugging
        endcase
    end

endmodule