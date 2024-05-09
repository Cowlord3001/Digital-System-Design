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
	CONSTANT ball_size :   INTEGER := 100;
	SIGNAL ball_on : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000"; -- indicates whether ball is over current pixel position
	SIGNAL flag : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";    -- indicates if we have already collided with a ball
	SIGNAL cursor_on : STD_LOGIC; -- indicates whether cursor is over current pixel position
	-- current ball position - intitialized to center of screen
	SIGNAL cursor_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL cursor_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	-- current ball motion - initialized to 0 pixels/frame (00000000000)
	SIGNAL cursor_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
	SIGNAL cursor_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
	signal temp : INTEGER := 0;
	signal white : STD_LOGIC;
BEGIN
    
    ballx(0) <= CONV_STD_LOGIC_VECTOR(100, 11);
    ballx(1) <= CONV_STD_LOGIC_VECTOR(300, 11);
    ballx(2) <= CONV_STD_LOGIC_VECTOR(500, 11);
    ballx(3) <= CONV_STD_LOGIC_VECTOR(700, 11);
    ballx(4) <= CONV_STD_LOGIC_VECTOR(100, 11);
    ballx(5) <= CONV_STD_LOGIC_VECTOR(300, 11);
    ballx(6) <= CONV_STD_LOGIC_VECTOR(500, 11);
    ballx(7) <= CONV_STD_LOGIC_VECTOR(700, 11);
    ballx(8) <= CONV_STD_LOGIC_VECTOR(100, 11);
    ballx(9) <= CONV_STD_LOGIC_VECTOR(300, 11);
    ballx(10) <= CONV_STD_LOGIC_VECTOR(500, 11);
    ballx(11) <= CONV_STD_LOGIC_VECTOR(700, 11);
    
    bally(0) <= CONV_STD_LOGIC_VECTOR(100, 11);
    bally(1) <= CONV_STD_LOGIC_VECTOR(100, 11);
    bally(2) <= CONV_STD_LOGIC_VECTOR(100, 11);
    bally(3) <= CONV_STD_LOGIC_VECTOR(100, 11);
    bally(4) <= CONV_STD_LOGIC_VECTOR(300, 11);
    bally(5) <= CONV_STD_LOGIC_VECTOR(300, 11);
    bally(6) <= CONV_STD_LOGIC_VECTOR(300, 11);
    bally(7) <= CONV_STD_LOGIC_VECTOR(300, 11);
    bally(8) <= CONV_STD_LOGIC_VECTOR(500, 11);
    bally(9) <= CONV_STD_LOGIC_VECTOR(500, 11);
    bally(10) <= CONV_STD_LOGIC_VECTOR(500, 11);
    bally(11) <= CONV_STD_LOGIC_VECTOR(500, 11);
    
    red <= NOT ball_on(0) AND NOT ball_on(3) AND NOT ball_on(6) AND NOT ball_on(9) AND NOT cursor_on;
    blue <= NOT ball_on(1) AND NOT ball_on(4) AND NOT ball_on(7) AND NOT ball_on(10) AND NOT cursor_on;
    green <= NOT ball_on(2) AND NOT ball_on(5) AND NOT ball_on(8) AND NOT ball_on(11) AND NOT cursor_on;
	
	-- process to draw ball current pixel address is covered by ball position
	bdraw : PROCESS (ballx, bally) IS
	BEGIN
	
       IF (pixel_col >= ballx(0) - ball_size) AND
          (pixel_col <= ballx(0) + ball_size) AND
             (pixel_row >= bally(0) - ball_size) AND
             (pixel_row <= bally(0) + ball_size) THEN
                IF (ballx(0) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(0) + ball_size >= cursor_x + cursor_size) AND
                       (bally(0) - ball_size <= cursor_y - cursor_size) AND
			           (bally(0) + ball_size >= cursor_y + cursor_size) AND 
			           (flag(0) = '0') THEN
			                ball_on(0) <= ball_on(0) XOR '1';
			                flag(0) <= '1';
			    END IF;
       ELSE
           ball_on(0) <= ball_on(0);
           flag(0) <= '0';
       END IF;
	
       IF (pixel_col >= ballx(1) - ball_size) AND
          (pixel_col <= ballx(1) + ball_size) AND
             (pixel_row >= bally(1) - ball_size) AND
             (pixel_row <= bally(1) + ball_size) THEN
                ball_on(1) <= '1';
       ELSE
           ball_on(1) <= '0';     
       END IF;
	
       IF (pixel_col >= ballx(2) - ball_size) AND
          (pixel_col <= ballx(2) + ball_size) AND
             (pixel_row >= bally(2) - ball_size) AND
             (pixel_row <= bally(2) + ball_size) THEN
                ball_on(2) <= '1';
       ELSE
           ball_on(2) <= '0';     
       END IF;
	
       IF (pixel_col >= ballx(3) - ball_size) AND
          (pixel_col <= ballx(3) + ball_size) AND
             (pixel_row >= bally(3) - ball_size) AND
             (pixel_row <= bally(3) + ball_size) THEN
                ball_on(3) <= '1';
       ELSE
           ball_on(3) <= '0';     
       END IF;
	
       IF (pixel_col >= ballx(4) - ball_size) AND
          (pixel_col <= ballx(4) + ball_size) AND
             (pixel_row >= bally(4) - ball_size) AND
             (pixel_row <= bally(4) + ball_size) THEN
                ball_on(4) <= '1';
       ELSE
           ball_on(4) <= '0';     
       END IF;
	
       IF (pixel_col >= ballx(5) - ball_size) AND
          (pixel_col <= ballx(5) + ball_size) AND
             (pixel_row >= bally(5) - ball_size) AND
             (pixel_row <= bally(5) + ball_size) THEN
                ball_on(5) <= '1';
       ELSE
           ball_on(5) <= '0';     
       END IF;
	
       IF (pixel_col >= ballx(6) - ball_size) AND
          (pixel_col <= ballx(6) + ball_size) AND
             (pixel_row >= bally(6) - ball_size) AND
             (pixel_row <= bally(6) + ball_size) THEN
                ball_on(6) <= '1';
       ELSE
           ball_on(6) <= '0';     
       END IF;
	
       IF (pixel_col >= ballx(7) - ball_size) AND
          (pixel_col <= ballx(7) + ball_size) AND
             (pixel_row >= bally(7) - ball_size) AND
             (pixel_row <= bally(7) + ball_size) THEN
                ball_on(7) <= '1';
       ELSE
           ball_on(7) <= '0';     
       END IF;
	
       IF (pixel_col >= ballx(8) - ball_size) AND
          (pixel_col <= ballx(8) + ball_size) AND
             (pixel_row >= bally(8) - ball_size) AND
             (pixel_row <= bally(8) + ball_size) THEN
                ball_on(8) <= '1';
       ELSE
           ball_on(8) <= '0';     
       END IF;
	
       IF (pixel_col >= ballx(9) - ball_size) AND
          (pixel_col <= ballx(9) + ball_size) AND
             (pixel_row >= bally(9) - ball_size) AND
             (pixel_row <= bally(9) + ball_size) THEN
                ball_on(9) <= '1';
       ELSE
           ball_on(9) <= '0';     
       END IF;
	
       IF (pixel_col >= ballx(10) - ball_size) AND
          (pixel_col <= ballx(10) + ball_size) AND
             (pixel_row >= bally(10) - ball_size) AND
             (pixel_row <= bally(10) + ball_size) THEN
                ball_on(10) <= '1';
       ELSE
           ball_on(10) <= '0';     
       END IF;
       
       IF (pixel_col >= ballx(11) - ball_size) AND
          (pixel_col <= ballx(11) + ball_size) AND
             (pixel_row >= bally(11) - ball_size) AND
             (pixel_row <= bally(11) + ball_size) THEN
                ball_on(11) <= '1';
       ELSE
           ball_on(11) <= '0';     
       END IF;
       
    END PROCESS;
    
    
--    collision : PROCESS (cursor_x,cursor_y) IS
--    BEGIN
--       IF (ballx(0) - ball_size <= cursor_x - cursor_size) AND
--          (ballx(0) + ball_size >= cursor_x + cursor_size) AND
--             (bally(0) - ball_size <= cursor_y - cursor_size) AND
--			 (bally(0) + ball_size >= cursor_y + cursor_size) THEN
--			    ball_on(0) <= '1';
--       END IF;
--    END PROCESS;
    
	
	-- process to draw cursor current pixel address is covered by cursor position
	draw_cursor : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		   (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				cursor_on <= '1';
		END IF;
    END PROCESS;
		
    -- process to move ball once every frame (i.e. once every vsync pulse)
    mball : PROCESS
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
			
        IF BTNU = '1' AND cursor_y >= (2*cursor_size) THEN
             cursor_y_motion <= "11111111100";
        ELSIF BTND = '1' AND cursor_y + (2*cursor_size) <= 600 THEN
             cursor_y_motion <= "00000000100";
        ELSE
             cursor_y_motion <= "00000000000";
        END IF;
        
        IF BTNR = '1' AND cursor_x + (2*cursor_size) <= 800 THEN
             cursor_x_motion <= "00000000100";
        ELSIF BTNL = '1' AND cursor_x >= (2*cursor_size) THEN
             cursor_x_motion <= "11111111100";
        ELSE
             cursor_x_motion <= "00000000000";
        END IF;
			
        cursor_x <= cursor_x + cursor_x_motion; -- compute next ball position
        cursor_y <= cursor_y + cursor_y_motion; -- compute next ball position
    END PROCESS;
END Behavioral;
