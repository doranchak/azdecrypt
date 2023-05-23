dim as ubyte ptr pi
dim as string filename1=remext(solver_file_name_ngrams)+"_binary.txt"
dim as string filename2=remext(solver_file_name_ngrams)+"_binary_table.txt"
dim as string filename3=remext(solver_file_name_ngrams)+"_binary.ini"
dim as string bdng=basedir+"\N-grams\"
select case ngram_size
	case 2,3,4,5,6,7
		select case ngram_size
			case 2:pi=@g2(0,0)
			case 3:pi=@g3(0,0,0)
			case 4:pi=@g4(0,0,0,0)
			case 5:pi=@g5(0,0,0,0,0)
			case 6:pi=@g6(0,0,0,0,0,0)
			case 7:pi=@g7(0,0,0,0,0,0,0)
		end select
		dim as integer bufferlen=(ngram_alphabet_size^2)-1 'why -1 ???
		dim as ubyte buffer(bufferlen)
		'open solvesub_ngramloctemp for binary as #1 'for language files (keep)
		open bdng+filename1 for binary as #1
		j=0
		k=0
		for i=0 to (ngram_alphabet_size^ngram_size)-1
			k+=1
			buffer(j)=pi[i]
			j+=1
			if j=bufferlen+1 then
				j=0
				put #1,,buffer()
			end if
		next i
		close #1
		filecopy bdng+remext(solver_file_name_ngrams)+".ini",bdng+filename3
		ui_editbox_settext(output_text,bdng+filename1+" created"+lb+bdng+filename3+" created") '+lb+str(j)+" "+str(k))
		'-------------------------------------------------------------------------------------
		'open remext(solvesub_ngramloctemp)+".ini" for binary as #1 'for language files (keep)
		'dim as string s="",unis=""
		'do
		'	line input #1,s
		'	if instr(s,"Unicode")>0 then unis+=s+lb
		'loop until eof(1)
		'close #1
		'open remext(solvesub_ngramloctemp)+".ini" for binary access write as #1
		'print #1,"N-gram size=b"+str(ngram_size)
		'print #1,"N-gram factor="+rdc(solvesub_ngramfactor,2)
		'print #1,"Entropy weight=1"
		'print #1,"Alphabet=";
		'for i=0 to ngram_alphabet_size-1
		'	print #1,chr(alphabet(i));
		'next i
		'print #1,lb+"Temperature=700";
		'if unis<>"" then print #1,lb+lb+unis;
		'close #1
		'-------------------------------------------------------------------------------------
	case 8
		pi=@bh8(0,0)
		open bdng+filename2 for binary as #1
		put #1,,bh4() 'doesn't work for files > 3GB (FreeBASIC bug)
		close #1
		dim as integer bufferlen=ngram_maxtableindex-1 'why -1 ???
		dim as ubyte buffer(bufferlen)
		open bdng+filename1 for binary as #1
		j=0
		k=0
		for i=0 to (ngram_maxtableindex*ngram_maxtableindex)-1
			k+=1
			buffer(j)=pi[i]
			j+=1
			if j=bufferlen+1 then
				j=0
				put #1,,buffer()
			end if
		next i
		close #1
		filecopy bdng+remext(solver_file_name_ngrams)+".ini",bdng+remext(solver_file_name_ngrams)+"_binary.ini"
		ui_editbox_settext(output_text,bdng+filename2+" created"+lb+bdng+filename1+" created"+lb+bdng+filename3+" created") '+lb+str(j)+" "+str(k))
end select