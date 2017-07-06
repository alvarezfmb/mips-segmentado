library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_IF_ID is
	port(clk, rst, we : in  std_logic;
		 pc_plus_4_IF, inst_IF: in  std_logic_vector(31 downto 0);
		 pc_plus_4_ID, inst_ID: out std_logic_vector(31 downto 0));
end reg_IF_ID;

architecture reg_IF_ID_arch of reg_IF_ID is
begin
	process(clk, rst)
	begin
		if rst = '1' then
			pc_plus_4_ID <= (others => '0');
			inst_ID <= (others => '0');
		elsif (clk'event and clk = '1') then
			if (we = '1') then
				pc_plus_4_ID <= pc_plus_4_IF;
				inst_ID <= inst_IF;
			end if;
		end if;
	end process;
end reg_IF_ID_arch;
