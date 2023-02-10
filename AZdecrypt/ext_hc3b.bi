select case ext_hc
	case 1,2,4 'columnar rearrangement/transposition 'added 1 <-------------------
		if best_score>bbest then
			bbest=best_score
			bioc=ioc_int/ll
			'thread(tn).itemname="Column order("
			for h=0 to 1
				for i=1 to solvesub_ctcolumns
					thread(tn).gkey(i,h)=extkey(tn,b,i,h)
					'thread(tn).gkey(i,0)=ukey(i)
					'thread(tn).itemname+=str(thread(tn).gkey(i,0))
					'if i<>solvesub_ctcolumns then thread(tn).itemname+=","
				next i
			next h
			'thread(tn).itemname+=")"
			'for i=1 to l
			'	bnba(i)=nba(i)
			'	extcip(tn,0,i)=alphabet(sol(i))
			'next i
		end if
	case 5 'nulls and skips
		if best_score>bbest then
			bl=l
			bbest=best_score
			bioc=ioc_int/ll
			for i=1 to solvesub_pnkl 'save b value instead?
				thread(tn).gkey(i,0)=extkey(tn,b,i,0)
				thread(tn).gkey(i,1)=extkey(tn,b,i,1)
			next i					
			for i=1 to l
				bnba(i)=nba(i)
				extcip(tn,0,i)=alphabet(sol(i))
			next i	
		end if
end select