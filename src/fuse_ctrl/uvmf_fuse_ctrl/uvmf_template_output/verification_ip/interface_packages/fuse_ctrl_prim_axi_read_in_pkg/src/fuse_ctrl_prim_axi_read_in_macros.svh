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
// DESCRIPTION: This file contains macros used with the fuse_ctrl_prim_axi_read_in package.
//   These macros include packed struct definitions.  These structs are
//   used to pass data between classes, hvl, and BFM's, hdl.  Use of 
//   structs are more efficient and simpler to modify.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_struct
//      and from_struct methods defined in the macros below that are used in  
//      the fuse_ctrl_prim_axi_read_in_configuration class.
//
  `define fuse_ctrl_prim_axi_read_in_CONFIGURATION_STRUCT \
typedef struct packed  { \
     uvmf_active_passive_t active_passive; \
     uvmf_initiator_responder_t initiator_responder; \
     } fuse_ctrl_prim_axi_read_in_configuration_s;

  `define fuse_ctrl_prim_axi_read_in_CONFIGURATION_TO_STRUCT_FUNCTION \
  virtual function fuse_ctrl_prim_axi_read_in_configuration_s to_struct();\
    fuse_ctrl_prim_axi_read_in_configuration_struct = \
       {\
       this.active_passive,\
       this.initiator_responder\
       };\
    return ( fuse_ctrl_prim_axi_read_in_configuration_struct );\
  endfunction

  `define fuse_ctrl_prim_axi_read_in_CONFIGURATION_FROM_STRUCT_FUNCTION \
  virtual function void from_struct(fuse_ctrl_prim_axi_read_in_configuration_s fuse_ctrl_prim_axi_read_in_configuration_struct);\
      {\
      this.active_passive,\
      this.initiator_responder  \
      } = fuse_ctrl_prim_axi_read_in_configuration_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_monitor_struct
//      and from_monitor_struct methods of the fuse_ctrl_prim_axi_read_in_transaction class.
//
  `define fuse_ctrl_prim_axi_read_in_MONITOR_STRUCT typedef struct packed  { \
  logic [AW-1:0] prim_araddr ; \
  logic prim_arvalid ; \
  logic [$bits(axi_pkg::axi_burst_e)] prim_arburst ; \
  logic [2:0] prim_arsize ; \
  logic [7:0] prim_arlen ; \
  logic [UW-1:0] prim_aruser ; \
  logic [IW-1:0] prim_arid ; \
  logic prim_arlock ; \
  logic prim_rready ; \
     } fuse_ctrl_prim_axi_read_in_monitor_s;

  `define fuse_ctrl_prim_axi_read_in_TO_MONITOR_STRUCT_FUNCTION \
  virtual function fuse_ctrl_prim_axi_read_in_monitor_s to_monitor_struct();\
    fuse_ctrl_prim_axi_read_in_monitor_struct = \
            { \
            this.prim_araddr , \
            this.prim_arvalid , \
            this.prim_arburst , \
            this.prim_arsize , \
            this.prim_arlen , \
            this.prim_aruser , \
            this.prim_arid , \
            this.prim_arlock , \
            this.prim_rready  \
            };\
    return ( fuse_ctrl_prim_axi_read_in_monitor_struct);\
  endfunction\

  `define fuse_ctrl_prim_axi_read_in_FROM_MONITOR_STRUCT_FUNCTION \
  virtual function void from_monitor_struct(fuse_ctrl_prim_axi_read_in_monitor_s fuse_ctrl_prim_axi_read_in_monitor_struct);\
            {\
            this.prim_araddr , \
            this.prim_arvalid , \
            this.prim_arburst , \
            this.prim_arsize , \
            this.prim_arlen , \
            this.prim_aruser , \
            this.prim_arid , \
            this.prim_arlock , \
            this.prim_rready  \
            } = fuse_ctrl_prim_axi_read_in_monitor_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_initiator_struct
//      and from_initiator_struct methods of the fuse_ctrl_prim_axi_read_in_transaction class.
//      Also update the comments in the driver BFM.
//
  `define fuse_ctrl_prim_axi_read_in_INITIATOR_STRUCT typedef struct packed  { \
  logic [AW-1:0] prim_araddr ; \
  logic prim_arvalid ; \
  logic [$bits(axi_pkg::axi_burst_e)] prim_arburst ; \
  logic [2:0] prim_arsize ; \
  logic [7:0] prim_arlen ; \
  logic [UW-1:0] prim_aruser ; \
  logic [IW-1:0] prim_arid ; \
  logic prim_arlock ; \
  logic prim_rready ; \
     } fuse_ctrl_prim_axi_read_in_initiator_s;

  `define fuse_ctrl_prim_axi_read_in_TO_INITIATOR_STRUCT_FUNCTION \
  virtual function fuse_ctrl_prim_axi_read_in_initiator_s to_initiator_struct();\
    fuse_ctrl_prim_axi_read_in_initiator_struct = \
           {\
           this.prim_araddr , \
           this.prim_arvalid , \
           this.prim_arburst , \
           this.prim_arsize , \
           this.prim_arlen , \
           this.prim_aruser , \
           this.prim_arid , \
           this.prim_arlock , \
           this.prim_rready  \
           };\
    return ( fuse_ctrl_prim_axi_read_in_initiator_struct);\
  endfunction

  `define fuse_ctrl_prim_axi_read_in_FROM_INITIATOR_STRUCT_FUNCTION \
  virtual function void from_initiator_struct(fuse_ctrl_prim_axi_read_in_initiator_s fuse_ctrl_prim_axi_read_in_initiator_struct);\
           {\
           this.prim_araddr , \
           this.prim_arvalid , \
           this.prim_arburst , \
           this.prim_arsize , \
           this.prim_arlen , \
           this.prim_aruser , \
           this.prim_arid , \
           this.prim_arlock , \
           this.prim_rready  \
           } = fuse_ctrl_prim_axi_read_in_initiator_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_responder_struct
//      and from_responder_struct methods of the fuse_ctrl_prim_axi_read_in_transaction class.
//      Also update the comments in the driver BFM.
//
  `define fuse_ctrl_prim_axi_read_in_RESPONDER_STRUCT typedef struct packed  { \
  logic [AW-1:0] prim_araddr ; \
  logic prim_arvalid ; \
  logic [$bits(axi_pkg::axi_burst_e)] prim_arburst ; \
  logic [2:0] prim_arsize ; \
  logic [7:0] prim_arlen ; \
  logic [UW-1:0] prim_aruser ; \
  logic [IW-1:0] prim_arid ; \
  logic prim_arlock ; \
  logic prim_rready ; \
     } fuse_ctrl_prim_axi_read_in_responder_s;

  `define fuse_ctrl_prim_axi_read_in_TO_RESPONDER_STRUCT_FUNCTION \
  virtual function fuse_ctrl_prim_axi_read_in_responder_s to_responder_struct();\
    fuse_ctrl_prim_axi_read_in_responder_struct = \
           {\
           this.prim_araddr , \
           this.prim_arvalid , \
           this.prim_arburst , \
           this.prim_arsize , \
           this.prim_arlen , \
           this.prim_aruser , \
           this.prim_arid , \
           this.prim_arlock , \
           this.prim_rready  \
           };\
    return ( fuse_ctrl_prim_axi_read_in_responder_struct);\
  endfunction

  `define fuse_ctrl_prim_axi_read_in_FROM_RESPONDER_STRUCT_FUNCTION \
  virtual function void from_responder_struct(fuse_ctrl_prim_axi_read_in_responder_s fuse_ctrl_prim_axi_read_in_responder_struct);\
           {\
           this.prim_araddr , \
           this.prim_arvalid , \
           this.prim_arburst , \
           this.prim_arsize , \
           this.prim_arlen , \
           this.prim_aruser , \
           this.prim_arid , \
           this.prim_arlock , \
           this.prim_rready  \
           } = fuse_ctrl_prim_axi_read_in_responder_struct;\
  endfunction
// pragma uvmf custom additional begin
// pragma uvmf custom additional end
