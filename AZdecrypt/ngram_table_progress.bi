if timer-loadngramtimer>1 then
	loadngramtimer=timer
	ot=str(solver_file_name_ngrams)+lb
	ot+="--------------------------------------------------------"+lb
	ot+="Loading progress: 100% / "+rdc(j/((nm1+1)^(ngram_size-1))*100,2)+"%"
	if loadngrams_showmsg=1 then ui_editbox_settext(output_text,ot)
end if