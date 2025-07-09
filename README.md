## 🚦 Hall Sensor Lookup Table

The controller reads three digital Hall sensor inputs (`hallA`, `hallB`, `hallC`) and uses them to generate a 3-bit code, which maps to specific motor drive states:

| `hall_code` (Binary) | `hall_code` (Decimal) | Phase A | Phase B | Phase C | Meaning                        |
|----------------------|-----------------------|---------|---------|---------|--------------------------------|
| `3'b001`             | 1                     | Z       | 0       | PWM     | A off, B low, C high           |
| `3'b010`             | 2                     | 0       | PWM     | Z       | A low, B high, C off           |
| `3'b011`             | 3                     | 0       | Z       | PWM     | A low, B off, C high           |
| `3'b100`             | 4                     | PWM     | Z       | 0       | A high, B off, C low           |
| `3'b101`             | 5                     | PWM     | 0       | Z       | A high, B low, C off           |
| `3'b110`             | 6                     | Z       | PWM     | 0       | A off, B high, C low           |
| Others               | —                     | Z       | Z       | Z       | All phases off (safe shutdown) |

> - `Z` = High impedance (tri-state)
> - `0` = Driven low
> - `PWM` = Driven by PWM signal (toggle high/low)

---------------------------------------------------------------------------------------------------------------

## Configuration

- This is a 6-step BLDC controller with open-loop PWM.
- PWM toggles every 3,000,000 cycles (e.g. ~16.67 Hz with 100 MHz clock).
- You can adjust `speed_2000rpm` to change PWM frequency.
