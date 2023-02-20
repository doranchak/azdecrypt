case button_cribs_solve
	if msg.message=wm_lbuttondown then
		'soi=string_to_info(ui_editbox_gettext(input_text),constcip)
		'if soi="Ok" then
			if task_active<>"none" then stop_current_task
			if len(solver_file_name_ngrams)>0 then
				e=1
				for i=1 to constcip
					if info(i)<>info2(i) then
						e=0
						exit for
					end if
				next i
				if e=0 then
					dim as long wc_x0,wc_y0,wc_x1,wc_y1
					ui_window_getposition(window_cribs,wc_x0,wc_y0,wc_x1,wc_y1)
					create_window_cribgrid(wc_x0,wc_y0,1)
				end if
				select case solvesub_cribgridinstance
					case 0:set_solverhighlight("substitution + crib grid")
					case 1:set_solverhighlight("bigram substitution")
					case 2:set_solverhighlight("substitution + monoalphabetic groups")
				end select
				sleep 100
				if task_active="none" then
					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",4,1,threads) 'stop solver
					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",2,1,threads) 'stop thread
					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",1,1,threads) 'start thread
					sleep 10
					thread_ptr(threadsmax+1)=threadcreate(@thread_solve_cribgrid,0)
				end if
			else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
			end if
		'else ui_editbox_settext(output_text,soi)
		'end if
	end if

case button_cribs_clear
	if msg.message=wm_lbuttondown then
		for y=1 to wc_dy
			for x=1 to wc_dx
				wc_pgrid(0,x,y)=""
				ui_editbox_settext(wc_cribs(x,y),"")
			next x
		next y
	end if

case button_cribs_reload
	if msg.message=wm_lbuttondown then
		soi=string_to_info(ui_editbox_gettext(input_text),constcip)
		if soi="Ok" then
			if task_active<>"none" then stop_current_task
			if len(solver_file_name_ngrams)>0 then
				sleep 100
				if task_active="none" then
					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",4,1,threads) 'stop solver
					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",2,1,threads) 'stop thread
					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",1,1,threads) 'start thread
					sleep 10
					dim as long wc_x0,wc_y0,wc_x1,wc_y1
					ui_window_getposition(window_cribs,wc_x0,wc_y0,wc_x1,wc_y1)
					create_window_cribgrid(wc_x0,wc_y0,1)
				end if
			else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
			end if
		else ui_editbox_settext(output_text,soi)
		end if
	end if