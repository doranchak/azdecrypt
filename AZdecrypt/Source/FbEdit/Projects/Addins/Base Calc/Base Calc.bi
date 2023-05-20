#Define FORMCALC 1000
#Define IDC_HEX 1001
#Define IDC_DEC 1002
#Define IDC_BIN 1003
#Define IDC_OCT 1008

dim SHARED hInstance as HINSTANCE
dim SHARED hooks as ADDINHOOKS
dim SHARED lpHandles as ADDINHANDLES ptr
dim SHARED lpFunctions as ADDINFUNCTIONS ptr
dim SHARED lpData as ADDINDATA Ptr
dim SHARED IDM_BASECALC as Integer
Dim Shared hasChanged(0 To 3) As Byte
Dim Shared As WNDPROC HexProc,OctProc,BinProc