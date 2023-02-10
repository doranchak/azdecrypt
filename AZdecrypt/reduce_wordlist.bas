screenres 640,480,32

dim as integer g,h,i,j,k,e,m
dim as uinteger lines
dim as string s,o

open "h:\wordlist.txt" for binary as #1
open "h:\wordlist2.txt" for output as #2

do
	lines+=1
	line input #1,s
	print #2,s
	if lines=65536 then exit do
loop until eof(1)

close #1
close #2

print "done"
sleep
beep