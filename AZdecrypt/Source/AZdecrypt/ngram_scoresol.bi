ngram_score=0
select case ngram_system
	case 1 'default
		for i=1 to l-(ngram_size-1)
			select case ngram_size
				case 2:i64=ngp(g2(sol(i),sol(i+1)))
				case 3:i64=ngp(g3(sol(i),sol(i+1),sol(i+2)))
				case 4:i64=ngp(g4(sol(i),sol(i+1),sol(i+2),sol(i+3)))
				case 5:i64=ngp(g5(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4)))
				case 6:i64=ngp(g6(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4),sol(i+5)))
				case 7:i64=ngp(g7(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4),sol(i+5),sol(i+6)))
			end select
			ngram_score+=i64
			if i64>hi64 then hi64=i64
		next i
	case 2 'bh
		for i=1 to l-(ngram_size-1)
			select case ngram_size
				case 6:i64=ngp(bh6(h3(sol(i),sol(i+1),sol(i+2)),h3(sol(i+3),sol(i+4),sol(i+5))))
				case 8:i64=ngp(bh8(h4(sol(i),sol(i+1),sol(i+2),sol(i+3)),h4(sol(i+4),sol(i+5),sol(i+6),sol(i+7))))
				case 10:i64=ngp(bh10(h5(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4)),h5(sol(i+5),sol(i+6),sol(i+7),sol(i+8),sol(i+9))))
				case 12:i64=ngp(bh12(h6(sol(i),sol(i+1),sol(i+2),sol(i+3),sol(i+4),sol(i+5)),h6(sol(i+6),sol(i+7),sol(i+8),sol(i+9),sol(i+10),sol(i+11))))
			end select
			ngram_score+=i64
			if i64>hi64 then hi64=i64
		next i
	case 3 'nn
		for j=1 to l-(ngram_size-1)
			#include "solver_ngram_nn1_4.bi"
			ngram_score+=i64
			if i64>hi64 then hi64=i64
		next j
end select