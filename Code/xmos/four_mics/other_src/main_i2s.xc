#include <platform.h>
#include <xs1.h>
#include <math.h>
#include "i2s.h"

/* ================================
 * Audio parameters
 * ================================ */
#define SAMPLE_FREQUENCY       (48000)
#define MASTER_CLOCK_FREQUENCY (12288000)  // 48kHz * 256
#define DATA_BITS              (32)


/* Beep parameters */
#define BEEP_FREQ              (1000)        // 1 kHz
#define BEEP_DURATION_MS       (2000)        // 2 seconds for easier testing
#define BEEP_SAMPLES           ((SAMPLE_FREQUENCY * BEEP_DURATION_MS) / 1000)
#define AMPLITUDE              (1 << 27)     // scale to 32-bit samples

/* Sine LUT parameters */
#define SINE_LUT_BITS          (9) 
#define SINE_LUT_SIZE          (1 << SINE_LUT_BITS)
#define PHASE_ACC_SHIFT        (32 - SINE_LUT_BITS)

static int32_t sine_lut[SINE_LUT_SIZE];

void init_sine_lut(void) {
    for (int i = 0; i < SINE_LUT_SIZE; i++) {
        float theta = (2.0f * 3.14159265f * (float)i) / (float)SINE_LUT_SIZE;
        sine_lut[i] = (int32_t)(sinf(theta) * (float)AMPLITUDE);
    }
}

#define BLINK_PERIOD_TICKS  (10000000)  // 100 ms at 100 MHz


on tile[0]: out port p_led = XS1_PORT_4C;


// Blink external LEDs
void blink_leds (void) {
    timer t;
    unsigned time;
    uint8_t led=0b0001;
    uint8_t left=1;
    t :> time;  // read current time

    while (1) {
        time += BLINK_PERIOD_TICKS;
        t when timerafter(time) :> void;
        p_led <: led;
        if (left) 
            led<<=1;
        else
            led>>=1;
        if ((led==0b0001 || led==0b1000)) 
            left = !left;
    }

    return;      
}

/* ================================
 * I2S application
 * ================================ */
[[distributable]]
void beep_server(server i2s_frame_callback_if i_i2s)
{
    uint32_t phase_acc = 0;
    float step_f = ((float)BEEP_FREQ / (float)SAMPLE_FREQUENCY) * 4294967296.0f;
    uint32_t phase_step = (uint32_t)step_f;
    
    unsigned samples_remaining = BEEP_SAMPLES;
    unsigned total_callbacks = 0;

    printf("Beep server: Starting on Tile 0...\n");
    printf("Phase step: %u\n", phase_step);
    printf("Beep samples: %u\n", BEEP_SAMPLES);

    while (1) {
        select {

            /* -------- init -------- */
            case i_i2s.init(i2s_config_t &?i2s_config,
                            tdm_config_t &?tdm_config):
                i2s_config.mclk_bclk_ratio =
                    (MASTER_CLOCK_FREQUENCY /
                    (SAMPLE_FREQUENCY * 2 * DATA_BITS));
                i2s_config.mode = I2S_MODE_LEFT_JUSTIFIED;
                printf("*** I2S INIT CALLED ***\n");
                printf("  mclk_bclk_ratio = %d\n", i2s_config.mclk_bclk_ratio);
                printf("  mode = I2S_MODE_LEFT_JUSTIFIED\n");
                break;

            /* -------- restart check -------- */
            case i_i2s.restart_check() -> i2s_restart_t restart:
                restart = I2S_NO_RESTART;
                total_callbacks++;
                break;

            /* -------- receive (unused) -------- */
            case i_i2s.receive(size_t num_in, int32_t samples[num_in]):
                printf("WARNING: receive called with num_in=%u (unexpected)\n", num_in);
                break;

            /* -------- send (sine beep) -------- */
            case i_i2s.send(size_t num_out, int32_t samples[num_out]):
                total_callbacks++;
                
                int32_t s = 0;

                if (samples_remaining > 0) {
                    unsigned index = phase_acc >> PHASE_ACC_SHIFT;
                    s = sine_lut[index];
                    phase_acc += phase_step;
                    samples_remaining--;
                } else {
                    // Restart beep for continuous output
                    samples_remaining = BEEP_SAMPLES;
                    phase_acc = 0;
                }

                for (int i = 0; i < num_out; i++) {
                    samples[i] = s;
                }
                break;
        }
    }
}

/* ================================
 * I2S ports on TILE 0 (matching XN file)
 * ================================ */
on tile[1]: out buffered port:32 p_dout[1] = {XS1_PORT_1A};  // Data out
on tile[1]: out port p_bclk = XS1_PORT_1C;                    // Bit clock
on tile[1]: out buffered port:32 p_lrclk = XS1_PORT_1B;      // LR clock (WS)
on tile[1]: clock bclk = XS1_CLKBLK_1;



/* ================================
 * Main
 * ================================ */
int main(void)
{
    i2s_frame_callback_if i_i2s;

    // Each function call or block executes on its own thread
    // There can be more logical threads than physical threads. 
    // In that case, the additional threads are time multiplexed.
    par {
        on tile[0]: 
                blink_leds();
        on tile[1]: {

            printf("\n===========================================\n");
            printf("I2S Beep Test - TILE 0 (No MCLK)\n");
            printf("===========================================\n");
            printf("Sample Rate: %d Hz\n", SAMPLE_FREQUENCY);
            printf("Master Clock: %d Hz\n", MASTER_CLOCK_FREQUENCY);
            printf("Data Bits: %d\n", DATA_BITS);
            printf("Beep Frequency: %d Hz\n", BEEP_FREQ);
            printf("===========================================\n\n");

            printf(">> Tile 1: Initializing sine LUT...\n");
            init_sine_lut();

            printf(">> Tile 1: Configuring clock from internal reference...\n");
            configure_clock_ref(bclk, 16);  // 100/16 MHz ref clock
            
            printf(">> Tile 1: Starting clock...\n");
            start_clock(bclk);
            
            printf(">> Tile 1: Starting I2S tasks...\n\n");

            par {
                beep_server(i_i2s); 

                {
                    printf(">> Tile 1: i2s_frame_master starting (BCLK master mode)...\n");
                    i2s_frame_master_external_clock(
                        i_i2s,          // The I2S frame callback interface to connect to the application
                        p_dout,         // Array of data output ports (TX channel)
                        1,              // 1 output fdata port
                        NULL,           // No input data ports (RX)
                        0,              
                        DATA_BITS,      // Number of bits per data word
                        p_bclk,         // Bit clock output port
                        p_lrclk,        // Word clock output port
                        bclk            // Clock configured externally providing bit clock
                    );
                    printf(">> Tile 1: i2s_frame_master EXITED (should never happen!)\n");
                }
            }



        }
    }
    return 0;
}
