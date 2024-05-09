LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;

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
	SIGNAL ball_on : STD_LOGIC_VECTOR(47 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(0, 48); -- indicates whether ball is over current pixel position
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
	signal black : STD_LOGIC;
	signal white : STD_LOGIC;
BEGIN

--color_proc : PROCESS IS
--BEGIN
   -- WAIT UNTIL rising_edge(v_sync);
    --red <= NOT ball_on(0) AND NOT ball_on(3) AND NOT ball_on(6) AND NOT ball_on(9) AND NOT ball_on(12) AND NOT ball_on(15) AND NOT ball_on(18) AND NOT ball_on(21) AND NOT ball_on(24) AND NOT ball_on(27) AND NOT ball_on(30) AND NOT ball_on(33) AND NOT ball_on(36) AND NOT ball_on(39) AND NOT ball_on(42) AND NOT ball_on(45) AND NOT cursor_on;
	--green <= NOT ball_on(1) AND NOT ball_on(4) AND NOT ball_on(7) AND NOT ball_on(10) AND NOT ball_on(13) AND NOT ball_on(16) AND NOT ball_on(19) AND NOT ball_on(22) AND NOT ball_on(25) AND NOT ball_on(28) AND NOT ball_on(31) AND NOT ball_on(34) AND NOT ball_on(37) AND NOT ball_on(40) AND NOT ball_on(43) AND NOT ball_on(46) AND NOT cursor_on;
	--blue  <= NOT ball_on(2) AND NOT ball_on(5) AND NOT ball_on(8) AND NOT ball_on(11) AND NOT ball_on(14) AND NOT ball_on(17) AND NOT ball_on(20) AND NOT ball_on(23) AND NOT ball_on(26) AND NOT ball_on(29) AND NOT ball_on(32) AND NOT ball_on(35) AND NOT ball_on(38) AND NOT ball_on(41) AND NOT ball_on(44) AND NOT ball_on(47) AND NOT cursor_on;
--END PROCESS;

     -- red <=   NOT cursor_on;
	 -- green <= NOT ball_on(24) AND NOT cursor_on;
     -- blue  <= NOT ball_on(24) AND NOT cursor_on;
    
    -- Checks if any ball should be colored.
    color_proc : PROCESS (ball_on) IS
    BEGIN
    for i in 0 to 46 loop
        red <= ball_on(i) AND cursor_on;
        green <= ball_on(i) AND NOT cursor_on;
        blue <= ball_on(i) AND NOT cursor_on;
    end loop;
    --    tempred <= '1';
    --    tempblue <= '1';
    --    tempgreen <= '1';
    --    for i in 0 to 47 loop
    --   if (real(i+1)/real(3) = ceil(real(i+1)/real(3))) THEN
    --        red <= tempred AND ball_on(i) AND NOT cursor_on;
    --        blue <= tempblue AND NOT ball_on(i) AND NOT cursor_on;
    --        green <= tempgreen AND NOT ball_on(i) AND NOT cursor_on;
    --    elsif (real(i+1)/real(2) = ceil(real(i+1)/real(2))) THEN
    --        red <= tempred AND NOT ball_on(i) AND NOT cursor_on;
   --         blue <= tempblue AND ball_on(i) AND NOT cursor_on;
   --         green <= tempgreen AND NOT ball_on(i) AND NOT cursor_on;
    --    elsif (real(i+1)/real(1) = ceil(real(i+1)/real(1))) THEN
    --        red <= tempred AND NOT ball_on(i) AND NOT cursor_on;
    --        blue <= tempblue AND NOT ball_on(i) AND NOT cursor_on;
    --        green <= tempgreen AND ball_on(i) AND NOT cursor_on;
    --    END IF;
    --    end loop;
    END PROCESS;
    
    forloop : PROCESS IS
    BEGIN
        
        for i in 0 to 5 loop
            for j in 0 to 7 loop
                ballx(temp) <= CONV_STD_LOGIC_VECTOR((j*100)+50, 11);
                bally(temp) <= CONV_STD_LOGIC_VECTOR((i*100)+50, 11);
                temp <= temp + 1;
            end loop;
        end loop;
        wait;
    END PROCESS;
 
    collision : PROCESS (cursor_x,cursor_y) IS
    BEGIN
        for i in 0 to 47 loop
            IF --(pixel_col >= ballx(i) - ball_size) AND
               (ballx(i) - ball_size <= cursor_x - cursor_size) AND
		       --(pixel_col <= ballx(i) + ball_size) AND
		       (ballx(i) + ball_size >= cursor_x + cursor_size) AND
			   --(pixel_row >= bally(i) - ball_size) AND
			   (bally(i) - ball_size <= cursor_y - cursor_size) AND
			   --(pixel_row <= bally(i) + ball_size) AND 
			   (bally(i) + ball_size >= cursor_y + cursor_size) THEN
			     ball_on(i) <= '1';
			     END IF;
			     END LOOP;
    END PROCESS;
    
	
	-- process to draw ball current pixel address is covered by ball position
	--bdraw : PROCESS IS
	--BEGIN
	   --WAIT UNTIL rising_edge(v_sync);
	   
	 --  for i in 0 to 47 loop
	 --      IF (pixel_col >= ballx(i) - ball_size) AND
		--      (pixel_col <= ballx(i) + ball_size) AND
		--	  (pixel_row >= bally(i) - ball_size) AND
		--	  (pixel_row <= bally(i) + ball_size) THEN
		--	     ball_on(i) <= '1';
		 -- END IF;
	   --end loop;
	   --wait;
    --END PROCESS;
	
	-- process to draw cursor current pixel address is covered by cursor position
	draw_cursor : PROCESS (cursor_x, cursor_y, pixel_row, pixel_col) IS
	BEGIN
	   --WAIT UNTIL rising_edge(v_sync);
	
		IF (pixel_col >= cursor_x - cursor_size) AND
		   (pixel_col <= cursor_x + cursor_size) AND
			 (pixel_row >= cursor_y - cursor_size) AND
			 (pixel_row <= cursor_y + cursor_size) THEN
				cursor_on <= '1';
		END IF;
		END PROCESS;
		
	--reset : PROCESS IS
	--BEGIN
	--WAIT UNTIL rising_edge(v_sync);
	--IF BTNC = '1' THEN
	 --  cursor_x <= CONV_STD_LOGIC_VECTOR(400, 11);
	  -- cursor_y <= CONV_STD_LOGIC_VECTOR(300, 11);
	--END IF;
	--END PROCESS;
		
		-- process to move ball once every frame (i.e. once every vsync pulse)
		mball : PROCESS IS
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
			IF BTNC = '1' THEN
	            cursor_x <= CONV_STD_LOGIC_VECTOR(400, 11);
	            cursor_y <= CONV_STD_LOGIC_VECTOR(300, 11);
	        END IF;
			
			cursor_x <= cursor_x + cursor_x_motion; -- compute next ball position
			cursor_y <= cursor_y + cursor_y_motion; -- compute next ball position
		END PROCESS;
END Behavioral;
