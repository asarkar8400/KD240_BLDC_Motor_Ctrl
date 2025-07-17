#include <stdio.h>
#include <xgpio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "sleep.h"

XGpio MotorEnGpio;
XGpio PwmGpio;
XGpio MonitorGpio;

int main() {
    int status;
    init_platform();

    xil_printf("Motor Control Program Start\n\r");

    // Initialize GPIOs
    XGpio_Initialize(&MotorEnGpio, XPAR_GPIO_0_DEVICE_ID);   // motor_en
    XGpio_Initialize(&PwmGpio,     XPAR_GPIO_1_DEVICE_ID);   // pwm_interval[21:0]
    XGpio_Initialize(&MonitorGpio, XPAR_GPIO_2_DEVICE_ID);   // hall_monitor, phase_monitor

    // Set Data Directions
    XGpio_SetDataDirection(&MotorEnGpio, 1, 0x0); // Output
    XGpio_SetDataDirection(&PwmGpio,     1, 0x0); // Output
    XGpio_SetDataDirection(&MonitorGpio, 1, 0xFFFFFFFF); // Input (hall/phase monitor)
    XGpio_SetDataDirection(&MonitorGpio, 2, 0xFFFFFFFF); // Input (hall/phase monitor)

    // Set Motor Speed
    u32 pwm_value = 3000000000;
    XGpio_DiscreteWrite(&PwmGpio, 1, pwm_value);

    // Turn on motor
    XGpio_DiscreteWrite(&MotorEnGpio, 1, 0x1);
    xil_printf("Motor ON\n\r");

    // Monitor and print hall/phase
    for (int i = 0; i < 100; i++) {
    	u8 hall = XGpio_DiscreteRead(&MonitorGpio, 1) & 0x7;   // Channel 1 = hall
    	u8 phase = XGpio_DiscreteRead(&MonitorGpio, 2) & 0x7;  // Channel 2 = phase

        xil_printf("hall: %d%d%d, phase: %d%d%d\n\r",
            (hall >> 2) & 1, (hall >> 1) & 1, hall & 1,
            (phase >> 2) & 1, (phase >> 1) & 1, phase & 1
        );

        sleep(1);
    }

    // Turn off motor
    XGpio_DiscreteClear(&MotorEnGpio, 1, 0x1);
    xil_printf("Motor OFF\n\r");

    cleanup_platform();
    return 0;
}
