hi64=0
argmax=-1
'dim as long aa,bb,cc
'hidx=0
'target=sol(j+nn_rec)
'for ni=0 to nn_rec-1
'	'txt1(ni)=ni+sol(j+ni)*(nn_rec*nn_hid1w)
'	txt1(ni)=sol(j+ni)+(ni*ngram_alphabet_size*nn_hid1w)
'next ni

dim as long aa,bb,cc

'nn_state1(0)=nn1((sol(j)*nn_alphabet)+sol(j+1)) _
'and nn1((sol(j+1)*nn_alphabet)+sol(j+2)+nn_alphabet_p2)

''nb=0
'for nb=0 to nn_hid1w-1
'	nn_state1(nb)=18446744073709551615
'	for nj=0 to nn_ngram_size-3 'bigrams
'		aa=sol(j+nj)*nn_alphabet+(sol(j+nj+1))
'		bb=nj*nn_alphabet_p2
'		cc=nb*nn_indim
'		nn_state1(nb)=nn_state1(nb) and nn1(aa+bb+cc)
'	next nj
'next nb


nb=0

nn_state1(nb)=nn1((sol(j)*nn_alphabet)+sol(j+1))_ '12
and nn1(nn_alphabet_p2+(sol(j+1)*nn_alphabet)+sol(j+2))_ '23
and nn1((nn_alphabet_p2*2)+(sol(j)*nn_alphabet)+sol(j+2)) '13

for nj=0 to nn_outdim-1 'output
	i64=0
	'for nb=0 to nn_hid1w-1
		'i64+=__builtin_popcountll(nn_state1(nb) and nn1((nn_indim*nn_hid1w)+nj+(nb*nn_outdim)))
		i64+=__builtin_popcountll(nn_state1(nb) and nn1((nn_indim*nn_hid1w)+nj+(sol(j+(nn_ngram_size-2))*nn_outdim)+(nb*nn_outdim)))
	'next nb
	i64=ngl_inv(i64)
	if i64>hi64 then
		hi64=i64
		argmax=nj
	end if
next nj

''for ni=1 to nn_layers-1 'forward propagation
''	if ni<nn_layers-1 then 'first layer(s)
'		'if ni=1 then 'input + first hidden state
'			for nb=0 to nn_hid1w-1
'				'-------------------------------------------------
'				nn_state1(nb)=table1(sol(j)+(nb*nn_indim)) _
'				and table1(sol(j+1)+ngram_alphabet_size+(nb*nn_indim)) _
'				and table1(sol(j+2)+(ngram_alphabet_size*2)+(nb*nn_indim))
'				'-------------------------------------------------
'				'nn_state1(nb)=18446744073709551615
'				'for nj=0 to nn_rec-1 'normal
'				'	nn_state1(nb)=nn_state1(nb) and table1((sol(j+nj)+(nj*ngram_alphabet_size))+(nb*nn_indim))
'				'next nj
'				'-------------------------------------------------
'				'nn_state1(nb)=18446744073709551615
'				'for nj=0 to nn_rec-2 'bigrams
'				'	aa=sol(j+nj)+(sol(j+nj+1)*nn_abc)
'				'	bb=nj*nn_abc2
'				'	cc=nb*nn_indim
'				'	nn_state1(nb)=nn_state1(nb) and table1(aa+bb+cc)
'				'next nj
'				'-------------------------------------------------
'			next nb
'		'else 'extra hidden states
'		'	for nb=0 to nn_hid1w-1
'		'		i64=0
'		'		for nj=0 to nn_intbits-1
'		'			i64=i64 or -((nn_state1(nb) and tablex(hidx))=0) shl nj
'		'			hidx+=1
'		'		next nj
'		'		nn_state1(nb)=i64
'		'	next nb
'		'end if
''	else 'last layer
'		for nj=0 to nn_outdim-1 'output
'			i64=0
'			for nb=0 to nn_hid1w-1
'			'	i64+=__builtin_popcountll(nn_state1(nb) and table2(nb+(nj*nn_hid1w)))
'				'i64=__builtin_popcountll(nn_state and table2(nj))
'				i64+=__builtin_popcountll(nn_state1(nb) and table2(nj+(nb*nn_outdim)))
'			next nb
'			'nn_os1(nj)=i64
'			'i64=32-i64
'			i64=ngl_inv(i64)
'			'i64=(nn_maxlog-i64)*-(i64<(nn_maxlog+1))
'			if i64>hi64 then
'				hi64=i64
'				argmax=nj
'			end if
'		next nj
'		'target=__builtin_popcountll(nn_state and table2(nb+target))
''	end if
''next ni