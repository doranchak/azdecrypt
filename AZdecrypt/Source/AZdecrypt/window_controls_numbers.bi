case button_numbers_process
	if msg.message=wm_lbuttondown then
		'soi=string_to_info(ui_editbox_gettext(input_text),constcip)
		'if soi="Ok" then
			if task_active<>"none" then stop_current_task
			if task_active="none" then
				toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",4,1,threads) 'stop solver
				toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",2,1,threads) 'stop thread
				toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",1,1,threads) 'start thread
				sleep 10
				thread_ptr(threadsmax+1)=threadcreate(@thread_numbers,0)
			end if	
		'end if
	end if