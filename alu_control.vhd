library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

--library work;
--use work.records_pkg.all;

entity alu_contorl is
	port(
		clk          : in  std_logic;
		f            : in  std_logic_vector(5 downto 0); -- funct
		alu_op_input : in  alu_op_input;
		alu_input    : out alu_input
	);
end entity;

architecture behavioral of alu_control is
begin

	with f & alu_op_input select alu_input <=
		x"0130" when "0000000",
		x"0000" when others;
	ALU_IN.Op0 <= ALU_OP_IN.Op1 and (FUNCT(0) or FUNCT(3));
	ALU_IN.Op1 <= (not ALU_OP_IN.Op1) or (not FUNCT(2));
	ALU_IN.Op2 <= ALU_OP_IN.Op0 or (ALU_OP_IN.Op1 and FUNCT(1));
	ALU_IN.Op3 <= ALU_OP_IN.Op2;

end ALU_CONTROL_ARC;
