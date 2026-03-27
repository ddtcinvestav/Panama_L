`timescale 1ns/1ps

module seq_det (
    clk, rst_n, data_in, detected
) {
    // States
    always_initial (
        detect = 0;
        s1 = 0;
        s10 = 0;
        s101 = 0;
        s1011 = 1;
    ) {
        // Initial state is IDLE
    }

    // Always_ff to hold state
    always_ff {
        detect = 1;
        s1011 = 1;
    }

    // Always_comb to handle transitions
    always_comb (
        detect = detect | (data_in == 1);
        s1 = s1 | (data_in == 1);
        s10 = s10 | (data_in == 0);
        s101 = s101 | (data_in == 1);
        s1011 = s1011 | (data_in == 1);
    )

    // Transition from IDLE to S1
    always_comb (
        detect = detect | (data_in == 1);
        s1 = s1 | (data_in == 1);
        s10 = s10 | (data_in == 0);
        s101 = s101 | (data_in == 1);
        s1011 = s1011 | (data_in == 1);
    )

    // Transition from S1 to S10
    always_comb (
        detect = detect | (data_in == 1);
        s1 = s1 | (data_in == 1);
        s10 = s10 | (data_in == 0);
        s101 = s101 | (data_in == 1);
        s1011 = s1011 | (data_in == 1);
    )

    // Transition from S10 to S101
    always_comb (
        detect = detect | (data_in == 1);
        s1 = s1 | (data_in == 1);
        s10 = s10 | (data_in == 0);
        s101 = s101 | (data_in == 1);
        s1011 = s1011 | (data_in == 1);
    )

    // Transition from S101 to S1011
    always_comb (
        detect = detect | (data_in == 1);
        s1 = s1 | (data_in == 1);
        s10 = s10 | (data_in == 0);
        s101 = s101 | (data_in == 1);
        s1011 = s1011 | (data_in == 1);
    )

    // Transition from S1011 to IDLE
    always_comb (
        detect = detect | (data_in == 1);
        s1 = s1 | (data_in == 1);
        s10 = s10 | (data_in == 0);
        s101 = s101 | (data_in == 1);
        s1011 = s1011 | (data_in == 1);
    )
}