select case ngram_size
	case 8
		for i=1 to al
			ngrams(i)=bh8(h4(sol(i),sol(i+1),sol(i+2),sol(i+3)),h4(sol(i+4),sol(i+5),sol(i+6),sol(i+7)))
			new_ngram_score+=ngrams(i)
		next i
	case 10
		for i=1 to al
			ngrams(i)=bh10(h5(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4)),h5(sol(i+5),sol(i+6),sol(i+7),sol(i+8),sol(i+9)))
			new_ngram_score+=ngrams(i)
		next i
end select