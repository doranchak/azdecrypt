if ui_listbox_getcursel(list_numbers_numtype)<>prev_index_list_numbers_numtype then 'numbers <------------------------------
	prev_index_list_numbers_numtype=ui_listbox_getcursel(list_numbers_numtype)
	s=ui_listbox_gettext(list_numbers_numtype,prev_index_list_numbers_numtype)
	ui_editbox_settext(editbox_numbers_nta1,"")
	ui_editbox_settext(editbox_numbers_nta2,"")
	ui_editbox_settext(editbox_numbers_nta3,"")
	ui_editbox_settext(editbox_numbers_nta4,"")
	ui_editbox_settext(editbox_numbers_nta5,"")
	ui_editbox_settext(editbox_numbers_nta6,"")
	select case s
		case "Numbers"
			ui_editbox_settext(editbox_numbers_nta1,"range: from#")
			ui_editbox_settext(editbox_numbers_nta2,"range: to#")
			ui_editbox_settext(editbox_numbers_nta3,"stepsize#")
			ui_editbox_settext(editbox_numbers_nta4,"amount# (0 = equal to range)")
			ui_editbox_settext(editbox_numbers_nta5,"level#")
		case "Prime numbers"
			ui_editbox_settext(editbox_numbers_nta1,"range: from#")
			ui_editbox_settext(editbox_numbers_nta2,"range: to#")
			ui_editbox_settext(editbox_numbers_nta3,"amount# (0 = equal to range)")
		case "Random numbers (Mersenne Twister)"
			ui_editbox_settext(editbox_numbers_nta1,"random number range: from#")
			ui_editbox_settext(editbox_numbers_nta2,"random number range: to#")
			ui_editbox_settext(editbox_numbers_nta3,"seed value# (0 = rnd timer seed)")
			ui_editbox_settext(editbox_numbers_nta4,"amount#")
	end select
end if
if ui_listbox_getcursel(list_numbers_operations)<>prev_index_list_numbers_operations then 'numbers <------------------------------
	prev_index_list_numbers_operations=ui_listbox_getcursel(list_numbers_operations)
	s=ui_listbox_gettext(list_numbers_operations,prev_index_list_numbers_operations)
	ui_editbox_settext(editbox_numbers_opa1,"")
	ui_editbox_settext(editbox_numbers_opa2,"")
	ui_editbox_settext(editbox_numbers_opa3,"")
	'select case s
	'	case "Add"
	'		ui_editbox_settext(editbox_numbers_opa1,"")
	'end select
end if