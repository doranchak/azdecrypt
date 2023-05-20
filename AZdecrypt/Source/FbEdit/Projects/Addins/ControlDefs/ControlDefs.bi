
dim SHARED hInstance as HINSTANCE
dim SHARED hooks as ADDINHOOKS
dim SHARED lpHandles as ADDINHANDLES ptr
dim SHARED lpFunctions as ADDINFUNCTIONS ptr
dim SHARED lpData as ADDINDATA ptr

#Define MaxCap		256
#Define MaxName	64

Type DIALOG
	hwnd			As HWND					' Set to TRUE
	hdmy			As HWND					' Handle of transparent window
	oldproc		As Any Ptr				' Set to NULL
	hpar			As HWND					' Set to NULL
	hcld			As HWND					' Set to NULL
	style			As Integer				' Set to desired style
	exstyle		As Integer				' Set to desired ex style
	dux			As Integer				' X position in dialog units
	duy			As Integer				' Y position in dialog units
	duccx			As Integer				' Width in dialog units
	duccy			As Integer				' Height in dialog units
	x				As Integer				' X position in pixels
	y				As Integer				' Y position in pixels
	ccx			As Integer				' Width in pixels
	ccy			As Integer				' Height in pixels
	caption		As ZString*MaxCap		' Caption max 255+1 char
	class			As ZString*32			' Set to Null string
	ntype			As Integer				' Follows ToolBox buttons Dialog=0, Edit=1, Static=2, GroupBox=3
	ntypeid		As Integer				' Set to NULL
	tab			As Integer				' Tab index, Dialog=0, First index=0
	id				As Integer				' Dialog / Controls ID
	idname		As ZString*MaxName	' ID Name, max 63+1 chars
	helpid		As Integer				' Help ID
	undo			As Integer				' Set to NULL
	himg			As Integer				' Set to NULL
End Type

Type CTLDBLCLICK
	nmhdr			As NMHDR
	lpDlgMem		As DIALOG Ptr
	nCtlId		As Integer
	lpCtlName	As ZString Ptr
	nDlgId		As Integer
	lpDlgName	As ZString Ptr
End Type
