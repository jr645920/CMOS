#include <iostream>
#include <fstream>
#include <algorithm>

using namespace std;

typedef struct hash_t {

};

//  functions for winnow
void next_hash(){

}

int global_pos(int m, int r, int w){

}

void record(){

}

//  main winnow function
void winnow(int w /*window size*/) {
    // circular buffer implementing window of size w
    hash_t h[w];
    for (int i = 0; i < w; ++i)
        h[i] = 999;
    int r = 0;   // window right end
    int min = 0; // index of minimum hash
    // At the end of each iteration, min holds the
    // position of the rightmost minimal hash in the
    // current window. record(x) is called only the
    // first time an instance of x is selected as the
    // rightmost minimal hash of a window.
    while (true)
    {
        r = (r + 1) % w;    // shift the window by one
        h[r] = next_hash(); // and add one new hash
        if (min == r)
        {
            // The previous minimum is no longer in this
            // window. Scan h leftward starting from r
            // for the rightmost minimal hash. Note min
            // starts with the index of the rightmost
            // hash.
            for (int i = (r - 1) % w; i != r; i = (i - 1 + w) % w)
                if (h[i] < h[min])
                    min = i;
            record(h[min], global_pos(min, r, w));
        }
        else
        {
            // Otherwise, the previous minimum is still in
            // this window. Compare against the new value
            // and update min if necessary.
            if (h[r] <= h[min])
            { // (*)
                min = r;
                record(h[min], global_pos(min, r, w));
            }
        }
    }
}