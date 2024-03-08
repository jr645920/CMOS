//*****************************************************************************************
// Filename: cmos.cpp
// Authors: Hunter Smith and Johnathan Reilly
// Brief: A c++ program that uses the Winnowing algorithm to detect plagarism in
//        pre-tokenized student sumbission files.
// ****************************************************************************************

#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>
#include <unordered_set>
#include <unordered_map>
#include <algorithm>

using namespace std;

// read tokens from the file
vector<vector<string>> read_in_tokens() {

    ifstream file;
    file.open("tokens.txt");
    if (!file.is_open()) { // error checking
        cerr << "Error opening tokens.txt " << endl;
        exit(1);
    }

    vector<vector<string>> tokens;
    string line;

    while (getline(file, line)) {
        istringstream iss(line);
        vector<string> submission_tokens;
        string token;

        while (iss >> token) {
            submission_tokens.push_back(token);
        }
        tokens.push_back(submission_tokens);
    }

    return tokens;
}

// generate k-grams from a sequence of tokens from read_in_tokens
vector<string> generate_kgrams(const vector<string>& tokens, int k) {
    vector<string> kgrams;
    for (size_t i = 0; i <= tokens.size() - k; i++) {
        string kgram;

        for (int j = 0; j < k; j++) {
            kgram += tokens[i + j];
        }

        kgrams.push_back(kgram);
    }

    return kgrams;
}

// compute the hash of a string
size_t hash_string(const string& str) {
    hash<string> hasher;
    return hasher(str);
}

// perform the Winnowing algorithm
vector<size_t> winnow(const vector<string>& tokens, int k, int w) {
    vector<string> kgrams = generate_kgrams(tokens, k);
    vector<size_t> fingerprints;

    for (size_t i = 0; i <= kgrams.size() - w; i++) {
        string window_min = *min_element(kgrams.begin() + i, kgrams.begin() + i + w); // global position is just mininmum element
        fingerprints.push_back(hash_string(window_min));
    }

    return fingerprints;
}

// calculate similarity (int didn't work so size_t had to be used)
double calculate_similarity(const unordered_set<size_t>& set_one, const unordered_set<size_t>& set_two) {
    unordered_set<size_t> intersection; // use set/map for kgrams
    for (size_t hash_val : set_one) {

        if (set_two.find(hash_val) != set_two.end()) {
            intersection.insert(hash_val);
        }

    }  

    double in_common_size = intersection.size();
    double total_size = set_one.size() + set_two.size() - in_common_size;

    return in_common_size / total_size; 
}

int main() {
    // Experiment with k-gram and window size
    int k = 10;            
    int w = k; 

    // Read in tokens
    vector<vector<string>> submissions = read_in_tokens();

    // winnowing algorithm with helper functions
    unordered_map<string, vector<size_t>> submission_fingerprints;

    for (const auto& submission : submissions) {
        string submission_id = submission[0];
        vector<size_t> fingerprints = winnow(submission, k, w);
        submission_fingerprints[submission_id] = fingerprints;
    }

    // calculate similarity 
    unordered_set<string> processed_pairs; // need to keep track of processed pairs

    for (auto first_pair = submission_fingerprints.begin(); first_pair != submission_fingerprints.end(); ++first_pair) {
        
        const string& id_one = first_pair -> first;
        const vector<size_t>& finerprints_one = first_pair  ->  second;

        for (auto second_pair = next(first_pair); second_pair != submission_fingerprints.end(); ++second_pair) {
            const string& id_two = second_pair -> first;

            // check if pair is processed or IDs are the same, only need to print once
            if (processed_pairs.count(id_one + id_two) || processed_pairs.count(id_two + id_one) || id_one == id_two){
                continue;
            }
               
            const vector<size_t>& finerprints_two = second_pair -> second;
            double similarity = calculate_similarity(unordered_set<size_t>(finerprints_one.begin(), finerprints_one.end()), unordered_set<size_t>(finerprints_two.begin(), finerprints_two.end()));
            cout << "Similarity between " << id_one << " and " << id_two << ": " << similarity * 100 << setprecision(4) << "%" << endl; // Set precision to two decimal places
            processed_pairs.insert(id_one + id_two); // Mark the pair as processed
        }
    }

    return 0;
}