
//********************************************************************************
// SPDX-License-Identifier: Apache-2.0
// 
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//********************************************************************************
module caliptra_ss_sram #(
   parameter DEPTH      = 64
  ,parameter DATA_WIDTH = 32
  ,parameter ADDR_WIDTH = $clog2(DEPTH)
) (
  input  logic                       clk_i,
  input  logic                       cs_i,
  input  logic                       we_i,
  input  logic [ADDR_WIDTH-1:0]      addr_i,
  input  logic [DATA_WIDTH-1:0]      wdata_i,
  output logic [DATA_WIDTH-1:0]      rdata_o
);


  bit [ DATA_WIDTH-1:0] ram[0:DEPTH-1];

  always @(posedge clk_i) begin
    if (cs_i & we_i) begin
      ram[addr_i] <= wdata_i;
    end
    if (cs_i & ~we_i) begin
      rdata_o <= ram[addr_i];
    end
  end

endmodule
