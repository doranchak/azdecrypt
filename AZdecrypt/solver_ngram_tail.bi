select case ngram_size
	case 2
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			ngrams(j)=g2(sol(j),sol(j+1))
		next i
	case 3
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			ngrams(j)=g3(sol(j),sol(j+1),sol(j+2))
		next i
	case 4
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			ngrams(j)=g4(sol(j),sol(j+1),sol(j+2),sol(j+3))
		next i
	case 5
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			ngrams(j)=g5(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4))
		next i
	case 6
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			ngrams(j)=g6(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5))
		next i
	case 7
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			ngrams(j)=g7(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6))
		next i
	case 8
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			ngrams(j)=bh8(bh4(sol(j),sol(j+1),sol(j+2),sol(j+3)),bh4(sol(j+4),sol(j+5),sol(j+6),sol(j+7)))
		next i
	case 10
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			ngrams(j)=bh10(bh5(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4)),bh5(sol(j+5),sol(j+6),sol(j+7),sol(j+8),sol(j+9)))
		next i
end select
