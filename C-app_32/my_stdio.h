/*************************
* My implementations of std c functions for bare metal x86 
* David Wrinn
**************************/
#include "stdarg.h"


#define COLOR_CHAR_MEM_START    0xb8000             // VGA color character memory starts at this address.
                                                    // 80x25 character screen.
#define COLOR_CHAR_MEM_END      0xb8f9f


int my_printf(const char* str, ...);
int my_putc(char c);