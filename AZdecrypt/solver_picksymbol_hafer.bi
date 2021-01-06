if mi(rchange)=s then mi(rchange)=1 else mi(rchange)+=1
curr_symbol=maps(rchange,mi(rchange))
mj(rchange)+=1
state=48271*state and 2147483647
maps2(rchange,mj(rchange))=1+s*state shr 31
if mj(rchange)=s then
	mj(rchange)=0
	for j=1 to s-1 step 2
		swap maps(rchange,maps2(rchange,j)),maps(rchange,maps2(rchange,j+1))
	next j
end if