
#Include Once "windows.bi"
#Include Once "win/richedit.bi"
#Include Once "win/commctrl.bi"

#Include "disasm.bi"
#Include "..\..\fbedit\inc\raedit.bi"
#Include "..\..\fbedit\inc\addins.bi"

'( tab ) for select: + 1300
Const TAB_0				= 0				'output
Const TAB_1				= 1				'var
Const TAB_2				= 2				'float
Const TAB_3				= 3				'string
Const TAB_4				= 4				'memory
Const TAB_5				= 5				'disassembler
Const TAB_6				= 6				'log
Const TAB_7				= 7				'choose tab (internal)

'( list )
Const LSV_1				= 0				'var
Const LSV_2				= 1				'float
Const LSV_3				= 2				'string
Const LSV_4				= 3				'memory
Const LSV_5				= 4				'disassembler
Const LSV_6				= 5				'log

'( typ )
Const TYP_INTEGER		= 0
Const TYP_DOUBLE		= 1
Const TYP_STRING		= 2

'( clear )
Const CLR_0				= &h1				'output
Const CLR_1				= &h2				'var
Const CLR_2				= &h4				'float
Const CLR_3				= &h8				'string
Const CLR_4				= &h10			'memory
Const CLR_5				= &h20			'disassembler
Const CLR_6				= &h40			'log

'( messages )
Const DBG_VAR			= WM_USER+1000	'add/update ( typ ).	wParam=( typ ), 	lParam=pointer MYDEBUGINF struct
Const DBG_LOG			= WM_USER+1001	'add logs ( typ ).	wParam=( typ ), 	lParam=pointer MYDEBUGINF struct
Const DBG_MEM			= WM_USER+1002	'add/update memory.	wParam=nlines, 	lParam=pointer MYDEBUGMEM struct
Const DBG_DIS			= WM_USER+1003	'add disassembler.	wParam=lenght,		lParam=pointer MYDEBUGMEM struct

Const DBG_SELECT		= WM_USER+1004	'Select tab.			wParam=( tab + 1300 ), 	lParam=0
Const DBG_CLEAR		= WM_USER+1005	'Clear tab.				wParam=( clear ),	lParam=0
Const DBG_STATE		= WM_USER+1006	'show/hide window.	wParam=TRUE/FALSE,lParam=0

Type MYDEBUGINF
	_Line		As Integer
	_Func		As ZString * 32
	_Path		As ZString * 260
	_File		As ZString * 260
	dLabel	As ZString * 32
	dString	As ZString * 128
	dInteger	As Integer
	dFloat	As Double
	iUpd		As Integer
End Type

Type MYDEBUGMEM
	_Line				As Integer
	_Func				As ZString * 32
	_Path				As ZString * 260
	_File				As ZString * 260
	dLabel			As ZString * 32
	dAddress			As Any ptr
	iUpd				As Integer
	iData ( 8192 )	As UByte				'max 512 lines ( 8kb )
End Type

Type MYDOCKWIN
	As Integer fDocked
	As RECT nPos
	As Integer nActualTab
	As Integer nLastTab
	As Integer nType
	As Integer tDelay
End Type

Type VIEWS
	As Integer nToolbar
	As Integer nTabselect
	As Integer nStatusbar
End Type

'callbacks
Declare Function DlgProc( ByVal hWnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM ) As Integer
Declare Function SelProc( ByVal hWnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM ) As Integer
Declare Function TabProc( ByVal hWnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM ) As Integer
Declare Function FBEProc( ByVal hWin As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM ) As Integer

'misc
Declare Sub InsertColumn( ByVal _hLvw As HWND, ByVal _iorder As Integer, ByVal _cx As Integer, ByRef _text As String )
Declare Function DumpLine( ByVal Address As Integer, ByVal bAscii As Integer ) As String
Declare Sub Set_Dock(ByVal hDlg As HWND, ByVal bDock As Integer)
Declare Sub myTimer()
Declare Function GetString( ByVal id As Integer, ByRef txt As String ) As String
Declare Sub GetFileNamePart( ByVal lpsrc As ZString Ptr, ByVal lpdst As ZString Ptr )
Declare Sub ChangeSeparator( ByVal txt As ZString Ptr )
Declare Sub GetViewSizes( ByVal v As VIEWS Ptr )

'functions
Declare Sub dbgInt( ByVal lpDBGINF As MYDEBUGINF ptr, ByVal bUpd As Integer )
Declare Sub dbgFlt( ByVal lpDBGINF As MYDEBUGINF ptr, ByVal bUpd As Integer )
Declare Sub dbgStr( ByVal lpDBGINF As MYDEBUGINF ptr, ByVal bUpd As Integer )
Declare Sub dbgMem( ByVal lpDBGMEM As MYDEBUGMEM ptr, ByVal ipos As Integer, ByVal bUpd As Integer )
Declare Sub dbgAsm( ByVal lpDBGMEM As MYDEBUGMEM ptr, ByVal ipos As Integer, ByVal bUpd As Integer )
Declare Sub logInt( ByVal lpDBGINF As MYDEBUGINF ptr )
Declare Sub logFlt( ByVal lpDBGINF As MYDEBUGINF ptr )
Declare Sub logStr( ByVal lpDBGINF As MYDEBUGINF ptr )

'addinfunc
Declare Sub AddToMenu( ByVal id As Integer, ByVal sMenu As String )
Declare Sub UpdateMenu( ByVal id As Integer, ByVal sMenu As String )
Declare Sub AddAccelerator( ByVal fvirt As Integer, ByVal akey As Integer, ByVal id As Integer )

Dim Shared As ADDINHOOKS hooks 
Dim Shared As ADDINDATA ptr lpData
Dim Shared As ADDINHANDLES ptr lpHandles
Dim Shared As ADDINFUNCTIONS ptr lpFunctions
Dim Shared As HINSTANCE hInstance
Dim Shared As HMENU hMenu
Dim Shared As HWND hDbgWin
Dim Shared As HWND hTabs( TAB_7 )
Dim Shared As HWND hList( LSV_6 )
Dim Shared As Integer nItems( LSV_6 )
Dim Shared As Integer bTabSelect
Dim Shared As Any ptr lpOldMain
Dim Shared As MYDOCKWIN dock1 = ( 1, (10, 10, 300, 200), 0, 1, 0, 2500 )
Dim Shared As VIEWS nSize

'id for menus
Dim Shared As Integer IDM_SHOWVARS_HIDE
Dim Shared As Integer IDM_SHOWVARS_NEXT
Dim Shared As Integer IDM_SHOWVARS_PREV
Dim Shared As Integer IDM_SHOWVARS_CLEAR

'from fbedit
#Define VIEW_OUTPUT				1
#Define VIEW_PROJECT				2
#Define VIEW_PROPERTY			4
#Define VIEW_TOOLBAR				8
#Define VIEW_TABSELECT			16
#Define VIEW_STATUSBAR			32
#Define VIEW_IMMEDIATE			64
#Define IDC_DIVIDER				1005
#Define IDC_DIVIDER2				1015
#Define IDC_IMGSPLASH			1017
#Define IDM_FILE_CLOSE			10012
#Define IDM_VIEW_OUTPUT			10092
#Define IDM_VIEW_IMMEDIATE		10085
#Define IDM_VIEW_PROJECT		10093
#Define IDM_VIEW_PROPERTY		10094

'rsrc
#Define IDD_DLG00               1000

'tabs
#Define IDD_TAB00               1100
#define IDD_TAB01               1101
#Define IDD_TAB02               1102
#define IDD_TAB03               1103
#Define IDD_TAB04               1104
#define IDD_TAB05               1105
#Define IDD_TAB06               1106
#define IDD_TAB07               1107

'listview
#Define IDC_LSV01               1201
#Define IDC_LSV02               1202
#Define IDC_LSV03               1203
#Define IDC_LSV04               1204
#Define IDC_LSV05               1205
#Define IDC_LSV06               1206

'selection
#Define IDC_RBN00               1300
#define IDC_RBN01               1301
#define IDC_RBN02               1302
#define IDC_RBN03               1303
#define IDC_RBN04               1304
#define IDC_RBN05               1305
#define IDC_RBN06               1306
