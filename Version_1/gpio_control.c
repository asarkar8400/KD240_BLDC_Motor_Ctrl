#include <stdio.h>
#include <xgpio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"

XGpio Motor_Ena_Gpio;

int main()
{
    int Status;
    init_platform();
    print("Hello World\n\r");

    // initialize axi gpio connected to motor_en
    Status = XGpio_Initialize(&Motor_Ena_Gpio, XPAR_MOTOR_ENA_BASEADDR);
    if (Status != XST_SUCCESS) {
        xil_printf("Gpio Initialization Failed\r\n");
        return XST_FAILURE;
    }

    // set the gpio pin as an output
    XGpio_SetDataDirection(&Motor_Ena_Gpio, 1, 0x00);

    XGpio_DiscreteWrite(&Motor_Ena_Gpio, 1, 0x01);
    print("Motor ON.\n\r");

    XGpio_DiscreteClear(&Motor_Ena_Gpio, 1, 0x01);
    print("Motor OFF.\n\r");

    cleanup_platform();
    return 0;
}
