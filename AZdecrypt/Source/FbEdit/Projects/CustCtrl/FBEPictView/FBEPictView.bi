Declare Function CreateClass(ByVal hModule As HMODULE,ByVal fGlobal As Boolean) As Integer

' Styles
#Define STYLE_SIZENONE				0
#Define STYLE_SIZECENTERIMAGE		1
#Define STYLE_SIZESTRETCH			2
#Define STYLE_SIZEKEEPASPECT		3
#Define STYLE_SIZESIZECONTROL		4

' Messages
#Define PVM_LOADFILE					WM_USER+1
#Define PVM_LOADRESOURCE			WM_USER+2

' Notifications
#Define PVN_CLICK						0
Type NMPVCLICK
	nmhdr As NMHDR
	pt As POINT
End Type

Const szClassName="FBEPICTVIEW"
