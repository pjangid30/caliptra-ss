// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

package otp_ctrl_pkg;

  import caliptra_prim_util_pkg::vbits;
  import otp_ctrl_reg_pkg::*;
  import ast_pkg::*;

  ////////////////////////
  // General Parameters //
  ////////////////////////

  // Number of vendor-specific test CSR bits coming from and going to
  // the life cycle TAP registers.
  parameter int OtpTestCtrlWidth   = 32;
  parameter int OtpTestStatusWidth = 32;
  parameter int OtpTestVectWidth   = 8;

  // Width of entropy input
  parameter int EdnDataWidth = 64;

  parameter int NumPartWidth = vbits(NumPart);

  parameter int SwWindowAddrWidth = vbits(NumSwCfgWindowWords);

  // Background check timer LFSR width.
  parameter int LfsrWidth = 40;
  // The LFSR will be reseeded once LfsrUsageThreshold
  // values have been drawn from it.
  parameter int LfsrUsageThreshold = 16;

  // Redundantly encoded and complementary values are used to for signalling to the partition
  // controller FSMs and the DAI whether a partition is locked or not. Any other value than
  // "Mubi8Lo" is interpreted as "Locked" in those FSMs.
  typedef struct packed {
    caliptra_prim_mubi_pkg::mubi8_t read_lock;
    caliptra_prim_mubi_pkg::mubi8_t write_lock;
  } part_access_t;

  parameter int DaiCmdWidth = 3;
  typedef enum logic [DaiCmdWidth-1:0] {
    DaiRead   = 3'b001,
    DaiWrite  = 3'b010,
    DaiDigest = 3'b100
  } dai_cmd_e;

  parameter int DeviceIdWidth = 256;
  typedef logic [DeviceIdWidth-1:0] otp_device_id_t;

  parameter int ManufStateWidth = 256;
  typedef logic [ManufStateWidth-1:0] otp_manuf_state_t;

  //////////////////////////////////////
  // Typedefs for OTP Macro Interface //
  //////////////////////////////////////

  // OTP-macro specific
  parameter int OtpWidth         = 16;
  parameter int OtpAddrWidth     = OtpByteAddrWidth - $clog2(OtpWidth/8);
  parameter int OtpDepth         = 2**OtpAddrWidth;
  parameter int OtpSizeWidth     = 2; // Allows to transfer up to 4 native OTP words at once.
  parameter int OtpErrWidth      = 3;
  parameter int OtpPwrSeqWidth   = 2;
  parameter int OtpIfWidth       = 2**OtpSizeWidth*OtpWidth;
  // Number of Byte address bits to cut off in order to get the native OTP word address.
  parameter int OtpAddrShift     = OtpByteAddrWidth - OtpAddrWidth;

  typedef enum logic [OtpErrWidth-1:0] {
    NoError              = 3'h0,
    MacroError           = 3'h1,
    MacroEccCorrError    = 3'h2,
    MacroEccUncorrError  = 3'h3,
    MacroWriteBlankError = 3'h4,
    AccessError          = 3'h5,
    CheckFailError       = 3'h6,
    FsmStateError        = 3'h7
  } otp_err_e;

  /////////////////////////////////
  // Typedefs for OTP Scrambling //
  /////////////////////////////////

  parameter int ScrmblKeyWidth   = 128;
  parameter int ScrmblBlockWidth = 64;

  parameter int NumPresentRounds = 31;
  parameter int ScrmblBlockHalfWords = ScrmblBlockWidth / OtpWidth;

  typedef enum logic [2:0] {
    Decrypt,
    Encrypt,
    LoadShadow,
    Digest,
    DigestInit,
    DigestFinalize
  } otp_scrmbl_cmd_e;

  ///////////////////////////////
  // Typedefs for LC Interface //
  ///////////////////////////////

  // The tokens below are all hash post-images
  typedef struct packed {
    logic                            valid;
    logic                            error;
    // Use lc_state_t and lc_cnt_t here as very wide enumerations ( > 64 bits )
    // are not supported for virtual interfaces by Excelium yet
    // https://github.com/lowRISC/opentitan/issues/8884 (Cadence issue: cds_46570160)
    // The enumeration types lc_state_e and lc_cnt_e are still ok in other circumstances
    lc_ctrl_state_pkg::lc_state_t    state;
    lc_ctrl_state_pkg::lc_cnt_t      count;
    // This is set to "On" if the partition containing the
    // root secrets have been locked. In that case, the device
    // is considered "personalized".
    lc_ctrl_pkg::lc_tx_t             secrets_valid;
    // This is set to "On" if the partition containing the
    // test tokens has been locked.
    lc_ctrl_pkg::lc_tx_t             test_tokens_valid;
    lc_ctrl_state_pkg::lc_token_t    test_unlock_token;
    lc_ctrl_state_pkg::lc_token_t    test_exit_dev_token;
    lc_ctrl_state_pkg::lc_token_t    dev_exit_prod_token;
    lc_ctrl_state_pkg::lc_token_t    prod_exit_prodend_token;
    // This is set to "On" if the partition containing the
    // rma token has been locked.
    lc_ctrl_pkg::lc_tx_t             rma_token_valid;
    lc_ctrl_state_pkg::lc_token_t    rma_token;
  } otp_lc_data_t;

  // Default for dangling connection.
  // Note that we put the life cycle into
  // TEST_UNLOCKED0 by default such that top levels without
  // the OTP controller can still function.
  parameter otp_lc_data_t OTP_LC_DATA_DEFAULT = '{
    valid: 1'b1,
    error: 1'b0,
    state: lc_ctrl_state_pkg::LcStTestUnlocked0,
    count: lc_ctrl_state_pkg::LcCnt1,
    secrets_valid: lc_ctrl_pkg::Off,
    test_tokens_valid: lc_ctrl_pkg::Off,
    test_unlock_token: '0,
    test_exit_dev_token: '0,
    dev_exit_prod_token: '0,
    prod_exit_prodend_token: '0,
    rma_token_valid: lc_ctrl_pkg::Off,
    rma_token: '0
  };

  typedef struct packed {
    logic req;
    lc_ctrl_state_pkg::lc_state_e state;
    lc_ctrl_state_pkg::lc_cnt_e   count;
  } lc_otp_program_req_t;

  typedef struct packed {
    logic err;
    logic ack;
  } lc_otp_program_rsp_t;

  // RAW unlock token hashing request.
  typedef struct packed {
    logic req;
    lc_ctrl_state_pkg::lc_token_t token_input;
  } lc_otp_token_req_t;

  typedef struct packed {
    logic ack;
    lc_ctrl_state_pkg::lc_token_t hashed_token;
  } lc_otp_token_rsp_t;

  typedef struct packed {
    logic [OtpTestCtrlWidth-1:0] ctrl;
  } lc_otp_vendor_test_req_t;

  typedef struct packed {
    logic [OtpTestStatusWidth-1:0] status;
  } lc_otp_vendor_test_rsp_t;

  ////////////////////////////////
  // Typedefs for Key Broadcast //
  ////////////////////////////////

  parameter int FlashKeySeedWidth = 256;
  parameter int SramKeySeedWidth  = 128;
  parameter int KeyMgrKeyWidth    = 256;
  parameter int FlashKeyWidth     = 128;
  parameter int SramKeyWidth      = 128;
  parameter int SramNonceWidth    = 128;
  parameter int OtbnKeyWidth      = 128;
  parameter int OtbnNonceWidth    = 64;

  typedef logic [SramKeyWidth-1:0]   sram_key_t;
  typedef logic [SramNonceWidth-1:0] sram_nonce_t;
  typedef logic [OtbnKeyWidth-1:0]   otbn_key_t;
  typedef logic [OtbnNonceWidth-1:0] otbn_nonce_t;

  localparam int OtbnNonceSel  = OtbnNonceWidth / ScrmblBlockWidth;
  localparam int FlashNonceSel = FlashKeyWidth / ScrmblBlockWidth;
  localparam int SramNonceSel  = SramNonceWidth / ScrmblBlockWidth;

  // Get maximum nonce width
  localparam int NumNonceChunks =
    (OtbnNonceWidth > FlashKeyWidth) ?
    ((OtbnNonceWidth > SramNonceSel) ? OtbnNonceSel : SramNonceSel) :
    ((FlashKeyWidth > SramNonceSel)  ? FlashNonceSel  : SramNonceSel);

  typedef struct packed {
    logic [KeyMgrKeyWidth-1:0] creator_root_key_share0;
    logic creator_root_key_share0_valid;
    logic [KeyMgrKeyWidth-1:0] creator_root_key_share1;
    logic creator_root_key_share1_valid;
    logic [KeyMgrKeyWidth-1:0] creator_seed;
    logic creator_seed_valid;
    logic [KeyMgrKeyWidth-1:0] owner_seed;
    logic owner_seed_valid;
  } otp_keymgr_key_t;

  parameter otp_keymgr_key_t OTP_KEYMGR_KEY_DEFAULT = '{
    creator_root_key_share0: 256'hefb7ea7ee90093cf4affd9aaa2d6c0ec446cfdf5f2d5a0bfd7e2d93edc63a102,
    creator_root_key_share0_valid: 1'b1,
    creator_root_key_share1: 256'h56d24a00181de99e0f690b447a8dde2a1ffb8bc306707107aa6e2410f15cfc37,
    creator_root_key_share1_valid: 1'b1,
    creator_seed: 256'hc7c50b38655cc87f821e5b07fed85d2c07e222a9e00bef308b3eccba0ba406fa,
    creator_seed_valid: 1'b1,
    owner_seed: 256'hf5052c0f14782d8b066be9f49c0b2000d3643ff3723ea7db972f69cd3e2e3e68,
    owner_seed_valid: 1'b1
  };

  typedef struct packed {
    logic data_req; // Requests static key for data scrambling.
    logic addr_req; // Requests static key for address scrambling.
  } flash_otp_key_req_t;

  typedef struct packed {
    logic req; // Requests ephemeral scrambling key and nonce.
  } sram_otp_key_req_t;

  typedef struct packed {
    logic req; // Requests ephemeral scrambling key and nonce.
  } otbn_otp_key_req_t;

  typedef struct packed {
    logic data_ack;                    // Ack for data key.
    logic addr_ack;                    // Ack for address key.
    logic [FlashKeyWidth-1:0] key;     // 128bit static scrambling key.
    logic [FlashKeyWidth-1:0] rand_key;
    logic seed_valid;                  // Set to 1 if the key seed has been provisioned and is
                                       // valid.
  } flash_otp_key_rsp_t;

  // Default for dangling connection
  parameter flash_otp_key_rsp_t FLASH_OTP_KEY_RSP_DEFAULT = '{
    data_ack: 1'b1,
    addr_ack: 1'b1,
    key: '0,
    rand_key: '0,
    seed_valid: 1'b1
  };

  typedef struct packed {
    logic        ack;        // Ack for key.
    sram_key_t   key;        // 128bit ephemeral scrambling key.
    sram_nonce_t nonce;      // 128bit nonce.
    logic        seed_valid; // Set to 1 if the key seed has been provisioned and is valid.
  } sram_otp_key_rsp_t;

  // Default for dangling connection
  parameter sram_otp_key_rsp_t SRAM_OTP_KEY_RSP_DEFAULT = '{
    ack: 1'b1,
    key: '0,
    nonce: '0,
    seed_valid: 1'b1
  };

  typedef struct packed {
    logic        ack;        // Ack for key.
    otbn_key_t   key;        // 128bit ephemeral scrambling key.
    otbn_nonce_t nonce;      // 256bit nonce.
    logic        seed_valid; // Set to 1 if the key seed has been provisioned and is valid.
  } otbn_otp_key_rsp_t;

  ////////////////////////////////
  // Power/Reset Ctrl Interface //
  ////////////////////////////////

  typedef struct packed {
    logic init;
  } pwr_otp_init_req_t;

  typedef struct packed {
    logic done;
  } pwr_otp_init_rsp_t;

  typedef struct packed {
    logic idle;
  } otp_pwr_state_t;


  ///////////////////
  // AST Interface //
  ///////////////////

  typedef struct packed {
    logic [OtpPwrSeqWidth-1:0] pwr_seq;
  } otp_ast_req_t;

  typedef struct packed {
    logic [OtpPwrSeqWidth-1:0] pwr_seq_h;
  } otp_ast_rsp_t;

  ///////////////////////////////////////////
  // Defaults for random netlist constants //
  ///////////////////////////////////////////

  // These LFSR parameters have been generated with
  // $ util/design/gen-lfsr-seed.py --width 40 --seed 4247488366
  typedef logic [LfsrWidth-1:0]                        lfsr_seed_t;
  typedef logic [LfsrWidth-1:0][$clog2(LfsrWidth)-1:0] lfsr_perm_t;
  localparam lfsr_seed_t RndCnstLfsrSeedDefault = 40'h453d28ea98;
  localparam lfsr_perm_t RndCnstLfsrPermDefault =
      240'h4235171482c225f79289b32181a0163a760355d3447063d16661e44c12a5;

  typedef struct packed {
    sram_key_t   key;
    sram_nonce_t nonce;
  } scrmbl_key_init_t;
  localparam scrmbl_key_init_t RndCnstScrmblKeyInitDefault =
      256'hcebeb96ffe0eced795f8b2cfe23c1e519e4fa08047a6bcfb811b04f0a479006e;


  
  typedef enum logic [2:0] {
    RESET_ST                   = 3'd0,
    IDLE_ST                    = 3'd1,
    WDATA_ADDR_ST              = 3'd2,
    WDATA_ST                   = 3'd3,
    FUSE_ADDR_AXI_ADDR_ST      = 3'd4,
    FUSE_ADDR_AXI_WR_ST        = 3'd5,
    FUSE_CMD_AXI_ADDR_ST       = 3'd6,
    DISCARD_FUSE_CMD_AXI_WR_ST = 3'd7
  } fc_table_state_t;


  typedef struct packed {
    logic [31:0] lower_addr;  // Lower bound of the address range
    logic [31:0] upper_addr;  // Upper bound of the address range
  } access_control_entry_t;
  
  localparam int FC_TABLE_NUM_RANGES = 2;
  
  localparam access_control_entry_t access_control_table [FC_TABLE_NUM_RANGES] = '{
    '{ lower_addr: 32'h00000000, upper_addr: 32'h00000FD8}, // Caliptra core
    '{ lower_addr: 32'h00000090, upper_addr: 32'h00000FD8}  // MCU core
  };

    //------------------------------------------------------------------
    // Typedef for PRIM GENERIC Module Inputs
    //------------------------------------------------------------------
    typedef struct packed {
      // Clock, reset, and observability
      logic                         clk_i;
      logic                         rst_ni;
      ast_pkg::ast_obs_ctrl_t       obs_ctrl_i;
  
      // Power sequencing (input from host)
      logic [OtpPwrSeqWidth-1:0]       pwr_seq_h_i;

  
      // DFT signals
      caliptra_prim_mubi_pkg::mubi4_t scanmode_i;
      logic                         scan_en_i;
      logic                         scan_rst_ni;
  
      // Ready/valid handshake and command channel
      logic                            valid_i;
      logic [OtpSizeWidth-1:0]         size_i;   // (Native words)-1
      caliptra_prim_otp_pkg::cmd_e     cmd_i;
      logic [OtpAddrWidth-1:0]         addr_i;
      logic [OtpIfWidth-1:0]           wdata_i;
    } prim_generic_otp_inputs_t;
  
    //------------------------------------------------------------------
    // Typedef for PRIM GENERIC Module Outputs
    //------------------------------------------------------------------
    typedef struct packed {
      // Observability output
      logic [7:0]                 otp_obs_o;
  
      // Power sequencing output
      logic [OtpPwrSeqWidth-1:0]     pwr_seq_o;
  
  
      // Alert signals
      logic                       fatal_alert_o;
      logic                       recov_alert_o;
  
      // Ready/valid handshake and response channel
      logic                       ready_o;
      logic                       valid_o;
      logic [OtpIfWidth-1:0]         rdata_o;
      caliptra_prim_otp_pkg::err_e     err_o;
    } prim_generic_otp_outputs_t;

endpackage : otp_ctrl_pkg
