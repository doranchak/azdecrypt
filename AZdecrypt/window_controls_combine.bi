case button_combine_add
	if msg.message=wm_lbuttondown then
		if ui_listbox_getcursel(list_combine_operations)>-1 then
			if val(ui_editbox_gettext(editbox_combine_a1))>0 andalso val(ui_editbox_gettext(editbox_combine_a2))>0 then
				soi=string_to_info(ui_editbox_gettext(input_text)) 'get cipher
				if soi="Ok" then
					combine_stacksize+=1
					i=ui_listbox_getcursel(list_combine_operations)
					j=combine_stacksize
					combine_stack(j).operation=ui_listbox_gettext(list_combine_operations,i)
					combine_stack(j).arg(1)=str(val(ui_editbox_gettext(editbox_combine_a1)))
					combine_stack(j).arg(2)=str(val(ui_editbox_gettext(editbox_combine_a2)))
					combine_stack(j).arg(3)=str(val(ui_editbox_gettext(editbox_combine_a3)))
					combine_stack(j).arg(4)=str(val(ui_editbox_gettext(editbox_combine_a4)))
					combine_stack(j).arg(5)=str(val(ui_editbox_gettext(editbox_combine_a5)))
					combine_stack(j).arg(6)=str(val(ui_editbox_gettext(editbox_combine_a6)))
					combine_stack(j).untransposed=ui_radiobutton_getcheck(radiobutton_combine_untransposed)
					combine_stack(j).multiplicative=ui_radiobutton_getcheck(radiobutton_combine_multiplicative)
					s=""
					e=0
					if combine_stack(j).multiplicative=0 then
						s+="A: "
					else
						s+="M: "
					end if
					s+=combine_stack(j).operation
					select case combine_stack(j).operation
						case "Expand symbol","Add character","Remove character","Dimension","Randomize",_
							"Add column","Add row","Remove column","Remove row","Add random character",_
							"Add characters","Randomize column order","Randomize row","Randomize column",_
							"Noop","Remove characters","Plaintext","Encode: homophonic substitution",_
							"Randomize row order","Randomize column order","Encode: caesar shift",_
							"Encode: homophonic substitution 1-170","Encode: homophonic substitution 171-340",_
							"Encode: homophonic substitution 2","Random nulls","Random skips","Add nulls and skips",_
							"Randomize and bigrams","Add row (using random symbols)","Add column (using random symbols)",_
							"Remove symbol"
							s+="("
						case else
							if combine_stack(j).untransposed=0 then
								s+="(TP,"
							else
								s+="(UTP,"
							end if
					end select
					for i=1 to 10
						if val(combine_stack(j).arg(i))>0 then
							if e=1 then s+=","
							s+=combine_stack(j).arg(i)
							e=1
						end if
					next i
					s+=")"
					ui_listbox_addstring(list_combine_stack,s) 
					get_combinations
					ui_editbox_settext(editbox_combine_combinations,"Combinations: "+str(combine_combinations))	
					if combine_stacksize>0 then ui_listbox_setcursel(list_combine_stack,combine_stacksize-1)
				else ui_editbox_settext(output_text,soi)
				end if
			end if	
		end if
	end if
	
case button_combine_remove
	if msg.message=wm_lbuttondown then
		if ui_listbox_getcursel(list_combine_stack)>-1 then
			i=ui_listbox_getcursel(list_combine_stack)
			ui_listbox_deletestring(list_combine_stack,i)
			combine_stack(i+1).operation=""
			for j=1 to 10
				combine_stack(i+1).arg(j)=""
			next j
			combine_stack(i+1).untransposed=0
			k=0
			combine_stacksize-=1
			for i=1 to combine_stacksize
				k+=1
				if combine_stack(i).operation="" then k+=1
				combine_stack(i).operation=combine_stack(k).operation
				for j=1 to 10
					combine_stack(i).arg(j)=combine_stack(k).arg(j)
				next j
				combine_stack(i).untransposed=combine_stack(k).untransposed
				combine_stack(i).multiplicative=combine_stack(k).multiplicative
			next i
			get_combinations	 
			ui_editbox_settext(editbox_combine_combinations,"Combinations: "+str(combine_combinations))
			if combine_stacksize>0 then ui_listbox_setcursel(list_combine_stack,0)
		end if
	end if
	
case button_combine_process
	if msg.message=wm_lbuttondown then
		if combine_stacksize>0 then
			stop_current_task
			combine_listlength=combine_stacksize
			combine_measurement=ui_listbox_gettext(list_combine_measurements,ui_listbox_getcursel(list_combine_measurements))
			combine_normalized=ui_checkbox_getcheck(checkbox_combine_normalized)
			combine_omitlist=ui_checkbox_getcheck(checkbox_combine_omitlist)
			combine_hypergraph=ui_checkbox_getcheck(checkbox_combine_hypergraph)
			combine_forcelinear=ui_checkbox_getcheck(checkbox_combine_forcelinear)
			combine_getsigma=val(ui_editbox_gettext(editbox_combine_getsigma))
			combine_ma1=val(ui_editbox_gettext(editbox_combine_ma1))
			combine_minioc=val(ui_editbox_gettext(editbox_combine_minioc))
			combine_maxioc=val(ui_editbox_gettext(editbox_combine_maxioc))
			combine_fromlen=val(ui_editbox_gettext(editbox_combine_fromlen))
			combine_tolen=val(ui_editbox_gettext(editbox_combine_tolen))
			sleep 100
			thread_ptr(threadsmax+1)=threadcreate(@thread_combine,0)
		end if
	end if