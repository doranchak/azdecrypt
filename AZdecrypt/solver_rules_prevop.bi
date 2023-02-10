select case prev_op
	case 0,1 'use new (slow)
		memcpy(@bkey(1),@okey(1),l*2)
		memcpy(@sol(1),@sol0(1),l)
	case 2,3 'undo swap
		for i=0 to or3
			j=or3-i
			swap bkey(swaph(j)),bkey(swapk(j))
			swap sol(swaph(j)),sol(swapk(j))
		next i
	case 4 'undo move
		memcpy(@bkey(or1),@okey(or1),((or2+or3)-(or1-1))*2)
		memcpy(@sol(or1),@sol0(or1),((or2+or3)-(or1-1)))
	case 5 'undo move
		memcpy(@bkey(or2),@okey(or2),((or1+or3)-(or2-1))*2)
		memcpy(@sol(or2),@sol0(or2),((or1+or3)-(or2-1)))
end select