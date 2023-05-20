select case map2b(curr_symbol,k)
	case 0
		z1=bh5(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4))
		if z1>0 then
			for i=0 to abc_sizem1
				blt=bh10(z1,bh5(sol(j+5),sol(j+6),sol(j+7),sol(j+8),i))
				if blt>bls then bls=blt:new_letter=i
			next i
		end if
	case 1
		z1=bh5(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4))
		if z1>0 then
			for i=0 to abc_sizem1
				blt=bh10(z1,bh5(sol(j+5),sol(j+6),sol(j+7),i,sol(j+9)))
				if blt>bls then bls=blt:new_letter=i
			next i
		end if
	case 2
		z1=bh5(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4))
		if z1>0 then
			for i=0 to abc_sizem1
				blt=bh10(z1,bh5(sol(j+5),sol(j+6),i,sol(j+8),sol(j+9)))
				if blt>bls then bls=blt:new_letter=i
			next i
		end if
	case 3
		z1=bh5(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4))
		if z1>0 then
			for i=0 to abc_sizem1
				blt=bh10(z1,bh5(sol(j+5),i,sol(j+7),sol(j+8),sol(j+9)))
				if blt>bls then bls=blt:new_letter=i
			next i
		end if
	case 4
		z1=bh5(sol(j),sol(j+1),sol(j+2),sol(j+3),sol(j+4))
		if z1>0 then
			for i=0 to abc_sizem1
				blt=bh10(z1,bh5(i,sol(j+6),sol(j+7),sol(j+8),sol(j+9)))
				if blt>bls then bls=blt:new_letter=i
			next i
		end if
	case 5
		z2=bh5(sol(j+5),sol(j+6),sol(j+7),sol(j+8),sol(j+9))
		if z2>0 then
			for i=0 to abc_sizem1
				blt=bh10(bh5(sol(j),sol(j+1),sol(j+2),sol(j+3),i),z2)
				if blt>bls then bls=blt:new_letter=i
			next i
		end if
	case 6
		z2=bh5(sol(j+5),sol(j+6),sol(j+7),sol(j+8),sol(j+9))
		if z2>0 then
			for i=0 to abc_sizem1
				blt=bh10(bh5(sol(j),sol(j+1),sol(j+2),i,sol(j+4)),z2)
				if blt>bls then bls=blt:new_letter=i
			next i
		end if
	case 7
		z2=bh5(sol(j+5),sol(j+6),sol(j+7),sol(j+8),sol(j+9))
		if z2>0 then
			for i=0 to abc_sizem1
				blt=bh10(bh5(sol(j),sol(j+1),i,sol(j+3),sol(j+4)),z2)
				if blt>bls then bls=blt:new_letter=i
			next i
		end if
	case 8
		z2=bh5(sol(j+5),sol(j+6),sol(j+7),sol(j+8),sol(j+9))
		if z2>0 then
			for i=0 to abc_sizem1
				blt=bh10(bh5(sol(j),i,sol(j+2),sol(j+3),sol(j+4)),z2)
				if blt>bls then bls=blt:new_letter=i
			next i
		end if
	case 9
		z2=bh5(sol(j+5),sol(j+6),sol(j+7),sol(j+8),sol(j+9))
		if z2>0 then
			for i=0 to abc_sizem1
				blt=bh10(bh5(i,sol(j+1),sol(j+2),sol(j+3),sol(j+4)),z2)
				if blt>bls then bls=blt:new_letter=i
			next i
		end if
end select