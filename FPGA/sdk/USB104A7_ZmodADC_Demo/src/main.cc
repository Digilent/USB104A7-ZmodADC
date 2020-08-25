/*
 * Empty C++ Application
 */
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "dpti/dpti.h"
#include "zmodlib/ZmodADC1410/zmodadc1410.h"
#include <sleep.h>

XStatus DemoInitialize();
void DemoRun();
#define addrZmodI2C	0x30

#define TRANSFER_LEN 0x400

#define NODATA -1
#define ARM_OP 1
#define IMMEDIATE_OP 2
#define STOP_OP 3
#define SET_TRIGGER_LEVEL_OP 4
#define SET_GAIN_OP 5
#define SET_TRIGGER_EDGE_OP 6
#define SET_COUPLING_OP 7
#define SET_LENGTH_OP 8


ZMODADC1410 ZmodADC(XPAR_ZMODADC_0_AXI_ZMODADC1410_1_S00_AXI_BASEADDR, XPAR_ZMODADC_0_AXI_DMA_ADC_BASEADDR, XPAR_AXI_IIC_0_BASEADDR, addrZmodI2C, XPAR_MICROBLAZE_0_AXI_INTC_ZMODADC_0_AXI_ZMODADC1410_1_LIRQOUT_INTR, XPAR_MICROBLAZE_0_AXI_INTC_ZMODADC_0_AXI_DMA_ADC_S2MM_INTROUT_INTR);

uint32_t getSignedRawFromVolt(float volt, uint8_t gain);


int main()
{
	if(DemoInitialize()!=XST_SUCCESS){
    	xil_printf("Error initializing demo\r\n");
    	cleanup_platform();
    	return -1;
    }
    DemoRun();

    cleanup_platform();
    return 0;
}

XStatus DemoInitialize(){
	XStatus Status;
    init_platform();

    xil_printf("Intializing Demo\r\n");
    Status = initDPTI(XPAR_AXI_DMA_DPTI_DEVICE_ID);
    if(Status != XST_SUCCESS){
    	xil_printf("Error initializing DPTI\r\n");
    	return Status;
    }
    if((Status=DPTI_RequestHeader()) != XST_SUCCESS){//Initial DMA request for 8 byte header
    	xil_printf("Error requesting the header\r\n");
    	return Status;
    }

    xil_printf("USB104A7 ZmodADC Demo Initialized\r\n");
    return XST_SUCCESS;
}

void setDefaults(){
	size_t defaultLength=0x3FFF;
	ZmodADC.setGain(0, 0);
	ZmodADC.setGain(1, 0);
	ZmodADC.setTransferLength(defaultLength);
	ZmodADC.setTrigger(0, 1, 0, 0, 0);
	ZmodADC.setTrigger(1, 1, 0, 0, 0);
	ZmodADC.setCoupling(0, 0);
	ZmodADC.setCoupling(1, 0);
}


void DemoRun(){
	int operation=0;
	uint32_t param;
	uint32_t channel=0;
	uint32_t window = 0;
	size_t length = 0x3FFF;
	bool armed=false;
	bool gain=0;
	uint32_t triggerLevel=getSignedRawFromVolt(0.5, gain);
	bool coupling=0;
	bool edge=0;
	uint32_t rawData;
	uint32_t szSendBuffer=0;
	float* sendBuffer=NULL;
	uint32_t* channelBuffer=NULL;

	setDefaults();

	while(1){

		if((operation = DPTI_GetOpcode())!=NODATA){
			//ZmodDAC Channel is specified in the 16th bit of the opcode
			if(operation>>16 == 1){
				channel = 0;//Channel 1
			}
			else if(operation>>16 == 2){
				channel = 1;//Channel 2
			}
			else{
				xil_printf("ZmodDAC Channel not specified\r\n");
			}

			switch(operation&0xF){
			case ARM_OP:
				//If the new length is longer than a previous length, reallocate memory
				if(sendBuffer!=NULL && szSendBuffer<length*sizeof(float)){
					//recvBuffer is too small to receive all of the data
					free(sendBuffer);
					sendBuffer=NULL;
					if(channelBuffer!=NULL)realloc(channelBuffer, length*sizeof(uint32_t));//Realloc channelbuffer to preserve old data
				}
				//Allocate memory to DPTI receive buffer
				if(sendBuffer==NULL){
					sendBuffer=(float*)malloc(length*sizeof(float));
					szSendBuffer=length*sizeof(float);
					//Check to see if it worked
					if(sendBuffer==NULL){
						xil_printf("Couldn't allocate memory to sendBuffer! Add memory to heap in lscript.ld.\r\n");
						xil_printf("Exiting...\r\n");
						return;
					}
				}

				//If channelBuffer has not been allocated, allocate memory to the buffer.
				if(channelBuffer==NULL){
					//Each sample received is 2 bytes. This will allocate nSamples*4 bytes, or 2 bytes per sample per channel.
					channelBuffer = (uint32_t*)calloc(length, sizeof(uint32_t));
					//Check to see if it worked
					if(channelBuffer==NULL){
						xil_printf("Couldn't allocate memory to channelBuffer! Add memory to heap in the lscript.ld.\r\n");
						xil_printf("Exiting...\r\n");
						return;
					}
				}
				//Arm the ZmodADC and continue
				ZmodADC.acquireTriggeredPolling(channelBuffer, channel, triggerLevel, edge, window, length);
				xil_printf("Channel %d armed\r\n", channel+1);
				//Get data from channelBuffer
				for(uint32_t i=0; i<length; i++){
					rawData = ZmodADC.signedChannelData(channel, channelBuffer[i]);
					sendBuffer[i] = ZmodADC.getVoltFromSignedRaw(rawData, gain);
				}
				//Send the data over DPTI
				if(DPTI_SendData(length*sizeof(float), sendBuffer)==XST_FAILURE){
					//Failed to send data
					xil_printf("Failed to send waveform data\r\n");
					break;
				}
				xil_printf("Data sent over DPTI\r\n");
				//armed = true;
				break;
			case IMMEDIATE_OP:
				//If the new length is longer than a previous length, reallocate memory
				if(sendBuffer!=NULL && szSendBuffer<length*sizeof(float)){
					//recvBuffer is too small to receive all of the data
					free(sendBuffer);
					sendBuffer=NULL;
					if(channelBuffer!=NULL)realloc(channelBuffer, length*sizeof(uint32_t));//Realloc channelbuffer to preserve old data
				}
				//Allocate memory to DPTI receive buffer
				if(sendBuffer==NULL){
					sendBuffer=(float*)malloc(length*sizeof(float));
					szSendBuffer=length*sizeof(float);
					//Check to see if it worked
					if(sendBuffer==NULL){
						xil_printf("Couldn't allocate memory to sendBuffer! Add memory to heap in lscript.ld.\r\n");
						xil_printf("Exiting...\r\n");
						return;
					}
				}

				//If channelBuffer has not been allocated, allocate memory to the buffer.
				if(channelBuffer==NULL){
					//Each sample received is 2 bytes. This will allocate nSamples*4 bytes, or 2 bytes per sample per channel.
					channelBuffer = (uint32_t*)calloc(length, sizeof(uint32_t));
					//Check to see if it worked
					if(channelBuffer==NULL){
						xil_printf("Couldn't allocate memory to channelBuffer! Add memory to heap in the lscript.ld.\r\n");
						xil_printf("Exiting...\r\n");
						return;
					}
				}

				//Run immediate capture on the ZmodADC
				ZmodADC.acquireImmediatePolling(channelBuffer, channel, length);

				//Get data from channelBuffer
				for(uint32_t i=0; i<length; i++){
					rawData = ZmodADC.signedChannelData(channel, channelBuffer[i]);
					sendBuffer[i] = ZmodADC.getVoltFromSignedRaw(rawData, gain);
				}
				//Send the data over DPTI
				if(DPTI_SendData(length*sizeof(float), sendBuffer)==XST_FAILURE){
					//Failed to send data
					xil_printf("Failed to send waveform data\r\n");
					break;
				}
				xil_printf("Data sent over DPTI\r\n");
				break;
			case STOP_OP:
				ZmodADC.stop();
				xil_printf("Stopped channel %d\r\n", channel+1);
				break;
			case SET_TRIGGER_LEVEL_OP:
				float flevel;
				param = DPTI_GetParameter();
				flevel = *(float*)&param;
				param = getSignedRawFromVolt(*(float*)&param, gain);
				if(param==0 || param>0x3FFF){
					xil_printf("Error: Invalid float value: %d (0x%02X), expected [1-0x3FFF]\r\n", param, param);
					break;
				}
				triggerLevel = param;
				xil_printf("Set trigger level to 0x%X (~%d.%03dv)\r\n", param, (int)flevel, (int)abs((flevel*1000 - (int)(flevel)*1000)));

				break;
			case SET_GAIN_OP:
				//Get gain parameter from PC
				param = DPTI_GetParameter();
				if(param > 1){
					xil_printf("Error: Invalid gain value %d, expected [0-1]\r\n", param);
				}
				gain = param;
				ZmodADC.setGain(channel, param);
				xil_printf("Set channel %d gain %s\r\n", channel+1, (param==0) ? "low":"high");
				break;
			case SET_TRIGGER_EDGE_OP:
				edge = DPTI_GetParameter();
				ZmodADC.setTrigger(channel, 0, triggerLevel, edge, window);
				xil_printf("Trigger edge set to %s edge\r\n", (edge)? "Falling":"Rising");
				break;
			case SET_COUPLING_OP:
				coupling = DPTI_GetParameter();
				ZmodADC.setCoupling(channel, coupling);
				xil_printf("Coupling set to %s\r\n", (coupling)?"AC":"DC");
				break;
			case SET_LENGTH_OP:
				length = DPTI_GetParameter();
				ZmodADC.setTransferLength(length);
				xil_printf("Length set to %d (0x%02X)\r\n", length, length);
				break;
			default:
				xil_printf("Unknown Operation %d\r\n", operation);
			}
			if(!armed)DPTI_RequestHeader();//Requests a new header if none are in progress
		}
		if(Xil_In32(_AXI_DPTI_BASE_ADDRESS+DPTI_STATUS_REG_OFFSET) & (DPTI_SR_REINIT_MASK) ||
			(Xil_In32(_AXI_DPTI_BASE_ADDRESS+DPTI_CONTROL_REG_OFFSET) & (DPTI_TO_STREAM))==0
		){ // If the USB device has be reinitialized or we aren't waiting for a transaction
			xil_printf("Reinitializing\r\n");
			DPTI_Reset(_AXI_DPTI_BASE_ADDRESS);
			usleep(100000);//Wait 10ms
			DPTI_RequestHeader();//Request a new header after reset
		}

	}

}

/**
 * Converts a signed raw value (provided by ZmodADC1410 IP core) to a value in Volts measure unit.
 * @param raw - the signed value as 14 bit value.
 * @param gain 0 LOW and 1 HIGH
 * @return the Volts value.
 */
uint32_t getSignedRawFromVolt(float volt, uint8_t gain)
{
	uint32_t raw;
	if(volt==25){//If user specifies max positive value (25), return max positive value, since 14bit signed 0x2000 is -25.
		return 0x1FFF;
	}
	float vMax = gain ? 1.0:25.0;
	//float fval = (float)raw * vMax / (float)(1<<13);
	raw = volt / vMax * (1<<13);
	raw &= 0x3FFF;
	return raw;
}




//Ignore this
////If it is awaiting a trigger and the transfer has completed
//if(armed && ZmodADC.isDMATransferComplete()){
//	armed=false;
//	xil_printf("ADC Triggered, sending over DPTI\r\n");
//	//Get data from channelBuffer
//	for(unsigned int i=0; i<length; i++){
//		rawData = ZmodADC.signedChannelData(channel, channelBuffer[i]);
//		sendBuffer[i] = ZmodADC.getVoltFromSignedRaw(rawData, gain);
//	}
//	//Send the data over DPTI
//	if(DPTI_SendData(length*sizeof(float), sendBuffer)==XST_FAILURE){
//		//Failed to send data
//		xil_printf("Failed to send waveform data\r\n");
//	}
//	else{
//		xil_printf("Data sent\r\n");
//	}
//}

