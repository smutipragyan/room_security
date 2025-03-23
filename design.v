module room_security (
    input clock, clear, 
    input [3:0] password_input,  // 4-bit password input
    input enter,                 // Enter button for password submission
    output reg door_lock,         // 1 = Locked, 0 = Unlocked
    output reg alarm              // 1 = Alarm ON (wrong attempts)
);

  parameter CORRECT_PASSWORD = 4'b1010;  // Set predefined password
  reg [2:0] attempt_count;               // Track wrong attempts

  always @(posedge clock or posedge clear) begin
    if (clear) begin
      door_lock <= 1;         // Lock the door initially
      alarm <= 0;             // Alarm OFF
      attempt_count <= 0;     // Reset attempts
    end 
    else if (enter) begin
      if (password_input == CORRECT_PASSWORD) begin
        door_lock <= 0;       // Unlock the door
        alarm <= 0;           // Alarm remains OFF
        attempt_count <= 0;   // Reset wrong attempt count
      end 
      else begin
        attempt_count <= attempt_count + 1; // Increase attempt count
        if (attempt_count >= 3) 
          alarm <= 1;         // Activate alarm after 3 wrong attempts
      end
    end
  end
endmodule
