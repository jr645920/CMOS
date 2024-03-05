%{
//*****************************************************************************************
// File: inforScan.l
// Purpose: To scan through a file and identify potential P numbers and SSNs.
// Obfuscated numbers (XXX-##-1234) are also detected, as those could be pieced together
// into more complete data sets
//
// build instructions
// flex infoScanner.l
// g++ -o infoScanner lex.yy.x
// ./infoScanner < data_file.txt
// ****************************************************************************************

//declarations

#include <iostream>
#include <fstream>

using namespace std;

//LOOPS
#define TKFLOOP 1
#define TKWLOOP 2
#define TKDLOOP 3
//CONDITIONAL
#define TKIF 4
#define TKELSE 5
//FILE ACTIONS
#define TKPRINT 6
#define TKSCAN 7
//MAIN, INCLUDE, RETURN
#define TKRETURN 8
#define TKINCLUDE 9
#define TKMAIN 10
//TYPES
#define TKTYPENUM 11 //int, double, float
#define TKTYPECHAR 12
#define TKTYPESTRING 13
#define TKTYPEBOOL 14
#define TKTYPEVOID 15
//VALUES
#define TKPOINTER 16
#define TKADDRESS 17
#define TKWORD 18
#define TKNUM 19
#define TKSTRING 20
//OPERATORS
#define TKADD 21
#define TKSUB 22
#define TKMUL 23
#define TKDIV 24
#define TKMOD 25
#define TKEQU 26
#define TKSEQU 27
#define TKAND 28
#define TKOR 29
#define TKBOOLEQU 30
#define TKBOOLNEQU 31
//OTHER
#define TKUNMATCHED 0


%}


D[0-9]
LD[a-zA-Z0-9]
type[(void)(int)(double)(float)]

%%


\/\*[^\*\/]*\*\/                  {} 

\/\/+[^\n]*\n                 {}

[ \t\n\f]	{} /* ignore whitespace */

[;\(\)\{\}] {} /* ignore semicolon, parenthesis, and brackets*/

for	{return TKFLOOP;}/* any for loop */

while {return TKWLOOP;} /* any while loop */

do {return TKDLOOP;} /* any do loop */

if {return TKIF;}

else {return TKELSE;}

printf {return TKPRINT;}

scanf {return TKSCAN;}

return {return TKRETURN;}

#include {return TKINCLUDE;}

main {return TKMAIN;}

({type}\*{LD}*)|({type}\*{LD}*) {return TKPOINTER;}

&{LD}* {return TKADDRESS;}

\"[^"]*\" {return TKSTRING;}

int|float|double {return TKTYPENUM;}

char {return TKTYPECHAR;}

string {return TKTYPESTRING;}

bool {return TKTYPEBOOL;}

void {return TKTYPEVOID;}

{D}* {return TKNUM;}

{LD}* {return TKWORD;}

\+|\+= {return TKADD;}

-|-= {return TKSUB;}

\*|\*= {return TKMUL;}

\/|\/= {return TKDIV;}

=== {return TKSEQU;}

== {return TKBOOLEQU;}

!= {return TKBOOLNEQU;}

= {return TKEQU;}

&& {return TKAND;}

\|\| {return TKOR;}

.	{return TKUNMATCHED;}



%%

int yywrap(){
	return true;
}

int main(){
	int token = 0;
	ofstream fout;

	//open the file
	fout.open("scanner_out.txt");
	if(fout.is_open()){
		token = yylex();
		fout << token;
		while(token){
			//output to file with a " " before it
			fout << " " << token;
			token = yylex();
		}
	}
	else{
		cout << "failed to open scanner out file" << endl;
	}
}