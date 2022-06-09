LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity Control is

	generic(    OPC_length: integer := 4;
    Dwidth: integer := 16;
    Awidth: integer := 6);
	port(
        rst, ena, clk: in std_logic;    --from tb
        done: out std_logic;            --to tb
		mov, done_code, nop, jnc, jc, jmp, sub, add, Nflag, Zflag, Cflag : in std_logic;  --status
		Cout, Cin, Ain, RF_writeEn_control, RFout, IRin, PCin, Imm_in : out std_logic;    --control
        PCsel, RFaddr: out std_logic_vector(1 downto 0);                                  --control
        OPC_in: in std_logic_vector(OPC_length-1 downto 0);                                       --control
        OPC: out std_logic_vector(OPC_length-1 downto 0)                                       --control
    );
end Control;

architecture arc_sys of Control is

signal control_vector : std_logic_vector(n downto 0);

-----------logic-------

-- reset                                        |
-- PC <= 0                                      |   PCsel <= reset, state<=fetch

-- fetch                                        |   no need for us
-- PM_read_addr <= PC                           |   happand automatic, state<=decode
--
-- decode                                       |
-- 1 - IR <= PM_data  , PC <= PC + 1            |   IRin, PCsel <= plus1, state<=determain_by_opc

-- add/sub                                      |
-- 2 - A <= R[rb]                               |   Ain, RFsel <= rb, RFout, state<=add_3/sub_3
-- 3 - C <= A +/- R[rc]                         |   Cin, RFsel <= rc, RFout, state<=R_type_4
-- 4 - R[ra] <= C                               |   Cout, RFsel <= ra, RF_en_write , state<=fetch

-- nop  -- ? can be we asume that ra is 0? if so combain with add
-- 2 - A <= R[0]                                |   Ain, RFsel <= zero, RFout, state<=
-- 3 - C <= A + R[0]                            |   Cin, RFsel <= zero, RFout, state<=
-- 4 - R[0] <= C                                |   Cout, RFsel <= zero, RF_en_write , state<=fetch


-- Jmp/Jc/jnc
-- 2 - if(cond): pc = pc+offset                 |   if(cond) PCsel<=offset, state<=fetch

-- mov
-- 2 - R[ra] <= immidiet                        |   imm_in, RFsel <= ra, RF_en_write, state<=fetch

-- inc
-- 2 - C <= R[ra] + 1                           |   RFsel <= ra, RFout, Cin, state<=inc_3
-- 3 - R[ra] <= C                               |   RFsel <= ra, Cout, RF_en_write, state<=fetch

-- done
-- 2 - done                                     |   done, state<=state

constant state_id_fetch      : std_logic_vector(3 downto 0) := "0000";
constant state_id_decode     : std_logic_vector(3 downto 0) := "0001";

constant state_id_R_type_2   : std_logic_vector(3 downto 0) := "0010";
constant state_id_R_type_4   : std_logic_vector(3 downto 0) := "0011";

constant state_id_add_3      : std_logic_vector(3 downto 0) := "0100";
constant state_id_sub_3      : std_logic_vector(3 downto 0) := "0101";

constant state_id_nop_2      : std_logic_vector(3 downto 0) := "0100";
constant state_id_nop_3      : std_logic_vector(3 downto 0) := "0110";
constant state_id_nop_4      : std_logic_vector(3 downto 0) := "0111";

constant state_id_J_type_2   : std_logic_vector(3 downto 0) := "1000";

constant state_id_mov_2      : std_logic_vector(3 downto 0) := "1001";

constant state_id_inc_2      : std_logic_vector(3 downto 0) := "1010";
constant state_id_inc_3      : std_logic_vector(3 downto 0) := "1011";

constant state_id_done       : std_logic_vector(3 downto 0) := "1100";





if(state=state_id_nop_4 or state=state_id_R_type_4 or state=state_id_inc_3)     
    then Cout   <=  '1'; else Cout   <=  '0'; end if;
if(state=state_id_nop_3 or state=state_id_add_3 or state=state_id_sub_3 or state=state_id_inc_2)     
    then Cin    <=  '1'; else Cin    <=  '0'; end if;
if(state=state_id_nop_2 or state=state_id_R_type_2)     
    then Ain   <=  '1'; else Ain   <=  '0'; end if;
if(state=state_id_nop_4 or state=state_id_R_type_4 or state=state_id_inc_3 or state=state_id_mov_2)     
    then RF_writeEn_control   <=  '1'; else RF_writeEn_control   <=  '0'; end if;


if(state=state_id_nop_2 or state=state_id_R_type_2 or state=state_id_nop_3 or state=state_id_add_3 or state=state_id_sub_3 or state=state_id_inc_3)     
    then RFout   <=  '1'; else RFout   <=  '0'; end if;
if(state=state_id_nop_3 or state=state_id_add_3 or state=state_id_sub_3 or state=state_id_inc_2)     
    then IRin    <=  '1'; else IRin    <=  '0'; end if;
if(state=state_id_nop_2 or state=state_id_R_type_2)     
    then PCin   <=  '1'; else PCin   <=  '0'; end if;
if(state=state_id_nop_4 or state=state_id_R_type_4 or state=state_id_inc_3 or state=state_id_mov_2)     
    then Imm_in   <=  '1'; else Imm_in   <=  '0'; end if;


Cout    <=  '1' when (state=state_id_nop_4 or state=state_id_R_type_4 or state=state_id_inc_3) else '0';
Cin     <=  '1' when (state=state_id_nop_3 or state=state_id_add_3 or state=state_id_sub_3 or state=state_id_inc_2) else '0';
Ain     <=  '1' when (state=state_id_nop_2 or state=state_id_R_type_2) else '0';
RF_writeEn_control  <=  when (state=state_id_nop_4 or state=state_id_R_type_4 or state=state_id_inc_3 or state=state_id_mov_2) else '0';
RFout   <=  '0';
IRin    <=  '0';
PCin    <=  '0';
Imm_in  <=  '0';
RFaddr  <=  "00";
- OPC     <=  "0000";
done    <=  '0';
PCsel <= "01" when (jmp='1' or (jc='1' and Cflag='1') or (jnc='1' and Cflag='0')) else "10";
state := 0;


signal opc_type : std_logic_vector(1 downto 0);


--subtype opc_type is  std_logic_vector(1 downto 0);
constant R_type   : std_logic_vector(1 downto 0) := "00";
constant J_type   : std_logic_vector(1 downto 0) := "01";
constant I_type   : std_logic_vector(1 downto 0) := "10";

BEGIN

OPC <= OPC_in;
opc_type <= opc_in(OPC_length-1 downto OPC_length-2);
PCsel <= "01" when (jmp='1' or (jc='1' and Cflag='1') or (jnc='1' and Cflag='0')) else "10";


FSM_PROC : process(clk)
variable state :integer range 1 to 4 :=1;
begin
    if rst = '1' then
        Cout    <=  '0';
        Cin     <=  '0';
        Ain     <=  '0';
        RF_writeEn_control  <=  '0';
        RFout   <=  '0';
        IRin    <=  '0';
        PCin    <=  '0';
        Imm_in  <=  '0';
        RFaddr  <=  "00";
       -- OPC     <=  "0000";
        done    <=  '0';
        state := 0;

    elsif ena = '0' then
        Cout    <=  '0';
        Cin     <=  '0';
        Ain     <=  '0';
        RF_writeEn_control  <=  '0';
        RFout   <=  '0';
        IRin    <=  '0';
        PCin    <=  '0';
        Imm_in  <=  '0';
        RFaddr  <=  "00";
       -- OPC     <=  "0000";
        done    <=  '0';
        state := state;

    elsif done_code = '1' then
        Cout    <=  '0';
        Cin     <=  '0';
        Ain     <=  '0';
        RF_writeEn_control  <=  '0';
        RFout   <=  '0';
        IRin    <=  '0';
        PCin    <=  '0';
        Imm_in  <=  '0';
        RFaddr  <=  "00";
       -- OPC     <=  "0000";
        done    <=  '1';
        state := 0;

    elsif rising_edge(clk) then
        case state is

            when 1 =>

                if nop='1' then
                -- insert ra to RF, Ra to A
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '1';
                    RF_writeEn_control  <=  '0';
                    RFout   <=  '1';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "11";
                   -- OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;
                elsif opc_type=R_type then
                -- insert ra to RF, Ra to A
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '1';
                    RF_writeEn_control  <=  '0';
                    RFout   <=  '1';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                   -- OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;
                elsif opc_type=J_type then
                -- pc = pc+offset
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '1';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                   -- OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;

                elsif opc_type=I_type then
                -- insert ra to writeAddr, RF_writeEn_control, immidiet + sign extention to bus,
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '1';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '1';
                    RFaddr  <=  "00";
                   -- OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;
                else
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                   -- OPC     <=  "0000";
                    done    <=  '0';
                    state := state;
                end if;

            when 2 =>

                if nop='1' then
                -- rb to RF, Rb to b, b calc with A to C
                    Cout    <=  '0';
                    Cin     <=  '1';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '0';
                    RFout   <=  '1';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "11";
                   -- OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;
                elsif opc_type=R_type then
                -- rb to RF, Rb to b, b calc with A to C
                    Cout    <=  '0';
                    Cin     <=  '1';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '0';
                    RFout   <=  '1';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "01";
                   -- OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;

                elsif opc_type=J_type then
                -- pc = pc+offset
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '1';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                   -- OPC     <=  "0000";
                    done    <=  '1';
                    state := 0;

                elsif opc_type=I_type then
                -- insert ra to writeAddr, RF_writeEn_control, immidiet + sign extention to bus,
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '1';
                    RFaddr  <=  "00";
                   -- OPC     <=  "0000";
                    done    <=  '1';
                    state := 0;
                else
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                   -- OPC     <=  "0000";
                    done    <=  '0';
                    state := state;

                end if;

            when 3 =>
                if opc_type=R_type then
                -- insert rc to RF + enable writing, cout
                    Cout    <=  '1';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '1';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "11";
                   -- OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;
                elsif opc_type=R_type then
                -- insert rc to RF + enable writing, cout
                    Cout    <=  '1';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '1';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "10";
                   -- OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;
                else
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                   -- OPC     <=  "0000";
                    done    <=  '0';
                    state := state;
                end if;
            when 4 =>
                if opc_type=R_type then
                -- insert rc to RF + enable writing, cout
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                   -- OPC     <=  "0000";
                    done    <=  '1';
                    state := 0;
                else
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    RF_writeEn_control  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                   -- OPC     <=  "0000";
                    done    <=  '0';
                    state := state;
                end if;
            end case;
    end if;
end process;

end arc_sys;
