case button_polyphones_reload
	if msg.message=wm_lbuttondown then
		soi=string_to_info(ui_editbox_gettext(input_text))
		if soi="Ok" then
			get_symbols(1)
			ui_listbox_setcursel(list_polyphones_stl,0)
		else ui_editbox_settext(output_text,soi)
		end if
	end if
	
case button_polyphones_setsel
	if msg.message=wm_lbuttondown then
		soi=string_to_info(ui_editbox_gettext(input_text))
		if soi="Ok" then
			dim as integer cursor=ui_listbox_getcursel(list_polyphones_stl)
			dim as string ngram1=ui_listbox_gettext(list_polyphones_stl,cursor)
			ngram1=left(ngram1,instr(ngram1,"(")-2)
			dim as integer snum
			if info_numerical=0 then
				snum=asc(ngram1)
			else	
				snum=val(ngram1)
			end if
			for i=1 to info_length
				if info(i)=snum then 
					k=nuba(i)
					exit for
				end if
			next i
			j=val(ui_editbox_gettext(editbox_polyphones_setsel))
			if j>ngram_alphabet_size then j=ngram_alphabet_size
			if j>=1 then
				cpol(k)=j
			end if
			get_symbols(1)
			ui_listbox_setcursel(list_polyphones_stl,cursor)
		else ui_editbox_settext(output_text,soi)
		end if
	end if
	
case button_polyphones_setall
	if msg.message=wm_lbuttondown then
		soi=string_to_info(ui_editbox_gettext(input_text))
		if soi="Ok" then
			dim as integer cursor=ui_listbox_getcursel(list_polyphones_stl)
			j=val(ui_editbox_gettext(editbox_polyphones_setall))
			if j>ngram_alphabet_size then j=ngram_alphabet_size
			if j>=1 then
				for i=1 to constcip
					cpol(i)=j
				next i
			end if
			get_symbols(1)
			ui_listbox_setcursel(list_polyphones_stl,cursor)
		else ui_editbox_settext(output_text,soi)
		end if
	end if
	
'case button_polyphones_solve
'	if msg.message=wm_lbuttondown then
'		soi=string_to_info(ui_editbox_gettext(input_text))
'		if soi="Ok" then
'			if task_active<>"none" then stop_current_task
'			if len(solver_file_name_ngrams)>0 then
'				sleep 100
'				if task_active="none" then
'					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",4,1,threads) 'stop solver
'					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",2,1,threads) 'stop thread
'					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",1,1,threads) 'start thread
'					sleep 10
'					thread_ptr(threadsmax+1)=threadcreate(@thread_solve_polyphones_user,0)
'				end if
'			else ui_editbox_settext(output_text,"Error: no n-grams loaded")
'			end if
'		else ui_editbox_settext(output_text,soi)
'		end if
'	end if