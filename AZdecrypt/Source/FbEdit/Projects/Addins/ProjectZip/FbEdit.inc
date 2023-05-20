
RAFONT Struct
	hFont				dd ?				; Code edit normal
	hIFont				dd ?				; Code edit italics
	hLnrFont			dd ?				; Line numbers
RAFONT Ends

RACOLOR Struct
	bckcol				dd ?				; Back color
	txtcol				dd ?				; Text color
	selbckcol			dd ?				; Sel back color
	seltxtcol			dd ?				; Sel text color
	cmntcol				dd ?				; Comment color
	strcol				dd ?				; String color
	oprcol				dd ?				; Operator color
	hicol1				dd ?				; Line hilite 1
	hicol2				dd ?				; Line hilite 2
	hicol3				dd ?				; Line hilite 3
	selbarbck			dd ?				; Selection bar
	selbarpen			dd ?				; Selection bar pen
	lnrcol				dd ?				; Line numbers color
	numcol				dd ?				; Numbers & hex color
RACOLOR Ends

FBCOLOR Struct
	racol 				RACOLOR <?>			; RAEdit control colors
	toolback 			dd ?				; Tools backcolor
	tooltext 			dd ?				; Tools textcolor
	dialogback 			dd ?				; Dialog backcolor
	dialogtext 			dd ?				; Dialog textcolor
	codelistback 		dd ?
	codelisttext 		dd ?
	codetipback 		dd ?
	codetiptext 		dd ?
	codetipapi 			dd ?
	codetipsel 			dd ?
	propertiespar		dd ?
FBCOLOR Ends

WINPOS Struct
	fmax				dd ?				; Main window is maximized
	x					dd ?				; Main window x-pos
	y					dd ?				; Main window y-pos
	wt					dd ?				; Main window width
	ht					dd ?				; Main window height
	fview				dd ?				; Flags
	ptstyle				POINT <?>			; Style manager position
	htout				dd ?				; Height of output
	wtpro				dd ?				; Width of project
	ptfind				POINT <?>			; Find dialog position
	ptgoto				POINT <?>			; Goto dialog position
	singleinstance		dd ?				; Single instance
	ptcclist			POINT <?>			; Code complete size
	ptsavelist			POINT <?>			; Save list position
WINPOS Ends

ADDINHOOKS Struct
	hook1				dd ?				; Hook flags for addin message 0 - 31
	hook2				dd ?				; Hook flags for addin message 32 - 63
	hook3				dd ?				; Hook flags for addin message 64 - 95
	hook4				dd ?				; Hook flags for addin message 96 - 127
ADDINHOOKS Ends

ADDINHANDLES Struct
	hwnd				dd ?				; Handle of FbEdit main window
	hred				dd ?				; Handle of text or resource edit window
	hres				dd ?				; Handle of resource edit window
	htoolbar			dd ?				; Handle of FbEdit toolbar
	hsbr				dd ?				; Handle of FbEdit statusbar
	hout				dd ?				; Handle of output window
	hmenu				dd ?				; FbEdit main menu
	hcontextmenu		dd ?				; Context menu
	htabtool			dd ?				; File tab
	hshp				dd ?				; Main window background
	htab				dd ?				; File / Project tab
	hfib				dd ?				; File browser control
	hprj				dd ?				; Project treeview
	hpr					dd ?				; Property control
	hfullscreen			dd ?				; Fullscreen container
	hfind				dd ?				; Find or Goto dialog
	hcc					dd ?				; Code complete
	htt					dd ?				; Code complete tooltip
	rafnt				RAFONT <?>			; Code edit fonts
	haccel				dd ?				; Accelerator table
	himl				dd ?				; Project treeview imagelist
	hmnuiml				dd ?				; Menu arrows imagelist
	hcbobuild			dd ?				; Handle of build option combobox
	hOutFont			dd ?				; Output window font
	hpane0				dd ?				; Handle of text or resource edit window in 2'nd pane
	hpane1				dd ?				; Handle of text or resource edit window in 2'nd pane
ADDINHANDLES Ends

ADDINDATA Struct
	version				dd ?				; FbEdit version (currently 1022)
	AppPath				db 260 dup(?)		; Path where FbEdit.exe is found
	ProjectPath			db 260 dup(?)		; Path to current project
	DefProjectPath		db 260 dup(?)		; Default project path
	IniFile				db 260 dup(?)		; FbEdit.ini
	ProjectFile			db 260 dup(?)		; ?.fbp
	fbcPath				db 260 dup(?)		; Path to compiler
	lpFBCOLOR			dd ?				; Colors
	smake				db 260 dup(?)		; Make compile command
	smakemodule			db 260 dup(?)		; Make compile module command
	smakeoutput			db 260 dup(?)		; Make output filename
	smakerun			db 260 dup(?)		; Run commamd line parameters
	smakerundebug		db 260 dup(?)		; External debugger
	filename			db 260 dup(?)		; Current open file
	resexport			db 260 dup(?)		; Projectt resource export setting.
	tbwt				dd ?				; Width of toolbar
	lpWINPOS			dd ?				; Window positions and sizes
	lpCharTab			dd ?				; Pointer to RAEdit character table
	hLangMem			dd ?				; Language translation
ADDINDATA Ends

ADDINFUNCTIONS Struct
	TextToOutput		dd ?				;As Sub(ByVal sText As String)
	SaveToIni			dd ?				;As Sub(ByVal lpszApp As ZString Ptr,ByVal lpszKey As ZString Ptr,ByVal szTypes As String,ByVal lpDta As Any Ptr,ByVal fProject As Boolean)
	LoadFromIni			dd ?				;As Function(ByVal lpszApp As ZString Ptr,ByVal lpszKey As ZString Ptr,ByVal szTypes As String,ByVal lpDta As Any Ptr,ByVal fProject As Boolean) As Boolean
	OpenTheFile			dd ?				;As Sub(ByVal sFile As String)
	Compile				dd ?				;As Function(ByVal sMake As String) As Integer
	ShowOutput			dd ?				;As Sub(ByVal bShow As Boolean)
	TranslateAddinDialog dd ?				;As Sub(ByVal hWin As HWND,ByVal sID As String)
	FindString 			dd ?				;As Function(ByVal hMem As HGLOBAL,ByVal szApp As String,ByVal szKey As String) As String
ADDINFUNCTIONS Ends

; Addin messages you can send to FbEdit main window

AIM_GETHANDLES			equ WM_USER+1000	; Returns a pointer to an ADDINHANDLES type
AIM_GETDATA				equ WM_USER+1001	; Returns a pointer to an ADDINDATA type
AIM_GETFUNCTIONS		equ WM_USER+1002	; Returns a pointer to an ADDINFUNCTIONS type (not implemented)
AIM_GETMENUID			equ WM_USER+1003	; Returns a free menu id. Use it if you add items to the menu.

; Messages sendt to your addin if they are hooked

AIM_COMMAND				equ 0				; wParam and lParam as for WM_COMMAND. Return TRUE to prevent FbEdit executing the command.
AIM_CLOSE				equ 1				; wParam and lParam as for WM_CLOSE. Return TRUE to prevent FbEdit from closing.
AIM_PROJECTOPEN			equ 2				; wParam=0 lParam=0
AIM_PROJECTCLOSE		equ 3				; wParam=0 lParam=0
AIM_FILEOPEN			equ 4				; wParam=0 lParam=FileName. Return TRUE to prevent FbEdit from opening the file.
AIM_FILECLOSE			equ 5				; wParam=0 lParam=FileName
AIM_ADDINSLOADED		equ 6				; wParam=0 lParam=0
AIM_MENUREFRESH			equ 7				; wParam=0 lParam=0
AIM_FILESTATE			equ 8				; wParam=tabindex lParam=lpTABMEM
AIM_MAKEBEGIN			equ 9				; wParam= lParam=
AIM_MAKEDONE			equ 10				; wParam= lParam=
AIM_GETTOOLTIP			equ 11				; wParam=id lParam=0

; Hookflags are bits set in a 32bit word
; Hook flags in hook1
HOOK_COMMAND			equ 1h
HOOK_CLOSE				equ 2h
HOOK_PROJECTOPEN		equ 4h
HOOK_PROJECTCLOSE		equ 8h
HOOK_FILEOPEN			equ 10h
HOOK_FILECLOSE			equ 20h
HOOK_ADDINSLOADED		equ 40h
HOOK_MENUREFRESH		equ 80h
HOOK_FILESTATE			equ 100h
HOOK_MAKEBEGIN			equ 200h
HOOK_MAKEDONE			equ 400h
HOOK_GETTOOLTIP			equ 800h

; Hook flags in hook2, reserved for future use. Set to 0

; Hook flags in hook3, reserved for future use. Set to 0

; Hook flags in hook4, reserved for future use. Set to 0
