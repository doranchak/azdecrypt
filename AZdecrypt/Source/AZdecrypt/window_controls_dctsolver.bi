case button_dct_batchciphers
	if msg.message=wm_lbuttondown then
		solvesub_dct_batchciphers=1
		if task_active<>"none" then stop_current_task
		set_solverhighlight("Double columnar transposition")
		sleep 100
		if len(solver_file_name_ngrams)>0 then
			if task_active="none" then
				solvesub_nosub=0
				toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",4,1,threads) 'stop solver
				toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",2,1,threads) 'stop thread
				toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",1,1,threads) 'start thread
				sleep 10
				thread_ptr(threadsmax+1)=threadcreate(@thread_solve_dct,0)
			end if
		else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
		end if
	end if