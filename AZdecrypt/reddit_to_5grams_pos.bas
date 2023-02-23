screenres 800,600,32

dim as integer h,i,j,k
dim as integer items,bytes,rawioc,total_items
dim as string a,num
dim as integer l1,x1,x2,x3,x4,x5,x6,x7
dim as integer maxp=45 'max word length? (best to set lower to fit memory)

dim as integer m=25
dim as integer ngram_size=5
dim shared as ubyte tx1(1000000)
dim shared as ubyte tx2(1000000)
dim as double t1,t2

redim shared as uinteger g5(25,25,25,25,25)
redim shared as uinteger g5s(26,26,26,26,26)
redim shared as uinteger g5p(25,25,25,25,25,maxp) '24 GB
redim shared as ushort ngram_list1(1000000000,ngram_size+1)

dim as short cv(255),rcv(255)
for i=97 to 122
	cv(i)=i-97
	rcv(i-97)=i-32
next i
cv(32)=26
rcv(26)=32

declare function rdc(byval n as double,byval dpa as integer)as string
declare sub quicksort_ngrams1(byval low as integer,byval high as integer,byval ngs as integer)

bytes=0
open "h:\uniq2.txt" for binary as #1

t1=timer
t2=timer

do

	line input #1,a
	
	j=1
	k=0
	for i=0 to len(a)-1
		if a[i]=32 then
			j=1
		else
			k+=1
			tx1(k)=a[i]-97 'letter
			tx2(k)=j 'position
			j+=1
			if j>maxp then j=maxp
		end if
	next i
	
	for i=0 to len(a)-ngram_size
		g5s(cv(a[i]),cv(a[i+1]),cv(a[i+2]),cv(a[i+3]),cv(a[i+4]))+=1
	next i
	
	for i=1 to k-(ngram_size-1)
		g5(tx1(i),tx1(i+1),tx1(i+2),tx1(i+3),tx1(i+4))+=1
		g5p(tx1(i),tx1(i+1),tx1(i+2),tx1(i+3),tx1(i+4),tx2(i))+=1
	next i
	
	bytes+=len(a)
	'if bytes>1000000000 then exit do
	
	if timer-t1>0.5 then
		t1=timer
		screenlock
		cls
		print "GB: "+rdc(bytes/1000000000,5)
		print "GB per day: "+rdc((bytes/11574)/(timer-t2),5)
		screenunlock
	end if

loop until eof(1)
close #1

for x1=0 to 25
	for x2=0 to 25
		for x3=0 to 25
			for x4=0 to 25
				for x5=0 to 25
					if g5(x1,x2,x3,x4,x5)>1 then
						items+=1
						ngram_list1(items,0)=log(g5(x1,x2,x3,x4,x5))*10
						ngram_list1(items,1)=x1
						ngram_list1(items,2)=x2
						ngram_list1(items,3)=x3
						ngram_list1(items,4)=x4
						ngram_list1(items,5)=x5
						k=0
						j=0
						for i=0 to maxp-1
							if g5p(x1,x2,x3,x4,x5,maxp-i)>k then
								k=g5p(x1,x2,x3,x4,x5,maxp-i)
								j=maxp-i
							end if
						next i
						ngram_list1(items,6)=j
					end if
					g5(x1,x2,x3,x4,x5)=0
				next x5
			next x4
		next x3
	next x2
next x1
print "items: "+str(items)
quicksort_ngrams1(1,items,ngram_size+1)

open "c:\azdecrypt\n-grams\test\"+str(ngram_size)+"-grams_letters.txt" for output as #1
k=0
for i=1 to items
	j=items-(i-1)
	if ngram_list1(j,0)>0 then
		a=""
		k+=1
		for h=1 to ngram_size
			a+=chr(ngram_list1(j,h)+65)
		next h
		num=str(ngram_list1(j,0))
		a+=space(3-len(num))+num
		print #1,a;
		if k=10000 then 
			print #1,""
			k=0
		end if
	end if
next i
close #1

open "c:\azdecrypt\n-grams\test\"+str(ngram_size)+"-grams_positions.txt" for output as #1
k=0
for i=1 to items
	j=items-(i-1)
	if ngram_list1(j,0)>0 then
		a=""
		k+=1
		for h=1 to ngram_size
			a+=chr(ngram_list1(j,h)+65)
		next h
		num=str(ngram_list1(j,ngram_size+1))
		a+=space(3-len(num))+num
		print #1,a;
		if k=10000 then 
			print #1,""
			k=0
		end if
	end if
next i
close #1

items=0
for x1=0 to 26
	for x2=0 to 26
		for x3=0 to 26
			for x4=0 to 26
				for x5=0 to 26
					if g5s(x1,x2,x3,x4,x5)>1 then
						items+=1
						ngram_list1(items,0)=log(g5s(x1,x2,x3,x4,x5))*10
						ngram_list1(items,1)=x1
						ngram_list1(items,2)=x2
						ngram_list1(items,3)=x3
						ngram_list1(items,4)=x4
						ngram_list1(items,5)=x5
					end if
					g5s(x1,x2,x3,x4,x5)=0
				next x5
			next x4
		next x3
	next x2
next x1
print "items: "+str(items)
quicksort_ngrams1(1,items,ngram_size+1)

open "c:\azdecrypt\n-grams\test\"+str(ngram_size)+"-grams_spaces.txt" for output as #1
k=0
for i=1 to items
	j=items-(i-1)
	if ngram_list1(j,0)>0 then
		a=""
		k+=1
		for h=1 to ngram_size
			a+=chr(rcv(ngram_list1(j,h)))
		next h
		num=str(ngram_list1(j,0))
		a+=space(3-len(num))+num
		print #1,a;
		if k=10000 then 
			print #1,""
			k=0
		end if
	end if
next i
close #1

print "Done."

beep
sleep

sub quicksort_ngrams1(byval low as integer,byval high as integer,byval ngs as integer)
	
	dim as integer i,j,k,pivot
	pivot=ngram_list1((low+high)/2,0)
	i=low
	j=high
	do while i<=j
		do while i<high and ngram_list1(i,0)<pivot
			i+=1
		loop
		do while j>low and pivot<ngram_list1(j,0)
			j-=1
		loop
		if i<=j then
			for k=0 to ngs
				swap ngram_list1(i,k),ngram_list1(j,k)
			next k
			i+=1
			j-=1
		end if
	loop
	if low<j then quicksort_ngrams1(low,j,ngs)
	if i<high then quicksort_ngrams1(i,high,ngs)
	
end sub

function rdc(byval n as double,byval dpa as integer)as string

	dim as string s=str(n)
	dim as integer i,ins=instr(s,".")
	dim as string cz0="."
	dim as string cz9="."
	if instr(s,"#INF")>0 then return "0"
	if instr(s,"#IND")>0 then return "0"
	for i=1 to dpa
		cz0+="0"
		cz9+="9"
	next i
	if ins=0 then
		return s
	end if
	if len(s)-ins<dpa then
		return s
	else
		if instr(s,cz0)>0 then return str(int(n))
		if instr(s,cz9)>0 then return str(int(n)+1)
		return left(s,len(s)-((len(s)-ins)-dpa))
	end if

end function