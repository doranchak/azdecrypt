if timer-loadngramtimer>1 then
	loadngramtimer=timer
	ot=str(solver_file_name_ngrams)+lb
	ot+="--------------------------------------------------------"+lb
	ot+="Loading progress: "+rdc((curr_items/total_items)*100,2)+"%"
	if loadngrams_showmsg=1 then ui_editbox_settext(output_text,ot)
end if