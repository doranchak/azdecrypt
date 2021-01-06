
dim SHARED hInstance as HINSTANCE
dim SHARED hooks as ADDINHOOKS
dim SHARED lpHandles as ADDINHANDLES ptr
dim SHARED lpFunctions as ADDINFUNCTIONS ptr
dim SHARED lpData as ADDINDATA ptr
dim SHARED IDM_SNIPLETS as integer
dim SHARED winsize as RECT=(10,10,800,600)

#define IDD_DLGSNIPLET			1000
#define IDC_FILEBROWSER			1001
#define IDC_RAEDIT				1002
