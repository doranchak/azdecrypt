'option explicit

#include once "windows.bi"

sub Module1(ByVal hWin as HWND)
	MessageBox(hWin,StrPtr("Module#1"),StrPtr("Module#1"),MB_OK)
end sub
