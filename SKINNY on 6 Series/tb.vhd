--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:47:41 10/28/2024
-- Design Name:   
-- Module Name:   /home/ise/SFXISE/SAKURA_G_BTPLL/tb.vhd
-- Project Name:  SAKURA_G_TARGET_sdPRESENT_NS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TARGET_Toplevel
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb IS
END tb;
 
ARCHITECTURE behavior OF tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TARGET_Toplevel
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         Read : IN  std_logic;
         Write : IN  std_logic;
         Address : IN  std_logic_vector(2 downto 0);
         DataIn : IN  std_logic_vector(3 downto 0);
         DataOut : OUT  std_logic_vector(3 downto 0);
         TRIGGER : OUT  std_logic;
         clear : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal Read : std_logic := '0';
   signal Write : std_logic := '0';
   signal Address : std_logic_vector(2 downto 0) := (others => '0');
   signal DataIn : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal DataOut : std_logic_vector(3 downto 0);
   signal TRIGGER : std_logic;
   signal clear : std_logic;

   -- Clock period definitions
   constant clk_period : time := 41.666 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TARGET_Toplevel PORT MAP (
          CLK => CLK,
          RST => RST,
          Read => Read,
          Write => Write,
          Address => Address,
          DataIn => DataIn,
          DataOut => DataOut,
          TRIGGER => TRIGGER,
          clear => clear
        );

   -- Clock process definitions
--   CLK_process :process
--   begin
--		CLK <= '0';
--		wait for CLK_period/2;
--		CLK <= '1';
--		wait for CLK_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      
		for ii in 0 to 120 loop 
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
			clk <= '0';
		end loop;
		
		
		wait for 10*clk_period/2;
		rst <= '1';
		wait for 10*clk_period/2;
		rst <= '0';
		wait for 100*clk_period/2;
		
		for iii in 0 to 120 loop 
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
			clk <= '0';
		end loop;



      wait;
   end process;

END;
