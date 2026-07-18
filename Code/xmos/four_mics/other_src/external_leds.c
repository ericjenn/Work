/* 
In order to use external libraries, you have to adjust the CMakeLists.txt file.
There is no need to download the libraries manually, CMake will take care of that.
See also https://www.xmos.com/documentation/XM-014363-PC/html/prog-guide/quick-start/c-programming-guide/index.html
*/ 

#include <stdio.h>
#include <platform.h>
#include <xcore/parallel.h>
#include <xcore/hwtimer.h>
#include <xcore/channel.h>
#include <xcore/port.h>



void say_hello(int my_id)
{
  printf("Hello world from %d!\n", my_id);
}


void blink (void) {
      port_t led_port = XS1_PORT_4C;
      hwtimer_t timer = hwtimer_alloc();
      port_enable(led_port);

      
  while(1) {
    port_out(led_port, 0b1010);
        hwtimer_delay(timer, 10000000);
    port_out(led_port, 0b0101);
            hwtimer_delay(timer, 5000000);

    }
    hwtimer_free(timer);
    port_disable(led_port);
  
}

// X1D50nX1D51,X1D62,X1D63
void blink_t1 (void) {
      port_t led_port = XS1_PORT_32A;
      hwtimer_t timer = hwtimer_alloc();
      port_enable(led_port);

      
  while(1) {
    port_out(led_port, 0b00000000000000000000000000000000);
        hwtimer_delay(timer, 10000000);
    port_out(led_port, 0b00000000000000000001100000000110);
            hwtimer_delay(timer, 5000000);

    }
    hwtimer_free(timer);
    port_disable(led_port);
  
}


void sends_first(chanend_t c)
{
  chan_out_word(c, 0x12345678);
  printf("Received byte: '%c'\n", chan_in_byte(c));
}


void receives_first(chanend_t c)
{
  printf("Received word: 0x%lx\n", chan_in_word(c));
  chan_out_byte(c, 'b');
}

/*
void gene_square_wave( void ) {
    int led_state = 0;
    port_timestamp_t tstamp;


    // Enable port and clock
    port_enable(led_port);
    clock_enable(clock_handle);

    // configure the clock to 1 MHz
    clock_set_source_clk_ref(clock_handle); // set the clock source to 100 MHz, i.e. 10 nsec period
    clock_set_divide(clock_handle, 50); // divide the clock by 2*50 (100) to get 1 MHz, i.e. 1 usec period

    // start the clock, and assign it to the port counter
    clock_start(clock_handle);
    port_set_clock(led_port, clock_handle);
    
    // forever loop
    while(1) {
        // toggle the state variable
        led_state = !led_state;
        //port_out will be immediate, unless there is a count condition set
        if (led_state) {
            port_out(led_port, 0xf);
        } else {
            port_out(led_port, 0x0);
        }
        // determine the precise count value that the port update occurred at:
        tstamp = port_get_trigger_time(led_port);
        // set a condition that the next port update must occur exactly 5 usec later
        port_set_trigger_time(led_port, tstamp + 5); // 5 usec
        // the next port_out will pause until the count value set.
    }
}

*/