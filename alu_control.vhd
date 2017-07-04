library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity alu_control is
	port(
		--Entradas
		clk    : in  STD_LOGIC;         -- Reloj
		f      : in  STD_LOGIC_VECTOR(5 downto 0); -- Campo de la instrucción FUNC
		alu_op : in  std_logic_vector(1 downto 0); -- Señal de control de la Unidad de Control
		--Salidas
		alu_in : out ALU_INPUT          -- Entrada de la ALU
	);
end alu_control;

architecture behavioral of alu_control is
begin

process(alu_op, f, alu_in)
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
