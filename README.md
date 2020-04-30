USB104A7 ZmodADC Demo
====================

Description
-----------

This project demonstrates how to use the ZmodADC with the USB104A7 board. This demo comes in two parts, the FPGA project and the PC console application. Vivado is used to build the hardware platform and Xilinx SDK is used to program the microblaze processor with the demo C/C++ application. The DPTI port provides a USB connected synchronous FIFO interface between the PC software and FPGA logic. This interface connection is used to download waveforms from the device and control the ZmodADC.

| Command			       			 | Function						                                                                  |
| ---------------------    			 | ------------------------------------------------------------------------------------------------ |
| arm \<path to .csv\>   			 | Arm the ZmodADC for a capture with the current configuration. Data will be sent to a csv file when the trigger occurs.  |
| start/immediate \<path to .csv\>	 | Acquire data from the ZmodADC immediately. Data is stored in the .csv																	          |
| ch1/ch2					   		 | Select the ZmodADC Channel to use.													  |
| length \<length\>   				 | Set the length of the acquisition. Length can be decimal or hex (EX: length 0x34A)																	  |
| level \<voltage\> 			     | Set trigger level voltage (default 0.5V). EX: level 1.2																	  |
| edge \<rising, falling\> 			 | Set the trigger edge to rising or falling edge (Default rising)																	  |
| window \<sample number\>           | Set the window position at which to run the data acquisition 														  |
| coupling \<ac, dc\>                | Set the coupling to AC or DC    													  |
| gain \<low, high, 0, 1\> 			 | Sets the gain high or low																		  |

For more information see the [USB104A7 ZmodADC Demo Wiki](https://reference.digilentinc.com/reference/programmable-logic/usb104a7/ZmodADC).

Requirements
------------
* **USB104A7**: To purchase a USB104A7, see the [Digilent Store](https://store.digilentinc.com/usb104a7/)
* **ZmodADC**: To purchase a ZmodADC, see the [Digilent Store](https://store.digilentinc.com/zmodadc/)
* **Vivado 2019.1 Installation with Xilinx SDK**: To set up Vivado, see the [Installing Vivado and Digilent Board Files Tutorial](https://reference.digilentinc.com/vivado/installing-vivado/start).
* **Adept Runtime**: Download links available on the [Adept Wiki](https://reference.digilentinc.com/reference/software/adept/start)
* **Serial Terminal Emulator Application**: For more information see the [Installing and Using a Terminal Emulator Tutorial](https://reference.digilentinc.com/learn/programmable-logic/tutorials/tera-term).
* **USB A Cable**
* **5V DC Adapter**
* **Visual Studio Code Installed (Optional)** : Used to build the console application.
* **gcc compiler (mingw or linux) in path (Optional)** : Used to build the console application. On windows, gcc can be installed through mingw.

Demo Setup
----------

##### FPGA Project
1. Download the most recent release ZIP archive ("USB104A7-ZmodADC-*.zip") from the repo's [releases page](https://github.com/Digilent/USB104A7-ZmodADC/releases).
2. Extract the downloaded ZIP.
NOTE: A precompiled bit file is available in the FPGA folder. This includes the FPGA configuration and compiled ELF file. This can be programmed to the FPGA using the vivado hardware manager or Digilent Adept.
3. Open the XPR project file, found at \<archive extracted location\>/FPGA/vivado_proj/USB104A7_ZmodADC_Demo.xpr, included in the extracted release archive in Vivado 2019.1.
4. Launch Xilinx SDK directly (not through the Vivado file menu). When prompted for a workspace, select "\<archive extracted location\>/sdk_workspace".
5. Once the workspace opens, click the **Import** button. In the resulting dialog, first select *Existing Projects into Workspace*, then click **Next**. Navigate to and select the same sdk_workspace folder.
6. Build the project. **Note**: *Errors are sometimes seen at this step. These are typically resolved by right-clicking on the BSP project and selecting Regenerate BSP Sources.*
7. Plug the ZmodADC into the USB104A7 Syzygy port. Plug in the 5v DC adapter and connect the USB104A7 to the PC using the USB cable.
8. Open a serial terminal application (such as [TeraTerm](https://ttssh2.osdn.jp/index.html.en) and connect it to the USB104A7's serial port, using a baud rate of 115200.
9. In the toolbar at the top of the SDK window, select *Xilinx -> Program FPGA*. Leave all fields as their defaults and click "Program".
10. In the Project Explorer pane, right click on the "USB104A7_ZmodADC_Demo" application project and select "Run As -> Launch on Hardware (System Debugger)".
11. The application will now be running on the USB104A7. It can be interacted with as described in the first section of this README.
12. Lastly, the hardware platform must be linked to a hardware handoff, so that changes to the Vivado design can be brought into the SDK workspace. In Vivado, in the toolbar at the top of the window, select *File -> Export -> Export Hardware*. Any Exported Location will do, but make sure to remember the selection, and make sure that the **Include bitstream** box is checked. Click **OK**.
13. In SDK, right click on the \*_hw_platform_\* project, and select *Change Hardware Platform Specification*. Click **Yes** in response to the warning. In the resulting dialog, navigate to and select the .hdf hardware handoff file exported in the previous step, then click **OK**. Now, whenever a modified design is exported from Vivado, on top of the .hdf file, it can be applied to the hardware platform.

##### Building the Console Application using VS Code
1. Open Visual Studio Code.
2. Open the folder containing the Console Application in visual studio code, found at \<archive extracted location\>/DPTI_App/DPTITransferWaveform.
3. To build, click Terminal -\> Run Build Task. Select either buildwin32 or buildlinux. This will run the build task found in tasks.json. This will run "gcc USB104A7_ZmodADCDemoApp.c -g3 -O0 -o \<dir\>\\USB104A7_ZmodADCDemoApp.exe -L./ -ldpti -ldmgr".
NOTE1: Build options can be configured in the .vscode/tasks.json file.
NOTE2: The linux dpti and dmgr shared objects can be downloaded from the [Adept 2](https://reference.digilentinc.com/reference/software/adept/start) wiki page under Runtime - Latest Downloads.

Next Steps
----------
This demo can be used as a basis for other projects by modifying the hardware platform in the Vivado project's block design or by modifying the SDK application project.

Check out the USB104A7's [Resource Center](https://reference.digilentinc.com/reference/programmable-logic/USB104A7/start) to find more documentation, demos, and tutorials.

For technical support or questions, please post on the [Digilent Forum](forum.digilentinc.com).

Additional Notes
----------------
For more information on how this project is version controlled, refer to the [digilent-vivado-scripts repo](https://github.com/digilent/digilent-vivado-scripts).