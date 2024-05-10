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

### List of Modifications

This project was based on **Lab 3: Bouncing Ball**. The following modifications were made:
- In vga_top.xdc, constraints for switches 0-2 and the directional buttons (BTNU, BTND, BTNL, and BTNR) were added.
- In vga_top.vhd, the above Pins were added to the architecture, ball component, and ball port map.
The core of our code was added to ball.vhd. This is as follows:
- The switches and directional button pins were added to the entity.
- A new type, c_mem_t, was added to the architecture. This is an 48-item array of std_logic_vector(10 downto 0).
- Added c_mem_t signals named ballx and bally. --This allowed us to easily index into our 48-square grid.
- ball_on was converted from std_logic to std_logic_vector(47 DOWNTO 0). It is set to 0 to start. --This allowed us to easily turn off and on each of our 48 squares.
- The constant size was split into cursor_size and ball_size. The former became a signal and was set to 6, and the latter remained a constant and was set to 50.
- Signal cursor_size_mod was added and set to 6. --This allowed us to change cursor_size using the switches later.
- Signal cursor_on was added, acting as a cursor version of ball_on.
- ball_x and ball_y were renamed to cursor_x and cursor_y.
- ball_y_motion was renamed to cursor_y_motion, and cursor_x_motion was added to allow for motion in the x direction. These are set to 0 to start. --This was originally a requirement for lab 3.

- After the begin, 96 lines of code were added which set ballx and bally for each of the 48 squares.
- The red, green, and blue signal assignments were replaced with massive rows of code which set 1/3 of the squares to cyan (0, 3, 6...), 1/3 to yellow (1, 4, 7...), and 1/3 to magenta (2, 5, 8...).
- The process bdraw now only uses ballx and bally in its sensitivity list. The process consists of 48 IF statements (with more nested IF statements) that draws the 48 squares as white until it detects a collision with the cursor, after which it sets the square to its respective color (see above) until the collision ends. This is the largest process in our code.
- The process cursorSZ is a new process which includes the switches in its sensitivity list. It calculates cursor_size by multiplying cursor_size_mod with the switches value converted to an integer. This allows the cursor to change sizes in real time as the switches are flipped.
- The proess draw_cursor is based on bdraw, acting similar to the original version from lab 3. The cursor is drawn as a circle, which was a requirement for lab 3 as well.
- The process mball is incorrectly labeled, now moving the cursor. The process now waits until one of the directional buttons are pressed, setting cursor_x_motion and cursor_y_motion according to these (or to 0 if no buttons are pressed). Both motions are updated at the bottom of the process.

### References & Inspirations
- https://github.com/mbanks01/DSD-image-project - Michael Banks' final project for CPE-487. This was used as inspiration during the first 1-2 days of coding, although it was referenced less often as original code was developed. Despite this, it was an important first step to developing our code.
- https://stackoverflow.com/questions/56794058/in-vhdl-is-it-possible-to-create-an-array-of-std-logic-vector-without-using-a-t - This stackoverflow post gave us the baseline for making an array of arrays. The type c_mem_t was ported into our code from here, albeit with some adjustments.

### Summary

#### Responsibilities
- Chris often worked off the main code base, integrating Frank's code as he developed it. This led to many of the GitHub contributions being made by Chris **despite** Frank making an equal number of contributions to the code itself.
- Chris developed many now-obsolete FOR loop processes, the ballx and bally assignments, the cursor movement, and the shift from FOR loops to manual assignments.
- Frank developed the original collision code, the circular cursor code, and worked on scaling the code from a 4x3 grid (12 squares) to an 8x6 grid (48 squares).
- The ARCHIVE in our GitHub contains many variations of ball.vhd, as well as some other miscellaneous pieces of code. The ball.vhd variations act as branches of the main ball code, being worked on by Chris, Frank, and even Professor Yett. While most of these contributed to the final ball.vhd code, some of each person's contributions can be observed here.

#### Difficulties
- The code originally utilized FOR loops extensively for many repetitive tasks, which would have reduced the lines of code from ~725 to ~200. However, FOR loops routinely mangled our code in nonsensical and borderline insane ways. This can be viewed in the **Timeline** below, and it necessitated removing every FOR loop in the code and replacing them with manual assignments.
- Changing the colors of a square was an extremely difficult process, eventually being scrapped due to time constraints. VHDL looks at colors less as what *is* colored and more like what *is not* colored. If you add too many colors, they stack into white. Not enough, and they may become black. Change colors in the wrong spot, and you may get screen tearing and other visual errors. We eventually hard-coded the colors of each square, removing many of the glitches that can be seen in the **Timeline** below.
- The borders that trap the cursor offscreen were affectionately referred to as "Hell Portals" throughout development. Although these could be removed given more time, the strange side effects they had on the grid (noted in **Expected Behavior & Hardware Requirements**) led to us keeping them as a sort of added challenge to the otherwise straightforward code.

#### Timeline

The exact dates and times of each iteration were not tracked in full due to the high concentration of changes per day and a disregard for uploading smaller changes to GitHub (directly sharing them via google drive instead). The majority of the code base was developed between Monday 05/06 and Thursday 05/09, with initial repositor commits occurring the previous week. The rough timeline is as follow:
- Prior to 05/06 - Initial files from lab 3 were added to this repository. Buttons and switches were added to vga_top.xdc, vga_top.vhd, and ball.vhd.
- 05/06 - Directional movement for the cursor was added. Now-obsolete code regarding BTNC was developed.
- 05/07 - Initial code for placing and drawing the grid. Arrays and vectors were added. Now-obsolete code including FOR loops and wait_until was developed.
- 05/08 - Many changes that still included the obsolete FOR loops. Aesthetic revisions and refactoring for greating readability were performed.
- 05/09 - The code was finalized. Various attempts at debugging the FOR loops were performed before eventually moving to manual assignment, reducing the grid size to do so. Collision code, color changing, and now-obsolete flag code which was meant to allow collided-with squares to maintain their color and potentially have various colors. Once the code was functional, it was scaled from 12 squares to the current 48 squares.

*Note: The descriptions and titles of each commit devolved significantly during the final day, showing the team's similarly-devolving mental state. The phrases "we are so back," "it's so over," and "banish them to **The Pit**" were quoted from some of the many commits during this period.*

The following timeline prioritizes the code's path to completion rather than the dates and times of their contribution:

