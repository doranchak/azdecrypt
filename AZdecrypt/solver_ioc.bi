erase frq2
for i=1 to l
	frq2(alpharev(thread(tn).sol(i)))+=1
next i
ioc_int=0
for i=0 to abc_sizem1
	ioc_int+=ioctable(frq2(i))
next i
thread(tn).ioc=ioc_int/ll