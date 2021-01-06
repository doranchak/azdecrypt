#include once "windows.bi"
#include once "win/commctrl.bi"
#include once "win/winreg.bi"
#include once "..\..\FbEdit\Inc\Addins.bi"
#include once "RegLib.bas"

#include once "rsrc.bi"



dim SHARED hInstance as HINSTANCE
dim SHARED hooks as ADDINHOOKS
dim SHARED lpHandles as ADDINHANDLES ptr
dim SHARED lpFunctions as ADDINFUNCTIONS ptr
dim SHARED lpData as ADDINDATA ptr
dim SHARED IDM_FILEASSOC as integer


