library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

-- Unidad de control de la ALU: recibe últimos 6 bits de las instrucciones
-- y genera señal de control para la ALU.

entity alu_control is
	port(
		f      : in  STD_LOGIC_VECTOR(5 downto 0);
		alu_op : in  std_logic_vector(1 downto 0);
		alu_in : out std_logic_vector(2 downto 0)); 
end alu_control;

architecture behavioral of alu_control is
begin

process(f, alu_op)
	begin
		if (alu_op = "00") then
			alu_in <= "010";
		elsif alu_op = "01" then
			alu_in <= "110";
		elsif alu_op = "10" then
			if f = "100000" then
				alu_in <= "010";
			elsif f = "100010" then
				alu_in <= "110";
			elsif f = "100100" then
				alu_in <= "000";
			elsif f = "100101" then
				alu_in <= "001";
			elsif f = "101010" then
				alu_in <= "111";
			end if;
		else
			alu_in <= "100";
end if;
end process;
		
end behavioral;
