if use_cribs=0 then
	
	if mi=s then mi=1 else mi+=1
	curr_symbol=maps(mi)
	mj+=1
	rng(maps2(mj),1+s,state)
	'state=48271*state and 2147483647
	'maps2(mj)=1+s*state shr 31
	if mj=s then
		mj=0
		for i=1 to s-1 step 2
			swap maps(maps2(i)),maps(maps2(i+1))
		next i
	end if
	
else
	
	if use_cribs<2 then '2 for "row bound fragments" solver
	
		do
			
			if mi=s then mi=1 else mi+=1
			curr_symbol=maps(mi)
		   mj+=1
		   rng(maps2(mj),1+s,state)
		   'state=48271*state and 2147483647
		   'maps2(mj)=1+s*state shr 31
		   if mj=s then
		   	mj=0
		   	for i=1 to s-1 step 2
					swap maps(maps2(i)),maps(maps2(i+1))
		   	next i
		   end if
			
		loop until cribkey(curr_symbol)=0 or stoptask=1
		
	else
		
		curr_symbol=1
		
	end if
	
end if