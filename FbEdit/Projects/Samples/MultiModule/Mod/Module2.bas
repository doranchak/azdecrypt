'option explicit

#include once "windows.bi"

sub Module2(ByVal hWin as HWND)
	MessageBox(hWin,StrPtr("Module#2"),StrPtr("Module#2"),MB_OK)
end sub
