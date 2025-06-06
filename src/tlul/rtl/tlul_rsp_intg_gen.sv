// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`include "caliptra_prim_assert.sv"

/**
 * Tile-Link UL response integrity generator
 */

module tlul_rsp_intg_gen import tlul_pkg::*; #(
  parameter bit EnableRspIntgGen = 1'b1,
  parameter bit EnableDataIntgGen = 1'b1
) (
  // TL-UL interface
  input  tl_d2h_t tl_i,
  output tl_d2h_t tl_o
);

  logic [D2HRspIntgWidth-1:0] rsp_intg;
  if (EnableRspIntgGen) begin : gen_rsp_intg
    tl_d2h_rsp_intg_t rsp;
    logic [D2HRspMaxWidth-1:0] unused_payload;

    assign rsp = extract_d2h_rsp_intg(tl_i);

    caliptra_prim_secded_inv_64_57_enc u_rsp_gen (
      .data_i(D2HRspMaxWidth'(rsp)),
      .data_o({rsp_intg, unused_payload})
    );
  end else begin : gen_passthrough_rsp_intg
    assign rsp_intg = tl_i.d_user.rsp_intg;
  end

  logic [DataIntgWidth-1:0] data_intg;
  if (EnableDataIntgGen) begin : gen_data_intg
    logic [DataMaxWidth-1:0] unused_data;
    tlul_data_integ_enc u_tlul_data_integ_enc (
      .data_i(DataMaxWidth'(tl_i.d_data)),
      .data_intg_o({data_intg, unused_data})
    );
  end else begin : gen_passthrough_data_intg
    assign data_intg = tl_i.d_user.data_intg;
  end

  always_comb begin
    tl_o = tl_i;
    tl_o.d_user.rsp_intg = rsp_intg;
    tl_o.d_user.data_intg = data_intg;
  end

  logic unused_tl;
  assign unused_tl = ^tl_i;


  `CALIPTRA_ASSERT_INIT(PayLoadWidthCheck, $bits(tl_d2h_rsp_intg_t) <= D2HRspMaxWidth)
  `CALIPTRA_ASSERT_INIT(DataWidthCheck_A, $bits(tl_i.d_data) <= DataMaxWidth)

endmodule // tlul_rsp_intg_gen
