------------------------------------------------
-- Module Name: Synchronizer
-- Good synchronizer made non-blocking assignments
-----------------------------------------------
library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity synchro is
    Port ( clk : in  STD_LOGIC;
           i :   in  STD_LOGIC;
           q :  out  STD_LOGIC );
end synchro;

architecture synchro of synchro is
    signal n1: STD_LOGIC;
begin
    process ( clk )
    begin
        if clk'event and clk = '1' then
            -- case down is 
            n1 <= i; -- non blocking         
            q <= n1; -- non blocking
        end if;
    end process;
end synchro;