rng(new_letter(n),abc_sizem1,state(n))
'state(n)=48271*state(n) and 2147483647
'new_letter(n)=abc_sizem1*state(n) shr 31
if new_letter(n)=old_letter(n) then new_letter(n)=abc_sizem1