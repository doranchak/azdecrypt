if wc_windowup=1 then
	
	dim as byte wc_editfocusset=0
	dim as string wc_symbol=""
	
	if wc_prevcheck_editcipher=0 then 'edit cipher = 0
		
		for y=1 to wc_dy 'check wc_cribs for changes
			for x=1 to wc_dx
				wc_symbol=ui_editbox_gettext(wc_cribs(x,y))
				if len(wc_symbol)>1 then
					if left(wc_symbol,1)=wc_pgrid(0,x,y) then
						wc_symbol=right(wc_symbol,1)
					else
						wc_symbol=left(wc_symbol,1)
					end if
					ui_editbox_settext(wc_cribs(x,y),wc_symbol)
					if x=wc_dx then 'set next edit focus
						if y=wc_dy then
							ui_setfocus(wc_cribs(1,1))
							ui_sendmessage(wc_cribs(1,1),EM_SETSEL,1,1)
						else	
							ui_setfocus(wc_cribs(1,y+1))
							ui_sendmessage(wc_cribs(1,y+1),EM_SETSEL,1,1)
						end if
					else
						ui_setfocus(wc_cribs(x+1,y))
						ui_sendmessage(wc_cribs(x+1,y),EM_SETSEL,1,1)
					end if
					wc_editfocusset=1	
				end if
				wc_symbol=ui_editbox_gettext(wc_cribs(x,y))
				if wc_symbol<>wc_pgrid(0,x,y) then
					e=0
					for i=0 to ngram_alphabet_size-1 'check alphabet
						if alphabet(i)=asc(wc_symbol) then
							e=1
							exit for
						end if
					next i
					if e=0 andalso len(wc_symbol)=0 then 'backspace
						for y2=1 to wc_dy
							for x2=1 to wc_dx
								if wc_nuba(x2,y2)=wc_nuba(x,y) then
									ui_editbox_settext(wc_cribs(x2,y2),"")
									wc_pgrid(0,x2,y2)=""
									if x2+((y2-1)*wc_dx)=wc_l then exit for,for
								end if
							next x2
						next y2
					else
						if e=1 then 'allowed alphabet
							if wc_editfocusset=0 then
								if x=wc_dx then 'set next edit focus
									if y=wc_dy then
										ui_setfocus(wc_cribs(1,1))
										ui_sendmessage(wc_cribs(1,1),EM_SETSEL,1,1)
									else	
										ui_setfocus(wc_cribs(1,y+1))
										ui_sendmessage(wc_cribs(1,y+1),EM_SETSEL,1,1)
									end if
								else
									ui_setfocus(wc_cribs(x+1,y))
									ui_sendmessage(wc_cribs(x+1,y),EM_SETSEL,1,1)
								end if
								wc_editfocusset=1
							end if
							for y2=1 to wc_dy
								for x2=1 to wc_dx
									if wc_nuba(x2,y2)=wc_nuba(x,y) then
										ui_editbox_settext(wc_cribs(x2,y2),wc_symbol)
										wc_pgrid(0,x2,y2)=wc_symbol
										if x2+((y2-1)*wc_dx)=wc_l then exit for,for
									end if
								next x2
							next y2
						else 'not allowed alphabet
							ui_editbox_settext(wc_cribs(x,y),wc_pgrid(0,x,y))
						end if
					end if
				end if
				if x+((y-1)*wc_dx)=wc_l then exit for,for
			next x
		next y
	
	else 'edit cipher
			
		for y=1 to wc_dy 'check wc_cipher for changes
			for x=1 to wc_dx	
				wc_symbol=ui_editbox_gettext(wc_cipher(x,y))
				if wc_num=0 then 'non-numerical cipher
					if len(wc_symbol)>1 then
						if left(wc_symbol,1)=wc_pgrid(1,x,y) then
							wc_symbol=right(wc_symbol,1)
						else
							wc_symbol=left(wc_symbol,1)
						end if
					end if
					if len(wc_symbol)=0 then
						ui_editbox_settext(wc_cipher(x,y),wc_pgrid(1,x,y))
						exit for,for
					end if
					if wc_symbol<>wc_pgrid(1,x,y) or len(ui_editbox_gettext(wc_cipher(x,y)))>1 then
						dim as string old_wc=wc_pgrid(1,x,y)
						wc_pgrid(1,x,y)=wc_symbol
						dim as string pstring=""
						i=0
						for y2=1 to wc_dy
							for x2=1 to wc_dx
								i+=1
								pstring+=wc_pgrid(1,x2,y2)
								if i=wc_l then exit for,for
							next x2
						next y2
						dim as string sti=string_to_info(pstring)
						if sti="Ok" then
							wc_s=info_symbols
							wc_pgrid(0,x,y)=""
							ui_editbox_settext(wc_cribs(x,y),"")
							ui_editbox_settext(wc_cipher(x,y),wc_symbol)
							i=0
							for y2=1 to wc_dy
								for x2=1 to wc_dx
									i+=1
									wc_nuba(x2,y2)=nuba(i)
									if i=wc_l then exit for,for
								next x2
							next y2
						else
							wc_pgrid(1,x,y)=old_wc
							ui_editbox_settext(output_text,"Error: unsupported character")
						end if
						'if x=wc_dx then 'set next edit focus
						'	if y=wc_dy then
						'		ui_setfocus(wc_cribs(1,1))
						'		ui_sendmessage(wc_cipher(1,1),EM_SETSEL,1,1)
						'	else
						'		ui_setfocus(wc_cribs(1,y+1))
						'		ui_sendmessage(wc_cipher(1,y+1),EM_SETSEL,1,1)
						'	end if
						'else
						'	ui_setfocus(wc_cribs(x+1,y))
						'	ui_sendmessage(wc_cipher(x+1,y),EM_SETSEL,1,1)
						'end if
						'wc_editfocusset=1
						exit for,for
					end if
				else 'numerical cipher
					if wc_symbol<>wc_pgrid(1,x,y) then
						e=0
						for i=1 to len(wc_symbol)
							select case asc(wc_symbol,i)
								case 48 to 57
								case else
									e=1
									exit for
							end select
						next i
						if e=1 or len(wc_symbol)=0 then
							ui_editbox_settext(wc_cipher(x,y),wc_pgrid(1,x,y))
						else 'only numbers
							wc_symbol=left(wc_symbol,4)
							wc_pgrid(1,x,y)=wc_symbol
							ui_editbox_settext(wc_cipher(x,y),wc_pgrid(1,x,y))
							dim as string pstring=""
							i=0
							for y2=1 to wc_dy
								for x2=1 to wc_dx
									i+=1
									pstring+=wc_pgrid(1,x2,y2)
									if i=wc_l then exit for,for
									pstring+=" "
								next x2
							next y2
							string_to_info(pstring)
							wc_s=info_symbols
							wc_pgrid(0,x,y)=""
							ui_editbox_settext(wc_cribs(x,y),"")
							ui_editbox_settext(wc_cipher(x,y),wc_symbol)
							i=0
							for y2=1 to wc_dy
								for x2=1 to wc_dx
									i+=1
									wc_nuba(x2,y2)=nuba(i)
									if i=wc_l then exit for,for
								next x2
							next y2
							ui_sendmessage(wc_cipher(x,y),EM_SETSEL,len(wc_symbol),len(wc_symbol))
						end if
						'if x=wc_dx then 'set next edit focus
						'	if y=wc_dy then
						'		ui_setfocus(wc_cribs(1,1))
								'ui_sendmessage(wc_cipher(x,y),EM_SETSEL,len(wc_symbol),len(wc_symbol))
						'	else
						'		ui_setfocus(wc_cribs(1,y+1))
						'		ui_sendmessage(wc_cipher(1,y+1),EM_SETSEL,1,1)
						'	end if
						'else
						'	ui_setfocus(wc_cribs(x+1,y))
						'	ui_sendmessage(wc_cipher(x+1,y),EM_SETSEL,1,1)
						'end if
						'wc_editfocusset=1
						exit for,for
					end if
				end if
				if x+((y-1)*wc_dx)=wc_l then exit for,for
			next x
		next y
	end if
	
	if ui_checkbox_getcheck(checkbox_cribs_editcipher)<>wc_prevcheck_editcipher then
		if wc_windowup=1 then
			if wc_prevcheck_showcipher=1 then
				wc_prevcheck_editcipher=ui_checkbox_getcheck(checkbox_cribs_editcipher)
				for y=1 to wc_dy
					for x=1 to wc_dx
						if wc_prevcheck_editcipher=0 then
							enablewindow(wc_cipher(x,y),0)
							enablewindow(wc_cribs(x,y),-1)
						else
							enablewindow(wc_cipher(x,y),-1)
							enablewindow(wc_cribs(x,y),0)
						end if
						if x+((y-1)*wc_dx)=wc_l then exit for,for
					next x
				next y
			else
				ui_checkbox_setcheck(checkbox_cribs_editcipher,0)
			end if
		end if
	end if
	
	if ui_checkbox_getcheck(checkbox_cribs_showcipher)<>wc_prevcheck_showcipher then
		if wc_windowup=1 then
			wc_prevcheck_showcipher=ui_checkbox_getcheck(checkbox_cribs_showcipher)
			dim as long wc_x0,wc_y0,wc_x1,wc_y1
			ui_window_getposition(window_cribs,wc_x0,wc_y0,wc_x1,wc_y1)
			create_window_cribgrid(wc_x0,wc_y0,0)
		end if
	end if

end if