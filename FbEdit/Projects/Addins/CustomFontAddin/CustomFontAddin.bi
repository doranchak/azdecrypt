#Define IDD_DLG1 1000 
#Define IDC_BROWSE 1001
#Define IDC_OK 1003
#Define IDC_CANCEL 1004
#Define IDC_EDT1 1002

Const szNULL=!"\0"
Const szFilter	= "Font Files (*.ttf, *.fon)" & szNULL & "*.ttf;*.fon" & szNULL

Dim Shared hInstance As HINSTANCE
dim SHARED IDM_CUSTOMFONT as Integer
Dim Shared oldFontName As ZString * 260
Dim Shared newFontName As ZString * 260