case button_symbols_update
	if msg.message=wm_lbuttondown then
		soi=string_to_info(ui_editbox_gettext(input_text),constcip)
		if soi="Ok" then 
			get_symbols(0)
			ui_listbox_setcursel(list_symbols_ngrams,0)
		else ui_editbox_settext(output_text,soi)
		end if
	end if

case button_symbols_process
	if msg.message=wm_lbuttondown then
		soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
		if soi="Ok" then 
			dim as string operation=ui_listbox_gettext(list_symbols_operations,ui_listbox_getcursel(list_symbols_operations))	
			select case operation
				
				case "Expand selected symbol"
					dim as integer cursor=ui_listbox_getcursel(list_symbols_ngrams)
					get_symbols(0)
					if info_numerical=0 then
						dim as string ngram1=ui_listbox_gettext(list_symbols_ngrams,cursor)
						ngram1=left(ngram1,instr(ngram1,":  ")-1)
						dim as integer lng1=len(ngram1)
						if lng1>1 then
							ui_editbox_settext(output_text,"Error: symbol n-gram size > 1")
							exit select
						end if
						dim as string string1=info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0)
						dim as integer lns=len(string1)
						dim as integer table1(255)
						erase table1
						for i=1 to 255
							table1(i)=ascii_table(i)
						next i
						for i=1 to len(string1)
							table1(asc(string1,i))=1	
						next i			
						i=1
						j=0
						dim as integer expansions=0
						do
						 	i=instr(i,string1,ngram1)
						 	if i>0 then
						 		expansions+=1
						 		if expansions>1 then
							 		do
							 			j+=1
							 			if j>255 then 
							 				ui_editbox_settext(output_text,"Error: expand > ASCII table")
							 				exit select
							 			end if
							 		loop until table1(j)=0
							 		string1=left(string1,i-1)+chr(j)+right(string1,lns-(i+(lng1-1)))
							 		lns=len(string1)
						 		end if
						 		i+=lng1
						 	else
						 		exit do
						 	end if
						loop
						string_to_info(string1,constcip2)
						ui_editbox_settext(input_text,string1)
						get_symbols(0)
						ui_listbox_setcursel(list_symbols_ngrams,cursor)
					else
						dim as string ngram1=ui_listbox_gettext(list_symbols_ngrams,cursor)
						ngram1=left(ngram1,instr(ngram1,":  ")-1)
						dim as integer lng=len(ngram1)
						dim as string number1=""
						dim as integer numbers1(info_length)
						numbers1(0)=0
						for i=1 to lng
							select case chr(asc(ngram1,i))
								case "0","1","2","3","4","5","6","7","8","9"
									number1+=chr(asc(ngram1,i))
								case else
									numbers1(0)+=1
									numbers1(numbers1(0))=val(number1)
									number1=""	
							end select
						next i
						if len(number1)>0 then
							numbers1(0)+=1
							numbers1(numbers1(0))=val(number1)
							number1=""
					   end if
						if numbers1(0)>1 then
							ui_editbox_settext(output_text,"Error: symbol n-gram size > 1")
							exit select			
						end if
						dim as integer table1(65536)
						erase table1
						for i=1 to info_length
							table1(info(i))=1
						next i
						k=0
						dim as integer expansions=0
						for i=1 to info_length-(numbers1(0)-1)
							e=1
							for j=1 to numbers1(0)
								if numbers1(j)<>info(i+(j-1)) then
									e=0
									exit for
								end if			
							next j
							if e=1 then
								expansions+=1
								if expansions>1 then
									for j=1 to numbers1(0)
										do
											k+=1
										loop until table1(k)=0
										info(i+(j-1))=k
									next j
								end if
								i+=(numbers1(0)-1) 'skip
							end if
						next i
						dim as string string1=info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0)
						ui_editbox_settext(input_text,string1)
						string_to_info(string1,constcip2)
						get_symbols(0)
						ui_listbox_setcursel(list_symbols_ngrams,cursor)	
					end if
					
				case "Replace selected symbol with"
					dim as integer cursor=ui_listbox_getcursel(list_symbols_ngrams)
					get_symbols(0)
					if info_numerical=0 then
						dim as string ngram1=ui_listbox_gettext(list_symbols_ngrams,cursor)
						dim as string ngram2=ui_editbox_gettext(editbox_symbols_a1)
						ngram1=left(ngram1,instr(ngram1,":  ")-1)
						dim as integer lng1=len(ngram1)
						dim as integer lng2=len(ngram2)
						dim as string string1=info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0)
						dim as integer lns=len(string1)
						i=1
						do
						 	i=instr(i,string1,ngram1)
						 	if i>0 then
						 		string1=left(string1,i-1)+ngram2+right(string1,lns-(i+(lng1-1)))
						 		lns=len(string1)
						 		i+=lng1+(lng2-1)
						 	else
						 		exit do
						 	end if
						loop	
						string_to_info(string1,constcip2)
						ui_editbox_settext(input_text,string1)
						get_symbols(0)
						ui_listbox_setcursel(list_symbols_ngrams,cursor)
					else
						dim as string ngram1=ui_listbox_gettext(list_symbols_ngrams,cursor)
						dim as string ngram2=ui_editbox_gettext(editbox_symbols_a1)
						ngram1=left(ngram1,instr(ngram1,":  ")-1)
						dim as integer lng1=len(ngram1)
						dim as integer lng2=len(ngram2)	
						dim as string number1=""
						dim as integer numbers1(info_length)
						numbers1(0)=0
						for i=1 to lng1
							select case chr(asc(ngram1,i))
								case "0","1","2","3","4","5","6","7","8","9"
									number1+=chr(asc(ngram1,i))
								case else
									numbers1(0)+=1
									numbers1(numbers1(0))=val(number1)
									number1=""	
							end select
						next i
						if len(number1)>0 then
							numbers1(0)+=1
							numbers1(numbers1(0))=val(number1)
							number1=""
						end if
						dim as string number2=""
						dim as integer numbers2(info_length)
						numbers2(0)=0
						for i=1 to lng2
							select case chr(asc(ngram2,i))
								case "0","1","2","3","4","5","6","7","8","9"
									number2+=chr(asc(ngram2,i))
								case else
									numbers2(0)+=1
									numbers2(numbers2(0))=val(number2)
									number2=""	
							end select
						next i
						if len(number2)>0 then
							numbers2(0)+=1
							numbers2(numbers2(0))=val(number2)
							number2=""
						end if		
						dim as long new_info(10000)
						k=0
						for i=1 to info_length '-(numbers1(0)-1)
							e=1
							if i<=info_length-(numbers1(0)-1) then
								for j=1 to numbers1(0)
									if numbers1(j)<>info(i+(j-1)) then
										e=0
										exit for
									end if			
								next j
							else
								e=0
							end if
							if e=0 then
								k+=1
								new_info(k)=info(i)	
							else
								for j=1 to numbers2(0) 'insert replace
									k+=1
									new_info(k)=numbers2(j)
								next j
								i+=(numbers1(0)-1) 'skip
							end if
						next i									
						dim as string string1=info_to_string(new_info(),k,info_x,info_y,info_numerical,0,0)
						ui_editbox_settext(input_text,string1)
						string_to_info(string1,constcip2)
						get_symbols(0)
						ui_listbox_setcursel(list_symbols_ngrams,cursor)											
					end if		
					
				case "Remove selected symbol"
					dim as integer cursor=ui_listbox_getcursel(list_symbols_ngrams)
					get_symbols(0)
					if info_numerical=0 then
						dim as string ngram1=ui_listbox_gettext(list_symbols_ngrams,cursor)
						ngram1=left(ngram1,instr(ngram1,":  ")-1)
						dim as integer lng=len(ngram1)
						dim as string string1=info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0)
						dim as integer lns=len(string1)
						'i=1
						do
						 	i=instr(string1,ngram1)
						 	if i>0 then
						 		string1=left(string1,i-1)+right(string1,lns-(i+(lng-1)))
						 		lns=len(string1)
						 		i+=lng
						 	else
						 		exit do
						 	end if
						loop
						string_to_info(string1,constcip2)
						ui_editbox_settext(input_text,string1)
						get_symbols(0)
						ui_listbox_setcursel(list_symbols_ngrams,cursor)
					else
						dim as string ngram1=ui_listbox_gettext(list_symbols_ngrams,cursor)
						ngram1=left(ngram1,instr(ngram1,":  ")-1)
						dim as integer lng=len(ngram1)
						dim as string number1=""
						dim as integer numbers1(info_length)
						numbers1(0)=0
						for i=1 to lng
							select case chr(asc(ngram1,i))
								case "0","1","2","3","4","5","6","7","8","9"
									number1+=chr(asc(ngram1,i))
								case else
									numbers1(0)+=1
									numbers1(numbers1(0))=val(number1)
									number1=""	
							end select
						next i
						if len(number1)>0 then
							numbers1(0)+=1
							numbers1(numbers1(0))=val(number1)
							number1=""
						end if
						dim as integer new_length=info_length
						for i=1 to info_length-(numbers1(0)-1)
							e=1
							for j=1 to numbers1(0)
								if numbers1(j)<>info(i+(j-1)) then
									e=0
									exit for
								end if			
							next j
							if e=1 then
								for j=1 to numbers1(0)
									info(i+(j-1))=0
									new_length-=1
								next j
								i+=(numbers1(0)-1) 'skip
							end if
						next i
						dim as long new_info(new_length)
						j=0
						for i=1 to info_length
							if info(i)>0 then
								j+=1
								new_info(j)=info(i)
							end if	
						next i
						dim as string string1=info_to_string(new_info(),new_length,info_x,info_y,info_numerical,0,0)
						ui_editbox_settext(input_text,string1)
						string_to_info(string1,constcip2)
						get_symbols(0)
						ui_listbox_setcursel(list_symbols_ngrams,cursor)
					end if
					
				case "Set symbol n-gram size"
					dim as integer cursor=ui_listbox_getcursel(list_symbols_ngrams)
					if val(ui_editbox_gettext(editbox_symbols_a1))>=1 then 
						symbols_ngramsize=val(ui_editbox_gettext(editbox_symbols_a1))
					end if
					get_symbols(0)
					ui_listbox_setcursel(list_symbols_ngrams,cursor)
					
			end select
		else ui_editbox_settext(output_text,soi)
		end if
	end if