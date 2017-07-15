library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Sumador: utilizado para calcular siguiente instrucción del programa
-- y dirección de salto efectiva.

entity adder is
    Port (A, B : in std_logic_vector(31 downto 0);
          res    : out std_logic_vector(31 downto 0));
    End;

architecture Behavioral of adder is
    begin
    	res <= A + B;
    end;
