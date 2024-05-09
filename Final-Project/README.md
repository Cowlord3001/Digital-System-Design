# Final Project: "Dance Pad"
*By Chris Alessandri and Frank Castillo*
### Expected Behavior & Hardware Requirements

This project requires a VGA connector and monitor. When the code is run, a black dot (the cursor) should appear on a white background. The directional buttons move the cursor, and switches 0-2 change its size. The white background consists of an 8x6 grid of squares which light up different colors when the cursor is entirely inside one (easier seen with the smallest cursor size).

*Note: If the cursor, at its smallest size, touches the edge of the screen, it will be sucked into the eldritch dark. However, moving it to the exact edge lights up an entire row / column of squares. If you can manage to get the cursor to the very edge of the screen's corner, the entire screen will come alive with vibrant color!*

### Block Diagram
![DSD Final Diagram](https://github.com/Cowlord3001/Digital-System-Design/assets/39775736/85e00fe9-52b0-42df-a181-3c0ba23e6f85)

### Instructions
#### Step 1 - Create a new RTL project *dancepad* in Vivado Quick Start
- Create five new source files of file type VHDL called ***clk_wiz_0, clk_wiz_0_clk_wiz, vga_sync, ball, and vga_top***.
- Create a new constraint file of file type XDC called ***vga_top***.
- Choose Nexys A7-100T board for the project.
- Click 'Finish'.
- Click design sources and copy the VHDL code from clk_wiz_0.vhd, clk_wiz_0_clk_wiz.vhd, vga_sync.vhd, ball.vhd, and vga_top.vhd.
- Click constraints and copy the code from vga_top.xdc.
- As an alternative, you can instead download files from GitHub and import them into your project when creating the project. The source file or files would still be imported during the Source step, and the constraint file or files would still be imported during the Constraints step. This was our team's preferred method.
#### Step 2 - Run Synthesis and Implementation
#### Step 3 - Generate Bitstream, open Hardware Manager, and program the FPGA.
#### Step 4 - Have fun!
- If you find yourself sucked into the dark beyond the stars (i.e. Offscreen), program the board again in the Hardware Manager to reset.

### Inputs and Outputs
- This project uses the same inputs and outputs as **Lab 3: Bouncing Ball**, as well as a few additional inputs:
#### OLD

*Clock Pin:*
- PIN E3

*VGA Connector Pins:*
- PIN A3, B4, C5  (red)
- PIN C6, A5, B6  (green)
- PIN B7, C7      (blue)
- PIN B11, B12    (sync)

#### NEW

*Switch Pins:*
- PIN J15, L16, M13

*Button Pins:*
- PIN M18, P17, M17, P18
