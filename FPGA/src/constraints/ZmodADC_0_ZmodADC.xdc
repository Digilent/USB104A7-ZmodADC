################# Constraints for the USB104 A7's Zmod Port #################

set_property PACKAGE_PIN A13 [get_ports {ZmodADC_0_SC1_AC_H_0}];
set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_SC1_AC_H_0}] ;
set_property PACKAGE_PIN A14 [get_ports {ZmodADC_0_SC1_AC_L_0}] ; #IO_L9N_T1_DQS_AD3N_15 Sch=syzygy_d_n[0]
set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_SC1_AC_L_0}] ; #IO_L9N_T1_DQS_AD3N_15 Sch=syzygy_d_n[0]
set_property PACKAGE_PIN B16 [get_ports {ZmodADC_0_SC2_AC_H_0}] ; #IO_L7P_T1_AD2P_15 Sch=syzygy_d_p[1]
set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_SC2_AC_H_0}] ; #IO_L7P_T1_AD2P_15 Sch=syzygy_d_p[1]
set_property PACKAGE_PIN B17 [get_ports {ZmodADC_0_SC2_AC_L_0}] ; #IO_L7N_T1_AD2N_15 Sch=syzygy_d_n[1]
set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_SC2_AC_L_0}] ; #IO_L7N_T1_AD2N_15 Sch=syzygy_d_n[1]
set_property PACKAGE_PIN D15 [get_ports {ZmodADC_0_SC1_GAIN_H_0}]; #IO_L12P_T1_MRCC_15 Sch=syzygy_d_p[5]
set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_SC1_GAIN_H_0}]; #IO_L12P_T1_MRCC_15 Sch=syzygy_d_p[5]
set_property PACKAGE_PIN C15 [get_ports {ZmodADC_0_SC1_GAIN_L_0}]; #IO_L12N_T1_MRCC_15 Sch=syzygy_d_n[5]
set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_SC1_GAIN_L_0}]; #IO_L12N_T1_MRCC_15 Sch=syzygy_d_n[5]
set_property PACKAGE_PIN B18 [get_ports {ZmodADC_0_SC2_GAIN_H_0}]; #IO_L10P_T1_AD11P_15 Sch=syzygy_d_p[3]
set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_SC2_GAIN_H_0}]; #IO_L10P_T1_AD11P_15 Sch=syzygy_d_p[3]
set_property PACKAGE_PIN A18 [get_ports {ZmodADC_0_SC2_GAIN_L_0}]; #IO_L10N_T1_AD11N_15 Sch=syzygy_d_n[3]
set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_SC2_GAIN_L_0}]; #IO_L10N_T1_AD11N_15 Sch=syzygy_d_n[3]
set_property PACKAGE_PIN E18 [get_ports {ZmodADC_0_SC_COM_H_0}]; #IO_L21P_T3_DQS_15 Sch=syzygy_d_p[7]
set_property  IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_SC_COM_H_0}]; #IO_L21P_T3_DQS_15 Sch=syzygy_d_p[7]
set_property PACKAGE_PIN D18 [get_ports {ZmodADC_0_SC_COM_L_0}]; #IO_L21N_T3_DQS_A18_15 Sch=syzygy_d_n[7]
set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_SC_COM_L_0}]; #IO_L21N_T3_DQS_A18_15 Sch=syzygy_d_n[7]

################# ADC (SC1 & SC2) ########################################
#ADC1(Scope 1&2) & ADC2(Scope 3&4) SPI
set_property PACKAGE_PIN A15 [get_ports {ZmodADC_0_sdio_sc_0}]; #IO_L8P_T1_AD10P_15 Sch=syzygy_d_p[2]
set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_sdio_sc_0}]; #IO_L8P_T1_AD10P_15 Sch=syzygy_d_p[2]
set_property DRIVE 4 [get_ports {ZmodADC_0_sdio_sc_0}]; #IO_L8P_T1_AD10P_15 Sch=syzygy_d_p[2]
set_property PACKAGE_PIN E17 [get_ports {ZmodADC_0_cs_sc1_0}]; #IO_L16P_T2_A28_15 Sch=syzygy_s[26]
set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_cs_sc1_0}]; #IO_L16P_T2_A28_15 Sch=syzygy_s[26]
set_property DRIVE 4 [get_ports {ZmodADC_0_cs_sc1_0}]; #IO_L16P_T2_A28_15 Sch=syzygy_s[26]
set_property PACKAGE_PIN A16 [get_ports {ZmodADC_0_sclk_sc_0}]; #IO_L8N_T1_AD10N_15 Sch=syzygy_d_n[2]
set_property IOSTANDARD LVCMOS18  [get_ports {ZmodADC_0_sclk_sc_0}]; #IO_L8N_T1_AD10N_15 Sch=syzygy_d_n[2]
set_property DRIVE 4 [get_ports {ZmodADC_0_sclk_sc_0}]; #IO_L8N_T1_AD10N_15 Sch=syzygy_d_n[2]

#ADC1 & ADC2 SYNC
set_property PACKAGE_PIN D17   [get_ports {ZmodADC_0_ADC_SYNC_0}]; #IO_L16N_T2_A27_15 Sch=syzygy_s[27]
set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_ADC_SYNC_0}]; #IO_L16N_T2_A27_15 Sch=syzygy_s[27]
set_property DRIVE 4 [get_ports {ZmodADC_0_ADC_SYNC_0}]; #IO_L16N_T2_A27_15 Sch=syzygy_s[27]
set_property SLEW SLOW [get_ports {ZmodADC_0_ADC_SYNC_0}]; #IO_L16N_T2_A27_15 Sch=syzygy_s[27]

#  S4       S8       F4       F8
#  1.99ns   2.56ns   1.82ns   2.06ns

#ADC 1&2 DCO
set_property PACKAGE_PIN H16 [get_ports ZmodADC_0_ADC_DCO_0]; #IO_L13P_T2_MRCC_15 Sch=syzygy_p2c_clk_p
set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_ADC_DCO_0]; #IO_L13P_T2_MRCC_15 Sch=syzygy_p2c_clk_p
#set_property PACKAGE_PIN W17 [get_ports {clkout_adc[1]}]
#ADC1&2 CLK
#set_property PACKAGE_PIN AB14 [get_ports {clkin_adc[2]}]
#set_property PACKAGE_PIN AB15 [get_ports {clkin_adc[3]}]

set_property PACKAGE_PIN F15 [get_ports {ZmodADC_0_CLKIN_ADC_P_0}]; #IO_L14P_T2_SRCC_15 Sch=syzygy_c2p_clk_p
set_property IOSTANDARD DIFF_SSTL18_I [get_ports {ZmodADC_0_CLKIN_ADC_P_0}]; #IO_L14P_T2_SRCC_15 Sch=syzygy_c2p_clk_p
set_property  SLEW SLOW [get_ports {ZmodADC_0_CLKIN_ADC_P_0}]; #IO_L14P_T2_SRCC_15 Sch=syzygy_c2p_clk_p
set_property PACKAGE_PIN F16   [get_ports {ZmodADC_0_CLKIN_ADC_N_0}]; #IO_L14N_T2_SRCC_15 Sch=syzygy_c2p_clk_n
set_property IOSTANDARD DIFF_SSTL18_I  [get_ports {ZmodADC_0_CLKIN_ADC_N_0}]; #IO_L14N_T2_SRCC_15 Sch=syzygy_c2p_clk_n
set_property SLEW SLOW [get_ports {ZmodADC_0_CLKIN_ADC_N_0}]; #IO_L14N_T2_SRCC_15 Sch=syzygy_c2p_clk_n

# slow I    2.06ns
# slow II   1.76ns
# fast I    1.60ns
# fast II   1.59ns

set_property PACKAGE_PIN H14 [get_ports {ZmodADC_0_ADC_DATA_0[0]}]; #IO_L15P_T2_DQS_15 Sch=syzygy_s[24]
set_property PACKAGE_PIN K15 [get_ports {ZmodADC_0_ADC_DATA_0[1]}]; #IO_L24P_T3_RS1_15 Sch=syzygy_s[22]
set_property PACKAGE_PIN E16 [get_ports {ZmodADC_0_ADC_DATA_0[2]}]; #IO_L11N_T1_SRCC_15 Sch=syzygy_d_n[4]
set_property PACKAGE_PIN C16 [get_ports {ZmodADC_0_ADC_DATA_0[3]}]; #IO_L20P_T3_A20_15 Sch=syzygy_d_p[6]
set_property PACKAGE_PIN C17 [get_ports {ZmodADC_0_ADC_DATA_0[4]}]; #IO_L20N_T3_A19_15 Sch=syzygy_d_n[6]
set_property PACKAGE_PIN J14 [get_ports {ZmodADC_0_ADC_DATA_0[5]}]; #IO_L19P_T3_A22_15 Sch=syzygy_s[16]
set_property PACKAGE_PIN G18 [get_ports {ZmodADC_0_ADC_DATA_0[6]}]; #IO_L22P_T3_A17_15 Sch=syzygy_s[18]
set_property PACKAGE_PIN J17 [get_ports {ZmodADC_0_ADC_DATA_0[7]}]; #IO_L23P_T3_FOE_B_15 Sch=syzygy_s[20]
set_property PACKAGE_PIN H15 [get_ports {ZmodADC_0_ADC_DATA_0[8]}]; #IO_L19N_T3_A21_VREF_15 Sch=syzygy_s[17]
set_property PACKAGE_PIN E15 [get_ports {ZmodADC_0_ADC_DATA_0[9]}]; #IO_L11P_T1_SRCC_15 Sch=syzygy_d_p[4]
set_property PACKAGE_PIN F18 [get_ports {ZmodADC_0_ADC_DATA_0[10]}]; #IO_L22N_T3_A16_15 Sch=syzygy_s[19]
set_property PACKAGE_PIN J18 [get_ports {ZmodADC_0_ADC_DATA_0[11]}]; #IO_L23N_T3_FWE_B_15 Sch=syzygy_s[21]
set_property PACKAGE_PIN J15 [get_ports {ZmodADC_0_ADC_DATA_0[12]}]; #IO_L24N_T3_RS0_15 Sch=syzygy_s[23]
set_property PACKAGE_PIN G14 [get_ports {ZmodADC_0_ADC_DATA_0[13]}]; #IO_L15N_T2_DQS_ADV_B_15 Sch=syzygy_s[25]

set_property IOSTANDARD LVCMOS18 [get_ports {ZmodADC_0_ADC_DATA_0*}];

# DCO to data skew [-1.2;1] ns -2.24 + 5 ns ADC Output delay option (DCO delay)

create_clock -period 10.000 -name ZmodADC_0_ADC_DCO_0 -waveform {0.000 5.000} [get_ports {ZmodADC_0_ADC_DCO_0}]
create_generated_clock -name ZmodADC_0_CLKIN_ADC_P_0 -source [get_pins design_1_i/ZmodADC_0/ZmodADC1410_Controll_1/U0/InstADC_ClkODDR/C] -divide_by 1 [get_ports ZmodADC_0_CLKIN_ADC_P_0]

set_input_delay -clock [get_clocks ZmodADC_0_ADC_DCO_0] -clock_fall -min -add_delay 3.240 [get_ports {ZmodADC_0_ADC_DATA_0[*]}]
set_input_delay -clock [get_clocks ZmodADC_0_ADC_DCO_0] -clock_fall -max -add_delay 5.440 [get_ports {ZmodADC_0_ADC_DATA_0[*]}]
set_input_delay -clock [get_clocks ZmodADC_0_ADC_DCO_0] -min -add_delay 3.240 [get_ports {ZmodADC_0_ADC_DATA_0[*]}]
set_input_delay -clock [get_clocks ZmodADC_0_ADC_DCO_0] -max -add_delay 5.440 [get_ports {ZmodADC_0_ADC_DATA_0[*]}]



################# Constraints for the Eclypse Z7's Zmod Port B #################

#set_property PACKAGE_PIN W15 [get_ports ZmodADC_0_SC1_AC_H_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_SC1_AC_H_0]
#set_property PACKAGE_PIN Y15 [get_ports ZmodADC_0_SC1_AC_L_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_SC1_AC_L_0]
#set_property PACKAGE_PIN V13 [get_ports ZmodADC_0_SC2_AC_H_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_SC2_AC_H_0]
#set_property PACKAGE_PIN W13 [get_ports ZmodADC_0_SC2_AC_L_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_SC2_AC_L_0]
#set_property PACKAGE_PIN V14 [get_ports ZmodADC_0_SC1_GAIN_H_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_SC1_GAIN_H_0]
#set_property PACKAGE_PIN V15 [get_ports ZmodADC_0_SC1_GAIN_L_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_SC1_GAIN_L_0]
#set_property PACKAGE_PIN AB14 [get_ports ZmodADC_0_SC2_GAIN_H_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_SC2_GAIN_H_0]
#set_property PACKAGE_PIN AB15 [get_ports ZmodADC_0_SC2_GAIN_L_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_SC2_GAIN_L_0]
#set_property PACKAGE_PIN Y20 [get_ports ZmodADC_0_SC_COM_H_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_SC_COM_H_0]
#set_property PACKAGE_PIN Y21 [get_ports ZmodADC_0_SC_COM_L_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_SC_COM_L_0]
################## ADC (SC1 & SC2) ########################################
##ADC1(Scope 1&2) & ADC2(Scope 3&4) SPI
#set_property PACKAGE_PIN Y13 [get_ports ZmodADC_0_sdio_sc_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_sdio_sc_0]
#set_property DRIVE 4 [get_ports ZmodADC_0_sdio_sc_0]
#set_property PACKAGE_PIN V17 [get_ports ZmodADC_0_cs_sc1_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_cs_sc1_0]
#set_property DRIVE 4 [get_ports ZmodADC_0_cs_sc1_0]
#set_property PACKAGE_PIN AA13 [get_ports ZmodADC_0_sclk_sc_0]
#set_property IOSTANDARD LVCMOS18 [get_ports ZmodADC_0_sclk_sc_0]
#set_property DRIVE 4 [get_ports ZmodADC_0_sclk_sc_0]
##ADC1 & ADC2 SYNC
#set_property PACKAGE_PIN U17 [get_ports ZmodADC_0_ADC_SYNC_0]
##set_property PACKAGE_PIN Y19 [get_ports {sync_adc[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports -filter { name =~ ZmodADC_0_ADC_SYNC* }]
#set_property DRIVE 4 [get_ports -filter { name =~ ZmodADC_0_ADC_SYNC* }]
#set_property SLEW SLOW [get_ports -filter { name =~ ZmodADC_0_ADC_SYNC* }]
##  S4       S8       F4       F8
##  1.99ns   2.56ns   1.82ns   2.06ns
#
##ADC 1&2 DCO
#set_property PACKAGE_PIN W17 [get_ports ZmodADC_0_ADC_DCO_0]
##set_property PACKAGE_PIN W17 [get_ports {clkout_adc[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports -filter { name =~ ZmodADC_0_ADC_DCO* }]
##ADC1&2 CLK
##set_property PACKAGE_PIN AB14 [get_ports {clkin_adc[2]}]
##set_property PACKAGE_PIN AB15 [get_ports {clkin_adc[3]}]
#
#set_property IOSTANDARD DIFF_SSTL18_I [get_ports -filter { name =~ ZmodADC_0_CLKIN_ADC* }]
#set_property PACKAGE_PIN W16 [get_ports ZmodADC_0_CLKIN_ADC_P_0]
#set_property PACKAGE_PIN Y16 [get_ports ZmodADC_0_CLKIN_ADC_N_0]
#set_property SLEW SLOW [get_ports -filter { name =~ ZmodADC_0_CLKIN_ADC* }]
## slow I    2.06ns
## slow II   1.76ns
## fast I    1.60ns
## fast II   1.59ns
#
#set_property PACKAGE_PIN U16 [get_ports {ZmodADC_0_ADC_DATA_0[0]}]
#set_property PACKAGE_PIN AB19 [get_ports {ZmodADC_0_ADC_DATA_0[1]}]
#set_property PACKAGE_PIN AA14 [get_ports {ZmodADC_0_ADC_DATA_0[2]}]
#set_property PACKAGE_PIN AA22 [get_ports {ZmodADC_0_ADC_DATA_0[3]}]
#set_property PACKAGE_PIN AB22 [get_ports {ZmodADC_0_ADC_DATA_0[4]}]
#set_property PACKAGE_PIN AA18 [get_ports {ZmodADC_0_ADC_DATA_0[5]}]
#set_property PACKAGE_PIN Y18 [get_ports {ZmodADC_0_ADC_DATA_0[6]}]
#set_property PACKAGE_PIN AB20 [get_ports {ZmodADC_0_ADC_DATA_0[7]}]
#set_property PACKAGE_PIN AA19 [get_ports {ZmodADC_0_ADC_DATA_0[8]}]
#set_property PACKAGE_PIN Y14 [get_ports {ZmodADC_0_ADC_DATA_0[9]}]
#set_property PACKAGE_PIN Y19 [get_ports {ZmodADC_0_ADC_DATA_0[10]}]
#set_property PACKAGE_PIN AB21 [get_ports {ZmodADC_0_ADC_DATA_0[11]}]
#set_property PACKAGE_PIN AA21 [get_ports {ZmodADC_0_ADC_DATA_0[12]}]
#set_property PACKAGE_PIN U15 [get_ports {ZmodADC_0_ADC_DATA_0[13]}]
#
#set_property IOSTANDARD LVCMOS18 [get_ports -filter { name =~ ZmodADC_0_ADC_DATA*}]
#
## DCO to data skew [-1.2;1] ns -2.24 + 5 ns ADC Output delay option (DCO delay)
#
#create_clock -period 10.000 -name ZmodADC_0_ADC_DCO_0 -waveform {0.000 5.000} [get_ports ZmodADC_0_ADC_DCO_0]
#create_generated_clock -name ZmodADC_0_CLKIN_ADC_P_0 -source [get_pins design_1_i/ZmodADC_0/ZmodADC1410_Controll_1/U0/InstADC_ClkODDR/C] -divide_by 1 [get_ports ZmodADC_0_CLKIN_ADC_P_0]
#
#set_input_delay -clock [get_clocks ZmodADC_0_ADC_DCO_0] -clock_fall -min -add_delay 3.240 [get_ports {ZmodADC_0_ADC_DATA_0[*]}]
#set_input_delay -clock [get_clocks ZmodADC_0_ADC_DCO_0] -clock_fall -max -add_delay 5.440 [get_ports {ZmodADC_0_ADC_DATA_0[*]}]
#set_input_delay -clock [get_clocks ZmodADC_0_ADC_DCO_0] -min -add_delay 3.240 [get_ports {ZmodADC_0_ADC_DATA_0[*]}]
#set_input_delay -clock [get_clocks ZmodADC_0_ADC_DCO_0] -max -add_delay 5.440 [get_ports {ZmodADC_0_ADC_DATA_0[*]}]

