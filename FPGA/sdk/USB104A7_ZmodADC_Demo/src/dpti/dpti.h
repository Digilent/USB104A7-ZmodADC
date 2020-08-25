#include "AXI_DPTI.h"

#include "xaxidma.h"


#define _AXI_DPTI_BASE_ADDRESS XPAR_AXI_DPTI_0_AXI4_LITE_BASEADDR


//size of DPTI header in bytes
#define _HeaderSize 4
// 8 mega bytes in bytes
#define _8MB 8388607



#ifdef XPAR_V6DDR_0_S_AXI_BASEADDR
#define DDR_BASE_ADDR		XPAR_V6DDR_0_S_AXI_BASEADDR
#elif XPAR_S6DDR_0_S0_AXI_BASEADDR
#define DDR_BASE_ADDR		XPAR_S6DDR_0_S0_AXI_BASEADDR
#elif XPAR_AXI_7SDDR_0_S_AXI_BASEADDR
#define DDR_BASE_ADDR		XPAR_AXI_7SDDR_0_S_AXI_BASEADDR
#elif XPAR_MIG7SERIES_0_BASEADDR
#define DDR_BASE_ADDR		XPAR_MIG7SERIES_0_BASEADDR
#endif

#ifndef DDR_BASE_ADDR
#warning CHECK FOR THE VALID DDR ADDRESS IN XPARAMETERS.H, \
		 DEFAULT SET TO 0x01000000
#define MEM_BASE_ADDR		0x01000000
#else
#define MEM_BASE_ADDR		(DDR_BASE_ADDR + 0x1000000)
#endif

#define TX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00100000)
#define RX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00300000)
#define RX_BUFFER_HIGH		(MEM_BASE_ADDR + 0x004FFFFF)

#define MAX_PKT_LEN		0x20
#define TEST_START_VALUE	0xC

int initDPTI(u16 DMADeviceId);
XStatus DPTI_RequestHeader();
int DPTI_DemoTransfers();
int DPTI_GetOpcode();
int DPTI_GetParameter();
XStatus DPTI_ReceiveData(int length, void* buffer);
XStatus DPTI_SendData(int length, void* buffer);
