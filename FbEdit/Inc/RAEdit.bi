' RAEdit control definitions
'

' Default colors
#Define DEFBCKCOLOR							&H00C0F0F0
#Define DEFTXTCOLOR							&H00000000
#Define DEFSELBCKCOLOR						&H00800000
#Define DEFSELTXTCOLOR						&H00FFFFFF
#Define DEFCMNTCOLOR							&H02008000
#Define DEFSTRCOLOR							&H00A00000
#Define DEFOPRCOLOR							&H000000A0
#Define DEFHILITE1							&H00F0C0C0
#Define DEFHILITE2							&H00C0F0C0
#Define DEFHILITE3							&H00C0C0F0
#Define DEFSELBARCOLOR						&H00C0C0C0
#Define DEFSELBARPEN							&H00808080
#Define DEFLNRCOLOR							&H00800000
#Define DEFNUMCOLOR							&H00808080
#Define DEFCMNTBCK							&H00C0F0F0
#Define DEFSTRBCK								&H00C0F0F0
#Define DEFNUMBCK								&H00C0F0F0
#Define DEFOPRBCK								&H00C0F0F0
#Define DEFCHANGEDCLR						&H0000FFFF
#Define DEFCHANGESAVEDCLR					&H0000FF00

' Window styles
#Define STYLE_NOSPLITT						&H0001			' No splitt button
#Define STYLE_NOLINENUMBER					&H0002			' No linenumber button
#Define STYLE_NOCOLLAPSE					&H0004			' No expand/collapse buttons
#Define STYLE_NOHSCROLL						&H0008			' No horizontal scrollbar
#Define STYLE_NOVSCROLL						&H0010			' No vertical scrollbar
#Define STYLE_NOHILITE						&H0020			' No color hiliting
#Define STYLE_NOSIZEGRIP					&H0040			' No size grip
#Define STYLE_NODBLCLICK					&H0080			' No action on double clicks
#Define STYLE_READONLY						&H0100			' Text is locked
#Define STYLE_NODIVIDERLINE				&H0200			' Blocks are not divided by line
#Define STYLE_NOBACKBUFFER					&H0400			' Drawing directly to screen DC
#Define STYLE_NOSTATE						&H0800			' No state indicator
#Define STYLE_DRAGDROP						&H1000			' Drag & Drop support, app must load ole
#Define STYLE_SCROLLTIP						&H2000			' Scrollbar tooltip
#Define STYLE_HILITECOMMENT				&H4000			' Comments are hilited
#Define STYLE_AUTOSIZELINENUM				&H8000			' With of linenumber bar autosizes

#Define STYLEEX_LOCK							&H0001			' Show lock button
#Define STYLEEX_BLOCKGUIDE					&H0002			' Show block guiders
#Define STILEEX_LINECHANGED				&H0004			' Show line changed state
#Define STILEEX_STRINGMODEFB				&H0008			' FreeBasic
#Define STILEEX_STRINGMODEC				&H0010			' C/C++

' REM_COMMAND commands
#Define CMD_LEFT								1
#Define CMD_RIGHT								2
#Define CMD_LINE_UP							3
#Define CMD_LINE_DOWN						4
#Define CMD_PAGE_UP							5
#Define CMD_PAGE_DOWN						6
#Define CMD_HOME								7
#Define CMD_END								8
#Define CMD_INSERT							9
#Define CMD_DELETE							10
#Define CMD_BACKSPACE						11
' REM_COMMAND command modifyers
#Define CMD_ALT								256
#Define CMD_CTRL								512
#Define CMD_SHIFT								1024

' Private edit messages
#Define REM_BASE								WM_USER+1000
#Define REM_SETHILITEWORDS					REM_BASE+0		' nColor:Integer,pszWords:ZString Ptr
#Define REM_SETFONT							REM_BASE+1		' nLineSpacing:Integer,pRAFONT:RAFONT Ptr
#Define REM_GETFONT							REM_BASE+2		' 0,pRAFONT:RAFONT Ptr
#Define REM_SETCOLOR							REM_BASE+3		' 0,pRACOLOR:RACOLOR Ptr
#Define REM_GETCOLOR							REM_BASE+4		' 0,pRACOLOR:RACOLOR Ptr
#Define REM_SETHILITELINE					REM_BASE+5		' nLine:Integer,nColor:Integer
#Define REM_GETHILITELINE					REM_BASE+6		' nLine:Integer,0
#Define REM_SETBOOKMARK						REM_BASE+7		' nLine:Integer,nType:Integer
#Define REM_GETBOOKMARK						REM_BASE+8		' nLine:Integer,0
#Define REM_CLRBOOKMARKS					REM_BASE+9		' 0,nType:Integer
#Define REM_NXTBOOKMARK						REM_BASE+10		' nLine:Integer,nType:Integer
#Define REM_PRVBOOKMARK						REM_BASE+11		' nLine:Integer,nType:Integer
#Define REM_FINDBOOKMARK					REM_BASE+12		' nBmID:Integer,0
#Define REM_SETBLOCKS						REM_BASE+13		' pLINERANGE:LINERANGE Ptr,0
#Define REM_ISLINE							REM_BASE+14		' nLine:Integer,pszDef:ZString Ptr
#Define REM_GETWORD							REM_BASE+15		' nBuffSize:Integer,pBuff:ZString Ptr
#Define REM_COLLAPSE							REM_BASE+16		' nLine:Integer,0
#Define REM_COLLAPSEALL						REM_BASE+17		' 0,0
#Define REM_EXPAND							REM_BASE+18		' nLine:Integer,0
#Define REM_EXPANDALL						REM_BASE+19		' 0,0
#Define REM_LOCKLINE							REM_BASE+20		' nLine:Integer,bNewValue:RAE_BOOL
#Define REM_ISLINELOCKED					REM_BASE+21		' nLine:Integer,0
#Define REM_HIDELINE							REM_BASE+22		' nLine:Integer,bNewValue:RAE_BOOL
#Define REM_ISLINEHIDDEN					REM_BASE+23		' nLine:Integer,0
#Define REM_AUTOINDENT						REM_BASE+24		' 0,bNewValue:RAE_BOOL
#Define REM_TABWIDTH							REM_BASE+25		' nChars:Integer,bExpand:RAE_BOOL
#Define REM_SELBARWIDTH						REM_BASE+26		' nWidth:Integer,0
#Define REM_LINENUMBERWIDTH				REM_BASE+27		' nWidth:Integer,0
#Define REM_MOUSEWHEEL						REM_BASE+28		' nLines:Integer,0
#Define REM_SUBCLASS							REM_BASE+29		' 0,pWndProc
#Define REM_SETSPLIT							REM_BASE+30		' nSplit:Integer,0
#Define REM_GETSPLIT							REM_BASE+31		' 0,0
#Define REM_VCENTER							REM_BASE+32		' 0,0
#Define REM_REPAINT							REM_BASE+33		' 0,bPaintNow:RAE_BOOL
#Define REM_BMCALLBACK						REM_BASE+34		' 0,pBmProc:Any Ptr
#Define REM_READONLY							REM_BASE+35		' 0,bNewValue:RAE_BOOL
#Define REM_INVALIDATELINE					REM_BASE+36		' nLine:Integer,0
#Define REM_SETPAGESIZE						REM_BASE+37		' nLines:Integer,0
#Define REM_GETPAGESIZE						REM_BASE+38		' 0,0
#Define REM_GETCHARTAB						REM_BASE+39		' nChar:Integer,0|RAE_CT
#Define REM_SETCHARTAB						REM_BASE+40		' nChar:Integer,nNewValue:RAE_CT
#Define REM_SETCOMMENTBLOCKS				REM_BASE+41		' pszStart:ZString Ptr,pszEnd:ZString Ptr
#Define REM_SETWORDGROUP					REM_BASE+42		' 0,nGroup:Integer
#Define REM_GETWORDGROUP					REM_BASE+43		' 0,0
#Define REM_SETBMID							REM_BASE+44		' nLine:Integer,nBmID:Integer
#Define REM_GETBMID							REM_BASE+45		' nLine:Integer,0
#Define REM_ISCHARPOS						REM_BASE+46		' cp:Integer,0
#Define REM_HIDELINES						REM_BASE+47		' nLine:Integer,nLines:Integer
#Define REM_SETDIVIDERLINE					REM_BASE+48		' nLine:Integer,bNewValue:RAE_BOOL
#Define REM_ISINBLOCK						REM_BASE+49		' nLine:Integer,pRABLOCKDEF:RABLOCKDEF Ptr
#Define REM_TRIMSPACE						REM_BASE+50		' nLine:Integer,bLeft:RAE_BOOL
#Define REM_SAVESEL							REM_BASE+51		' 0,0
#Define REM_RESTORESEL						REM_BASE+52		' 0,0
#Define REM_GETCURSORWORD					REM_BASE+53		' nBuffSize:Integer,pBuff:ZString Ptr
#Define REM_SETSEGMENTBLOCK				REM_BASE+54		' nLine:Integer,bNewValue:RAE_BOOL
#Define REM_GETMODE							REM_BASE+55		' 0,0|RAE_MODE
#Define REM_SETMODE							REM_BASE+56		' nMode:RAE_MODE,0
#Define REM_GETBLOCK							REM_BASE+57		' 0,pBLOCKRANGE:BLOCKRANGE Ptr
#Define REM_SETBLOCK							REM_BASE+58		' 0,pBLOCKRANGE:BLOCKRANGE Ptr
#Define REM_BLOCKINSERT						REM_BASE+59		' 0,pBuff:ZString Ptr
#Define REM_LOCKUNDOID						REM_BASE+60		' bNewValue:RAE_BOOL,0
#Define REM_ADDBLOCKDEF						REM_BASE+61		' 0,pRABLOCKDEF:RABLOCKDEF Ptr
#Define REM_CONVERT							REM_BASE+62		' nType:RAE_CONVERT,0
#Define REM_BRACKETMATCH					REM_BASE+63		' 0,pszBracketMatch:ZString Ptr
#Define REM_COMMAND							REM_BASE+64		' nCommand:RAE_CMD,0
#Define REM_CASEWORD							REM_BASE+65		' cp:Integer,pszWord:ZString Ptr
#Define REM_GETBLOCKEND						REM_BASE+66		' nLine:Integer,0
#Define REM_SETLOCK							REM_BASE+67		' bNewValue:RAE_BOOL,0
#Define REM_GETLOCK							REM_BASE+68		' 0,0
#Define REM_GETWORDFROMPOS					REM_BASE+69		' cp:Integer,pBuff:ZString Ptr
#Define REM_SETNOBLOCKLINE					REM_BASE+70		' nLine:Integer,bNewValue:RAE_BOOL
#Define REM_ISLINENOBLOCK					REM_BASE+71		' nLine:Integer,0
#Define REM_SETALTHILITELINE				REM_BASE+72		' nLine:Integer,bNewValue:RAE_BOOL
#Define REM_ISLINEALTHILITE				REM_BASE+73		' nLine:Integer,0
#Define REM_SETCURSORWORDTYPE				REM_BASE+74		' nType:Integer,0
#Define REM_SETBREAKPOINT					REM_BASE+75		' nLine:Integer,bNewValue:RAE_BOOL
#Define REM_NEXTBREAKPOINT					REM_BASE+76		' nLine:Integer,0
#Define REM_GETLINESTATE					REM_BASE+77		' nLine:Integer,0|RAE_STATE
#Define REM_SETERROR							REM_BASE+78		' nLine:Integer,nErrID:Integer
#Define REM_GETERROR							REM_BASE+79		' nLine:Integer,0
#Define REM_NEXTERROR						REM_BASE+80		' nLine:Integer,0
#Define REM_CHARTABINIT						REM_BASE+81		' 0,0
#Define REM_LINEREDTEXT						REM_BASE+82		' nLine:Integer,bNewValue:RAE_BOOL
#Define REM_SETSTYLEEX						REM_BASE+83		' nStyleEx:RAE_STYLEEX,0
#Define REM_GETUNICODE						REM_BASE+84		' 0,0
#Define REM_SETUNICODE						REM_BASE+85		' bNewValue:RAE_BOOL,0
#Define REM_SETCHANGEDSTATE				REM_BASE+86		' bNewValue:RAE_BOOL,0
#Define REM_SETTOOLTIP						REM_BASE+87		' nToolTip:Integer,pszToolTip:ZString Ptr
#Define REM_HILITEACTIVELINE				REM_BASE+88		' 0,nColor:Integer
#Define REM_GETUNDO							REM_BASE+89		' nSize:Integer,pBuff:ZString Ptr
#Define REM_SETUNDO							REM_BASE+90		' nSize:Integer,pBuff:ZString Ptr
#Define REM_GETLINEBEGIN					REM_BASE+91		' nLine:Integer,0

' Convert types
#Define CONVERT_TABTOSPACE					0
#Define CONVERT_SPACETOTAB					1
#Define CONVERT_UPPERCASE					2
#Define CONVERT_LOWERCASE					3

' Modes
#Define MODE_NORMAL							0					' Normal
#Define MODE_BLOCK							1					' Block select
#Define MODE_OVERWRITE						2					' Overwrite mode

' Line hiliting
#Define STATE_HILITEOFF						0
#Define STATE_HILITE1						1
#Define STATE_HILITE2						2
#Define STATE_HILITE3						3
#Define STATE_HILITEMASK					3

' Bookmarks
#Define STATE_BMOFF							&H00
#Define STATE_BM1								&H10
#Define STATE_BM2								&H20
#Define STATE_BM3								&H30
#Define STATE_BM4								&H40
#Define STATE_BM5								&H50
#Define STATE_BM6								&H60
#Define STATE_BM7								&H70
#Define STATE_BM8								&H80
#Define STATE_BMMASK							&HF0

' Line states
#Define STATE_LOCKED							&H00100
#Define STATE_HIDDEN							&H00200
#Define STATE_COMMENT						&H00400
#Define STATE_DIVIDERLINE					&H00800
#Define STATE_SEGMENTBLOCK					&H01000
#Define STATE_NOBLOCK						&H02000
#Define STATE_ALTHILITE						&H04000
#Define STATE_BREAKPOINT					&H08000
#Define STATE_BLOCKSTART					&H10000
#Define STATE_BLOCK							&H20000
#Define STATE_BLOCKEND						&H40000
#Define STATE_REDTEXT						&H80000
#Define STATE_CHANGED						&H200000
#Define STATE_CHANGESAVED					&H400000
#Define STATE_GARBAGE						&H80000000

' Character table types
#Define CT_NONE								0
#Define CT_CHAR								1
#Define CT_OPER								2
#Define CT_HICHAR								3
#Define CT_CMNTCHAR							4
#Define CT_STRING								5
#Define CT_CMNTDBLCHAR						6
#Define CT_CMNTINITCHAR						7

Type RAFONT Field=1
	hFont			As HFONT											' Code edit normal
	hIFont		As HFONT											' Code edit italics
	hLnrFont		As HFONT											' Line numbers
End Type

Type RACOLOR Field=1
	bckcol		As Long											' Back color
	txtcol		As Long											' Text color
	selbckcol	As Long											' Sel back color
	seltxtcol	As Long											' Sel text color
	cmntcol		As Long											' Comment color
	strcol		As Long											' String color
	oprcol		As Long											' Operator color
	hicol1		As Long											' Line hilite 1
	hicol2		As Long											' Line hilite 2
	hicol3		As Long											' Line hilite 3
	selbarbck	As Long											' Selection bar
	selbarpen	As Long											' Selection bar pen
	lnrcol		As Long											' Line numbers color
	numcol		As Long											' Numbers & hex color
	cmntback		As Long											' Comment back color
	strback		As Long											' String back color
	numback		As Long											' Numbers & hex back color
	oprback		As Long											' Operator back color
	changed		As Long											' Line changed indicator
	changesaved	As Long											' Line saved chane indicator
End Type

Type RASELCHANGE Field=1
	nmhdr			As NMHDR
	chrg			As CHARRANGE									' Current selection
	seltyp		As Word											' SEL_TEXT or SEL_OBJECT
	Line			As Long											' Line number
	cpLine		As Long											' Character position of first character
	lpLine		As Long											' Pointer to line
	nlines		As Long											' Total number of lines
	nhidden		As Long											' Total number of hidden lines
	fchanged		As Long											' TRUE if changed since last
	npage			As Long											' Page number
	nWordGroup	As Long											' Hilite word group(0-15)
End Type

#Define BD_NONESTING							&H01				' Set to true for non nested blocks
#Define BD_DIVIDERLINE						&H02				' Draws a divider line
#Define BD_INCLUDELAST						&H04				' lpszEnd line is also collapsed
#Define BD_LOOKAHEAD							&H08				' Look 500 lines ahead for the ending
#Define BD_SEGMENTBLOCK						&H10				' Segment block, collapse till next segmentblock
#Define BD_COMMENTBLOCK						&H20				' Comment block, collapse till end of commentblock
#Define BD_NOBLOCK							&H40				' No block nesting
#Define BD_ALTHILITE							&H80				' wordgroup+1

Type RABLOCKDEF Field=1
	lpszStart	As ZString Ptr									' Block start
	lpszEnd		As ZString Ptr									' Block end
	lpszNot1		As ZString Ptr									' Dont hide line containing this or set to NULL
	lpszNot2		As ZString Ptr									' Dont hide line containing this or set to NULL
	flag			As Long											' High word is WordGroup(0-15)
End Type

Type LINERANGE Field=1
	lnMin		As Long												' Starting line
	lnMax		As Long												' Ending line
End Type

Type BLOCKRANGE Field=1
	lnMin		As Long												' Starting line
	clMin		As Long												' Starting column
	lnMax		As Long												' Ending line
	clMax		As Long												' Ending column
End Type
