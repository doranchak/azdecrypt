
#Include "RAProperty.bi"

Type RAPROPERTY
	hwnd				As HWND
	hpar				As HWND
	id					As Integer
	hfont				As HFONT
	himl				As HIMAGELIST
	htbr				As HWND
	hcbo				As HWND
	hlst				As HWND
	hmem				As HGLOBAL
	cbsize			As Integer
	lpmem				As Integer
	rpfree			As Integer
	rpproject		As Integer
	lpchartab		As Integer
	defgen			As DEFGEN
	lpignore			As Integer
	rpignorefree	As Integer
	lpisword			As Integer
	rpiswordfree	As Integer
	lpdeftype		As Integer
	rpfreedeftype	As Integer
	nOwner			As Integer
	nButton			As Integer
	szFindTypes		As ZString*64
	szFindText		As ZString*64
	rpFindPos		As Integer
	nfindtype		As Integer
	nfindowner		As Integer
	nfindline		As Integer
	nfindendline	As Integer
	backcolor		As Integer
	textcolor		As Integer
	oprcolor			As Integer
	hbrback			As HBRUSH
	topindex			As Integer
	selindex			As Integer
	htooltip			As HWND
	nlanguage		As Integer
	hMemArray		As HGLOBAL
End Type

Type PROPERTIES Field=1
	nSize				As Integer
	nOwner			As Integer
	nLine				As Integer
	nEnd				As Integer
	nType				As UByte
End Type

#Define IDD_DLGAPI              1000
#Define IDC_LSTBI               1001
#Define IDC_BTNADD              1002
#Define IDC_BTNDEL              1003
#Define IDC_PRPCODE             1004
#Define IDC_EDTPREFIX           1006
#Define IDC_BTNUPDATEINI        1005
#Define IDC_EDTDESCRIPTION      1007
#Define IDC_BTNCONST            1008
#Define IDC_BTNMSG              1009

#Define IDD_DLGCONST            1100
#Define IDC_EDTCONST            1101
#Define IDC_LSTCONST            1102
#Define IDC_BTNEDIT             1103

' Filter string for GetOpenFileName
Const szNULL=!"\0"
Const ALLFilterString="Code Files (*.bas, *.bi)" & szNULL & "*.bas;*.bi" & szNULL & "All Files (*.*)" & szNULL & "*.*" & szNULL & szNULL

Const szAppName="Make api files"
Const szCRLF=!"\13\10\0"

' Code properties
Const szCode = "Functions (*Call.api)"
Const szConst = "Constants (*Word.api)"
'Const szData = "Variables"
Const szStruct = "UDTs (*Struct.api)"
Const szEnum = "Enums (*Enum.api)"
'Const szNamespace = "Namespaces"
'Const szMacro = "Macros"
'Const szConstructor = "Constructors"
'Const szDestructor = "Destructors"
'Const szProperty = "Properties"
'Const szOperator = "Operators"
Dim Shared defgen As DEFGEN = ("/'" & szNULL,"'/" & szNULL,"'" & szNULL,"""" & szNULL,"_" & szNULL)
Dim Shared deftypesub As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_PROC,Asc("p"),3,"sub")
Dim Shared deftypeendsub As DEFTYPE = (TYPE_TWOWORDS,DEFTYPE_ENDPROC,Asc("p"),3,"end" & Chr(3) & "sub")
Dim Shared deftypefun As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_FUNCTION,Asc("p"),8,"function")
Dim Shared deftypeendfun As DEFTYPE = (TYPE_TWOWORDS,DEFTYPE_ENDFUNCTION,Asc("p"),3,"end" & Chr(8) & "function")
Dim Shared deftypedata As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_DATA,Asc("d"),3,"dim")
Dim Shared deftypecommon As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_DATA,Asc("d"),6,"common")
Dim Shared deftypestatic As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_DATA,Asc("d"),6,"static")
Dim Shared deftypevar As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_DATA,Asc("d"),3,"var")
Dim Shared deftypeconst As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_CONST,Asc("c"),7,"#define")
Dim Shared deftypeconst2 As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_CONST,Asc("c"),5,"const")
Dim Shared deftypestruct As DEFTYPE = (TYPE_OPTNAMESECOND,DEFTYPE_STRUCT,Asc("s"),4,"type")
Dim Shared deftypeendstruct As DEFTYPE = (TYPE_TWOWORDS,DEFTYPE_ENDSTRUCT,Asc("s"),3,"end" & Chr(4) & "type")
Dim Shared deftypeunion As DEFTYPE = (TYPE_OPTNAMESECOND,DEFTYPE_STRUCT,Asc("s"),5,"union")
Dim Shared deftypeendunion As DEFTYPE = (TYPE_TWOWORDS,DEFTYPE_ENDSTRUCT,Asc("s"),3,"end" & Chr(5) & "union")
Dim Shared deftypeenum As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_ENUM,Asc("e"),4,"enum")
Dim Shared deftypeendenum As DEFTYPE = (TYPE_TWOWORDS,DEFTYPE_ENDENUM,Asc("e"),3,"end" & Chr(4) & "enum")
Dim Shared deftypenamespace As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_NAMESPACE,Asc("n"),9,"namespace")
Dim Shared deftypeendnamespace As DEFTYPE = (TYPE_TWOWORDS,DEFTYPE_ENDNAMESPACE,Asc("n"),3,"end" & Chr(9) & "namespace")
Dim Shared deftypewithblock As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_WITHBLOCK,Asc("w"),4,"with")
Dim Shared deftypeendwithblock As DEFTYPE = (TYPE_TWOWORDS,DEFTYPE_ENDWITHBLOCK,Asc("w"),3,"end" & Chr(4) & "with")
Dim Shared deftypemacro As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_MACRO,Asc("m"),6,"#macro")
Dim Shared deftypeendmacro As DEFTYPE = (TYPE_ONEWORD,DEFTYPE_ENDMACRO,Asc("m"),9,"#endmacro")
Dim Shared deftypeconstructor As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_CONSTRUCTOR,Asc("x"),11,"constructor")
Dim Shared deftypeendconstructor As DEFTYPE = (TYPE_TWOWORDS,DEFTYPE_ENDCONSTRUCTOR,Asc("x"),3,"end" & Chr(11) & "constructor")
Dim Shared deftypedestructor As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_DESTRUCTOR,Asc("y"),10,"destructor")
Dim Shared deftypeenddestructor As DEFTYPE = (TYPE_TWOWORDS,DEFTYPE_ENDDESTRUCTOR,Asc("y"),3,"end" & Chr(10) & "destructor")
Dim Shared deftypeproperty As DEFTYPE = (TYPE_NAMESECOND,DEFTYPE_PROPERTY,Asc("z"),8,"property")
Dim Shared deftypeendproperty As DEFTYPE = (TYPE_TWOWORDS,DEFTYPE_ENDPROPERTY,Asc("z"),3,"end" & Chr(8) & "property")
Dim Shared deftypeoperator As DEFTYPE = (TYPE_OPTNAMESECOND,DEFTYPE_OPERATOR,Asc("o"),8,"operator")
Dim Shared deftypeendoperator As DEFTYPE = (TYPE_TWOWORDS,DEFTYPE_ENDOPERATOR,Asc("o"),3,"end" & Chr(8) & "operator")

' xxxConst.api
Const szConst1="3SendDlgItemMessage"
Const szConst2="2SendMessage"
Const szConst3="2PostMessage"

Dim Shared CommandLine As ZString Ptr
Dim Shared hInstance As HMODULE
Dim Shared hWnd As HWND
Dim Shared hPrp As HWND
Dim Shared AppPath As ZString*260
Dim Shared FbEditPath As ZString*260
Dim Shared hFbEditDll As HMODULE
Dim Shared CharTab As Function() As Any Ptr
Dim Shared lpCharTab As Any Ptr
Dim Shared SetCharTab As Function(ByVal nChar As Integer,ByVal nVal As Integer) As Any Ptr
Dim Shared lpRAPROPERTY As RAPROPERTY Ptr
Dim Shared szWord As ZString*16384
Dim Shared szLine As ZString*16384
Dim Shared szLastLine As ZString*16384
Dim Shared szFilter As ZString*260
Dim Shared bMsg As Integer
Dim Shared szTemp As ZString*1048576
