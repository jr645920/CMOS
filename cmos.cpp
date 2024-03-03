#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <iterator>
#include <map>


using namespace std;

int global_pos(int m, int r, int w) {
    return (m + r) % w;
}
// Function to record the minimal hash and its position as a fingerprint
void record(int min, int w) {
    int position = global_pos(min, w - 1, w); // Adjusted to use w - 1 for r
}

int next_hash(int current_hash) {
    return (current_hash * 100) % 4; // Example hash function, adjust as needed
}

//  main winnow function
void winnow(int w) {
    vector<int> h(w, 999); // Circular buffer implementing window of size w
    for (int i = 0; i < w; i++){
        h[i] = INT_MAX;
    }
    int r = 0; // Window right end
    int min = 0; // Index of minimum hash
    // At the end of each iteration, min holds the
    // position of the rightmost minimal hash in the
    // current window. record(x) is called only the
    // first time an instance of x is selected as the
    // rightmost minimal hash of a window.
    while (true) {
        r = (r + 1) % w; // Shift the window by one
        h[r] = next_hash(r); // Add one new hash
       
        if (min == r) {
            // The previous minimum is no longer in this
            // window. Scan h leftward starting from r
            // for the rightmost minimal hash. Note min
            // starts with the index of the rightmost hash.
            for (int i = (r - 1 + w) % w; i != r; i = (i - 1 + w) % w) {
                if (h[i] < h[min]) {
                    min = i;
                }
            }
            // Record the minimal hash
            record(h[min], global_pos(min, r, w));
        } else {
            // The previous minimum is still in this window
            // Compare against the new value and update min if necessary
            if (h[r] < h[min]) {
                min = r;
                // Record the minimal hash
                record(h[min], global_pos(min, r, w));
            }
        }
    }
}

int main(){

    fstream file_in;
    file_in.open("tokens.txt");
    
    if (file_in.is_open()){
        winnow(4);
    }
    else{
        cout << "Error opening tokens.txt" << endl;
        exit(0);
    }
    
        
    
    


    
}