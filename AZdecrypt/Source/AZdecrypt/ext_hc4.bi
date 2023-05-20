select case ext_hc
	case 2,4 'columnar rearrangement/transposition	
		if solvesub_pndepth>1 then
			best_score=bbest
			thread(tn).score=bbest
			thread(tn).ioc=bioc
			for i=1 to l
				nba(i)=bnba(i)
				thread(tn).sol(i)=extcip(tn,0,i)
			next i
		end if
	case 5 'nulls and skips	
		if solvesub_pndepth>1 then
			l=bl
			best_score=bbest
			thread(tn).score=bbest
			thread(tn).ioc=bioc
			for i=1 to l
				nba(i)=bnba(i)
				thread(tn).sol(i)=extcip(tn,0,i)
			next i
		end if
		dim as short nulls(solvesub_pnkl)
		dim as short skips(solvesub_pnkl)
		nulls(0)=0
		skips(0)=0
		thread(tn).itemname="Period("+str(solvesub_pnperiod)+") "
		thread(tn).itemname2=""
		for i=1 to solvesub_pnkl
			'thread(tn).gkey(i,0)=extkey(tn,b,i,0) 'b-1 ???
			'thread(tn).gkey(i,1)=extkey(tn,b,i,1) 'b-1 ???
			if thread(tn).gkey(i,1)=0 then
				nulls(0)+=1
				nulls(nulls(0))=thread(tn).gkey(i,0)
			else
				skips(0)+=1
				skips(skips(0))=thread(tn).gkey(i,0)
			end if
		next i					
		if nulls(0)>0 then
			quicksort_short(nulls(),1,nulls(0))
			if nulls(0)=1 then
				thread(tn).itemname+="Null("
				thread(tn).itemname2+="Null("
			else
				thread(tn).itemname+="Nulls("
				thread(tn).itemname2+="Nulls("
			end if
			for i=1 to nulls(0)
				thread(tn).itemname+=str(nulls(i))
				if i<>nulls(0) then thread(tn).itemname+=","
				for j=1 to 4-len(str(nulls(i)))
					thread(tn).itemname2+="0"
				next j
				thread(tn).itemname2+=str(nulls(i))
				if i<>nulls(0) then thread(tn).itemname2+=","
			next i
			if skips(0)>0 then
				thread(tn).itemname+=") "
				thread(tn).itemname2+=") "
			else
				thread(tn).itemname+=")"
				thread(tn).itemname2+=")"
			end if
		end if
		if skips(0)>0 then
			quicksort_short(skips(),1,skips(0))
			if skips(0)=1 then
				thread(tn).itemname+="Skip("
				thread(tn).itemname2+="Skip("
			else
				thread(tn).itemname+="Skips("
				thread(tn).itemname2+="Skips("
			end if
			for i=1 to skips(0)
				thread(tn).itemname+=str(skips(i))
				if i<>skips(0) then thread(tn).itemname+=","
				for j=1 to 4-len(str(skips(i)))
					thread(tn).itemname2+="0"
				next j
				thread(tn).itemname2+=str(skips(i))
				if i<>skips(0) then thread(tn).itemname2+=","
			next i
			thread(tn).itemname+=")"
			thread(tn).itemname2+=")"
		end if
		'-------------------------------------------
		'for i=1 to solvesub_pnkl 'heatmap
		'	if thread(tn).gkey(i,1)=0 then 'nulls
		'		thread(tn).graph(thread(tn).gkey(i,0))+=1
		'	end if
		'next i
end select