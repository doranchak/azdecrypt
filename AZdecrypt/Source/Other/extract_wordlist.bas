declare function crc_32(buf as byte ptr,buflen as ulong)as ulong
declare function rdc(byval n as double,byval dpa as integer)as string
declare sub quicksort_short(byval low as integer,byval high as integer)

redim shared as uinteger wlfrq(2^32) '4 GB
redim shared as ulong wlptr(2^32) '4 GB
redim shared as ubyte wl(1000000000,50) '51 GB

dim as integer g,h,i,j,k,e,m
dim as uinteger lines,bytes,words
dim as string s,o
dim as double t=timer

screenres 640,480,32

open "h:\uniq2.txt" for binary as #1

do
	
	line input #1,s
	
	s+=" "
	lines+=1
	bytes+=len(s)
	
	j=0
	for i=1 to len(s)-1 'first char is never a space, start at 1
		if s[i]=32 then
			if i-j<51 then 'word length filter
				k=crc_32(@s[j],i-j)
				if wlfrq(k)=0 then
					words+=1
					wlptr(words)=k 'word number
					wl(words,0)=i-j 'word length
					g=0
					for h=j to i-1
						g+=1
						wl(words,g)=s[h]-97
						'print chr(s[h]);
					next h
					'print
				end if
				wlfrq(k)+=1
				j=i+1
			end if
		end if
	next i
	
	if timer-t>1 then
		t=timer
		screenlock
		cls
		print "Gigabytes: "+rdc(bytes/2^30,5)
		screenunlock
	end if
	
	'if bytes>1000000000 then exit do
	
loop until eof(1)
close #1

print "sorting wordlist by frequency..."
quicksort_short(1,words)

open "h:\wordlist.txt" for output as #1
for i=1 to words 'words
	k=words-(i-1)
	o=""
	for j=1 to wl(k,0)
		o+=chr(wl(k,j)+97)
	next j
	o+=" "+str(wlfrq(wlptr(k)))
	print #1,o
next i
close #1
print "words: "+str(words)
print "done: h:\wordlist.txt created"

beep
sleep

close #1

function crc_32(buf as byte ptr,buflen as ulong) as ulong
	
	'adapted from rosetta code by Jarlve
	static as ulong table(255),have_table
	dim as ulong crc,i
	if have_table=0 then
		dim as ulong j,k
		for i=0 to 255
			k=i
			for j=0 to 7
				if (k and 1) then
					k shr=1
					k xor=&hedb88320
				else
					k shr=1
				end if
				table(i)=k
			next
		next
		have_table=1
	end if
	crc=not crc 
	for i=0 to buflen-1
		crc=(crc\256)xor table((crc and &hff)xor buf[i])
	next
	return not crc
	
end function

function rdc(byval n as double,byval dpa as integer)as string
	
	dim as string s=str(n)
	dim as integer i=instr(s,".")
	if instr(s,"#INF")>0 then return "0"
	if instr(s,"#IND")>0 then return "0"
	if i=0 then 
		return s
	else
		return left(s,i+dpa)
	end if
	
end function

sub quicksort_short(byval low as integer,byval high as integer)
	
	dim as integer i,j,k,pivot,m,h
	pivot=wlfrq(wlptr((low+high)/2))
	i=low
	j=high
	do while i<=j
		do while i<high and wlfrq(wlptr(i))<pivot
			i+=1
		loop
		do while j>low and pivot<wlfrq(wlptr(j))
			j-=1
		loop
		if i<=j then 
			m=0
			if wl(i,0)>m then m=wl(i,0)
			if wl(j,0)>m then m=wl(j,0)
			for h=0 to m
				swap wl(i,h),wl(j,h)
			next h
			swap wlptr(i),wlptr(j)
			i+=1
			j-=1
		end if
	loop
	if low<j then quicksort_short(low,j)
	if i<high then quicksort_short(i,high)

end sub