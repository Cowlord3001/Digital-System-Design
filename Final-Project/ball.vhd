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
	CONSTANT size0  : INTEGER := 8;    -- "RADIUS"
	CONSTANT size_rest :   INTEGER := 50;
	SIGNAL ball_on : STD_LOGIC_VECTOR(3 DOWNTO 0); -- indicates whether ball / pixel is over current pixel position
	-- current ball position - intitialized to center of screen
	SIGNAL ball_x0  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL ball_y0  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	SIGNAL ball_x1  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
	SIGNAL ball_y1  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
	SIGNAL ball_x2  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(100, 11);
	SIGNAL ball_y2  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(100, 11);
	SIGNAL ball_x3  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
	SIGNAL ball_y3  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
	-- current ball motion - initialized to 0 pixels/frame (00000000000)
	SIGNAL ball_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
	SIGNAL ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
BEGIN
	red <= NOT ball_on(1);
	green <= NOT ball_on(2);
	blue  <= NOT ball_on(3);
	
	
	
	
	-- process to draw ball current pixel address is covered by ball position
	bdraw0 : PROCESS (ball_x0, ball_y0, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= ball_x0 - size0) AND
		 (pixel_col <= ball_x0 + size0) AND
			 (pixel_row >= ball_y0 - size0) AND
			 (pixel_row <= ball_y0 + size0) THEN
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
		
		-- process to move ball once every frame (i.e. once every vsync pulse)
		mball : PROCESS
		BEGIN
			WAIT UNTIL rising_edge(v_sync);
			
			IF BTNU = '1' AND ball_y + (2*size) <= 600 THEN
			     ball_y_motion <= "11111111100";
			ELSIF BTND = '1' AND ball_y >= (2*size) THEN
			     ball_y_motion <= "00000000100";
			ELSE
		         ball_y_motion <= "00000000000";
			END IF;
			
			IF BTNR = '1' AND ball_x + (2*size) <= 800 THEN
			     ball_x_motion <= "00000000100";
			ELSIF BTNL = '1' AND ball_x >= (2*size) THEN
			     ball_x_motion <= "11111111100";
			ELSE
		         ball_x_motion <= "00000000000";
			END IF;
			
			ball_x <= ball_x + ball_x_motion; -- compute next ball position
			ball_y <= ball_y + ball_y_motion; -- compute next ball position
		END PROCESS;
END Behavioral;
