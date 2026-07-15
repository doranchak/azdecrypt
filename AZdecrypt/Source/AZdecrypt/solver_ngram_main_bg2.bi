select case ngram_system
	case 1 'default
		select case ngram_size
			case 2
				for i=1 to map2(curr_symbol,lp,0)
					j=map2(curr_symbol,lp,i)
					new_ngram_score+=g2(sol(j),sol(j+1))-ngrams(j)
				next i
			case 3
				for i=1 to map2(curr_symbol,lp,0)
					j=map2(curr_symbol,lp,i)
					new_ngram_score+=g3(sol(j),sol(j+1),sol(j+2))-ngrams(j)
				next i
			case 4
				for i=1 to map2(curr_symbol,lp,0)
					j=map2(curr_symbol,lp,i)
					new_ngram_score+=g4(sol(j),sol(j+1),sol(j+2),sol(j+3))-ngrams(j)
				next i
			case 5
				for i=1 to map2(curr_symbol,lp,0)
					j=map2(curr_symbol,lp,i)
					new_ngram_score+=g5(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4))-ngrams(j)
				next i
			case 6
				for i=1 to map2(curr_symbol,lp,0)
					j=map2(curr_symbol,lp,i)
					new_ngram_score+=g6(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5))-ngrams(j)
				next i
			case 7
				for i=1 to map2(curr_symbol,lp,0)
					j=map2(curr_symbol,lp,i)
					new_ngram_score+=g7(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6))-ngrams(j)
				next i
		end select
	case 2 'bh
		select case ngram_size
			case 6
				for i=1 to map2(curr_symbol,lp,0)
					z=0
					j=map2(curr_symbol,lp,i)
					z1=h3(sol(j),sol(j+1),sol(j+2))
					if z1<>0 then
						z2=h3(sol(j+3),sol(j+4),sol(j+5))
						if z2<>0 then z=bh6(z1,z2)
					end if
					new_ngram_score+=z-ngrams(j)
				next i
			case 8
				for i=1 to map2(curr_symbol,lp,0)
					z=0
					j=map2(curr_symbol,lp,i)
					z1=h4(sol(j),sol(j+1),sol(j+2),sol(j+3))
					if z1<>0 then
						z2=h4(sol(j+4),sol(j+5),sol(j+6),sol(j+7))
						if z2<>0 then z=bh8(z1,z2)
					end if
					new_ngram_score+=z-ngrams(j)
				next i
			case 10
				for i=1 to map2(curr_symbol,lp,0)
					z=0
					j=map2(curr_symbol,lp,i)
					z1=h5(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4))
					if z1<>0 then
						z2=h5(sol(j+5),sol(j+6),sol(j+7),sol(j+8),sol(j+9))
						if z2<>0 then z=bh10(z1,z2)
					end if
					new_ngram_score+=z-ngrams(j)
				next i
		end select
	case 3 'nn
		for i=1 to map2(curr_symbol,lp,0)
			j=map2(curr_symbol,lp,i)
			#include "solver_ngram_nn1_4.bi"
			new_ngram_score+=i64-ngrams(j)
		next i
end select