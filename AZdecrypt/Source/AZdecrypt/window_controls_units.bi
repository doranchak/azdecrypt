case button_units_start
	if msg.message=wm_lbuttondown then
		soi=string_to_info(ui_editbox_gettext(input_text),constcip)
		if soi="Ok" then
			if task_active<>"none" then stop_current_task
			if len(solver_file_name_ngrams)>0 then
				'if ui_listbox_getcursel(list_main)<>12 then ui_listbox_setcursel(list_main,12)
				set_solverhighlight("substitution + units")
				sleep 25
				if task_active="none" then
					'---------------------------------------------------------------
					if val(ui_editbox_gettext(editbox_main_homophoneweight))>=0 then
						solvesub_homophoneweight=val(ui_editbox_gettext(editbox_main_homophoneweight))
					end if
					if val(ui_editbox_gettext(editbox_main_entropyweight))>0 then
						if val(ui_editbox_gettext(editbox_main_entropyweight))<>solvesub_entweight then
							solvesub_entweight=val(ui_editbox_gettext(editbox_main_entropyweight))
							select case solvesub_entweight
								case 0.25:solvesub_fastent=1
								case 0.5:solvesub_fastent=2
								case 0.75:solvesub_fastent=3
								case 1:solvesub_fastent=4
								case 1.5:solvesub_fastent=5
								case 2:solvesub_fastent=6
								case else:solvesub_fastent=0
							end select
							ui_listbox_replacestring(list_optionssolver,i,s+": "+str(solvesub_entweight))
							normalize_ngramfactor
						end if
					end if
					'---------------------------------------------------------------
					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",4,1,threads) 'stop solver
					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",2,1,threads) 'stop thread
					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",1,1,threads) 'start thread
					sleep 25
					thread_ptr(threadsmax+1)=threadcreate(@thread_solve_units,0)
				end if
			else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
			end if
		else ui_editbox_settext(output_text,soi)
		end if
	end if