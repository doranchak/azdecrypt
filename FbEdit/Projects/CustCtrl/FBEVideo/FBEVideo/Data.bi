
type MCIWndCreate as function(byval hWin as HWND,byval hInst as HINSTANCE,byval st as Integer,byval szFile as zstring ptr) as HWND

#define MCIWNDF_NOERRORDLG			&H4000
#define MCIWNDF_NOPLAYBAR			&H0002
#define MCIWNDF_NOAUTOSIZEMOVIE	&H0004
#define MCIWNDF_NOMENU				&H0008
#define MCIWNDF_NOTIFYMODE			&H0100
#define MCIWNDF_NOTIFYPOS			&H0200

#define MCIWNDM_NOTIFYMODE			WM_USER+200
#define MCIWNDM_NOTIFYPOS        WM_USER+201
#define MCIWNDM_GETPOSITION		WM_USER+102
#define MCIWNDM_GETLENGTH			WM_USER+104
#define MCIWNDM_PUT_DEST			WM_USER+143
#define MCIWNDM_GET_SOURCE			WM_USER+140

type FBEVID
	hParent		as HWND
	hMCIWnd		as HWND
	Style			as Integer
	MCIStyle		as Integer
end type

#ifdef DEFDLL

' Propery types
#define PROP_STYLETRUEFALSE		1
#define PROP_EXSTYLETRUEFALSE		2
#define PROP_STYLEMULTI				3

' This is a False/True style or exstyle description.
type PROPERTYFALSETRUE field=1
	and_false	as integer
	or_false		as integer
	and_true		as integer
	or_true		as integer
end type

' Description of the 3 properties
type PROPERTIES field=1
	type1			as integer
	property1	as PROPERTYFALSETRUE ptr
	type2			as integer
	property2	as PROPERTYFALSETRUE ptr
	type3			as integer
	property3	as PROPERTYFALSETRUE ptr
end type

type CCDEFEX field=1
	ID				as integer					'Controls uniqe ID. ID's below 1000 are reserved.
	lptooltip	as zstring ptr				'Pointer to FbEdit toolbox tooltip text
	hbmp			as HBITMAP					'Handle of FbEdit toolbox bitmap
	lpcaption	as zstring ptr				'Pointer to default caption text
	lpname		as zstring ptr				'Pointer to default idname text
	lpclass		as zstring ptr				'Pointer to class text
	style			as integer					'Default style
	exstyle		as integer					'Default ex-style
	flist1		as integer					'Property listbox bitflag1
	flist2		as integer					'Property listbox bitflag2
	flist3		as integer					'Property listbox bitflag3
	flist4		as integer					'Property listbox bitflag4
	lpszproperty as zstring ptr			'Pointer to properties text
	lpproprty	as PROPERTIES ptr			'Pointer to properties descriptor
end type

' Default styles
#define DEFSTYLE						WS_CHILD or WS_VISIBLE
#define DEFEXSTYLE					&H200
#define IDB_BMP						100

#define EXSTYLE_NONE					0

' Controls tooltip
CONST szToolTip="Custom Video Control"
' Controls default caption
CONST szCap=""
' Controls default name
CONST szName="IDC_VID"

dim SHARED PropertyPlaybar as PROPERTYFALSETRUE=(-1 xor STYLE_PLAYBAR,0,-1 xor STYLE_PLAYBAR,STYLE_PLAYBAR)
dim SHARED PropertyAspect as PROPERTYFALSETRUE=(-1 xor STYLE_KEEPASPECT,0,-1 xor STYLE_KEEPASPECT,STYLE_KEEPASPECT)
dim SHARED PropertyNotify as PROPERTYFALSETRUE=(-1 xor STYLE_NOTIFY,0,-1 xor STYLE_NOTIFY,STYLE_NOTIFY)

' Theese are the 2 properties for this control
CONST szProperties="PlayBar,KeepAspect,Notify"
' Properties descriptor
dim SHARED Properties as PROPERTIES=(PROP_STYLETRUEFALSE,@PropertyPlaybar,PROP_STYLETRUEFALSE,@PropertyAspect,PROP_STYLETRUEFALSE,@PropertyNotify)
' FbEdit uses this data when designing the control on a dialog. For a description of flist1 to flist4 bit values, see CustCtrl.txt file.
dim SHARED ccdefex as CCDEFEX=(902,@szToolTip,0,@szCap,@szName,@szClassName,DEFSTYLE,DEFEXSTYLE,&B11111101000011000000000000000000,&B00010000000000011000000000000000,&B00001000000000000000000000000000,&B00000000000000000000000000000000,@szProperties,@Properties)
#endif

dim SHARED hInstance as HINSTANCE
dim SHARED lpOldMCIWndProc as any ptr
dim SHARED hLib as HMODULE
dim SHARED MCIWndCreate as MCIWndCreate
