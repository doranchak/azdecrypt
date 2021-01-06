declare function CreateClass(byval hModule as HMODULE,byval fGlobal as Boolean) as Integer

' Styles
#define STYLE_PLAYBAR			1
#define STYLE_KEEPASPECT		2
#define STYLE_NOTIFY				4

' Messages
#define FBEVID_PLAY				WM_USER+0			' wParam=0, lParam=lpFileName
#define FBEVID_STOP				WM_USER+1			' wParam=0, lParam=0
#define FBEVID_GETMCIWND		WM_USER+2			' wParam=0, lParam=0

CONST szClassName=				"FBEVIDEO"

