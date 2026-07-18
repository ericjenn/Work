/*
 According to the documentation, it seems that only xc can be used to pin
 a job on a specific tile. 
*/

#include <platform.h>

typedef chanend chanend_t;

extern "C" {
    void sends_first(chanend_t);
    void receives_first(chanend_t);
    void say_hello(int);
    void blink(void);
    void blink_t1(void);
}

int main(void)
{
  chan c;
  par {
    on tile[0]: sends_first(c);
    on tile[1]: receives_first(c);
    on tile[1]: blink_t1();
    on tile[0]: blink();
    on tile[0]: say_hello(0);
  }
  return 0;
}
