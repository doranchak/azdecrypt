'Messages
		'Create horizontal splitt in current splitt at current row. wParam=0, lParam=0
#Define SPRM_SPLITTHOR				WM_USER+100		' 0,0
		'Create vertical splitt in current splitt at current col. wParam=0, lParam=0
#Define SPRM_SPLITTVER				WM_USER+101		' 0,0
		'Close the current splitt. wParam=0, lParam=0
#Define SPRM_SPLITTCLOSE			WM_USER+102		' 0,0
		'Syncronizez a splitt window witit's parent. wParam=0, lParam=TRUE/FALSE
#Define SPRM_SPLITTSYNC				WM_USER+103		' 0,bSync[FALSE,TRUE]
		'*Get splitt state. wParam=nWin(0-7), if nWin=-1 active split window, lParam=0
#Define SPRM_GETSPLITTSTATE		WM_USER+104		' nWin:Integer,0
		'Get the current cells rect in active splitt. wParam=0, lParam=pointer to RECT struct. Returns handle of active splitt window.
#Define SPRM_GETCELLRECT			WM_USER+105		' 0,pRECT:RECT Ptr|HWND
		'Get lock cols in active splitt. wParam=0, lParam=0
#Define SPRM_GETLOCKCOL				WM_USER+106		' 0,0
		'Lock cols in active splitt. wParam=0, lParam=cols
#Define SPRM_SETLOCKCOL				WM_USER+107		' 0,nCols:Integer
		'Get lock rows in active splitt. wParam=0, lParam=0
#Define SPRM_GETLOCKROW				WM_USER+108		' 0,0
		'Lock rows in active splitt. wParam=0, lParam=rows
#Define SPRM_SETLOCKROW				WM_USER+109		' 0,nRows:Integer
		'Delete col. wParam=col, lParam=0
#Define SPRM_DELETECOL				WM_USER+110		' nCol:Integer,0
		'Insert col. wParam=col, lParam=0
#Define SPRM_INSERTCOL				WM_USER+111		' nCol:Integer,0
		'Delete row. wParam=row, lParam=0
#Define SPRM_DELETEROW				WM_USER+112		' nRow:Integer,0
		'Insert row. wParam=row, lParam=0
#Define SPRM_INSERTROW				WM_USER+113		' nRow:Integer,0
		'Get number of columns. wParam=0, lParam=0
#Define SPRM_GETCOLCOUNT			WM_USER+114		' 0,0|Integer
		'Set number of columns. wParam=nCols, lParam=0
#Define SPRM_SETCOLCOUNT			WM_USER+115		' nCols:Integer,0
		'Get number of rows. wParam=0, lParam=0
#Define SPRM_GETROWCOUNT			WM_USER+116		' 0,0|Integer
		'Set number of rows. wParam=nRows, lParam=0
#Define SPRM_SETROWCOUNT			WM_USER+117		' nRows:Integer,0
		'Recalculates the sheet
#Define SPRM_RECALC					WM_USER+118		' 0,0
		'Blank a cell. wParam=col, lParam=row
#Define SPRM_BLANKCELL				WM_USER+119		' nCol:Integer,nRow:Integer
		'Get active splitt window. wParam=0, lParam=0
#Define SPRM_GETCURRENTWIN			WM_USER+120		' 0,0|Integer
		'Set active splitt window. wParam=0, lParam=nWin (0-7)
#Define SPRM_SETCURRENTWIN			WM_USER+121		' 0,nWin:Integer
		'Get current col/row in active window. wParam=0, lParam=0. Returns Hiword=row, Loword=col
#Define SPRM_GETCURRENTCELL		WM_USER+122		' 0,0|Integer
		'Set current col/row in active window. wParam=col, lParam=row
#Define SPRM_SETCURRENTCELL		WM_USER+123		' nCol:Integer,nRow:Integer
		'*Get content of current cell. wParam=0, lParam=0. Returns a pointer to a null terminated string.
#Define SPRM_GETCELLSTRING			WM_USER+124		' 0,0|ZString Ptr
		'Set content of current cell. wParam=type, lParam=pointer to string.
#Define SPRM_SETCELLSTRING			WM_USER+125		' nType:Integer,pszString:ZString Ptr
		'Get column width. wParam=col, lParam=0. Returns column width.
#Define SPRM_GETCOLWIDT		  		WM_USER+126		' nCol:Integer,0|Integer
		'Set column width. wParam=col, lParam=width.
#Define SPRM_SETCOLWIDT		  		WM_USER+127		' nCol:Integer,nWidth:Integer
		'Get row height. wParam=row, lParam=0. Returns row height.
#Define SPRM_GETROWHEIGHT		  	WM_USER+128		' nRow:Integer,0|Integer
		'Set row height. wParam=row, lParam=height.
#Define SPRM_SETROWHEIGHT		  	WM_USER+129		' nRow:Integer,nHeight:Integer
		'Get cell data. wParam=0, lParam=Pointer to SPR_ITEM struct
#Define SPRM_GETCELLDATA			WM_USER+130		' 0,pSPR_ITEM:SPR_ITEM Ptr
		'Set cell data. wParam=0, lParam=Pointer to SPR_ITEM struct
#Define SPRM_SETCELLDATA			WM_USER+131		' 0,pSPR_ITEM:SPR_ITEM Ptr
		'Get multiselection. wParam=0, lParam=pointer to a RECT struct. Returns handle of active split window
#Define SPRM_GETMULTISEL			WM_USER+132		' 0,pRECT:RECT Ptr|HWND
		'Set multiselection. wParam=0, lParam=pointer to a RECT struct. Returns handle of active split window
#Define SPRM_SETMULTISEL			WM_USER+133		' 0,pRECT:RECT Ptr|HWND
		'Get font. wParam=index(0-15), lParam=pointer to FONT struct. Returns font handle
#Define SPRM_GETFONT					WM_USER+134		' nIndex:Integer,pFONT:FONT Ptr|HFONT
		'Set font. wParam=index(0-15), lParam=pointer to FONT struct. Returns font handle
#Define SPRM_SETFONT					WM_USER+135		' nIndex:Integer,pFONT:FONT Ptr|HFONT
		'Get global. wParam=0, lParam=pointer to GLOBAL struct.
#Define SPRM_GETGLOBAL				WM_USER+136		' 0,pGLOBAL:GLOBAL Ptr
		'Set global. wParam=0, lParam=pointer to GLOBAL struct.
#Define SPRM_SETGLOBAL				WM_USER+137		' 0,pGLOBAL:GLOBAL Ptr
		'Import a line of data. wParam=SepChar, lParam=pointer to data line.
#Define SPRM_IMPORTLINE				WM_USER+138		' nSepChar:Integer,pszLine:ZString Ptr
		'Load a file. wParam=0, lParam=pointer to filename
#Define SPRM_LOADFILE				WM_USER+139		' 0,pszFileName:ZString Ptr
		'Save a file. wParam=0, lParam=pointer to filename
#Define SPRM_SAVEFILE				WM_USER+140		' 0,pszFileName:ZString Ptr
		'Clears the sheet. wParam=0, lParam=0
#Define SPRM_NEWSHEET			  	WM_USER+141		' 0,0
		'Expand a cell to cover more than one cell. wParam=0, lParam=pointer to RECT struct
#Define SPRM_EXPANDCELL				WM_USER+142		' 0,pRECT:RECT Ptr
		'Get cell data type. wParam=col, lParam=row. Returns cell type.
#Define SPRM_GETCELLTYPE			WM_USER+143		' nCol:Integer,nRow:Integer|Integer
		'Adjust cell refs in formula. wParam=pointer to cell, lParam=pointer to RECT.
#Define SPRM_ADJUSTCELLREF			WM_USER+144		' pCell,pRECT:RECT Ptr
		'Creates a ComboBox. wPatam=0, lParam=0
#Define SPRM_CREATECOMBO			WM_USER+145		' 0,0
		'Scrolls current cell into view
#Define SPRM_SCROLLCELL				WM_USER+146		' 0,0
		'Deletes a cell. wParam=col, lParam=row
#Define SPRM_DELETECELL				WM_USER+147		' nCol:Integer,nRow:Integer
		'Returns date format string. wParam=0, lParam=0
#Define SPRM_GETDATEFORMAT			WM_USER+148		' 0,0|ZString Ptr
		'Sets date format string. wParam=0, lParam=lpDateFormat (yyyy-MM-dd)
#Define SPRM_SETDATEFORMAT			WM_USER+149		' 0,pszDateFormat:ZString Ptr
		'Calculate row height. wParam=row, lParam=Update TRUE/FALSE. Returns max row height needed.
#Define SPRM_CALCROWHEIGHT			WM_USER+150		' nRow:Integer,bUpdate[FALSE,TRUE]|Integer

'Styles
#Define SPS_VSCROLL			  		&h0001			'Vertical scrollbar
#Define SPS_HSCROLL			  		&h0002			'Horizontal scrollbar
#Define SPS_STATUS			  		&h0004			'Show status window
#Define SPS_GRIDLINES			  	&h0008			'Show grid lines
#Define SPS_ROWSELECT			  	&h0010			'Selection by row
#Define SPS_CELLEDIT			  		&h0020			'Cell editing
#Define SPS_GRIDMODE			  		&h0040			'Inserting and deleting row/col adjusts max row/col
#Define SPS_COLSIZE			  		&h0080			'Allow col widt sizeing by mouse
#Define SPS_ROWSIZE		      	&h0100			'Allow row height sizeing by mouse
#Define SPS_WINSIZE			  		&h0200			'Allow splitt window sizeing by mouse
#Define SPS_MULTISELECT		  		&h0400			'Allow multiselect
#Define SPS_LOCKVSCROLL				&h0800			'Vertical scrolling is locked
#Define SPS_LOCKHSCROLL				&h1000			'Horizontal scrolling is locked
#Define SPS_NOFOCUS					&h2000			'The cellfocus is not shown.

'Cell data types
#Define TPE_EMPTY						&h000				'The cell contains formatting only
#Define TPE_COLHDR					&h001				'Column header
#Define TPE_ROWHDR					&h002				'Row header
#Define TPE_WINHDR					&h003				'Window (splitt) header
#Define TPE_TEXT						&h004				'Text cell
#Define TPE_TEXTMULTILINE			&h005				'Text cell, text is multiline
#Define TPE_INTEGER					&h006				'Double word integer
#Define TPE_FLOAT						&h007				'80 bit float
#Define TPE_FORMULA					&h008				'Formula
#Define TPE_GRAP						&h009				'Graph
#Define TPE_HYPERLINK				&h00A				'Hyperlink
#Define TPE_CHECKBOX					&h00B				'Checkbox
#Define TPE_COMBOBOX					&h00C				'Combobox
#Define TPE_OWNERDRAWBLOB			&h00D				'Owner drawn blob, first word is lenght of blob
#Define TPE_OWNERDRAWINTEGER		&h00E				'Owner drawn integer

#Define TPE_EXPANDED					&h00F				'Part of expanded cell, internally used

#Define TPE_BUTTON					&h010				'Small button
#Define TPE_WIDEBUTTON				&h020				'Button, covers the cell
#Define TPE_DATE						&h030				'Combine with type integer
#Define TPE_FORCETYPE				&h040				'Forced type
#Define TPE_FIXEDSIZE				&h080				'Fixed size for CheckBox, ComboBox and Button image

'Format Alignment & Decimals
#Define FMTA_AUTO						&h000				'Text left middle, numbers right middle
#Define FMTA_LEFT						&h010
#Define FMTA_CENTER					&h020
#Define FMTA_RIGHT					&h030
#Define FMTA_TOP						&h000
#Define FMTA_MIDDLE					&h040
#Define FMTA_BOTTOM					&h080
#Define FMTA_GLOBAL					&h0F0
#Define FMTA_MASK						&h0F0				'Alignment mask
#Define FMTA_XMASK					&h030				'Alignment x-mask
#Define FMTA_YMASK					&h0C0				'Alignment y-mask

#Define FMTD_0							&h00
#Define FMTD_1							&h01
#Define FMTD_2							&h02
#Define FMTD_3							&h03
#Define FMTD_4							&h04
#Define FMTD_5							&h05
#Define FMTD_6							&h06
#Define FMTD_7							&h07
#Define FMTD_8							&h08
#Define FMTD_9							&h09
#Define FMTD_10						&h0A
#Define FMTD_11						&h0B
#Define FMTD_12						&h0C
#Define FMTD_ALL						&h0D
#Define FMTD_SCI						&h0E
#Define FMTD_GLOBAL					&h0F
#Define FMTD_MASK						&h0F

Type FORMAT
	bckcol			As Integer							'Back color
	txtcol			As Integer							'Text color
	txtal				As Byte								'Text alignment and decimals
	imgal				As Byte								'Image alignment and imagelist/control index
	fnt				As Byte								'Font index (0-15)
	tpe				As Byte								'Cell type
End Type

Type GLOBAL
	colhdrbtn		As Integer
	rowhdrbtn		As Integer
	winhdrbtn		As Integer
	lockcol			As Integer							'Back color of locked cell
	hdrgrdcol		As Integer							'Header grid color
	grdcol			As Integer							'Cell grid color
	bcknfcol			As Integer							'Back color of active cell, lost focus
	txtnfcol			As Integer							'Text color of active cell, lost focus
	bckfocol			As Integer							'Back color of active cell, has focus
	txtfocol			As Integer							'Text color of active cell, has focus
	ncols				As Integer
	nrows				As Integer
	ghdrwt			As Integer
	ghdrht			As Integer
	gcellwt			As Integer
	gcellht			As Integer
	colhdr			As FORMAT							'Column header formatting
	rowhdr			As FORMAT 							'Row header formatting
	winhdr			As FORMAT							'Window header formatting
	cell				As FORMAT							'Cell formatting
End Type

Type FONT
	hfont				As Integer							'Font handle
	face				As ZString*LF_FACESIZE			'Face name
	fsize				As Integer							'Point size
	ht					As Integer							'Height
	bold				As Byte								'Bold
	italic			As Byte								'Italics
	underline		As Byte								'Underline
	strikeout		As Byte								'Strikeout
End Type

#Define STATE_LOCKED					&h001				'Cell is locked for editing
#Define STATE_HIDDEN					&h002				'Cell content is not displayed
#Define STATE_AUTOSIZEHEIGHT		&h004				'Cell forces autosize height for the row when data is entered in a multiline cell
#Define STATE_REDRAW					&h008
#Define STATE_ERROR					&h010
#Define STATE_DIV0					&h020
#Define STATE_UNDERFLOW				&h030
#Define STATE_OVERFLOW				&h040
#Define STATE_RECALC					&h080
#Define STATE_ERRMASK				&h0F0

#Define SPRIF_BACKCOLOR				&h00000001		'Back color is valid
#Define SPRIF_TEXTCOLOR				&h00000002		'Text color is valid
#Define SPRIF_TEXTALIGN				&h00000004
#Define SPRIF_IMAGEALIGN			&h00000008
#Define SPRIF_FONT					&h00000010
#Define SPRIF_STATE					&h00000020
#Define SPRIF_TYPE					&h00000040
#Define SPRIF_WIDTH					&h00000080
#Define SPRIF_HEIGHT					&h00000100
#Define SPRIF_DATA					&h00000200
#Define SPRIF_DOUBLE					&h00000400		'Converts to / from double
#Define SPRIF_SINGLE					&h00000800		'Converts to / from single
#Define SPRIF_COMPILE				&h80000000		'Compile the formula

Type SPR_ITEM
	flag				As Integer
	col				As Integer
	row				As Integer
	expx				As Byte								'Expanded columns
	expy				As Byte								'Expanded rows
	state				As Byte
	fmt				As FORMAT
	wt					As Integer
	ht					As Integer
	lpdta				As Any ptr
End Type

'Notification messages (WM_NOTIFY)
#Define SPRN_SELCHANGE				1					'Splitt, col or row changed.
#Define SPRN_BEFOREEDIT				2					'Before the editbox is shown
#Define SPRN_AFTEREDIT				3					'After the editbox is closed
#Define SPRN_BEFOREUPDATE			4					'Before cell is updated
#Define SPRN_AFTERUPDATE			5					'After cell is updated
#Define SPRN_HYPERLINKENTER		6					'Hyperlink entered
#Define SPRN_HYPERLINKLEAVE		7					'Hyperlink leaved
#Define SPRN_HYPERLINKCLICK		8					'Hyperlink clicked
#Define SPRN_BUTTONCLICK			9					'Button clicked

'on structs
Type SPR_SELCHANGE
	hdr				As NMHDR
	nwin				As Integer
	col				As Integer
	row				As Integer
	fcancel			As Integer
	fclick			As Integer							'TRUE if mouse was clicked
End Type

Type SPR_EDIT
	hdr				As NMHDR
	lpspri			As SPR_ITEM ptr
	fcancel			As Integer
End Type

Type SPR_HYPERLINK
	hdr				As NMHDR
	lpspri			As SPR_ITEM ptr
End Type

Type SPR_BUTTON
	hdr				As NMHDR
	lpspri			As SPR_ITEM ptr
End Type
