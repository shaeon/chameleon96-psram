	component hps is
		port (
			clock_bridge_0_out_clk_1_clk           : out   std_logic;                                         -- clk
			hps_0_f2h_sdram0_clock_clk             : in    std_logic                      := 'X';             -- clk
			hps_0_f2h_sdram0_data_araddr           : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- araddr
			hps_0_f2h_sdram0_data_arlen            : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arlen
			hps_0_f2h_sdram0_data_arid             : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- arid
			hps_0_f2h_sdram0_data_arsize           : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- arsize
			hps_0_f2h_sdram0_data_arburst          : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- arburst
			hps_0_f2h_sdram0_data_arlock           : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- arlock
			hps_0_f2h_sdram0_data_arprot           : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- arprot
			hps_0_f2h_sdram0_data_arvalid          : in    std_logic                      := 'X';             -- arvalid
			hps_0_f2h_sdram0_data_arcache          : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arcache
			hps_0_f2h_sdram0_data_awaddr           : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- awaddr
			hps_0_f2h_sdram0_data_awlen            : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awlen
			hps_0_f2h_sdram0_data_awid             : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- awid
			hps_0_f2h_sdram0_data_awsize           : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awsize
			hps_0_f2h_sdram0_data_awburst          : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- awburst
			hps_0_f2h_sdram0_data_awlock           : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- awlock
			hps_0_f2h_sdram0_data_awprot           : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awprot
			hps_0_f2h_sdram0_data_awvalid          : in    std_logic                      := 'X';             -- awvalid
			hps_0_f2h_sdram0_data_awcache          : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awcache
			hps_0_f2h_sdram0_data_bresp            : out   std_logic_vector(1 downto 0);                      -- bresp
			hps_0_f2h_sdram0_data_bid              : out   std_logic_vector(7 downto 0);                      -- bid
			hps_0_f2h_sdram0_data_bvalid           : out   std_logic;                                         -- bvalid
			hps_0_f2h_sdram0_data_bready           : in    std_logic                      := 'X';             -- bready
			hps_0_f2h_sdram0_data_arready          : out   std_logic;                                         -- arready
			hps_0_f2h_sdram0_data_awready          : out   std_logic;                                         -- awready
			hps_0_f2h_sdram0_data_rready           : in    std_logic                      := 'X';             -- rready
			hps_0_f2h_sdram0_data_rdata            : out   std_logic_vector(63 downto 0);                     -- rdata
			hps_0_f2h_sdram0_data_rresp            : out   std_logic_vector(1 downto 0);                      -- rresp
			hps_0_f2h_sdram0_data_rlast            : out   std_logic;                                         -- rlast
			hps_0_f2h_sdram0_data_rid              : out   std_logic_vector(7 downto 0);                      -- rid
			hps_0_f2h_sdram0_data_rvalid           : out   std_logic;                                         -- rvalid
			hps_0_f2h_sdram0_data_wlast            : in    std_logic                      := 'X';             -- wlast
			hps_0_f2h_sdram0_data_wvalid           : in    std_logic                      := 'X';             -- wvalid
			hps_0_f2h_sdram0_data_wdata            : in    std_logic_vector(63 downto 0)  := (others => 'X'); -- wdata
			hps_0_f2h_sdram0_data_wstrb            : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- wstrb
			hps_0_f2h_sdram0_data_wready           : out   std_logic;                                         -- wready
			hps_0_f2h_sdram0_data_wid              : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- wid
			hps_0_f2h_sdram1_clock_clk             : in    std_logic                      := 'X';             -- clk
			hps_0_f2h_sdram1_data_araddr           : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- araddr
			hps_0_f2h_sdram1_data_arlen            : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arlen
			hps_0_f2h_sdram1_data_arid             : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- arid
			hps_0_f2h_sdram1_data_arsize           : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- arsize
			hps_0_f2h_sdram1_data_arburst          : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- arburst
			hps_0_f2h_sdram1_data_arlock           : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- arlock
			hps_0_f2h_sdram1_data_arprot           : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- arprot
			hps_0_f2h_sdram1_data_arvalid          : in    std_logic                      := 'X';             -- arvalid
			hps_0_f2h_sdram1_data_arcache          : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arcache
			hps_0_f2h_sdram1_data_awaddr           : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- awaddr
			hps_0_f2h_sdram1_data_awlen            : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awlen
			hps_0_f2h_sdram1_data_awid             : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- awid
			hps_0_f2h_sdram1_data_awsize           : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awsize
			hps_0_f2h_sdram1_data_awburst          : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- awburst
			hps_0_f2h_sdram1_data_awlock           : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- awlock
			hps_0_f2h_sdram1_data_awprot           : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awprot
			hps_0_f2h_sdram1_data_awvalid          : in    std_logic                      := 'X';             -- awvalid
			hps_0_f2h_sdram1_data_awcache          : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awcache
			hps_0_f2h_sdram1_data_bresp            : out   std_logic_vector(1 downto 0);                      -- bresp
			hps_0_f2h_sdram1_data_bid              : out   std_logic_vector(7 downto 0);                      -- bid
			hps_0_f2h_sdram1_data_bvalid           : out   std_logic;                                         -- bvalid
			hps_0_f2h_sdram1_data_bready           : in    std_logic                      := 'X';             -- bready
			hps_0_f2h_sdram1_data_arready          : out   std_logic;                                         -- arready
			hps_0_f2h_sdram1_data_awready          : out   std_logic;                                         -- awready
			hps_0_f2h_sdram1_data_rready           : in    std_logic                      := 'X';             -- rready
			hps_0_f2h_sdram1_data_rdata            : out   std_logic_vector(63 downto 0);                     -- rdata
			hps_0_f2h_sdram1_data_rresp            : out   std_logic_vector(1 downto 0);                      -- rresp
			hps_0_f2h_sdram1_data_rlast            : out   std_logic;                                         -- rlast
			hps_0_f2h_sdram1_data_rid              : out   std_logic_vector(7 downto 0);                      -- rid
			hps_0_f2h_sdram1_data_rvalid           : out   std_logic;                                         -- rvalid
			hps_0_f2h_sdram1_data_wlast            : in    std_logic                      := 'X';             -- wlast
			hps_0_f2h_sdram1_data_wvalid           : in    std_logic                      := 'X';             -- wvalid
			hps_0_f2h_sdram1_data_wdata            : in    std_logic_vector(63 downto 0)  := (others => 'X'); -- wdata
			hps_0_f2h_sdram1_data_wstrb            : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- wstrb
			hps_0_f2h_sdram1_data_wready           : out   std_logic;                                         -- wready
			hps_0_f2h_sdram1_data_wid              : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- wid
			hps_0_f2h_sdram2_clock_clk             : in    std_logic                      := 'X';             -- clk
			hps_0_f2h_sdram2_data_araddr           : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- araddr
			hps_0_f2h_sdram2_data_arlen            : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arlen
			hps_0_f2h_sdram2_data_arid             : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- arid
			hps_0_f2h_sdram2_data_arsize           : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- arsize
			hps_0_f2h_sdram2_data_arburst          : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- arburst
			hps_0_f2h_sdram2_data_arlock           : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- arlock
			hps_0_f2h_sdram2_data_arprot           : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- arprot
			hps_0_f2h_sdram2_data_arvalid          : in    std_logic                      := 'X';             -- arvalid
			hps_0_f2h_sdram2_data_arcache          : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arcache
			hps_0_f2h_sdram2_data_awaddr           : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- awaddr
			hps_0_f2h_sdram2_data_awlen            : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awlen
			hps_0_f2h_sdram2_data_awid             : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- awid
			hps_0_f2h_sdram2_data_awsize           : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awsize
			hps_0_f2h_sdram2_data_awburst          : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- awburst
			hps_0_f2h_sdram2_data_awlock           : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- awlock
			hps_0_f2h_sdram2_data_awprot           : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awprot
			hps_0_f2h_sdram2_data_awvalid          : in    std_logic                      := 'X';             -- awvalid
			hps_0_f2h_sdram2_data_awcache          : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awcache
			hps_0_f2h_sdram2_data_bresp            : out   std_logic_vector(1 downto 0);                      -- bresp
			hps_0_f2h_sdram2_data_bid              : out   std_logic_vector(7 downto 0);                      -- bid
			hps_0_f2h_sdram2_data_bvalid           : out   std_logic;                                         -- bvalid
			hps_0_f2h_sdram2_data_bready           : in    std_logic                      := 'X';             -- bready
			hps_0_f2h_sdram2_data_arready          : out   std_logic;                                         -- arready
			hps_0_f2h_sdram2_data_awready          : out   std_logic;                                         -- awready
			hps_0_f2h_sdram2_data_rready           : in    std_logic                      := 'X';             -- rready
			hps_0_f2h_sdram2_data_rdata            : out   std_logic_vector(127 downto 0);                    -- rdata
			hps_0_f2h_sdram2_data_rresp            : out   std_logic_vector(1 downto 0);                      -- rresp
			hps_0_f2h_sdram2_data_rlast            : out   std_logic;                                         -- rlast
			hps_0_f2h_sdram2_data_rid              : out   std_logic_vector(7 downto 0);                      -- rid
			hps_0_f2h_sdram2_data_rvalid           : out   std_logic;                                         -- rvalid
			hps_0_f2h_sdram2_data_wlast            : in    std_logic                      := 'X';             -- wlast
			hps_0_f2h_sdram2_data_wvalid           : in    std_logic                      := 'X';             -- wvalid
			hps_0_f2h_sdram2_data_wdata            : in    std_logic_vector(127 downto 0) := (others => 'X'); -- wdata
			hps_0_f2h_sdram2_data_wstrb            : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- wstrb
			hps_0_f2h_sdram2_data_wready           : out   std_logic;                                         -- wready
			hps_0_f2h_sdram2_data_wid              : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- wid
			hps_0_h2f_loan_io_in                   : out   std_logic_vector(66 downto 0);                     -- in
			hps_0_h2f_loan_io_out                  : in    std_logic_vector(66 downto 0)  := (others => 'X'); -- out
			hps_0_h2f_loan_io_oe                   : in    std_logic_vector(66 downto 0)  := (others => 'X'); -- oe
			hps_0_h2f_user1_clock_clk              : out   std_logic;                                         -- clk
			hps_0_i2c2_out_data                    : out   std_logic;                                         -- out_data
			hps_0_i2c2_sda                         : in    std_logic                      := 'X';             -- sda
			hps_0_i2c2_clk_clk                     : out   std_logic;                                         -- clk
			hps_0_uart1_cts                        : in    std_logic                      := 'X';             -- cts
			hps_0_uart1_dsr                        : in    std_logic                      := 'X';             -- dsr
			hps_0_uart1_dcd                        : in    std_logic                      := 'X';             -- dcd
			hps_0_uart1_ri                         : in    std_logic                      := 'X';             -- ri
			hps_0_uart1_dtr                        : out   std_logic;                                         -- dtr
			hps_0_uart1_rts                        : out   std_logic;                                         -- rts
			hps_0_uart1_out1_n                     : out   std_logic;                                         -- out1_n
			hps_0_uart1_out2_n                     : out   std_logic;                                         -- out2_n
			hps_0_uart1_rxd                        : in    std_logic                      := 'X';             -- rxd
			hps_0_uart1_txd                        : out   std_logic;                                         -- txd
			hps_io_hps_io_sdio_inst_CMD            : inout std_logic                      := 'X';             -- hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0             : inout std_logic                      := 'X';             -- hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1             : inout std_logic                      := 'X';             -- hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK            : out   std_logic;                                         -- hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2             : inout std_logic                      := 'X';             -- hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3             : inout std_logic                      := 'X';             -- hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0             : inout std_logic                      := 'X';             -- hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1             : inout std_logic                      := 'X';             -- hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2             : inout std_logic                      := 'X';             -- hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3             : inout std_logic                      := 'X';             -- hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4             : inout std_logic                      := 'X';             -- hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5             : inout std_logic                      := 'X';             -- hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6             : inout std_logic                      := 'X';             -- hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7             : inout std_logic                      := 'X';             -- hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK            : in    std_logic                      := 'X';             -- hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP            : out   std_logic;                                         -- hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR            : in    std_logic                      := 'X';             -- hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT            : in    std_logic                      := 'X';             -- hps_io_usb1_inst_NXT
			hps_io_hps_io_spim0_inst_CLK           : out   std_logic;                                         -- hps_io_spim0_inst_CLK
			hps_io_hps_io_spim0_inst_MOSI          : out   std_logic;                                         -- hps_io_spim0_inst_MOSI
			hps_io_hps_io_spim0_inst_MISO          : in    std_logic                      := 'X';             -- hps_io_spim0_inst_MISO
			hps_io_hps_io_spim0_inst_SS0           : out   std_logic;                                         -- hps_io_spim0_inst_SS0
			hps_io_hps_io_spim1_inst_CLK           : out   std_logic;                                         -- hps_io_spim1_inst_CLK
			hps_io_hps_io_spim1_inst_MOSI          : out   std_logic;                                         -- hps_io_spim1_inst_MOSI
			hps_io_hps_io_spim1_inst_MISO          : in    std_logic                      := 'X';             -- hps_io_spim1_inst_MISO
			hps_io_hps_io_spim1_inst_SS0           : out   std_logic;                                         -- hps_io_spim1_inst_SS0
			hps_io_hps_io_uart0_inst_RX            : in    std_logic                      := 'X';             -- hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX            : out   std_logic;                                         -- hps_io_uart0_inst_TX
			hps_io_hps_io_i2c0_inst_SDA            : inout std_logic                      := 'X';             -- hps_io_i2c0_inst_SDA
			hps_io_hps_io_i2c0_inst_SCL            : inout std_logic                      := 'X';             -- hps_io_i2c0_inst_SCL
			hps_io_hps_io_i2c1_inst_SDA            : inout std_logic                      := 'X';             -- hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL            : inout std_logic                      := 'X';             -- hps_io_i2c1_inst_SCL
			hps_io_hps_io_i2c3_inst_SDA            : inout std_logic                      := 'X';             -- hps_io_i2c3_inst_SDA
			hps_io_hps_io_i2c3_inst_SCL            : inout std_logic                      := 'X';             -- hps_io_i2c3_inst_SCL
			hps_io_hps_io_gpio_inst_GPIO00         : inout std_logic                      := 'X';             -- hps_io_gpio_inst_GPIO00
			hps_io_hps_io_gpio_inst_GPIO09         : inout std_logic                      := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_io_hps_io_gpio_inst_GPIO44         : inout std_logic                      := 'X';             -- hps_io_gpio_inst_GPIO44
			hps_io_hps_io_gpio_inst_LOANIO14       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO14
			hps_io_hps_io_gpio_inst_LOANIO17       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO17
			hps_io_hps_io_gpio_inst_LOANIO19       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO19
			hps_io_hps_io_gpio_inst_LOANIO22       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO22
			hps_io_hps_io_gpio_inst_LOANIO23       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO23
			hps_io_hps_io_gpio_inst_LOANIO25       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO25
			hps_io_hps_io_gpio_inst_LOANIO27       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO27
			hps_io_hps_io_gpio_inst_LOANIO28       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO28
			hps_io_hps_io_gpio_inst_LOANIO29       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO29
			hps_io_hps_io_gpio_inst_LOANIO30       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO30
			hps_io_hps_io_gpio_inst_LOANIO32       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO32
			hps_io_hps_io_gpio_inst_LOANIO33       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO33
			hps_io_hps_io_gpio_inst_LOANIO34       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO34
			hps_io_hps_io_gpio_inst_LOANIO48       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO48
			hps_io_hps_io_gpio_inst_LOANIO53       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO53
			hps_io_hps_io_gpio_inst_LOANIO54       : inout std_logic                      := 'X';             -- hps_io_gpio_inst_LOANIO54
			memory_mem_a                           : out   std_logic_vector(14 downto 0);                     -- mem_a
			memory_mem_ba                          : out   std_logic_vector(2 downto 0);                      -- mem_ba
			memory_mem_ck                          : out   std_logic;                                         -- mem_ck
			memory_mem_ck_n                        : out   std_logic;                                         -- mem_ck_n
			memory_mem_cke                         : out   std_logic;                                         -- mem_cke
			memory_mem_cs_n                        : out   std_logic;                                         -- mem_cs_n
			memory_mem_ras_n                       : out   std_logic;                                         -- mem_ras_n
			memory_mem_cas_n                       : out   std_logic;                                         -- mem_cas_n
			memory_mem_we_n                        : out   std_logic;                                         -- mem_we_n
			memory_mem_reset_n                     : out   std_logic;                                         -- mem_reset_n
			memory_mem_dq                          : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- mem_dq
			memory_mem_dqs                         : inout std_logic_vector(1 downto 0)   := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                       : inout std_logic_vector(1 downto 0)   := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                         : out   std_logic;                                         -- mem_odt
			memory_mem_dm                          : out   std_logic_vector(1 downto 0);                      -- mem_dm
			memory_oct_rzqin                       : in    std_logic                      := 'X';             -- oct_rzqin
			pio_rf_leds_external_connection_export : out   std_logic_vector(1 downto 0);                      -- export
			reset_bridge_0_out_reset_1_reset       : out   std_logic                                          -- reset
		);
	end component hps;

	u0 : component hps
		port map (
			clock_bridge_0_out_clk_1_clk           => CONNECTED_TO_clock_bridge_0_out_clk_1_clk,           --        clock_bridge_0_out_clk_1.clk
			hps_0_f2h_sdram0_clock_clk             => CONNECTED_TO_hps_0_f2h_sdram0_clock_clk,             --          hps_0_f2h_sdram0_clock.clk
			hps_0_f2h_sdram0_data_araddr           => CONNECTED_TO_hps_0_f2h_sdram0_data_araddr,           --           hps_0_f2h_sdram0_data.araddr
			hps_0_f2h_sdram0_data_arlen            => CONNECTED_TO_hps_0_f2h_sdram0_data_arlen,            --                                .arlen
			hps_0_f2h_sdram0_data_arid             => CONNECTED_TO_hps_0_f2h_sdram0_data_arid,             --                                .arid
			hps_0_f2h_sdram0_data_arsize           => CONNECTED_TO_hps_0_f2h_sdram0_data_arsize,           --                                .arsize
			hps_0_f2h_sdram0_data_arburst          => CONNECTED_TO_hps_0_f2h_sdram0_data_arburst,          --                                .arburst
			hps_0_f2h_sdram0_data_arlock           => CONNECTED_TO_hps_0_f2h_sdram0_data_arlock,           --                                .arlock
			hps_0_f2h_sdram0_data_arprot           => CONNECTED_TO_hps_0_f2h_sdram0_data_arprot,           --                                .arprot
			hps_0_f2h_sdram0_data_arvalid          => CONNECTED_TO_hps_0_f2h_sdram0_data_arvalid,          --                                .arvalid
			hps_0_f2h_sdram0_data_arcache          => CONNECTED_TO_hps_0_f2h_sdram0_data_arcache,          --                                .arcache
			hps_0_f2h_sdram0_data_awaddr           => CONNECTED_TO_hps_0_f2h_sdram0_data_awaddr,           --                                .awaddr
			hps_0_f2h_sdram0_data_awlen            => CONNECTED_TO_hps_0_f2h_sdram0_data_awlen,            --                                .awlen
			hps_0_f2h_sdram0_data_awid             => CONNECTED_TO_hps_0_f2h_sdram0_data_awid,             --                                .awid
			hps_0_f2h_sdram0_data_awsize           => CONNECTED_TO_hps_0_f2h_sdram0_data_awsize,           --                                .awsize
			hps_0_f2h_sdram0_data_awburst          => CONNECTED_TO_hps_0_f2h_sdram0_data_awburst,          --                                .awburst
			hps_0_f2h_sdram0_data_awlock           => CONNECTED_TO_hps_0_f2h_sdram0_data_awlock,           --                                .awlock
			hps_0_f2h_sdram0_data_awprot           => CONNECTED_TO_hps_0_f2h_sdram0_data_awprot,           --                                .awprot
			hps_0_f2h_sdram0_data_awvalid          => CONNECTED_TO_hps_0_f2h_sdram0_data_awvalid,          --                                .awvalid
			hps_0_f2h_sdram0_data_awcache          => CONNECTED_TO_hps_0_f2h_sdram0_data_awcache,          --                                .awcache
			hps_0_f2h_sdram0_data_bresp            => CONNECTED_TO_hps_0_f2h_sdram0_data_bresp,            --                                .bresp
			hps_0_f2h_sdram0_data_bid              => CONNECTED_TO_hps_0_f2h_sdram0_data_bid,              --                                .bid
			hps_0_f2h_sdram0_data_bvalid           => CONNECTED_TO_hps_0_f2h_sdram0_data_bvalid,           --                                .bvalid
			hps_0_f2h_sdram0_data_bready           => CONNECTED_TO_hps_0_f2h_sdram0_data_bready,           --                                .bready
			hps_0_f2h_sdram0_data_arready          => CONNECTED_TO_hps_0_f2h_sdram0_data_arready,          --                                .arready
			hps_0_f2h_sdram0_data_awready          => CONNECTED_TO_hps_0_f2h_sdram0_data_awready,          --                                .awready
			hps_0_f2h_sdram0_data_rready           => CONNECTED_TO_hps_0_f2h_sdram0_data_rready,           --                                .rready
			hps_0_f2h_sdram0_data_rdata            => CONNECTED_TO_hps_0_f2h_sdram0_data_rdata,            --                                .rdata
			hps_0_f2h_sdram0_data_rresp            => CONNECTED_TO_hps_0_f2h_sdram0_data_rresp,            --                                .rresp
			hps_0_f2h_sdram0_data_rlast            => CONNECTED_TO_hps_0_f2h_sdram0_data_rlast,            --                                .rlast
			hps_0_f2h_sdram0_data_rid              => CONNECTED_TO_hps_0_f2h_sdram0_data_rid,              --                                .rid
			hps_0_f2h_sdram0_data_rvalid           => CONNECTED_TO_hps_0_f2h_sdram0_data_rvalid,           --                                .rvalid
			hps_0_f2h_sdram0_data_wlast            => CONNECTED_TO_hps_0_f2h_sdram0_data_wlast,            --                                .wlast
			hps_0_f2h_sdram0_data_wvalid           => CONNECTED_TO_hps_0_f2h_sdram0_data_wvalid,           --                                .wvalid
			hps_0_f2h_sdram0_data_wdata            => CONNECTED_TO_hps_0_f2h_sdram0_data_wdata,            --                                .wdata
			hps_0_f2h_sdram0_data_wstrb            => CONNECTED_TO_hps_0_f2h_sdram0_data_wstrb,            --                                .wstrb
			hps_0_f2h_sdram0_data_wready           => CONNECTED_TO_hps_0_f2h_sdram0_data_wready,           --                                .wready
			hps_0_f2h_sdram0_data_wid              => CONNECTED_TO_hps_0_f2h_sdram0_data_wid,              --                                .wid
			hps_0_f2h_sdram1_clock_clk             => CONNECTED_TO_hps_0_f2h_sdram1_clock_clk,             --          hps_0_f2h_sdram1_clock.clk
			hps_0_f2h_sdram1_data_araddr           => CONNECTED_TO_hps_0_f2h_sdram1_data_araddr,           --           hps_0_f2h_sdram1_data.araddr
			hps_0_f2h_sdram1_data_arlen            => CONNECTED_TO_hps_0_f2h_sdram1_data_arlen,            --                                .arlen
			hps_0_f2h_sdram1_data_arid             => CONNECTED_TO_hps_0_f2h_sdram1_data_arid,             --                                .arid
			hps_0_f2h_sdram1_data_arsize           => CONNECTED_TO_hps_0_f2h_sdram1_data_arsize,           --                                .arsize
			hps_0_f2h_sdram1_data_arburst          => CONNECTED_TO_hps_0_f2h_sdram1_data_arburst,          --                                .arburst
			hps_0_f2h_sdram1_data_arlock           => CONNECTED_TO_hps_0_f2h_sdram1_data_arlock,           --                                .arlock
			hps_0_f2h_sdram1_data_arprot           => CONNECTED_TO_hps_0_f2h_sdram1_data_arprot,           --                                .arprot
			hps_0_f2h_sdram1_data_arvalid          => CONNECTED_TO_hps_0_f2h_sdram1_data_arvalid,          --                                .arvalid
			hps_0_f2h_sdram1_data_arcache          => CONNECTED_TO_hps_0_f2h_sdram1_data_arcache,          --                                .arcache
			hps_0_f2h_sdram1_data_awaddr           => CONNECTED_TO_hps_0_f2h_sdram1_data_awaddr,           --                                .awaddr
			hps_0_f2h_sdram1_data_awlen            => CONNECTED_TO_hps_0_f2h_sdram1_data_awlen,            --                                .awlen
			hps_0_f2h_sdram1_data_awid             => CONNECTED_TO_hps_0_f2h_sdram1_data_awid,             --                                .awid
			hps_0_f2h_sdram1_data_awsize           => CONNECTED_TO_hps_0_f2h_sdram1_data_awsize,           --                                .awsize
			hps_0_f2h_sdram1_data_awburst          => CONNECTED_TO_hps_0_f2h_sdram1_data_awburst,          --                                .awburst
			hps_0_f2h_sdram1_data_awlock           => CONNECTED_TO_hps_0_f2h_sdram1_data_awlock,           --                                .awlock
			hps_0_f2h_sdram1_data_awprot           => CONNECTED_TO_hps_0_f2h_sdram1_data_awprot,           --                                .awprot
			hps_0_f2h_sdram1_data_awvalid          => CONNECTED_TO_hps_0_f2h_sdram1_data_awvalid,          --                                .awvalid
			hps_0_f2h_sdram1_data_awcache          => CONNECTED_TO_hps_0_f2h_sdram1_data_awcache,          --                                .awcache
			hps_0_f2h_sdram1_data_bresp            => CONNECTED_TO_hps_0_f2h_sdram1_data_bresp,            --                                .bresp
			hps_0_f2h_sdram1_data_bid              => CONNECTED_TO_hps_0_f2h_sdram1_data_bid,              --                                .bid
			hps_0_f2h_sdram1_data_bvalid           => CONNECTED_TO_hps_0_f2h_sdram1_data_bvalid,           --                                .bvalid
			hps_0_f2h_sdram1_data_bready           => CONNECTED_TO_hps_0_f2h_sdram1_data_bready,           --                                .bready
			hps_0_f2h_sdram1_data_arready          => CONNECTED_TO_hps_0_f2h_sdram1_data_arready,          --                                .arready
			hps_0_f2h_sdram1_data_awready          => CONNECTED_TO_hps_0_f2h_sdram1_data_awready,          --                                .awready
			hps_0_f2h_sdram1_data_rready           => CONNECTED_TO_hps_0_f2h_sdram1_data_rready,           --                                .rready
			hps_0_f2h_sdram1_data_rdata            => CONNECTED_TO_hps_0_f2h_sdram1_data_rdata,            --                                .rdata
			hps_0_f2h_sdram1_data_rresp            => CONNECTED_TO_hps_0_f2h_sdram1_data_rresp,            --                                .rresp
			hps_0_f2h_sdram1_data_rlast            => CONNECTED_TO_hps_0_f2h_sdram1_data_rlast,            --                                .rlast
			hps_0_f2h_sdram1_data_rid              => CONNECTED_TO_hps_0_f2h_sdram1_data_rid,              --                                .rid
			hps_0_f2h_sdram1_data_rvalid           => CONNECTED_TO_hps_0_f2h_sdram1_data_rvalid,           --                                .rvalid
			hps_0_f2h_sdram1_data_wlast            => CONNECTED_TO_hps_0_f2h_sdram1_data_wlast,            --                                .wlast
			hps_0_f2h_sdram1_data_wvalid           => CONNECTED_TO_hps_0_f2h_sdram1_data_wvalid,           --                                .wvalid
			hps_0_f2h_sdram1_data_wdata            => CONNECTED_TO_hps_0_f2h_sdram1_data_wdata,            --                                .wdata
			hps_0_f2h_sdram1_data_wstrb            => CONNECTED_TO_hps_0_f2h_sdram1_data_wstrb,            --                                .wstrb
			hps_0_f2h_sdram1_data_wready           => CONNECTED_TO_hps_0_f2h_sdram1_data_wready,           --                                .wready
			hps_0_f2h_sdram1_data_wid              => CONNECTED_TO_hps_0_f2h_sdram1_data_wid,              --                                .wid
			hps_0_f2h_sdram2_clock_clk             => CONNECTED_TO_hps_0_f2h_sdram2_clock_clk,             --          hps_0_f2h_sdram2_clock.clk
			hps_0_f2h_sdram2_data_araddr           => CONNECTED_TO_hps_0_f2h_sdram2_data_araddr,           --           hps_0_f2h_sdram2_data.araddr
			hps_0_f2h_sdram2_data_arlen            => CONNECTED_TO_hps_0_f2h_sdram2_data_arlen,            --                                .arlen
			hps_0_f2h_sdram2_data_arid             => CONNECTED_TO_hps_0_f2h_sdram2_data_arid,             --                                .arid
			hps_0_f2h_sdram2_data_arsize           => CONNECTED_TO_hps_0_f2h_sdram2_data_arsize,           --                                .arsize
			hps_0_f2h_sdram2_data_arburst          => CONNECTED_TO_hps_0_f2h_sdram2_data_arburst,          --                                .arburst
			hps_0_f2h_sdram2_data_arlock           => CONNECTED_TO_hps_0_f2h_sdram2_data_arlock,           --                                .arlock
			hps_0_f2h_sdram2_data_arprot           => CONNECTED_TO_hps_0_f2h_sdram2_data_arprot,           --                                .arprot
			hps_0_f2h_sdram2_data_arvalid          => CONNECTED_TO_hps_0_f2h_sdram2_data_arvalid,          --                                .arvalid
			hps_0_f2h_sdram2_data_arcache          => CONNECTED_TO_hps_0_f2h_sdram2_data_arcache,          --                                .arcache
			hps_0_f2h_sdram2_data_awaddr           => CONNECTED_TO_hps_0_f2h_sdram2_data_awaddr,           --                                .awaddr
			hps_0_f2h_sdram2_data_awlen            => CONNECTED_TO_hps_0_f2h_sdram2_data_awlen,            --                                .awlen
			hps_0_f2h_sdram2_data_awid             => CONNECTED_TO_hps_0_f2h_sdram2_data_awid,             --                                .awid
			hps_0_f2h_sdram2_data_awsize           => CONNECTED_TO_hps_0_f2h_sdram2_data_awsize,           --                                .awsize
			hps_0_f2h_sdram2_data_awburst          => CONNECTED_TO_hps_0_f2h_sdram2_data_awburst,          --                                .awburst
			hps_0_f2h_sdram2_data_awlock           => CONNECTED_TO_hps_0_f2h_sdram2_data_awlock,           --                                .awlock
			hps_0_f2h_sdram2_data_awprot           => CONNECTED_TO_hps_0_f2h_sdram2_data_awprot,           --                                .awprot
			hps_0_f2h_sdram2_data_awvalid          => CONNECTED_TO_hps_0_f2h_sdram2_data_awvalid,          --                                .awvalid
			hps_0_f2h_sdram2_data_awcache          => CONNECTED_TO_hps_0_f2h_sdram2_data_awcache,          --                                .awcache
			hps_0_f2h_sdram2_data_bresp            => CONNECTED_TO_hps_0_f2h_sdram2_data_bresp,            --                                .bresp
			hps_0_f2h_sdram2_data_bid              => CONNECTED_TO_hps_0_f2h_sdram2_data_bid,              --                                .bid
			hps_0_f2h_sdram2_data_bvalid           => CONNECTED_TO_hps_0_f2h_sdram2_data_bvalid,           --                                .bvalid
			hps_0_f2h_sdram2_data_bready           => CONNECTED_TO_hps_0_f2h_sdram2_data_bready,           --                                .bready
			hps_0_f2h_sdram2_data_arready          => CONNECTED_TO_hps_0_f2h_sdram2_data_arready,          --                                .arready
			hps_0_f2h_sdram2_data_awready          => CONNECTED_TO_hps_0_f2h_sdram2_data_awready,          --                                .awready
			hps_0_f2h_sdram2_data_rready           => CONNECTED_TO_hps_0_f2h_sdram2_data_rready,           --                                .rready
			hps_0_f2h_sdram2_data_rdata            => CONNECTED_TO_hps_0_f2h_sdram2_data_rdata,            --                                .rdata
			hps_0_f2h_sdram2_data_rresp            => CONNECTED_TO_hps_0_f2h_sdram2_data_rresp,            --                                .rresp
			hps_0_f2h_sdram2_data_rlast            => CONNECTED_TO_hps_0_f2h_sdram2_data_rlast,            --                                .rlast
			hps_0_f2h_sdram2_data_rid              => CONNECTED_TO_hps_0_f2h_sdram2_data_rid,              --                                .rid
			hps_0_f2h_sdram2_data_rvalid           => CONNECTED_TO_hps_0_f2h_sdram2_data_rvalid,           --                                .rvalid
			hps_0_f2h_sdram2_data_wlast            => CONNECTED_TO_hps_0_f2h_sdram2_data_wlast,            --                                .wlast
			hps_0_f2h_sdram2_data_wvalid           => CONNECTED_TO_hps_0_f2h_sdram2_data_wvalid,           --                                .wvalid
			hps_0_f2h_sdram2_data_wdata            => CONNECTED_TO_hps_0_f2h_sdram2_data_wdata,            --                                .wdata
			hps_0_f2h_sdram2_data_wstrb            => CONNECTED_TO_hps_0_f2h_sdram2_data_wstrb,            --                                .wstrb
			hps_0_f2h_sdram2_data_wready           => CONNECTED_TO_hps_0_f2h_sdram2_data_wready,           --                                .wready
			hps_0_f2h_sdram2_data_wid              => CONNECTED_TO_hps_0_f2h_sdram2_data_wid,              --                                .wid
			hps_0_h2f_loan_io_in                   => CONNECTED_TO_hps_0_h2f_loan_io_in,                   --               hps_0_h2f_loan_io.in
			hps_0_h2f_loan_io_out                  => CONNECTED_TO_hps_0_h2f_loan_io_out,                  --                                .out
			hps_0_h2f_loan_io_oe                   => CONNECTED_TO_hps_0_h2f_loan_io_oe,                   --                                .oe
			hps_0_h2f_user1_clock_clk              => CONNECTED_TO_hps_0_h2f_user1_clock_clk,              --           hps_0_h2f_user1_clock.clk
			hps_0_i2c2_out_data                    => CONNECTED_TO_hps_0_i2c2_out_data,                    --                      hps_0_i2c2.out_data
			hps_0_i2c2_sda                         => CONNECTED_TO_hps_0_i2c2_sda,                         --                                .sda
			hps_0_i2c2_clk_clk                     => CONNECTED_TO_hps_0_i2c2_clk_clk,                     --                  hps_0_i2c2_clk.clk
			hps_0_uart1_cts                        => CONNECTED_TO_hps_0_uart1_cts,                        --                     hps_0_uart1.cts
			hps_0_uart1_dsr                        => CONNECTED_TO_hps_0_uart1_dsr,                        --                                .dsr
			hps_0_uart1_dcd                        => CONNECTED_TO_hps_0_uart1_dcd,                        --                                .dcd
			hps_0_uart1_ri                         => CONNECTED_TO_hps_0_uart1_ri,                         --                                .ri
			hps_0_uart1_dtr                        => CONNECTED_TO_hps_0_uart1_dtr,                        --                                .dtr
			hps_0_uart1_rts                        => CONNECTED_TO_hps_0_uart1_rts,                        --                                .rts
			hps_0_uart1_out1_n                     => CONNECTED_TO_hps_0_uart1_out1_n,                     --                                .out1_n
			hps_0_uart1_out2_n                     => CONNECTED_TO_hps_0_uart1_out2_n,                     --                                .out2_n
			hps_0_uart1_rxd                        => CONNECTED_TO_hps_0_uart1_rxd,                        --                                .rxd
			hps_0_uart1_txd                        => CONNECTED_TO_hps_0_uart1_txd,                        --                                .txd
			hps_io_hps_io_sdio_inst_CMD            => CONNECTED_TO_hps_io_hps_io_sdio_inst_CMD,            --                          hps_io.hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0             => CONNECTED_TO_hps_io_hps_io_sdio_inst_D0,             --                                .hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1             => CONNECTED_TO_hps_io_hps_io_sdio_inst_D1,             --                                .hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK            => CONNECTED_TO_hps_io_hps_io_sdio_inst_CLK,            --                                .hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2             => CONNECTED_TO_hps_io_hps_io_sdio_inst_D2,             --                                .hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3             => CONNECTED_TO_hps_io_hps_io_sdio_inst_D3,             --                                .hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0             => CONNECTED_TO_hps_io_hps_io_usb1_inst_D0,             --                                .hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1             => CONNECTED_TO_hps_io_hps_io_usb1_inst_D1,             --                                .hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2             => CONNECTED_TO_hps_io_hps_io_usb1_inst_D2,             --                                .hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3             => CONNECTED_TO_hps_io_hps_io_usb1_inst_D3,             --                                .hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4             => CONNECTED_TO_hps_io_hps_io_usb1_inst_D4,             --                                .hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5             => CONNECTED_TO_hps_io_hps_io_usb1_inst_D5,             --                                .hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6             => CONNECTED_TO_hps_io_hps_io_usb1_inst_D6,             --                                .hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7             => CONNECTED_TO_hps_io_hps_io_usb1_inst_D7,             --                                .hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK            => CONNECTED_TO_hps_io_hps_io_usb1_inst_CLK,            --                                .hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP            => CONNECTED_TO_hps_io_hps_io_usb1_inst_STP,            --                                .hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR            => CONNECTED_TO_hps_io_hps_io_usb1_inst_DIR,            --                                .hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT            => CONNECTED_TO_hps_io_hps_io_usb1_inst_NXT,            --                                .hps_io_usb1_inst_NXT
			hps_io_hps_io_spim0_inst_CLK           => CONNECTED_TO_hps_io_hps_io_spim0_inst_CLK,           --                                .hps_io_spim0_inst_CLK
			hps_io_hps_io_spim0_inst_MOSI          => CONNECTED_TO_hps_io_hps_io_spim0_inst_MOSI,          --                                .hps_io_spim0_inst_MOSI
			hps_io_hps_io_spim0_inst_MISO          => CONNECTED_TO_hps_io_hps_io_spim0_inst_MISO,          --                                .hps_io_spim0_inst_MISO
			hps_io_hps_io_spim0_inst_SS0           => CONNECTED_TO_hps_io_hps_io_spim0_inst_SS0,           --                                .hps_io_spim0_inst_SS0
			hps_io_hps_io_spim1_inst_CLK           => CONNECTED_TO_hps_io_hps_io_spim1_inst_CLK,           --                                .hps_io_spim1_inst_CLK
			hps_io_hps_io_spim1_inst_MOSI          => CONNECTED_TO_hps_io_hps_io_spim1_inst_MOSI,          --                                .hps_io_spim1_inst_MOSI
			hps_io_hps_io_spim1_inst_MISO          => CONNECTED_TO_hps_io_hps_io_spim1_inst_MISO,          --                                .hps_io_spim1_inst_MISO
			hps_io_hps_io_spim1_inst_SS0           => CONNECTED_TO_hps_io_hps_io_spim1_inst_SS0,           --                                .hps_io_spim1_inst_SS0
			hps_io_hps_io_uart0_inst_RX            => CONNECTED_TO_hps_io_hps_io_uart0_inst_RX,            --                                .hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX            => CONNECTED_TO_hps_io_hps_io_uart0_inst_TX,            --                                .hps_io_uart0_inst_TX
			hps_io_hps_io_i2c0_inst_SDA            => CONNECTED_TO_hps_io_hps_io_i2c0_inst_SDA,            --                                .hps_io_i2c0_inst_SDA
			hps_io_hps_io_i2c0_inst_SCL            => CONNECTED_TO_hps_io_hps_io_i2c0_inst_SCL,            --                                .hps_io_i2c0_inst_SCL
			hps_io_hps_io_i2c1_inst_SDA            => CONNECTED_TO_hps_io_hps_io_i2c1_inst_SDA,            --                                .hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL            => CONNECTED_TO_hps_io_hps_io_i2c1_inst_SCL,            --                                .hps_io_i2c1_inst_SCL
			hps_io_hps_io_i2c3_inst_SDA            => CONNECTED_TO_hps_io_hps_io_i2c3_inst_SDA,            --                                .hps_io_i2c3_inst_SDA
			hps_io_hps_io_i2c3_inst_SCL            => CONNECTED_TO_hps_io_hps_io_i2c3_inst_SCL,            --                                .hps_io_i2c3_inst_SCL
			hps_io_hps_io_gpio_inst_GPIO00         => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO00,         --                                .hps_io_gpio_inst_GPIO00
			hps_io_hps_io_gpio_inst_GPIO09         => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO09,         --                                .hps_io_gpio_inst_GPIO09
			hps_io_hps_io_gpio_inst_GPIO44         => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO44,         --                                .hps_io_gpio_inst_GPIO44
			hps_io_hps_io_gpio_inst_LOANIO14       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO14,       --                                .hps_io_gpio_inst_LOANIO14
			hps_io_hps_io_gpio_inst_LOANIO17       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO17,       --                                .hps_io_gpio_inst_LOANIO17
			hps_io_hps_io_gpio_inst_LOANIO19       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO19,       --                                .hps_io_gpio_inst_LOANIO19
			hps_io_hps_io_gpio_inst_LOANIO22       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO22,       --                                .hps_io_gpio_inst_LOANIO22
			hps_io_hps_io_gpio_inst_LOANIO23       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO23,       --                                .hps_io_gpio_inst_LOANIO23
			hps_io_hps_io_gpio_inst_LOANIO25       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO25,       --                                .hps_io_gpio_inst_LOANIO25
			hps_io_hps_io_gpio_inst_LOANIO27       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO27,       --                                .hps_io_gpio_inst_LOANIO27
			hps_io_hps_io_gpio_inst_LOANIO28       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO28,       --                                .hps_io_gpio_inst_LOANIO28
			hps_io_hps_io_gpio_inst_LOANIO29       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO29,       --                                .hps_io_gpio_inst_LOANIO29
			hps_io_hps_io_gpio_inst_LOANIO30       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO30,       --                                .hps_io_gpio_inst_LOANIO30
			hps_io_hps_io_gpio_inst_LOANIO32       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO32,       --                                .hps_io_gpio_inst_LOANIO32
			hps_io_hps_io_gpio_inst_LOANIO33       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO33,       --                                .hps_io_gpio_inst_LOANIO33
			hps_io_hps_io_gpio_inst_LOANIO34       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO34,       --                                .hps_io_gpio_inst_LOANIO34
			hps_io_hps_io_gpio_inst_LOANIO48       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO48,       --                                .hps_io_gpio_inst_LOANIO48
			hps_io_hps_io_gpio_inst_LOANIO53       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO53,       --                                .hps_io_gpio_inst_LOANIO53
			hps_io_hps_io_gpio_inst_LOANIO54       => CONNECTED_TO_hps_io_hps_io_gpio_inst_LOANIO54,       --                                .hps_io_gpio_inst_LOANIO54
			memory_mem_a                           => CONNECTED_TO_memory_mem_a,                           --                          memory.mem_a
			memory_mem_ba                          => CONNECTED_TO_memory_mem_ba,                          --                                .mem_ba
			memory_mem_ck                          => CONNECTED_TO_memory_mem_ck,                          --                                .mem_ck
			memory_mem_ck_n                        => CONNECTED_TO_memory_mem_ck_n,                        --                                .mem_ck_n
			memory_mem_cke                         => CONNECTED_TO_memory_mem_cke,                         --                                .mem_cke
			memory_mem_cs_n                        => CONNECTED_TO_memory_mem_cs_n,                        --                                .mem_cs_n
			memory_mem_ras_n                       => CONNECTED_TO_memory_mem_ras_n,                       --                                .mem_ras_n
			memory_mem_cas_n                       => CONNECTED_TO_memory_mem_cas_n,                       --                                .mem_cas_n
			memory_mem_we_n                        => CONNECTED_TO_memory_mem_we_n,                        --                                .mem_we_n
			memory_mem_reset_n                     => CONNECTED_TO_memory_mem_reset_n,                     --                                .mem_reset_n
			memory_mem_dq                          => CONNECTED_TO_memory_mem_dq,                          --                                .mem_dq
			memory_mem_dqs                         => CONNECTED_TO_memory_mem_dqs,                         --                                .mem_dqs
			memory_mem_dqs_n                       => CONNECTED_TO_memory_mem_dqs_n,                       --                                .mem_dqs_n
			memory_mem_odt                         => CONNECTED_TO_memory_mem_odt,                         --                                .mem_odt
			memory_mem_dm                          => CONNECTED_TO_memory_mem_dm,                          --                                .mem_dm
			memory_oct_rzqin                       => CONNECTED_TO_memory_oct_rzqin,                       --                                .oct_rzqin
			pio_rf_leds_external_connection_export => CONNECTED_TO_pio_rf_leds_external_connection_export, -- pio_rf_leds_external_connection.export
			reset_bridge_0_out_reset_1_reset       => CONNECTED_TO_reset_bridge_0_out_reset_1_reset        --      reset_bridge_0_out_reset_1.reset
		);

