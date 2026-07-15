'nb=0

dim as long idx1=(sol(j)*nn_alphabet)+sol(j+1) '12
dim as long idx2=(sol(j+1)*nn_alphabet)+sol(j+2) '23
dim as long idx3=(sol(j+2)*nn_alphabet)+sol(j+3) '34

'i64=0
'for nb=0 to nn_hid1w-1
	i64=__builtin_popcountll(nn1(idx1) and nn1(676+idx2) and nn1(1352+idx3))
'next nb
i64=ngl_inv(i64)