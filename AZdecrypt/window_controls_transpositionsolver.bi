case button_transpostionsolver_add
	if msg.message=wm_lbuttondown then
		dim as integer selec=ui_listbox_getcursel(list_transpositionsolver_operations)
		if selec>-1 then
			e=0
			for i=0 to 100
				if ui_listbox_gettext(list_transpositionsolver_stack,i)=ui_listbox_gettext(list_transpositionsolver_operations,selec) then
					e=1
					exit for
				end if
			next i
			if e=0 then ui_listbox_addstring(list_transpositionsolver_stack,ui_listbox_gettext(list_transpositionsolver_operations,selec))
		end if
	end if
	
case button_transpostionsolver_addall
	if msg.message=wm_lbuttondown then
		for i=0 to 100	
			e=0
			for j=0 to 100
				if ui_listbox_gettext(list_transpositionsolver_stack,j)=ui_listbox_gettext(list_transpositionsolver_operations,i) then
					e=1
					exit for
				end if
			next j
			if e=0 then ui_listbox_addstring(list_transpositionsolver_stack,ui_listbox_gettext(list_transpositionsolver_operations,i))
		next i
	end if

case button_transpostionsolver_remove
	if msg.message=wm_lbuttondown then
		dim as integer selec=ui_listbox_getcursel(list_transpositionsolver_stack)
		if selec>-1 then
			ui_listbox_deletestring(list_transpositionsolver_stack,selec)
		end if
	end if
	
case button_transpostionsolver_removeall
	if msg.message=wm_lbuttondown then
		dim as integer selec=ui_listbox_getcursel(list_transpositionsolver_stack)
		for i=0 to 100
			ui_listbox_deletestring(list_transpositionsolver_stack,0)
		next i
	end if
	
'case button_transpostionsolver_start
'	if msg.message=wm_lbuttondown then
'		soi=string_to_info(ui_editbox_gettext(input_text))
'		if soi="Ok" then
'			if ui_listbox_gettext(list_transpositionsolver_stack,0)="" then 'if no op in stack then add all
'				for i=0 to 100
'					e=0
'					for j=0 to 100
'						if ui_listbox_gettext(list_transpositionsolver_stack,j)=ui_listbox_gettext(list_transpositionsolver_operations,i) then
'							e=1
'							exit for
'						end if
'					next j
'					if e=0 then ui_listbox_addstring(list_transpositionsolver_stack,ui_listbox_gettext(list_transpositionsolver_operations,i))
'				next i
'			end if
'			if task_active<>"none" then stop_current_task
'			if solvesub_nosub=0 then set_solverhighlight("substitution + simple transposition") else set_solverhighlight("simple transposition")
'			sleep 100
'			if len(solver_file_name_ngrams)>0 then
'				if task_active="none" then
'					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",4,1,threads) 'stop solver
'					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",2,1,threads) 'stop thread
'					toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",1,1,threads) 'start thread
'					sleep 10
'					thread_ptr(threadsmax+1)=threadcreate(@thread_solve_simpletransposition,0)
'				end if
'			else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
'			end if
'		else ui_editbox_settext(output_text,soi)
'		end if
'	end if
	
case button_transpostionsolver_batchciphers1
	if msg.message=wm_lbuttondown then
		solvesub_transpositionbatchciphers=1
		if ui_listbox_gettext(list_transpositionsolver_stack,0)="" then 'if no op in stack then add all
			for i=0 to 100
				e=0
				for j=0 to 100
					if ui_listbox_gettext(list_transpositionsolver_stack,j)=ui_listbox_gettext(list_transpositionsolver_operations,i) then
						e=1
						exit for
					end if
				next j
				if e=0 then ui_listbox_addstring(list_transpositionsolver_stack,ui_listbox_gettext(list_transpositionsolver_operations,i))
			next i
		end if
		if task_active<>"none" then stop_current_task
		set_solverhighlight("substitution + simple transposition")
		sleep 100
		if len(solver_file_name_ngrams)>0 then
			if task_active="none" then
				solvesub_nosub=0
				toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",4,1,threads) 'stop solver
				toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",2,1,threads) 'stop thread
				toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",1,1,threads) 'start thread
				sleep 10
				thread_ptr(threadsmax+1)=threadcreate(@thread_solve_simpletransposition,0)
			end if
		else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
		end if
	end if
	
case button_transpostionsolver_batchciphers2
	if msg.message=wm_lbuttondown then
		solvesub_transpositionbatchciphers=1
		if ui_listbox_gettext(list_transpositionsolver_stack,0)="" then 'if no op in stack then add all
			for i=0 to 100
				e=0
				for j=0 to 100
					if ui_listbox_gettext(list_transpositionsolver_stack,j)=ui_listbox_gettext(list_transpositionsolver_operations,i) then
						e=1
						exit for
					end if
				next j
				if e=0 then ui_listbox_addstring(list_transpositionsolver_stack,ui_listbox_gettext(list_transpositionsolver_operations,i))
			next i
		end if
		if task_active<>"none" then stop_current_task
		set_solverhighlight("simple transposition")
		sleep 100
		if len(solver_file_name_ngrams)>0 then
			if task_active="none" then
				solvesub_nosub=1
				toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",4,1,threads) 'stop solver
				toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",2,1,threads) 'stop thread
				toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",1,1,threads) 'start thread
				sleep 10
				thread_ptr(threadsmax+1)=threadcreate(@thread_solve_simpletransposition,0)
			end if
		else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
		end if
	end if