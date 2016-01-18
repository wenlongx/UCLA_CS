Wenlong Xiong
UID: 204407085

To make the program multithreaded, I moved all the logic that rendered each pixel (starting from 
the nested for loops) to a separate function called render_pixel. I passed in 2 arguments - one 
called start and one called end. These marked the range of rows of pixels that each thread would 
cover. Each thread renders an equal number of pixels except for the last, which takes care of the 
leftovers rows that don't divide evenly.
I ran into an issue while I was writing the pixel rendering function where I was having a race 
condition when I printed out the scaled colors. This is because I printed the colors directly to 
stdout in each thread, so the order in which the threads were started were not necessarily the 
order in which the threads printed thge colors. I fixed this by creating a global variable that was 
a multidimensional array of floats (I stored all the color values in it while I was running the 
threads) and by printing only after all the threads had terminated.
My multithreaded implementation results in improved performance when the program is run with a 
number of threads greater than 1 and less than or equal to the number of cores the computer has. 
This allows each thread to be run on a separate core, allowing multiple pixel rendering 
calculations to be performed at once. When the program runs with a number of threads greater than 
the number of cores the computer has, several threads begin occupying a single core, and the 
increased overhead coupled with the cost of context switches result in decreased performance. This 
is shown by the following results (I timed my program when it was run with different numbers of 
threads):
1 Thread:
    real    0m49.806s
    user    0m49.818s
    sys 0m0.003s
2 Threads:
    real    0m25.937s
    user    0m50.135s
    sys 0m0.002s
4 Threads:
    real    0m18.881s
    user    0m56.551s
    sys 0m0.004s
8 Threads:
    real    0m10.856s
    user    0m52.272s
    sys 0m0.000s
