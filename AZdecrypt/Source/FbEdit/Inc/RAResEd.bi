
' Dialog memory size
#Define MaxMem						128*1024*3
#Define MaxCap						256
#Define MaxName					64

' Dialog structures
Type DLGHEAD
	locked		As Integer				' Set to FALSE
	class			As ZString*32			' Set to Null string
	menuid		As ZString*MaxName	' Set to Null string
	font			As ZString*32			' Set to "MS Sans Serif"
	fontsize		As Integer				' Set to 8
	charset		As UByte					' Set to NULL
	italic		As UByte					' Set to NULL
	weight		As UShort				' Set to NULL
	lang			As Integer				' Set to NULL
	sublang		As Integer				' Set to NULL
	undo			As Integer				' Set to NULL
	ctlid			As Integer				' Set to 1001
	hmnu			As Integer				' Set to NULL
	lpmnu			As Integer				' Set to NULL
	htlb			As HWND					' Set to NULL
	hstb			As HWND					' Set to NULL
	hred			As HWND					' Set to NULL
	ftextmode	As Integer				' Set to NULL
End Type

Type DIALOG
	hwnd			As HWND					' Set to TRUE
	style			As Integer				' Set to desired style
	exstyle		As Integer				' Set to desired ex style
	dux			As Integer				' X position in dialog units
	duy			As Integer				' Y position in dialog units
	duccx			As Integer				' Width in dialog units
	duccy			As Integer				' Height in dialog units
	caption		As ZString*MaxCap		' Caption max 255+1 char
	class			As ZString*32			' Set to Null string
	ntype			As Integer				' Follows ToolBox buttons Dialog=0, Edit=1, Static=2, GroupBox=3
	ntypeid		As Integer				' Set to NULL
	tab			As Integer				' Tab index, Dialog=0, First index=0
	id				As Integer				' Dialog / Controls ID
	idname		As ZString*MaxName	' ID Name, max 63+1 chars
	helpid		As Integer				' Help ID
	himg			As Integer				' Set to NULL
End Type

Type LANGUAGEMEM
	lang			As Integer
	sublang		As Integer
End Type

' Menu structures
Type MNUHEAD
	menuname		As ZString*MaxName
	menuid		As Integer
	startid		As Integer
	menuex		As Integer
	lang			As LANGUAGEMEM
End Type

Type MNUITEM
	itemflag		As Integer
	itemname		As ZString*MaxName
	itemid		As Integer
	itemcaption	As ZString*64
	level			As Integer
	ntype			As Integer
	nstate		As Integer
	shortcut		As Integer
	helpid		As Integer
End Type

Type RARESEDCOLOR
	back			As Integer
	text			As Integer
	styles		As Integer
	words			As Integer
End Type

Type CUSTSTYLE
	szStyle		As ZString*64
	nValue		As Integer
	nMask			As Integer
End Type

Type RARSTYPE
	sztype		As ZString*32
	nid			As Integer
	szext			As ZString*64	
	szedit		As ZString*128
End Type

' Resource ID's
Type RESID
	startid		As Integer
	incid			As Integer
End Type

Type INITID
	dlg			As RESID
	mnu			As RESID
	acl			As RESID
	ver			As RESID
	man			As RESID
	rcd			As RESID
	tbr			As RESID
	res			As RESID
	usr			As RESID
End Type

Type WINSIZE
	htpro			As Integer
	wtpro			As Integer
	htout			As Integer
	wttbx			As Integer
	ptstyle		As POINT
End Type

' Dialog editor messages
#Define DEM_BASE					WM_USER+2000
#Define DEM_OPEN					DEM_BASE+1		' 0,hMem:HGLOBAL
#Define DEM_DELETECONTROLS		DEM_BASE+2		' 0,0
#Define DEM_CANUNDO				DEM_BASE+3		' ,0,0|BOOLEAN
#Define DEM_UNDO					DEM_BASE+4		' 0,0
#Define DEM_CUT					DEM_BASE+5		' 0,0
#Define DEM_COPY					DEM_BASE+6		' 0,0
#Define DEM_CANPASTE				DEM_BASE+7		' 0,0|BOOLEAN
#Define DEM_PASTE					DEM_BASE+8		' 0,0
#Define DEM_ISLOCKED				DEM_BASE+9		' 0,0|BOOLEAN
#Define DEM_LOCKCONTROLS		DEM_BASE+10		' 0,bLock[FALSE,TRUE]
#Define DEM_ISBACK				DEM_BASE+11		' 0,0|BOOLEAN
#Define DEM_SENDTOBACK			DEM_BASE+12		' 0,0
#Define DEM_ISFRONT				DEM_BASE+13		' 0,0|BOOLEAN
#Define DEM_BRINGTOFRONT		DEM_BASE+14		' 0,0
#Define DEM_ISSELECTION			DEM_BASE+15		' 0,0|Integer
#Define DEM_ALIGNSIZE			DEM_BASE+16		' 0,nAlign[ALIGN_BOTTOM,ALIGN_CENTER,ALIGN_DLGHCENTER,ALIGN_DLGVCENTER,ALIGN_LEFT,ALIGN_MIDDLE,ALIGN_RIGHT,ALIGN_TOP]
#Define DEM_GETMODIFY			DEM_BASE+17		' 0,0
#Define DEM_SETMODIFY			DEM_BASE+18		' bModify[FALSE,TRUE],0
#Define DEM_COMPACT				DEM_BASE+19		' 0,0|Integer
#Define DEM_EXPORTTORC			DEM_BASE+20		' 0,0|HGLOBAL
#Define DEM_SETPOSSTATUS		DEM_BASE+21		' hSbr:HWND,nPane:Integer
#Define DEM_SETGRIDSIZE			DEM_BASE+22		' xySize:Integer,nColor:Integer
#Define DEM_ADDCONTROL			DEM_BASE+23		' hTbx:HWND,lpCCDEF:CCDEF Ptr
#Define DEM_GETCOLOR				DEM_BASE+24		' 0,lpRARESEDCOLOR:RARESEDCOLOR Ptr
#Define DEM_SETCOLOR				DEM_BASE+25		' 0,lpRARESEDCOLOR:RARESEDCOLOR Ptr
#Define DEM_SHOWDIALOG			DEM_BASE+26		' 0,0
#Define DEM_SHOWTABINDEX		DEM_BASE+27		' 0,0
#Define DEM_EXPORTDLG			DEM_BASE+28		' 0,lpszFileName:ZString Ptr
#Define DEM_AUTOID				DEM_BASE+29		' 0,0
#Define DEM_GETBUTTONSCOUNT	DEM_BASE+30		' 0,0
#Define DEM_GETMEM				DEM_BASE+31		' nMem[DEWM_DIALOG,DEWM_MEMORY,DEWM_PROJECT,DEWM_READONLY,DEWM_SCROLLX,DEWM_SCROLLY],0
#Define DEM_SHOWOUTPUT			DEM_BASE+32		' bShow[FALSE,TRUE],0
#Define DEM_GETSIZE				DEM_BASE+33		' 0,lpWINSIZE:WINSIZE Ptr
#Define DEM_SETSIZE				DEM_BASE+34		' 0,lpWINSIZE:WINSIZE Ptr
#Define DEM_GETTEXTMODE			DEM_BASE+35		' 0,0
#Define DEM_SETTEXTMODE			DEM_BASE+36		' bTextMode[FALSE,TRUE],0
#Define DEM_CANREDO				DEM_BASE+37		' ,0,0|BOOLEAN
#Define DEM_REDO					DEM_BASE+38		' 0,0
#Define DEM_GETSHOWDIALOG		DEM_BASE+39		' 0,0
#Define DEM_CLEARCUSTSTYLE		DEM_BASE+40		' 0,0
#Define DEM_ADDCUSTSTYLE		DEM_BASE+41		' 0,lpCUSTSTYLE:CUSTSTYLE Ptr
#Define DEM_GETOUTPUT			DEM_BASE+42		' 0,0

' DEM_ALIGNSIZE lParam
#Define ALIGN_LEFT				1
#Define ALIGN_CENTER				2
#Define ALIGN_RIGHT				3
#Define ALIGN_TOP					4
#Define ALIGN_MIDDLE				5
#Define ALIGN_BOTTOM				6
#Define SIZE_WIDTH				7
#Define SIZE_HEIGHT				8
#Define SIZE_BOTH					9
#Define ALIGN_DLGVCENTER		10
#Define ALIGN_DLGHCENTER		11

' Menu editor messages
#Define MEM_BASE					DEM_BASE+1000
#Define MEM_OPEN					MEM_BASE+1		' 0,hMem:HGLOBAL
#Define MEM_GETERR				MEM_BASE+2		' 0,0

' Project messages
#Define PRO_BASE					DEM_BASE+2000
#Define PRO_OPEN					PRO_BASE+1		' lpszProjectFile:ZStringPtr,hMem:HGLOBAL
#Define PRO_CLOSE					PRO_BASE+2		' 0,0
#Define PRO_EXPORT				PRO_BASE+3		' 0,hMem:HGLOBAL
#Define PRO_GETMODIFY			PRO_BASE+4		' 0,0|BOOLEAN
#Define PRO_SETMODIFY			PRO_BASE+5		' bModify[FALSE,TRUE],0
#Define PRO_GETSELECTED			PRO_BASE+6		' 0,0|Integer
#Define PRO_ADDITEM				PRO_BASE+7		' nType[TPE_ACCEL,TPE_DIALOG,TPE_INCLUDE,TPE_LANGUAGE,TPE_MENU,TPE_NAME,TPE_RCDATA,TPE_RESOURCE,TPE_STRING,TPE_TOOLBAR,TPE_VERSION,TPE_XPMANIFEST],bOpen[FALSE,TRUE]
#Define PRO_DELITEM				PRO_BASE+8		' 0,0
#Define PRO_CANUNDO				PRO_BASE+9		' 0,0
#Define PRO_UNDODELETED			PRO_BASE+10		' 0,0
#Define PRO_SETNAME				PRO_BASE+11		' lpszName:ZString Ptr,lpszPath:ZString Ptr
#Define PRO_SHOWNAMES			PRO_BASE+12		' 0,hOut:HWND
#Define PRO_SETEXPORT			PRO_BASE+13		' nType:Integer,lpszDefaultFileName:ZString Ptr
#Define PRO_EXPORTNAMES			PRO_BASE+14		' 0,hOut:HWND
#Define PRO_SETINITID			PRO_BASE+17		' 0,lpINITID:INITID Ptr
#Define PRO_GETMEM				PRO_BASE+18		' 0,0|HGLOBAL
#Define PRO_SETTEXTFONT			PRO_BASE+19		' hFont:HFONT,0
#Define PRO_GETTEXTFONT			PRO_BASE+20		' 0,0|HFONT
#Define PRO_SETSYSTEMPATH		PRO_BASE+21		' 0,lpszPath:ZString Ptr
#Define PRO_GETSYSTEMPATH		PRO_BASE+22		' 0,0|ZString Ptr
#Define PRO_SETCUSTOMTYPE		PRO_BASE+23		' nIndex:Integer,lpRARSTYPE:RARSTYPE Ptr
#Define PRO_GETCUSTOMTYPE		PRO_BASE+24		' nIndex:Integer,lpRARSTYPE:RARSTYPE Ptr
#Define PRO_SETDEFINE			PRO_BASE+25		' 0,lpszName:ZString Ptr
#Define PRO_GETDIALOG			PRO_BASE+26		' 0,0
#Define PRO_INCVERSION			PRO_BASE+27		' 0,0
#Define PRO_SETHIGHLIGHT		PRO_BASE+28		' nColorStyles:Integer,nColorWords:Integer

' Project item types
#Define TPE_NAME					1
#Define TPE_INCLUDE				2
#Define TPE_RESOURCE				3
#Define TPE_DIALOG				4
#Define TPE_MENU					5
#Define TPE_ACCEL					6
#Define TPE_VERSION				7
#Define TPE_STRING				8
#Define TPE_LANGUAGE				9
#Define TPE_LANGUAGE				9
#Define TPE_XPMANIFEST			10
#Define TPE_RCDATA				11
#Define TPE_TOOLBAR				12

' Dialog Edit Window Styles
#Define DES_GRID					1
#Define DES_SNAPTOGRID			2
#Define DES_TOOLTIP				4
#Define DES_STYLEHEX				8
#Define DES_SIZETOFONT			16
#Define DES_NODEFINES			32
#Define DES_SIMPLEPROPERTY		64
#Define DES_SIMPLEPROPERTY		64
#Define DES_DEFIDC_STATIC		128
#Define DES_BORLAND				256

' Dialog edit window memory
#Define DEWM_DIALOG				0
#Define DEWM_MEMORY				4
#Define DEWM_READONLY			8
#Define DEWM_SCROLLX				12
#Define DEWM_SCROLLY				16
#Define DEWM_PROJECT				20

Type CTLDBLCLICK
	nmhdr			As NMHDR
	lpDlgMem		As DIALOG Ptr
	nCtlId		As Integer
	lpCtlName	As ZString Ptr
	nDlgId		As Integer
	lpDlgName	As ZString Ptr
End Type

' Window classes global
Const szDlgEditClass="DLGEDITCLASS"
Const szToolBoxClass="TOOLBOXCLASS"
Const szPropertyClass="PROPERTYCLASS"
Const szProjectClass="PROJECTCLASS"
Const szDlgEditDummyClass="DlgEditDummy"
