#define WIN32_LEAN_AND_MEAN


#if defined (WIN32)
    
    #include <windows.h>
    
#else

    #include <signal.h>
    #include <termios.h>
	#include <pthread.h>
	#include <unistd.h>

#endif


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>
#include <time.h>

#include "dpcdecl.h"
#include "dmgr.h"
#include "dpti.h"


#ifndef strlwr
char* strlwr(char* str){
	uint8_t *p = (uint8_t*) str;
	while(*p){
		*p = tolower((uint8_t)*p);
		p++;
	}
	return str;
}
#endif


//Op codes
#define ARM_OP 1
#define IMMEDIATE_OP 2
#define STOP_OP 3
#define SET_TRIGGER_LEVEL_OP 4
#define SET_GAIN_OP 5
#define SET_TRIGGER_EDGE_OP 6
#define SET_COUPLING_OP 7
#define SET_LENGTH_OP 8

//Command Protocol:
//Operations and parameters are sent in 4 byte packets over DPTI.

//The operation is sent first:
//The opcode is sent in the lower 2 bytes
//The ZmodDAC channel is sent in the upper 2 bytes (bits 17&16)

//The parameter is sent second, if applicable

#ifndef bool
typedef enum { false, true } bool;
#endif

//Function flags
bool fArm=false;
bool fArmed=false;
bool fImmediate=false;
bool fStop=false;
bool fSetGain=false;
bool fSetTriggerEdge=false;
bool fSetTriggerLevel=false;
bool fSetCoupling=false;
bool fSetLength=false;

bool fExitApplication=false;

//DPTI Initialized Flag
bool fDptiInit=false;

//Global Variables
uint16_t divider;
uint8_t gain;
char filename[256];
uint8_t channel = 1;
bool triggerEdge=0;
float triggerLevel = 0;
bool coupling = 0;
uint32_t length = 0x3FFF;
char input[256];


DWORD threadID;
enum cmdState{
GETINPUT, // Wait for console thread to enter command
EXECUTE, // Command received, main thread to execute
WAIT // Command received, both threads waiting for DPTI
} cmdState = GETINPUT;

//DPTI Device Variables
HIF hif;
DPRP pDevProperties;
int portNum=1; //Synchronous DPTI Port
int failattempt=0;

//Forward Declarations
void closeDPTI();
int parseArgs(char* input);
void printUsage();
int getNumLines(FILE* csv);
int getWaveData(FILE* csv, BYTE* buf);
int initDPTI();
#if defined(WIN32)
HANDLE terminalHandle;
DWORD WINAPI TerminalThread();
#else
pthread_t terminalHandle;
void* terminalThread();
#endif

int main(int argc, char* argv[]){
	int sample;
	int arg;
	int nLines;
	float pBuf[0x3FFF];
	DWORD nDataIn;
	DWORD nDataOut;
	unsigned int nVals;
	struct timespec ts = {.tv_sec = 0, .tv_nsec = 1000000};

	BYTE opCodeToSend[4];
	BYTE paramToSend[4];
	int status;

	printUsage();
	atexit(closeDPTI);

//Initialize the DPTI connection.

	if(status = initDPTI()!=0){
		printf("Is the USB104A7 connected and accessible?\n");
		return status;
	}else{
		fDptiInit=true;
	}
	

#if defined (WIN32)
	terminalHandle = CreateThread(0, 0, TerminalThread, NULL, 0, &threadID);
#else
	status = pthread_create(&terminalHandle, NULL, &terminalThread, NULL);
#endif

	while(1){
		//If the DPTI is not connected
		if(fDptiInit==false){
			//Initialize the DPTI connection.
			if(status = initDPTI()!=0){
			continue;//Retry
			}else{
				fDptiInit=true;
			}
		}

		//cmdState is set in the terminal thread when input is received.
		if(cmdState == EXECUTE){
			//Parse input
			if(parseArgs(input) == -1)
			{
				cmdState = GETINPUT;
			}
			
		}

		//Write wave operation
		if (fArm){
			fArm=false;

			//Opcode has the channel in the top 2 bytes and the opcode in the bottom 2 bytes.
			*(uint32_t*)opCodeToSend = (ARM_OP | (channel<<16));
			
			// Opcode is sent first
			if(!DptiIO(hif, opCodeToSend, 4, NULL, 0, fFalse))
			{
				printf("Error sending opcode.\n");
				closeDPTI();
				continue;
			}
			DmgrSetTransTimeout(hif, 0x7FFFFFFF);
			//Then Receive the buffer, overlap enabled, so this function will 'arm' the DPTI device
			if(!DptiIO(hif, NULL, 0, (BYTE*)pBuf, length*sizeof(float), fTrue))
			{
				status = DmgrGetLastError();
				printf("Error %d receiving waveform.\n", status);
				closeDPTI();
				continue;
			}
			printf("Waiting for trigger...\r\n");
			fArmed=true;
			cmdState=WAIT;
		}
		
		//Immediate acquire operation	
		if(fImmediate){
			
			fImmediate=false;
			*(uint32_t*)opCodeToSend = IMMEDIATE_OP | (channel<<16);
			// Only Opcode is sent
			if(!DptiIO(hif, opCodeToSend, 4, NULL, 0, fFalse))
			{
				status = DmgrGetLastError();
				printf("Error %d sending opcode.\n", status);
				closeDPTI();
				continue;
			}
			//Then Request the buffer
			if(!DptiIO(hif, NULL, 0, (BYTE*)pBuf, length*sizeof(float), fTrue))
			{
				status = DmgrGetLastError();
				printf("Error %d receiving waveform.\n", status);
				closeDPTI();
				continue;
			}
			fArmed=true;
			cmdState=WAIT;
		}
		//Device is armed and waiting for trigger
		if (fArmed){
			DmgrGetTransResult(hif, &nDataOut, &nDataIn, 0);
			status = DmgrGetLastError();
			if(status!=ercTransferPending && status!=ercNoErc){
				fArmed=false;
				printf("Error %d receiving data.\r\n", status);
				DmgrSetTransTimeout(hif, 3000);
				cmdState=GETINPUT;//Print prompt again.
			}
			else if(nDataIn>=length*sizeof(float)){
				printf("Received %d bytes, %d samples\n", nDataIn, nDataIn/4);
				FILE* file = fopen(filename, "w");
				for(int i =0; i<length; i++){
					fprintf(file, "%f\n", pBuf[i]);
				}
				fclose(file);
				DmgrSetTransTimeout(hif, 3000);
				fArmed=false;
				cmdState=GETINPUT;//Print prompt again.
			}
		}
		//Stop Operation
		if(fStop){
			fStop=false;
			*(uint32_t*)opCodeToSend = STOP_OP | (channel<<16);
			// Only Opcode is sent
			if(!DptiIO(hif, opCodeToSend, 4, NULL, 0, fFalse))
			{
				status = DmgrGetLastError();
				printf("Error %d sending opcode.\n", status);
				closeDPTI();
				continue;
			}
			cmdState=GETINPUT;//Print prompt again.
		}
		//Set Gain
		if(fSetGain){
			fSetGain=false;
			*(uint32_t*)opCodeToSend = SET_GAIN_OP | (channel<<16);
			*(uint32_t*)paramToSend = gain;
			// Opcode is sent first
			if(!DptiIO(hif, opCodeToSend, 4, NULL, 0, fFalse))
			{
				status = DmgrGetLastError();
				printf("Error %d sending opcode.\n", status);
				closeDPTI();
				continue;
			}
			// Gain parameter send second
			if(!DptiIO(hif, paramToSend, 4, NULL, 0, fFalse))
			{
				status = DmgrGetLastError();
				printf("Error %d sending parameter.\n", status);
				closeDPTI();
				continue;
			}
			cmdState=GETINPUT;//Print prompt again.
		}
		//Set Trigger Edge
		if(fSetTriggerEdge){
			fSetTriggerEdge=false;
			*(uint32_t*)opCodeToSend = SET_TRIGGER_EDGE_OP | (channel<<16);
			*(uint32_t*)paramToSend = triggerEdge;
			// Opcode is sent first
			if(!DptiIO(hif, opCodeToSend, 4, NULL, 0, fFalse))
			{
				status = DmgrGetLastError();
				printf("Error %d sending opcode.\n", status);
				closeDPTI();
				continue;
			}
			// Gain parameter send second
			if(!DptiIO(hif, paramToSend, 4, NULL, 0, fFalse))
			{
				status = DmgrGetLastError();
				printf("Error %d sending parameter.\n", status);
				closeDPTI();
				continue;
			}
			cmdState=GETINPUT;//Print prompt again.
		}
		//Set Output Frequency Divider
		if(fSetTriggerLevel){
			fSetTriggerLevel=false;
			*(uint32_t*)opCodeToSend = SET_TRIGGER_LEVEL_OP | (channel<<16);
			*(uint32_t*)paramToSend = *(uint32_t*)&triggerLevel;
			// Opcode is sent first
			if(!DptiIO(hif, opCodeToSend, 4, NULL, 0, fFalse))
			{
				status = DmgrGetLastError();
				printf("Error %d sending opcode.\n", status);
				closeDPTI();
				continue;
			}
			// Divider parameter send second
			if(!DptiIO(hif, paramToSend, 4, NULL, 0, fFalse))
			{
				status = DmgrGetLastError();
				printf("Error %d sending parameter.\n", status);
				closeDPTI();
				continue;
			}
			cmdState=GETINPUT;//Print prompt again.
		}
		//Set Coupling
		if(fSetCoupling){
			fSetCoupling=false;
			*(uint32_t*)opCodeToSend = SET_COUPLING_OP | (channel<<16);
			*(uint32_t*)paramToSend = coupling;
			// Opcode is sent first
			if(!DptiIO(hif, opCodeToSend, 4, NULL, 0, fFalse))
			{
				status = DmgrGetLastError();
				printf("Error %d sending opcode.\n", status);
				closeDPTI();
				continue;
			}
			// Gain parameter send second
			if(!DptiIO(hif, paramToSend, 4, NULL, 0, fFalse))
			{
				status = DmgrGetLastError();
				printf("Error %d sending parameter.\n", status);
				closeDPTI();
				continue;
			}
			cmdState=GETINPUT;//Print prompt again.
		}
		//Set Length
		if(fSetLength){
			
			fSetLength=false;
			*(uint32_t*)opCodeToSend = SET_LENGTH_OP | (channel<<16);
			*(uint32_t*)paramToSend = length;
			// Opcode is sent first
			if(!DptiIO(hif, opCodeToSend, 4, NULL, 0, fFalse))
			{
				status = DmgrGetLastError();
				printf("Error %d sending opcode.\n", status);
				closeDPTI();
				continue;
			}
			// Gain parameter send second
			if(!DptiIO(hif, paramToSend, 4, NULL, 0, fFalse))
			{
				status = DmgrGetLastError();
				printf("Error %d sending parameter.\n", status);
				closeDPTI();
				continue;
			}
			cmdState=GETINPUT;//Print prompt again.
		}
		nanosleep(&ts, NULL);
	}

	return 0;
}

/**
* Closes the connection to the DPTI device
*/
void closeDPTI(){
	cmdState=GETINPUT;//Print prompt again.
	DmgrCancelTrans(hif);
	DptiDisable(hif);
	DmgrClose(hif);
	fDptiInit=false;
	cmdState=false;
}

/**
* Parses the input string into commands. Boolean flags are set and executed in the main loop.
*
* @param input the input string to parse
*
* @return 0 if passed, -1 if failed
*
*/
int parseArgs(char* input){
	char* arg;
	arg = strtok(input, " \n");
	if(arg==NULL){
		printf("\nPlease enter a command\n");
		return -1;
	}
	while(arg!=NULL){
		if(strcmp(strlwr(arg), "arm")==0){
			arg = strtok(NULL," \n");
			if(arg!=NULL){
				strcpy(filename, arg);
				fArm = true;
			}
			else{
				printf("Error: No filename specified\n");
				return -1;
			}
		}
		else if(strcmp(strlwr(arg), "start")==0 || strcmp(strlwr(arg), "immediate")==0){
			arg = strtok(NULL," \n");
			if(arg!=NULL){
				strcpy(filename, arg);
				fImmediate = true;
			}
			else{
				printf("Error: No filename specified\n");
				return -1;
			}
		}
		else if(strcmp(strlwr(arg), "stop") == 0){
			fStop = true;
		}

		else if(strcmp(strlwr(arg), "length") == 0){
			arg = strtok(NULL," \n");
			if(arg==NULL){
				printf("Please enter a length value, EX: length 42\n");
				return -1;
			}
			if(arg[0]<'0' && arg[0]>'9'){
				printf("Invalid length value \"%s\". Please enter a length value. EX: length 42\n", arg);
			}
			if(arg[0]=='0' && (arg[1]=='x'||arg[1]=='X')){
				sscanf(arg, "0x%X", &length);
			}
			else{
				length = atoi(arg);
			}
			if(length>0 && length < 0x4000){
				fSetLength = true;
			}
			else{
				printf("Length value must be between 1 and 16384\n");
				return -1;
			}
		}
		else if(strcmp(strlwr(arg), "gain") == 0){
			arg = strtok(NULL," \n");
			if(arg==NULL){
				printf("Please enter a gain value, EX: gain high\n");
				return -1;
			}
			if(strcmp(strlwr(arg), "low")==0 || arg[0]=='0'){
				gain = 0;
				fSetGain=true;
			}
			else if(strcmp(strlwr(arg), "high")==0 || arg[0]=='1'){
				gain = 1;
				fSetGain=true;
			}
			
			else{
				printf("Invalid gain value \"%s\". Expected low, 0, high, or 1\n", arg);
				return -1;
			}
		}
		else if(strcmp(strlwr(arg), "edge") == 0){
			arg = strtok(NULL," \n");
			if(arg==NULL){
				printf("Please enter a trigger edge, EX: trigger rising\n");
				return -1;
			}
			if(strcmp(strlwr(arg), "rising")==0 || arg[0]=='1'){
				triggerEdge = 0;
				fSetTriggerEdge=true;
			}
			else if(strcmp(strlwr(arg), "falling")==0 || arg[0]=='0'){
				triggerEdge = 0;
				fSetTriggerEdge=true;
			}
			
			else{
				printf("Invalid trigger edge value \"%s\". Expected rising, 1, falling, 0\n", arg);
				return -1;
			}
		}
		else if(strcmp(strlwr(arg), "level") == 0){
			arg = strtok(NULL," \n");
			if(arg==NULL){
				printf("Please enter a trigger level, EX: trigger 1.5\n");
				return -1;
			}
			if(arg[0]<'0' && arg[0]>'9'){
				printf("Invalid trigger level value \"%s\". Please enter a trigger level value. EX: level 1.5\n", arg);
			}
			triggerLevel = atof(arg);
			if(triggerLevel>0 && triggerLevel < 25){
				fSetTriggerLevel = true;
			}
			else{
				printf("Trigger Level value must be between 0 and \n");
				return -1;
			}
		}
		else if(strcmp(strlwr(arg), "ch1") == 0){
			channel = 1;
		}
		else if(strcmp(strlwr(arg), "ch2") == 0){
			channel = 2;
		}
		else if(strcmp(strlwr(arg), "help") == 0 || arg[0]=='?'){
			printUsage();
		}
		else {
			printf("Error: Invalid argument %s\n", arg);
			return -1;
		}
		arg = strtok(NULL, " \n");
	}

	return 0;
}

/**
* Prints the usage of the program
*/
void printUsage(){
	printf("USB104A7 ZmodADC demo\n------------------------------\n");
	printf("Commands\n");
	printf("arm [path to waveform.csv]\t-\tArm the ADC to acquire data to be sent to a file\n");
	printf("immediate/start\t\t-\tAcquire data immediately\n");
	printf("level [voltage]\t-\tSet trigger level voltage (default 0.5V).\n");
	printf("edge [rising, falling]\t\t-\tSet the trigger edge to rising or falling edge (Default rising).\n");
	printf("window [sample number]\t\t-\tSet the window position at which to run the data acquisition\n");

	printf("stop\t\t-\tStop the ZmodADC Acquisition\n");
	printf("ch1/ch2\t\t-\tSelect ADC channel\n");
	printf("gain [low,high,0,1]\t-\tSet the gain low or high\n\n");
	

}

/**
* Gets the number of newlines in a file
*
* @param csv handle of the file to scan.
*
* @return the number of newlines in the file
*
*/
int getNumLines(FILE* csv){
	int ch;
	int nLines=0;
	fseek(csv, 0, SEEK_SET);
	do{
		ch = fgetc(csv);
		if (ch=='\n')nLines++;
	}while(ch!=EOF);
	return nLines;
}

/**
* Reads each sample in the waveform .csv and converts them into signed 14 bit values. Samples are expected to be values between -1 and 1.
*
* @param csv File handle of the csv file to read.
*
* @param buf Buffer to store the signed 14 bit values.
*
* @return number of samples added
*
*/
int getWaveData(FILE* csv, BYTE* buf){
	char line[256];
	int offset=0;
	float sample;
	fseek(csv, 0, SEEK_SET);
	while(fgets(line, 256, csv)!=NULL){
		if((line[0]==0 || line[0]<'0' || line[0]>'9') && line[0]!='-'){//If it is not a number, skip
			continue;
		}
		sample = atof(line);
		if (sample>1)sample=1;
		else if (sample<-1)sample=-1;
		*(int16_t*)&buf[offset*2] = (int16_t)(0x1FFF * sample);//Convert from percentage to 14 bit signed int value
		//Using offset*2 here to pack the values as 16 bit ints.
		offset++;
	}
	return offset;
}

/**
* Initializes the connection to the DPTI device.
*
* @return status, 0 if passed
*
*/
int initDPTI(){
	int status;
	int cprtPti;
	//Open device
	if((status = DmgrOpen(&hif, "Usb104A7_DPTI"))==false){
		status = DmgrGetLastError();
		printf("Error %d opening Usb104A7_DPTI\n", status);
		return status;	
	}
	//Get DPTI port count on device
	if((status = DptiGetPortCount(hif, &cprtPti))==false){
		status = DmgrGetLastError();
		printf("Error %d getting DPTI port count\n", status);
		DmgrClose(hif);
		return status;
	}
	if(cprtPti == 0){
		printf("No DPTI ports found\n");
		return status;
	}
	if((status = DptiGetPortProperties(hif, portNum, &pDevProperties))==false){
		status = DmgrGetLastError();
		printf("Error %d getting port properties\n", status);
		DmgrClose(hif);
		return status;
	}
	if(pDevProperties & dprpPtiSynchronous == 0){
		printf("Error device does not support Synchronous Parallel Transfers\n");
		return -1;
	}
	//Enable DPTI bus
	if((status = DptiEnableEx(hif, portNum))==false){
		status = DmgrGetLastError();
		printf("Error %d enabling DPTI bus\n", status);
		DmgrClose(hif);
		return status;
	}
	DptiSetChunkSize(hif, 16384, 16384);
	DmgrSetTransTimeout(hif, 3000);
	printf("DPTI Device Opened\n");
	return 0;
}
#if defined(WIN32)
DWORD WINAPI TerminalThread(){
#else
void* terminalThread(){
#endif
	
		//Print command prompt
		while(1){
			printf("Channel %d:", channel);
			fgets(input, sizeof(input), stdin);
			cmdState = EXECUTE;
			while(cmdState != GETINPUT);
		}
		return 0;
}