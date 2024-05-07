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
	CONSTANT cursor_size  : INTEGER := 8;    -- "RADIUS"
	CONSTANT size_rest :   INTEGER := 50;
	SIGNAL ball_on : STD_LOGIC_VECTOR(16 DOWNTO 0); -- indicates whether ball / pixel is over current pixel position
	-- current ball position - intitialized to center of screen
	SIGNAL cursor_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL cursor_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	SIGNAL ball_x1  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
	SIGNAL ball_y1  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
	SIGNAL ball_x2  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
	SIGNAL ball_y2  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
	SIGNAL ball_x3  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(250, 11);
	SIGNAL ball_y3  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
	SIGNAL ball_x4  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(350, 11);
	SIGNAL ball_y4  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
	SIGNAL ball_x5  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(450, 11);
	SIGNAL ball_y5  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
	SIGNAL ball_x6  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(550, 11);
	SIGNAL ball_y6  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
	SIGNAL ball_x7  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(650, 11);
	SIGNAL ball_y7  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
	SIGNAL ball_x8  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(750, 11);
	SIGNAL ball_y8  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
	SIGNAL ball_x9  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
	SIGNAL ball_y9  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
	SIGNAL ball_x10  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
	SIGNAL ball_y10  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
	SIGNAL ball_x11  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(250, 11);
	SIGNAL ball_y11  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
	SIGNAL ball_x12  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(350, 11);
	SIGNAL ball_y12  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
	SIGNAL ball_x13  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(450, 11);
	SIGNAL ball_y13  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
	SIGNAL ball_x14  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(550, 11);
	SIGNAL ball_y14  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
	SIGNAL ball_x15  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(650, 11);
	SIGNAL ball_y15  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
	SIGNAL ball_x16  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(750, 11);
	SIGNAL ball_y16  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);	
	-- current ball motion - initialized to 0 pixels/frame (00000000000)
	SIGNAL ball_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
	SIGNAL ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
BEGIN
	red <= NOT ball_on(1) AND NOT ball_on(4) AND NOT ball_on(7) AND NOT ball_on(10) AND NOT ball_on(13) AND NOT ball_on(16) AND NOT ball_on(0);
	green <= NOT ball_on(2) AND NOT ball_on(5) AND NOT ball_on(8) AND NOT ball_on(11) AND NOT ball_on(14) AND NOT ball_on(0);
	blue  <= NOT ball_on(3) AND NOT ball_on(6) AND NOT ball_on(9) AND NOT ball_on(12) AND NOT ball_on(15) AND NOT ball_on(0);
	
	-- process to draw ball current pixel address is covered by ball position
	bdraw0 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(0) <= '1';
		END IF;
		END PROCESS;
		
	bdraw1 : PROCESS (ball_x1, ball_y1) IS
	BEGIN
		IF (pixel_col >= ball_x1 - size_rest) AND
		 (pixel_col <= ball_x1 + size_rest) AND
			 (pixel_row >= ball_y1 - size_rest) AND
			 (pixel_row <= ball_y1 + size_rest) THEN
				ball_on(1) <= '1';
		END IF;
		END PROCESS;
		
	bdraw2 : PROCESS (ball_x2, ball_y2) IS
	BEGIN
		IF (pixel_col >= ball_x2 - size_rest) AND
		 (pixel_col <= ball_x2 + size_rest) AND
			 (pixel_row >= ball_y2 - size_rest) AND
			 (pixel_row <= ball_y2 + size_rest) THEN
				ball_on(2) <= '1';
		END IF;
		END PROCESS;
		
	bdraw3 : PROCESS (ball_x3, ball_y3) IS
	BEGIN
		IF (pixel_col >= ball_x3 - size_rest) AND
		 (pixel_col <= ball_x3 + size_rest) AND
			 (pixel_row >= ball_y3 - size_rest) AND
			 (pixel_row <= ball_y3 + size_rest) THEN
				ball_on(3) <= '1';
		END IF;
		END PROCESS;
	bdraw4 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(4) <= '1';
		END IF;
		END PROCESS;
	bdraw5 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(5) <= '1';
		END IF;
		END PROCESS;
	bdraw6 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(6) <= '1';
		END IF;
		END PROCESS;
	bdraw7 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(7) <= '1';
		END IF;
		END PROCESS;
	bdraw8 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(8) <= '1';
		END IF;
		END PROCESS;
	bdraw9 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(9) <= '1';
		END IF;
		END PROCESS;
	bdraw10 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(10) <= '1';
		END IF;
		END PROCESS;
	bdraw11 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(11) <= '1';
		END IF;
		END PROCESS;
	bdraw12 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(12) <= '1';
		END IF;
		END PROCESS;
	bdraw13 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(13) <= '1';
		END IF;
		END PROCESS;
	bdraw14 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(14) <= '1';
		END IF;
		END PROCESS;
	bdraw15 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(15) <= '1';
		END IF;
		END PROCESS;
	bdraw16 : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= cursor_x - cursor_size) AND
		 (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				ball_on(16) <= '1';
		END IF;
		END PROCESS;
		
		-- process to move ball once every frame (i.e. once every vsync pulse)
		mball : PROCESS
		BEGIN
			WAIT UNTIL rising_edge(v_sync);
			
			IF BTNU = '1' AND cursor_y + (2*cursor_size) <= 600 THEN
			     ball_y_motion <= "11111111100";
			ELSIF BTND = '1' AND cursor_y >= (2*cursor_size) THEN
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
--color: PROCESS (SW) IS
--BEGIN
	--red <= SW(0) OR NOT ball_on;
    --green <= SW(1) OR NOT ball_on;
    --blue <= SW(2) OR NOT ball_on;
--END PROCESS;
