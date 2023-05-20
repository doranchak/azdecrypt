if solvesub_ngramcaching=0 then
	select case map3b(curr_symbol,k)
		case 0
			z1=bh4(sol(j),sol(j+1),sol(j+2),sol(j+3))
			if z1>0 then
				for i=0 to abc_sizem1
					blt=bh8(z1,bh4(sol(j+4),sol(j+5),sol(j+6),i))
					if blt>bls then bls=blt:new_letter=i
				next i
			end if
		case 1
			z1=bh4(sol(j),sol(j+1),sol(j+2),sol(j+3))
			if z1>0 then
				for i=0 to abc_sizem1
					blt=bh8(z1,bh4(sol(j+4),sol(j+5),i,sol(j+7)))
					if blt>bls then bls=blt:new_letter=i
				next i
			end if
		case 2
			z1=bh4(sol(j),sol(j+1),sol(j+2),sol(j+3))
			if z1>0 then
				for i=0 to abc_sizem1
					blt=bh8(z1,bh4(sol(j+4),i,sol(j+6),sol(j+7)))
					if blt>bls then bls=blt:new_letter=i
				next i
			end if
		case 3
			z1=bh4(sol(j),sol(j+1),sol(j+2),sol(j+3))
			if z1>0 then
				for i=0 to abc_sizem1
					blt=bh8(z1,bh4(i,sol(j+5),sol(j+6),sol(j+7)))
					if blt>bls then bls=blt:new_letter=i
				next i
			end if
		case 4
			z2=bh4(sol(j+4),sol(j+5),sol(j+6),sol(j+7))
			if z2>0 then
				for i=0 to abc_sizem1
					blt=bh8(bh4(sol(j),sol(j+1),sol(j+2),i),z2)
					if blt>bls then bls=blt:new_letter=i
				next i
			end if
		case 5
			z2=bh4(sol(j+4),sol(j+5),sol(j+6),sol(j+7))
			if z2>0 then
				for i=0 to abc_sizem1
					blt=bh8(bh4(sol(j),sol(j+1),i,sol(j+3)),z2)
					if blt>bls then bls=blt:new_letter=i
				next i
			end if
		case 6
			z2=bh4(sol(j+4),sol(j+5),sol(j+6),sol(j+7))
			if z2>0 then
				for i=0 to abc_sizem1
					blt=bh8(bh4(sol(j),i,sol(j+2),sol(j+3)),z2)
					if blt>bls then bls=blt:new_letter=i
				next i
			end if
		case 7
			z2=bh4(sol(j+4),sol(j+5),sol(j+6),sol(j+7))
			if z2>0 then
				for i=0 to abc_sizem1
					blt=bh8(bh4(i,sol(j+1),sol(j+2),sol(j+3)),z2)
					if blt>bls then bls=blt:new_letter=i
				next i
			end if
	end select
else
	select case map3b(curr_symbol,k)
		case 0
			z1=bh4(sol(j),sol(j+1),sol(j+2),sol(j+3))
			if z1>0 then
				new_letter=cachebh80(sol(j+4),sol(j+5),sol(j+6),z1)
				if new_letter=0 then
					new_letter=abc_size
					for i=0 to abc_sizem1
						blt=bh8(z1,bh4(sol(j+4),sol(j+5),sol(j+6),i))
						if blt>bls then bls=blt:new_letter=i
					next i
					cachebh80(sol(j+4),sol(j+5),sol(j+6),z1)=new_letter+1
				else
					new_letter-=1
				end if
			end if
		case 1
			z1=bh4(sol(j),sol(j+1),sol(j+2),sol(j+3))
			if z1>0 then
				new_letter=cachebh81(sol(j+4),sol(j+5),sol(j+7),z1)
				if new_letter=0 then
					new_letter=abc_size
					for i=0 to abc_sizem1
						blt=bh8(z1,bh4(sol(j+4),sol(j+5),i,sol(j+7)))
						if blt>bls then bls=blt:new_letter=i
					next i
					cachebh81(sol(j+4),sol(j+5),sol(j+7),z1)=new_letter+1
				else
					new_letter-=1
				end if
			end if
		case 2
			z1=bh4(sol(j),sol(j+1),sol(j+2),sol(j+3))
			if z1>0 then
				new_letter=cachebh82(sol(j+4),sol(j+6),sol(j+7),z1)
				if new_letter=0 then
					new_letter=abc_size
					for i=0 to abc_sizem1
						blt=bh8(z1,bh4(sol(j+4),i,sol(j+6),sol(j+7)))
						if blt>bls then bls=blt:new_letter=i
					next i
					cachebh82(sol(j+4),sol(j+6),sol(j+7),z1)=new_letter+1
				else
					new_letter-=1
				end if
			end if
		case 3
			z1=bh4(sol(j),sol(j+1),sol(j+2),sol(j+3))
			if z1>0 then
				new_letter=cachebh83(sol(j+5),sol(j+6),sol(j+7),z1)
				if new_letter=0 then
					new_letter=abc_size
					for i=0 to abc_sizem1
						blt=bh8(z1,bh4(i,sol(j+5),sol(j+6),sol(j+7)))
						if blt>bls then bls=blt:new_letter=i
					next i
					cachebh83(sol(j+5),sol(j+6),sol(j+7),z1)=new_letter+1
				else
					new_letter-=1
				end if
			end if
		case 4
			z2=bh4(sol(j+4),sol(j+5),sol(j+6),sol(j+7))
			if z2>0 then
				new_letter=cachebh84(sol(j),sol(j+1),sol(j+2),z2)
				if new_letter=0 then
					new_letter=abc_size
					for i=0 to abc_sizem1
						blt=bh8(bh4(sol(j),sol(j+1),sol(j+2),i),z2)
						if blt>bls then bls=blt:new_letter=i
					next i
					cachebh84(sol(j),sol(j+1),sol(j+2),z2)=new_letter+1
				else
					new_letter-=1
				end if
			end if
		case 5
			z2=bh4(sol(j+4),sol(j+5),sol(j+6),sol(j+7))
			if z2>0 then
				new_letter=cachebh85(sol(j),sol(j+1),sol(j+3),z2)
				if new_letter=0 then
					new_letter=abc_size
					for i=0 to abc_sizem1
						blt=bh8(bh4(sol(j),sol(j+1),i,sol(j+3)),z2)
						if blt>bls then bls=blt:new_letter=i
					next i
					cachebh85(sol(j),sol(j+1),sol(j+3),z2)=new_letter+1
				else
					new_letter-=1
				end if
			end if
		case 6
			z2=bh4(sol(j+4),sol(j+5),sol(j+6),sol(j+7))
			if z2>0 then
				new_letter=cachebh86(sol(j),sol(j+2),sol(j+3),z2)
				if new_letter=0 then
					new_letter=abc_size
					for i=0 to abc_sizem1
						blt=bh8(bh4(sol(j),i,sol(j+2),sol(j+3)),z2)
						if blt>bls then bls=blt:new_letter=i
					next i
					cachebh86(sol(j),sol(j+2),sol(j+3),z2)=new_letter+1
				else
					new_letter-=1
				end if
			end if
		case 7
			z2=bh4(sol(j+4),sol(j+5),sol(j+6),sol(j+7))
			if z2>0 then
				new_letter=cachebh87(sol(j+1),sol(j+2),sol(j+3),z2)
				if new_letter=0 then
					new_letter=abc_size
					for i=0 to abc_sizem1
						blt=bh8(bh4(i,sol(j+1),sol(j+2),sol(j+3)),z2)
						if blt>bls then bls=blt:new_letter=i
					next i
					cachebh87(sol(j+1),sol(j+2),sol(j+3),z2)=new_letter+1
				else
					new_letter-=1
				end if
			end if
	end select
end if