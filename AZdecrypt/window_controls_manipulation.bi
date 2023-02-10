case button_manipulation_process
	if msg.message=wm_lbuttondown then
		dim as string operation
		dim as integer no_input_needed=0
		operation=ui_listbox_gettext(list_manipulation_operations,ui_listbox_getcursel(list_manipulation_operations))
		select case operation 'convert input to lcase/ucase
			case "Encode: digraph substitution","Encode: caesar shift"
				soi=string_to_info(ucase(ui_editbox_gettext(input_text)))
			case else
				soi=string_to_info(ui_editbox_gettext(input_text))
		end select
		select case operation
			case "Generate numbers","Generate random numbers"
				no_input_needed=1
		end select
		if soi="Ok" or no_input_needed=1 then
			dim as double arg(constcip)
			arg(1)=info_length
			arg(2)=info_symbols
			arg(3)=info_x
			if info_x=0 then info_x=17
			arg(4)=info_y
			arg(7)=val(ui_editbox_gettext(editbox_manipulation_a1))
			arg(8)=val(ui_editbox_gettext(editbox_manipulation_a2))
			arg(9)=val(ui_editbox_gettext(editbox_manipulation_a3))
			arg(10)=val(ui_editbox_gettext(editbox_manipulation_a4))
			arg(11)=val(ui_editbox_gettext(editbox_manipulation_a5))
			arg(12)=val(ui_editbox_gettext(editbox_manipulation_a6))
			select case operation 'use nuba or info
				case "Encode: vigenère"
					dim as string tmpk1=ui_editbox_gettext(editbox_manipulation_a4)
					for i=1 to len(tmpk1)
						arg(10+i)=asc(tmpk1,i)
					next i
					arg(10)=len(tmpk1)
					for i=1 to info_length
						cstate(1,i)=info(i)
					next i
				case "Encode: digraph substitution"
					dim as string tmpk1=ucase(ui_editbox_gettext(editbox_manipulation_a1))
					dim as string tmpk2=ucase(ui_editbox_gettext(editbox_manipulation_a2))
					arg(7)=0
					for i=1 to len(tmpk1)
						if asc(tmpk1,i)>64 andalso asc(tmpk1,i)<91 then
							arg(7)+=1
							arg(8+arg(7))=asc(tmpk1,i)
						end if
					next i
					arg(8)=0	
					for i=1 to len(tmpk2)
						if asc(tmpk2,i)>64 andalso asc(tmpk2,i)<91 then
							arg(8)+=1
							arg(8+arg(7)+arg(8))=asc(tmpk2,i)
						end if
					next i
					for i=1 to info_length
						cstate(1,i)=info(i)
					next i
				case "Remove column","Remove row","Remove character","Remove character periodic",_
					"Randomize positions periodic","Replace periodic with random filler","Encode: homophonic substitution",_
					"Randomize characters","Encode: caesar shift","Encode: homophonic substitution 2","Encode: fractioned morse",_
					"Modulo","Add nulls and skips","Math","Randomize and bigrams","Randomize and trigrams"
					',"Encode: homophonic substitution (no repeat window)"
					for i=1 to info_length
						cstate(1,i)=info(i)
					next i
				case "Disperse symbol","Expand symbol","Remove symbol","Merge random characters","Merge random symbols",_
					"Add null characters","Add null symbol","Assign homophones"
					dim as string dstmp=ui_editbox_gettext(editbox_manipulation_a1)
					if val(dstmp)>0 then
						dim as string a4s=ui_editbox_gettext(editbox_manipulation_a4)
						if operation="Assign homophones" andalso a4s<>"" then
							a4s+=" "
							dim as integer tpos1=9
							dim as string tnum1=""
							for i=1 to len(a4s)
								select case chr(asc(a4s,i))
									case "0","1","2","3","4","5","6","7","8","9"
										tnum1+=chr(asc(a4s,i))
									case else
										tpos1+=1
										arg(tpos1)=val(tnum1)
										tnum1=""
								end select
							next i	
						end if
						arg(7)=val(ui_editbox_gettext(editbox_manipulation_a1))
					else
						arg(7)=asc(ui_editbox_gettext(editbox_manipulation_a1))
					end if
					for i=1 to info_length
						cstate(1,i)=info(i)
					next i
				case "Add row","Add row (using random symbols)"
					info_y+=1
					for i=1 to info_length
						if operation="Add row" then
							cstate(1,i)=nuba(i)
						else
							cstate(1,i)=info(i)
						end if
					next i
				case "Add column","Add column (using random symbols)"
					info_x+=1
					for i=1 to info_length
						if operation="Add column" then
							cstate(1,i)=nuba(i)
						else
							cstate(1,i)=info(i)
						end if
					next i
				case else 'default if no exeception
					for i=1 to info_length
						cstate(1,i)=nuba(i)
					next i
			end select
			'operation=ui_listbox_gettext(list_manipulation_operations,ui_listbox_getcursel(list_manipulation_operations))
			dim as string ret=cstate_operation(1,2,operation,arg())
			if left(ret,5)<>"Error" then
				dim as integer newlength=val(left(ret,instr(ret,",")-1))
				for i=1 to newlength
					info(i)=cstate(2,i)
				next i
				select case operation 'output numeric or character
					case "Encode: vigenère","Encode: digraph substitution","Encode: caesar shift","Encode: fractioned morse"
						ui_editbox_settext(input_text,info_to_string(info(),newlength,info_x,0,0,0,0))
					case "Randomize characters","Remove column","Remove row","Remove character",_
						"Remove character periodic","Randomize positions periodic","Expand symbol",_
						"Replace periodic with random filler","Disperse symbol","Remove symbol",_
						"Merge random characters","Merge random symbols","Add null characters",_
						"Add null symbol","Assign homophones","Add nulls and skips","Randomize and bigrams",_
						"Add row (using random symbols)","Add column (using random symbols)","Randomize and trigrams"
						ui_editbox_settext(input_text,info_to_string(info(),newlength,info_x,0,info_numerical,0,0))
					case else
						ui_editbox_settext(input_text,info_to_string(info(),newlength,info_x,0,1,0,0))
				end select
			else ui_editbox_settext(output_text,ret)
			end if 
		else ui_editbox_settext(output_text,soi)
		end if
	end if