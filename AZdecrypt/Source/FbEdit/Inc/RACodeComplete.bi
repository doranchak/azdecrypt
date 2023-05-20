
' CodeCompleteListBox Styles
#Define STYLE_USEIMAGELIST		1
' CodeCompleteListBox Messages
#Define CCM_ADDITEM			WM_USER+0			' nType:Integer,pszString:ZString Ptr
#Define CCM_DELITEM			WM_USER+1			' nIndex:Integer,0
#Define CCM_GETITEM			WM_USER+2			' nIndex:Integer,0|ZString Ptr
#Define CCM_GETCOUNT			WM_USER+3			' 0,0|Integer
#Define CCM_CLEAR				WM_USER+4			' 0,0
#Define CCM_SETCURSEL		WM_USER+5			' nIndex:Integer,0
#Define CCM_GETCURSEL		WM_USER+6			' 0,0|Integer
#Define CCM_GETTOPINDEX		WM_USER+7			' 0,0|Integer
#Define CCM_SETTOPINDEX		WM_USER+8			' nIndex:Integer,0
#Define CCM_GETITEMRECT		WM_USER+9			' nIndex:Integer,lpRECT:RECT Ptr
#Define CCM_SETVISIBLE		WM_USER+10			' 0,0
#Define CCM_FINDSTRING		WM_USER+11			' nStartIndex:Integer,lpszString:ZString Ptr|Integer
#Define CCM_SORT				WM_USER+12			' bDescending[FALSE,TRUE],bDelDup[FALSE,TRUE]
#Define CCM_GETCOLOR			WM_USER+13			' 0,lpCC_COLOR:CC_COLOR Ptr
#Define CCM_SETCOLOR			WM_USER+14			' 0,lpCC_COLOR:CC_COLOR Ptr
#Define CCM_ADDLIST			WM_USER+15			' 0,lpCC_ADDLIST:CC_ADDLIST Ptr
#Define CCM_GETMAXWIDTH		WM_USER+16			' 0,0|Integer

Type CC_COLOR
	back As Integer
	text As Integer
End Type

Type CC_ADDLIST
	lpszList As ZString Ptr
	lpszFilter As ZString Ptr
	nType As Integer
End Type

' CodeCompleteToolTip Styles
#Define STYLE_USEPARANTESES	1
' CodeCompleteToolTip Messages
#Define TTM_SETITEM			WM_USER+0			' 0,lpTTITEM:TTITEM Ptr|Integer
#Define TTM_GETCOLOR			WM_USER+1			' 0,lpTT_COLOR:TT_COLOR Ptr
#Define TTM_SETCOLOR			WM_USER+2			' 0,lpTT_COLOR:TT_COLOR Ptr
#Define TTM_GETITEMNAME		WM_USER+3			' 0,lpTTITEM:TTITEM Ptr|ZString Ptr
#Define TTM_SCREENFITS		WM_USER+4			' 0,lpPOINT:Point Ptr
#Define TTM_GETITEMTYPE		WM_USER+5			' 0,lpTTITEM:TTITEM Ptr|ZString Ptr

Type TT_COLOR
	back As Integer
	text As Integer
	api As Integer
	hilite As Integer
End Type

Type TTITEM
	lpszApi As ZString Ptr							' Pointer to api string
	lpszParam As ZString Ptr						' Pointer to comma separated parameters string
	nitem As Integer									' Item to hilite
	lpszRetType As ZString Ptr						' Pointer to return type string
	lpszDesc As ZString Ptr							' Pointer to item description
	novr As Integer									' Totals of functions
	nsel As Integer									' Actual function
	nwidth As Integer									' Width of tooltip
End Type

Const szCCLBClassName = "RACodeComplete"
Const szCCTTClassName = "RAToolTip"
