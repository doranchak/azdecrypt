do
	rng(r,abc_size,state)
	'state=48271*state and 2147483647
	'r=abc_size*state shr 31
	for i=0 to shifts-1
		if poly_letter(rc1_symbol,i)<>abcshift(r,i) then exit do
	next i
loop
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