select case ngram_system
	case 1 'default
		select case ngram_size
			case 2
				for i=1 to al
					new_ngram_score+=g2(sol(i),sol(i+1))
				next i
			case 3
				for i=1 to al
					new_ngram_score+=g3(sol(i),sol(i+1),sol(i+2))
				next i
			case 4
				for i=1 to al
					new_ngram_score+=g4(sol(i),sol(i+1),sol(i+2),sol(i+3))
				next i
			case 5
				for i=1 to al
					new_ngram_score+=g5(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4))
				next i
			case 6
				for i=1 to al
					new_ngram_score+=g6(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4),sol(i+5))
				next i
			case 7
				for i=1 to al
					new_ngram_score+=g7(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4),sol(i+5),sol(i+6))
				next i
			
		end select
	case 2 'bh
		select case ngram_size
			case 6
				for i=1 to al
					new_ngram_score+=bh6(h3(sol(i),sol(i+1),sol(i+2)),h3(sol(i+3),sol(i+4),sol(i+5)))
				next i
			case 8
				for i=1 to al
					new_ngram_score+=bh8(h4(sol(i),sol(i+1),sol(i+2),sol(i+3)),h4(sol(i+4),sol(i+5),sol(i+6),sol(i+7)))
				next i
			case 10
				for i=1 to al
					new_ngram_score+=bh10(h5(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4)),h5(sol(i+5),sol(i+6),sol(i+7),sol(i+8),sol(i+9)))
				next i
		end select
	case 3 'nn
		for i=1 to al
			j=i
			#include "solver_ngram_nn1_4.bi"
			new_ngram_score+=i64
		next i
end select