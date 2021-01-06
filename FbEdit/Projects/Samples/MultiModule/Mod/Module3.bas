'option explicit

#include once "windows.bi"

sub Module3(ByVal hWin as HWND)
	MessageBox(hWin,StrPtr("Module#3"),StrPtr("Module#3"),MB_OK)
end sub
