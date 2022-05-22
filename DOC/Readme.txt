lab3 - VHDL
Barry Yosilevich - 208725218
Eilon Toledano - 206903445

.vhd file functional description:


top.vhd:
- Implements a central proccesing unit:
- ports functional description:
 	+ clk, rst, ena: control lines for the unit
	+ PM_write_Addr_TB, RF_write_address_from_TB, RF_read_address_from_TB ,PM_dataIn_TB, TBactive, RF_writeEn_from_TB, PM_writeEn_from_TB: activating/ disactivating test bench content muxing.
	+ done: TB finish flag

RF.vhd:
- Implements register file architecture:
- ports functional description:
	+ clk, rst, RF_writeEn: control lines for the unit
	+ RF_write_data



AdderSub.vhd:    a block used for addition and substraction
ALU.vhd:         a block responsible for all arithemetic function
aux_package.vhd: a general package containing component definitions
Control.vhd:     a block which includes the fsm which controls the signals used in the datapath
Datapath.vhd:    a block which recieves control signals and input and generates the output.
FA.vhd:          a full header.. used for adderSub block.
Logic.vhd:       a block that performs the logical operations.

ControlTB.vhd:   a simple tb for the control.
DatapathTB.vhd:  a simple tb for the datapath.
topTB.vhd:       a tb which parses input from a file and sends it to the top arch and reads the output from the block and writes them to a diffrent file.
