case button_dimension_update
	if msg.message=wm_lbuttondown then
		soi=string_to_info(ui_editbox_gettext(input_text),constcip)
		if soi="Ok" then
			get_native_dimensions
		else ui_editbox_settext(output_text,soi)
		end if
	end if

case button_dimension_custom
	if msg.message=wm_lbuttondown then
		dim as string x1,y1
		dim as string g1=ui_editbox_gettext(editbox_dimension_custom)
		dim as integer switch1
		for i=1 to len(g1)
			select case asc(g1,i)
				case 48 to 57
					if switch1=0 then x1+=chr(asc(g1,i))
					if switch1=1 then y1+=chr(asc(g1,i))
				case else
					if len(x1)>0 then
						switch1=1
					end if
			end select
		next i
		soi=string_to_info(ui_editbox_gettext(input_text),constcip2)
		if val(x1)>0 andalso val(x1)<=info_length then
			if soi="Ok" then
				info_x=val(x1)
				if val(y1)=0 then
					if info_length mod val(x1)=0 then
						y1=str(info_length\info_x)
					else
						y1=str((info_length\info_x)+1)
					end if
				end if
				info_y=val(y1)
				if val(x1)*val(y1)<info_length then info_length=val(x1)*val(y1)
				ui_editbox_settext(input_text,info_to_string(info(),info_length,val(x1),val(y1),info_numerical,0,0))
				'ui_editbox_settext(input_text,info_to_string(info(),val(x1)*val(y1),val(x1),val(y1),info_numerical,0,0))
			else ui_editbox_settext(output_text,soi)
			end if
		end if	
	end if