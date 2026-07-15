case button_main_process
	if msg.message=wm_lbuttondown then
		soi=string_to_info(ui_editbox_gettext(input_text),constcip)
		dim as byte bypass=0
		if ui_listbox_gettext(list_main,ui_listbox_getcursel(list_main))="Substitution + crib grid" andalso wc_windowup=1 then bypass=1 'soi="Ok" 'exception
		if ui_listbox_gettext(list_main,ui_listbox_getcursel(list_main))="Substitution + simple transposition" andalso ts_windowup=0 then bypass=1 'soi="Ok" 'exception '???
		if ui_listbox_gettext(list_main,ui_listbox_getcursel(list_main))="Substitution + simple transposition" andalso wc_windowup=1 andalso ui_checkbox_getcheck(checkbox_transpostionsolver_tpmatrix)=1 then bypass=1 'soi="Ok" 'exception
		if soi="Ok" or bypass=1 then 'if cipher is ok
			if info_symbols>1 or bypass=1 then 'symbol check
				if task_active<>"none" then stop_current_task 'stop current task
				sleep 25
				if len(solver_file_name_ngrams)>0 then 'if letter n-grams are ok
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
						solvesub_nosub=0
						if solverexist=1 then
							select case ui_listbox_gettext(list_main,ui_listbox_getcursel(list_main))
								case "Non-substitution"
									solvesub_nosub=1
									thread_ptr(threadsmax+1)=threadcreate(@thread_solve_nosub,0)
								case "Substitution","Substitution + sequential homophones","Higher-order homophonic",_
									"Substitution + sparse polyalphabetism","Substitution (test)"
									thread_ptr(threadsmax+1)=threadcreate(@thread_solve_substitution,0)
								case "Substitution + crib grid","Bigram substitution","Substitution + monoalphabetic groups",_
									"Bigram substitution (6,8,10)"
									dim as byte prev_solvesub_cribgridinstance=solvesub_cribgridinstance
									select case ui_listbox_gettext(list_main,ui_listbox_getcursel(list_main))
										case "Substitution + crib grid":solvesub_cribgridinstance=0
										case "Bigram substitution":solvesub_cribgridinstance=1
										case "Bigram substitution (6,8,10)"::solvesub_cribgridinstance=1
										'case "Bigram substitution 2":solvesub_cribgridinstance=1
										case "Substitution + monoalphabetic groups":solvesub_cribgridinstance=2
									end select
									e=1
									for i=1 to constcip
										if info(i)<>info2(i) then
											e=0
											exit for
										end if
									next i
									if wc_windowup=0 or prev_solvesub_cribgridinstance<>solvesub_cribgridinstance or e=0 then
										dim as long wc_x0,wc_y0,wc_x1,wc_y1
										if e=0 then ui_window_getposition(window_cribs,wc_x0,wc_y0,wc_x1,wc_y1) else ui_window_getposition(window_main,wc_x0,wc_y0,wc_x1,wc_y1)
										create_window_cribgrid(wc_x0,wc_y0,1)
									else
										thread_ptr(threadsmax+1)=threadcreate(@thread_solve_cribgrid,0)
									end if
								case "Substitution + verbose"
									if sv_windowup=0 then
										create_window_verbose
									else
										if ui_checkbox_getcheck(checkbox_verbose_ambiguous)=0 then
											thread_ptr(threadsmax+1)=threadcreate(@thread_solve_verbose,0)
										else
											thread_ptr(threadsmax+1)=threadcreate(@thread_solve_verbose_ambiguous,0)
										end if
									end if
								case "Columnar transposition","Columnar rearrangement","Row rearrangement","Grid rearrangement","Roche's first method",_
									"Variable row rearrangement"
									if cl_windowup=0 then
										create_window_permutations
									else
										solvesub_nosub=1
										thread_ptr(threadsmax+1)=threadcreate(@thread_solve_permutations,0)
									end if
								case "Double columnar transposition"
									if dct_windowup=0 then
										create_window_dct
									else
										solvesub_nosub=1
										thread_ptr(threadsmax+1)=threadcreate(@thread_solve_dct,0)
									end if
								case "Periodic transposition"
									if pt_windowup=0 then
										create_window_rules
									else
										solvesub_nosub=1
										if ui_editbox_gettext(editbox_rules_manual)="" then
											thread_ptr(threadsmax+1)=threadcreate(@thread_solve_rules,0)
										else
											thread_ptr(threadsmax+1)=threadcreate(@thread_solve_rules_manual,0)
										end if
									end if
								case "Periodic transposition [auto]","Periodic transposition inverted [auto]"
									solvesub_nosub=1
									thread_ptr(threadsmax+1)=threadcreate(@thread_solve_rules_manual,0)
								case "Substitution + columnar transposition","Substitution + columnar rearrangement",_
									"Substitution + nulls and skips","Nulls and skips"
									select case ui_listbox_gettext(list_main,ui_listbox_getcursel(list_main))
										case "Substitution + columnar rearrangement"
											genhc_mode="columnar rearrangement"
										case "Substitution + columnar transposition"
											genhc_mode="columnar transposition"
										case "Substitution + nulls and skips"
											genhc_mode="nulls and skips"
										case "Nulls and skips"
											genhc_mode="nulls and skips"
											solvesub_nosub=1
									end select
									thread_ptr(threadsmax+1)=threadcreate(@thread_solve_genhc,0)
								'case "Bigram substitution 2"
								'	thread_ptr(threadsmax+1)=threadcreate(@thread_solve_substitution,0)
								case "Substitution + row bound"
									thread_ptr(threadsmax+1)=threadcreate(@thread_solve_rowbound,0)
								case "Substitution + row bound fragments"
									thread_ptr(threadsmax+1)=threadcreate(@thread_solve_rowbound_fragments,0)
								case "Substitution + polyphones"
									if pp_windowup=0 then
										create_window_polyphones
										get_symbols(1)
										ui_listbox_setcursel(list_polyphones_stl,0)
									else
										if ui_radiobutton_getcheck(radiobutton_polyphones_user)=1 then thread_ptr(threadsmax+1)=threadcreate(@thread_solve_polyphones_user,0)
										if ui_radiobutton_getcheck(radiobutton_polyphones_auto)=1 then thread_ptr(threadsmax+1)=threadcreate(@thread_solve_polyphones_auto,0)
										if ui_radiobutton_getcheck(radiobutton_polyphones_hafer1)=1 then thread_ptr(threadsmax+1)=threadcreate(@thread_solve_polyphones_hafer,0)
										if ui_radiobutton_getcheck(radiobutton_polyphones_hafer2)=1 then thread_ptr(threadsmax+1)=threadcreate(@thread_solve_polyphones_hafer,0)
									end if
								case "Manual polyalphabetic"
									if mp_windowup=0 then
										create_window_manualpoly
										'get_symbols(2)
										dim as string tempstring001
										for i=0 to ngram_alphabet_size-1
											tempstring001+=chr(alphabet(i))
										next i
										for i=1 to info_symbols
											mp_letters(i)=tempstring001
										next i
										get_symbols(2)
										ui_listbox_setcursel(list_manualpoly_stl,0)
									else
										thread_ptr(threadsmax+1)=threadcreate(@thread_solve_manualpoly,0)
									end if
								case "Substitution + simple transposition","Simple transposition"
									if ui_listbox_gettext(list_main,ui_listbox_getcursel(list_main))="Simple transposition" then solvesub_nosub=1
									if ts_windowup=0 then
										create_window_transpositionsolver
									else
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
										thread_ptr(threadsmax+1)=threadcreate(@thread_solve_simpletransposition,0)
									end if
								case "Substitution + vigenère"
									thread_ptr(threadsmax+1)=threadcreate(@thread_solve_vigenere,0)
								case "Substitution + vigenère word list"
									thread_ptr(threadsmax+1)=threadcreate(@thread_solve_vigenerelist,0)
								case "Substitution + crib list"
									thread_ptr(threadsmax+1)=threadcreate(@thread_solve_criblist,0)
								case "Substitution + units"
									if un_windowup=0 then
										create_window_units
									else
										thread_ptr(threadsmax+1)=threadcreate(@thread_solve_units,0)
									end if
								case "Merge sequential homophones"
									thread_ptr(threadsmax+1)=threadcreate(@thread_solve_mergeseqhom,0)
								case "Multiple caesar shifts"
									solvesub_nosub=1
									thread_ptr(threadsmax+1)=threadcreate(@thread_solve_caesarshifts,0)
								case "Find words"
									'solvesub_nosub=1
									if fw_windowup=0 then
										create_window_findwords
									else
										thread_ptr(threadsmax+1)=threadcreate(@thread_solve_findwords,0)
									end if
							end select
						end if
					end if
				else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
				end if
			else ui_editbox_settext(output_text,"Error: cipher must have at least two unique symbols")
			end if
		else ui_editbox_settext(output_text,soi)
		end if
	end if