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
	SIGNAL ball_on : STD_LOGIC_VECTOR(0 DOWNTO 47); -- indicates whether ball / pixel is over current pixel position
	-- current ball position - intitialized to center of screen
	SIGNAL cursor_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL cursor_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	-- current ball motion - initialized to 0 pixels/frame (00000000000)
	SIGNAL ball_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
	SIGNAL ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
	signal temp : INTEGER;
BEGIN

    forloop : PROCESS IS
    BEGIN
    temp <= 0;
        for i in 0 to 5 loop
            for j in 0 to 7 loop
                ballx(temp) <= CONV_STD_LOGIC_VECTOR(j*100+50, 11);
                bally(temp) <= CONV_STD_LOGIC_VECTOR(i*100+50, 11);
                temp <= temp + 1;
            end loop;
        end loop;
    END PROCESS;
	
	-- process to draw ball current pixel address is covered by ball position
	bdraw : PROCESS (ballx, bally) IS
	BEGIN
	   for i in 0 to 47 loop
	       IF (pixel_col >= ballx(i) - ball_size) AND
		      (pixel_col <= ballx(i) + ball_size) AND
			  (pixel_row >= bally(i) - ball_size) AND
			  (pixel_row <= bally(i) + ball_size) THEN
			     ball_on(i) <= '1';
		  END IF;
	   end loop;
    END PROCESS;
	
    red <= NOT ball_on(5) AND NOT ball_on(0);
	green <= NOT ball_on(9) AND NOT ball_on(0);
	blue  <= NOT ball_on(22) AND NOT ball_on(0);
	
	-- process to draw cursor current pixel address is covered by cursor position
	draw_cursor : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(0) <= '1';
		END IF;
		END PROCESS;
		
	
		
		-- process to move ball once every frame (i.e. once every vsync pulse)
		mball : PROCESS
		BEGIN
			WAIT UNTIL rising_edge(v_sync);
			
			IF BTNU = '1' AND cursor_y >= (2*cursor_size) THEN
			     ball_y_motion <= "11111111100";
			ELSIF BTND = '1' AND cursor_y + (2*cursor_size) <= 600 THEN
			     ball_y_motion <= "00000000100";
			ELSE
		         ball_y_motion <= "00000000000";
			END IF;
			
			IF BTNR = '1' AND cursor_x + (2*cursor_size) <= 800 THEN
			     ball_x_motion <= "00000000100";
			ELSIF BTNL = '1' AND cursor_x >= (2*cursor_size) THEN
			     ball_x_motion <= "11111111100";
			ELSE
		         ball_x_motion <= "00000000000";
			END IF;
			
			cursor_x <= cursor_x + ball_x_motion; -- compute next ball position
			cursor_y <= cursor_y + ball_y_motion; -- compute next ball position
		END PROCESS;
END Behavioral;
