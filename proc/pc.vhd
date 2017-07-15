library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- PC: program counter implementado con registro de 32 bits

entity program_counter is
	port(clk, rst, we : in  std_logic;
		 input        : in  std_logic_vector(31 downto 0);
		 output       : out std_logic_vector(31 downto 0));
end program_counter;

architecture program_counter_beh of program_counter is
	signal a : std_logic_vector(31 downto 0);
begin
	process(clk, rst)
	begin
		if rst = '1' then
			a <= (others => '0');
		elsif (clk'event and clk = '1') then
			if (we = '1') then
				a <= input;
			end if;
		end if;
	end process;
	output <= a;
end program_counter_beh;


