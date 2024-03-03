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

using namespace std;

//LOOPS
#define TKFLOOP 001
#define TKWLOOP 002
#define TKDLOOP 003
//CONDITIONAL
#define TKIF 004
#define TKELSE 005
//FILE ACTIONS
#define TKPRINT 006
#define TKSCAN 007
//MAIN, INCLUDE, RETURN
#define TKRETURN 008
#define TKINCLUDE 009
#define TKMAIN 010
//TYPES
#define TKTYPENUM 011 //int, double, float
#define TKTYPECHAR 012
#define TKTYPESTRING 013
#define TKTYPEBOOL 014
#define TKTYPEVOID 015
//VALUES
#define TKPOINTER 016
#define TKADDRESS 017
#define TKWORD 018
#define TKNUM 019
#define TKSTRING 020
//OPERATORS
#define TKADD 021
#define TKSUB 022
#define TKMUL 023
#define TKDIV 024
#define TKMOD 025
#define TKEQU 026
#define TKNSEQU 027
#define TKAND 028
#define TKOR 029
#define TKBOOLEQU 030
#define TKBOOLNEQU 031
//OTHER
#define TKUNMATCHED 255

int linecount = 1;

void Addline(char c) {
	if(c=='\n')
	{
		linecount++;
	}
}

int line_num(){
	return linecount;
}




%}

L[a-zA-Z]
D[0-9]
LD[a-zA-Z0-9]
type[(void)(int)(double)(float)]

%%


\/\*[^\*\/]*\*\/                  {} /* comments start with /* and end in *\             */

\/\/+[^\n]*\n                 {} /* comments start with // or more and end in newline            */

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

({type} \*{LD}*)|({type}\* {LD}*) {return TKPOINTER;}

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

!= {return TKBOOKNEQU;}

= {return TKEQU;}

&& {return TKAND;}

\|\| {return TKOR;}




.							{ 	//unmatched
								return TKUNMATCHED;
							}



%%

int yywrap(){
	return true;
}

int main() {
	int token = 0;
	token = yylex();
	while(token){
		switch (token) {
			case TKPNUM:
				cout << "Found a P number on line " << line_num() << " : " << yytext << endl;
				break;
			case TKSSNUM:
				cout << "Found a SS number on line " << line_num() << " : " << yytext << endl;
				break;
			case TKOBPNUM:
				cout << "Found an obfuscated P number on line " << line_num() << " : " << yytext << endl;
				break;
			case TKOBSSNUM:
				cout << "Found an obfuscated SS number on line " << line_num() << " : " << yytext << endl;
				break;
			}
	
		token = yylex();
	}
}	