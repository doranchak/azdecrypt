'state=48271*state and 2147483647
'new_letter=abc_sizem1*state shr 31
'if new_letter=old_letter then new_letter=abc_sizem1

do
	rng(new_letter,abc_size,state)
loop until new_letter<>old_letter