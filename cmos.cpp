#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <iterator>
#include <map>


using namespace std;

// hashtable
vector < vector<multimap<int, int>> > hash_table;

//  functions for winnow
int next_hash(){
    return (rand() * 100) % 4;
}

int global_pos(int m, int r, int w){
    return m + r;
}

void record(int hash, int nextposition){
    multimap<int, int> tmp(hash, nextposition);
    hash_table[hash].push_back(tmp);
}

//  main winnow function
void winnow(int w, vector<vector<multimap<int, int>>>& hash_table) {
    vector<int> h(w, 999); // Circular buffer implementing window of size w
    int r = 0; // Window right end
    int min = 0; // Index of minimum hash

    while (true) {
        r = (r + 1) % w; // Shift the window by one
        h[r] = next_hash(); // Add one new hash
        
        if (min == r) {
            // The previous minimum is no longer in this window
            // Scan h leftward starting from r for the rightmost minimal hash
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
            if (h[r] <= h[min]) {
                min = r;
                // Record the minimal hash
                record(h[min], global_pos(min, r, w));
            }
        }
    }
}

int main(){

}