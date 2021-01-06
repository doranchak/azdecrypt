#Define IDD_DLG1		1000
#Define IDC_BTNSTART	1003
#Define IDC_BTNSTOP	1001
#Define IDC_LSTFILES	1002
#Define IDC_STCFILES	1004
#Define IDC_EDTPATH	1005
#Define IDC_EDTFILE	1006

Dim Shared hInstance As HMODULE
Dim Shared hWnd As HWND
Dim Shared hThread As HANDLE
Dim Shared szTmp As ZString*MAX_PATH
Dim Shared szFilter As ZString*16
Dim Shared i As Integer
Const szDefPath="C:\FbEdit\Projects"
Const szDefFile="*.fbp"
Const szOpen="Open"
