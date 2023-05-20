bls=0
if d>mc then
	#include "solver_randomnewletter_hafer.bi"
else
	rng(k,1+map2(rc1_symbol,0),state)
	'state=48271*state and 2147483647
	'k=1+map2(rc1_symbol,0)*state shr 31
	j=map2(rc1_symbol,k)
	select case ngram_size
		'case 2
		'	select case map2b(rc1_symbol,k)
		'		case 1:new_letter=g2b(1,sol(j+1)):old_letter=sol(j)
		'		case 0:new_letter=g2b(0,sol(j)):old_letter=sol(j+1)
		'	end select
		'case 3
		'	select case map2b(rc1_symbol,k)
		'		case 2:new_letter=g3b(2,sol(j+1),sol(j+2)):old_letter=sol(j)
		'		case 1:new_letter=g3b(1,sol(j),sol(j+2)):old_letter=sol(j+1)
		'		case 0:new_letter=g3b(0,sol(j),sol(j+1)):old_letter=sol(j+2)
		'	end select
		'case 4
		'	select case map2b(rc1_symbol,k)
		'		case 3:new_letter=g4b(3,sol(j+1),sol(j+2),sol(j+3)):old_letter=sol(j)
		'		case 2:new_letter=g4b(2,sol(j),sol(j+2),sol(j+3)):old_letter=sol(j+1)
		'		case 1:new_letter=g4b(1,sol(j),sol(j+1),sol(j+3)):old_letter=sol(j+2)
		'		case 0:new_letter=g4b(0,sol(j),sol(j+1),sol(j+2)):old_letter=sol(j+3)
		'	end select
		case 5
			select case map2b(rc1_symbol,k)
				case 4:new_letter=g5b(4,sol(j+1),sol(j+2),sol(j+3),sol(j+4)):old_letter=sol(j)
				case 3:new_letter=g5b(3,sol(j),sol(j+2),sol(j+3),sol(j+4)):old_letter=sol(j+1)
				case 2:new_letter=g5b(2,sol(j),sol(j+1),sol(j+3),sol(j+4)):old_letter=sol(j+2)
				case 1:new_letter=g5b(1,sol(j),sol(j+1),sol(j+2),sol(j+4)):old_letter=sol(j+3)
				case 0:new_letter=g5b(0,sol(j),sol(j+1),sol(j+2),sol(j+3)):old_letter=sol(j+4)
			end select
		case 6
			select case map2b(rc1_symbol,k)
				case 5:new_letter=g6b(5,sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5)):old_letter=sol(j)
				case 4:new_letter=g6b(4,sol(j),sol(j+2),sol(j+3),sol(j+4),sol(j+5)):old_letter=sol(j+1)
				case 3:new_letter=g6b(3,sol(j),sol(j+1),sol(j+3),sol(j+4),sol(j+5)):old_letter=sol(j+2)
				case 2:new_letter=g6b(2,sol(j),sol(j+1),sol(j+2),sol(j+4),sol(j+5)):old_letter=sol(j+3)
				case 1:new_letter=g6b(1,sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+5)):old_letter=sol(j+4)
				case 0:new_letter=g6b(0,sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4)):old_letter=sol(j+5)
			end select
		case 7
			new_letter=abc_size
			select case map2b(rc1_symbol,k)
				case 0
					old_letter=sol(j+6)
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
					old_letter=sol(j+5)
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
					old_letter=sol(j+4)
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
					old_letter=sol(j+3)
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
					old_letter=sol(j+2)
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
					old_letter=sol(j+1)
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
					old_letter=sol(j)
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
			#include "solver_pickletter_bh8_hafer.bi"
		'case 10
		'	new_letter=abc_size
		'	#include "solver_pickletter_bh10_hafer.bi"
	end select
	if new_letter=old_letter or new_letter=abc_size then
		#include "solver_randomnewletter_hafer.bi"
	else
		for i=0 to shifts-1
			if poly_letter(rc1_symbol,i)=old_letter then
				for j=0 to abc_sizem1
					if abcshift(j,i)=new_letter then
						r=j
						exit for,for
					end if
				next j
			end if
		next i
		for i=0 to shifts-1
			new_letters(i)=abcshift(r,i)
			poly_letter(rc1_symbol,i)=abcshift(r,i)
		next i
		for i=1 to map1(rc1_symbol,0)
			for j=0 to shifts-1
				if old_letters(j)=sol(map1(rc1_symbol,i)) then
					sol(map1(rc1_symbol,i))=new_letters(j)
					frq(old_letters(j))-=mape1(map1(rc1_symbol,i))
					frq(new_letters(j))+=mape1(map1(rc1_symbol,i))
					exit for
				end if
			next j
		next i
	end if
end if