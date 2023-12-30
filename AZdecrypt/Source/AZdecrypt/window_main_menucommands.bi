select case msg.message
	case wm_command 'menu commands
		select case msg.wparam
			case 1
     			file_load()
			case 2
				file_save()
			case 3  
				file_save_as()
			case 4
				exit_prog=1
			case 5 
				create_window_dimension
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					get_native_dimensions
				'else ui_editbox_settext(output_text,soi)
				end if
			case 6 'symbols
				create_window_symbols
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then 
					get_symbols(0)
					ui_listbox_setcursel(list_symbols_ngrams,0)
				'else ui_editbox_settext(output_text,soi)
				end if			
			case 7 'directions
				create_window_transposition
			case 8 'convert to numbers
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					info_numerical=1
					ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0))
				else ui_editbox_settext(output_text,soi)
				end if	
			case 9 'convert to symbols
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					for i=1 to info_length
						if info(i)>255 then
							ui_editbox_settext(output_text,"Error: number to ASCII mismatch")
							exit select
						end if
						if info(i)<32 then 
							ui_editbox_settext(output_text,"Error: number to ASCII mismatch")
							exit select
						end if
						if ascii_table(info(i))>0 then
							ui_editbox_settext(output_text,"Error: number to ASCII mismatch")
							exit select
						end if
					next i
					info_numerical=0
					ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 10 'convert to random symbols
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					if info_symbols<215 then '<-------------------------------------------------------- ok???
						dim as integer tmp1(info_symbols)
						j=0
						for i=1 to info_symbols
							do
								j+=1
							loop until ascii_table(j)=0 or j=256
							tmp1(i)=j
							if j=256 then ui_editbox_settext(output_text,"Error: number to ASCII mismatch")	
						next i
						for i=1 to info_symbols*sqr(info_symbols)
							swap tmp1(int(rnd*info_symbols)+1),tmp1(int(rnd*info_symbols)+1)
						next i
						for i=1 to info_length
							nuba(i)=tmp1(nuba(i))
						next i
						info_numerical=0
						ui_editbox_settext(input_text,info_to_string(nuba(),info_length,info_x,info_y,info_numerical,0,0))
					else ui_editbox_settext(output_text,"Error: number to ASCII mismatch")
					end if
				else ui_editbox_settext(output_text,soi)
				end if
			case 11 'number by appearance
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					info_numerical=1
					ui_editbox_settext(input_text,info_to_string(nuba(),info_length,info_x,info_y,info_numerical,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 12 'solver options
				create_window_optionssolver
			case 13 'benchmark
				if task_active<>"none" then stop_current_task
				sleep 10
				if len(solver_file_name_ngrams)>0 then
					if task_active="none" then
						sleep 10
						'thread_ptr(threadsmax+1)=threadcreate(@thread_benchmark_ngrams,0)
						thread_ptr(threadsmax+1)=threadcreate(@thread_benchmark,0)
					end if
				else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
				end if
			case 14 'load n-grams
				s=""
				dim as string oldfilter=filter
				filter="N-gram files (*.txt/*.bin/*.gz)"+chr(0)+"*.txt;*.bin;*.gz"+chr(0)+"All files (*.*)"+chr(0)+"*.*"
				s=ui_loadsavedialog(0,"Open n-grams",filter,1,basedir+"\N-grams\")
				filter=oldfilter
				if len(s)>0 then
					if task_active<>"none" then stop_current_task
					sleep 10
					if task_active="none" then
						toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",4,1,threads)
						toggle_solverthreads(empty(),0,0,0,0,basedir+"\Output\",2,1,threads)
						solvesub_ngramloctemp=s
						sleep 10
						thread_ptr(threadsmax+1)=threadcreate(@thread_load_ngrams,0)
					end if
				end if
			case 15 'unispace
				dim as integer ml=0
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if unispacing=1 then
					unispacing=0
					ui_modifymenu(hedit,15,MF_UNCHECKED,15,"Unispace numerical")
					ui_drawmenubar(window_main)
				else 
					unispacing=1
					ui_modifymenu(hedit,15,MF_CHECKED,15,"Unispace numerical")
					ui_drawmenubar(window_main)
				end if
				if soi="Ok" then
					ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0))
				'else ui_editbox_settext(output_text,soi)
				end if
			case 16 'batch ciphers (substitution)
				if task_active<>"none" then stop_current_task
				sleep 10
				if len(solver_file_name_ngrams)>0 then
					if task_active="none" then
						sleep 10
						thread_ptr(threadsmax+1)=threadcreate(@thread_batch_ciphers_substitution,0)
					end if
				else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
				end if
			case 17 'rearrange asequentially
				dim as integer e
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					dim as long seqout(info_length)
					dim as short maprs(info_symbols,1)
					for i=1 to info_length
						maprs(nuba(i),0)+=1
						maprs(nuba(i),1)=info(i)
					next i
					do
						e=0
						for i=1 to info_symbols-1
							if maprs(i,0)<maprs(i+1,0) then
								e=1
								swap maprs(i,0),maprs(i+1,0)
								swap maprs(i,1),maprs(i+1,1)
							end if
						next i
					loop until e=0
					e=0
					for i=1 to info_symbols
						for j=1 to maprs(i,0)
							e+=1
							seqout(e)=maprs(i,1)
						next j
					next i
					ui_editbox_settext(input_text,info_to_string(seqout(),info_length,info_x,info_y,info_numerical,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 18 'combine
				combine_stacksize=0
				erase combine_stack
				create_window_combine
			case 19 'randomize positions
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					for i=1 to 1000000 'info_length^2
						swap info(int(rnd*info_length)+1),info(int(rnd*info_length)+1)
					next i
					ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0))
				else ui_editbox_settext(output_text,soi)
				end if				
			case 20 'manipulate
				create_window_manipulation
			case 21 'bias letter n-grams
				if task_active<>"none" then stop_current_task
				if len(solver_file_name_ngrams)>0 then
					sleep 10
					if task_active="none" then
						thread_ptr(threadsmax+1)=threadcreate(@thread_load_ngrambias,0)
					end if
				else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
				end if
			case 22 'batch letter n-grams
				soi=string_to_info(ui_editbox_gettext(input_text),constcip)	
				if soi="Ok" then
					if task_active<>"none" then stop_current_task
					sleep 10 
					if task_active="none" then
						sleep 10
						thread_ptr(threadsmax+1)=threadcreate(@thread_batch_ngrams_substitution,0)
					end if
				else ui_editbox_settext(output_text,soi)
				end if
			case 23 'convert to lowercase
				'soi=string_to_info(ui_editbox_gettext(input_text))
				'if soi="Ok" then
					ui_editbox_settext(input_text,lcase(ui_editbox_gettext(input_text)))
				'else ui_editbox_settext(output_text,soi)
				'end if
			case 24 'convert to lowercase
				'soi=string_to_info(ui_editbox_gettext(input_text))
				'if soi="Ok" then
					ui_editbox_settext(input_text,ucase(ui_editbox_gettext(input_text)))
				'else ui_editbox_settext(output_text,soi)
				'end if
			case 25 'remove line breaks
				'soi=string_to_info(ui_editbox_gettext(input_text))
				'if soi="Ok" then
					dim as string text2=""
					dim as string text1=ui_editbox_gettext(input_text)
					for i=1 to len(text1)
						select case asc(text1,i)
							case 10,13
							case else
								text2+=chr(asc(text1,i))
						end select		
					next i
					ui_editbox_settext(input_text,text2)
				'else ui_editbox_settext(output_text,soi)
				'end if
			case 26 'remove numbers
				'soi=string_to_info(ui_editbox_gettext(input_text))
				'if soi="Ok" then
					dim as string text2=""
					dim as string text1=ui_editbox_gettext(input_text)
					for i=1 to len(text1)
						select case asc(text1,i)
							case 48 to 57
							case else
								text2+=chr(asc(text1,i))
						end select		
					next i
					ui_editbox_settext(input_text,text2)
				'else ui_editbox_settext(output_text,soi)
				'end if
			case 27 'remove punct
				'soi=string_to_info(ui_editbox_gettext(input_text))
				'if soi="Ok" then
					dim as string text2=""
					dim as string text1=ui_editbox_gettext(input_text)
					for i=1 to len(text1)
						select case asc(text1,i)
							'case 65 to 90,97 to 122
							'	text2+=chr(asc(text1,i))
							case 33 to 47
							case 58 to 63
							case 91 to 96
							case 123 to 126
							case 145 to 148
							case 150,151,173 '–,­,—
							case 133 '…
							case asc("@")
							case else:text2+=chr(asc(text1,i))
						end select		
					next i
					ui_editbox_settext(input_text,text2)
				'else ui_editbox_settext(output_text,soi)
				'end if
			case 28 'remove spaces
				'soi=string_to_info(ui_editbox_gettext(input_text))
				'if soi="Ok" then
					dim as string text2=""
					dim as string text1=ui_editbox_gettext(input_text)
					for i=1 to len(text1)
						select case asc(text1,i)
							case 32
							case else
								text2+=chr(asc(text1,i))
						end select		
					next i
					ui_editbox_settext(input_text,text2)
				'else ui_editbox_settext(output_text,soi)
				'end if
			case 29 'randomize row order
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					dim as double arg(10)
					for i=1 to info_length
						cstate(1,i)=info(i)
					next i
					arg(1)=info_length
					arg(2)=info_symbols
					arg(3)=info_x
					arg(4)=info_y
					cstate_operation(1,2,"Randomize row order",arg())
					for i=1 to info_length
						info(i)=cstate(2,i)
					next i
					ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 30 'randomize column order
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					dim as double arg(10)
					for i=1 to info_length
						cstate(1,i)=info(i)
					next i
					arg(1)=info_length
					arg(2)=info_symbols
					arg(3)=info_x
					arg(4)=info_y
					cstate_operation(1,2,"Randomize column order",arg())
					for i=1 to info_length
						info(i)=cstate(2,i)
					next i
					ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 31 'add row and column numbers
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					dim as integer sbc=0						 
					dim as string sout=""
					if info_numerical=0 then
						sbc=len(str(info_x))+1
						sout+="    "
						for i=1 to info_x
							sout+=str(i)
							if i<>info_x then sout+=space(sbc-len(str(i)))
						next i
						sout+=lb
						k=0
						for i=1 to info_y
							sout+=lb
							sout+=str(i)
							sout+=space(4-len(str(i)))
							for j=1 to info_x
								k+=1
								sout+=chr(info(k))
								if j<>info_x then sout+=space(sbc-1)
							next j
						next i
					else
						for i=1 to info_length
							if len(str(info(i)))+1>sbc then sbc=len(str(info(i)))+1		
						next i
						sout+="    "
						for i=1 to info_x
							sout+=str(i)
							if i<>info_x then sout+=space(sbc-len(str(i)))
						next i
						sout+=lb
						k=0
						for i=1 to info_y
							sout+=lb
							sout+=str(i)
							sout+=space(4-len(str(i)))
							for j=1 to info_x
								k+=1
								sout+=str(info(k))
								if j<>info_x then sout+=space(sbc-len(str(info(k))))
							next j
						next i
					end if
					ui_editbox_settext(input_text,sout)
				else ui_editbox_settext(output_text,soi)
				end if
			case 32 'convert tabs to spaces
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 33 'create transposition matrix
				create_window_creatematrix(0,0)
			case 34 'open file to output window
				file_load2()
			case 35 'offset rows top-to-bottom
				dim as string con=ui_editbox_gettext(input_text)
				dim as string conout=""
				soi=string_to_info(con,constcip2)
				if info_numerical=1 then exit select
				j=0
				if soi="Ok" then
					for i=1 to len(con)
						conout+=chr(asc(con,i))
						if asc(con,i)=10 andalso asc(con,i-1)=13 then
							j+=1
							conout+=space(j)
						end if
					next i
					ui_editbox_settext(input_text,conout)
				else ui_editbox_settext(output_text,soi)
				end if
			case 36 'offset rows bottom-to-top
				dim as string con=ui_editbox_gettext(input_text)
				dim as string conout=""
				dim as string conpart=""
				soi=string_to_info(con,constcip2)
				if info_numerical=1 then exit select
				j=0
				k=0
				if soi="Ok" then
					for i=1 to len(con)
						if asc(con,i)<>10 andalso asc(con,i)<>13 then j+=1
						if asc(con,i+1)=13 andalso asc(con,i+2)=10 then
							k+=1
							j=0
						end if
					next i
					if j>0 then k+=1
					j=0
					for i=1 to len(con)
						conpart+=chr(asc(con,i))
						if asc(con,i)=10 or i=len(con) then
							j+=1
							conout+=space(k-j)
							conout+=conpart
							conpart=""
						end if
					next i
					ui_editbox_settext(input_text,conout)
				else ui_editbox_settext(output_text,soi)
				end if
			case 37 'remove diacritics
				ui_editbox_settext(input_text,remove_diacritics(ui_editbox_gettext(input_text)))
			case 38 'ascii distance
				dim as string cv=ui_editbox_gettext(input_text)
				soi=string_to_info(cv,constcip)
				if soi="Ok" then
					for i=1 to info_length-1
						info(i)=info(i+1)-info(i)
						'info(i)=abs(info(i+1)-info(i))
					next i
					ui_editbox_settext(input_text,info_to_string(info(),info_length-1,info_x,info_y,1,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 39 'square with spaces
				dim as string con=ui_editbox_gettext(input_text)
				dim as string conout=""
				soi=string_to_info(con,constcip2)
				if info_numerical=1 then exit select
				j=0
				k=0
				if soi="Ok" then
					for i=1 to len(con)
						if asc(con,i)<>10 andalso asc(con,i)<>13 then j+=1
						if asc(con,i+1)=13 andalso asc(con,i+2)=10 then
							if j>k then k=j
							j=0
						end if
					next i
					if j>k then k=j
					j=0
					for i=1 to len(con)
						if asc(con,i)<>10 andalso asc(con,i)<>13 then j+=1
						conout+=chr(asc(con,i))
						if asc(con,i+1)=13 andalso asc(con,i+2)=10 then
							if k>j then conout+=space(k-j)
							j=0
						end if
					next i
					if j>0 andalso k>j then conout+=space(k-j)
					ui_editbox_settext(input_text,conout)
				else ui_editbox_settext(output_text,soi)
				end if
			case 40 'convert spaces to rows
				dim as string con=ui_editbox_gettext(input_text)
				dim as string conout=""
				dim as short sp=0,passedfirstchar=0
				soi=string_to_info(con,constcip2)
				j=0
				if soi="Ok" then
					for i=1 to len(con)
						if asc(con,i)<>32 andalso asc(con,i)<>10 andalso asc(con,i)<>13 then
							if sp=1 then 
								if passedfirstchar=1 then conout+=lb
								sp=0
							end if
							conout+=chr(asc(con,i))
							passedfirstchar=1
						end if
						if asc(con,i)=32 then sp=1
					next i
					ui_editbox_settext(input_text,conout)
				else ui_editbox_settext(output_text,soi)
				end if
			case 41 'convert rows to spaces
				dim as string con=ui_editbox_gettext(input_text)
				dim as string conout=""
				dim as short sp=0
				soi=string_to_info(con,constcip2)
				j=0
				if soi="Ok" then
					for i=1 to len(con)
						if asc(con,i)<>32 andalso asc(con,i)<>10 andalso asc(con,i)<>13 then
							if sp=1 then 
								conout+=" "
								sp=0
							end if
							conout+=chr(asc(con,i))
						end if
						if asc(con,i)=10 andalso asc(con,i-1)=13 then sp=1
					next i
					ui_editbox_settext(input_text,conout)
				else ui_editbox_settext(output_text,soi)
				end if
			case 42 'stat options
				create_window_optionsstats
			case 43 'rearrange sequentially
				dim as integer e
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					dim as long seqout(info_length)
					dim as short maprs(info_symbols,1)
					for i=1 to info_length
						maprs(nuba(i),0)+=1
						maprs(nuba(i),1)=info(i)
					next i
					do
						e=0
						for i=1 to info_symbols-1
							if maprs(i,0)<maprs(i+1,0) then
								e=1
								swap maprs(i,0),maprs(i+1,0)
								swap maprs(i,1),maprs(i+1,1)
							end if
						next i
					loop until e=0
					j=0
					do
						e=0
						for i=1 to info_symbols
							if maprs(i,0)>0 then
								e=1
								j+=1
								seqout(j)=maprs(i,1)
								maprs(i,0)-=1
							end if
						next i
					loop until e=0
					ui_editbox_settext(input_text,info_to_string(seqout(),info_length,info_x,info_y,info_numerical,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 44 'batch merge sequential homophones
				if task_active<>"none" then stop_current_task
				if len(solver_file_name_ngrams)>0 then
					sleep 100
					if task_active="none" then
						sleep 10
						thread_ptr(threadsmax+1)=threadcreate(@thread_batch_ciphers_mergeseqhom,0)
					end if
				else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
				end if
			case 45
				if task_active<>"none" then stop_current_task
				sleep 10 
				if task_active="none" then
					sleep 10
					thread_ptr(threadsmax+1)=threadcreate(@downscale_ngrams,0)
				end if
			case 47 'batch settings
				'if task_active<>"none" then stop_current_task
				if len(solver_file_name_ngrams)>0 then
					sleep 100
					if task_active="none" then
						sleep 10
						thread_ptr(threadsmax+1)=threadcreate(@thread_batch_settings,0)
					end if
				else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
				end if
				'if task_active<>"none" then stop_current_task
				'if len(solver_file_name_ngrams)>0 then
				'	sleep 100
				'	if task_active="none" then
				'		sleep 10
				'		thread_ptr(threadsmax+1)=threadcreate(@thread_batch_settings,0)
				'	end if
				'else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
				'end if
			case 48 'letter n-gram stats
				if len(solver_file_name_ngrams)>0 then
					#include "ngram_stats.bi"
				end if
			case 49 'convert to frequencies
				dim as string cv=ui_editbox_gettext(input_text)
				soi=string_to_info(cv,constcip2)
				if soi="Ok" then
					dim as short freq01(65536)
					erase freq01
					for i=1 to info_length
						freq01(info(i))+=1
					next i
					for i=1 to info_length
						info(i)=freq01(info(i))
					next i
					ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,1,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 50 'convert to symbol NBA
				dim as string cv=ui_editbox_gettext(input_text)
				soi=string_to_info(cv,constcip2)
				if soi="Ok" then
					dim as short snba(constcip2)
					erase snba
					for i=1 to info_length
						snba(nuba(i))+=1
						info(i)=snba(nuba(i))
					next i
					ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,1,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 51 'convert to intersymbol distances
				dim as string cv=ui_editbox_gettext(input_text)
				soi=string_to_info(cv,constcip2)
				if soi="Ok" then
					redim rep2(constcip2,constcip2)
					'dim as short snba(constcip2,constcip2)
					dim as short snba1(constcip2)
					erase snba1
					for i=1 to info_length
						rep2(nuba(i),0)+=1
						rep2(nuba(i),rep2(nuba(i),0))=i
					next i
					j=0
					erase info
					for i=1 to info_length
						snba1(nuba(i))+=1
						if snba1(nuba(i))<rep2(nuba(i),0) then
							j+=1
							info(j)=rep2(nuba(i),snba1(nuba(i))+1)-rep2(nuba(i),snba1(nuba(i)))
						end if
					next i
					info_length=j
					ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,1,0,0))
					redim rep2(0,0)
				else ui_editbox_settext(output_text,soi)
				end if
			case 52 'convert to incremental map
				dim as string cv=ui_editbox_gettext(input_text)
				soi=string_to_info(cv,constcip2)
				if soi="Ok" then
					for i=1 to info_length-1
						select case info(i)
							case is<info(i+1):info(i)=asc("*")
							case is>info(i+1):info(i)=asc(".")
							case is=info(i+1):info(i)=asc("=")
						end select
					next i
				else ui_editbox_settext(output_text,soi)	
				end if
				ui_editbox_settext(input_text,info_to_string(info(),info_length-1,info_x,info_y,0,0,0))
			case 53 'generate unique substrings
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)	
				if soi="Ok" then
					if task_active<>"none" then stop_current_task
					sleep 10 
					if task_active="none" then
						sleep 10
						thread_ptr(threadsmax+1)=threadcreate(@generate_substrings,0)
					end if
				else ui_editbox_settext(output_text,soi)
				end if
			case 54 'output letter n-grams to binary
				if task_active<>"none" then stop_current_task
				sleep 10 
				if task_active="none" then
					sleep 10
					thread_ptr(threadsmax+1)=threadcreate(@output_ngrams_binary,0)
				end if
			case 55 'convert 2 symbols to 1 number
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					dim as short symn(info_symbols,info_symbols),news=0
					dim as long ncip(info_length)
					dim as string os
					'erase symn
					j=0
					for i=1 to info_length step 2
						j+=1
						if symn(nuba(i),nuba(i+1))=0 then
							news+=1
							symn(nuba(i),nuba(i+1))=news
						end if
						ncip(j)=symn(nuba(i),nuba(i+1))
					next i
					ui_editbox_settext(input_text,info_to_string(ncip(),j,info_x,info_y,1,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 56 'convert 3 symbols to 1 number	
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					dim as short symn(info_symbols,info_symbols,info_symbols),news=0
					dim as long ncip(info_length)
					dim as string os
					'erase symn
					j=0
					for i=1 to info_length step 3
						j+=1
						if symn(nuba(i),nuba(i+1),nuba(i+2))=0 then
							news+=1
							symn(nuba(i),nuba(i+1),nuba(i+2))=news
						end if
						ncip(j)=symn(nuba(i),nuba(i+1),nuba(i+2))
					next i
					ui_editbox_settext(input_text,info_to_string(ncip(),j,info_x,info_y,1,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 57 'convert symbols inbetween spaces to numbers
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					dim as string con=ui_editbox_gettext(input_text)+" "
					'dim as short symn(constcip2,constcip2+1)
					redim rep2(constcip2,constcip2+1)
					dim as short seq(constcip2),news=0,nl=0
					dim as long ncip(constcip2)
					j=0:e=0
					'erase symn,seq,ncip
					for i=1 to len(con)
						select case asc(con,i)
							case 10,13,32 'space or line break
								if j>0 then
									for k=1 to news
										e=1
										if rep2(k,1)=j then
											for h=1 to j
												if rep2(k,h+1)<>seq(h) then
													e=0
													exit for
												end if
											next h
										else
											e=0
										end if
										if e=1 then exit for
									next k
									if e=0 then
										news+=1
										rep2(news,0)=news 'nba
										rep2(news,1)=j 'length
										for h=1 to j
											rep2(news,h+1)=seq(h)
										next h
										k=news
									end if
									nl+=1
									ncip(nl)=rep2(k,0)
									j=0
								end if
							case else
								j+=1
								seq(j)=asc(con,i)
						end select
					next i
					ui_editbox_settext(input_text,info_to_string(ncip(),nl,info_x,info_y,1,0,0))
					redim rep2(0,0)
				else ui_editbox_settext(output_text,soi)
				end if
			case 58 'add spaces to plaintext
				if addspaces_ngrams=1 then
					soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
					if soi="Ok" then
						if info_numerical=0 then
							dim as long txt(constcip2)
							j=0
							for i=1 to info_length
								select case info(i)
									case 65 to 90
										j+=1
										txt(j)=info(i)
									case 97 to 122
										j+=1
										txt(j)=info(i)-32
								end select
							next i
							if j>4 then 'letter 5-grams
								ui_editbox_settext(input_text,info_to_string(txt(),j,info_x,info_y,0,2,0))
							else ui_editbox_settext(output_text,"Error: input does not have enough plaintext letters")
							end if
						else ui_editbox_settext(output_text,"Error: input cannot be numerical")
						end if
					else ui_editbox_settext(output_text,soi)
					end if
				else ui_editbox_settext(output_text,"Error: internal spacing letter n-grams not found")
				end if
			case 59 'remove lowercase letters
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					j=0
					dim as long txt(info_length)
					for i=1 to info_length
						select case info(i)
							case 97 to 122
							case else
								j+=1
								txt(j)=info(i)
						end select
					next i
					ui_editbox_settext(input_text,info_to_string(txt(),j,info_x,info_y,0,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 60 'remove uppercase letters
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					j=0
					dim as long txt(info_length)
					for i=1 to info_length
						select case info(i)
							case 65 to 90
							case else
								j+=1
								txt(j)=info(i)
						end select
					next i
					ui_editbox_settext(input_text,info_to_string(txt(),j,info_x,info_y,0,0,0))
				else ui_editbox_settext(output_text,soi)
				end if
			case 61 'batch ciphers (non-substitution)
				if task_active<>"none" then stop_current_task
				sleep 10
				if len(solver_file_name_ngrams)>0 then
					if task_active="none" then
						sleep 10
						solvesub_nosub=1
						thread_ptr(threadsmax+1)=threadcreate(@thread_batch_ciphers_substitution,0)
					end if
				else ui_editbox_settext(output_text,"Error: no letter n-grams loaded")
				end if
			case 62 'period map
				dim as string num,cv=ui_editbox_gettext(input_text)+" "
				s="":j=0:info_x=0
				dim as integer minus,steps=format_periodmapsteps
				for i=0 to len(cv)-1
					select case cv[i]
						case 48 to 57
							num+=chr(cv[i])
						case 13
							if info_x=0 then info_x=j
							if num<>"" then
								j+=1
								if minus=0 then
									info(j)=val(num)
								else
									info(j)=-val(num)
									minus=0
								end if
								num=""
							end if
						case 32
							if num<>"" then
								j+=1
								if minus=0 then
									info(j)=val(num)
								else
									info(j)=-val(num)
									minus=0
								end if
								num=""
							end if
						case 45
							minus=1
					end select
				next i
				if steps>j-steps then steps=j-steps
				for i=1 to j-steps
					info(i)=info(i+steps)-info(i)
				next i
				ui_editbox_settext(input_text,info_to_string(info(),j-steps,info_x,j,1,0,0))
			case 63 'period map 2
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if info_numerical=1 andalso info_symbols=info_length then
					dim as long map(info_length)
					for i=1 to info_length
						map(info(i))=i
					next i
					for i=1 to info_length-format_periodmapsteps 'step format_periodmapsteps
						info(i)=map(i+format_periodmapsteps)-map(i)
					next i
					ui_editbox_settext(input_text,info_to_string(info(),info_length-format_periodmapsteps,info_x,info_y,1,0,0))
				else ui_editbox_settext(output_text,"Error: input have to be unique numbers from 1 to "+str(info_length))
				end if
			case 64 'invert transposition matrix
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if info_numerical=1 andalso info_symbols=info_length then
					dim as long map(info_length)
					for i=1 to info_length
						map(info(i))=i
					next i
					for i=1 to info_length
						info(i)=map(i)
					next i
					ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,1,0,0))
				else ui_editbox_settext(output_text,"Error: input have to be unique numbers from 1 to "+str(info_length))
				end if
			case 65 'generate caesar shifts
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					if info_numerical=0 then
						generate_caesarshifts
					else
						ui_editbox_settext(output_text,"Error: input cannot be numerical")
					end if
				else ui_editbox_settext(output_text,soi)
				end if
			case 66 'output letter n-grams to text
				if task_active<>"none" then stop_current_task
				sleep 10
				if task_active="none" then
					sleep 10
					thread_ptr(threadsmax+1)=threadcreate(@output_ngrams_text,0)
				end if
			case 67 'generate nulls and skips
				soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
				if soi="Ok" then
					if task_active<>"none" then stop_current_task
					sleep 10 
					if task_active="none" then
						sleep 10
						thread_ptr(threadsmax+1)=threadcreate(@generate_nullsandskips,0)
					end if
				else ui_editbox_settext(output_text,soi)
				end if
			case 68 'generate skip n-grams
				if task_active<>"none" then stop_current_task
				sleep 10
				if task_active="none" then
					sleep 10
					thread_ptr(threadsmax+1)=threadcreate(@generate_skipngrams,0)
				end if
			case 69 'generate ciphers
				if task_active<>"none" then stop_current_task
				sleep 10
				if task_active="none" then
					sleep 10
					thread_ptr(threadsmax+1)=threadcreate(@generate_ciphers,0)
				end if
			case 100 to 300 'statsmenu
				soi=string_to_info(ui_editbox_gettext(input_text),constcip)
				if soi="Ok" then
					updatewindow(window_main)
					select case msg.wparam
						case 100:stats_unigrams
						case 101:stats_ngrams
						case 102:stats_encoding
						case 103:stats_periodic(1)
						case 104
							if thread_ptr(threadsmax+2)=0 then
								ui_editbox_settext(output_text,"Please wait..."+lb)
								thread_ptr(threadsmax+2)=threadcreate(@stats_keywordlength,0)
							else stop_measurement=1
							end if
						case 105
							if thread_ptr(threadsmax+2)=0 then
								ui_editbox_settext(output_text,"Please wait..."+lb)
								thread_ptr(threadsmax+2)=threadcreate(@stats_outputgraphs,0)
							else stop_measurement=1
							end if
						case 106
							if thread_ptr(threadsmax+2)=0 then
								stats_symbolcyclepatternscs=3:stats_symbolcyclepatternsfl=5
								thread_ptr(threadsmax+2)=threadcreate(@stats_compare_symbolcyclepatterns,0)
							else stop_measurement=1
							end if
						case 107
							if thread_ptr(threadsmax+2)=0 then
								ui_editbox_settext(output_text,"Please wait..."+lb)
								thread_ptr(threadsmax+2)=threadcreate(@stats_findrearrangement,0)
							else stop_measurement=1
							end if
						case 108
							if thread_ptr(threadsmax+2)=0 then
								thread_ptr(threadsmax+2)=threadcreate(@stats_compare_symbolcyclepatterns,0)
							else stop_measurement=1
							end if
						case 109
							if thread_ptr(threadsmax+2)=0 then
								ui_editbox_settext(output_text,"Please wait..."+lb)
								thread_ptr(threadsmax+2)=threadcreate(@stats_observations,0)
							else stop_measurement=1
							end if
						case 110:stats_hafershifts
						case 154:stats_transpositionmatrix
						case 155
							if thread_ptr(threadsmax+2)=0 then
								ui_editbox_settext(output_text,"Please wait..."+lb)
								thread_ptr(threadsmax+2)=threadcreate(@stats_alphabets,0)
							else stop_measurement=1
							end if
						case 156:stats_chi2
						case 200 to 250 'plaintext + encoding direction
							if thread_ptr(threadsmax+2)=0 then
								select case msg.wparam
									case 201 to 250:stats_direction_m=msg.wparam-200
								end select
								ui_editbox_settext(output_text,"Please wait..."+lb)
								thread_ptr(threadsmax+2)=threadcreate(@stats_direction,0)
							else stop_measurement=1
							end if
						case 251 to 280
							select case msg.wparam
								case 251:stats_symbolcyclepatternscs=2:stats_symbolcyclepatternsfl=2
								case 252:stats_symbolcyclepatternscs=2:stats_symbolcyclepatternsfl=3
								case 253:stats_symbolcyclepatternscs=2:stats_symbolcyclepatternsfl=4
								case 254:stats_symbolcyclepatternscs=2:stats_symbolcyclepatternsfl=5
								case 255:stats_symbolcyclepatternscs=2:stats_symbolcyclepatternsfl=6
								case 256:stats_symbolcyclepatternscs=2:stats_symbolcyclepatternsfl=7
								case 257:stats_symbolcyclepatternscs=2:stats_symbolcyclepatternsfl=8
								case 258:stats_symbolcyclepatternscs=2:stats_symbolcyclepatternsfl=9
								case 259:stats_symbolcyclepatternscs=2:stats_symbolcyclepatternsfl=10
								case 260:stats_symbolcyclepatternscs=3:stats_symbolcyclepatternsfl=2
								case 261:stats_symbolcyclepatternscs=3:stats_symbolcyclepatternsfl=3
								case 262:stats_symbolcyclepatternscs=3:stats_symbolcyclepatternsfl=4
								case 263:stats_symbolcyclepatternscs=3:stats_symbolcyclepatternsfl=5
								case 264:stats_symbolcyclepatternscs=3:stats_symbolcyclepatternsfl=6
								case 265:stats_symbolcyclepatternscs=3:stats_symbolcyclepatternsfl=7
								case 266:stats_symbolcyclepatternscs=3:stats_symbolcyclepatternsfl=8
								case 267:stats_symbolcyclepatternscs=3:stats_symbolcyclepatternsfl=9
								case 268:stats_symbolcyclepatternscs=3:stats_symbolcyclepatternsfl=10
								case 269:stats_symbolcyclepatternscs=4:stats_symbolcyclepatternsfl=2
								case 270:stats_symbolcyclepatternscs=4:stats_symbolcyclepatternsfl=3
								case 271:stats_symbolcyclepatternscs=4:stats_symbolcyclepatternsfl=4
								case 272:stats_symbolcyclepatternscs=4:stats_symbolcyclepatternsfl=5
								case 273:stats_symbolcyclepatternscs=4:stats_symbolcyclepatternsfl=6
								case 274:stats_symbolcyclepatternscs=4:stats_symbolcyclepatternsfl=7
								case 275:stats_symbolcyclepatternscs=4:stats_symbolcyclepatternsfl=8
								case 276:stats_symbolcyclepatternscs=4:stats_symbolcyclepatternsfl=9
								case 277:stats_symbolcyclepatternscs=4:stats_symbolcyclepatternsfl=10
							end select
							if thread_ptr(threadsmax+2)=0 then
								ui_editbox_settext(output_text,"Please wait..."+lb)
								thread_ptr(threadsmax+2)=threadcreate(@stats_symbolcyclepatterns,0)
							else stop_measurement=1
							end if
						case 160 to 170
							if thread_ptr(threadsmax+2)=0 then
								select case msg.wparam
									case 160:stats_nsymbolcycles=2
									case 161:stats_nsymbolcycles=3
									case 162:stats_nsymbolcycles=4
									case 163:stats_nsymbolcycles=5
									case 164:stats_nsymbolcycles=6
									case 165:stats_nsymbolcycles=7
									case 166:stats_nsymbolcycles=8
								end select
								ui_editbox_settext(output_text,"Please wait..."+lb)
								thread_ptr(threadsmax+2)=threadcreate(@stats_perfectsymbolcycles,0)
							else stop_measurement=1
							end if
						case 171 to 174
							if thread_ptr(threadsmax+2)=0 then
								select case msg.wparam
									case 171:stats_nsymbolcycles=3
									case 172:stats_nsymbolcycles=4
									case 173:stats_nsymbolcycles=5
									case 174:stats_nsymbolcycles=6
								end select
								ui_editbox_settext(output_text,"Please wait..."+lb)
								thread_ptr(threadsmax+2)=threadcreate(@stats_cycletypes,0)
							else stop_measurement=1
							end if
						case 120:stats_compare_keymapping
						case 121:stats_compare_kasiskeexamination
						case 122:stats_compare_equalitytest
						case 123:stats_omnidirectional(2)
						case 124:stats_omnidirectional(3)
						case 125 'free
						case 126:stats_periodic(2)
						case 129:stats_periodic(3)
						case 131:stats_periodic(4)
						case 132:stats_periodic(5)
						case 133:stats_periodic(6)
						case 134:stats_periodic(13)
						case 135:stats_periodic(8)
						case 136:stats_periodic(10)
						case 137:stats_periodic(11)
						case 138:stats_periodic(12)
						case 139:stats_periodic(14)
						case 153:stats_periodic(15)
						case 140 to 152
							if thread_ptr(threadsmax+2)=0 then
								select case msg.wparam
									case 140:encodingnulls_u=1:encodingnulls_t=1:encodingnulls_m=1
									case 141:encodingnulls_u=2:encodingnulls_t=1:encodingnulls_m=2
									case 142:encodingnulls_u=2:encodingnulls_t=1:encodingnulls_m=3
									case 143:encodingnulls_u=3:encodingnulls_t=1:encodingnulls_m=2
									case 144:encodingnulls_u=3:encodingnulls_t=1:encodingnulls_m=3	
									case 145:encodingnulls_u=4:encodingnulls_t=1:encodingnulls_m=2
									case 146:encodingnulls_u=4:encodingnulls_t=1:encodingnulls_m=3
									case 147:encodingnulls_u=5:encodingnulls_t=1:encodingnulls_m=2
									case 148:encodingnulls_u=5:encodingnulls_t=1:encodingnulls_m=3
									case 149:encodingnulls_u=6:encodingnulls_t=1:encodingnulls_m=2
									case 150:encodingnulls_u=6:encodingnulls_t=1:encodingnulls_m=3
									case 151:encodingnulls_u=7:encodingnulls_t=1:encodingnulls_m=2
									case 152:encodingnulls_u=7:encodingnulls_t=1:encodingnulls_m=3
								end select
								thread_ptr(threadsmax+2)=threadcreate(@stats_encodingrandomization,0)
							else stop_measurement=1
							end if
					end select
				else ui_editbox_settext(output_text,soi)
				end if 
		end select
end select