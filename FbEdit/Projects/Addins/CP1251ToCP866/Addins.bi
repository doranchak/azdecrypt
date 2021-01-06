
#Define IDC_RESED								1100
#Define IDC_CODEED							1200
#Define IDC_HEXED								1300

#Ifndef RAFONT
Type RAFONT Field=1
	hFont				As HFONT							' Code edit normal
	hIFont			As HFONT							' Code edit italics
	hLnrFont			As HFONT							' Line numbers
End Type
#EndIf

#Ifndef RACOLOR
Type RACOLOR Field=1
	bckcol			As Integer						' Back color
	txtcol			As Integer						' Text color
	selbckcol		As Integer						' Sel back color
	seltxtcol		As Integer						' Sel text color
	cmntcol			As Integer						' Comment color
	strcol			As Integer						' String color
	oprcol			As Integer						' Operator color
	hicol1			As Integer						' Line hilite 1
	hicol2			As Integer						' Line hilite 2
	hicol3			As Integer						' Line hilite 3
	selbarbck		As Integer						' Selection bar
	selbarpen		As Integer						' Selection bar pen
	lnrcol			As Integer						' Line numbers color
	numcol			As Integer						' Numbers & hex color
End Type
#EndIf

Type FBCOLOR
	racol 			As RACOLOR						' RAEdit control colors
	toolback 		As Integer						' Tools backcolor
	tooltext 		As Integer						' Tools textcolor
	dialogback 		As Integer						' Dialog backcolor
	dialogtext 		As Integer						' Dialog textcolor
	codelistback 	As Integer
	codelisttext 	As Integer
	codetipback 	As Integer
	codetiptext 	As Integer
	codetipapi 		As Integer
	codetipsel 		As Integer
	propertiespar	As Integer
End Type

Type WINPOS
	fmax				As Integer						' Main window is maximized
	x					As Integer						' Main window x-pos
	y					As Integer						' Main window y-pos
	wt					As Integer						' Main window width
	ht					As Integer						' Main window height
	fview				As Integer						' Flags
	ptstyle			As Point							' Style manager position
	htout				As Integer						' Height of output
	wtpro				As Integer						' Width of project
	ptfind			As Point							' Find dialog position
	ptgoto			As Point							' Goto dialog position
	singleinstance	As Integer						' Single instance
	ptcclist			As Point							' Code complete size
	ptsavelist		As Point							' Save list position
End Type

Type TABMEM
	hedit				As HWND
	filename			As ZString*260
	profileinx		As Integer
	filestate		As Integer
	ft					As FILETIME
End Type

Type ADDINHOOKS
	hook1				As UINT							' Hook flags for addin message 0 - 31
	hook2				As UINT							' Hook flags for addin message 32 - 63
	hook3				As UINT							' Hook flags for addin message 64 - 95
	hook4				As UINT							' Hook flags for addin message 96 - 127
End Type

Type ADDINHANDLES
	hwnd				As HWND							' Handle of FbEdit main window
	hred				As HWND							' Handle of text or resource edit window
	hres				As HWND							' Handle of resource edit window
	htoolbar			As HWND							' Handle of FbEdit toolbar
	hsbr				As HWND							' Handle of FbEdit statusbar
	hout				As HWND							' Handle of output window
	hmenu				As HMENU							' FbEdit main menu
	hcontextmenu	As HMENU							' Context menu
	htabtool			As HWND							' File tab
	hshp				As HWND							' Main window background
	htab				As HWND							' File / Project tab
	hfib				As HWND							' File browser control
	hprj				As HWND							' Project treeview
	hpr				As HWND							' Property control
	hfullscreen		As HWND							' Fullscreen container
	hfind				As HWND							' Find or Goto dialog
	hcc				As HWND							' Code complete
	htt				As HWND							' Code complete tooltip
	rafnt				As RAFONT						' Code edit fonts
	haccel			As HACCEL						' Accelerator table
	himl				As HIMAGELIST					' Project treeview imagelist
	hmnuiml			As HIMAGELIST					' Menu arrows imagelist
	hcbobuild		As HWND							' Handle of build option combobox
	hOutFont			As HFONT							' Output window font
	hpane(1)			As HWND							' Handle of text or resource edit window in 2'nd pane
	hraresed			As HWND							' Handle of RAResEd window
	hrareseddlg		As HWND							' Handle of RAResEd dialog
	himm				As HWND							' Handle of immediate window
	hToolFont		As HFONT							' Tool windows font
End Type

Type ADDINDATA
	version			As Integer						' FbEdit version (currently 1066)
	AppPath			As ZString*260					' Path where FbEdit.exe is found
	ProjectPath		As ZString*260					' Path to current project
	DefProjectPath	As ZString*260					' Default project path
	IniFile			As ZString*260					' FbEdit.ini
	ProjectFile		As ZString*260					' ?.fbp
	fbcPath			As ZString*260					' Path to compiler
	lpFBCOLOR		As FBCOLOR Ptr					' Colors
	smake				As ZString*260					' Make compile command
	smakemodule		As ZString*260					' Make compile module command
	smakeoutput		As ZString*260					' Make output filename
	smakerun			As ZString*260					' Run commamd line parameters
	smakerundebug	As ZString*260					' External debugger
	filename			As ZString*260					' Current open file
	resexport		As ZString*260					' Projectt resource export setting.
	tbwt				As Integer						' Width of toolbar
	lpWINPOS			As WINPOS Ptr					' Window positions and sizes
	lpCharTab		As Any Ptr						' Pointer to RAEdit character table
	hLangMem			As HGLOBAL						' Language translation
	bExtOutput		As Integer						' External Output
	HelpPath			As ZString*260					' Path to help files
	fDebug			As Boolean						' Project is beeing debugged
	fNoNotify		As Boolean						' No handling of RAEdit WM_NOTIFY
End Type

Type ADDINFUNCTIONS
	TextToOutput As Sub(ByVal sText As String)
	SaveToIni As Sub(ByVal lpszApp As ZString Ptr,ByVal lpszKey As ZString Ptr,ByVal lpszTypes As ZString Ptr,ByVal lpDta As Any Ptr,ByVal fProject As Boolean)
	LoadFromIni As Function(ByVal lpszApp As ZString Ptr,ByVal lpszKey As ZString Ptr,ByVal szTypes As String,ByVal lpDta As Any Ptr,ByVal fProject As Boolean) As Boolean
	OpenTheFile As Sub(ByVal sFile As String,ByVal fHex As Boolean)
	Compile As Function(ByVal sMake As String) As Integer
	ShowOutput As Sub(ByVal bShow As Boolean)
	TranslateAddinDialog As Sub(ByVal hWin As HWND,ByVal sID As String)
	FindString As Function(ByVal hMem As HGLOBAL,ByVal szApp As String,ByVal szKey As String) As String
	CallAddins As Function(ByVal hWin As HWND,ByVal uMsg As UINT,wParam As WPARAM,lParam As LPARAM,ByVal hook1 As UINT) As Integer
	ShowImmediate As Sub(ByVal bShow As Boolean)
End Type

' Addin messages you can send to FbEdit main window

#Define AIM_GETHANDLES		WM_USER+1000		' Returns a pointer to an ADDINHANDLES type
#Define AIM_GETDATA			WM_USER+1001		' Returns a pointer to an ADDINDATA type
#Define AIM_GETFUNCTIONS	WM_USER+1002		' Returns a pointer to an ADDINFUNCTIONS type (not implemented)
#Define AIM_GETMENUID		WM_USER+1003		' Returns a free menu id. Use it if you add items to the menu.
#Define AIM_OPENFILE			WM_USER+1004		' wParam=fHex, lParam=lpFileName

' Messages sendt to your addin if they are hooked

#Define AIM_COMMAND			0						' wParam and lParam as for WM_COMMAND. Return TRUE to prevent FbEdit executing the command.
#Define AIM_CLOSE				1						' wParam and lParam as for WM_CLOSE. Return TRUE to prevent FbEdit from closing.
#Define AIM_PROJECTOPEN		2						' wParam=0 lParam=0
#Define AIM_PROJECTCLOSE	3						' wParam=0 lParam=0
#Define AIM_FILEOPEN			4						' wParam=0 lParam=FileName. Return TRUE to prevent FbEdit from opening the file.
#Define AIM_FILECLOSE		5						' wParam=0 lParam=FileName
#Define AIM_ADDINSLOADED	6						' wParam=0 lParam=0
#Define AIM_MENUREFRESH		7						' wParam=0 lParam=0
#Define AIM_FILESTATE		8						' wParam=tabindex lParam=lpTABMEM
#Define AIM_MAKEBEGIN		9						' wParam= lParam=
#Define AIM_MAKEDONE			10						' wParam= lParam=
#Define AIM_GETTOOLTIP		11						' wParam=id lParam=0
#Define AIM_CTLDBLCLK		12						' wParam=0 lParam=lpCTLDBLCLICK
#Define AIM_MENUENABLE		13						' wParam=0 lParam=0
#Define AIM_FILEOPENNEW		14						' wParam=Handle, lParam=FileName.
#Define AIM_QUERYCLOSE		15						' wParam and lParam as for WM_CLOSE. Return TRUE to prevent FbEdit from closing.
#Define AIM_CONTEXTMEMU		16						' wParam and lParam as for WM_CONTEXTMENU
#Define AIM_FILESAVED		17						' wParam=0 lParam=FileName
#Define AIM_CREATEEDIT		18						' wParam=hWnd, lParam=0

' Hookflags are bits set in a 32bit word
' Hook flags in hook1
#Define HOOK_COMMAND			&H1
#Define HOOK_CLOSE			&H2
#Define HOOK_PROJECTOPEN	&H4
#Define HOOK_PROJECTCLOSE	&H8
#Define HOOK_FILEOPEN		&H10
#Define HOOK_FILECLOSE		&H20
#Define HOOK_ADDINSLOADED	&H40
#Define HOOK_MENUREFRESH	&H80
#Define HOOK_FILESTATE		&H100
#Define HOOK_MAKEBEGIN		&H200
#Define HOOK_MAKEDONE		&H400
#Define HOOK_GETTOOLTIP		&H800
#Define HOOK_CTLDBLCLK		&H1000
#Define HOOK_MENUENABLE		&H2000
#Define HOOK_FILEOPENNEW	&H4000
#Define HOOK_QUERYCLOSE		&H8000
#Define HOOK_CONTEXTMEMU	&H10000
#Define HOOK_FILESAVED		&H20000
#Define HOOK_CREATEEDIT		&H40000

' Hook flags in hook2, reserved for future use. Set to 0

' Hook flags in hook3, reserved for future use. Set to 0

' Hook flags in hook4, reserved for future use. Set to 0
