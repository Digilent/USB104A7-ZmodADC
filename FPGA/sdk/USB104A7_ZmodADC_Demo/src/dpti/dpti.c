#include "dpti.h"

/*
 * Device instance definitions
 */

static XAxiDma AxiDma;

static u8 dptiBuf [_HeaderSize];

/**
 * Initialize the DPTI and DMA.
 *
 * @param DMADeviceId
 *
 *
 * @return a pointer to an instance of DMAEnv
 */
int initDPTI(u16 DMADeviceId){
 	XAxiDma_Config *CfgPtr;
  	XStatus Status;
  	int timeout =0;

	/* Initialize the XAxiDma device.
	 */
	CfgPtr = XAxiDma_LookupConfig(DMADeviceId);
	if (!CfgPtr) {
		xil_printf("No config found for %d\r\n", DMADeviceId);
		return XST_FAILURE;
	}

	Status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failed %d\r\n", Status);
		return XST_FAILURE;
	}

	if(XAxiDma_HasSg(&AxiDma)){
		xil_printf("Device configured as SG mode \r\n");
		return XST_FAILURE;
	}

	/* Disable interrupts, we use polling mode
	 */
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
						XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
						XAXIDMA_DMA_TO_DEVICE);
	XAxiDma_Reset(&AxiDma);
	while(!XAxiDma_ResetIsDone(&AxiDma)){
		timeout++;
		if(timeout>=6000000){
			xil_printf("Failed to reset DPTI DMA device\r\n");
			return XST_FAILURE;
		}
	}
	DPTI_Reset(_AXI_DPTI_BASE_ADDRESS);

	return XST_SUCCESS;
}
/**
 * Requests [_HeaderSize] number of bytes from DMA and DPTI.
 *
 * @return XST_SUCCESS or XST_FAILURE
 */
XStatus DPTI_RequestHeader(){
	XStatus Status;
	u8 DPTI_Status;

	DPTI_Status = DPTI_SimpleTransfer(_AXI_DPTI_BASE_ADDRESS, DPTI_TO_STREAM, _HeaderSize); // Requesting a 4 byte transfer from the PC
	Status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)dptiBuf, _HeaderSize, XAXIDMA_DEVICE_TO_DMA); // DMA writes header in memory
	if ((Status != XST_SUCCESS) || (DPTI_Status != XST_SUCCESS)){
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}

/**
 * Get a 4 byte OpCode from DPTI. This function must only be used after a header was
 * requested using DPTI_RequestHeader(). If data is available, it will be received.
 *
 * @return opcode received
 */
int DPTI_GetOpcode(){
	u32 operation_from_PC;
	int i;

	// Already requested DMA transfer of 4 bytes.
	// Read header from PC
	if (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA)) // If DMA transfer has finished (we have 4 byte header)
	{
		if((Xil_In32(_AXI_DPTI_BASE_ADDRESS + DPTI_STATUS_REG_OFFSET) & DPTI_SR_RX_LEN_EMPTY_MASK) && XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA)){//Somehow got into a weird state where DPTI is not receiving but DMA is armed.
			DPTI_RequestHeader();
		}
		return -1;
	}
	Xil_DCacheInvalidateRange((UINTPTR)dptiBuf, _HeaderSize);
	xil_printf("Read Data from PC\r\n");
	// Extracting information from header
	for (i = 3; i >= 0; i--){

		operation_from_PC <<= 8;
		operation_from_PC += dptiBuf[i];

	}
	return operation_from_PC;
}


/**
 * Gets a 4byte parameter from DPTI. This function blocks for 10000000 cycles before timing out.
 *
 * @return parameter received
 */
int DPTI_GetParameter(){
	u8 DPTI_Status;
	XStatus Status;
	int param;
	int i;
	int timeout=0;

	xil_printf("Waiting for parameter from PC \r\n");
	DPTI_Status = DPTI_SimpleTransfer(_AXI_DPTI_BASE_ADDRESS, DPTI_TO_STREAM, _HeaderSize);
	Status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)dptiBuf, _HeaderSize, XAXIDMA_DEVICE_TO_DMA);
	if ((Status != XST_SUCCESS) || (DPTI_Status != XST_SUCCESS)){
		return 0;
	}
	while (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA)) // Wait for DMA to finish transfer
	{
		timeout++;
		if(timeout >= 10000000){
			xil_printf("Timed out waiting for length!\r\n");
			XAxiDma_Reset(&AxiDma);
			return 0;
		}
	}
	Xil_DCacheInvalidateRange((UINTPTR)dptiBuf, _HeaderSize);//Refresh buffer in cache
	for (i = 3; i >= 0; i--){
		param <<= 8;
		param += dptiBuf[i];
	}

	return param;
}
/**
 * Receive data from DPTI
 *
 * @param length the number of bytes to receive
 * @param buffer buffer pointer to store data
 *
 * @return XST_SUCCESS if successful, XST_FAILURE if failed
 */
XStatus DPTI_ReceiveData(int length, void* buffer){
	u32 frame_addr_aux;
	u32 length_aux;
	u8 DPTI_Status;
	XStatus Status;
	int timeout;
	frame_addr_aux = (u32)buffer;//address_from_PC;

	length_aux = length;

	while(length_aux > _8MB) // For large transfers. This loop will fragment a large transfer into several 8 MB transfers
	{
		xil_printf("%d bytes remaining \r\n", length_aux);
		DPTI_Status = DPTI_SimpleTransfer(_AXI_DPTI_BASE_ADDRESS, DPTI_TO_STREAM, _8MB);
		Status = XAxiDma_SimpleTransfer(&AxiDma, frame_addr_aux, _8MB, XAXIDMA_DEVICE_TO_DMA);

		if ((Status != XST_SUCCESS) || (DPTI_Status != XST_SUCCESS)){
			return XST_FAILURE;
		}
		timeout=0;
		while (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA)) // Wait for DMA to finish transfer
		{
			timeout++;
			if(timeout >= 10000000){
				xil_printf("Timed out waiting for data!\r\n");
				XAxiDma_Reset(&AxiDma);
				return XST_FAILURE;
			}
		}

		frame_addr_aux += _8MB; // Address is incremented by 8 MB and prepared for next transfer
		length_aux -= _8MB; // Length is decreased by 8 MB
	}

	xil_printf("%d bytes remaining \r\n", length_aux);
	// If the transfer is smaller than 8 MB or, for large transfers, there is data left, the transfer is performed below
	DPTI_Status = DPTI_SimpleTransfer(_AXI_DPTI_BASE_ADDRESS, DPTI_TO_STREAM, length_aux);
	Status = XAxiDma_SimpleTransfer(&AxiDma, frame_addr_aux, length_aux, XAXIDMA_DEVICE_TO_DMA);
	if ((Status != XST_SUCCESS) || (DPTI_Status != XST_SUCCESS)){
		return XST_FAILURE;
	}

	timeout=0;
	while (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA)) // Wait for DMA to finish transfer
	{
		timeout++;
		if(timeout >= 10000000){
			xil_printf("Timed out waiting for data!\r\n");
			XAxiDma_Reset(&AxiDma);
			return XST_FAILURE;
		}
	}
	Xil_DCacheInvalidateRange((UINTPTR)buffer, length);//Refresh buffer in cache
	xil_printf("DONE Reading data from PC\r\n");
	return XST_SUCCESS;
}

/**
 * Send data over DPTI
 *
 * @param length the number of bytes to receive
 * @param buffer buffer pointer to store data
 *
 * @return XST_SUCCESS if successful, XST_FAILURE if failed
 */
XStatus DPTI_SendData(int length, void* buffer){
	u32 frame_addr_aux;
	u32 length_aux;
	u8 DPTI_Status;
	XStatus Status;
	int timeout;
	frame_addr_aux = (u32)buffer;//address_to_PC;

	length_aux = length;

	while(length_aux > _8MB) // For large transfers. This loop will fragment a large transfer into several 8 MB transfers
	{
		xil_printf("%d bytes remaining \r\n", length_aux);
		DPTI_Status = DPTI_SimpleTransfer(_AXI_DPTI_BASE_ADDRESS, STREAM_TO_DPTI, _8MB);
		Status = XAxiDma_SimpleTransfer(&AxiDma, frame_addr_aux, _8MB, XAXIDMA_DMA_TO_DEVICE);

		if ((Status != XST_SUCCESS) || (DPTI_Status != XST_SUCCESS)){
			return XST_FAILURE;
		}
		timeout=0;
		while (XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE)) // Wait for DMA to finish transfer
		{
			timeout++;
			if(timeout >= 10000000){
				xil_printf("Timed out waiting for data!\r\n");
				XAxiDma_Reset(&AxiDma);
				return XST_FAILURE;
			}
		}

		frame_addr_aux += _8MB; // Address is incremented by 8 MB and prepared for next transfer
		length_aux -= _8MB; // Length is decreased by 8 MB
	}

	xil_printf("%d bytes remaining \r\n", length_aux);
	// If the transfer is smaller than 8 MB or, for large transfers, there is data left, the transfer is performed below
	DPTI_Status = DPTI_SimpleTransfer(_AXI_DPTI_BASE_ADDRESS, STREAM_TO_DPTI, length_aux);
	Status = XAxiDma_SimpleTransfer(&AxiDma, frame_addr_aux, length_aux, XAXIDMA_DMA_TO_DEVICE);
	if ((Status != XST_SUCCESS) || (DPTI_Status != XST_SUCCESS)){
		return XST_FAILURE;
	}

	timeout=0;
	while (XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE)) // Wait for DMA to finish transfer
	{
		timeout++;
		if(timeout >= 10000000){
			xil_printf("Timed out waiting for data to send!\r\n");
			XAxiDma_Reset(&AxiDma);
			return XST_FAILURE;
		}
	}
	xil_printf("DONE writing data to PC\r\n");
	return XST_SUCCESS;
}
