dim as string load_status=""
load_status+="N-grams: "+str(solver_file_name_ngrams)+lb
load_status+="---------------------------------------------------------"+lb
load_status+="N-gram file format: "+ngram_format+lb
select case ngram_size
	case 2 to 7:load_status+="N-gram system: default"+lb
	case 8:load_status+="N-gram system: beijinghouse"+lb
end select
load_status+="N-gram size: "+str(ngram_size)+lb
load_status+="N-gram entropy weight: "+str(solvesub_entweight)+lb
load_status+="N-gram factor: "+rdc(solvesub_ngramfactor,7)+lb
load_status+="N-gram temperature: "+str(solvesub_temperature)+lb
load_status+="N-gram alphabet: "
for i=0 to ngram_alphabet_size-1
	load_status+=chr(alphabet(i))
next i
load_status+=" ("+str(ngram_alphabet_size)+" letters)"+lb
load_status+="---------------------------------------------------------"+lb
load_status+="N-gram items: "+str(ngram_count)+" ("+rdc(ngram_count/(ngram_alphabet_size^ngram_size)*100,2)+"% coverage)"+lb
if ngram_maxtableindex>0 then load_status+="N-gram system table size: "+str(ngram_maxtableindex)+ " ("+rdc(trimmed_table_ratio*100,2)+"% usage)"+lb
load_status+="N-gram log value range: "+str(ngram_lowval)+" to "+str(ngram_highval)+" ("+str(distinct_values)+" distinct values)"+lb
load_status+="N-gram log value average: "+rdc(ngram_avgval/(ngram_alphabet_size^ngram_size),2)+" / "+rdc(ngram_avgval/ngram_count,2)+lb
load_status+="N-gram log value entropy: "+rdc(abs(ngram_value_entropy1),2)+" / "+rdc(abs(ngram_value_entropy2),2)+lb
load_status+="N-gram memory usage: "+rdc(ngram_mem/1073741824,2)+" GB RAM ("+str(ngram_mem)+" bytes)"+lb
if ngram_size=8 andalso solvesub_ngramcaching=1 then
	dim as uinteger cachebh8_nfb=8*(ngram_alphabet_size^3)*ngram_maxtableindex
	load_status+="N-gram caching extra memory usage: "+rdc(cachebh8_nfb/1073741824,2)+" GB RAM ("+str(cachebh8_nfb)+" bytes)"+lb
end if
load_status+="N-gram Loading time: "+rdc(ngram_loading_time,2)+" seconds"
if loadngrams_showmsg=1 then ui_editbox_settext(output_text,load_status)