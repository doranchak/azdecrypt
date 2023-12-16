dim as string load_status=""
dim as string warnings=""
dim as integer hasspace=0
load_status+="N-grams: "+str(solver_file_name_ngrams)+lb
'load_status+="(n-grams_language_author_source_version.txt/bin/gz)"+lb
load_status+="---------------------------------------------------------"+lb
load_status+="N-gram type: "+ngram_type+lb
load_status+="N-gram file format: "+ngram_format+lb
select case ngram_size
	case 2 to 7:load_status+="N-gram system: default"+lb
	case 8:load_status+="N-gram system: beijinghouse"+lb
end select
load_status+="N-gram size: "+str(ngram_size)+lb
load_status+="N-gram entropy weight: "+str(solvesub_entweight)+lb
load_status+="N-gram factor: "+rdc(solvesub_ngramfactor,7)+lb
load_status+="N-gram temperature: "+str(solvesub_temperature)+lb
load_status+="N-gram alphabet: "+chr(34)
for i=0 to ngram_alphabet_size-1
	load_status+=chr(alphabet(i))
	if alphabet(i)=32 then hasspace=1
next i
load_status+=chr(34)+" ("+str(ngram_alphabet_size)+" letters)"+lb
load_status+="---------------------------------------------------------"+lb
load_status+="N-gram language: "+ngram_language+lb
load_status+="N-gram word spacing: "+ngram_spaceslang+lb
load_status+="N-gram normalization: "
if normtext<>"" then load_status+=ngram_language+lb else load_status+=" none"+lb
load_status+="N-gram compiler: "+ngram_author+lb
load_status+="N-gram source: "+ngram_source+lb
load_status+="N-gram version: "+ngram_version+lb
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
load_status+="N-gram loading time: "+rdc(ngram_loading_time,2)+" seconds"
'load_status2+=lb+"---------------------------------------------------------"
if loadngrams_fileformatmismatch<>"" then warnings+=lb+"- N-gram file format auto-detected as "+str(loadngrams_fileformatmismatch)
if loadngrams_ngramvalueoverflows>0 then warnings+=lb+"- N-gram log value overflows: "+str(loadngrams_ngramvalueoverflows)
if ngram_size<9 andalso (ngram_count/(ngram_alphabet_size^ngram_size)*100)<1 then warnings+=lb+"- N-gram item coverage is very low"
if ngram_size=9 andalso (ngram_count/(ngram_alphabet_size^ngram_size)*100)<0.1 then warnings+=lb+"- N-gram item coverage is very low"
if ngram_size=10 andalso (ngram_count/(ngram_alphabet_size^ngram_size)*100)<0.01 then warnings+=lb+"- N-gram item coverage is very low"
dim as double nge_lo,nge_hi
select case ngram_size
	case 2:nge_lo=0.05:nge_hi=0.75
	case 3:nge_lo=0.1:nge_hi=0.75
	case 4:nge_lo=0.25:nge_hi=1
	case 5:nge_lo=0.5:nge_hi=1.5
	case 6:nge_lo=0.75:nge_hi=1.75
	case 7:nge_lo=1:nge_hi=2
	case 8:nge_lo=1:nge_hi=2
	case 9:nge_lo=1:nge_hi=2
	case 10:nge_lo=1:nge_hi=2
	case else:nge_lo=1:nge_hi=2
end select
if solvesub_entweight<nge_lo then warnings+=lb+"- N-gram entropy weight may be to low"
if solvesub_entweight>nge_hi then warnings+=lb+"- N-gram entropy weight may be to high"
if ngram_language="unspecified" then
	warnings+=lb+"- Unspecified language, word spacing will not be applied. "
	warnings+=lb+"  Please use the following n-gram file format: "
	warnings+=lb+"  n-grams_language_author_source_version.txt/bin/gz"
end if
if ngram_standardalphabet=0 andalso ngram_spacingsource<>"none" andalso hasspace=0 then
	warnings+=lb+"- Alphabet must be ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	warnings+=lb+"  for word spacing to apply"
end if
if warnings<>"" then load_status+=lb+"-------------------- *** WARNINGS *** -------------------"
if loadngrams_showmsg=1 then ui_editbox_settext(output_text,load_status+warnings)