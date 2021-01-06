;#########################################################################
;		Assembler directives

.486
.model flat,stdcall
option casemap:none

;#########################################################################
;		Include file

include ProjectZip.inc
include Misc.asm
include Files.asm

.code

;#########################################################################
;		Common AddIn Procedures

DllEntry proc hInst:HINSTANCE,reason:DWORD,reserved1:DWORD

	mov		eax,hInst
	mov		hInstance, eax
	mov		eax,TRUE
	ret

DllEntry Endp

AddMenu proc
	LOCAL mii:MENUITEMINFO

	;Get handle of Project popup
	mov		mii.cbSize,sizeof MENUITEMINFO
	mov		mii.fMask,MIIM_SUBMENU
	mov		edx,lpHandles
	invoke GetMenuItemInfo,[edx].ADDINHANDLES.hmenu,10101,FALSE,addr mii
	;Add our menuitem
	invoke GetLangString,10000,offset szProjectZip
	invoke AppendMenu,mii.hSubMenu,MF_STRING,IDAddIn,eax
	ret

AddMenu endp

; Export this proc (it is autoexported if MakeDef is enabled with option 2)
InstallDll proc uses ebx hWin:DWORD,hInst:DWORD

	mov		ebx,hWin
	;Get pointer to handles struct
	invoke SendMessage,ebx,AIM_GETHANDLES,0,0
	mov		lpHandles,eax
	;Get pointer to proc struct
	invoke SendMessage,ebx,AIM_GETFUNCTIONS,0,0
	mov		lpProc,eax
	;Get pointer to data struct
	invoke SendMessage,ebx,AIM_GETDATA,0,0	
	mov		lpData,eax
	invoke SendMessage,ebx,AIM_GETMENUID,0,0
	mov		IDAddIn,eax
	invoke AddMenu
	mov		fHook.hook1,HOOK_COMMAND
	mov		eax,offset fHook
	ret 

InstallDll Endp

BrowseFolder proc hWin:HWND,nID:DWORD
	LOCAL	buffer[MAX_PATH]:BYTE

	mov		eax,hWin
	mov		bri.hwndOwner,eax
	xor		eax,eax
	mov		bri.pidlRoot,eax
	mov		bri.pszDisplayName,eax
	mov		bri.lpszTitle,eax
	mov		bri.ulFlags,BIF_RETURNONLYFSDIRS or BIF_STATUSTEXT
	mov		bri.lpfn,BrowseCallbackProc
	; get path
	invoke SendDlgItemMessage,hWin,nID,WM_GETTEXT,sizeof buffer,addr buffer
	mov		bri.lParam,offset szDestFolder
	mov		bri.iImage,0
	invoke SHBrowseForFolder,offset bri
	.if eax
		mov		pidl,eax
		invoke SHGetPathFromIDList,pidl,offset szDestFolder
		invoke lstrcpy,addr buffer,offset szDestFolder
		invoke lstrcat,addr buffer,offset szZipFile
		; set new path back to edit
		invoke SendDlgItemMessage,hWin,nID,WM_SETTEXT,0,addr buffer
	.endif
	ret

BrowseFolder endp

;--------------------------------------------------------------------------------
; set initial folder in browser
BrowseCallbackProc proc hWin:HWND,uMsg:UINT,lParam:LPARAM,pData:DWORD

	.if uMsg==BFFM_INITIALIZED
		invoke PostMessage,hWin,BFFM_SETSELECTION,TRUE,pData
		invoke PostMessage,hWin,BFFM_SETSTATUSTEXT,0,offset szProjectZip
	.endif
	xor eax, eax
	ret

BrowseCallbackProc endp

ListViewProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL	lvi:LV_ITEM
	LOCAL	buffer[MAX_PATH]:BYTE

	.if uMsg==WM_LBUTTONDBLCLK
		invoke SendMessage,hWin,LVM_GETNEXTITEM,-1,LVNI_FOCUSED
		.if eax!=-1
			mov		lvi.imask,LVIF_TEXT or LVIF_PARAM or LVIF_IMAGE
			mov		lvi.iItem,eax
			mov		lvi.iSubItem,0
			lea		eax,buffer
			mov		lvi.pszText,eax
			mov		lvi.cchTextMax,sizeof buffer
			invoke SendMessage,hWin,LVM_GETITEM,0,addr lvi
			mov		eax,lvi.iImage
			.if eax==0
				invoke lstrlen,offset szSourceFolder
				lea		eax,szSourceFolder[eax]
				.while byte ptr [eax]!='\' && eax>offset szSourceFolder
					dec		eax
				.endw
				.if byte ptr [eax-1]==':'
					inc		eax
				.endif
				mov		byte ptr [eax],0
				invoke FileDir,offset szSourceFolder,FALSE
			.elseif eax==1
				invoke lstrlen,offset szSourceFolder
				.if byte ptr szSourceFolder[eax-1]!='\'
					mov		word ptr szSourceFolder[eax],'\'
				.endif
				invoke lstrcat,offset szSourceFolder,addr buffer
				invoke FileDir,offset szSourceFolder,FALSE
			.endif
		.endif
	.endif
	invoke CallWindowProc,OldListViewProc,hWin,uMsg,wParam,lParam
	ret

ListViewProc endp

SelectAll proc uses ebx
	LOCAL	lvi:LV_ITEM

	xor		ebx,ebx
  @@:
	mov		lvi.imask,LVIF_IMAGE
	mov		lvi.iItem,ebx
	mov		lvi.iSubItem,0
	invoke SendMessage,hLV,LVM_GETITEM,0,addr lvi
	.if eax
		xor		eax,eax
		.if lvi.iImage
			mov		eax,LVIS_SELECTED
		.endif
		mov		lvi.stateMask,LVIS_SELECTED
		mov		lvi.state,eax
		invoke SendMessage,hLV,LVM_SETITEMSTATE,ebx,addr lvi
		inc		ebx
		jmp		@b
	.endif
	ret

SelectAll endp

DoZipFolder proc lpPth:DWORD
	LOCAL	buffer[MAX_PATH]:BYTE
	LOCAL	hwfd:DWORD

	;Make the path local
	invoke lstrcpy,addr buffer,lpPth
	;Check if path ends with '\'. If not, add.
	invoke lstrlen,addr buffer
	dec		eax
	.if buffer[eax]!='\'
		;Add '\'
		inc		eax
		mov		buffer[eax],'\'
	.endif
	;Add '*.*'
	inc		eax
	mov		dword ptr buffer[eax],'*.*'
	;Find first match, if any
	invoke FindFirstFile,addr buffer,addr wfd
	.if eax!=INVALID_HANDLE_VALUE
		;Save returned handle
		mov		hwfd,eax
	  Next:
		;Check if found is a dir
		mov		eax,wfd.dwFileAttributes
		and		eax,FILE_ATTRIBUTE_DIRECTORY
		.if eax
			;Do not include '.' and '..'
			mov		al,wfd.cFileName
			.if al!='.'
				invoke lstrlen,addr buffer
				mov		edx,eax
				push	edx
				sub		edx,3
				;Do not remove the '\'
				.if buffer[edx]=='\'
					inc		edx
				.endif
				;Add new dir to path
				invoke lstrcpy,addr buffer[edx],addr wfd.cFileName
				;Call myself again
				invoke DoZipFolder,addr buffer
				pop		edx
				;Remove what was added
				mov		buffer[edx],0
			.endif
		.else
			;Add file
			push	esi
			push	edi
			mov		edi,lpPth
			invoke lstrlen,edi
			lea		edi,[edi+eax]
			.while byte ptr [edi]!='\' && edi>lpPth
				dec		edi
			.endw
			mov		esi,offset szSkip
			.while byte ptr [esi]
				.if byte ptr [esi]=='\'
					.if byte ptr [edi]!='\'
						inc		esi
					.endif
					invoke lstrcmpi,esi,edi
					or		eax,eax
					je		@f
				.endif
				invoke lstrlen,esi
				lea		esi,[esi+eax+1]
			.endw
			invoke lstrcpy,offset szTemp,lpPth
			invoke lstrlen,offset szTemp
			mov		word ptr szTemp[eax],'\'
			invoke lstrcat,offset szTemp,addr wfd.cFileName
			invoke AddFileToZip,offset szTemp
		  @@:
			pop		edi
			pop		esi
		.endif
		;Any more matches?
		invoke FindNextFile,hwfd,addr wfd
		or		eax,eax
		jne		Next
		;No more matches, close handle
		invoke FindClose,hwfd
	.endif
	ret

DoZipFolder endp

DoZip proc uses ebx,fProject:DWORD
	LOCAL	lvi:LV_ITEM
	LOCAL	buffer[MAX_PATH]:BYTE

	invoke GetCurrentDirectory,sizeof szCurrentFolder,offset szCurrentFolder
	invoke SetCurrentDirectory,offset szSourceFolder
	invoke SendMessage,hED,WM_GETTEXT,sizeof buffer,addr buffer
	invoke GetFileAttributes,addr buffer
	.if eax!=-1
		test	eax,FILE_ATTRIBUTE_DIRECTORY
		.if ZERO?
			invoke GetLangString,2004,offset szOverwrite
			invoke lstrcpy,offset szTemp,eax 
			invoke lstrlen,addr buffer
			lea		edx,buffer
			.while byte ptr [edx+eax]!='\' && eax
				dec		eax
			.endw
			.if byte ptr [edx+eax]=='\'
				inc		eax
			.endif
			lea		edx,[edx+eax]
			invoke lstrcat,offset szTemp,edx
			invoke MessageBox,hDlg,offset szTemp,offset szProjectZip,MB_OKCANCEL or MB_ICONQUESTION
		.endif
	.else
		mov		eax,IDOK
	.endif
	.if eax==IDOK
		invoke lstrcpy,offset szTemp,addr buffer
		invoke lstrlen,offset szTemp
		lea		eax,szTemp[eax]
		.while byte ptr [eax]!='\' && eax>offset szTemp
			dec		eax
		.endw
		.if byte ptr [eax-1]==':' || byte ptr [eax-1]=='\'
			inc		eax
		.endif
		mov		byte ptr [eax],0
		invoke GetFileAttributes,offset szTemp
		.if eax==-1
			invoke CreateDirectory,offset szTemp,NULL
		.endif
		invoke CreateTheZip,addr buffer
		.if eax
			.if fProject
				mov		edx,lpData
				invoke lstrcpy,addr buffer,addr [edx].ADDINDATA.ProjectFile
				lea		ebx,buffer
				invoke lstrlen,ebx
				.while eax
					.break .if byte ptr [ebx+eax-1]=='\'
					dec		eax
				.endw
				invoke AddFileToZip,addr [ebx+eax]
				xor		ebx,ebx
				.while ebx<1500
					inc		ebx
					invoke BinToDec,ebx,addr buffer
					mov		edx,lpData
					invoke GetPrivateProfileString,addr szFile,addr buffer,addr szNULL,addr buffer,sizeof buffer,addr [edx].ADDINDATA.ProjectFile
					.if eax
						invoke lstrcpy,addr buffer,eax
						invoke AddFileToZip,addr buffer
					.endif
				.endw
			.else
				xor		ebx,ebx
			  @@:
				mov		lvi.imask,LVIF_TEXT or LVIF_IMAGE or LVIF_STATE
				mov		lvi.iItem,ebx
				mov		lvi.iSubItem,0
				lea		eax,buffer
				mov		lvi.pszText,eax
				mov		lvi.cchTextMax,sizeof buffer
				mov		lvi.stateMask,LVIS_SELECTED
				invoke SendMessage,hLV,LVM_GETITEM,0,addr lvi
				.if eax
					.if lvi.state && lvi.iImage
						.if lvi.iImage==2
							invoke AddFileToZip,addr buffer
						.else
							invoke DoZipFolder,addr buffer
						.endif
					.endif
					inc		ebx
					jmp		@b
				.endif
			.endif
			invoke CloseTheZip
			invoke GetLangString,2007,offset szDone
			invoke TextOutput,eax
		.else
			invoke GetLangString,2005,offset szError
			invoke lstrcpy,offset szTemp,eax
			invoke lstrcat,offset szTemp,addr buffer
			invoke MessageBox,hDlg,offset szTemp,offset szProjectZip,MB_OK or MB_ICONERROR
		.endif
	.endif
	invoke SetCurrentDirectory,offset szCurrentFolder
	ret

DoZip endp

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL	hCtl:HWND
	LOCAL	lvc:LV_COLUMN
	LOCAL	lvi:LV_ITEM
	LOCAL	rect:RECT
	LOCAL	hBmp:DWORD

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		mov		eax,hWin
		mov		hDlg,eax
		push	ebx
		mov		ebx,esp
		push	offset szAppName
		push	hWin
		mov		eax,lpProc
		call	[eax].ADDINFUNCTIONS.TranslateAddinDialog
		push	FALSE
		push	offset pos
		push	offset szPOS
		push	offset szKeyPos
		push	offset szApp
		mov		eax,lpProc
		call	[eax].ADDINFUNCTIONS.LoadFromIni
		mov		esp,ebx
		pop		ebx
		.if eax
			invoke MoveWindow,hWin,pos.x,pos.y,pos.wt,pos.ht,FALSE
		.endif
		mov		eax,lpData
		invoke GetPrivateProfileString,offset szApp,offset szKeySkip,offset szNULL,offset szSkip,sizeof szSkip,addr [eax].ADDINDATA.IniFile
		mov		eax,offset szSkip
		.while byte ptr [eax]
			.if byte ptr [eax]==';'
				mov		byte ptr [eax],0
			.endif
			inc		eax
		.endw
		;Create an imagelist
		invoke ImageList_Create,16,16,ILC_COLOR8,5,5
		mov		hIml,eax
		;Add images
		invoke LoadBitmap,hInstance,IDB_FILE
		mov		hBmp,eax
	    invoke ImageList_Add,hIml,hBmp,NULL
	    invoke DeleteObject,hBmp
		invoke GetDlgItem,hWin,IDC_LSVFILELIST
		mov		hLV,eax
		invoke GetDlgItem,hWin,IDC_LSTSORT
		mov		hLB,eax
		invoke SendMessage,hLV,LVM_SETIMAGELIST,LVSIL_SMALL,hIml
		mov		lvc.imask,LVCF_FMT or LVCF_TEXT or LVCF_WIDTH
		mov		lvc.fmt,LVCFMT_LEFT
		invoke GetLangString,2000,offset szName
		mov		lvc.pszText,eax
		mov		lvc.lx,170
		invoke SendMessage,hLV,LVM_INSERTCOLUMN,0,addr lvc
		mov		lvc.fmt,LVCFMT_RIGHT
		invoke GetLangString,2001,offset szSize
		mov		lvc.pszText,eax
		mov		lvc.lx,70
		invoke SendMessage,hLV,LVM_INSERTCOLUMN,1,addr lvc
		mov		lvc.fmt,LVCFMT_LEFT
		invoke GetLangString,2002,offset szDate
		mov		lvc.pszText,eax
		mov		lvc.lx,115
		invoke SendMessage,hLV,LVM_INSERTCOLUMN,2,addr lvc
		mov		edx,lpData
		.if byte ptr [edx].ADDINDATA.ProjectFile
			invoke lstrcpy,offset szSourceFolder,addr [edx].ADDINDATA.ProjectPath
		.else
			invoke lstrcpy,offset szSourceFolder,addr [edx].ADDINDATA.DefProjectPath
		.endif
		mov		eax,lpData
		invoke GetPrivateProfileInt,offset szApp,offset szKeyOpt,0,addr [eax].ADDINDATA.IniFile
		mov		fOption,eax
		mov		eax,lpData
		invoke GetPrivateProfileString,offset szApp,offset szKeyFolder,offset szNULL,offset szDestFolder,sizeof szDestFolder,addr [eax].ADDINDATA.IniFile
		.if !eax
			mov		edx,lpData
			invoke lstrcpy,offset szDestFolder,addr [edx].ADDINDATA.DefProjectPath
			invoke lstrcat,offset szDestFolder,offset szArchive
		.endif
		invoke GetDlgItem,hWin,IDC_EDTFOLDER
		mov		hED,eax
		invoke SendMessage,hED,EM_LIMITTEXT,MAX_PATH-1,0
		invoke GetDlgItem,hWin,IDC_BTNFOLDER
		invoke SendMessage,eax,WM_SETFONT,NULL,FALSE
		invoke SetWindowLong,hLV,GWL_WNDPROC,offset ListViewProc
		mov		OldListViewProc,eax
		xor		eax,eax
		mov		edx,lpData
		.if byte ptr [edx].ADDINDATA.ProjectFile
			inc		eax
		.endif
		invoke FileDir,offset szSourceFolder,eax
		mov		edx,lpData
		.if byte ptr [edx].ADDINDATA.ProjectFile
			invoke GetDlgItem,hWin,IDC_BTNZIPPROJECT
			invoke EnableWindow,eax,TRUE
		.endif
	.elseif eax==WM_COMMAND
		mov		edx,wParam
		movzx	eax,dx
		shr		edx,16
		.if edx==BN_CLICKED
			.if eax==IDC_BTNZIP
				invoke DoZip,FALSE
			.elseif eax==IDC_BTNZIPPROJECT
				mov		edx,lpData
				invoke lstrcpy,offset szSourceFolder,addr [edx].ADDINDATA.ProjectPath
				mov		edx,lpData
				invoke FileDir,addr [edx].ADDINDATA.ProjectPath,TRUE
				invoke DoZip,TRUE
			.elseif eax==IDC_BTNSELECTALL
				invoke SelectAll
			.elseif eax==IDC_BTNEXIT
				invoke SendMessage,hWin,WM_CLOSE,0,0
			.elseif eax==IDC_BTNFOLDER
				invoke BrowseFolder,hWin,IDC_EDTFOLDER
			.endif
		.endif
	.elseif eax==WM_NOTIFY
		.if wParam==IDC_LSVFILELIST
			mov		edx,lParam
			mov		eax,[edx].NM_LISTVIEW.hdr.code
			.if eax==LVN_ITEMCHANGED
				.if ![edx].NM_LISTVIEW.iItem
					mov		lvi.imask,LVIF_IMAGE or LVIF_STATE
					mov		lvi.iItem,0
					mov		lvi.iSubItem,0
					mov		lvi.stateMask,LVIS_SELECTED
					invoke SendMessage,hLV,LVM_GETITEM,0,addr lvi
					.if !lvi.iImage && lvi.state
						mov		lvi.state,0
						invoke SendMessage,hLV,LVM_SETITEMSTATE,0,addr lvi
					.endif
				.endif
				invoke SendMessage,hLV,LVM_GETSELECTEDCOUNT,0,0
				push	ebx
				xor		ebx,ebx
				.if eax
					inc		ebx
				.endif
				invoke GetDlgItem,hWin,IDC_BTNZIP
				invoke EnableWindow,eax,ebx
				pop		ebx
			.endif
		.endif
	.elseif eax==WM_CLOSE
		invoke GetWindowRect,hWin,addr pos
		mov		eax,pos.x
		sub		pos.wt,eax
		mov		eax,pos.y
		sub		pos.ht,eax
		push	ebx
		mov		ebx,esp
		push	FALSE
		push	offset pos
		push	offset szPOS
		push	offset szKeyPos
		push	offset szApp
		mov		eax,lpProc
		call	[eax].ADDINFUNCTIONS.SaveToIni
		mov		esp,ebx
		pop		ebx
		invoke ImageList_Destroy,hIml
		invoke EndDialog,hWin,0
	.elseif eax==WM_SIZE
		xor		eax,eax
		mov		rect.left,eax
		mov		rect.top,eax
		mov		eax,lParam
		movzx	edx,ax
		shr		eax,16
		mov		rect.right,edx
		mov		rect.bottom,eax
		invoke GetDlgItem,hWin,IDC_BTNFOLDER
		mov		edx,rect.right
		sub		edx,22
		invoke MoveWindow,eax,edx,2,21,21,TRUE
		invoke GetDlgItem,hWin,IDC_EDTFOLDER
		mov		edx,rect.right
		sub		edx,74+22
		invoke MoveWindow,eax,74,2,edx,21,TRUE
		invoke GetDlgItem,hWin,IDC_EDTCURRENT
		mov		edx,rect.right
		sub		edx,74
		invoke MoveWindow,eax,74,25,edx,21,TRUE
		invoke GetDlgItem,hWin,IDC_LSVFILELIST
		mov		edx,rect.bottom
		sub		edx,28+23+28
		invoke MoveWindow,eax,0,28+23,rect.right,edx,TRUE
		invoke GetDlgItem,hWin,IDC_BTNSELECTALL
		mov		edx,rect.bottom
		sub		edx,28-3
		invoke MoveWindow,eax,3,edx,85,21,TRUE
		invoke GetDlgItem,hWin,IDC_BTNZIP
		mov		edx,rect.bottom
		sub		edx,28-3
		invoke MoveWindow,eax,3+85+3,edx,85,21,TRUE
		invoke GetDlgItem,hWin,IDC_BTNZIPPROJECT
		mov		edx,rect.bottom
		sub		edx,28-3
		invoke MoveWindow,eax,3+85+3+85+3,edx,85,21,TRUE
		invoke GetDlgItem,hWin,IDC_BTNEXIT
		mov		edx,rect.bottom
		sub		edx,28-3
		mov		ecx,rect.right
		sub		ecx,3+85
		.if sdword ptr ecx<3+85+3+85+3+85+3
			mov		ecx,3+85+3+85+3+85+3
		.endif
		invoke MoveWindow,eax,ecx,edx,85,21,TRUE
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

; Export this proc (it is autoexported if MakeDef is enabled with option 2)
DllFunction proc hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	; This proc handles messages sent from RadASM to our dll
	; Return TRUE to prevent RadASM and other DLL's from

	mov		eax,uMsg
	.if eax==AIM_COMMAND
		mov		edx,wParam
		movzx	eax,dx
		shr		edx,16
		.if eax==IDAddIn && edx==BN_CLICKED
			; Your addin has been selected
			invoke DialogBoxParam,hInstance,IDD_DIALOG1,hWin,offset DlgProc,0
		.endif
	.endif
	mov		eax,FALSE
	ret

DllFunction Endp

;#########################################################################

End DllEntry
