case button_optionsstats_change
	if msg.message=wm_lbuttondown then
		if ui_editbox_gettext(editbox_optionsstats_a1)<>"" then
			if stats_running=0 then
				i=ui_listbox_getcursel(list_optionsstats)
				s=ui_listbox_gettext(list_optionsstats,i)
				s=left(s,instr(s,":")-1)
				dim as integer change=0
				dim as double d=val(ui_editbox_gettext(editbox_optionsstats_a1))
				select case s
					case "(Find plaintext and encoding direction) Randomization trials"
						if d>=1 andalso d<100001 then
							change=1
							stats_dirrndtrials=d
							ui_listbox_replacestring(list_optionsstats,i,s+": "+str(stats_dirrndtrials))
						else ui_editbox_settext(output_text,"Error: stats options (A1)")
						end if
					case "(Find encoding randomization) Randomization trials"
						if d>=1 andalso d<100001 then
							change=2
							stats_encrndtrials=d
							ui_listbox_replacestring(list_optionsstats,i,s+": "+str(stats_encrndtrials))
						else ui_editbox_settext(output_text,"Error: stats options (A1)")
						end if
					case "(N-symbol cycles) Weight"
						if d>=1 andalso d<101 then
							change=3
							stats_nsymbolcyclesweight=d
							ui_listbox_replacestring(list_optionsstats,i,s+": "+str(stats_nsymbolcyclesweight))
						else ui_editbox_settext(output_text,"Error: stats options (A1)")
						end if
					case "(Symbol cycle patterns & types) Randomization trials"
						if d>=1 andalso d<100001 then
							change=3
							stats_symbolcyclepatternsrndtrials=d
							ui_listbox_replacestring(list_optionsstats,i,s+": "+str(stats_symbolcyclepatternsrndtrials))
						else ui_editbox_settext(output_text,"Error: stats options (A1)")
						end if
					case "(Plaintext direction) Bigrams alphabet"
						if d>=2 andalso d<=constcip then
							change=4
							stats_bigramsmod=d
							ui_listbox_replacestring(list_optionsstats,i,s+": "+str(stats_bigramsmod))
						else ui_editbox_settext(output_text,"Error: stats options (A1)")
						end if
				end select
				if change>0 then ui_listbox_setcursel(list_optionsstats,i)
				'select case change
				'	case 3:create_scs_table(stats_nsymbolcyclesweight)
				'end select
			else ui_editbox_settext(output_text,"Error: stats running")
			end if
		else ui_editbox_settext(output_text,"Error: stats options (A1)")
		end if
	end if