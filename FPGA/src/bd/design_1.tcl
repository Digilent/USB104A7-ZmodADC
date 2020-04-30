
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a100tcsg324-1
   set_property BOARD_PART digilentinc.com:usb104-a7:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
digilentinc.com:IP:AXI_DPTI:1.1\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axi_iic:2.0\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:mig_7series:4.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:util_vector_logic:2.0\
natinst.com:user:AXI_ZmodADC1410:1.0\
xilinx.com:user:ZmodADC1410_Controller:1.0\
xilinx.com:ip:ila:6.2\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:blk_mem_gen:8.4\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}


##################################################################
# MIG PRJ FILE TCL PROCs
##################################################################

proc write_mig_file_design_1_mig_7series_0_2 { str_mig_prj_filepath } {

   file mkdir [ file dirname "$str_mig_prj_filepath" ]
   set mig_prj_file [open $str_mig_prj_filepath  w+]

   puts $mig_prj_file {﻿<?xml version="1.0" encoding="UTF-8" standalone="no" ?>}
   puts $mig_prj_file {<Project NoOfControllers="1">}
   puts $mig_prj_file {  <!-- IMPORTANT: This is an internal file that has been generated by the MIG software. Any direct editing or changes made to this file may result in unpredictable behavior or data corruption. It is strongly advised that users do not edit the contents of this file. Re-run the MIG GUI with the required settings if any of the options provided below need to be altered. -->}
   puts $mig_prj_file {  <ModuleName>design_1_mig_7series_0_2</ModuleName>}
   puts $mig_prj_file {  <dci_inouts_inputs>1</dci_inouts_inputs>}
   puts $mig_prj_file {  <dci_inputs>1</dci_inputs>}
   puts $mig_prj_file {  <Debug_En>OFF</Debug_En>}
   puts $mig_prj_file {  <DataDepth_En>1024</DataDepth_En>}
   puts $mig_prj_file {  <LowPower_En>ON</LowPower_En>}
   puts $mig_prj_file {  <XADC_En>Enabled</XADC_En>}
   puts $mig_prj_file {  <TargetFPGA>xc7a100t-csg324/-1</TargetFPGA>}
   puts $mig_prj_file {  <Version>4.2</Version>}
   puts $mig_prj_file {  <SystemClock>No Buffer</SystemClock>}
   puts $mig_prj_file {  <ReferenceClock>Use System Clock</ReferenceClock>}
   puts $mig_prj_file {  <SysResetPolarity>ACTIVE LOW</SysResetPolarity>}
   puts $mig_prj_file {  <BankSelectionFlag>FALSE</BankSelectionFlag>}
   puts $mig_prj_file {  <InternalVref>1</InternalVref>}
   puts $mig_prj_file {  <dci_hr_inouts_inputs>40 Ohms</dci_hr_inouts_inputs>}
   puts $mig_prj_file {  <dci_cascade>0</dci_cascade>}
   puts $mig_prj_file {  <Controller number="0">}
   puts $mig_prj_file {    <MemoryDevice>DDR3_SDRAM/Components/MT41K256M16XX-107</MemoryDevice>}
   puts $mig_prj_file {    <TimePeriod>2500</TimePeriod>}
   puts $mig_prj_file {    <VccAuxIO>1.8V</VccAuxIO>}
   puts $mig_prj_file {    <PHYRatio>4:1</PHYRatio>}
   puts $mig_prj_file {    <InputClkFreq>200</InputClkFreq>}
   puts $mig_prj_file {    <UIExtraClocks>0</UIExtraClocks>}
   puts $mig_prj_file {    <MMCM_VCO>800</MMCM_VCO>}
   puts $mig_prj_file {    <MMCMClkOut0> 1.000</MMCMClkOut0>}
   puts $mig_prj_file {    <MMCMClkOut1>1</MMCMClkOut1>}
   puts $mig_prj_file {    <MMCMClkOut2>1</MMCMClkOut2>}
   puts $mig_prj_file {    <MMCMClkOut3>1</MMCMClkOut3>}
   puts $mig_prj_file {    <MMCMClkOut4>1</MMCMClkOut4>}
   puts $mig_prj_file {    <DataWidth>16</DataWidth>}
   puts $mig_prj_file {    <DeepMemory>1</DeepMemory>}
   puts $mig_prj_file {    <DataMask>1</DataMask>}
   puts $mig_prj_file {    <ECC>Disabled</ECC>}
   puts $mig_prj_file {    <Ordering>Normal</Ordering>}
   puts $mig_prj_file {    <BankMachineCnt>4</BankMachineCnt>}
   puts $mig_prj_file {    <CustomPart>FALSE</CustomPart>}
   puts $mig_prj_file {    <NewPartName></NewPartName>}
   puts $mig_prj_file {    <RowAddress>15</RowAddress>}
   puts $mig_prj_file {    <ColAddress>10</ColAddress>}
   puts $mig_prj_file {    <BankAddress>3</BankAddress>}
   puts $mig_prj_file {    <MemoryVoltage>1.5V</MemoryVoltage>}
   puts $mig_prj_file {    <C0_MEM_SIZE>536870912</C0_MEM_SIZE>}
   puts $mig_prj_file {    <UserMemoryAddressMap>BANK_ROW_COLUMN</UserMemoryAddressMap>}
   puts $mig_prj_file {    <PinSelection>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="R6" SLEW="" VCCAUX_IO="" name="ddr3_addr[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="P2" SLEW="" VCCAUX_IO="" name="ddr3_addr[10]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="P5" SLEW="" VCCAUX_IO="" name="ddr3_addr[11]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="R1" SLEW="" VCCAUX_IO="" name="ddr3_addr[12]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="U8" SLEW="" VCCAUX_IO="" name="ddr3_addr[13]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="N6" SLEW="" VCCAUX_IO="" name="ddr3_addr[14]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="R7" SLEW="" VCCAUX_IO="" name="ddr3_addr[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="T6" SLEW="" VCCAUX_IO="" name="ddr3_addr[2]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="U7" SLEW="" VCCAUX_IO="" name="ddr3_addr[3]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="T1" SLEW="" VCCAUX_IO="" name="ddr3_addr[4]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="V7" SLEW="" VCCAUX_IO="" name="ddr3_addr[5]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="P3" SLEW="" VCCAUX_IO="" name="ddr3_addr[6]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="T8" SLEW="" VCCAUX_IO="" name="ddr3_addr[7]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="M6" SLEW="" VCCAUX_IO="" name="ddr3_addr[8]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="R8" SLEW="" VCCAUX_IO="" name="ddr3_addr[9]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="V6" SLEW="" VCCAUX_IO="" name="ddr3_ba[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="R2" SLEW="" VCCAUX_IO="" name="ddr3_ba[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="R5" SLEW="" VCCAUX_IO="" name="ddr3_ba[2]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="N4" SLEW="" VCCAUX_IO="" name="ddr3_cas_n"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="V9" SLEW="" VCCAUX_IO="" name="ddr3_ck_n[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="U9" SLEW="" VCCAUX_IO="" name="ddr3_ck_p[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="N5" SLEW="" VCCAUX_IO="" name="ddr3_cke[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="U1" SLEW="" VCCAUX_IO="" name="ddr3_dm[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="L1" SLEW="" VCCAUX_IO="" name="ddr3_dm[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="R3" SLEW="" VCCAUX_IO="" name="ddr3_dq[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="M2" SLEW="" VCCAUX_IO="" name="ddr3_dq[10]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="L4" SLEW="" VCCAUX_IO="" name="ddr3_dq[11]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="L6" SLEW="" VCCAUX_IO="" name="ddr3_dq[12]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="K3" SLEW="" VCCAUX_IO="" name="ddr3_dq[13]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="M1" SLEW="" VCCAUX_IO="" name="ddr3_dq[14]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="K5" SLEW="" VCCAUX_IO="" name="ddr3_dq[15]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="V1" SLEW="" VCCAUX_IO="" name="ddr3_dq[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="T3" SLEW="" VCCAUX_IO="" name="ddr3_dq[2]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="U4" SLEW="" VCCAUX_IO="" name="ddr3_dq[3]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="U3" SLEW="" VCCAUX_IO="" name="ddr3_dq[4]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="V5" SLEW="" VCCAUX_IO="" name="ddr3_dq[5]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="T5" SLEW="" VCCAUX_IO="" name="ddr3_dq[6]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="V4" SLEW="" VCCAUX_IO="" name="ddr3_dq[7]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="M3" SLEW="" VCCAUX_IO="" name="ddr3_dq[8]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="L3" SLEW="" VCCAUX_IO="" name="ddr3_dq[9]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="V2" SLEW="" VCCAUX_IO="" name="ddr3_dqs_n[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="N1" SLEW="" VCCAUX_IO="" name="ddr3_dqs_n[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="U2" SLEW="" VCCAUX_IO="" name="ddr3_dqs_p[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="N2" SLEW="" VCCAUX_IO="" name="ddr3_dqs_p[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="P4" SLEW="" VCCAUX_IO="" name="ddr3_odt[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="M4" SLEW="" VCCAUX_IO="" name="ddr3_ras_n"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="K6" SLEW="" VCCAUX_IO="" name="ddr3_reset_n"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="" PADName="U6" SLEW="" VCCAUX_IO="" name="ddr3_we_n"/>}
   puts $mig_prj_file {    </PinSelection>}
   puts $mig_prj_file {    <System_Control>}
   puts $mig_prj_file {      <Pin Bank="Select Bank" PADName="No connect" name="sys_rst"/>}
   puts $mig_prj_file {      <Pin Bank="Select Bank" PADName="No connect" name="init_calib_complete"/>}
   puts $mig_prj_file {      <Pin Bank="Select Bank" PADName="No connect" name="tg_compare_error"/>}
   puts $mig_prj_file {    </System_Control>}
   puts $mig_prj_file {    <TimingParameters>}
   puts $mig_prj_file {      <Parameters tcke="5" tfaw="35" tras="34" trcd="13.91" trefi="7.8" trfc="260" trp="13.91" trrd="6" trtp="7.5" twtr="7.5"/>}
   puts $mig_prj_file {    </TimingParameters>}
   puts $mig_prj_file {    <mrBurstLength name="Burst Length">8 - Fixed</mrBurstLength>}
   puts $mig_prj_file {    <mrBurstType name="Read Burst Type and Length">Sequential</mrBurstType>}
   puts $mig_prj_file {    <mrCasLatency name="CAS Latency">6</mrCasLatency>}
   puts $mig_prj_file {    <mrMode name="Mode">Normal</mrMode>}
   puts $mig_prj_file {    <mrDllReset name="DLL Reset">No</mrDllReset>}
   puts $mig_prj_file {    <mrPdMode name="DLL control for precharge PD">Slow Exit</mrPdMode>}
   puts $mig_prj_file {    <emrDllEnable name="DLL Enable">Enable</emrDllEnable>}
   puts $mig_prj_file {    <emrOutputDriveStrength name="Output Driver Impedance Control">RZQ/6</emrOutputDriveStrength>}
   puts $mig_prj_file {    <emrMirrorSelection name="Address Mirroring">Disable</emrMirrorSelection>}
   puts $mig_prj_file {    <emrCSSelection name="Controller Chip Select Pin">Disable</emrCSSelection>}
   puts $mig_prj_file {    <emrRTT name="RTT (nominal) - On Die Termination (ODT)">RZQ/6</emrRTT>}
   puts $mig_prj_file {    <emrPosted name="Additive Latency (AL)">0</emrPosted>}
   puts $mig_prj_file {    <emrOCD name="Write Leveling Enable">Disabled</emrOCD>}
   puts $mig_prj_file {    <emrDQS name="TDQS enable">Enabled</emrDQS>}
   puts $mig_prj_file {    <emrRDQS name="Qoff">Output Buffer Enabled</emrRDQS>}
   puts $mig_prj_file {    <mr2PartialArraySelfRefresh name="Partial-Array Self Refresh">Full Array</mr2PartialArraySelfRefresh>}
   puts $mig_prj_file {    <mr2CasWriteLatency name="CAS write latency">5</mr2CasWriteLatency>}
   puts $mig_prj_file {    <mr2AutoSelfRefresh name="Auto Self Refresh">Enabled</mr2AutoSelfRefresh>}
   puts $mig_prj_file {    <mr2SelfRefreshTempRange name="High Temparature Self Refresh Rate">Normal</mr2SelfRefreshTempRange>}
   puts $mig_prj_file {    <mr2RTTWR name="RTT_WR - Dynamic On Die Termination (ODT)">Dynamic ODT off</mr2RTTWR>}
   puts $mig_prj_file {    <PortInterface>AXI</PortInterface>}
   puts $mig_prj_file {    <AXIParameters>}
   puts $mig_prj_file {      <C0_C_RD_WR_ARB_ALGORITHM>RD_PRI_REG</C0_C_RD_WR_ARB_ALGORITHM>}
   puts $mig_prj_file {      <C0_S_AXI_ADDR_WIDTH>29</C0_S_AXI_ADDR_WIDTH>}
   puts $mig_prj_file {      <C0_S_AXI_DATA_WIDTH>64</C0_S_AXI_DATA_WIDTH>}
   puts $mig_prj_file {      <C0_S_AXI_ID_WIDTH>3</C0_S_AXI_ID_WIDTH>}
   puts $mig_prj_file {      <C0_S_AXI_SUPPORTS_NARROW_BURST>0</C0_S_AXI_SUPPORTS_NARROW_BURST>}
   puts $mig_prj_file {    </AXIParameters>}
   puts $mig_prj_file {  </Controller>}
   puts $mig_prj_file {</Project>}

   close $mig_prj_file
}
# End of write_mig_file_design_1_mig_7series_0_2()



##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ZmodADC_0
proc create_hier_cell_ZmodADC_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ZmodADC_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE


  # Create pins
  create_bd_pin -dir I -from 13 -to 0 ADC_DATA_0
  create_bd_pin -dir I ADC_DCO_0
  create_bd_pin -dir I -type clk ADC_InClk
  create_bd_pin -dir O ADC_SYNC_0
  create_bd_pin -dir I -type clk AxiStreamClk
  create_bd_pin -dir O CLKIN_ADC_N_0
  create_bd_pin -dir O CLKIN_ADC_P_0
  create_bd_pin -dir O SC1_AC_H_0
  create_bd_pin -dir O SC1_AC_L_0
  create_bd_pin -dir O SC1_GAIN_H_0
  create_bd_pin -dir O SC1_GAIN_L_0
  create_bd_pin -dir O SC2_AC_H_0
  create_bd_pin -dir O SC2_AC_L_0
  create_bd_pin -dir O SC2_GAIN_H_0
  create_bd_pin -dir O SC2_GAIN_L_0
  create_bd_pin -dir O SC_COM_H_0
  create_bd_pin -dir O SC_COM_L_0
  create_bd_pin -dir I -type clk SysClk
  create_bd_pin -dir O cs_sc1_0
  create_bd_pin -dir O -type intr lIrqOut
  create_bd_pin -dir I -type rst lRst_n
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir O -type intr s2mm_introut
  create_bd_pin -dir O sclk_sc_0
  create_bd_pin -dir IO sdio_sc_0

  # Create instance: AXI_ZmodADC1410_1, and set properties
  set AXI_ZmodADC1410_1 [ create_bd_cell -type ip -vlnv natinst.com:user:AXI_ZmodADC1410:1.0 AXI_ZmodADC1410_1 ]
  set_property -dict [ list \
   CONFIG.kCrossRegCnt {13} \
 ] $AXI_ZmodADC1410_1

  # Create instance: ZmodADC1410_Controll_1, and set properties
  set ZmodADC1410_Controll_1 [ create_bd_cell -type ip -vlnv xilinx.com:user:ZmodADC1410_Controller:1.0 ZmodADC1410_Controll_1 ]
  set_property -dict [ list \
   CONFIG.kCh1HgMultCoefStatic {"000000000000000000"} \
   CONFIG.kCh1LgMultCoefStatic {"000000000000000000"} \
   CONFIG.kCh2HgMultCoefStatic {"000000000000000000"} \
   CONFIG.kCh2LgMultCoefStatic {"000000000000000000"} \
   CONFIG.kExtCmdInterfaceEn {true} \
   CONFIG.kExtRelayConfigEn {true} \
 ] $ZmodADC1410_Controll_1

  # Create instance: axi_dma_ADC, and set properties
  set axi_dma_ADC [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_ADC ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {18} \
 ] $axi_dma_ADC

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property -dict [ list \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {8} \
 ] $ila_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_1

  # Create interface connections
  connect_bd_intf_net -intf_net AXI_ZmodADC1410_1_AXI_S2MM [get_bd_intf_pins AXI_ZmodADC1410_1/AXI_S2MM] [get_bd_intf_pins axi_dma_ADC/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net AXI_ZmodADC1410_1_mCalibCh1 [get_bd_intf_pins AXI_ZmodADC1410_1/mCalibCh1] [get_bd_intf_pins ZmodADC1410_Controll_1/sCalibCh1]
  connect_bd_intf_net -intf_net AXI_ZmodADC1410_1_mCalibCh2 [get_bd_intf_pins AXI_ZmodADC1410_1/mCalibCh2] [get_bd_intf_pins ZmodADC1410_Controll_1/sCalibCh2]
  connect_bd_intf_net -intf_net AXI_ZmodADC1410_1_mSPI [get_bd_intf_pins AXI_ZmodADC1410_1/mSPI_IAP] [get_bd_intf_pins ZmodADC1410_Controll_1/sSPI_IAP]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_dma_ADC/M_AXI_S2MM]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins AXI_ZmodADC1410_1/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_dma_ADC/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net ADC_DATA_0_1 [get_bd_pins ADC_DATA_0] [get_bd_pins ZmodADC1410_Controll_1/dADC_Data]
  connect_bd_net -net ADC_DCO_0_1 [get_bd_pins ADC_DCO_0] [get_bd_pins ZmodADC1410_Controll_1/DcoClk]
  connect_bd_net -net AXI_ZmodADC1410_1_lIrqOut [get_bd_pins lIrqOut] [get_bd_pins AXI_ZmodADC1410_1/lIrqOut]
  connect_bd_net -net AXI_ZmodADC1410_1_sCh1CouplingSelect [get_bd_pins AXI_ZmodADC1410_1/sCh1CouplingSelect] [get_bd_pins ZmodADC1410_Controll_1/sCh1CouplingConfig]
  connect_bd_net -net AXI_ZmodADC1410_1_sCh1GainSelect [get_bd_pins AXI_ZmodADC1410_1/sCh1GainSelect] [get_bd_pins ZmodADC1410_Controll_1/sCh1GainConfig] [get_bd_pins ila_0/probe5]
  connect_bd_net -net AXI_ZmodADC1410_1_sCh2CouplingSelect [get_bd_pins AXI_ZmodADC1410_1/sCh2CouplingSelect] [get_bd_pins ZmodADC1410_Controll_1/sCh2CouplingConfig]
  connect_bd_net -net AXI_ZmodADC1410_1_sCh2GainSelect [get_bd_pins AXI_ZmodADC1410_1/sCh2GainSelect] [get_bd_pins ZmodADC1410_Controll_1/sCh2GainConfig] [get_bd_pins ila_0/probe6]
  connect_bd_net -net AXI_ZmodADC1410_1_sTestMode [get_bd_pins AXI_ZmodADC1410_1/sTestMode] [get_bd_pins ZmodADC1410_Controll_1/sTestMode] [get_bd_pins ila_0/probe7]
  connect_bd_net -net AXI_ZmodADC1410_1_sZmodControllerRst_n [get_bd_pins AXI_ZmodADC1410_1/sZmodControllerRst_n] [get_bd_pins ZmodADC1410_Controll_1/sRst_n]
  connect_bd_net -net Net [get_bd_pins sdio_sc_0] [get_bd_pins ZmodADC1410_Controll_1/sADC_SDIO]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins lRst_n] [get_bd_pins AXI_ZmodADC1410_1/lRst_n] [get_bd_pins axi_dma_ADC/axi_resetn]
  connect_bd_net -net ZmodADC1410_Controll_0_CALIB_DONE_N [get_bd_pins AXI_ZmodADC1410_1/sInitDone_n] [get_bd_pins ZmodADC1410_Controll_1/sInitDone_n] [get_bd_pins ila_0/probe4]
  connect_bd_net -net ZmodADC1410_Controll_1_FIFO_EMPTY_CHA [get_bd_pins ZmodADC1410_Controll_1/FIFO_EMPTY_CHA] [get_bd_pins ila_0/probe0]
  connect_bd_net -net ZmodADC1410_Controll_1_FIFO_EMPTY_CHB [get_bd_pins ZmodADC1410_Controll_1/FIFO_EMPTY_CHB] [get_bd_pins ila_0/probe1]
  connect_bd_net -net ZmodADC1410_Controll_1_adcClkIn_n [get_bd_pins CLKIN_ADC_N_0] [get_bd_pins ZmodADC1410_Controll_1/adcClkIn_n]
  connect_bd_net -net ZmodADC1410_Controll_1_adcClkIn_p [get_bd_pins CLKIN_ADC_P_0] [get_bd_pins ZmodADC1410_Controll_1/adcClkIn_p]
  connect_bd_net -net ZmodADC1410_Controll_1_adcSync [get_bd_pins ADC_SYNC_0] [get_bd_pins ZmodADC1410_Controll_1/adcSync]
  connect_bd_net -net ZmodADC1410_Controll_1_sADC_CS [get_bd_pins cs_sc1_0] [get_bd_pins ZmodADC1410_Controll_1/sADC_CS]
  connect_bd_net -net ZmodADC1410_Controll_1_sADC_Sclk [get_bd_pins sclk_sc_0] [get_bd_pins ZmodADC1410_Controll_1/sADC_Sclk]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh1CouplingH [get_bd_pins SC1_AC_H_0] [get_bd_pins ZmodADC1410_Controll_1/sCh1CouplingH]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh1CouplingL [get_bd_pins SC1_AC_L_0] [get_bd_pins ZmodADC1410_Controll_1/sCh1CouplingL]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh1GainH [get_bd_pins SC1_GAIN_H_0] [get_bd_pins ZmodADC1410_Controll_1/sCh1GainH]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh1GainL [get_bd_pins SC1_GAIN_L_0] [get_bd_pins ZmodADC1410_Controll_1/sCh1GainL]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh1Out [get_bd_pins ZmodADC1410_Controll_1/sCh1Out] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh2CouplingH [get_bd_pins SC2_AC_H_0] [get_bd_pins ZmodADC1410_Controll_1/sCh2CouplingH]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh2CouplingL [get_bd_pins SC2_AC_L_0] [get_bd_pins ZmodADC1410_Controll_1/sCh2CouplingL]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh2GainH [get_bd_pins SC2_GAIN_H_0] [get_bd_pins ZmodADC1410_Controll_1/sCh2GainH]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh2GainL [get_bd_pins SC2_GAIN_L_0] [get_bd_pins ZmodADC1410_Controll_1/sCh2GainL]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh2Out [get_bd_pins ZmodADC1410_Controll_1/sCh2Out] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net ZmodADC1410_Controll_1_sRelayComH [get_bd_pins SC_COM_H_0] [get_bd_pins ZmodADC1410_Controll_1/sRelayComH]
  connect_bd_net -net ZmodADC1410_Controll_1_sRelayComL [get_bd_pins SC_COM_L_0] [get_bd_pins ZmodADC1410_Controll_1/sRelayComL]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_dma_ADC/s2mm_introut]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins AxiStreamClk] [get_bd_pins AXI_ZmodADC1410_1/AxiStreamClk] [get_bd_pins axi_dma_ADC/m_axi_s2mm_aclk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins s00_axi_aclk] [get_bd_pins AXI_ZmodADC1410_1/s00_axi_aclk] [get_bd_pins axi_dma_ADC/s_axi_lite_aclk]
  connect_bd_net -net clk_wiz_0_clk_out4 [get_bd_pins ADC_InClk] [get_bd_pins ZmodADC1410_Controll_1/ADC_InClk]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins SysClk] [get_bd_pins AXI_ZmodADC1410_1/SysClk] [get_bd_pins ZmodADC1410_Controll_1/SysClk] [get_bd_pins ila_0/clk]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins AXI_ZmodADC1410_1/sCh1In] [get_bd_pins ila_0/probe2] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins AXI_ZmodADC1410_1/sCh2In] [get_bd_pins ila_0/probe3] [get_bd_pins xlslice_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR3_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR3_0 ]

  set Zmod_IIC [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 Zmod_IIC ]

  set usb_uart [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 usb_uart ]


  # Create ports
  set ZmodADC_0_ADC_DATA_0 [ create_bd_port -dir I -from 13 -to 0 ZmodADC_0_ADC_DATA_0 ]
  set ZmodADC_0_ADC_DCO_0 [ create_bd_port -dir I ZmodADC_0_ADC_DCO_0 ]
  set ZmodADC_0_ADC_SYNC_0 [ create_bd_port -dir O ZmodADC_0_ADC_SYNC_0 ]
  set ZmodADC_0_CLKIN_ADC_N_0 [ create_bd_port -dir O ZmodADC_0_CLKIN_ADC_N_0 ]
  set ZmodADC_0_CLKIN_ADC_P_0 [ create_bd_port -dir O ZmodADC_0_CLKIN_ADC_P_0 ]
  set ZmodADC_0_SC1_AC_H_0 [ create_bd_port -dir O ZmodADC_0_SC1_AC_H_0 ]
  set ZmodADC_0_SC1_AC_L_0 [ create_bd_port -dir O ZmodADC_0_SC1_AC_L_0 ]
  set ZmodADC_0_SC1_GAIN_H_0 [ create_bd_port -dir O ZmodADC_0_SC1_GAIN_H_0 ]
  set ZmodADC_0_SC1_GAIN_L_0 [ create_bd_port -dir O ZmodADC_0_SC1_GAIN_L_0 ]
  set ZmodADC_0_SC2_AC_H_0 [ create_bd_port -dir O ZmodADC_0_SC2_AC_H_0 ]
  set ZmodADC_0_SC2_AC_L_0 [ create_bd_port -dir O ZmodADC_0_SC2_AC_L_0 ]
  set ZmodADC_0_SC2_GAIN_H_0 [ create_bd_port -dir O ZmodADC_0_SC2_GAIN_H_0 ]
  set ZmodADC_0_SC2_GAIN_L_0 [ create_bd_port -dir O ZmodADC_0_SC2_GAIN_L_0 ]
  set ZmodADC_0_SC_COM_H_0 [ create_bd_port -dir O ZmodADC_0_SC_COM_H_0 ]
  set ZmodADC_0_SC_COM_L_0 [ create_bd_port -dir O ZmodADC_0_SC_COM_L_0 ]
  set ZmodADC_0_cs_sc1_0 [ create_bd_port -dir O ZmodADC_0_cs_sc1_0 ]
  set ZmodADC_0_sclk_sc_0 [ create_bd_port -dir O ZmodADC_0_sclk_sc_0 ]
  set ZmodADC_0_sdio_sc_0 [ create_bd_port -dir IO ZmodADC_0_sdio_sc_0 ]
  set btn0 [ create_bd_port -dir I btn0 ]
  set prog_clko [ create_bd_port -dir I prog_clko ]
  set prog_d [ create_bd_port -dir IO -from 7 -to 0 prog_d ]
  set prog_oen [ create_bd_port -dir O prog_oen ]
  set prog_rdn [ create_bd_port -dir O prog_rdn ]
  set prog_rxen [ create_bd_port -dir I prog_rxen ]
  set prog_siwun [ create_bd_port -dir O prog_siwun ]
  set prog_spien [ create_bd_port -dir I prog_spien ]
  set prog_txen [ create_bd_port -dir I prog_txen ]
  set prog_wrn [ create_bd_port -dir O prog_wrn ]
  set sys_clock [ create_bd_port -dir I -type clk sys_clock ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   CONFIG.PHASE {0.000} \
 ] $sys_clock

  # Create instance: AXI_DPTI_0, and set properties
  set AXI_DPTI_0 [ create_bd_cell -type ip -vlnv digilentinc.com:IP:AXI_DPTI:1.1 AXI_DPTI_0 ]

  # Create instance: ZmodADC_0
  create_hier_cell_ZmodADC_0 [current_bd_instance .] ZmodADC_0

  # Create instance: axi_dma_dpti, and set properties
  set axi_dma_dpti [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_dpti ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {23} \
 ] $axi_dma_dpti

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {5} \
 ] $axi_mem_intercon

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
   CONFIG.UARTLITE_BOARD_INTERFACE {usb_uart} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_uartlite_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {126.455} \
   CONFIG.CLKOUT1_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT2_JITTER {144.719} \
   CONFIG.CLKOUT2_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {111.164} \
   CONFIG.CLKOUT3_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {400.000} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {8} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {2} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_CACHE_BYTE_SIZE {8192} \
   CONFIG.C_DCACHE_BYTE_SIZE {8192} \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_LMB {1} \
   CONFIG.C_USE_DCACHE {1} \
   CONFIG.C_USE_ICACHE {1} \
 ] $microblaze_0

  # Create instance: microblaze_0_axi_intc, and set properties
  set microblaze_0_axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 microblaze_0_axi_intc ]
  set_property -dict [ list \
   CONFIG.C_HAS_FAST {1} \
 ] $microblaze_0_axi_intc

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {7} \
 ] $microblaze_0_axi_periph

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: microblaze_0_xlconcat, and set properties
  set microblaze_0_xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 microblaze_0_xlconcat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $microblaze_0_xlconcat

  # Create instance: mig_7series_0, and set properties
  set mig_7series_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0 ]

  # Generate the PRJ File for MIG
  set str_mig_folder [get_property IP_DIR [ get_ips [ get_property CONFIG.Component_Name $mig_7series_0 ] ] ]
  set str_mig_file_name mig_a.prj
  set str_mig_file_path ${str_mig_folder}/${str_mig_file_name}

  write_mig_file_design_1_mig_7series_0_2 $str_mig_file_path

  set_property -dict [ list \
   CONFIG.BOARD_MIG_PARAM {Custom} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.XML_INPUT_FILE {mig_a.prj} \
 ] $mig_7series_0

  # Create instance: rst_clk_wiz_0_100M, and set properties
  set rst_clk_wiz_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_0_100M ]

  # Create instance: rst_mig_7series_0_ui_clk, and set properties
  set rst_mig_7series_0_ui_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_mig_7series_0_ui_clk ]

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create interface connections
  connect_bd_intf_net -intf_net AXI_DPTI_0_M_AXIS [get_bd_intf_pins AXI_DPTI_0/M_AXIS] [get_bd_intf_pins axi_dma_dpti/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net ZmodADC_0_M_AXI_S2MM [get_bd_intf_pins ZmodADC_0/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_dpti_M_AXIS_MM2S [get_bd_intf_pins AXI_DPTI_0/S_AXIS] [get_bd_intf_pins axi_dma_dpti/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_dma_dpti_M_AXI_MM2S [get_bd_intf_pins axi_dma_dpti/M_AXI_MM2S] [get_bd_intf_pins axi_mem_intercon/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_dpti_M_AXI_S2MM [get_bd_intf_pins axi_dma_dpti/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S03_AXI]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports Zmod_IIC] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins mig_7series_0/S_AXI]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports usb_uart] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DC [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DC]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_IC [get_bd_intf_pins axi_mem_intercon/S01_AXI] [get_bd_intf_pins microblaze_0/M_AXI_IC]
  connect_bd_intf_net -intf_net microblaze_0_axi_dp [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins AXI_DPTI_0/AXI4_Lite] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins axi_dma_dpti/S_AXI_LITE] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins ZmodADC_0/S00_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins ZmodADC_0/S_AXI_LITE] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net microblaze_0_intc_axi [get_bd_intf_pins microblaze_0_axi_intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_interrupt [get_bd_intf_pins microblaze_0/INTERRUPT] [get_bd_intf_pins microblaze_0_axi_intc/interrupt]
  connect_bd_intf_net -intf_net mig_7series_0_DDR3 [get_bd_intf_ports DDR3_0] [get_bd_intf_pins mig_7series_0/DDR3]

  # Create port connections
  connect_bd_net -net AXI_DPTI_0_prog_oen [get_bd_ports prog_oen] [get_bd_pins AXI_DPTI_0/prog_oen]
  connect_bd_net -net AXI_DPTI_0_prog_rdn [get_bd_ports prog_rdn] [get_bd_pins AXI_DPTI_0/prog_rdn]
  connect_bd_net -net AXI_DPTI_0_prog_siwun [get_bd_ports prog_siwun] [get_bd_pins AXI_DPTI_0/prog_siwun]
  connect_bd_net -net AXI_DPTI_0_prog_wrn [get_bd_ports prog_wrn] [get_bd_pins AXI_DPTI_0/prog_wrn]
  connect_bd_net -net Net [get_bd_ports ZmodADC_0_sdio_sc_0] [get_bd_pins ZmodADC_0/sdio_sc_0]
  connect_bd_net -net Net1 [get_bd_ports prog_d] [get_bd_pins AXI_DPTI_0/prog_d]
  connect_bd_net -net ZmodADC_0_ADC_DATA_0_1 [get_bd_ports ZmodADC_0_ADC_DATA_0] [get_bd_pins ZmodADC_0/ADC_DATA_0]
  connect_bd_net -net ZmodADC_0_ADC_DCO_0_1 [get_bd_ports ZmodADC_0_ADC_DCO_0] [get_bd_pins ZmodADC_0/ADC_DCO_0]
  connect_bd_net -net ZmodADC_0_ADC_SYNC_1 [get_bd_ports ZmodADC_0_ADC_SYNC_0] [get_bd_pins ZmodADC_0/ADC_SYNC_0]
  connect_bd_net -net ZmodADC_0_CLKIN_ADC_N_1 [get_bd_ports ZmodADC_0_CLKIN_ADC_N_0] [get_bd_pins ZmodADC_0/CLKIN_ADC_N_0]
  connect_bd_net -net ZmodADC_0_CLKIN_ADC_P_1 [get_bd_ports ZmodADC_0_CLKIN_ADC_P_0] [get_bd_pins ZmodADC_0/CLKIN_ADC_P_0]
  connect_bd_net -net ZmodADC_0_SC1_AC_H_1 [get_bd_ports ZmodADC_0_SC1_AC_H_0] [get_bd_pins ZmodADC_0/SC1_AC_H_0]
  connect_bd_net -net ZmodADC_0_SC1_AC_L_1 [get_bd_ports ZmodADC_0_SC1_AC_L_0] [get_bd_pins ZmodADC_0/SC1_AC_L_0]
  connect_bd_net -net ZmodADC_0_SC1_GAIN_H_1 [get_bd_ports ZmodADC_0_SC1_GAIN_H_0] [get_bd_pins ZmodADC_0/SC1_GAIN_H_0]
  connect_bd_net -net ZmodADC_0_SC1_GAIN_L_1 [get_bd_ports ZmodADC_0_SC1_GAIN_L_0] [get_bd_pins ZmodADC_0/SC1_GAIN_L_0]
  connect_bd_net -net ZmodADC_0_SC2_AC_H_1 [get_bd_ports ZmodADC_0_SC2_AC_H_0] [get_bd_pins ZmodADC_0/SC2_AC_H_0]
  connect_bd_net -net ZmodADC_0_SC2_AC_L_1 [get_bd_ports ZmodADC_0_SC2_AC_L_0] [get_bd_pins ZmodADC_0/SC2_AC_L_0]
  connect_bd_net -net ZmodADC_0_SC2_GAIN_H_1 [get_bd_ports ZmodADC_0_SC2_GAIN_H_0] [get_bd_pins ZmodADC_0/SC2_GAIN_H_0]
  connect_bd_net -net ZmodADC_0_SC2_GAIN_L_1 [get_bd_ports ZmodADC_0_SC2_GAIN_L_0] [get_bd_pins ZmodADC_0/SC2_GAIN_L_0]
  connect_bd_net -net ZmodADC_0_SC_COM_H_1 [get_bd_ports ZmodADC_0_SC_COM_H_0] [get_bd_pins ZmodADC_0/SC_COM_H_0]
  connect_bd_net -net ZmodADC_0_SC_COM_L_1 [get_bd_ports ZmodADC_0_SC_COM_L_0] [get_bd_pins ZmodADC_0/SC_COM_L_0]
  connect_bd_net -net ZmodADC_0_cs_sc1_1 [get_bd_ports ZmodADC_0_cs_sc1_0] [get_bd_pins ZmodADC_0/cs_sc1_0]
  connect_bd_net -net ZmodADC_0_lIrqOut [get_bd_pins ZmodADC_0/lIrqOut] [get_bd_pins microblaze_0_xlconcat/In0]
  connect_bd_net -net ZmodADC_0_s2mm_introut [get_bd_pins ZmodADC_0/s2mm_introut] [get_bd_pins microblaze_0_xlconcat/In3]
  connect_bd_net -net ZmodADC_0_sclk_sc_1 [get_bd_ports ZmodADC_0_sclk_sc_0] [get_bd_pins ZmodADC_0/sclk_sc_0]
  connect_bd_net -net axi_dma_dpti_mm2s_introut [get_bd_pins axi_dma_dpti/mm2s_introut] [get_bd_pins microblaze_0_xlconcat/In1]
  connect_bd_net -net axi_dma_dpti_s2mm_introut [get_bd_pins axi_dma_dpti/s2mm_introut] [get_bd_pins microblaze_0_xlconcat/In2]
  connect_bd_net -net btn0_1 [get_bd_pins mig_7series_0/sys_rst] [get_bd_pins rst_clk_wiz_0_100M/ext_reset_in] [get_bd_pins rst_mig_7series_0_ui_clk/ext_reset_in] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net btn0_2 [get_bd_ports btn0] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins mig_7series_0/sys_clk_i]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins ZmodADC_0/ADC_InClk] [get_bd_pins clk_wiz_0/clk_out3]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins rst_clk_wiz_0_100M/dcm_locked]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_clk_wiz_0_100M/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins AXI_DPTI_0/axi_lite_aclk] [get_bd_pins AXI_DPTI_0/m_axis_aclk] [get_bd_pins AXI_DPTI_0/s_axis_aclk] [get_bd_pins ZmodADC_0/AxiStreamClk] [get_bd_pins ZmodADC_0/SysClk] [get_bd_pins ZmodADC_0/s00_axi_aclk] [get_bd_pins axi_dma_dpti/m_axi_mm2s_aclk] [get_bd_pins axi_dma_dpti/m_axi_s2mm_aclk] [get_bd_pins axi_dma_dpti/s_axi_lite_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_mem_intercon/S02_ACLK] [get_bd_pins axi_mem_intercon/S03_ACLK] [get_bd_pins axi_mem_intercon/S04_ACLK] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_intc/processor_clk] [get_bd_pins microblaze_0_axi_intc/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins rst_clk_wiz_0_100M/slowest_sync_clk]
  connect_bd_net -net microblaze_0_intr [get_bd_pins microblaze_0_axi_intc/intr] [get_bd_pins microblaze_0_xlconcat/dout]
  connect_bd_net -net mig_7series_0_mmcm_locked [get_bd_pins mig_7series_0/mmcm_locked] [get_bd_pins rst_mig_7series_0_ui_clk/dcm_locked]
  connect_bd_net -net mig_7series_0_ui_clk [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins mig_7series_0/ui_clk] [get_bd_pins rst_mig_7series_0_ui_clk/slowest_sync_clk]
  connect_bd_net -net prog_clko_0_1 [get_bd_ports prog_clko] [get_bd_pins AXI_DPTI_0/prog_clko]
  connect_bd_net -net prog_rxen_0_1 [get_bd_ports prog_rxen] [get_bd_pins AXI_DPTI_0/prog_rxen]
  connect_bd_net -net prog_spien_0_1 [get_bd_ports prog_spien] [get_bd_pins AXI_DPTI_0/prog_spien]
  connect_bd_net -net prog_txen_0_1 [get_bd_ports prog_txen] [get_bd_pins AXI_DPTI_0/prog_txen]
  connect_bd_net -net rst_clk_wiz_0_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins rst_clk_wiz_0_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_0_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins microblaze_0_axi_intc/processor_rst] [get_bd_pins rst_clk_wiz_0_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_0_100M_peripheral_aresetn [get_bd_pins AXI_DPTI_0/axi_lite_aresetn] [get_bd_pins AXI_DPTI_0/m_axis_aresetn] [get_bd_pins AXI_DPTI_0/s_axis_aresetn] [get_bd_pins ZmodADC_0/lRst_n] [get_bd_pins axi_dma_dpti/axi_resetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axi_mem_intercon/S02_ARESETN] [get_bd_pins axi_mem_intercon/S03_ARESETN] [get_bd_pins axi_mem_intercon/S04_ARESETN] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins microblaze_0_axi_intc/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_0_100M/peripheral_aresetn]
  connect_bd_net -net rst_mig_7series_0_ui_clk_peripheral_aresetn [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins mig_7series_0/aresetn] [get_bd_pins rst_mig_7series_0_ui_clk/peripheral_aresetn]
  connect_bd_net -net sys_clock_1 [get_bd_ports sys_clock] [get_bd_pins clk_wiz_0/clk_in1]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_dpti/Data_MM2S] [get_bd_addr_segs mig_7series_0/memmap/memaddr] SEG_mig_7series_0_memaddr
  create_bd_addr_seg -range 0x20000000 -offset 0x80000000 [get_bd_addr_spaces axi_dma_dpti/Data_S2MM] [get_bd_addr_segs mig_7series_0/memmap/memaddr] SEG_mig_7series_0_memaddr
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs AXI_DPTI_0/AXI4_Lite/AXI4_Lite_reg] SEG_AXI_DPTI_0_AXI4_Lite_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ZmodADC_0/AXI_ZmodADC1410_1/S00_AXI/S00_AXI_reg] SEG_AXI_ZmodADC1410_1_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41E10000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ZmodADC_0/axi_dma_ADC/S_AXI_LITE/Reg] SEG_axi_dma_ADC_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41E00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_dma_dpti/S_AXI_LITE/Reg] SEG_axi_dma_dpti_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40800000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40600000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] SEG_axi_uartlite_0_Reg
  create_bd_addr_seg -range 0x00008000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00020000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_axi_intc/S_AXI/Reg] SEG_microblaze_0_axi_intc_Reg
  create_bd_addr_seg -range 0x20000000 -offset 0x80000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mig_7series_0/memmap/memaddr] SEG_mig_7series_0_memaddr
  create_bd_addr_seg -range 0x20000000 -offset 0x80000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs mig_7series_0/memmap/memaddr] SEG_mig_7series_0_memaddr
  create_bd_addr_seg -range 0x20000000 -offset 0x80000000 [get_bd_addr_spaces ZmodADC_0/axi_dma_ADC/Data_S2MM] [get_bd_addr_segs mig_7series_0/memmap/memaddr] SEG_mig_7series_0_memaddr


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


