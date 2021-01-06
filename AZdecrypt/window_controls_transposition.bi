case button_transposition_transpose,button_transposition_untranspose
	if msg.message=wm_lbuttondown then
		dim as integer untransposed
		select case msg.hwnd
			case button_transposition_transpose
				untransposed=0
			case button_transposition_untranspose
				untransposed=1
		end select
		dim as string operation=ui_listbox_gettext(list_transposition,ui_listbox_getcursel(list_transposition))
		soi=string_to_info(ui_editbox_gettext(input_text))
		if operation="Use transposition matrix" then
			if soi="Ok" then
				dim as integer l1=info_length
				dim as integer s1=info_symbols
				dim as integer n1=info_numerical
				dim as integer x1=info_x
				dim as integer y1=info_y
				dim as integer cip1(l1)
				for i=1 to l1
					cip1(i)=info(i)
				next i
				soi=string_to_info(ui_editbox_gettext(output_text))
				if soi="Ok" then
					if info_length=l1 then
						dim as integer l2=info_length
						dim as integer s2=info_symbols
						dim as integer cip2(l2)
						for i=1 to l1
							cip2(i)=info(i)
						next i	
						for i=1 to l1
							if untransposed=0 then
								info(i)=cip1(cip2(i))
							else
								info(cip2(i))=cip1(i)
							end if
						next i
						ui_editbox_settext(input_text,info_to_string(info(),l1,x1,y1,n1,0,0))
					else ui_editbox_settext(output_text,"Error: input output length mismatch")
					end if
				else ui_editbox_settext(output_text,soi)
				end if
			else ui_editbox_settext(output_text,soi)
			end if
			exit select
		end if
		if soi="Ok" then
			dim as integer p=0
			dim as string num=""
			if operation="Rearrange rows" or operation="Rearrange columns" then
				dim as string a1=ui_editbox_gettext(editbox_transposition_a1)+" "
				erase extarg
				for i=1 to len(a1)
					select case asc(a1,i)
						case 48 to 57
							num+=chr(asc(a1,i))
						case else
							if len(num)>0 then
								p+=1
								extarg(p)=val(num)
								num=""
							end if
					end select
				next i
			end if
			p=0
			dim as string a7=ui_editbox_gettext(editbox_transposition_a7)+" "
			dim as string a8=ui_editbox_gettext(editbox_transposition_a8)+" "
			dim as integer dxy(4)
			dim as integer partial_rectangle=1
			for i=1 to len(a7)
				select case asc(a7,i)
					case 48 to 57
						num+=chr(asc(a7,i))
					case else
						if len(num)>0 then
							p+=1
							if p<5 then dxy(p)=val(num)
							num=""							
						end if
				end select
			next i
			for i=1 to len(a8)
				select case asc(a8,i)
					case 48 to 57
						num+=chr(asc(a8,i))
					case else
						if len(num)>0 then
							p+=1
							if p<5 then dxy(p)=val(num)
							num=""
						end if
				end select
			next i		
			dim as integer x1=dxy(1)
			dim as integer y1=dxy(2)
			dim as integer x2=dxy(3)
			dim as integer y2=dxy(4)
			if x1<1 or x1>info_x then partial_rectangle=0
			if y1<1 or y1>info_y then partial_rectangle=0
			if x2<1 or x2>info_x then partial_rectangle=0
			if y2<1 or y2>info_y then partial_rectangle=0
			if x1>x2 then partial_rectangle=0
		 	if y1>y2 then partial_rectangle=0
		 	if left(a7,7)="partial" then partial_rectangle=0
		 	if left(a8,7)="partial" then partial_rectangle=0
		 	if partial_rectangle=0 then
		 		x1=1
		 		y1=1
		 		x2=info_x
		 		y2=info_y
		 	end if
		 	dim as integer grid(info_x,info_y)
			dim as integer part(info_length)
			dim as integer part_length
			dim as integer tx=x2-(x1-1)
			dim as integer ty=y2-(y1-1) 				  
		 	i=0
		 	for y=1 to info_y
		 		for x=1 to info_x
		 			i+=1
		 			if i<=info_length then
		 				grid(x,y)=info(i)
		 			else
		 				grid(x,y)=0
		 			end if
		 		next x
		 	next y
		 	for y=y1 to y2
		 		for x=x1 to x2
		 			if grid(x,y)>0 then
		 				part_length+=1
		 				part(part_length)=grid(x,y)
		 			end if
		 		next x
		 	next y
			dim as double arg(100)
			dim as string cso
			arg(1)=part_length 'info_length
			arg(2)=info_symbols
			arg(3)=tx 'info_x
			arg(4)=ty 'info_y
			arg(5)=untransposed '0
			arg(6)=ui_checkbox_getcheck(checkbox_transposition_keepnulls)
			arg(7)=val(ui_editbox_gettext(editbox_transposition_a1))
			arg(8)=val(ui_editbox_gettext(editbox_transposition_a2))
			arg(9)=val(ui_editbox_gettext(editbox_transposition_a3))
			arg(10)=val(ui_editbox_gettext(editbox_transposition_a4))
			arg(11)=val(ui_editbox_gettext(editbox_transposition_a5))
			arg(12)=val(ui_editbox_gettext(editbox_transposition_a6))
			for i=1 to part_length 'info_length
				cstate(1,i)=part(i)
			next i
			cso=cstate_operation(1,2,operation,arg())
			if left(cso,5)<>"Error" then	 
				i=0
				for y=y1 to y2
			 		for x=x1 to x2
			 			if grid(x,y)>0 then
			 				i+=1
			 				grid(x,y)=cstate(2,i)
			 			end if
			 		next x
			 	next y
			 	i=0
			 	for y=1 to info_y
			 		for x=1 to info_x
			 			if grid(x,y)>0 then
				 			i+=1
				 			info_out(i)=grid(x,y)
			 			end if 
			 		next x
			 	next y
				ui_editbox_settext(input_text,info_to_string(info_out(),info_length,info_x,info_y,info_numerical,0,0))
			else ui_editbox_settext(output_text,cso)
			end if
		else ui_editbox_settext(output_text,soi)
		end if
	end if