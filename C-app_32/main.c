/******************************************* 
* Print a message to the VGA character display
* David Wrinn
********************************************/
#include "my_stdio.h"

extern char* pvid_mem;

int main()
{
    
    pvid_mem = pvid_mem + 1760;
    //my_printf("This is a test message.\n");
    //my_printf("test message 2.");
    my_putc('T');

    int i = 0;
    while(1)
    {
        i = 1;
    }

    

    return 0; 
}