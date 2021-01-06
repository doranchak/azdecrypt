case button_creatematrix_clear
	if msg.message=wm_lbuttondown then
		tma_c=1
		tma_c2=0
		for y=1 to tma_dy
			for x=1 to tma_dx
				tma(x,y)=""
				ui_label_settext(buttons_creatematrix(x,y),"")
			next x
		next y
		dim as long wc_x0,wc_y0,wc_x1,wc_y1
		ui_window_getposition(window_creatematrix,wc_x0,wc_y0,wc_x1,wc_y1)
		create_window_creatematrix(wc_x0,wc_y0)
	end if

'case button_creatematrix_saveas
'	if msg.message=wm_lbuttondown then
'		if tma_ok=1 then
'			i=0
'			dim as long tm(tma_dx*tma_dy)
'			for y=1 to tma_dy
'				for x=1 to tma_dx
'					if val(tma(x,y))>0 then
'						i+=1
'						tm(i)=val(tma(x,y))
'					end if
'				next x
'			next y
'			if i>0 then
'				file=ui_loadsavedialog(1,"Save transposition matrix as",filter) 
'				if file<>"" then
'					if right(file,4)<>".txt" then file+=".txt"
'					open file for output as #2
'					put #2,,info_to_string(tm(),i,tma_dx,tma_dy,1)
'					close #2
'				end if
'			end if
'		end if
'	end if

case button_creatematrix_undo
	if msg.message=wm_lbuttondown then
		if tma_dx>0 andalso tma_dy>0 andalso tma_c2>0 then
			tma_c2-=1
			tma_lpx=tma_his2(tma_c2,0)
			tma_lpy=tma_his2(tma_c2,1)
			tma_c=tma_his2(tma_c2,2)
			for y=1 to tma_dy
				for x=1 to tma_dx
					ui_label_settext(buttons_creatematrix(x,y),"")
					if tma_his1(tma_c2,x,y)>0 then
						tma(x,y)=str(tma_his1(tma_c2,x,y))
						ui_label_settext(buttons_creatematrix(x,y),str(tma_his1(tma_c2,x,y)))
					else
						tma(x,y)=""
					end if			
				next x
			next y
		end if
	end if
	
case button_creatematrix_transpose
	if msg.message=wm_lbuttondown then
		dim as string soi=string_to_info(ui_editbox_gettext(input_text))
		if soi="Ok" then
			i=0
			dim as short licm1(info_length)
			dim as short licm2(tma_dx*tma_dy)
			for y=1 to tma_dy
				for x=1 to tma_dx
					if val(tma(x,y))>0 then
						i+=1
						licm2(i)=val(tma(x,y))
					end if
				next x
			next y
			if i>0 then
				for i=1 to info_length
					licm1(i)=info(i)
				next i
				for i=1 to info_length
					info(i)=licm1(licm2(i)) 'tp
				next i
				ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0))
			else ui_editbox_settext(output_text,"Error: no transposition matrix active")
			end if
		else ui_editbox_settext(output_text,soi)
		end if
	end if
	
case button_creatematrix_untranspose
	if msg.message=wm_lbuttondown then
		dim as string soi=string_to_info(ui_editbox_gettext(input_text))
		if soi="Ok" then
			i=0
			dim as short licm1(info_length)
			dim as short licm2(tma_dx*tma_dy)
			for y=1 to tma_dy
				for x=1 to tma_dx
					if val(tma(x,y))>0 then
						i+=1
						licm2(i)=val(tma(x,y))
					end if
				next x
			next y
			if i>0 then
				for i=1 to info_length
					licm1(i)=info(i)
				next i
				for i=1 to info_length
					info(licm2(i))=licm1(i) 'utp
				next i
				ui_editbox_settext(input_text,info_to_string(info(),info_length,info_x,info_y,info_numerical,0,0))
			else ui_editbox_settext(output_text,"Error: no transposition matrix active")
			end if
		else ui_editbox_settext(output_text,soi)
		end if
	end if

case button_creatematrix_exportoutput
	if msg.message=wm_lbuttondown then
		if tma_ok=1 then
			i=0
			dim as long tm(tma_dx*tma_dy)
			for y=1 to tma_dy
				for x=1 to tma_dx
					if val(tma(x,y))>0 then
						i+=1
						tm(i)=val(tma(x,y))
					end if
				next x
			next y
			if i>0 then ui_editbox_settext(output_text,info_to_string(tm(),i,tma_dx,tma_dy,1,0,0))
		end if
	end if