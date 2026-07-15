case button_manualpoly_reload
	if msg.message=wm_lbuttondown then
		soi=string_to_info(ui_editbox_gettext(input_text),constcip)
		if soi="Ok" then
			dim as string tempstring001=""
			for i=0 to ngram_alphabet_size-1
				tempstring001+=chr(alphabet(i))
			next i
			for i=1 to info_symbols
				mp_letters(i)=tempstring001
			next i
			get_symbols(2)
			ui_listbox_setcursel(list_manualpoly_stl,0)
		else ui_editbox_settext(output_text,soi)
		end if
	end if
	
case button_manualpoly_setsel
	if msg.message=wm_lbuttondown then
		soi=string_to_info(ui_editbox_gettext(input_text),constcip)
		if soi="Ok" then
			dim as integer cursor=ui_listbox_getcursel(list_manualpoly_stl)
			dim as string ngram1=ui_listbox_gettext(list_manualpoly_stl,cursor)
			ngram1=left(ngram1,instr(ngram1,"(")-2)
			dim as integer snum
			if info_numerical=0 then
				snum=asc(ngram1)
			else	
				snum=val(ngram1)
			end if
			for i=1 to info_length
				if info(i)=snum then 
					k=nuba(i)
					exit for
				end if
			next i
			dim as string oldmp=mp_letters(k)
			mp_letters(k)=""
			for i=1 to len(ui_editbox_gettext(editbox_manualpoly_setsel))
				if alpharevp1(asc(ui_editbox_gettext(editbox_manualpoly_setsel),i))>0 then
					mp_letters(k)+=chr(asc(ui_editbox_gettext(editbox_manualpoly_setsel),i))
				end if
			next i
			if mp_letters(k)="" then mp_letters(k)=oldmp
			get_symbols(2)
			if cursor+1=info_symbols then
				ui_listbox_setcursel(list_manualpoly_stl,0)
			else
				ui_listbox_setcursel(list_manualpoly_stl,cursor+1)
			end if
		else ui_editbox_settext(output_text,soi)
		end if
	end if
	
'case button_polyphones_setall
'	if msg.message=wm_lbuttondown then
'		soi=string_to_info(ui_editbox_gettext(input_text),constcip)
'		if soi="Ok" then
'			dim as integer cursor=ui_listbox_getcursel(list_polyphones_stl)
'			j=val(ui_editbox_gettext(editbox_polyphones_setall))
'			if j>ngram_alphabet_size then j=ngram_alphabet_size
'			if j>=1 then
'				for i=1 to constcip
'					cpol(i)=j
'				next i
'			end if
'			get_symbols(1)
'			ui_listbox_setcursel(list_polyphones_stl,cursor)
'		else ui_editbox_settext(output_text,soi)
'		end if
'	end if