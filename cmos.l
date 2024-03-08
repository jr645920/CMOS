%{
//*****************************************************************************************
// Filename: cmos.l
// Authors: Hunter Smith and Johnathan Reilly
// Brief: A LEX program that tokenizes student sumbission file to be checked for plagarism
// ****************************************************************************************

//declarations

#include <iostream>
#include <fstream>

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
#define TKRETURN 010
#define TKINCLUDE 011
#define TKMAIN 012
//TYPES
#define TKTYPENUM 013 //int, double, float
#define TKTYPECHAR 014
#define TKTYPESTRING 015
#define TKTYPEBOOL 016
#define TKTYPEVOID 017
//VALUES
#define TKPOINTER 020
#define TKADDRESS 021
#define TKWORD 022
#define TKNUM 023
#define TKSTRING 024
//OPERATORS
#define TKADD 025
#define TKSUB 026
#define TKMUL 027
#define TKDIV 030
#define TKMOD 031
#define TKEQU 032
#define TKSEQU 033
#define TKAND 034
#define TKOR 035
#define TKBOOLEQU 036
#define TKBOOLNEQU 037
//OTHER
#define TKUNMATCHED 255


%}


D[0-9]
LD[a-zA-Z0-9]
type[(void)(int)(double)(float)]

%%


\/\*[^\*\/]*\*\/                  {} 

\/\/+[^\n]*\n                 {}

[ \t\n\f\r]	{} /* ignore whitespace */

[;\(\)\{\}\.\,\<\>\%\'\$\_\^\[\]\:\\\?\	] {} /* ignore semicolon, parenthesis, and brackets*/

[\x08] /* why was this in a file? */

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

{D}+ {return TKNUM;}

{LD}+ {return TKWORD;}

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