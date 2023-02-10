select case ngram_size
	case 2
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			new_ngram_score+=g2(sol(j),sol(j+1))-ngrams(j)
		next i
	case 3
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			new_ngram_score+=g3(sol(j),sol(j+1),sol(j+2))-ngrams(j)
		next i
	case 4
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			new_ngram_score+=g4(sol(j),sol(j+1),sol(j+2),sol(j+3))-ngrams(j)
		next i
	case 5
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			new_ngram_score+=g5(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4))-ngrams(j)
		next i
	case 6
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			new_ngram_score+=g6(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5))-ngrams(j)
		next i
	case 7
		for i=1 to map2(curr_symbol,0)
			j=map2(curr_symbol,i)
			new_ngram_score+=g7(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6))-ngrams(j)
		next i
	case 8
		for i=1 to map2(curr_symbol,0)
			z=0
			j=map2(curr_symbol,i)
			z1=bh4(sol(j),sol(j+1),sol(j+2),sol(j+3))
			if z1<>0 then
				z2=bh4(sol(j+4),sol(j+5),sol(j+6),sol(j+7))
				if z2<>0 then z=bh8(z1,z2)
			end if
			new_ngram_score+=z-ngrams(j)
		next i
	case 10
		for i=1 to map2(curr_symbol,0)
			z=0
			j=map2(curr_symbol,i)
			z1=bh5(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4))
			if z1<>0 then
				z2=bh5(sol(j+5),sol(j+6),sol(j+7),sol(j+8),sol(j+9))
				if z2<>0 then z=bh10(z1,z2)
			end if
			new_ngram_score+=z-ngrams(j)
		next i
end select
