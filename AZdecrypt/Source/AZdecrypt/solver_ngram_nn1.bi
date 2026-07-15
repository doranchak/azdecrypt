'hi64=0
'argmax=-1
'hidx=0
'target=sol(j+nn_rec)
'for ni=0 to nn_rec-1
'	'txt1(ni)=ni+sol(j+ni)*(nn_rec*nn_hid1w)
'	txt1(ni)=sol(j+ni)+(ni*ngram_alphabet_size*nn_hid1w)
'next ni

'for ni=1 to nn_layers-1 'forward propagation
'	if ni<nn_layers-1 then 'first layer(s)
		'if ni=1 then 'input + first hidden state
			'for nb=0 to nn_hid1w-1
				'nn_state1(nb)=18446744073709551615
				nn_state=18446744073709551615
				for nj=0 to nn_rec-1
					nn_state=nn_state and table1(sol(j+nj)*nn_rec) 'ngram_alphabet_size
					'nn_state=nn_state and table1(sol(j+nj)+(nj*nn_abc)) 'ngram_alphabet_size
					'nn_state1(nb)=nn_state1(nb) and table1(sol(j+nj)+(nj*ngram_alphabet_size*nn_hid1w)+(nb*nn_rec))
					'nn_state1(nb)=nn_state1(nb) and table1(sol(j+nj)+nnp(j,nj)+(nb*nn_rec))
					'nn_state1(nb)=nn_state1(nb) and table1(txt1(nj)+(nb*nn_rec))
					'nn_state1(nb)=nn_state1(nb) and table1((nj+sol(j+nj)*(nn_rec*nn_hid1w))+(nb*nn_rec))
				next nj
			'next nb
		'else 'extra hidden states
		'	for nb=0 to nn_hid1w-1
		'		i64=0
		'		for nj=0 to nn_intbits-1
		'			i64=i64 or -((nn_state1(nb) and tablex(hidx))=0) shl nj
		'			hidx+=1
		'		next nj
		'		nn_state1(nb)=i64
		'	next nb
		'end if
'	else 'last layer
		'for nj=0 to nn_outdim-1 'output
		''	'i64=0
		''	'for nb=0 to nn_hid1w-1
		''	'	i64+=__builtin_popcountll(nn_state1(nb) and table2(nb+(nj*nn_hid1w)))
		'		i64=__builtin_popcountll(nn_state and table2(nj))
		''	'next nb
		''	'nn_os1(nj)=i64
		'	if i64>hi64 then
		'		hi64=i64
		'		argmax=nj
		'	end if
		'next nj
		'if argmax=sol(j+nn_rec) then i64=1 else i64=0
		i64=__builtin_popcountll(nn_state and table2(sol(j+nn_rec)))
'	end if
'next ni

'nn_state = -1ULL
'dim as ulongint temp
'for nj = 0 to nn_rec - 1
'    temp = sol(j + nj) + (nj * nn_abc)
'    nn_state and= table1(temp)
'next nj
'i64 = __builtin_popcountll(nn_state and table2(sol(j + nn_rec)))
