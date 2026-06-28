/*************************
* My implementations of std c functions for bare metal x86 
* David Wrinn
**************************/
#include "my_stdio.h"

// Global vars 
char* pvid_mem = (char*)COLOR_CHAR_MEM_START; // keep track of the character position on screen.

/*
int my_printf(const char* str, ...)
{
    va_list args;
    int print_char_num = 0;


    if(!str) {return -1; } //If the string is empty return an error code.
    
    while(*str)
    {
        if(*str == '%')
        {
            str++; //increment the pointer by 1 to look after the delimiter.

            if(*str == '\0') {return -1; } //we've reached the end of the str.

            switch(*str)
            {
                case 'c':                  // Handle characters
                    my_putc(va_arg(args, int), pvid_mem);
                    print_char_num++;
                    pvid_mem++;
                    break;
                
                case 's':                  // Handle strings
                    int tmp_count = my_printf(va_arg(args, char*)); // recursive call.
                    pvid_mem += tmp_count;
                    print_char_num += tmp_count;
                    break;

                //case 'd':                  // Handle signed integers
                //case 'i':
                    //print_char_num += my_print_num(va_arg(args, int));
                    //break;

                case '%':                  // Handle the % sign.
                    my_putc('%', pvid_mem);
                    print_char_num++;
                    pvid_mem++;
                    break;
                
                default:
                    my_putc('%', pvid_mem);           // Handle unkown specifiers as plaintext.
                    pvid_mem++;
                    my_putc(*str, pvid_mem);
                    pvid_mem++;
                    print_char_num += 2;
                    break;
            }
        } else
        {
            my_putc(*str, pvid_mem);
            pvid_mem++;
            print_char_num++;
        }
        str++; // increment the pointer.
    }
    return print_char_num;
}
*/
int my_putc(char c)
{
    if(pvid_mem >= (char*)COLOR_CHAR_MEM_START || pvid_mem <= (char*)COLOR_CHAR_MEM_END)
    {
        *pvid_mem = c;
        return c;
    } else
    {
        return -1;
    }
}

/*
int my_print_num(int n)
{
    int count = 0;
    unsigned int num;

    if(n < 0)
    {
        my_putc('-', pvid_mem);
        count++;
        num = -n;
    } else
    {
        num = n;
    }

    if(num / 10)
    {
        count += 
    }
}
    */