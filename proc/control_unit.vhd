library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Unidad de control: genera se�ales de control para los componentes a partir de 
-- los primeros 6 bits del codigo de la instruccion.

entity control_unit is
	port(
		OP       : in  STD_LOGIC_VECTOR(5 downto 0);
		EX_signals: out STD_LOGIC_VECTOR(3 downto 0);
		MEM_signals: out STD_LOGIC_VECTOR(2 downto 0);
		WB_signals: out STD_LOGIC_VECTOR(1 downto 0)
	);
end control_unit;

architecture beh of control_unit is

	signal R_TYPE : STD_LOGIC;
	signal LW     : STD_LOGIC;
	signal SW     : STD_LOGIC;
	signal BEQ    : STD_LOGIC;
	signal LUI    : STD_LOGIC;
	signal RegWrite : STD_LOGIC;   
	signal MemtoReg : STD_LOGIC;       
	signal Branch   : STD_LOGIC;       
	signal MemRead  : STD_LOGIC;       
	signal MemWrite : STD_LOGIC;       
	signal RegDst   : STD_LOGIC;      
	signal ALUSrc   : STD_LOGIC;       
	signal alu_op   : STD_LOGIC_VECTOR(1 downto 0);

begin
	process(OP)
		begin
	R_TYPE <= not OP(5) and not OP(4) and not OP(3) and not OP(2) and not OP(1) and not OP(0);

	LW <= OP(5) and not OP(4) and not OP(3) and not OP(2) and OP(1) and OP(0);

	SW <= OP(5) and not OP(4) and OP(3) and not OP(2) and OP(1) and OP(0);

	BEQ <= not OP(5) and not OP(4) and not OP(3) and OP(2) and not OP(1) and not OP(0);

	LUI <= not OP(5) and not OP(4) and OP(3) and OP(2) and OP(1) and OP(0);
	end process;

	RegWrite <= R_TYPE or LW or LUI;
	MemtoReg <= LW;
	Branch   <= BEQ;
	MemRead  <= LW;
	MemWrite <= SW;
	RegDst   <= R_TYPE;
	ALUSrc   <= LW or SW or LUI;
	
	process(BEQ, R_TYPE, LW, SW, LUI)
	  begin
	if BEQ = '1' then
		alu_op <= "01";
	elsif R_TYPE = '1' then
		alu_op <= "10";
	elsif LW = '1' or SW = '1' then
		alu_op <= "00";
	elsif LUI = '1' then
		alu_op <= "11";
	end if;
	end process;
	
	EX_signals <= RegDst & ALUSrc & alu_op;
  	MEM_signals <= Branch & MemRead & MemWrite;
  	WB_signals <= RegWrite & MemtoReg;
  
end beh;
