case button_units_start
	if msg.message=wm_lbuttondown then
		soi=string_to_info(ui_editbox_gettext(input_text))
		if soi="Ok" then
			if task_active<>"none" then stop_current_task
			if len(solver_file_name_ngrams)>0 then
				'if ui_listbox_getcursel(list_main)<>12 then ui_listbox_setcursel(list_main,12)
				set_solverhighlight("substitution + units")
				sleep 100
				if task_active="none" then
					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",4,1,threads) 'stop solver
					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",2,1,threads) 'stop thread
					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",1,1,threads) 'start thread
					sleep 10
					thread_ptr(threadsmax+1)=threadcreate(@thread_solve_units,0)
				end if
			else ui_editbox_settext(output_text,"Error: no n-grams loaded")
			end if
		else ui_editbox_settext(output_text,soi)
		end if
	end if