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
#Define DEFCHANGEDCLR						&H0000F0F0
#Define DEFCHANGESAVEDCLR					&H0000F000

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
#Define REM_SETHILITEWORDS					REM_BASE+0		' wParam=Color, lParam=lpszWords
#Define REM_SETFONT							REM_BASE+1		' wParam=nLineSpacing, lParam=lpRAFONT
#Define REM_GETFONT							REM_BASE+2		' wParam=0, lParam=lpRAFONT
#Define REM_SETCOLOR							REM_BASE+3		' wParam=0, lParam=lpRACOLOR
#Define REM_GETCOLOR							REM_BASE+4		' wParam=0, lParam=lpRACOLOR
#Define REM_SETHILITELINE					REM_BASE+5		' wParam=Line, lParam=Color
#Define REM_GETHILITELINE					REM_BASE+6		' wParam=Line, lParam=0
#Define REM_SETBOOKMARK						REM_BASE+7		' wParam=Line, lParam=Type
#Define REM_GETBOOKMARK						REM_BASE+8		' wParam=Line, lParam=0
#Define REM_CLRBOOKMARKS					REM_BASE+9		' wParam=0, lParam=Type
#Define REM_NXTBOOKMARK						REM_BASE+10		' wParam=Line, lParam=Type
#Define REM_PRVBOOKMARK						REM_BASE+11		' wParam=Line, lParam=Type
#Define REM_FINDBOOKMARK					REM_BASE+12		' wParam=BmID, lParam=0
#Define REM_SETBLOCKS						REM_BASE+13		' wParam=[lpLINERANGE], lParam=0
#Define REM_ISLINE							REM_BASE+14		' wParam=Line, lParam=lpszDef
#Define REM_GETWORD							REM_BASE+15		' wParam=BuffSize, lParam=lpBuff
#Define REM_COLLAPSE							REM_BASE+16		' wParam=Line, lParam=0
#Define REM_COLLAPSEALL						REM_BASE+17		' wParam=0, lParam=0
#Define REM_EXPAND							REM_BASE+18		' wParam=Line, lParam=0
#Define REM_EXPANDALL						REM_BASE+19		' wParam=0, lParam=0
#Define REM_LOCKLINE							REM_BASE+20		' wParam=Line, lParam=TRUE/FALSE
#Define REM_ISLINELOCKED					REM_BASE+21		' wParam=Line, lParam=0
#Define REM_HIDELINE							REM_BASE+22		' wParam=Line, lParam=TRUE/FALSE
#Define REM_ISLINEHIDDEN					REM_BASE+23		' wParam=Line, lParam=0
#Define REM_AUTOINDENT						REM_BASE+24		' wParam=0, lParam=TRUE/FALSE
#Define REM_TABWIDTH							REM_BASE+25		' wParam=nChars, lParam=TRUE/FALSE (Expand tabs)
#Define REM_SELBARWIDTH						REM_BASE+26		' wParam=nWidth, lParam=0
#Define REM_LINENUMBERWIDTH				REM_BASE+27		' wParam=nWidth, lParam=0
#Define REM_MOUSEWHEEL						REM_BASE+28		' wParam=nLines, lParam=0
#Define REM_SUBCLASS							REM_BASE+29		' wParam=0, lParam=lpWndProc
#Define REM_SETSPLIT							REM_BASE+30		' wParam=nSplit, lParam=0
#Define REM_GETSPLIT							REM_BASE+31		' wParam=0, lParam=0
#Define REM_VCENTER							REM_BASE+32		' wParam=0, lParam=0
#Define REM_REPAINT							REM_BASE+33		' wParam=0, lParam=TRUE/FALSE (Paint Now)
#Define REM_BMCALLBACK						REM_BASE+34		' wParam=0, lParam=lpBmProc
#Define REM_READONLY							REM_BASE+35		' wParam=0, lParam=TRUE/FALSE
#Define REM_INVALIDATELINE					REM_BASE+36		' wParam=Line, lParam=0
#Define REM_SETPAGESIZE						REM_BASE+37		' wParam=nLines, lParam=0
#Define REM_GETPAGESIZE						REM_BASE+38		' wParam=0, lParam=0
#Define REM_GETCHARTAB						REM_BASE+39		' wParam=nChar, lParam=0
#Define REM_SETCHARTAB						REM_BASE+40		' wParam=nChar, lParam=nValue
#Define REM_SETCOMMENTBLOCKS				REM_BASE+41		' wParam=lpStart, lParam=lpEnd
#Define REM_SETWORDGROUP					REM_BASE+42		' wParam=0, lParam=nGroup (0-15)
#Define REM_GETWORDGROUP					REM_BASE+43		' wParam=0, lParam=0
#Define REM_SETBMID							REM_BASE+44		' wParam=nLine, lParam=nBmID
#Define REM_GETBMID							REM_BASE+45		' wParam=nLine, lParam=0
#Define REM_ISCHARPOS						REM_BASE+46		' wParam=CP, lParam=0, returns 1 if comment block, 2 if comment, 3 if string
#Define REM_HIDELINES						REM_BASE+47		' wParam=nLine, lParam=nLines
#Define REM_SETDIVIDERLINE					REM_BASE+48		' wParam=nLine, lParam=TRUE/FALSE
#Define REM_ISINBLOCK						REM_BASE+49		' wParam=nLine, lParam=lpRABLOCKDEF
#Define REM_TRIMSPACE						REM_BASE+50		' wParam=nLine, lParam=fLeft
#Define REM_SAVESEL							REM_BASE+51		' wParam=0, lParam=0
#Define REM_RESTORESEL						REM_BASE+52		' wParam=0, lParam=0
#Define REM_GETCURSORWORD					REM_BASE+53		' wParam=BuffSize, lParam=lpBuff
#Define REM_SETSEGMENTBLOCK				REM_BASE+54		' wParam=nLine, lParam=TRUE/FALSE
#Define REM_GETMODE							REM_BASE+55		' wParam=0, lParam=0
#Define REM_SETMODE							REM_BASE+56		' wParam=nMode, lParam=0
#Define REM_GETBLOCK							REM_BASE+57		' wParam=0, lParam=lpBLOCKRANGE
#Define REM_SETBLOCK							REM_BASE+58		' wParam=0, lParam=lpBLOCKRANGE
#Define REM_BLOCKINSERT						REM_BASE+59		' wParam=0, lParam=lpText
#Define REM_LOCKUNDOID						REM_BASE+60		' wParam=TRUE/FALSE, lParam=0
#Define REM_ADDBLOCKDEF						REM_BASE+61		' wParam=0, lParam=lpRABLOCKDEF
#Define REM_CONVERT							REM_BASE+62		' wParam=nType, lParam=0
#Define REM_BRACKETMATCH					REM_BASE+63		' wParam=0, lParam=lpszBracketMatch
#Define REM_COMMAND							REM_BASE+64		' wParam=nCommand, lParam=0
#Define REM_CASEWORD							REM_BASE+65		' wParam=cp, lParam=lpWord
#Define REM_GETBLOCKEND						REM_BASE+66		' wParam=Line, lParam=0
#Define REM_SETLOCK							REM_BASE+67		' wParam=TRUE/FALSE, lParam=0
#Define REM_GETLOCK							REM_BASE+68		' wParam=0, lParam=0
#Define REM_GETWORDFROMPOS					REM_BASE+69		' wParam=cp, lParam=lpBuff
#Define REM_SETNOBLOCKLINE					REM_BASE+70		' wParam=Line, lParam=TRUE/FALSE
#Define REM_ISLINENOBLOCK					REM_BASE+71		' wParam=Line, lParam=0
#Define REM_SETALTHILITELINE				REM_BASE+72		' wParam=Line, lParam=TRUE/FALSE
#Define REM_ISLINEALTHILITE				REM_BASE+73		' wParam=Line, lParam=0
#Define REM_SETCURSORWORDTYPE				REM_BASE+74		' wParam=nType, lParam=0
#Define REM_SETBREAKPOINT					REM_BASE+75		' wParam=nLine, lParam=TRUE/FALSE
#Define REM_NEXTBREAKPOINT					REM_BASE+76		' wParam=nLine, lParam=0
#Define REM_GETLINESTATE					REM_BASE+77		' wParam=nLine, lParam=0
#Define REM_SETERROR							REM_BASE+78		' wParam=nLine, lParam=nErrID
#Define REM_GETERROR							REM_BASE+79		' wParam=nLine, lParam=0
#Define REM_NEXTERROR						REM_BASE+80		' wParam=nLine, lParam=0
#Define REM_CHARTABINIT						REM_BASE+81		' wParam=0, lParam=0
#Define REM_LINEREDTEXT						REM_BASE+82		' wParam=nLine, lParam=TRUE/FALSE
#Define REM_SETSTYLEEX						REM_BASE+83		' wParam=nStyleEx, lParam=0
#Define REM_GETUNICODE						REM_BASE+84		' wParam=0, lParam=0
#Define REM_SETUNICODE						REM_BASE+85		' wParam=TRUE/FALSE, lParam=0
#Define REM_SETCHANGEDSTATE				REM_BASE+86		' wParam=TRUE/FALSE, lParam=0
#Define REM_SETTOOLTIP						REM_BASE+87		' wParam=n (1-6), lParam=lpText
#Define REM_HILITEACTIVELINE				REM_BASE+88		' wParam=0, lParam=nColor

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
#Define STATE_COMMENTNEST					&H00100000
#Define STATE_CHANGED						&H00200000
#Define STATE_CHANGESAVED					&H00400000
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
	lpszStart	As ZString Ptr										' Block start
	lpszEnd		As ZString Ptr									' Block end
	lpszNot1		As ZString Ptr									' Dont hide line containing this or set to NULL
	lpszNot2		As ZString Ptr										' Dont hide line containing this or set to NULL
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
