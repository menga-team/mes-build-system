#include <stdbool.h>

#include <timer.h>
#include <gpu.h>

#define FPS 60
#define FRAMETIME ((1.0/FPS)*1000)

uint8_t start(void) {
    uint32_t deltatime;
    uint32_t stop;
    uint32_t start;
    char* helloworld = "Hello World" FONT_EXCLAMATIONMARKDOUBLE;

    start = timer_get_ms();
    while(true) {
        // rendering
        gpu_blank(BACK_BUFFER, 0);
        gpu_print_text(BACK_BUFFER, 1, 1, 1, 3, helloworld);
        gpu_swap_buf();

        // timing
        stop = timer_get_ms();
        deltatime = stop - start;
        if (deltatime < FRAMETIME) {
            timer_block_ms(FRAMETIME - deltatime);
        }
        start = timer_get_ms();
    }
}