select case ngram_size
	case 2
		for i=1 to al
			ngrams(i)=g2(sol(i),sol(i+1))
			new_ngram_score+=ngrams(i)
		next i
	case 3
		for i=1 to al
			ngrams(i)=g3(sol(i),sol(i+1),sol(i+2))
			new_ngram_score+=ngrams(i)
		next i
	case 4
		for i=1 to al
			ngrams(i)=g4(sol(i),sol(i+1),sol(i+2),sol(i+3))
			new_ngram_score+=ngrams(i)
		next i
	case 5
		for i=1 to al
			ngrams(i)=g5(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4))
			new_ngram_score+=ngrams(i)
		next i
	case 6
		for i=1 to al
			ngrams(i)=g6(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4),sol(i+5))
			new_ngram_score+=ngrams(i)
		next i
	case 7
		for i=1 to al
			ngrams(i)=g7(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4),sol(i+5),sol(i+6))
			new_ngram_score+=ngrams(i)
		next i
	case 8
		for i=1 to al
			ngrams(i)=bh8(bh4(sol(i),sol(i+1),sol(i+2),sol(i+3)),bh4(sol(i+4),sol(i+5),sol(i+6),sol(i+7)))
			new_ngram_score+=ngrams(i)
		next i
	case 10
		for i=1 to al
			ngrams(i)=bh10(bh5(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4)),bh5(sol(i+5),sol(i+6),sol(i+7),sol(i+8),sol(i+9)))
			new_ngram_score+=ngrams(i)
		next i
end select