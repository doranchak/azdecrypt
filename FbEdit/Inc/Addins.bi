
#Define IDC_RESED								1100	' Resource editor
#Define IDC_CODEED							1200	' Code editor
#Define IDC_HEXED								1300	' Hex editor

#Ifndef RAFONT
Type RAFONT Field=1
	hFont				As HFONT							' Code edit normal
	hIFont			As HFONT							' Code edit italics
	hLnrFont			As HFONT							' Line numbers
End Type
#EndIf

' COLREF bits: WWWW 00IB bbbb gggg rrrr
' WWWW	Wordgroup (bit 28=Inline asm bit 29=RC file
' I		Italic
' B		Bold
' bbbb	Blue
' gggg	Green
' rrrr	Red

Type KWCOLOR
	C0					As COLORREF
	C1					As COLORREF
	C2					As COLORREF
	C3					As COLORREF
	C4					As COLORREF
	C5					As COLORREF
	C6					As COLORREF
	C7					As COLORREF
	C8					As COLORREF
	C9					As COLORREF
	C10				As COLORREF						' RC file
	C11				As COLORREF
	C12				As COLORREF						' Data types
	C13				As COLORREF						' Api structures
	C14				As COLORREF						' Api constants
	C15				As COLORREF						' Api calls
	C16				As COLORREF						' Custom 1
	C17				As COLORREF						' Custom 2
	C18				As COLORREF						' Custom 3
	C19				As COLORREF						' Inline asm instructions
	C20				As COLORREF						' Inline asm registers
End Type

#Ifndef RACOLOR
Type RACOLOR Field=1
	bckcol			As COLORREF						' Back color
	txtcol			As COLORREF						' Text color
	selbckcol		As COLORREF						' Sel back color
	seltxtcol		As COLORREF						' Sel text color
	cmntcol			As COLORREF						' Comment color
	strcol			As COLORREF						' String color
	oprcol			As COLORREF						' Operator color
	hicol1			As COLORREF						' Line hilite 1
	hicol2			As COLORREF						' Line hilite 2
	hicol3			As COLORREF						' Line hilite 3
	selbarbck		As COLORREF						' Selection bar
	selbarpen		As COLORREF						' Selection bar pen
	lnrcol			As COLORREF						' Line numbers color
	numcol			As COLORREF						' Numbers & hex color
	cmntback			As COLORREF						' Comment back color
	strback			As COLORREF						' String back color
	numback			As COLORREF						' Numbers & hex back color
	oprback			As COLORREF						' Operator back color
	changed			As COLORREF						' Line changed indicator
	changesaved		As COLORREF						' Line saved chane indicator
End Type
#EndIf

Type FBCOLOR
	racol 			As RACOLOR						' RAEdit control colors
	toolback 		As COLORREF						' Tools backcolor
	tooltext 		As COLORREF						' Tools textcolor
	dialogback 		As COLORREF						' Dialog backcolor
	dialogtext 		As COLORREF						' Dialog textcolor
	codelistback 	As COLORREF						' Code complete list back color
	codelisttext 	As COLORREF						' Code complete list text color
	codetipback 	As COLORREF						' Code tooltip back color
	codetiptext 	As COLORREF						' Code tooltip text color
	codetipapi 		As COLORREF						' Code tooltip api color
	codetipsel 		As COLORREF						' Code tooltip current item color
	propertiespar	As COLORREF						' Properties parameters color
End Type

Type THEME
	lpszTheme		As ZString Ptr					' Name of the theme
	kwc				As KWCOLOR						' 21 Keyword colors
	fbc				As FBCOLOR						' 20 Editor colors + 11 FbEdit colors
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
	hedit				As HWND							' Handle of the edit control
	filename			As ZString*260					' Filename
	profileinx		As Integer						' Project file index
	filestate		As Integer						' Changed state
	ft					As FILETIME						' Filetime last saved
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
	hregister		As HWND							' Debug register window.
	hfpu				As HWND							' Debug fpu window.
	hmmx				As HWND							' Debug mmx window.
	hdbgtab			As HWND							' Debug tab
End Type

Type ADDINDATA
	version			As Integer						' FbEdit version (currently 1076)
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
	fDebug			As Integer						' Project is beeing debugged
	fNoNotify		As Integer						' No handling of RAEdit WM_NOTIFY
	smakequickrun	As ZString*260					' Quick Run
	lpBuff			As ZString Ptr					' Pointer to internal ZString buffer
	lpszVersion		As ZString Ptr					' Pointer to version string
	nDbgTabSel		As Integer						' Selected Debug tab
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
	MakeProjectFileName As Function(ByVal sFile As String) As String
	HH_Help As Sub()
	IsProjectFile As Function(ByVal sFile As String) As Integer
End Type

' Addin messages you can send to FbEdit main window

#Define AIM_GETHANDLES		WM_USER+1000		' Returns a pointer to an ADDINHANDLES type
#Define AIM_GETDATA			WM_USER+1001		' Returns a pointer to an ADDINDATA type
#Define AIM_GETFUNCTIONS	WM_USER+1002		' Returns a pointer to an ADDINFUNCTIONS type
#Define AIM_GETMENUID		WM_USER+1003		' Returns a free menu ID. Use it if you add items to the menu.
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
#Define AIM_PROJECTREMOVE	19						' wParam=ProjectFileID, lParam=FileName
#Define AIM_PROJECTTOGGLE	20						' wParam=OldProjectFileID, lParam=NewProjectFileID

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
#Define HOOK_PROJECTREMOVE	&H80000
#Define HOOK_PROJECTTOGGLE	&H100000

' Hook flags in hook2, reserved for future use. Set to 0

' Hook flags in hook3, reserved for future use. Set to 0

' Hook flags in hook4, reserved for future use. Set to 0
