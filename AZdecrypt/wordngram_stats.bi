dim as string load_status=""
dim as string load_status2=""
load_status+="N-grams: "+str(solver_file_name_wordngrams)+lb
load_status+="---------------------------------------------------------"+lb
load_status+="N-gram type: "+ngram_type+lb
load_status+="N-gram file format: "+wordngram_format+lb
select case wordngram_size
	case 1:load_status+="N-gram system: default"+lb
end select
load_status+="N-gram size: "+str(wordngram_size)+lb
'load_status+="N-gram entropy weight: "+str(solvesub_entweight)+lb
'load_status+="N-gram factor: "+rdc(solvesub_ngramfactor,7)+lb
'load_status+="N-gram temperature: "+str(solvesub_temperature)+lb
'load_status+="N-gram alphabet: "
'for i=0 to ngram_alphabet_size-1
'	load_status+=chr(alphabet(i))
'next i
'load_status+=" ("+str(ngram_alphabet_size)+" letters)"+lb
load_status+="---------------------------------------------------------"+lb
load_status+="N-gram words: "+str(wordngram_count)+lb
load_status+="N-gram longest word: "+str(wordngram_maxwordlength)+lb
load_status+="N-gram log value range: "+str(wordngram_lowval)+" to "+str(wordngram_highval)+" ("+str(worddistinct_values)+" distinct values)"+lb
load_status+="N-gram log value average: "+rdc(wordngram_avgval/wordngram_count,2)+lb
load_status+="N-gram log value entropy: "+rdc(abs(wordngram_value_entropy1),2)+lb
load_status+="N-gram memory usage: "+rdc(wordngram_mem/1073741824,2)+" GB RAM ("+str(wordngram_mem)+" bytes)"+lb
load_status+="N-gram loading time: "+rdc(wordngram_loading_time,2)+" seconds"
'load_status2+=lb+"---------------------------------------------------------"
if loadngrams_wordngramvalueoverflows>0 then load_status2+=lb+"N-gram log value overflows: "+str(loadngrams_wordngramvalueoverflows)
if load_status2<>"" then load_status+=lb+"-------------------- *** WARNINGS *** -------------------"
if loadngrams_showmsg=1 then ui_editbox_settext(output_text,load_status+load_status2)