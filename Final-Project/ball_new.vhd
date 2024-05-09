LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ball IS
	PORT (
		v_sync    : IN STD_LOGIC;
		pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		red       : OUT STD_LOGIC;
		green     : OUT STD_LOGIC;
		blue      : OUT STD_LOGIC;
		SW        : IN std_logic_vector(2 DOWNTO 0);
		BTNC      : IN std_logic;
		BTNU      : IN std_logic;
		BTND      : IN std_logic;
		BTNL      : IN std_logic;
		BTNR      : IN std_logic
	);
END ball;

ARCHITECTURE Behavioral OF ball IS
    type c_mem_t is array (0 to 47) of std_logic_vector(10 downto 0);
    signal ballx : c_mem_t;
    signal bally : c_mem_t;
	CONSTANT cursor_size  : INTEGER := 8;    -- "RADIUS"
	CONSTANT ball_size :   INTEGER := 50;
	SIGNAL red_on, blue_on, green_on : STD_LOGIC_VECTOR(47 DOWNTO 0); -- indicates whether ball is over current pixel position
	SIGNAL cursor_on : STD_LOGIC; -- indicates whether cursor is over current pixel position
	-- current ball position - intitialized to center of screen
	SIGNAL cursor_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL cursor_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	-- current ball motion - initialized to 0 pixels/frame (00000000000)
	SIGNAL cursor_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
	SIGNAL cursor_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
	signal temp : INTEGER := 0;
	signal tempred : STD_LOGIC;
	signal tempblue : STD_LOGIC;
	signal tempgreen : STD_LOGIC;
BEGIN

    -- Checks if any ball should be colored.
    color_proc : PROCESS (red_on, blue_on, green_on) IS
    BEGIN
        tempred <= '1';
        tempblue <= '1';
        tempgreen <= '1';
        for i in 0 to 47 loop
            tempred <= tempred XOR red_on(i);
            tempblue <= tempblue XOR blue_on(i);
            tempgreen <= tempgreen XOR green_on(i);
        end loop;
    END PROCESS;
	red <= tempred;
	blue <= tempblue;
	green <= tempgreen;
    -- sets the x and y positions for all 48 balls.
    forloop : PROCESS
    BEGIN
        --for i in 0 to 5 loop
            for j in 0 to 7 loop
                ballx(temp) <= CONV_STD_LOGIC_VECTOR(j*100+50, 11);
                bally(temp) <= CONV_STD_LOGIC_VECTOR(50, 11);
                temp <= temp + 1;
            end loop;
        --end loop;
        wait;
    END PROCESS;
	
	-- process to draw ball current pixel address is covered by ball position
	bdraw : PROCESS (pixel_col, pixel_row) IS
	BEGIN
	   for i in 0 to 47 loop
	       IF (pixel_col > ballx(i) - ball_size) AND
		      (pixel_col < ballx(i) + ball_size) AND
			  (pixel_row > bally(i) - ball_size) AND
			  (pixel_row < bally(i) + ball_size) THEN
		       IF i < 16 then
			     red_on(i) <= '1';
		       		blue_on(i) <= '0';
		   		green_on(i) <= '0';
		       elsif i < 32 then
			       blue_on(i) <= '1';
		   		green_on(i) <= '0';
		red_on(i) <= '0';
		       else
			       green_on(i) <= '1';
		   		blue_on(i) <= '0';
red_on(i) <= '0';
		       end if;
	   	ELSE
			blue_on(i) <= '0';
			green_on(i) <= '0';
			red_on(i) <= '0';
		   END IF;
	   end loop;
	   --wait;
    END PROCESS;
	
	-- -- process to draw cursor current pixel address is covered by cursor position
	-- draw_cursor : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	-- BEGIN
	-- 	IF (pixel_col >= cursor_x - cursor_size) AND
	-- 	   (pixel_col <= cursor_x + cursor_size) AND
	-- 		 (pixel_row >= cursor_y - cursor_size) AND
	-- 		 (pixel_row <= cursor_y + cursor_size) THEN
	-- 			cursor_on <= '1';
	-- 	END IF;
 --    END PROCESS;
		
    -- -- process to move ball once every frame (i.e. once every vsync pulse)
    -- mball : PROCESS
    -- BEGIN
    --     WAIT UNTIL rising_edge(v_sync);
			
    --     IF BTNU = '1' AND cursor_y >= (2*cursor_size) THEN
    --          cursor_y_motion <= "11111111100";
    --     ELSIF BTND = '1' AND cursor_y + (2*cursor_size) <= 600 THEN
    --          cursor_y_motion <= "00000000100";
    --     ELSE
    --          cursor_y_motion <= "00000000000";
    --     END IF;
        
    --     IF BTNR = '1' AND cursor_x + (2*cursor_size) <= 800 THEN
    --          cursor_x_motion <= "00000000100";
    --     ELSIF BTNL = '1' AND cursor_x >= (2*cursor_size) THEN
    --          cursor_x_motion <= "11111111100";
    --     ELSE
    --          cursor_x_motion <= "00000000000";
    --     END IF;
			
    --     cursor_x <= cursor_x + cursor_x_motion; -- compute next ball position
    --     cursor_y <= cursor_y + cursor_y_motion; -- compute next ball position
    -- END PROCESS;
END Behavioral;
