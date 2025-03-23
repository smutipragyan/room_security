`timescale 1ns/1ps

module room_security_tb;

  reg clock, clear, enter;
  reg [3:0] password_input;
  wire door_lock, alarm;

  // Instantiate Room Security System
  room_security uut (
    .clock(clock),
    .clear(clear),
    .password_input(password_input),
    .enter(enter),
    .door_lock(door_lock),
    .alarm(alarm)
  );

  // Generate Clock Signal (10ns period)
  always #5 clock = ~clock;

  initial begin
    $dumpfile("room_security.vcd");
    $dumpvars(0, room_security_tb);

    clock = 0; clear = 1; enter = 0; password_input = 4'b0000; 
    #10 clear = 0;  // Release reset

    #10 password_input = 4'b0011; enter = 1;  // Wrong attempt 1
    #10 enter = 0;
    
    #10 password_input = 4'b1100; enter = 1;  // Wrong attempt 2
    #10 enter = 0;

    #10 password_input = 4'b0110; enter = 1;  // Wrong attempt 3 (Alarm ON)
    #10 enter = 0;

    #10 password_input = 4'b1010; enter = 1;  // Correct password
    #10 enter = 0;

    #50 $finish;
  end

  initial begin
    $monitor("Time=%0t | Password=%b | Door Lock=%b | Alarm=%b | Attempts=%d", 
              $time, password_input, door_lock, alarm, uut.attempt_count);
  end

endmodule
