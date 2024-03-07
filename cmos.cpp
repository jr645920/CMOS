#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>
#include <string>
#include <algorithm>
#include <iterator>
#include <math.h>
#include <map>

using namespace std;

vector<vector<string>> read_in_tokens(){ //read in tokens into one long string 

    fstream tokens_file;
    tokens_file.open("tokens.txt");

    if(!tokens_file.is_open()){ //error checking
        cout << "ERROR OPENING TOKENS FILE" << endl;
        exit(0);
    }

    
    string filename;
    string line;
    
    string token;
    vector<vector<string>> returnstring;
    vector<string> tokens;
    string all_tokens;

    
    while(!tokens_file.eof()){
        all_tokens = "";
        getline(tokens_file, line);
        stringstream ss(line);
        ss >> filename;

        while(ss >> token){
            all_tokens += token;
        }

        tokens.push_back(all_tokens);
        returnstring.push_back(tokens);
        cout << all_tokens << endl;
    }

    return returnstring;
}



int main(){
    vector<vector<string>> tmp;
    tmp = read_in_tokens();
    

}