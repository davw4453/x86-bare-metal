/******************************************* 
* Print a message to the VGA character display
* David Wrinn
********************************************/


int main()
{
    char* video_memory = (char*) 0xb8000;
    video_memory = video_memory + 1760;
    *video_memory = 'X';

    int i = 0;
    while(1)
    {
        i = 1;
    }
    return 0; 
}