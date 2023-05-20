
Dim Shared hInstance As HINSTANCE
Dim Shared hooks As ADDINHOOKS
Dim Shared lpHandles As ADDINHANDLES Ptr
Dim Shared lpFunctions As ADDINFUNCTIONS Ptr
Dim Shared lpData As ADDINDATA Ptr

Type MNUITEM
	hmnu	As HMENU
	wid	As Integer
	ntype	As Integer
	txt	As ZString*64
	acl	As ZString*32
	img	As Integer
	wdt	As Integer
	hgt	As Integer
End Type

#define IDB_TOOLBAR				100
#define IDB_MNUARROW				101
#define IDB_MENUCHECK			102

Dim Shared hIml As HIMAGELIST
Dim Shared hGrayIml As HIMAGELIST
Dim Shared lpOldWndProc As Any Ptr
Dim Shared hMem As HGLOBAL
Dim Shared hMenu As HMENU
Dim Shared hMenuBrush As HBRUSH
Dim Shared hMnuFont As HFONT
Dim Shared MnuFontHt As Integer
Dim Shared nCheck As Integer

#define MIM_BACKGROUND			2
#define MIM_APPLYTOSUBMENUS	&H80000000
