
' Messages
#Define PRM_SELECTPROPERTY				WM_USER+0		' nType:Integer,0
#Define PRM_ADDPROPERTYTYPE			WM_USER+1		' dwType:Integer,pszType:ZString Ptr
#Define PRM_ADDPROPERTYFILE			WM_USER+2		' dwType:Integer,pszFile:ZString Ptr
#Define PRM_SETGENDEF					WM_USER+3		' 0,pGENDEF:GENDEF Ptr
#Define PRM_ADDIGNORE					WM_USER+4		' nIgnoreType:RAP_IGNORE,pszWord:ZString Ptr
#Define PRM_ADDDEFTYPE					WM_USER+5		' 0,pDEFTYPE:DEFTYPE Ptr
#Define PRM_PARSEFILE					WM_USER+6		' nOwner:Integer,pFileData:HGLOBAL
#Define PRM_SETCHARTAB					WM_USER+7		' 0,pCharTab:Any Ptr
#Define PRM_DELPROPERTY					WM_USER+8		' nOwner:Integer,0
#Define PRM_REFRESHLIST					WM_USER+9		' 0,0
#Define PRM_SELOWNER						WM_USER+10		' nOwner:Integer,0
#Define PRM_GETSELBUTTON				WM_USER+11		' 0,0
#Define PRM_SETSELBUTTON				WM_USER+12		' nButton:Integer,0
#Define PRM_FINDFIRST					WM_USER+13		' pszTypes:ZString Ptr,pszText:ZString Ptr
#Define PRM_FINDNEXT						WM_USER+14		' 0,0
#Define PRM_FINDGETTYPE					WM_USER+15		' 0,0
#Define PRM_GETWORD						WM_USER+16		' nPos:Integer,pszLine:ZString Ptr
#Define PRM_GETTOOLTIP					WM_USER+17		' 0,pTOOLTIP:TOOLTIP Ptr
#Define PRM_SETBACKCOLOR				WM_USER+18		' 0,nColor:Integer
#Define PRM_GETBACKCOLOR				WM_USER+19		' 0,0
#Define PRM_SETTEXTCOLOR				WM_USER+20		' 0,nColor:Integer
#Define PRM_GETTEXTCOLOR				WM_USER+21		' 0,0
#Define PRM_ISINPROC						WM_USER+22		' 0,pISINPROC:ISINPROC Ptr
#Define PRM_GETSTRUCTWORD				WM_USER+23		' nPos:Integer,pszLine:ZString Ptr
#Define PRM_FINDITEMDATATYPE			WM_USER+24		' pszItemName:ZString Ptr,pszItemList:ZString Ptr
#Define PRM_MEMSEARCH					WM_USER+25		' 0,pMEMSEARCH:MEMSEARCH Ptr
#Define PRM_FINDGETOWNER				WM_USER+26		' 0,0
#Define PRM_FINDGETLINE					WM_USER+27		' 0,0
#Define PRM_ISINWITHBLOCK				WM_USER+28		' nOwner:Integer,nLine:Integer
#Define PRM_FINDGETENDLINE				WM_USER+29		' 0,0
#Define PRM_ADDISWORD					WM_USER+30		' nType:Integer,pszWord:ZString Ptr
#Define PRM_SETOPRCOLOR					WM_USER+31		' 0,nColor:Integer
#Define PRM_GETOPRCOLOR					WM_USER+32		' 0,0
#Define PRM_CLEARWORDLIST				WM_USER+33		' 0,0
#Define PRM_GETSTRUCTSTART				WM_USER+34		' nPos:Integer,pszLine:ZString Ptr
#Define PRM_GETCURSEL					WM_USER+35		' 0,0
#Define PRM_GETSELTEXT					WM_USER+36		' 0,pBuff:ZString Ptr
#Define PRM_GETSORTEDLIST				WM_USER+37		' pszTypes:ZString Ptr,pCount:Integer Ptr
#Define PRM_FINDINSORTEDLIST			WM_USER+38		' nCount:Integer,pMEMSEARCH:MEMSEARCH Ptr
#Define PRM_ISTOOLTIPMESSAGE			WM_USER+39		' pMESSAGE:MESSAGE Ptr,pTOOLTIP:TOOLTIP Ptr
#Define PRM_SETLANGUAGE					WM_USER+40		' nLanguage:RAP_LANGUAGE,0
#Define PRM_SETTOOLTIP					WM_USER+41		' n:Integer,pszText:ZString Ptr
#Define PRM_PREPARSE						WM_USER+42		' bKeepStrings:RAP_BOOL,pFileData:HGLOBAL
#Define PRM_ISINLIST						WM_USER+43		' dwType:Integer,pWord:ZString Ptr
#Define PRM_ADDPROPERTYWORD			WM_USER+44		' dwType:Integer,pszWord:ZString Ptr
#Define PRM_ADDPROPERTYLIST			WM_USER+45		' dwType:Integer,pszListOfWords:ZString Ptr
#Define PRM_COMPACTLIST					WM_USER+46		' bProject:RAP_BOOL,0

' Languages
#Define nFREEBASIC						0
#Define nMASM								1

' Styles
#Define PRSTYLE_FLATTOOLBAR			1
#Define PRSTYLE_DIVIDERLINE			2
#Define PRSTYLE_PROJECT					4

Type DEFGEN
	szCmntBlockSt	As ZString*16
	szCmntBlockEn	As ZString*16
	szCmntChar		As ZString*16
	szString			As ZString*16
	szLineCont		As ZString*16
End Type

#Define TYPE_NAMEFIRST					1
#Define TYPE_OPTNAMEFIRST				2
#Define TYPE_NAMESECOND					3
#Define TYPE_OPTNAMESECOND				4
#Define TYPE_TWOWORDS					5
#Define TYPE_ONEWORD						6

#Define DEFTYPE_PROC						1
#Define DEFTYPE_ENDPROC					2
#Define DEFTYPE_DATA						3
'#define DEFTYPE_MULTIDATA				4
#Define DEFTYPE_CONST					5
#Define DEFTYPE_ENDCONST				6
#Define DEFTYPE_STRUCT					7
#Define DEFTYPE_ENDSTRUCT				8
#Define DEFTYPE_TYPE						9
#Define DEFTYPE_ENDTYPE					10
#Define DEFTYPE_LOCALDATA				11
#Define DEFTYPE_NAMESPACE				12
#Define DEFTYPE_ENDNAMESPACE			13
#Define DEFTYPE_ENUM						14
#Define DEFTYPE_ENDENUM					15
#Define DEFTYPE_WITHBLOCK				16
#Define DEFTYPE_ENDWITHBLOCK			17
#Define DEFTYPE_MACRO					18
#Define DEFTYPE_ENDMACRO				19
#Define DEFTYPE_PROPERTY				20
#Define DEFTYPE_ENDPROPERTY			21
#Define DEFTYPE_OPERATOR				22
#Define DEFTYPE_ENDOPERATOR			23
#Define DEFTYPE_CONSTRUCTOR			24
#Define DEFTYPE_ENDCONSTRUCTOR		25
#Define DEFTYPE_DESTRUCTOR				26
#Define DEFTYPE_ENDDESTRUCTOR			27
#Define DEFTYPE_LABEL					28
#Define DEFTYPE_FUNCTION				29
#Define DEFTYPE_ENDFUNCTION			30

Type DEFTYPE
	nType				As UByte
	nDefType			As UByte
	nDef				As UByte
	nlen				As UByte
	szWord			As ZString*32
End Type

' Ignore types
#Define IGNORE_LINEFIRSTWORD			1
#Define IGNORE_LINESECONDWORD			2
#Define IGNORE_FIRSTWORD				3
#Define IGNORE_SECONDWORD				4
#Define IGNORE_FIRSTWORDTWOWORDS		5
#Define IGNORE_SECONDWORDTWOWORDS	6
#Define IGNORE_PROCPARAM				7
#Define IGNORE_DATATYPEINIT			8
#Define IGNORE_STRUCTITEMFIRSTWORD	9
#Define IGNORE_STRUCTITEMSECONDWORD	10
#Define IGNORE_STRUCTTHIRDWORD		11
#Define IGNORE_STRUCTITEMINIT			12
#Define IGNORE_PTR						13
#Define IGNORE_STRUCTLINEFIRSTWORD	14
#Define IGNORE_DATATYPE					15

' Character table types
#Define CT_NONE							0
#Define CT_CHAR							1
#Define CT_OPER							2
#Define CT_HICHAR							3
#Define CT_CMNTCHAR						4
#Define CT_STRING							5
#Define CT_CMNTDBLCHAR					6
#Define CT_CMNTINITCHAR					7

Type RAPNOTIFY
	nmhdr				As NMHDR
	nid				As Integer
	nline				As Integer
End Type

Type ISINPROC
	nLine				As Integer
	nOwner			As Integer
	lpszType			As ZString Ptr
End Type

#Define TT_NOMATCHCASE					1
#Define TT_PARANTESES					2

Type OVERRIDE
	lpszParam		As ZString Ptr
	lpszRetType		As ZString Ptr
End Type

Type TOOLTIP
	lpszType			As ZString Ptr
	lpszLine			As ZString Ptr
	lpszApi			As ZString Ptr
	nPos				As Integer
	novr				As Integer
	ovr(32)			As OVERRIDE
End Type

Type MSGAPI
	nPos				As Integer
	lpszApi			As ZString Ptr
End Type

Type MESSAGE
	szType			As ZString*4
	lpMsgApi(31)	As MSGAPI
End Type

Type MEMSEARCH
	lpMem				As HGLOBAL
	lpFind			As ZString Ptr
	lpCharTab		As Any Ptr
	fr					As Integer
End Type

' Class
Const szClassName As String="RAPROPERTY"
