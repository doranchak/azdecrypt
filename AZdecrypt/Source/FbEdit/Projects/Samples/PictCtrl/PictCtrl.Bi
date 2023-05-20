#define IDD_DLG1 1000 
#define IDC_BTN1 1001
#define IDC_BTN2 1002

#Define HIMETRIC_INCH		2540

Type OLE_XSIZE_HIMETRIC As Integer
Type OLE_YSIZE_HIMETRIC As Integer
Type OLE_XPOS_HIMETRIC As Integer
Type OLE_YPOS_HIMETRIC As Integer

Type MyIPicture
	QueryInterface as function(byval as Any ptr, byval as IID ptr, byval as PVOID ptr) as HRESULT
	AddRef as function(byval as Any ptr) as ULONG
	Release as function(byval as Any ptr) as ULONG
	get_Handle as function(byval as Any ptr, byval as OLE_HANDLE ptr) as HRESULT
	get_hPal as function(byval as Any ptr, byval as OLE_HANDLE ptr) as HRESULT
	get_Type as function(byval as Any ptr, byval as short ptr) as HRESULT
	get_Width as function(byval as Any ptr, byval as OLE_XSIZE_HIMETRIC ptr) as HRESULT
	get_Height as function(byval as Any ptr, byval as OLE_YSIZE_HIMETRIC ptr) as HRESULT
	Render as function(byval as Any ptr, byval as HDC, byval as integer, byval as integer, byval as integer, byval as integer, byval as OLE_XPOS_HIMETRIC, byval as OLE_YPOS_HIMETRIC, byval as OLE_XSIZE_HIMETRIC, byval as OLE_YSIZE_HIMETRIC, byval as RECT ptr) as HRESULT
	set_hPal as function(byval as Any ptr, byval as OLE_HANDLE) as HRESULT
	get_CurDC as function(byval as Any ptr, byval as HDC ptr) as HRESULT
	SelectPicture as function(byval as Any ptr, byval as HDC, byval as HDC ptr, byval as OLE_HANDLE ptr) as HRESULT
	get_KeepOriginalFormat as function(byval as Any ptr, byval as BOOL ptr) as HRESULT
	put_KeepOriginalFormat as function(byval as Any ptr, byval as BOOL) as HRESULT
	PictureChanged as function(byval as Any ptr) as HRESULT
	SaveAsFile as function(byval as Any ptr, byval as Any ptr, byval as BOOL, byval as LONG ptr) as HRESULT
	get_Attributes as function(byval as Any ptr, byval as PDWORD) as HRESULT
end type

Dim Shared pIPicture As Integer ptr
Dim Shared IPicture As MyIPicture ptr
Dim Shared IID_IPicture As GUID=(&H07BF80980,&H0BF32,&H0101A,{&H08B,&H0BB,&H000,&H0AA,&H000,&H030,&H00C,&H0AB})

type MyIStream
	QueryInterface as function (byval as Any ptr, byval as IID ptr, byval as PVOID ptr) as HRESULT
	AddRef as function (byval as Any ptr) as ULONG
	Release as function (byval as Any ptr) as ULONG
	Read as function (byval as Any ptr, byval as any ptr, byval as ULONG, byval as ULONG ptr) as HRESULT
	Write as function (byval as Any ptr, byval as any ptr, byval as ULONG, byval as ULONG ptr) as HRESULT
	Seek as function (byval as Any ptr, byval as LARGE_INTEGER, byval as DWORD, byval as ULARGE_INTEGER ptr) as HRESULT
	SetSize as function (byval as Any ptr, byval as ULARGE_INTEGER) as HRESULT
	CopyTo as function (byval as Any ptr, byval as IStream ptr, byval as ULARGE_INTEGER, byval as ULARGE_INTEGER ptr, byval as ULARGE_INTEGER ptr) as HRESULT
	Commit as function (byval as Any ptr, byval as DWORD) as HRESULT
	Revert as function (byval as Any ptr) as HRESULT
	LockRegion as function (byval as Any ptr, byval as ULARGE_INTEGER, byval as ULARGE_INTEGER, byval as DWORD) as HRESULT
	UnlockRegion as function (byval as Any ptr, byval as ULARGE_INTEGER, byval as ULARGE_INTEGER, byval as DWORD) as HRESULT
	Stat as function (byval as Any ptr, byval as STATSTG ptr, byval as DWORD) as HRESULT
	Clone as function (byval as Any ptr, byval as LPSTREAM ptr) as HRESULT
end type

Dim Shared pIStream As Any ptr
Dim Shared IStream As MyIStream ptr

Dim Shared hBmp As HBITMAP

Dim Shared szPicture(3) As String
Dim Shared i As Integer
