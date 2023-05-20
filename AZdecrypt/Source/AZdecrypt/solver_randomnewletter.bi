'state=48271*state and 2147483647
'new_letter=abc_sizem1*state shr 31
'if new_letter=old_letter then new_letter=abc_sizem1

do
	state=48271*state and 2147483647
	new_letter=abc_size*state shr 31
loop until new_letter<>old_letter