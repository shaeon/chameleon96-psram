
module hps (
	clock_bridge_0_out_clk_1_clk,
	hps_0_f2h_sdram0_clock_clk,
	hps_0_f2h_sdram0_data_araddr,
	hps_0_f2h_sdram0_data_arlen,
	hps_0_f2h_sdram0_data_arid,
	hps_0_f2h_sdram0_data_arsize,
	hps_0_f2h_sdram0_data_arburst,
	hps_0_f2h_sdram0_data_arlock,
	hps_0_f2h_sdram0_data_arprot,
	hps_0_f2h_sdram0_data_arvalid,
	hps_0_f2h_sdram0_data_arcache,
	hps_0_f2h_sdram0_data_awaddr,
	hps_0_f2h_sdram0_data_awlen,
	hps_0_f2h_sdram0_data_awid,
	hps_0_f2h_sdram0_data_awsize,
	hps_0_f2h_sdram0_data_awburst,
	hps_0_f2h_sdram0_data_awlock,
	hps_0_f2h_sdram0_data_awprot,
	hps_0_f2h_sdram0_data_awvalid,
	hps_0_f2h_sdram0_data_awcache,
	hps_0_f2h_sdram0_data_bresp,
	hps_0_f2h_sdram0_data_bid,
	hps_0_f2h_sdram0_data_bvalid,
	hps_0_f2h_sdram0_data_bready,
	hps_0_f2h_sdram0_data_arready,
	hps_0_f2h_sdram0_data_awready,
	hps_0_f2h_sdram0_data_rready,
	hps_0_f2h_sdram0_data_rdata,
	hps_0_f2h_sdram0_data_rresp,
	hps_0_f2h_sdram0_data_rlast,
	hps_0_f2h_sdram0_data_rid,
	hps_0_f2h_sdram0_data_rvalid,
	hps_0_f2h_sdram0_data_wlast,
	hps_0_f2h_sdram0_data_wvalid,
	hps_0_f2h_sdram0_data_wdata,
	hps_0_f2h_sdram0_data_wstrb,
	hps_0_f2h_sdram0_data_wready,
	hps_0_f2h_sdram0_data_wid,
	hps_0_f2h_sdram1_clock_clk,
	hps_0_f2h_sdram1_data_araddr,
	hps_0_f2h_sdram1_data_arlen,
	hps_0_f2h_sdram1_data_arid,
	hps_0_f2h_sdram1_data_arsize,
	hps_0_f2h_sdram1_data_arburst,
	hps_0_f2h_sdram1_data_arlock,
	hps_0_f2h_sdram1_data_arprot,
	hps_0_f2h_sdram1_data_arvalid,
	hps_0_f2h_sdram1_data_arcache,
	hps_0_f2h_sdram1_data_awaddr,
	hps_0_f2h_sdram1_data_awlen,
	hps_0_f2h_sdram1_data_awid,
	hps_0_f2h_sdram1_data_awsize,
	hps_0_f2h_sdram1_data_awburst,
	hps_0_f2h_sdram1_data_awlock,
	hps_0_f2h_sdram1_data_awprot,
	hps_0_f2h_sdram1_data_awvalid,
	hps_0_f2h_sdram1_data_awcache,
	hps_0_f2h_sdram1_data_bresp,
	hps_0_f2h_sdram1_data_bid,
	hps_0_f2h_sdram1_data_bvalid,
	hps_0_f2h_sdram1_data_bready,
	hps_0_f2h_sdram1_data_arready,
	hps_0_f2h_sdram1_data_awready,
	hps_0_f2h_sdram1_data_rready,
	hps_0_f2h_sdram1_data_rdata,
	hps_0_f2h_sdram1_data_rresp,
	hps_0_f2h_sdram1_data_rlast,
	hps_0_f2h_sdram1_data_rid,
	hps_0_f2h_sdram1_data_rvalid,
	hps_0_f2h_sdram1_data_wlast,
	hps_0_f2h_sdram1_data_wvalid,
	hps_0_f2h_sdram1_data_wdata,
	hps_0_f2h_sdram1_data_wstrb,
	hps_0_f2h_sdram1_data_wready,
	hps_0_f2h_sdram1_data_wid,
	hps_0_f2h_sdram2_clock_clk,
	hps_0_f2h_sdram2_data_araddr,
	hps_0_f2h_sdram2_data_arlen,
	hps_0_f2h_sdram2_data_arid,
	hps_0_f2h_sdram2_data_arsize,
	hps_0_f2h_sdram2_data_arburst,
	hps_0_f2h_sdram2_data_arlock,
	hps_0_f2h_sdram2_data_arprot,
	hps_0_f2h_sdram2_data_arvalid,
	hps_0_f2h_sdram2_data_arcache,
	hps_0_f2h_sdram2_data_awaddr,
	hps_0_f2h_sdram2_data_awlen,
	hps_0_f2h_sdram2_data_awid,
	hps_0_f2h_sdram2_data_awsize,
	hps_0_f2h_sdram2_data_awburst,
	hps_0_f2h_sdram2_data_awlock,
	hps_0_f2h_sdram2_data_awprot,
	hps_0_f2h_sdram2_data_awvalid,
	hps_0_f2h_sdram2_data_awcache,
	hps_0_f2h_sdram2_data_bresp,
	hps_0_f2h_sdram2_data_bid,
	hps_0_f2h_sdram2_data_bvalid,
	hps_0_f2h_sdram2_data_bready,
	hps_0_f2h_sdram2_data_arready,
	hps_0_f2h_sdram2_data_awready,
	hps_0_f2h_sdram2_data_rready,
	hps_0_f2h_sdram2_data_rdata,
	hps_0_f2h_sdram2_data_rresp,
	hps_0_f2h_sdram2_data_rlast,
	hps_0_f2h_sdram2_data_rid,
	hps_0_f2h_sdram2_data_rvalid,
	hps_0_f2h_sdram2_data_wlast,
	hps_0_f2h_sdram2_data_wvalid,
	hps_0_f2h_sdram2_data_wdata,
	hps_0_f2h_sdram2_data_wstrb,
	hps_0_f2h_sdram2_data_wready,
	hps_0_f2h_sdram2_data_wid,
	hps_0_h2f_loan_io_in,
	hps_0_h2f_loan_io_out,
	hps_0_h2f_loan_io_oe,
	hps_0_h2f_user1_clock_clk,
	hps_0_i2c2_out_data,
	hps_0_i2c2_sda,
	hps_0_i2c2_clk_clk,
	hps_0_uart1_cts,
	hps_0_uart1_dsr,
	hps_0_uart1_dcd,
	hps_0_uart1_ri,
	hps_0_uart1_dtr,
	hps_0_uart1_rts,
	hps_0_uart1_out1_n,
	hps_0_uart1_out2_n,
	hps_0_uart1_rxd,
	hps_0_uart1_txd,
	hps_io_hps_io_sdio_inst_CMD,
	hps_io_hps_io_sdio_inst_D0,
	hps_io_hps_io_sdio_inst_D1,
	hps_io_hps_io_sdio_inst_CLK,
	hps_io_hps_io_sdio_inst_D2,
	hps_io_hps_io_sdio_inst_D3,
	hps_io_hps_io_usb1_inst_D0,
	hps_io_hps_io_usb1_inst_D1,
	hps_io_hps_io_usb1_inst_D2,
	hps_io_hps_io_usb1_inst_D3,
	hps_io_hps_io_usb1_inst_D4,
	hps_io_hps_io_usb1_inst_D5,
	hps_io_hps_io_usb1_inst_D6,
	hps_io_hps_io_usb1_inst_D7,
	hps_io_hps_io_usb1_inst_CLK,
	hps_io_hps_io_usb1_inst_STP,
	hps_io_hps_io_usb1_inst_DIR,
	hps_io_hps_io_usb1_inst_NXT,
	hps_io_hps_io_spim0_inst_CLK,
	hps_io_hps_io_spim0_inst_MOSI,
	hps_io_hps_io_spim0_inst_MISO,
	hps_io_hps_io_spim0_inst_SS0,
	hps_io_hps_io_spim1_inst_CLK,
	hps_io_hps_io_spim1_inst_MOSI,
	hps_io_hps_io_spim1_inst_MISO,
	hps_io_hps_io_spim1_inst_SS0,
	hps_io_hps_io_uart0_inst_RX,
	hps_io_hps_io_uart0_inst_TX,
	hps_io_hps_io_i2c0_inst_SDA,
	hps_io_hps_io_i2c0_inst_SCL,
	hps_io_hps_io_i2c1_inst_SDA,
	hps_io_hps_io_i2c1_inst_SCL,
	hps_io_hps_io_i2c3_inst_SDA,
	hps_io_hps_io_i2c3_inst_SCL,
	hps_io_hps_io_gpio_inst_GPIO00,
	hps_io_hps_io_gpio_inst_GPIO09,
	hps_io_hps_io_gpio_inst_GPIO44,
	hps_io_hps_io_gpio_inst_LOANIO14,
	hps_io_hps_io_gpio_inst_LOANIO17,
	hps_io_hps_io_gpio_inst_LOANIO19,
	hps_io_hps_io_gpio_inst_LOANIO22,
	hps_io_hps_io_gpio_inst_LOANIO23,
	hps_io_hps_io_gpio_inst_LOANIO25,
	hps_io_hps_io_gpio_inst_LOANIO27,
	hps_io_hps_io_gpio_inst_LOANIO28,
	hps_io_hps_io_gpio_inst_LOANIO29,
	hps_io_hps_io_gpio_inst_LOANIO30,
	hps_io_hps_io_gpio_inst_LOANIO32,
	hps_io_hps_io_gpio_inst_LOANIO33,
	hps_io_hps_io_gpio_inst_LOANIO34,
	hps_io_hps_io_gpio_inst_LOANIO48,
	hps_io_hps_io_gpio_inst_LOANIO53,
	hps_io_hps_io_gpio_inst_LOANIO54,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	pio_rf_leds_external_connection_export,
	reset_bridge_0_out_reset_1_reset);	

	output		clock_bridge_0_out_clk_1_clk;
	input		hps_0_f2h_sdram0_clock_clk;
	input	[31:0]	hps_0_f2h_sdram0_data_araddr;
	input	[3:0]	hps_0_f2h_sdram0_data_arlen;
	input	[7:0]	hps_0_f2h_sdram0_data_arid;
	input	[2:0]	hps_0_f2h_sdram0_data_arsize;
	input	[1:0]	hps_0_f2h_sdram0_data_arburst;
	input	[1:0]	hps_0_f2h_sdram0_data_arlock;
	input	[2:0]	hps_0_f2h_sdram0_data_arprot;
	input		hps_0_f2h_sdram0_data_arvalid;
	input	[3:0]	hps_0_f2h_sdram0_data_arcache;
	input	[31:0]	hps_0_f2h_sdram0_data_awaddr;
	input	[3:0]	hps_0_f2h_sdram0_data_awlen;
	input	[7:0]	hps_0_f2h_sdram0_data_awid;
	input	[2:0]	hps_0_f2h_sdram0_data_awsize;
	input	[1:0]	hps_0_f2h_sdram0_data_awburst;
	input	[1:0]	hps_0_f2h_sdram0_data_awlock;
	input	[2:0]	hps_0_f2h_sdram0_data_awprot;
	input		hps_0_f2h_sdram0_data_awvalid;
	input	[3:0]	hps_0_f2h_sdram0_data_awcache;
	output	[1:0]	hps_0_f2h_sdram0_data_bresp;
	output	[7:0]	hps_0_f2h_sdram0_data_bid;
	output		hps_0_f2h_sdram0_data_bvalid;
	input		hps_0_f2h_sdram0_data_bready;
	output		hps_0_f2h_sdram0_data_arready;
	output		hps_0_f2h_sdram0_data_awready;
	input		hps_0_f2h_sdram0_data_rready;
	output	[63:0]	hps_0_f2h_sdram0_data_rdata;
	output	[1:0]	hps_0_f2h_sdram0_data_rresp;
	output		hps_0_f2h_sdram0_data_rlast;
	output	[7:0]	hps_0_f2h_sdram0_data_rid;
	output		hps_0_f2h_sdram0_data_rvalid;
	input		hps_0_f2h_sdram0_data_wlast;
	input		hps_0_f2h_sdram0_data_wvalid;
	input	[63:0]	hps_0_f2h_sdram0_data_wdata;
	input	[7:0]	hps_0_f2h_sdram0_data_wstrb;
	output		hps_0_f2h_sdram0_data_wready;
	input	[7:0]	hps_0_f2h_sdram0_data_wid;
	input		hps_0_f2h_sdram1_clock_clk;
	input	[31:0]	hps_0_f2h_sdram1_data_araddr;
	input	[3:0]	hps_0_f2h_sdram1_data_arlen;
	input	[7:0]	hps_0_f2h_sdram1_data_arid;
	input	[2:0]	hps_0_f2h_sdram1_data_arsize;
	input	[1:0]	hps_0_f2h_sdram1_data_arburst;
	input	[1:0]	hps_0_f2h_sdram1_data_arlock;
	input	[2:0]	hps_0_f2h_sdram1_data_arprot;
	input		hps_0_f2h_sdram1_data_arvalid;
	input	[3:0]	hps_0_f2h_sdram1_data_arcache;
	input	[31:0]	hps_0_f2h_sdram1_data_awaddr;
	input	[3:0]	hps_0_f2h_sdram1_data_awlen;
	input	[7:0]	hps_0_f2h_sdram1_data_awid;
	input	[2:0]	hps_0_f2h_sdram1_data_awsize;
	input	[1:0]	hps_0_f2h_sdram1_data_awburst;
	input	[1:0]	hps_0_f2h_sdram1_data_awlock;
	input	[2:0]	hps_0_f2h_sdram1_data_awprot;
	input		hps_0_f2h_sdram1_data_awvalid;
	input	[3:0]	hps_0_f2h_sdram1_data_awcache;
	output	[1:0]	hps_0_f2h_sdram1_data_bresp;
	output	[7:0]	hps_0_f2h_sdram1_data_bid;
	output		hps_0_f2h_sdram1_data_bvalid;
	input		hps_0_f2h_sdram1_data_bready;
	output		hps_0_f2h_sdram1_data_arready;
	output		hps_0_f2h_sdram1_data_awready;
	input		hps_0_f2h_sdram1_data_rready;
	output	[63:0]	hps_0_f2h_sdram1_data_rdata;
	output	[1:0]	hps_0_f2h_sdram1_data_rresp;
	output		hps_0_f2h_sdram1_data_rlast;
	output	[7:0]	hps_0_f2h_sdram1_data_rid;
	output		hps_0_f2h_sdram1_data_rvalid;
	input		hps_0_f2h_sdram1_data_wlast;
	input		hps_0_f2h_sdram1_data_wvalid;
	input	[63:0]	hps_0_f2h_sdram1_data_wdata;
	input	[7:0]	hps_0_f2h_sdram1_data_wstrb;
	output		hps_0_f2h_sdram1_data_wready;
	input	[7:0]	hps_0_f2h_sdram1_data_wid;
	input		hps_0_f2h_sdram2_clock_clk;
	input	[31:0]	hps_0_f2h_sdram2_data_araddr;
	input	[3:0]	hps_0_f2h_sdram2_data_arlen;
	input	[7:0]	hps_0_f2h_sdram2_data_arid;
	input	[2:0]	hps_0_f2h_sdram2_data_arsize;
	input	[1:0]	hps_0_f2h_sdram2_data_arburst;
	input	[1:0]	hps_0_f2h_sdram2_data_arlock;
	input	[2:0]	hps_0_f2h_sdram2_data_arprot;
	input		hps_0_f2h_sdram2_data_arvalid;
	input	[3:0]	hps_0_f2h_sdram2_data_arcache;
	input	[31:0]	hps_0_f2h_sdram2_data_awaddr;
	input	[3:0]	hps_0_f2h_sdram2_data_awlen;
	input	[7:0]	hps_0_f2h_sdram2_data_awid;
	input	[2:0]	hps_0_f2h_sdram2_data_awsize;
	input	[1:0]	hps_0_f2h_sdram2_data_awburst;
	input	[1:0]	hps_0_f2h_sdram2_data_awlock;
	input	[2:0]	hps_0_f2h_sdram2_data_awprot;
	input		hps_0_f2h_sdram2_data_awvalid;
	input	[3:0]	hps_0_f2h_sdram2_data_awcache;
	output	[1:0]	hps_0_f2h_sdram2_data_bresp;
	output	[7:0]	hps_0_f2h_sdram2_data_bid;
	output		hps_0_f2h_sdram2_data_bvalid;
	input		hps_0_f2h_sdram2_data_bready;
	output		hps_0_f2h_sdram2_data_arready;
	output		hps_0_f2h_sdram2_data_awready;
	input		hps_0_f2h_sdram2_data_rready;
	output	[127:0]	hps_0_f2h_sdram2_data_rdata;
	output	[1:0]	hps_0_f2h_sdram2_data_rresp;
	output		hps_0_f2h_sdram2_data_rlast;
	output	[7:0]	hps_0_f2h_sdram2_data_rid;
	output		hps_0_f2h_sdram2_data_rvalid;
	input		hps_0_f2h_sdram2_data_wlast;
	input		hps_0_f2h_sdram2_data_wvalid;
	input	[127:0]	hps_0_f2h_sdram2_data_wdata;
	input	[15:0]	hps_0_f2h_sdram2_data_wstrb;
	output		hps_0_f2h_sdram2_data_wready;
	input	[7:0]	hps_0_f2h_sdram2_data_wid;
	output	[66:0]	hps_0_h2f_loan_io_in;
	input	[66:0]	hps_0_h2f_loan_io_out;
	input	[66:0]	hps_0_h2f_loan_io_oe;
	output		hps_0_h2f_user1_clock_clk;
	output		hps_0_i2c2_out_data;
	input		hps_0_i2c2_sda;
	output		hps_0_i2c2_clk_clk;
	input		hps_0_uart1_cts;
	input		hps_0_uart1_dsr;
	input		hps_0_uart1_dcd;
	input		hps_0_uart1_ri;
	output		hps_0_uart1_dtr;
	output		hps_0_uart1_rts;
	output		hps_0_uart1_out1_n;
	output		hps_0_uart1_out2_n;
	input		hps_0_uart1_rxd;
	output		hps_0_uart1_txd;
	inout		hps_io_hps_io_sdio_inst_CMD;
	inout		hps_io_hps_io_sdio_inst_D0;
	inout		hps_io_hps_io_sdio_inst_D1;
	output		hps_io_hps_io_sdio_inst_CLK;
	inout		hps_io_hps_io_sdio_inst_D2;
	inout		hps_io_hps_io_sdio_inst_D3;
	inout		hps_io_hps_io_usb1_inst_D0;
	inout		hps_io_hps_io_usb1_inst_D1;
	inout		hps_io_hps_io_usb1_inst_D2;
	inout		hps_io_hps_io_usb1_inst_D3;
	inout		hps_io_hps_io_usb1_inst_D4;
	inout		hps_io_hps_io_usb1_inst_D5;
	inout		hps_io_hps_io_usb1_inst_D6;
	inout		hps_io_hps_io_usb1_inst_D7;
	input		hps_io_hps_io_usb1_inst_CLK;
	output		hps_io_hps_io_usb1_inst_STP;
	input		hps_io_hps_io_usb1_inst_DIR;
	input		hps_io_hps_io_usb1_inst_NXT;
	output		hps_io_hps_io_spim0_inst_CLK;
	output		hps_io_hps_io_spim0_inst_MOSI;
	input		hps_io_hps_io_spim0_inst_MISO;
	output		hps_io_hps_io_spim0_inst_SS0;
	output		hps_io_hps_io_spim1_inst_CLK;
	output		hps_io_hps_io_spim1_inst_MOSI;
	input		hps_io_hps_io_spim1_inst_MISO;
	output		hps_io_hps_io_spim1_inst_SS0;
	input		hps_io_hps_io_uart0_inst_RX;
	output		hps_io_hps_io_uart0_inst_TX;
	inout		hps_io_hps_io_i2c0_inst_SDA;
	inout		hps_io_hps_io_i2c0_inst_SCL;
	inout		hps_io_hps_io_i2c1_inst_SDA;
	inout		hps_io_hps_io_i2c1_inst_SCL;
	inout		hps_io_hps_io_i2c3_inst_SDA;
	inout		hps_io_hps_io_i2c3_inst_SCL;
	inout		hps_io_hps_io_gpio_inst_GPIO00;
	inout		hps_io_hps_io_gpio_inst_GPIO09;
	inout		hps_io_hps_io_gpio_inst_GPIO44;
	inout		hps_io_hps_io_gpio_inst_LOANIO14;
	inout		hps_io_hps_io_gpio_inst_LOANIO17;
	inout		hps_io_hps_io_gpio_inst_LOANIO19;
	inout		hps_io_hps_io_gpio_inst_LOANIO22;
	inout		hps_io_hps_io_gpio_inst_LOANIO23;
	inout		hps_io_hps_io_gpio_inst_LOANIO25;
	inout		hps_io_hps_io_gpio_inst_LOANIO27;
	inout		hps_io_hps_io_gpio_inst_LOANIO28;
	inout		hps_io_hps_io_gpio_inst_LOANIO29;
	inout		hps_io_hps_io_gpio_inst_LOANIO30;
	inout		hps_io_hps_io_gpio_inst_LOANIO32;
	inout		hps_io_hps_io_gpio_inst_LOANIO33;
	inout		hps_io_hps_io_gpio_inst_LOANIO34;
	inout		hps_io_hps_io_gpio_inst_LOANIO48;
	inout		hps_io_hps_io_gpio_inst_LOANIO53;
	inout		hps_io_hps_io_gpio_inst_LOANIO54;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[15:0]	memory_mem_dq;
	inout	[1:0]	memory_mem_dqs;
	inout	[1:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[1:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	output	[1:0]	pio_rf_leds_external_connection_export;
	output		reset_bridge_0_out_reset_1_reset;
endmodule
