#define IDD_DLG1                1000
#define IDR_MENU                10000
#define IDM_FILE_GOTO1          10002
#define IDM_FILE_BACK           10003
#define IDM_FILE_FORWARD        10004
#Define IDM_FILE_EXIT           10001

type IID
    Data1 as uinteger
    Data2 as ushort 
    Data3 as ushort 
    Data4(0 to 7) as ubyte
end type

Type IUnknown
	QueryInterface As Function(ByVal pif As Any ptr,ByVal iid As IID ptr,ByVal pInterface As Any ptr) As Integer
	AddRef As Function(ByVal pif As Any ptr) As Integer
	Release As Function(ByVal pif As Any ptr) As Integer
End Type

Type IWebBrowser
	QueryInterface As Function(ByVal pif As Any ptr,ByVal iid As IID ptr,ByVal pInterface As Any ptr) As Integer
	AddRef As Function(ByVal pif As Any ptr) As Integer
	Release As Function(ByVal pif As Any ptr) As Integer
	GetTypeInfoCount As Function(ByVal pif As Any ptr,pctinfo As DWORD) As Integer
	GetTypeInfo As Function(ByVal pif As Any ptr,ByVal iTInfo As DWORD,ByVal lcid as DWORD,ByVal ppTInfo as DWORD) As Integer
	GetIDsOfNames As Function(ByVal pif As Any ptr,ByVal riid As DWORD,ByVal rgszNames as DWORD,ByVal cNames as DWORD,ByVal lcid as DWORD,ByVal rgDispId as DWORD) As Integer
	Invoke As Function(ByVal pif As Any ptr,ByVal dispIdMember As DWORD,ByVal riid As DWORD,ByVal lcid as DWORD,ByVal wFlags as DWORD,ByVal pDispParams as DWORD,ByVal pVarResult as DWORD,ByVal pExcepInfo as DWORD,ByVal puArgErr as DWORD) As Integer
	GoBack As Function(ByVal pif As Any ptr) As Integer
	GoForward As Function(ByVal pif As Any ptr) As Integer
	GoHome As Function(ByVal pif As Any ptr) As Integer
	GoSearch As Function(ByVal pif As Any ptr) As Integer
	Navigate As Function(ByVal pif As Any ptr,ByVal bstrURL as WString ptr,ByVal Flags as any ptr,ByVal TargetFrameName as any ptr,ByVal PostData as any ptr,ByVal Headers as any ptr) As Integer
End Type

Dim AtlAxWinInit As Function As Boolean
Dim Shared AtlAxGetControl As Function (ByVal hWin As HWND,ByRef pp As Integer ptr) As Integer

Dim Shared hDll As HMODULE
Dim Shared hInstance As HINSTANCE
Dim Shared hWeb As HWND

dim Shared IID_IWebBrowser As IID=(&H0EAB22AC1,&H030C1,&H011CF,{&H0A7,&H0EB,&H000,&H000,&H0C0,&H05B,&H0AE,&H00B})

Dim Shared pIUnknown As Integer ptr
Dim Shared IUnknown As IUnknown ptr
Dim Shared pIWebBrowser As Integer ptr
Dim Shared IWebBrowser As IWebBrowser ptr
