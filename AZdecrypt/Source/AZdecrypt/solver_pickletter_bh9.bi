blt=0
select case h
	case 0
		for i=0 to abc_sizem1
				if i<>old_letter then blt=bh9(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6),sol(j+7),i)
				if blt>bls then bls=blt:new_letter=i
		next i
		
	case 1
		for i=0 to abc_sizem1
				if i<>old_letter then blt=bh9(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6),i,sol(j+8))
				if blt>bls then bls=blt:new_letter=i
		next i

	case 2
		for i=0 to abc_sizem1
				if i<>old_letter then blt=bh9(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5),i,sol(j+7),sol(j+8))
				if blt>bls then bls=blt:new_letter=i
		next i

	case 3
		for i=0 to abc_sizem1
				if i<>old_letter then blt=bh9(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4),i,sol(j+6),sol(j+7),sol(j+8))
				if blt>bls then bls=blt:new_letter=i
		next i
		
	case 4
		for i=0 to abc_sizem1
				if i<>old_letter then blt=bh9(sol(j),sol(j+1),sol(j+2),sol(j+3),i,sol(j+5),sol(j+6),sol(j+7),sol(j+8))
				if blt>bls then bls=blt:new_letter=i
		next i

	case 5
		for i=0 to abc_sizem1
				if i<>old_letter then blt=bh9(sol(j),sol(j+1),sol(j+2),i,sol(j+4),sol(j+5),sol(j+6),sol(j+7),sol(j+8))
				if blt>bls then bls=blt:new_letter=i
		next i

	case 6
		for i=0 to abc_sizem1
				if i<>old_letter then blt=bh9(sol(j),sol(j+1),i,sol(j+3),sol(j+4),sol(j+5),sol(j+6),sol(j+7),sol(j+8))
				if blt>bls then bls=blt:new_letter=i
		next i

	case 7
		for i=0 to abc_sizem1
				if i<>old_letter then blt=bh9(sol(j),i,sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6),sol(j+7),sol(j+8))
				if blt>bls then bls=blt:new_letter=i
		next i

	case 8
		for i=0 to abc_sizem1
				if i<>old_letter then blt=bh9(i,sol(j+1),sol(j+2),sol(j+3),sol(j+4),sol(j+5),sol(j+6),sol(j+7),sol(j+8))
				if blt>bls then bls=blt:new_letter=i
		next i
			
End select