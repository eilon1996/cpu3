
-- in: IR[7,0], imm_in(3-state)
--out: duplicate the last digit to reach length 16

LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY SignExt IS
  GENERIC (length : INTEGER := 16);
  PORT ( immidiet: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
         immidiet_extend: OUT STD_LOGIC_VECTOR (length-1 DOWNTO 0));
END SignExt;
------------------------------------------------
ARCHITECTURE rtl OF SignExt IS
BEGIN
  PROCESS (immidiet)
  BEGIN

    FOR i IN 0 TO 7 LOOP
        immidiet_extend(i) <= immidiet(i);
    END LOOP;
    FOR i IN 8 TO length-1 LOOP
        immidiet_extend(i) <= immidiet(7);
    END LOOP;
  END PROCESS;

END rtl;

