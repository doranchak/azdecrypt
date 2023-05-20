#ifdef __fb_linux__

	const WS_OVERLAPPEDWINDOW = &h0
	const WS_VISIBLE = &h0
	const WS_DISABLED = &h0
	const MF_CHECKED = &h0
	const MF_UNCHECKED = &h0
	const ES_READONLY = &h0
	const WS_TABSTOP = &h0
	const ES_CENTER = &h0
	const WS_SYSMENU = &h0
	const WS_MINIMIZEBOX = &h0
	const WS_GROUP = &h0
	const MF_SEPARATOR = &h0
	TYPE HWND AS ANY PTR
	TYPE msg AS ANY PTR
	TYPE HMENU AS ANY ptr
	
#endif

function GetCPUCores As ubyte
	
	Dim As UByte numcores
	Asm
	mov eax,&h0A
	cpuid
	mov [numcores],al
	End Asm
	If numcores = 0 Then numcores = 1
	return numcores
	
end function

sub ui_editbox_settext(byval hwndedit as hwnd,byval text as string,byval arg3 as string="")
	
	#ifdef __fb_linux__
		select case arg3
			case "exception 1": 'if needed and can easily be added to the other ui_... subs/functions 
			case else
		end select
	#else
	 	editbox_settext(hwndedit,text)
	#endif
	
end sub

function ui_editbox_gettext(byval hwndedit as hwnd)as string
	
	#ifdef __fb_linux__
		return ""
	#else
		return editbox_gettext(hwndedit)
	#endif
	
end function

function ui_loadsavedialog(byval savedlog as long=0,byval windowname as string="",byval filter as string="",byval fltrindex as long=1,byval initdir as string="",byval strdefext as string="")as string
	
	#ifdef __fb_linux__
		return ""
	#else
	 	return loadsavedialog(savedlog,windowname,filter,fltrindex,initdir,strdefext)
	#endif
	
end function

function ui_window_new(byval x as long,byval y as long,byval w as long,byval h as long,byval title as string,byval style as ulong=WS_OVERLAPPEDWINDOW Or WS_VISIBLE)as hwnd
	
	#ifdef __fb_linux__
		return 0
	#else
	 	return window_new(x,y,w,h,title,style)
	#endif
	
end function

sub ui_window_getposition(byval hwnd as hwnd,byref x_left as long,byref y_top as long,byref x_right as long,byref y_bottom as long)
	
	#ifdef __fb_linux__
	#else
		window_getposition(hwnd,x_left,y_top,x_right,y_bottom)
	#endif
	
end sub

function ui_window_event_close(byval hwnd as hwnd,byref msg as msg)as long
	
	#ifdef __fb_linux__
		return 0
	#else
		return window_event_close(hwnd,msg)
	#endif
	
end function

sub ui_control_setfont(byval hwndcontrol as hwnd,byval font as string,byval h as long=16,byval w as long=8,byval wt as long=0,byval it as long=false,byval ul as long=false,byval so as long=false)
	
	#ifdef __fb_linux__
	#else
		control_setfont(hwndcontrol,font,h,w,wt,it,ul,so)
	#endif
	
end sub

function ui_button_new(byval x as long,byval y as long,byval w as long,byval h as long,byval label as string,byval style as ulong=WS_TABSTOP,byval hwnd as hwnd)as hwnd
	
	#ifdef __fb_linux__
		return 0
	#else
		return button_new(x,y,w,h,label,style,hwnd)
	#endif
	
end function

function ui_checkbox_new(byval x as long,byval y as long,byval w as long,byval h as long,byval label as string,byval style as ulong=WS_TABSTOP,byval hwnd as hwnd)as hwnd
	
	#ifdef __fb_linux__
		return 0
	#else
		return checkbox_new(x,y,w,h,label,style,hwnd)
	#endif
	
end function

sub ui_checkbox_setcheck(byval hwndcheck as hwnd,byval checkstate as long)
	
	#ifdef __fb_linux__
	#else
		checkbox_setcheck(hwndcheck,checkstate)
	#endif
	
end sub

function ui_checkbox_getcheck(byval hwndcheck as hwnd)as long
	
	#ifdef __fb_linux__
		return 0
	#else
		return checkbox_getcheck(hwndcheck)
	#endif
	
end function

function ui_radiobutton_new(byval x as long,byval y as long,byval w as long,byval h as long,byval label as string,byval style as long=WS_TABSTOP,byval hwnd as hwnd)as hwnd
	
	#ifdef __fb_linux__
		return 0
	#else
		return radiobutton_new(x,y,w,h,label,style,hwnd)
	#endif
	
end function

sub ui_radiobutton_setcheck(byval hwndradio as hwnd,byval checkstate as long)
	
	#ifdef __fb_linux__
	#else
		radiobutton_setcheck(hwndradio,checkstate)
	#endif
	
end sub

function ui_radiobutton_getcheck(byval hwndradio as hwnd)as long
	
	#ifdef __fb_linux__
		return 0
	#else
		return radiobutton_getcheck(hwndradio)
	#endif
	
end function

function ui_label_new(byval x as long,byval y as long,byval w as long,byval h as long,byval text as string,byval style as ulong=0,byval hwnd as hwnd)as hwnd
	
	#ifdef __fb_linux__
		return 0
	#else
		return label_new(x,y,w,h,text,style,hwnd)
	#endif
	
end function

sub ui_label_settext(byval hwndlabel as hwnd,byval text as string)
	
	#ifdef __fb_linux__
	#else
		label_settext(hwndlabel,text)
	#endif
	
end sub

function ui_editbox_new(byval x as long,byval y as long,byval w as long,byval h as long,byval text as string,byval style as ulong=WS_TABSTOP,byval hwnd as hwnd)as hwnd
	
	#ifdef __fb_linux__
		return 0
	#else
		return editbox_new(x,y,w,h,text,style,hwnd)
	#endif
	
end function

function ui_editor_new(byval x as long,byval y as long,byval w as long,byval h as long,byval text as string,byval style as ulong=WS_TABSTOP,byval hwnd as hwnd)as hwnd
	
	#ifdef __fb_linux__
		return 0
	#else
		return editor_new(x,y,w,h,text,style,hwnd)
	#endif
	
end function

function ui_listbox_new(byval x as long,byval y as long,byval w as long,byval h as long,byval style as ulong=WS_TABSTOP,byval hwnd as hwnd)as hwnd
	
	#ifdef __fb_linux__
		return 0
	#else
		return listbox_new(x,y,w,h,style,hwnd)
	#endif
	
end function

sub ui_listbox_addstring(byval hwndlist as hwnd,byval text as string)
	
	#ifdef __fb_linux__
	#else
		listbox_addstring(hwndlist,text)
	#endif
	
end sub

sub ui_listbox_deletestring(byval hwndlist as hwnd,byval index as long)
	
	#ifdef __fb_linux__
	#else
		listbox_deletestring(hwndlist,index)
	#endif
	
end sub

sub ui_listbox_replacestring(byval hwndlist as hwnd,byval index as long,byval text as string,byval newdata as long=0)
	
	#ifdef __fb_linux__
	#else
		listbox_replacestring(hwndlist,index,text,newdata)
	#endif
	
end sub

sub ui_listbox_resetcontent(byval hwndlist as hwnd)
	
	#ifdef __fb_linux__
	#else
		listbox_resetcontent(hwndlist)
	#endif
	
end sub

sub ui_listbox_setcursel(byval hwndlist as hwnd,byval index as long)
	
	#ifdef __fb_linux__
	#else
		listbox_setcursel(hwndlist,index)
	#endif
	
end sub

function ui_listbox_getcursel(byval hwndlist as hwnd)as long
	
	#ifdef __fb_linux__
		return 0
	#else
		return listbox_getcursel(hwndlist)
	#endif
	
end function

function ui_listbox_gettext(byval hwndlist as hwnd,byval index as long)as string
	
	#ifdef __fb_linux__
		return ""
	#else
		return listbox_gettext(hwndlist,index)
	#endif
	
end function

sub ui_menutitle(byval hmenu as hmenu,byval hmenutitle as hmenu,byval title as string)
	
	#ifdef __fb_linux__
	#else
		menutitle(hmenu,hmenutitle,title)
	#endif
	
end sub

sub ui_menuitem(byval hmenutitle as hmenu,byval menuitemnumber as long,byval menuitemname as string)
	
	#ifdef __fb_linux__
	#else
		menuitem(hmenutitle,menuitemnumber,menuitemname)
	#endif
	
end sub

function ui_createmenu()as hmenu
	
	#ifdef __fb_linux__
		return 0
	#else
		return createmenu() 'can take arguments ???
	#endif
	
end function

sub ui_appendmenu(byval hmenu as hmenu,byval style as ulong,byval index as long,byval text as string="")

	#ifdef __fb_linux__
	#else
		appendmenu(hmenu,style,index,text)
	#endif
	
end sub

sub ui_seticon(byval hwnd as hwnd)
	
	#ifdef __fb_linux__
	#else
		dim hicon as hicon=loadimage(getmodulehandle(null),"fb_program_icon",image_icon,256,256,lr_shared)	
		sendmessage(hwnd,wm_seticon,cast(wparam,icon_big),cast(lparam,hicon))
	#endif

end sub

sub ui_destroywindow(byval hwnd as hwnd)
	
	#ifdef __fb_linux__
	#else
		destroywindow(hwnd)
	#endif

end sub

sub ui_sendmessage(byval hwnd as hwnd,byval msg as long,byval arg1 as long,byval arg2 as long)
	
	#ifdef __fb_linux__
	#else
		sendmessage(hwnd,msg,arg1,arg2)
	#endif
	
end sub

sub ui_modifymenu(byval hmenu as hmenu,byval index1 as long,byval msg as long,byval index2 as long,byval text as string)
	
	#ifdef __fb_linux__
	#else
		modifymenu(hmenu,index1,msg,index2,text)
	#endif
	
end sub

sub ui_drawmenubar(byval hwnd as hwnd)
	
	#ifdef __fb_linux__
	#else
		drawmenubar(hwnd)
	#endif
	
end sub

sub ui_setfocus(byval hwnd as hwnd)
	
	#ifdef __fb_linux__
	#else
		setfocus(hwnd)
	#endif
	
end sub

sub ui_setwindowtext(byval hwnd as hwnd,byval text as string)
	
	#ifdef __fb_linux__
	#else
		setwindowtext(hwnd,text)
	#endif

end sub

sub ui_setmenu(byval hwnd as hwnd,byval hmenu as hmenu)
	
	#ifdef __fb_linux__
	#else
		setmenu(hwnd,hmenu)
	#endif
	
end sub