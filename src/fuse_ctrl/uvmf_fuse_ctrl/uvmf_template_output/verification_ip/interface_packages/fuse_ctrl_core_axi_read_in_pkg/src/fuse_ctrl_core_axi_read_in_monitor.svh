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
// DESCRIPTION: This class receives fuse_ctrl_core_axi_read_in transactions observed by the
//     fuse_ctrl_core_axi_read_in monitor BFM and broadcasts them through the analysis port
//     on the agent. It accesses the monitor BFM through the monitor
//     task. This UVM component captures transactions
//     for viewing in the waveform viewer if the
//     enable_transaction_viewing flag is set in the configuration.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class fuse_ctrl_core_axi_read_in_monitor #(
      int AW = 32,
      int DW = 32,
      int IW = 3,
      int UW = 32
      ) extends uvmf_monitor_base #(
                    .CONFIG_T(fuse_ctrl_core_axi_read_in_configuration  #(
                             .AW(AW),
                             .DW(DW),
                             .IW(IW),
                             .UW(UW)
                             )),
                    .BFM_BIND_T(virtual fuse_ctrl_core_axi_read_in_monitor_bfm  #(
                             .AW(AW),
                             .DW(DW),
                             .IW(IW),
                             .UW(UW)
                             )),
                    .TRANS_T(fuse_ctrl_core_axi_read_in_transaction  #(
                             .AW(AW),
                             .DW(DW),
                             .IW(IW),
                             .UW(UW)
                             )));

  `uvm_component_param_utils( fuse_ctrl_core_axi_read_in_monitor #(
                              AW,
                              DW,
                              IW,
                              UW
                              ))

// Structure used to pass data from monitor BFM to monitor class in agent.
// Use to_monitor_struct function to pack transaction variables into structure.
// Use from_monitor_struct function to unpack transaction variables from structure.
`fuse_ctrl_core_axi_read_in_MONITOR_STRUCT

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
// ****************************************************************************
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
// This function sends configuration object variables to the monitor BFM 
// using the configuration struct.
//
   virtual function void configure(input CONFIG_T cfg);
      bfm.configure( cfg.to_struct() );

   endfunction

// ****************************************************************************
// This function places a handle to this class in the proxy variable in the
// monitor BFM.  This allows the monitor BFM to call the notify_transaction
// function within this class.
//
   virtual function void set_bfm_proxy_handle();
      bfm.proxy = this;   endfunction

// ***************************************************************************              
  virtual task run_phase(uvm_phase phase);                                                   
  // Start monitor BFM thread and don't call super.run() in order to                       
  // override the default monitor proxy 'pull' behavior with the more                      
  // emulation-friendly BFM 'push' approach using the notify_transaction                   
  // function below                                                                        
  bfm.start_monitoring();                                                   
  endtask                                                                                    
  
// **************************************************************************  
  
// This function is called by the monitor BFM.  It receives data observed by the
// monitor BFM.  Data is passed using the fuse_ctrl_core_axi_read_in_monitor_struct.          
 virtual function void notify_transaction(input fuse_ctrl_core_axi_read_in_monitor_s fuse_ctrl_core_axi_read_in_monitor_struct);
 
 
    trans = new("trans");
    trans.from_monitor_struct(fuse_ctrl_core_axi_read_in_monitor_struct);
    trans.start_time = time_stamp;                                                          
    trans.end_time = $time;                                                                 
    time_stamp = trans.end_time;
 
    analyze(trans);                                                                         
  endfunction  

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

