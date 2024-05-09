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
		BTNU      : IN std_logic;
		BTND      : IN std_logic;
		BTNL      : IN std_logic;
		BTNR      : IN std_logic
	);
END ball;

ARCHITECTURE Behavioral OF ball IS
    type c_mem_t is array (0 to 47) of std_logic_vector(10 downto 0);
    signal ballx : c_mem_t;     -- NOTE: We refer to the colored squares as 'balls'
    signal bally : c_mem_t;     --        Do NOT question this!
	signal cursor_size  : INTEGER := 6;    -- "RADIUS"
	signal cursor_size_mod : INTEGER := 6;    --Modifier for our cursor's size
	CONSTANT ball_size :   INTEGER := 50;
	SIGNAL ball_on : STD_LOGIC_VECTOR(47 DOWNTO 0) := "000000000000000000000000000000000000000000000000"; -- indicates whether ball is over current pixel position
	SIGNAL cursor_on : STD_LOGIC; -- indicates whether cursor is over current pixel position
	-- current ball position - intitialized to center of screen
	SIGNAL cursor_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL cursor_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	-- current ball motion - initialized to 0 pixels/frame (00000000000)
	SIGNAL cursor_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
	SIGNAL cursor_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
BEGIN
    
    -- sets the X and Y coordinates for the centers of each of the balls
    ballx(0) <= CONV_STD_LOGIC_VECTOR(50, 11);
    ballx(1) <= CONV_STD_LOGIC_VECTOR(150, 11);
    ballx(2) <= CONV_STD_LOGIC_VECTOR(250, 11);
    ballx(3) <= CONV_STD_LOGIC_VECTOR(350, 11);
    ballx(4) <= CONV_STD_LOGIC_VECTOR(450, 11);
    ballx(5) <= CONV_STD_LOGIC_VECTOR(550, 11);
    ballx(6) <= CONV_STD_LOGIC_VECTOR(650, 11);
    ballx(7) <= CONV_STD_LOGIC_VECTOR(750, 11);
    ballx(8) <= CONV_STD_LOGIC_VECTOR(50, 11);
    ballx(9) <= CONV_STD_LOGIC_VECTOR(150, 11);
    ballx(10) <= CONV_STD_LOGIC_VECTOR(250, 11);
    ballx(11) <= CONV_STD_LOGIC_VECTOR(350, 11);
    ballx(12) <= CONV_STD_LOGIC_VECTOR(450, 11);
    ballx(13) <= CONV_STD_LOGIC_VECTOR(550, 11);
    ballx(14) <= CONV_STD_LOGIC_VECTOR(650, 11);
    ballx(15) <= CONV_STD_LOGIC_VECTOR(750, 11);
    ballx(16) <= CONV_STD_LOGIC_VECTOR(50, 11);
    ballx(17) <= CONV_STD_LOGIC_VECTOR(150, 11);
    ballx(18) <= CONV_STD_LOGIC_VECTOR(250, 11);
    ballx(19) <= CONV_STD_LOGIC_VECTOR(350, 11);
    ballx(20) <= CONV_STD_LOGIC_VECTOR(450, 11);
    ballx(21) <= CONV_STD_LOGIC_VECTOR(550, 11);
    ballx(22) <= CONV_STD_LOGIC_VECTOR(650, 11);
    ballx(23) <= CONV_STD_LOGIC_VECTOR(750, 11);
    
    ballx(24) <= CONV_STD_LOGIC_VECTOR(50, 11);
    ballx(25) <= CONV_STD_LOGIC_VECTOR(150, 11);
    ballx(26) <= CONV_STD_LOGIC_VECTOR(250, 11);
    ballx(27) <= CONV_STD_LOGIC_VECTOR(350, 11);
    ballx(28) <= CONV_STD_LOGIC_VECTOR(450, 11);
    ballx(29) <= CONV_STD_LOGIC_VECTOR(550, 11);
    ballx(30) <= CONV_STD_LOGIC_VECTOR(650, 11);
    ballx(31) <= CONV_STD_LOGIC_VECTOR(750, 11);
    ballx(32) <= CONV_STD_LOGIC_VECTOR(50, 11);
    ballx(33) <= CONV_STD_LOGIC_VECTOR(150, 11);
    ballx(34) <= CONV_STD_LOGIC_VECTOR(250, 11);
    ballx(35) <= CONV_STD_LOGIC_VECTOR(350, 11);
    ballx(36) <= CONV_STD_LOGIC_VECTOR(450, 11);
    ballx(37) <= CONV_STD_LOGIC_VECTOR(550, 11);
    ballx(38) <= CONV_STD_LOGIC_VECTOR(650, 11);
    ballx(39) <= CONV_STD_LOGIC_VECTOR(750, 11);
    ballx(40) <= CONV_STD_LOGIC_VECTOR(50, 11);
    ballx(41) <= CONV_STD_LOGIC_VECTOR(150, 11);
    ballx(42) <= CONV_STD_LOGIC_VECTOR(250, 11);
    ballx(43) <= CONV_STD_LOGIC_VECTOR(350, 11);
    ballx(44) <= CONV_STD_LOGIC_VECTOR(450, 11);
    ballx(45) <= CONV_STD_LOGIC_VECTOR(550, 11);
    ballx(46) <= CONV_STD_LOGIC_VECTOR(650, 11);
    ballx(47) <= CONV_STD_LOGIC_VECTOR(750, 11);
    
    bally(0) <= CONV_STD_LOGIC_VECTOR(50, 11);
    bally(1) <= CONV_STD_LOGIC_VECTOR(50, 11);
    bally(2) <= CONV_STD_LOGIC_VECTOR(50, 11);
    bally(3) <= CONV_STD_LOGIC_VECTOR(50, 11);
    bally(4) <= CONV_STD_LOGIC_VECTOR(50, 11);
    bally(5) <= CONV_STD_LOGIC_VECTOR(50, 11);
    bally(6) <= CONV_STD_LOGIC_VECTOR(50, 11);
    bally(7) <= CONV_STD_LOGIC_VECTOR(50, 11);
    bally(8) <= CONV_STD_LOGIC_VECTOR(150, 11);
    bally(9) <= CONV_STD_LOGIC_VECTOR(150, 11);
    bally(10) <= CONV_STD_LOGIC_VECTOR(150, 11);
    bally(11) <= CONV_STD_LOGIC_VECTOR(150, 11);
    bally(12) <= CONV_STD_LOGIC_VECTOR(150, 11);
    bally(13) <= CONV_STD_LOGIC_VECTOR(150, 11);
    bally(14) <= CONV_STD_LOGIC_VECTOR(150, 11);
    bally(15) <= CONV_STD_LOGIC_VECTOR(150, 11);
    bally(16) <= CONV_STD_LOGIC_VECTOR(250, 11);
    bally(17) <= CONV_STD_LOGIC_VECTOR(250, 11);
    bally(18) <= CONV_STD_LOGIC_VECTOR(250, 11);
    bally(19) <= CONV_STD_LOGIC_VECTOR(250, 11);
    bally(20) <= CONV_STD_LOGIC_VECTOR(250, 11);
    bally(21) <= CONV_STD_LOGIC_VECTOR(250, 11);
    bally(22) <= CONV_STD_LOGIC_VECTOR(250, 11);
    bally(23) <= CONV_STD_LOGIC_VECTOR(250, 11);
    
    bally(24) <= CONV_STD_LOGIC_VECTOR(350, 11);
    bally(25) <= CONV_STD_LOGIC_VECTOR(350, 11);
    bally(26) <= CONV_STD_LOGIC_VECTOR(350, 11);
    bally(27) <= CONV_STD_LOGIC_VECTOR(350, 11);
    bally(28) <= CONV_STD_LOGIC_VECTOR(350, 11);
    bally(29) <= CONV_STD_LOGIC_VECTOR(350, 11);
    bally(30) <= CONV_STD_LOGIC_VECTOR(350, 11);
    bally(31) <= CONV_STD_LOGIC_VECTOR(350, 11);
    bally(32) <= CONV_STD_LOGIC_VECTOR(450, 11);
    bally(33) <= CONV_STD_LOGIC_VECTOR(450, 11);
    bally(34) <= CONV_STD_LOGIC_VECTOR(450, 11);
    bally(35) <= CONV_STD_LOGIC_VECTOR(450, 11);
    bally(36) <= CONV_STD_LOGIC_VECTOR(450, 11);
    bally(37) <= CONV_STD_LOGIC_VECTOR(450, 11);
    bally(38) <= CONV_STD_LOGIC_VECTOR(450, 11);
    bally(39) <= CONV_STD_LOGIC_VECTOR(450, 11);
    bally(40) <= CONV_STD_LOGIC_VECTOR(550, 11);
    bally(41) <= CONV_STD_LOGIC_VECTOR(550, 11);
    bally(42) <= CONV_STD_LOGIC_VECTOR(550, 11);
    bally(43) <= CONV_STD_LOGIC_VECTOR(550, 11);
    bally(44) <= CONV_STD_LOGIC_VECTOR(550, 11);
    bally(45) <= CONV_STD_LOGIC_VECTOR(550, 11);
    bally(46) <= CONV_STD_LOGIC_VECTOR(550, 11);
    bally(47) <= CONV_STD_LOGIC_VECTOR(550, 11);
    
    
    -- color stuff
    red <= NOT ball_on(0) AND NOT ball_on(3) AND NOT ball_on(6) AND NOT ball_on(9) AND NOT cursor_on AND NOT ball_on(12) AND NOT ball_on(15) AND NOT ball_on(18) AND NOT ball_on(21) AND NOT ball_on(24) AND NOT ball_on(27) AND NOT ball_on(30) AND NOT ball_on(33) AND NOT ball_on(36) AND NOT ball_on(39) AND NOT ball_on(42) AND NOT ball_on(45);
    blue <= NOT ball_on(1) AND NOT ball_on(4) AND NOT ball_on(7) AND NOT ball_on(10) AND NOT cursor_on AND NOT ball_on(13) AND NOT ball_on(16) AND NOT ball_on(19) AND NOT ball_on(22) AND NOT ball_on(25) AND NOT ball_on(28) AND NOT ball_on(31) AND NOT ball_on(34) AND NOT ball_on(37) AND NOT ball_on(40) AND NOT ball_on(43) AND NOT ball_on(46);
    green <= NOT ball_on(2) AND NOT ball_on(5) AND NOT ball_on(8) AND NOT ball_on(11) AND NOT cursor_on AND NOT ball_on(14) AND NOT ball_on(17) AND NOT ball_on(20) AND NOT ball_on(23) AND NOT ball_on(26) AND NOT ball_on(29) AND NOT ball_on(32) AND NOT ball_on(35) AND NOT ball_on(38) AND NOT ball_on(41) AND NOT ball_on(44) AND NOT ball_on(47);
	
	
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
			           (bally(0) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(0) <= '1';END IF;
       ELSE ball_on(0) <= '0'; END IF;
	
       IF (pixel_col >= ballx(1) - ball_size) AND
          (pixel_col <= ballx(1) + ball_size) AND
             (pixel_row >= bally(1) - ball_size) AND
             (pixel_row <= bally(1) + ball_size) THEN
                IF (ballx(1) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(1) + ball_size >= cursor_x + cursor_size) AND
                       (bally(1) - ball_size <= cursor_y - cursor_size) AND
			           (bally(1) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(1) <= '1';END IF;
       ELSE ball_on(1) <= '0'; END IF;
	
       IF (pixel_col >= ballx(2) - ball_size) AND
          (pixel_col <= ballx(2) + ball_size) AND
             (pixel_row >= bally(2) - ball_size) AND
             (pixel_row <= bally(2) + ball_size) THEN
                IF (ballx(2) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(2) + ball_size >= cursor_x + cursor_size) AND
                       (bally(2) - ball_size <= cursor_y - cursor_size) AND
			           (bally(2) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(2) <= '1';END IF;
       ELSE ball_on(2) <= '0'; END IF;
	
       IF (pixel_col >= ballx(3) - ball_size) AND
          (pixel_col <= ballx(3) + ball_size) AND
             (pixel_row >= bally(3) - ball_size) AND
             (pixel_row <= bally(3) + ball_size) THEN
                IF (ballx(3) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(3) + ball_size >= cursor_x + cursor_size) AND
                       (bally(3) - ball_size <= cursor_y - cursor_size) AND
			           (bally(3) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(3) <= '1';END IF;
       ELSE ball_on(3) <= '0'; END IF;
	
       IF (pixel_col >= ballx(4) - ball_size) AND
          (pixel_col <= ballx(4) + ball_size) AND
             (pixel_row >= bally(4) - ball_size) AND
             (pixel_row <= bally(4) + ball_size) THEN
                IF (ballx(4) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(4) + ball_size >= cursor_x + cursor_size) AND
                       (bally(4) - ball_size <= cursor_y - cursor_size) AND
			           (bally(4) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(4) <= '1';END IF;
       ELSE ball_on(4) <= '0'; END IF;
	
       IF (pixel_col >= ballx(5) - ball_size) AND
          (pixel_col <= ballx(5) + ball_size) AND
             (pixel_row >= bally(5) - ball_size) AND
             (pixel_row <= bally(5) + ball_size) THEN
                IF (ballx(5) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(5) + ball_size >= cursor_x + cursor_size) AND
                       (bally(5) - ball_size <= cursor_y - cursor_size) AND
			           (bally(5) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(5) <= '1';END IF;
       ELSE ball_on(5) <= '0'; END IF;
	
       IF (pixel_col >= ballx(6) - ball_size) AND
          (pixel_col <= ballx(6) + ball_size) AND
             (pixel_row >= bally(6) - ball_size) AND
             (pixel_row <= bally(6) + ball_size) THEN
                IF (ballx(6) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(6) + ball_size >= cursor_x + cursor_size) AND
                       (bally(6) - ball_size <= cursor_y - cursor_size) AND
			           (bally(6) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(6) <= '1';END IF;
       ELSE ball_on(6) <= '0'; END IF;
	
       IF (pixel_col >= ballx(7) - ball_size) AND
          (pixel_col <= ballx(7) + ball_size) AND
             (pixel_row >= bally(7) - ball_size) AND
             (pixel_row <= bally(7) + ball_size) THEN
                IF (ballx(7) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(7) + ball_size >= cursor_x + cursor_size) AND
                       (bally(7) - ball_size <= cursor_y - cursor_size) AND
			           (bally(7) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(7) <= '1';END IF;
       ELSE ball_on(7) <= '0'; END IF;
	
       IF (pixel_col >= ballx(8) - ball_size) AND
          (pixel_col <= ballx(8) + ball_size) AND
             (pixel_row >= bally(8) - ball_size) AND
             (pixel_row <= bally(8) + ball_size) THEN
                IF (ballx(8) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(8) + ball_size >= cursor_x + cursor_size) AND
                       (bally(8) - ball_size <= cursor_y - cursor_size) AND
			           (bally(8) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(8) <= '1';END IF;
       ELSE ball_on(8) <= '0'; END IF;
	
       IF (pixel_col >= ballx(9) - ball_size) AND
          (pixel_col <= ballx(9) + ball_size) AND
             (pixel_row >= bally(9) - ball_size) AND
             (pixel_row <= bally(9) + ball_size) THEN
                IF (ballx(9) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(9) + ball_size >= cursor_x + cursor_size) AND
                       (bally(9) - ball_size <= cursor_y - cursor_size) AND
			           (bally(9) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(9) <= '1';END IF;
       ELSE ball_on(9) <= '0'; END IF;
	
       IF (pixel_col >= ballx(10) - ball_size) AND
          (pixel_col <= ballx(10) + ball_size) AND
             (pixel_row >= bally(10) - ball_size) AND
             (pixel_row <= bally(10) + ball_size) THEN
                IF (ballx(10) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(10) + ball_size >= cursor_x + cursor_size) AND
                       (bally(10) - ball_size <= cursor_y - cursor_size) AND
			           (bally(10) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(10) <= '1';END IF;
       ELSE ball_on(10) <= '0'; END IF;
       
       IF (pixel_col >= ballx(11) - ball_size) AND
          (pixel_col <= ballx(11) + ball_size) AND
             (pixel_row >= bally(11) - ball_size) AND
             (pixel_row <= bally(11) + ball_size) THEN
                IF (ballx(11) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(11) + ball_size >= cursor_x + cursor_size) AND
                       (bally(11) - ball_size <= cursor_y - cursor_size) AND
			           (bally(11) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(11) <= '1';END IF;
       ELSE ball_on(11) <= '0'; END IF;
       
       IF (pixel_col >= ballx(12) - ball_size) AND
          (pixel_col <= ballx(12) + ball_size) AND
             (pixel_row >= bally(12) - ball_size) AND
             (pixel_row <= bally(12) + ball_size) THEN
                IF (ballx(12) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(12) + ball_size >= cursor_x + cursor_size) AND
                       (bally(12) - ball_size <= cursor_y - cursor_size) AND
			           (bally(12) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(12) <= '1';END IF;
       ELSE ball_on(12) <= '0'; END IF;

IF (pixel_col >= ballx(13) - ball_size) AND
          (pixel_col <= ballx(13) + ball_size) AND
             (pixel_row >= bally(13) - ball_size) AND
             (pixel_row <= bally(13) + ball_size) THEN
                IF (ballx(13) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(13) + ball_size >= cursor_x + cursor_size) AND
                       (bally(13) - ball_size <= cursor_y - cursor_size) AND
			           (bally(13) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(13) <= '1';END IF;
       ELSE ball_on(13) <= '0'; END IF;

IF (pixel_col >= ballx(14) - ball_size) AND
          (pixel_col <= ballx(14) + ball_size) AND
             (pixel_row >= bally(14) - ball_size) AND
             (pixel_row <= bally(14) + ball_size) THEN
                IF (ballx(14) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(14) + ball_size >= cursor_x + cursor_size) AND
                       (bally(14) - ball_size <= cursor_y - cursor_size) AND
			           (bally(14) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(14) <= '1';END IF;
       ELSE ball_on(14) <= '0'; END IF;

IF (pixel_col >= ballx(15) - ball_size) AND
          (pixel_col <= ballx(15) + ball_size) AND
             (pixel_row >= bally(15) - ball_size) AND
             (pixel_row <= bally(15) + ball_size) THEN
                IF (ballx(15) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(15) + ball_size >= cursor_x + cursor_size) AND
                       (bally(15) - ball_size <= cursor_y - cursor_size) AND
			           (bally(15) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(15) <= '1';END IF;
       ELSE ball_on(15) <= '0'; END IF;

IF (pixel_col >= ballx(16) - ball_size) AND
          (pixel_col <= ballx(16) + ball_size) AND
             (pixel_row >= bally(16) - ball_size) AND
             (pixel_row <= bally(16) + ball_size) THEN
                IF (ballx(16) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(16) + ball_size >= cursor_x + cursor_size) AND
                       (bally(16) - ball_size <= cursor_y - cursor_size) AND
			           (bally(16) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(16) <= '1';END IF;
       ELSE ball_on(16) <= '0'; END IF;

IF (pixel_col >= ballx(17) - ball_size) AND
          (pixel_col <= ballx(17) + ball_size) AND
             (pixel_row >= bally(17) - ball_size) AND
             (pixel_row <= bally(17) + ball_size) THEN
                IF (ballx(17) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(17) + ball_size >= cursor_x + cursor_size) AND
                       (bally(17) - ball_size <= cursor_y - cursor_size) AND
			           (bally(17) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(17) <= '1';END IF;
       ELSE ball_on(17) <= '0'; END IF;

IF (pixel_col >= ballx(18) - ball_size) AND
          (pixel_col <= ballx(18) + ball_size) AND
             (pixel_row >= bally(18) - ball_size) AND
             (pixel_row <= bally(18) + ball_size) THEN
                IF (ballx(18) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(18) + ball_size >= cursor_x + cursor_size) AND
                       (bally(18) - ball_size <= cursor_y - cursor_size) AND
			           (bally(18) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(18) <= '1';END IF;
       ELSE ball_on(18) <= '0'; END IF;

IF (pixel_col >= ballx(19) - ball_size) AND
          (pixel_col <= ballx(19) + ball_size) AND
             (pixel_row >= bally(19) - ball_size) AND
             (pixel_row <= bally(19) + ball_size) THEN
                IF (ballx(19) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(19) + ball_size >= cursor_x + cursor_size) AND
                       (bally(19) - ball_size <= cursor_y - cursor_size) AND
			           (bally(19) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(19) <= '1';END IF;
       ELSE ball_on(19) <= '0'; END IF;

IF (pixel_col >= ballx(20) - ball_size) AND
          (pixel_col <= ballx(20) + ball_size) AND
             (pixel_row >= bally(20) - ball_size) AND
             (pixel_row <= bally(20) + ball_size) THEN
                IF (ballx(20) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(20) + ball_size >= cursor_x + cursor_size) AND
                       (bally(20) - ball_size <= cursor_y - cursor_size) AND
			           (bally(20) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(20) <= '1';END IF;
       ELSE ball_on(20) <= '0'; END IF;

IF (pixel_col >= ballx(21) - ball_size) AND
          (pixel_col <= ballx(21) + ball_size) AND
             (pixel_row >= bally(21) - ball_size) AND
             (pixel_row <= bally(21) + ball_size) THEN
                IF (ballx(21) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(21) + ball_size >= cursor_x + cursor_size) AND
                       (bally(21) - ball_size <= cursor_y - cursor_size) AND
			           (bally(21) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(21) <= '1';END IF;
       ELSE ball_on(21) <= '0'; END IF;

IF (pixel_col >= ballx(22) - ball_size) AND
          (pixel_col <= ballx(22) + ball_size) AND
             (pixel_row >= bally(22) - ball_size) AND
             (pixel_row <= bally(22) + ball_size) THEN
                IF (ballx(22) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(22) + ball_size >= cursor_x + cursor_size) AND
                       (bally(22) - ball_size <= cursor_y - cursor_size) AND
			           (bally(22) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(22) <= '1';END IF;
       ELSE ball_on(22) <= '0'; END IF;

IF (pixel_col >= ballx(23) - ball_size) AND
          (pixel_col <= ballx(23) + ball_size) AND
             (pixel_row >= bally(23) - ball_size) AND
             (pixel_row <= bally(23) + ball_size) THEN
                IF (ballx(23) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(23) + ball_size >= cursor_x + cursor_size) AND
                       (bally(23) - ball_size <= cursor_y - cursor_size) AND
			           (bally(23) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(23) <= '1';END IF;
       ELSE ball_on(23) <= '0'; END IF;

IF (pixel_col >= ballx(24) - ball_size) AND
          (pixel_col <= ballx(24) + ball_size) AND
             (pixel_row >= bally(24) - ball_size) AND
             (pixel_row <= bally(24) + ball_size) THEN
                IF (ballx(24) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(24) + ball_size >= cursor_x + cursor_size) AND
                       (bally(24) - ball_size <= cursor_y - cursor_size) AND
			           (bally(24) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(24) <= '1';END IF;
       ELSE ball_on(24) <= '0'; END IF;

IF (pixel_col >= ballx(25) - ball_size) AND
          (pixel_col <= ballx(25) + ball_size) AND
             (pixel_row >= bally(25) - ball_size) AND
             (pixel_row <= bally(25) + ball_size) THEN
                IF (ballx(25) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(25) + ball_size >= cursor_x + cursor_size) AND
                       (bally(25) - ball_size <= cursor_y - cursor_size) AND
			           (bally(25) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(25) <= '1';END IF;
       ELSE ball_on(25) <= '0'; END IF;

IF (pixel_col >= ballx(26) - ball_size) AND
          (pixel_col <= ballx(26) + ball_size) AND
             (pixel_row >= bally(26) - ball_size) AND
             (pixel_row <= bally(26) + ball_size) THEN
                IF (ballx(26) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(26) + ball_size >= cursor_x + cursor_size) AND
                       (bally(26) - ball_size <= cursor_y - cursor_size) AND
			           (bally(26) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(26) <= '1';END IF;
       ELSE ball_on(26) <= '0'; END IF;

IF (pixel_col >= ballx(27) - ball_size) AND
          (pixel_col <= ballx(27) + ball_size) AND
             (pixel_row >= bally(27) - ball_size) AND
             (pixel_row <= bally(27) + ball_size) THEN
                IF (ballx(27) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(27) + ball_size >= cursor_x + cursor_size) AND
                       (bally(27) - ball_size <= cursor_y - cursor_size) AND
			           (bally(27) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(27) <= '1';END IF;
       ELSE ball_on(27) <= '0'; END IF;

IF (pixel_col >= ballx(28) - ball_size) AND
          (pixel_col <= ballx(28) + ball_size) AND
             (pixel_row >= bally(28) - ball_size) AND
             (pixel_row <= bally(28) + ball_size) THEN
                IF (ballx(28) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(28) + ball_size >= cursor_x + cursor_size) AND
                       (bally(28) - ball_size <= cursor_y - cursor_size) AND
			           (bally(28) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(28) <= '1';END IF;
       ELSE ball_on(28) <= '0'; END IF;

IF (pixel_col >= ballx(29) - ball_size) AND
          (pixel_col <= ballx(29) + ball_size) AND
             (pixel_row >= bally(29) - ball_size) AND
             (pixel_row <= bally(29) + ball_size) THEN
                IF (ballx(29) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(29) + ball_size >= cursor_x + cursor_size) AND
                       (bally(29) - ball_size <= cursor_y - cursor_size) AND
			           (bally(29) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(29) <= '1';END IF;
       ELSE ball_on(29) <= '0'; END IF;

IF (pixel_col >= ballx(30) - ball_size) AND
          (pixel_col <= ballx(30) + ball_size) AND
             (pixel_row >= bally(30) - ball_size) AND
             (pixel_row <= bally(30) + ball_size) THEN
                IF (ballx(30) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(30) + ball_size >= cursor_x + cursor_size) AND
                       (bally(30) - ball_size <= cursor_y - cursor_size) AND
			           (bally(30) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(30) <= '1';END IF;
       ELSE ball_on(30) <= '0'; END IF;

IF (pixel_col >= ballx(31) - ball_size) AND
          (pixel_col <= ballx(31) + ball_size) AND
             (pixel_row >= bally(31) - ball_size) AND
             (pixel_row <= bally(31) + ball_size) THEN
                IF (ballx(31) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(31) + ball_size >= cursor_x + cursor_size) AND
                       (bally(31) - ball_size <= cursor_y - cursor_size) AND
			           (bally(31) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(31) <= '1';END IF;
       ELSE ball_on(31) <= '0'; END IF;

IF (pixel_col >= ballx(32) - ball_size) AND
          (pixel_col <= ballx(32) + ball_size) AND
             (pixel_row >= bally(32) - ball_size) AND
             (pixel_row <= bally(32) + ball_size) THEN
                IF (ballx(32) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(32) + ball_size >= cursor_x + cursor_size) AND
                       (bally(32) - ball_size <= cursor_y - cursor_size) AND
			           (bally(32) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(32) <= '1';END IF;
       ELSE ball_on(32) <= '0'; END IF;

IF (pixel_col >= ballx(33) - ball_size) AND
          (pixel_col <= ballx(33) + ball_size) AND
             (pixel_row >= bally(33) - ball_size) AND
             (pixel_row <= bally(33) + ball_size) THEN
                IF (ballx(33) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(33) + ball_size >= cursor_x + cursor_size) AND
                       (bally(33) - ball_size <= cursor_y - cursor_size) AND
			           (bally(33) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(33) <= '1';END IF;
       ELSE ball_on(33) <= '0'; END IF;

IF (pixel_col >= ballx(34) - ball_size) AND
          (pixel_col <= ballx(34) + ball_size) AND
             (pixel_row >= bally(34) - ball_size) AND
             (pixel_row <= bally(34) + ball_size) THEN
                IF (ballx(34) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(34) + ball_size >= cursor_x + cursor_size) AND
                       (bally(34) - ball_size <= cursor_y - cursor_size) AND
			           (bally(34) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(34) <= '1';END IF;
       ELSE ball_on(34) <= '0'; END IF;

IF (pixel_col >= ballx(35) - ball_size) AND
          (pixel_col <= ballx(35) + ball_size) AND
             (pixel_row >= bally(35) - ball_size) AND
             (pixel_row <= bally(35) + ball_size) THEN
                IF (ballx(35) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(35) + ball_size >= cursor_x + cursor_size) AND
                       (bally(35) - ball_size <= cursor_y - cursor_size) AND
			           (bally(35) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(35) <= '1';END IF;
       ELSE ball_on(35) <= '0'; END IF;

IF (pixel_col >= ballx(36) - ball_size) AND
          (pixel_col <= ballx(36) + ball_size) AND
             (pixel_row >= bally(36) - ball_size) AND
             (pixel_row <= bally(36) + ball_size) THEN
                IF (ballx(36) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(36) + ball_size >= cursor_x + cursor_size) AND
                       (bally(36) - ball_size <= cursor_y - cursor_size) AND
			           (bally(36) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(36) <= '1';END IF;
       ELSE ball_on(36) <= '0'; END IF;

IF (pixel_col >= ballx(37) - ball_size) AND
          (pixel_col <= ballx(37) + ball_size) AND
             (pixel_row >= bally(37) - ball_size) AND
             (pixel_row <= bally(37) + ball_size) THEN
                IF (ballx(37) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(37) + ball_size >= cursor_x + cursor_size) AND
                       (bally(37) - ball_size <= cursor_y - cursor_size) AND
			           (bally(37) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(37) <= '1';END IF;
       ELSE ball_on(37) <= '0'; END IF;

IF (pixel_col >= ballx(38) - ball_size) AND
          (pixel_col <= ballx(38) + ball_size) AND
             (pixel_row >= bally(38) - ball_size) AND
             (pixel_row <= bally(38) + ball_size) THEN
                IF (ballx(38) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(38) + ball_size >= cursor_x + cursor_size) AND
                       (bally(38) - ball_size <= cursor_y - cursor_size) AND
			           (bally(38) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(38) <= '1';END IF;
       ELSE ball_on(38) <= '0'; END IF;

IF (pixel_col >= ballx(39) - ball_size) AND
          (pixel_col <= ballx(39) + ball_size) AND
             (pixel_row >= bally(39) - ball_size) AND
             (pixel_row <= bally(39) + ball_size) THEN
                IF (ballx(39) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(39) + ball_size >= cursor_x + cursor_size) AND
                       (bally(39) - ball_size <= cursor_y - cursor_size) AND
			           (bally(39) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(39) <= '1';END IF;
       ELSE ball_on(39) <= '0'; END IF;

IF (pixel_col >= ballx(40) - ball_size) AND
          (pixel_col <= ballx(40) + ball_size) AND
             (pixel_row >= bally(40) - ball_size) AND
             (pixel_row <= bally(40) + ball_size) THEN
                IF (ballx(40) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(40) + ball_size >= cursor_x + cursor_size) AND
                       (bally(40) - ball_size <= cursor_y - cursor_size) AND
			           (bally(40) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(40) <= '1';END IF;
       ELSE ball_on(40) <= '0'; END IF;

IF (pixel_col >= ballx(41) - ball_size) AND
          (pixel_col <= ballx(41) + ball_size) AND
             (pixel_row >= bally(41) - ball_size) AND
             (pixel_row <= bally(41) + ball_size) THEN
                IF (ballx(41) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(41) + ball_size >= cursor_x + cursor_size) AND
                       (bally(41) - ball_size <= cursor_y - cursor_size) AND
			           (bally(41) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(41) <= '1';END IF;
       ELSE ball_on(41) <= '0'; END IF;

IF (pixel_col >= ballx(42) - ball_size) AND
          (pixel_col <= ballx(42) + ball_size) AND
             (pixel_row >= bally(42) - ball_size) AND
             (pixel_row <= bally(42) + ball_size) THEN
                IF (ballx(42) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(42) + ball_size >= cursor_x + cursor_size) AND
                       (bally(42) - ball_size <= cursor_y - cursor_size) AND
			           (bally(42) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(42) <= '1';END IF;
       ELSE ball_on(42) <= '0'; END IF;

IF (pixel_col >= ballx(43) - ball_size) AND
          (pixel_col <= ballx(43) + ball_size) AND
             (pixel_row >= bally(43) - ball_size) AND
             (pixel_row <= bally(43) + ball_size) THEN
                IF (ballx(43) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(43) + ball_size >= cursor_x + cursor_size) AND
                       (bally(43) - ball_size <= cursor_y - cursor_size) AND
			           (bally(43) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(43) <= '1';END IF;
       ELSE ball_on(43) <= '0'; END IF;

IF (pixel_col >= ballx(44) - ball_size) AND
          (pixel_col <= ballx(44) + ball_size) AND
             (pixel_row >= bally(44) - ball_size) AND
             (pixel_row <= bally(44) + ball_size) THEN
                IF (ballx(44) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(44) + ball_size >= cursor_x + cursor_size) AND
                       (bally(44) - ball_size <= cursor_y - cursor_size) AND
			           (bally(44) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(44) <= '1';END IF;
       ELSE ball_on(44) <= '0'; END IF;

IF (pixel_col >= ballx(45) - ball_size) AND
          (pixel_col <= ballx(45) + ball_size) AND
             (pixel_row >= bally(45) - ball_size) AND
             (pixel_row <= bally(45) + ball_size) THEN
                IF (ballx(45) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(45) + ball_size >= cursor_x + cursor_size) AND
                       (bally(45) - ball_size <= cursor_y - cursor_size) AND
			           (bally(45) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(45) <= '1';END IF;
       ELSE ball_on(45) <= '0'; END IF;

IF (pixel_col >= ballx(46) - ball_size) AND
          (pixel_col <= ballx(46) + ball_size) AND
             (pixel_row >= bally(46) - ball_size) AND
             (pixel_row <= bally(46) + ball_size) THEN
                IF (ballx(46) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(46) + ball_size >= cursor_x + cursor_size) AND
                       (bally(46) - ball_size <= cursor_y - cursor_size) AND
			           (bally(46) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(46) <= '1';END IF;
       ELSE ball_on(46) <= '0'; END IF;

IF (pixel_col >= ballx(47) - ball_size) AND
          (pixel_col <= ballx(47) + ball_size) AND
             (pixel_row >= bally(47) - ball_size) AND
             (pixel_row <= bally(47) + ball_size) THEN
                IF (ballx(47) - ball_size <= cursor_x - cursor_size) AND
                   (ballx(47) + ball_size >= cursor_x + cursor_size) AND
                       (bally(47) - ball_size <= cursor_y - cursor_size) AND
			           (bally(47) + ball_size >= cursor_y + cursor_size) THEN
			                ball_on(47) <= '1';END IF;
       ELSE ball_on(47) <= '0'; END IF;
       
    END PROCESS;
    
	
	-- process to change the cursor's size when the switches are pressed.
	cursorSZ : process (SW) is
    begin
        cursor_size <= cursor_size_mod*conv_integer(SW) + 1;
    end process;
    
	
	-- process to draw cursor current pixel address is covered by cursor position
	draw_cursor : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
		IF (((conv_integer (pixel_col) - conv_integer (cursor_x))**2 + (conv_integer(pixel_row) - conv_integer (cursor_y))**2) <= cursor_size**2) THEN
				cursor_on <= '1';
		ELSE
			cursor_on <= '0';
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
