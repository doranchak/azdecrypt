' Messages
#Define FBM_SETPATH				WM_USER+1	' bRefresh[FALSE,TRUE],lpszPath:ZString Ptr
#Define FBM_GETPATH				WM_USER+2	' 0,lpszPath:ZString Ptr
#Define FBM_SETFILTERSTRING	WM_USER+3	' bRefresh[FALSE,TRUE],lpszFilter:ZString Ptr
#Define FBM_GETFILTERSTRING	WM_USER+4	' 0,lpszFilter:ZString Ptr
#Define FBM_SETFILTER			WM_USER+5	' bRefresh[FALSE,TRUE],bFilter[FALSE,TRUE]
#Define FBM_GETFILTER			WM_USER+6	' 0,0|Integer
#Define FBM_SETSELECTED			WM_USER+7	' 0,lpszFile:ZString Ptr
#Define FBM_GETSELECTED			WM_USER+8	' 0,lpszFile:ZString Ptr
#Define FBM_SETBACKCOLOR		WM_USER+9	' 0,nColor:Integer
#Define FBM_GETBACKCOLOR		WM_USER+10	' 0,0|Integer
#Define FBM_SETTEXTCOLOR		WM_USER+11	' 0,nColor:Integer
#Define FBM_GETTEXTCOLOR		WM_USER+12	' 0,0|Integer
#Define FBM_GETIMAGELIST		WM_USER+13	' 0,0|HIMAGELIST
#Define FBM_SETTOOLTIP			WM_USER+14	' n:Integer,lpszTooltip:ZString Ptr

' Notifications
#Define FBN_PATHCHANGE			1
#Define FBN_DBLCLICK				2

Type FBNOTIFY
	nmhdr As NMHDR
	lpfile As ZString Ptr
End Type

' Styles
#Define FBSTYLE_FLATTOOLBAR	1
#Define FBSTYLE_DIVIDERLINE	2

Const szFBClassName As String="RAFileBrowser"
