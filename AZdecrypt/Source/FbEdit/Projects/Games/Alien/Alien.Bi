#define IDD_DLG1                1000
#define IDC_SHP1                1001
#define IDR_MENU                10000
#define IDM_FILE_NEW            10001
#define IDM_FILE_PAUSE          10002
#define IDM_FILE_EXIT           10003

#define IDR_ACCEL               1
#define IDB_ALIEN               100

dim SHARED hInstance as HINSTANCE
dim msg as MSG

dim SHARED hWnd as HWND
dim SHARED hShp as HWND
dim SHARED hIml as HIMAGELIST
dim SHARED hAcl as HACCEL
dim SHARED lpOldBoardProc as any ptr
dim SHARED mDC as HDC
dim SHARED hOldBmp as HBITMAP

#define MALIENSX			8		' Number of aliens in x direction
#define MALIENSY			6		' Number of aliens in y direction
#define MSHOTS				3		' Number of shots
#define MBOMBS				8		' Number of bombs
#define MSHIELDS			5		' Number of shields
#define MTIMER				30		' Speed

type OBJECT
	x		as Integer
	y		as Integer
	state	as Integer
end type

dim SHARED shots(MSHOTS-1) as OBJECT
dim SHARED bombs(MBOMBS-1) as OBJECT
dim SHARED shields(MSHIELDS*2-1) as OBJECT
dim SHARED aliens(MALIENSX*MALIENSY-1) as OBJECT
dim SHARED aliensmovex as Integer
dim SHARED aliensmovey as Integer
dim SHARED halt as Integer
dim SHARED goy as Integer
dim SHARED gunx as Integer
dim SHARED caliens as Integer
dim SHARED nguns as Integer
dim SHARED points as Integer
dim SHARED shot as Integer
dim SHARED naliens as Integer
