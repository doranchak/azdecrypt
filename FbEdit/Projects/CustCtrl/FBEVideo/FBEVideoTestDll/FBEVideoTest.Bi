#define MCIWNDM_NOTIFYMODE			WM_USER+200
#define MCIWNDM_NOTIFYPOS        WM_USER+201
#define MCIWNDM_GETPOSITION      WM_USER+102
#define MCIWNDM_PLAYFROM         WM_USER+122
#define MCIWNDM_SETSPEED         WM_USER+112

#define IDD_DLG1                1000
#define IDC_VID1                1002
#define IDR_MENU                10000
#define IDM_FILE                10001
#define IDM_FILE_OPEN           10002
#define IDM_FILE_EXIT           10003
#define IDM_VIEW                10004
#define IDM_VIEW_BAR            10005
#define IDM_VIEW_ASPECT         10006
#define IDM_VIEW_REPEAT         10007
#define IDM_VIEW_STOP           10008

dim shared hLib as HMODULE
dim shared sFile as ZString*260
dim shared fActivated as Boolean
dim shared fRepeat as Boolean
