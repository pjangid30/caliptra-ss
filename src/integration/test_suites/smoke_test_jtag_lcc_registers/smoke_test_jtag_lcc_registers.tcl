# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

init

set script_dir [file dirname [info script]]
source [file join $script_dir common.tcl]

array set tokens {
    0,0 0x00000000  0,1 0x00000000  0,2 0x00000000  0,3 0x00000000
    1,0 0x00000000  1,1 0x00000000  1,2 0x00000000  1,3 0x00000000
    2,0 0x00000000  2,1 0x00000000  2,2 0x00000000  2,3 0x00000000
    3,0 0x72f04808  3,1 0x05f493b4  3,2 0x7790628a  3,3 0x318372c8
    4,0 0x00000000  4,1 0x00000000  4,2 0x00000000  4,3 0x00000000
    5,0 0x17c78a78  5,1 0xc7b443ef  5,2 0xd6931045  5,3 0x55e74f3c
    6,0 0x00000000  6,1 0x00000000  6,2 0x00000000  6,3 0x00000000
    7,0 0x1644aa12  7,1 0x79925802  7,2 0xdbc26815  7,3 0x8597a5fa
    8,0 0x00000000  8,1 0x00000000  8,2 0x00000000  8,3 0x00000000
    9,0 0x34d1ea6e  9,1 0x121f023f  9,2 0x6e9dc51c  9,3 0xc7439b6f
   10,0 0x00000000 10,1 0x00000000 10,2 0x00000000 10,3 0x00000000
   11,0 0x03fd9df1 11,1 0x20978af4 11,2 0x49db216d 11,3 0xb0225ece
   12,0 0x00000000 12,1 0x00000000 12,2 0x00000000 12,3 0x00000000
   13,0 0xcfc0871c 13,1 0xc400e922 13,2 0x4290a4ad 13,3 0x7f10dc89
   14,0 0x00000000 14,1 0x00000000 14,2 0x00000000 14,3 0x00000000
   15,0 0x67e87f3e 15,1 0xae6ee167 15,2 0x802efa05 15,3 0xbaaa3138
   16,0 0x2f533ae9 16,1 0x341d2478 16,2 0x5f066362 16,3 0xb5fe1577
   17,0 0xf622abb6 17,1 0x5d8318f4 17,2 0xc721179d 17,3 0x51c001f2
   18,0 0x25b8649d 18,1 0xe7818e5b 18,2 0x826d5ba4 18,3 0xd6b633a0
   19,0 0x00000000 19,1 0x00000000 19,2 0x00000000 19,3 0x00000000
   20,0 0x00000000 20,1 0x00000000 20,2 0x00000000 20,3 0x00000000
}

#––– Initialize the controller and re‑read state –––
lcc_initialization

test_read_only_registers
test_write_only_registers
test_transition_cmd_ctrl_registers
test_read_write_registers 0
test_transition_if 0
test_read_write_registers 1
# Skip this test as it activates the CLAIM_TRANSITION_IF_REGWEN
# which we cannot revert.
#test_transition_if 1

# Claim the TRANSITION_IF mutex.
riscv dmi_write $LC_CTRL_CLAIM_TRANSITION_IF_OFFSET $MUBITRUE
# Write the magic token that the smoke_test_jtag_lcc_registers
# C program is waiting for.
riscv dmi_write $LC_CTRL_TRANSITION_TOKEN_0_OFFSET 0xABCDEFCA
set t0 [riscv dmi_read $LC_CTRL_TRANSITION_TOKEN_0_OFFSET]
puts "Info: The test complete cmd was triggered: $t0"
# Releate the TRANSITION_IF mutex. 
riscv dmi_write $LC_CTRL_CLAIM_TRANSITION_IF_OFFSET 0

shutdown
