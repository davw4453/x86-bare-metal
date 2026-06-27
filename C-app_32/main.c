/******************************************* 
* Print a message to the VGA character display
* David Wrinn
********************************************/


int main()
{
    //char* video_memory = (char*) 0xb8000;
    //video_memory = video_memory + 1760;
    //*video_memory = 'X';

    while(1)
    {
        __asm__ __volatile__("jmp ."); // Jump to the current instruction forever
    }
    return 0; 
}