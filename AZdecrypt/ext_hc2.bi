select case ext_hc
	case 1,3 'columnar rearrangement/transposition bigram beam
		for i=1 to l
			'thread(tn).cip(i)=extcip(tn,b,i)
			if local_pcmode=1 then thread(tn).key(i)=extpcm(tn,1,i) 'extpcm = pc-cycles transposition matrix
		next i
	case 2,4 'columnar rearrangement/transposition azd beam
		for i=1 to l
			thread(tn).cip(i)=extcip(tn,b,i)
			if local_pcmode=1 then thread(tn).key(i)=extpcm(tn,b,i) 'extpcm = pc-cycles transposition matrix
		next i
	case 5 'nulls and skips azd beam
		l=extinf(tn,b,0)
		s=extinf(tn,b,1)
		thread(tn).l=l
		thread(tn).s=s
		ll=l*(l-1)
		al=l-(ngram_size-1)
		for i=1 to l
			thread(tn).cip(i)=extcip(tn,b,i)
			if local_pcmode=1 then thread(tn).key(i)=extpcm(tn,b,i) 'extpcm = pc-cycles transposition matrix
		next i
end select