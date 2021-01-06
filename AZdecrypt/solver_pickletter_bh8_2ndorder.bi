select case map2b(curr_symbol(n),k)
	case 0
		z1=bh4(sol(n,j),sol(n,j+1),sol(n,j+2),sol(n,j+3))
		if z1>0 then
			for i=0 to abc_sizem1
				blt=bh8(z1,bh4(sol(n,j+4),sol(n,j+5),sol(n,j+6),i))
				if blt>bls then bls=blt:new_letter(n)=i
			next i
		end if
	case 1
		z1=bh4(sol(n,j),sol(n,j+1),sol(n,j+2),sol(n,j+3))
		if z1>0 then
			for i=0 to abc_sizem1
				blt=bh8(z1,bh4(sol(n,j+4),sol(n,j+5),i,sol(n,j+7)))
				if blt>bls then bls=blt:new_letter(n)=i
			next i
		end if
	case 2
		z1=bh4(sol(n,j),sol(n,j+1),sol(n,j+2),sol(n,j+3))
		if z1>0 then
			for i=0 to abc_sizem1
				blt=bh8(z1,bh4(sol(n,j+4),i,sol(n,j+6),sol(n,j+7)))
				if blt>bls then bls=blt:new_letter(n)=i
			next i
		end if
	case 3
		z1=bh4(sol(n,j),sol(n,j+1),sol(n,j+2),sol(n,j+3))
		if z1>0 then
			for i=0 to abc_sizem1
				blt=bh8(z1,bh4(i,sol(n,j+5),sol(n,j+6),sol(n,j+7)))
				if blt>bls then bls=blt:new_letter(n)=i
			next i
		end if		
	case 4
		z2=bh4(sol(n,j+4),sol(n,j+5),sol(n,j+6),sol(n,j+7))
		if z2>0 then
			for i=0 to abc_sizem1
				blt=bh8(bh4(sol(n,j),sol(n,j+1),sol(n,j+2),i),z2)
				if blt>bls then bls=blt:new_letter(n)=i
			next i
		end if		
	case 5
		z2=bh4(sol(n,j+4),sol(n,j+5),sol(n,j+6),sol(n,j+7))
		if z2>0 then
			for i=0 to abc_sizem1
				blt=bh8(bh4(sol(n,j),sol(n,j+1),i,sol(n,j+3)),z2)
				if blt>bls then bls=blt:new_letter(n)=i
			next i
		end if
	case 6
		z2=bh4(sol(n,j+4),sol(n,j+5),sol(n,j+6),sol(n,j+7))
		if z2>0 then
			for i=0 to abc_sizem1
				blt=bh8(bh4(sol(n,j),i,sol(n,j+2),sol(n,j+3)),z2)
				if blt>bls then bls=blt:new_letter(n)=i
			next i
		end if
	case 7
		z2=bh4(sol(n,j+4),sol(n,j+5),sol(n,j+6),sol(n,j+7))
		if z2>0 then
			for i=0 to abc_sizem1
				blt=bh8(bh4(i,sol(n,j+1),sol(n,j+2),sol(n,j+3)),z2)
				if blt>bls then bls=blt:new_letter(n)=i
			next i
		end if
end select