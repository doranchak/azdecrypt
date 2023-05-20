#Define GN_HEADERCLICK		1				'User clicked header
#Define GN_BUTTONCLICK		2				'Sendt when user clicks the button in a button cell
#Define GN_CHECKCLICK		3				'Sendt when user double clicks the checkbox in a checkbox cell
#Define GN_IMAGECLICK		4				'Sendt when user double clicks the image in an image cell
#Define GN_BEFORESELCHANGE	5				'Sendt when user request a selection change
#Define GN_AFTERSELCHANGE	6				'Sendt after a selection change
#Define GN_BEFOREEDIT		7				'Sendt before the cell edit control shows
#Define GN_AFTEREDIT			8				'Sendt when the cell edit control is about to close
#Define GN_BEFOREUPDATE		9				'Sendt before a cell updates grid data
#Define GN_AFTERUPDATE		10				'Sendt after grid data has been updated
#Define GN_USERCONVERT		11				'Sendt when user cell needs to be converted.
#Define GN_EDITCHANGE		12				'Sendt when user types text in the edit control.

'Messages
#Define GM_ADDCOL				WM_USER+1	'0,lpCOLUMN:COLUMN Ptr
#Define GM_ADDROW				WM_USER+2	'0,lpROWDATA:Any Ptr
#Define GM_INSROW				WM_USER+3	'nRow:Integer,lpROWDATA:Any Ptr
#Define GM_DELROW				WM_USER+4	'nRow:Integer,0
#Define GM_MOVEROW			WM_USER+5	'nFromRow:Integer,nToRow:Integer
#Define GM_COMBOADDSTRING	WM_USER+6	'nCol:Integer,lpszString:ZString Ptr
#Define GM_COMBOCLEAR		WM_USER+7	'nCol:Integer,0
#Define GM_GETCURSEL			WM_USER+8	'0,0|Integer
#Define GM_SETCURSEL			WM_USER+9	'nCol:Integer,nRow:Integer
#Define GM_GETCURCOL			WM_USER+10	'0,0|Integer
#Define GM_SETCURCOL			WM_USER+11	'nCol:Integer,0
#Define GM_GETCURROW			WM_USER+12	'0,0|Integer
#Define GM_SETCURROW			WM_USER+13	'nRow:Integer,0
#Define GM_GETCOLCOUNT		WM_USER+14	'0,0
#Define GM_GETROWCOUNT		WM_USER+15	'0,0|Integer
#Define GM_GETCELLDATA		WM_USER+16	'nRowCol:Integer,lpData:Any Ptr
#Define GM_SETCELLDATA		WM_USER+17	'nRowCol:Integer,lpData:Any Ptr
#Define GM_GETCELLRECT		WM_USER+18	'nRowCol:Integer,lpRECT:RECT Ptr
#Define GM_SCROLLCELL		WM_USER+19	'0,0
#Define GM_GETBACKCOLOR		WM_USER+20	'0,0
#Define GM_SETBACKCOLOR		WM_USER+21	'nColor:Integer,0
#Define GM_GETGRIDCOLOR		WM_USER+22	'0,0|Integer
#Define GM_SETGRIDCOLOR		WM_USER+23	'nColor:Integer,0
#Define GM_GETTEXTCOLOR		WM_USER+24	'0,0|Integer
#Define GM_SETTEXTCOLOR		WM_USER+25	'nColor:Integer,0
#Define GM_ENTEREDIT			WM_USER+26	'nCol:Integer,nRow:Integer
#Define GM_ENDEDIT			WM_USER+27	'nRowCol:Integer,bCancel[FALSE,TRUE]
#Define GM_GETCOLWIDTH		WM_USER+28	'nCol:Integer,0|Integer
#Define GM_SETCOLWIDTH		WM_USER+29	'nCol:Integer,nWidth:Integer
#Define GM_GETHDRHEIGHT		WM_USER+30	'0,0|Integer
#Define GM_SETHDRHEIGHT		WM_USER+31	'0,nHeight:Integer
#Define GM_GETROWHEIGHT		WM_USER+32	'nRow:Integer,0|Integer
#Define GM_SETROWHEIGHT		WM_USER+33	'0,nHeight:Integer
#Define GM_RESETCONTENT		WM_USER+34	'0,0
#Define GM_COLUMNSORT		WM_USER+35	'nCol:Integer,nSort[SORT_ASCENDING,SORT_DESCENDING,SORT_INVERT]
#Define GM_GETHDRTEXT		WM_USER+36	'nCol:Integer,lpBuffer:ZString Ptr
#Define GM_SETHDRTEXT		WM_USER+37	'nCol:Integer,lpszText:ZString Ptr
#Define GM_GETCOLFORMAT		WM_USER+38	'nCol:Integer,lpBuffer:ZString Ptr
#Define GM_SETCOLFORMAT		WM_USER+39	'nCol:Integer,lpszText:ZString Ptr
#Define GM_CELLCONVERT		WM_USER+40	'nRowCol:Integer,lpszBuffer:ZString Ptr
#Define GM_RESETCOLUMNS		WM_USER+41	'0,0
#Define GM_GETROWCOLOR		WM_USER+42	'nRow:Integer,lpROWCOLOR:ROWCOLOR Ptr
#Define GM_SETROWCOLOR		WM_USER+43	'nRow:Integer,lpROWCOLOR:ROWCOLOR Ptr
#Define GM_GETCOLDATA		WM_USER+44	'nCol:Integer,lpCOLUMN:COLUMN Ptr
#Define GM_COMBOFINDSTRING	WM_USER+45	'nCol:Integer,lpszString:ZString Ptr

'Column alignment
#Define GA_ALIGN_LEFT		0
#Define GA_ALIGN_CENTER		1
#Define GA_ALIGN_RIGHT		2

'Column types
#Define TYPE_EDITTEXT		0				'String
#Define TYPE_EDITLONG		1				'Long
#Define TYPE_CHECKBOX		2				'Long
#Define TYPE_COMBOBOX		3				'Long
#Define TYPE_HOTKEY			4				'Long
#Define TYPE_BUTTON			5				'String
#Define TYPE_IMAGE			6				'Long
#Define TYPE_DATE				7				'Long
#Define TYPE_TIME				8				'Long
#Define TYPE_USER				9				'0=String, 1 to 512 bytes binary data
#Define TYPE_EDITBUTTON		10				'String
#Define TYPE_EDITCOMBOBOX	11				'String

'Column sorting
#Define SORT_ASCENDING		0
#Define SORT_DESCENDING		1
#Define SORT_INVERT			2

'Window styles
#Define STYLE_NOSEL			&H01
#Define STYLE_NOFOCUS		&H02
#Define STYLE_HGRIDLINES	&H04
#Define STYLE_VGRIDLINES	&H08
#Define STYLE_GRIDFRAME		&H10
#Define STYLE_NOCOLSIZE		&H20

#Define ODT_GRID				6

Type COLUMN
	colwt As Integer							'Column width
	lpszhdrtext As PTSTR						'Pointer to header text.
	halign As Integer							'Header text alignment.
	calign As Integer							'Column text alignment.
	ctype As Integer							'Column data type.
	ctextmax As Integer						'Max text lenght for TYPE_EDITTEXT and TYPE_EDITLONG.
	lpszformat As PTSTR						'Format string for TYPE_EDITLONG.
	himl As Integer							'Handle of image list. For the image columns and combobox only.
	hdrflag As Integer						'Header flags.
	colxp As Integer							'Column position. Internally used.
	edthwnd As Integer						'Column control handle. Internally used.
	lParam As Integer							'User defined 32 bit value.
End Type

Type ROWCOLOR
	backcolor As Integer
	textcolor As Integer
End Type

'Notifications
Type GRIDNOTIFY
	nmhdr As NMHDR
	col As Integer								'Column
	row As Integer								'Row
	hwnd As HWND								'Handle of column edit control
	lpdata As Any Ptr							'Pointer to data
	fcancel As Integer						'Set to TRUE to cancel operation
End Type


