//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// SPDX-License-Identifier: Apache-2.0
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

// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// DESCRIPTION: Protocol specific agent class definition
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class fuse_ctrl_core_axi_write_in_agent #(
     int AW = 32,
     int DW = 32,
     int IW = 3,
     int UW = 32
     ) extends uvmf_parameterized_agent #(
                    .CONFIG_T(fuse_ctrl_core_axi_write_in_configuration #(
                              .AW(AW),
                              .DW(DW),
                              .IW(IW),
                              .UW(UW)
                              )),
                    .DRIVER_T(fuse_ctrl_core_axi_write_in_driver #(
                              .AW(AW),
                              .DW(DW),
                              .IW(IW),
                              .UW(UW)
                              )),
                    .MONITOR_T(fuse_ctrl_core_axi_write_in_monitor #(
                               .AW(AW),
                               .DW(DW),
                               .IW(IW),
                               .UW(UW)
                               )),
                    .COVERAGE_T(fuse_ctrl_core_axi_write_in_transaction_coverage #(
                                .AW(AW),
                                .DW(DW),
                                .IW(IW),
                                .UW(UW)
                                )),
                    .TRANS_T(fuse_ctrl_core_axi_write_in_transaction #(
                             .AW(AW),
                             .DW(DW),
                             .IW(IW),
                             .UW(UW)
                             ))
                    );

  `uvm_component_param_utils( fuse_ctrl_core_axi_write_in_agent #(
                              AW,
                              DW,
                              IW,
                              UW
                              ))

// pragma uvmf custom class_item_additional begin
// pragma uvmf custom class_item_additional end

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
  // FUNCTION: build_phase
  virtual function void build_phase(uvm_phase phase);
// pragma uvmf custom build_phase_pre_super begin
// pragma uvmf custom build_phase_pre_super end
    super.build_phase(phase);
    if (configuration.active_passive == ACTIVE) begin
      // Place sequencer handle into configuration object
      // so that it may be retrieved from configuration 
      // rather than using uvm_config_db
      configuration.sequencer = this.sequencer;
    end
  endfunction
  
endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

