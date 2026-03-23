`timescale 1ns/1ps

Okay, so I need to generate a complete SystemVerilog module for a finite state machine (FSM) based on the provided state definitions and transition tables. Let me start by understanding the problem.

First, the module is named `seq_det`, and it has four inputs: `clk`, `rst_n`, `data_in`, and `outputLogic`. The outputs are `det`, which is a boolean indicating whether a detection has occurred.

Looking at the states, there are two states: IDLE (000) and a detected state (100). The transitions are defined in the `transitions` table. For example, when the state is IDLE (000) and the `data_in` is 0, it stays in IDLE. If `data_in` is 1, it transitions to the detected state.

I need to design the FSM with the following components:
1. State register: This will hold the current state (IDLE or detected).
2. Output register: This will store the detection result (0 or 1).
3. Reset signal: This will reset the FSM when `rst_n` is 1.
4. Transition table: This will define the state transitions based on the inputs.
5. Output statement: This will output the `det` signal.

I'll start by defining the state register. Since there are only two states, a 2-bit register is sufficient. I'll use a `reg` type for the state.

Next, the output register is straightforward; it's a `reg` type with one bit.

For the transition table, I'll create a `case` statement where each case corresponds to a transition. Each transition will have conditions based on the `clk`, `rst_n`, and `data_in` inputs.

I also need to handle the reset signal. The reset will be active high, so I'll use a `reset` signal in the transition cases.

Finally, I'll write the output statement to output the `det` signal whenever the FSM transitions to the detected state.

I should ensure that the FSM is synthesizable, so I'll use combinational logic for the transitions and sequential logic for the outputs.

Putting it all together, I'll write the module with the state register, transition table, output register, and the output statement.
</think>

module seq_det(input logic clk, rst_n, data_in, output logic detected);
  reg [1] state;  // State register: 000 (IDLE), 100 (detected)
  reg [1] output;  // Output register: 0 or 1
  input reset;     // Reset signal

  always
  case (state, rst_n, data_in)
    (000, 0, 0)  // IDLE, reset, data_in=0: stay IDLE
    (000, 0, 1)  // IDLE, reset, data_in=1: transition to detected
    (100, 1, 0)  // Detected, reset, data_in=0: stay detected
    (100, 1, 1)  // Detected, reset, data_in=1: stay detected
    (001, 0, 0)  // IDLE, data_in=0: stay IDLE
    (010, 0, 0)  // IDLE, data_in=0: stay IDLE
    (011, 0, 1)  // IDLE, data_in=1: stay IDLE
    (101, 0, 0)  // IDLE, data_in=0: stay IDLE
    (101, 0, 1)  // IDLE, data_in=1: stay IDLE
    (1011, 0, 0) // IDLE, data_in=0: stay IDLE
    (1011, 0, 1) // IDLE, data_in=1: stay IDLE
  endcase

  always
  output = state == 100;
end