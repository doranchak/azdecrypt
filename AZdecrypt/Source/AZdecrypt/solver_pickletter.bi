'try to replace select case with one line and test if faster

bls=0
if d>mc then
	#include "solver_randomnewletter.bi"
else
	rng(k,1+map2(curr_symbol,0),state)
	'state=48271*state and 2147483647
	'k=1+map2(curr_symbol,0)*state shr 31
	j=map2(curr_symbol,k)
	select case ngram_size
		case 2
			select case map2b(curr_symbol,k)
				case 1:new_letter=g2b(1,sol(j+1))
				case 0:new_letter=g2b(0,sol(j))
			end select
		case 3
			select case map2b(curr_symbol,k)
				case 2:new_letter=g3b(2,sol(j+1),sol(j+2))
				case 1:new_letter=g3b(1,sol(j),sol(j+2))
				case 0:new_letter=g3b(0,sol(j),sol(j+1))
			end select
		case 4
			select case map2b(curr_symbol,k)
				case 3:new_letter=g4b(3,sol(j+1),sol(j+2),sol(j+3))
				case 2:new_letter=g4b(2,sol(j),sol(j+2),sol(j+3))
				case 1:new_letter=g4b(1,sol(j),sol(j+1),sol(j+3))
				case 0:new_letter=g4b(0,sol(j),sol(j+1),sol(j+2))
			end select
		case 5
			select case map2b(curr_symbol,k)
				case 4:new_letter=g5b(4,sol(j+1),sol(j+2),sol(j+3),sol(j+4))
				case 3:new_letter=g5b(3,sol(j),sol(j+2),sol(j+3),sol(j+4))
				case 2:new_letter=g5b(2,sol(j),sol(j+1),sol(j+3),sol(j+4))
				case 1:new_letter=g5b(1,sol(j),sol(j+1),sol(j+2),sol(j+4))
				case 0:new_letter=g5b(0,sol(j),sol(j+1),sol(j+2),sol(j+3))
			end select
		case 6
			select case map2b(curr_symbol,k)
				case 5:new_letter=g6b(5,sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5))
				case 4:new_letter=g6b(4,sol(j),sol(j+2),sol(j+3),sol(j+4),sol(j+5))
				case 3:new_letter=g6b(3,sol(j),sol(j+1),sol(j+3),sol(j+4),sol(j+5))
				case 2:new_letter=g6b(2,sol(j),sol(j+1),sol(j+2),sol(j+4),sol(j+5))
				case 1:new_letter=g6b(1,sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+5))
				case 0:new_letter=g6b(0,sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4))
			end select
		case 7
			new_letter=abc_size
			select case map2b(curr_symbol,k)
				case 0
					new_letter=g7b(0,sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5))
					if new_letter=0 then
						new_letter=abc_size
						for i=0 to abc_sizem1
							blt=g7(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5),i)
							if blt>bls then bls=blt:new_letter=i
						next i
						g7b(0,sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5))=new_letter+1
					else
						new_letter-=1
					end if
				case 1
					new_letter=g7b(1,sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+6))
					if new_letter=0 then
						new_letter=abc_size
						for i=0 to abc_sizem1
							blt=g7(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),i,sol(j+6))
							if blt>bls then bls=blt:new_letter=i
						next i
						g7b(1,sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+6))=new_letter+1
					else
						new_letter-=1
					end if
				case 2
					new_letter=g7b(2,sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+5),sol(j+6))
					if new_letter=0 then
						new_letter=abc_size
						for i=0 to abc_sizem1
							blt=g7(sol(j),sol(j+1),sol(j+2),sol(j+3),i,sol(j+5),sol(j+6))
							if blt>bls then bls=blt:new_letter=i
						next i
						g7b(2,sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+5),sol(j+6))=new_letter+1
					else
						new_letter-=1
					end if
				case 3
					new_letter=g7b(3,sol(j),sol(j+1),sol(j+2),sol(j+4),sol(j+5),sol(j+6))
					if new_letter=0 then
						new_letter=abc_size
						for i=0 to abc_sizem1
							blt=g7(sol(j),sol(j+1),sol(j+2),i,sol(j+4),sol(j+5),sol(j+6))
							if blt>bls then bls=blt:new_letter=i
						next i
						g7b(3,sol(j),sol(j+1),sol(j+2),sol(j+4),sol(j+5),sol(j+6))=new_letter+1
					else
						new_letter-=1
					end if
				case 4
					new_letter=g7b(4,sol(j),sol(j+1),sol(j+3),sol(j+4),sol(j+5),sol(j+6))
					if new_letter=0 then
						new_letter=abc_size
						for i=0 to abc_sizem1
							blt=g7(sol(j),sol(j+1),i,sol(j+3),sol(j+4),sol(j+5),sol(j+6))
							if blt>bls then bls=blt:new_letter=i
						next i
						g7b(4,sol(j),sol(j+1),sol(j+3),sol(j+4),sol(j+5),sol(j+6))=new_letter+1
					else
						new_letter-=1
					end if
				case 5
					new_letter=g7b(5,sol(j),sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6))
					if new_letter=0 then
						new_letter=abc_size
						for i=0 to abc_sizem1
							blt=g7(sol(j),i,sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6))
							if blt>bls then bls=blt:new_letter=i
						next i
						g7b(5,sol(j),sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6))=new_letter+1
					else
						new_letter-=1
					end if
				case 6
					new_letter=g7b(6,sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6))
					if new_letter=0 then
						new_letter=abc_size
						for i=0 to abc_sizem1
							blt=g7(i,sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6))
							if blt>bls then bls=blt:new_letter=i
						next i
						g7b(6,sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6))=new_letter+1
					else
						new_letter-=1
					end if
			end select
		case 8
			new_letter=abc_size
			#include "solver_pickletter_bh8.bi"
		case 10
			new_letter=abc_size
			#include "solver_pickletter_bh10.bi"
		case else
			rng(k,1+map2(curr_symbol,0),state)
			j=map2(curr_symbol,k)
	end select
	if new_letter=old_letter or new_letter=abc_size then
		if ngram_language <> "english" then
			#include "solver_randomnewletter.bi"
		else
			h=map2b(curr_symbol,k)
			#include "solver_randomnewletter3.bi"
		end if
	end if
end if