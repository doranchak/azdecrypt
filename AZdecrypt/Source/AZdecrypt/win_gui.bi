'===============================================================================
' WinGUI.bi
' A small WinAPI GUI library
' Author: Lothar Schirm
' Created on January 28, 2016 (in German)
' Latest changes on October 27, 2016
'===============================================================================

'updates by Jarlve in function of AZdecrypt

'I thank following FreeBASIC community members for their code contributions:
' - RNBW: ControlSetFont, ComboBox
' - Josep Roca: WaitEvent and WS_TABSTOP style 

#Include Once "windows.bi"

'Required for TrackBar and ProgressBar:
#Include "win/commctrl.bi"
InitCommonControls()

Const Dialog_Box = "#32770"	'System class dialog box	


'-------------------------------------------------------------------------------
'  Window Functions
'-------------------------------------------------------------------------------

Function Window_New(ByRef x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, _
										ByVal Title As String, _
										ByVal Style As ULong = WS_OVERLAPPEDWINDOW Or WS_VISIBLE) As HWND
	'Create a new window. Parameter:
	'- x, y = top left corner
	'- w = width
	'- h = height
	'- Title = Title
	'- Style = See below
	
	'Style:
	'WS_OVERLAPPEDWINDOW Or WS_VISIBLE creates an initial visible overlapped window 
	'with the WS_OVERLAPPED, WS_CAPTION, WS_SYSMENU, WS_THICKFRAME, WS_MINIMIZEBOX, 
	'and WS_MAXIMIZEBOX styles. The size of the window can be changed by by click-dragging
	'from one of the window corners. 
	'Other styles may be used, e.g. WS_OVERLAPPED Or WS_SYSMENU Or WS_VISIBLE in order
	'to create a non-resizable window (see Function InputBox).  

	Return CreateWindowEx(0, Dialog_Box, Title, Style, x, y, w, h, 0, 0, 0, 0)
	
End Function

'Function Window_New2(ByRef x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, _
'										ByVal Title As String, _
'										ByVal Style As ULong) As HWND
'	'Create a new window. Parameter:
'	'- x, y = top left corner
'	'- w = width
'	'- h = height
'	'- Title = Title
'	'- Style = See below
'	
'	'Style:
'	'WS_OVERLAPPEDWINDOW Or WS_VISIBLE creates an initial visible overlapped window 
'	'with the WS_OVERLAPPED, WS_CAPTION, WS_SYSMENU, WS_THICKFRAME, WS_MINIMIZEBOX, 
'	'and WS_MAXIMIZEBOX styles. The size of the window can be changed by by click-dragging
'	'from one of the window corners. 
'	'Other styles may be used, e.g. WS_OVERLAPPED Or WS_SYSMENU Or WS_VISIBLE in order
'	'to create a non-resizable window (see Function InputBox).  
'
'	Return CreateWindowEx(0, Dialog_Box, Title, Style, x, y, w, h, 0, 0, 0, 0)
'	
'End Function

Sub Window_GetSize(ByVal hwnd As HWND, ByRef x_left As Long, ByRef y_top As Long, _
										ByRef x_right As Long, ByRef y_bottom As Long)
	'Retrieves the coordinates of a window's client area. Parameters:
	'- hwnd = Handle of the window
	'- x-left = x-coordinate of the upper-left corner
	'- y_top = y-coordinate of the upper-left corner
	'- x_right = x-coordinate of the lower-right corner
	'- y_bottom = y-coordinate of the lower-right corner
	
	Dim As RECT rect
	
	'Store window size in rect:
	GetClientRect(hwnd, @rect)
	x_left = rect.left
	y_top = rect.top 
	x_right = rect.right
	y_bottom = rect.bottom
	
End Sub

Sub Window_GetPosition(ByVal hwnd As HWND, ByRef x_left As Long, ByRef y_top As Long, _
										ByRef x_right As Long, ByRef y_bottom As Long)
	'Retrieves the coordinates of a window's client area. Parameters:
	'- hwnd = Handle of the window
	'- x-left = x-coordinate of the upper-left corner
	'- y_top = y-coordinate of the upper-left corner
	'- x_right = x-coordinate of the lower-right corner
	'- y_bottom = y-coordinate of the lower-right corner
	
	Dim As RECT rect
	
	'Store window size in rect:
	'GetClientRect(hwnd, @rect)
	GetWindowRect(hwnd, @rect)
	x_left = rect.left
	y_top = rect.top 
	x_right = rect.right
	y_bottom = rect.bottom
	
End Sub

Sub WaitEvent(ByVal hWnd As HWND, ByRef msg As MSG)
	'Wait for an event. Returns a result <> 0 if a Windows message has been received.
	'Parameters:
	'- hWnd = handle of the window
	'- msg = Message
		 
	'Note:
	'-----
	'IsDialogMessage (<> 0) supports the use of keys to change between controls.
	'Each active control in this library has the WS_TABSTOP style as a parameter 
	'"Style" so that the user can change between controls using the TAB key. If this
	'is not desired, the parameter can be set to 0.
	' 
	'Groups of controls can be defined by using the WS_GROUP style. WS_GROUP specifies
	'the first control of a group of controls. The group consists of this first control
	'and all controls defined after it, up to the next control with the WS_GROUP style. 
	'The first control in each group usually has the WS_TABSTOP style so that the user
	'can move from group to group. The user can subsequently change the keyboard focus
	'from one control in the group to the next control in the group by using the direction keys. 	
	
	If GetMessage(@msg, 0, 0, 0) <> 0 Then
		If IsDialogMessage(hWnd, @msg) = 0 Then
			TranslateMessage(@msg )
			DispatchMessage(@msg )
		End If
	End If
		
End Sub


'Function Window_Event_Close(ByVal hWnd As HWND, ByRef msg As MSG) As Long
'	'Returns 1 when the close button (X) of the window has been clicked. Parameters:
'	'- hWnd = handle of the window
'	'- msg = Message (see Sub WaitEvent)
'	
'	If msg.hwnd = hWnd And msg.message = 161 Then
'		If msg.wParam = 20 Then Return 1 Else Return 0
'	End If
'	
'End Function

Function Window_Event_Close(ByVal hWnd As HWND, ByRef msg As MSG) As Long
   'Returns 1 when the close button (X) of the window has been clicked. Parameters:
   '- hWnd = handle of the window
   '- msg = Message (see Sub WaitEvent)
   
   '161: WM_NCLBUTTONDOWN
   '162: WM_NCLBUTTONUP
   '513: WM_LBUTTONDOWN
   '514: WM_LBUTTONUP
   
   'Windows
   If msg.hwnd = hWnd And msg.message = 161 Then
      If msg.wParam = 20 Then Return 1 Else Return 0
   End if
   
   'Fix for WineHQ by Largo
   If msg.hwnd = hWnd And msg.message = 274 Then
      If msg.wParam = 61536 Then Return 1 Else Return 0
   End if
   
End function


'-------------------------------------------------------------------------------
' Controls (General Functions)
'-------------------------------------------------------------------------------

SUB Control_SetFont(ByVal hWndControl As HWND, ByVal Font As String, _
										ByVal h As Long = 16, ByVal w As Long = 8, _
										ByVal wt As Long = 0, ByVal it As Long = False, _
										ByVal ul As Long = False, ByVal so As Long = False)
	'Set font for a control. Parameters:
	'- Control hWnd = Handle to the control
	'- Font = e.g. "Courier New", "Arial", "New Times Roman"
	'- h = Logical height of the font
	'- w = Logical average width of font
	'- wt = Font weight (e.g. FW_THIN, FW_NORMAL, FW_BOLD)
	'- it = Italic: True = yes
	'- ul = Underline: True = yes
	'- so = Strikout: True = yes
      
   DIM As HFONT hFont
   
   hFont = CreateFont(h, w, 0, 0, wt, it, ul, so, ANSI_CHARSET, FALSE, FALSE, _
											DEFAULT_QUALITY, DEFAULT_PITCH Or FF_ROMAN, Font) 
   
   SendMessage(hWndControl, WM_SETFONT, CAST(WPARAM, hfont), True)

END Sub


Sub Control_Resize(ByVal hWndControl As HWND, ByVal x As Long, ByVal y As Long, _
										ByVal w As Long, ByVal h As Long)
	'Resize a control. Parameters:
	'- x, y = top left corner
	'- w = width
	'- h = height
	
	MoveWindow(hWndControl, x, y, w, h, True)
	
End Sub	


'-------------------------------------------------------------------------------
' Button
'-------------------------------------------------------------------------------

Function Button_New(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, _
										ByVal Label As String, ByVal Style As ULong = WS_TABSTOP, _
										ByVal hwnd As HWND) As HWND
	'Create a new button. Parameters:
	'- x, y = top left corner
	'- w = width
	'- h = height
	'- Label = label
	'- Style: See description in Sub WaitEvent
	'- hwnd = handle of the window		
	
	Return CreateWindowEx(0, "BUTTON", Label, Style Or WS_VISIBLE Or WS_CHILD, _
												x, y, w, h, hwnd, 0, 0, 0 )
	
End Function


'-------------------------------------------------------------------------------
' Checkbox
'-------------------------------------------------------------------------------

Function CheckBox_New(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, _
										ByVal Label As String, ByVal Style As Ulong = WS_TABSTOP, _
										ByVal hwnd As HWND) As HWND
	'Create a new checkbox (autocheckbox, the state switches automatically by clicking). 
	'Parameters:
	'- x, y = top left corner
	'- w = width '- h = height
	'- label = label
	'- Style: See description in Sub WaitEvent
	'- hwnd = handle of the window		
	
	Return CreateWindowEx(0, "BUTTON", Label, _
												Style Or WS_VISIBLE Or WS_CHILD Or BS_AUTOCHECKBOX, _
												x, y, w, h,	hWnd, 0, 0, 0 )
												
End Function


Sub CheckBox_SetCheck(ByVal hWndCheck As HWND, ByVal CheckState As Long)
	'Set check status of the checkbox. Parameters:
	'- hWndCheck = Handle of the checkbox
	'- CheckState: <> 0 = checked, 0 = unchecked
    
  If CheckState Then SendMessage(hWndCheck, BM_SETCHECK, BST_CHECKED, 0) Else _
    SendMessage(hWndCheck, BM_SETCHECK, BST_UNCHECKED, 0)
       
End Sub


Function CheckBox_GetCheck(ByVal hWndCheck As HWND ) As Long
	'Request the status of the checkbox. 0 = unchecked, 1 = checked. Parameters:
	'- hWndCheck = handle of the checkbox
	
	If SendMessage(hWndCheck, BM_GETCHECK, 0, 0) = BST_CHECKED Then Return 1 _
		Else Return 0
       
End Function


'-------------------------------------------------------------------------------
' Radiobutton
'-------------------------------------------------------------------------------

Function RadioButton_New(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, _
										ByVal Label As String, ByVal Style As Long = WS_TABSTOP, _
										ByVal hwnd As HWND) As HWND
	'New radio button (if a radio button is clicked, its state will be
	'automatically set to "checked" and the states of the others in the group
	'will be set to "unchecked". Parameters:
	'- x, y = top left corner
	'- w = width
	'- h = height
	'- label = label
	'- Style: See description in Sub WaitEvent. WS_GROUP must be used for the 
	'  first radio button of a group
	'- hwnd = handle of the window
		
	Return CreateWindowEx(0, "BUTTON", Label, _
												Style Or WS_VISIBLE Or WS_CHILD Or BS_AUTORADIOBUTTON, _
												x, y, w, h,	hWnd, 0, 0, 0 )
												
End Function


Sub RadioButton_SetCheck(ByVal hWndRadio As HWND, ByVal CheckState As Long)
	'Set the state of a radio button. Parameters:
	'- hWndRadio = handle of the radio buttons
	'- CheckState: <> 0 = checked, 0 = unchecked  
    
  If CheckState Then SendMessage(hWndRadio, BM_SETCHECK, BST_CHECKED, 0) Else _
    SendMessage(hWndRadio, BM_SETCHECK, BST_UNCHECKED, 0)
       
End Sub


Function RadioButton_GetCheck(ByVal hWndRadio As HWND ) As Long
	'Request the state of the radio buttons. 0 = unchecked, 1 = checked. Parameters:
	'- hWndRadio = handle of the radio buttons
	
	If SendMessage(hWndRadio, BM_GETCHECK, 0, 0) = BST_CHECKED Then Return 1 _
		Else Return 0
       
End Function

'-------------------------------------------------------------------------------
' Group Box
'-------------------------------------------------------------------------------

Function GroupBox_New(ByVal x As Long, ByVal y As Long, ByVal w As Long, _
											ByVal h As Long, ByVal Label As String, ByVal hwnd As HWND) As HWND
	'Create a new group box. Parameters:
	'- x, y = top left corner
	'- w = width
	'- h = height
	'- Label = label
	'- hwnd = handle of the window
	
	Return CreateWindowEx(0, "BUTTON", Label, _
											WS_VISIBLE Or WS_CHILD Or BS_GROUPBOX, _
											x, y, w, h, hwnd, 0, 0, 0 )
	
End Function
										

'-------------------------------------------------------------------------------
' Label (Static Text)
'-------------------------------------------------------------------------------

Function Label_New(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, _
										ByVal text As String, ByVal Style As ULong = 0, ByVal hwnd As HWND) As HWND
 'Create a new Label (= static text). Parameters:
 '- x, y = top left corner
 '- w = width
 '- h = height
 '- text = Text
 '- Style = WS_BORDER, SS_LEFT, SS_CENTER, SS_RIGHT 
 '  (different styles can be connected by "Or")
 '- hwnd = handle of the window	
	
	Return CreateWindowEx(0, "STATIC", Text, Style Or WS_VISIBLE Or WS_CHILD, x, y, w, h, _
											hWnd, 0, 0, 0 )
												
End Function


Sub Label_SetText(ByVal hWndLabel As HWND, ByVal Text As String)
	'Set text of a label. Parameters:
	'- hWndLabel = Handle of the label
	'- Text = text
    
  SetWindowText(hWndLabel, Text)
	
End Sub


'-------------------------------------------------------------------------------
' EditBox, Text Editor
'-------------------------------------------------------------------------------

function EditBox_New(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, _
										byval Text As String, ByVal Style As ULong = WS_TABSTOP, ByVal hwnd As HWND) _
										As HWND
	
	'Create a new Editbox (single line). Parameters:
	'- x, y = top left corner
	'- w = width
	'- h = height
	'- text = Text
	'- Style: See description in Sub WaitEvent and below
	'- hwnd = handle of the window

	'Style:
	'- ES_LEFT, ES_CENTER or ES_RIGHT
	'- ES_LOWERCASE or ES_UPPERCASE
	'- ES_NUMBER
	'- ES_PASSWORD
	'- ES_READONLY
	'(different styles can be connected by "Or")	
	
	'Return CreateWindowEx(0, "EDIT", Text, _
	'				Style Or WS_VISIBLE Or WS_CHILD OR ES_AUTOHSCROLL, _
	'				x, y, w, h, hWnd, 0, 0, 0 )
	
	Return CreateWindowEx(0, "EDIT", Text, _
                      Style Or WS_BORDER Or WS_VISIBLE Or WS_CHILD OR ES_AUTOHSCROLL, _
                      x, y, w, h, hWnd, 0, 0, 0 )
    	
End Function

	
Function Editor_New(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, _
										ByVal Text As String, ByVal Style As ULong = WS_TABSTOP, ByVal hwnd As HWND) _
										As HWND
	'Create a new Text Editor (multiline EditBox). Parameters:
	'- x, y = top left corner
	'- h = width
	'- h = height
	'- Text = Text
	'- Style: See Sub WaitEvent, ES_READONLY
	'- hwnd = handle of the window
	
	Return CreateWindowEx(0, "EDIT", Text, _
											Style Or WS_BORDER Or WS_VISIBLE Or WS_CHILD Or WS_HSCROLL _
											Or WS_VSCROLL Or ES_MULTILINE  Or ES_WANTRETURN, _
											x, y, w, h, hwnd, 0, 0, 0 )	
	                        
End Function


Sub EditBox_SetText(ByVal hWndEdit As HWND, ByVal Text As String)
	'Set text into an editbox or an editor. Parameters:
	'- hWndEdit = handle of the edit box
	'- Text = text	
    
  SetWindowText(hWndEdit, Text)

End Sub


Function EditBox_GetText(ByVal hWndEdit As HWND) As String
	'Returns the text from an editbox or an editor. Parameter:
	'- hWndEdit = handle of the edit box
    
	Dim BufferSize As Long
	Dim Buffer As String
	
	BufferSize = GetWindowTextLength(hWndEdit)
	Buffer = Space(BufferSize)
	GetWindowText(hWndEdit, Buffer, BufferSize + 1)  
		 
	Return RTrim(Buffer, Chr(0))
         
End Function


Sub EditBox_Clear(ByVal hWndEdit As HWND)
	'Delets the current selection in an editbox or an editor. It does not
	'place the deleted text in the clipboard. Parameter:
	'- hWndEdit = handle of the editbox
    
	SendMessage(hWndEdit, WM_CLEAR, 0, 0)
    
End Sub


Sub EditBox_Cut(ByVal hWndEdit As HWND)
	'Cuts the current selection in an editbox or editor  and places it in the
	'clipboard. Parameter:
	'- hWndEdit = Handle of the editbox
  SendMessage(hWndEdit, WM_CUT, 0, 0)
    
End Sub


Sub EditBox_Copy(ByVal hWndEdit As HWND)
	'Copy the current selection in an editbox or editor and places it in the
	'clipboard. Parameters:
	'- hWndEdit = Handle of the editbox
	
	SendMessage(hWndEdit, WM_COPY, 0, 0)
    
End Sub


Sub EditBox_Paste(ByVal hWndEdit As HWND)
	'Pastes the current clipboard contents. Parameter:
	'- hWndEdit = Handle of the editbox

	SendMessage(hWndEdit, WM_PASTE, 0, 0)
    
End Sub


Sub EditBox_Undo(ByVal hWndEdit As HWND)
	'Undo the last operation. When this message is sent to an editbox or an editor,
	'the previously deleted text is restored or the previously added text is deleted.
	'Parameter:
	'- hWndEdit = handle of the editbox
	
	SendMessage(hWndEdit, WM_UNDO, 0, 0)
	
End Sub 		


Function EditBox_GetLineCount(ByVal hWndEdit As HWND) As Long
'Returns the number of lines in an editor. If no text exists then the return value is 1.
'Parameters:
'- hWndEdit: Handle of the editor

	Return SendMessage(hWndEdit, EM_GETLINECOUNT, 0, 0)
    
End Function


Function EditBox_GetLine(ByVal hWndEdit As HWND, ByVal LineNumber As Integer) As String
'Gets a line of text from an editor. Parameters: 
'- hWndEdit: Handle of editor
'- LineNumber: The zero-based index of the line to retrieve.
    
	Dim BufferSize As Long
	Dim Buffer As String
	
	'Get the length of the text:
	BufferSize = SendMessage(hWndEdit, EM_LINELENGTH, LineNumber, 0)
	If BufferSize = 0 Then Return ""
	
	'Load the text into the buffer:
	Buffer = Space(BufferSize + 1)
	SendMessage hWndEdit, EM_GETLINE, LineNumber, Cast(LPARAM, Strptr(Buffer))
	
	Return RTrim(Buffer, Chr(0))
         
End Function


'-------------------------------------------------------------------------------
' ListBox
'-------------------------------------------------------------------------------

Function ListBox_New(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, _
										ByVal Style As Ulong = WS_TABSTOP, ByVal hwnd As HWND) As HWND
	'Create a new listbox. Parameters:
	'- x, y = top left corner
	'- w = width
	'- h = height
	'- Style: See decription in Sub WaitEvent
	'- hwnd = handle of the window	
	
	Return CreateWindowEx(0, "LISTBOX", "", Style Or WS_BORDER Or WS_VISIBLE Or WS_CHILD Or _
												WS_HSCROLL Or WS_VSCROLL, x, y, w, h, hWnd, _
												0, 0, 0 )
																							
End Function


Sub ListBox_AddString(ByVal hWndList As HWND, ByVal Text As String) _
	'Add a line of text. Parameters:
	'- hWndList = Handle of the listbox
	'- Text = text to add	
	
	If text = "" Then Exit Sub
  SendMessage(hWndList, LB_ADDSTRING, 0, Cast(LPARAM, StrPtr(Text)))
    
End Sub


Sub Listbox_DeleteString(ByVal hWndList As HWND, ByVal Index As Long)
	'Delete string. Parameters:
	'- hWndList = handle of the listbox
	'- Index = index (starting from 0)	
    
  SendMessage(hWndList, LB_DELETESTRING, Index, 0)
    
End Sub


Sub  ListBox_InsertString(ByVal hWndList As HWND, ByVal Index As Long, ByVal Text As String)
	'Insert string. Parameters:
	'- hWndList = handle of the listbox
	'- Index = index (starting from 0). Index = -1: String is added at the end of 
	'  the list (equivalent to ListBox_AddString)
	'- Text = Text to be inserted
	
	If text = "" Then Exit Sub
	SendMessage(hWndList, LB_INSERTSTRING, Index, Cast(LPARAM, StrPtr(Text)))
    
End Sub


Sub ListBox_ReplaceString(ByVal hWndList As HWND, ByVal Index As Long, ByVal Text As String, _
                          ByVal NewData As Long = 0)	
	'Replace a string by another. Parameters:
	'- hWndList = Handle of the listbox
	'- Index = Index of the string to be replaced
	'- Text = new Text
	'- New Data = 32-bit value associated with the list box item 
	 
	 If text = "" Then Exit Sub 
   SendMessage(hWndList, LB_DELETESTRING, Index, 0)
   Index = SendMessage(hWndList, LB_INSERTSTRING, Index, Cast(LPARAM, Strptr(Text)))
   SendMessage(hWndList, LB_SETITEMDATA, Index, NewData)
        
End Sub                


Function ListBox_GetCount(ByVal hWndList As HWND ) As Long
	'Returns the number of entries in the listbox. The returned count is one greater 
	'than the index value of the last item (the index is zero-based).
	'Parameters:
	'- hWndList = Handle of the listbox	
    
  Return SendMessage(hWndList, LB_GETCOUNT, 0, 0)
    
End Function


Sub ListBox_ResetContent(ByVal hWndList As HWND)
	'Delete the contents of the listbox. Parameters:
	'- hWndList = Handle is the listbox	
    
  SendMessage(hWndList, LB_RESETCONTENT, 0, 0)
    
End Sub


Sub ListBox_SetCurSel(ByVal hWndList As HWND, ByVal Index As Long)
	'Set selection in the listbox. Parameters:
	'-hWndList = Handle of the listbox
	'- Index = index (starting from 0)
  	
  SendMessage(hWndList, LB_SETCURSEL, Index, 0)

End Sub            


Function ListBox_GetCurSel(ByVal hWndList As HWND ) As Long
	'Returns the selected index (index starts from 0). Parameters:
	'-hWndList = Handle of the listbox
  
  Return SendMessage(hWndList, LB_GETCURSEL, 0, 0)
    
End Function


Function ListBox_GetText(ByVal hWndList As HWND, ByVal Index As Long) As String
	'Returns the text corresponding to the index. Parameters:
	'-hWndList = handle of the listbox
	' - Index = hndex  	

	Dim BufferSize As Long
	Dim Buffer As String
	
	'Examine text length:
	BufferSize = SendMessage(hWndList, LB_GETTEXTLEN, Index, 0)
	Buffer = Space(BufferSize + 1)

	'Load text into the buffer:
	If SendMessage(hWndList, LB_GETTEXT, Index, Cast(LPARAM, StrPtr(Buffer))) = LB_ERR Then
		Return ""
	Else
		Return RTrim(Buffer, Chr(0))
	End If      
			
End Function


'-------------------------------------------------------------------------------
' ComboBox
'-------------------------------------------------------------------------------

Function ComboBox_New(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, _
											ByVal Style As Ulong = WS_TABSTOP, ByVal hwnd As HWND) As HWND
	'New Combo box. Parameters:
	'- x, y = top left corner
	'- w = width
	'- h = height
	'- Label = label
	'- Style: See description in Sub WaitEvent
	'- hwnd = handle of the window
	'Note: Combo box without vertical scrollbar, items can be scrolled with keys up/down!
	
	Return CreateWindow("COMBOBOX", "", Style Or WS_BORDER Or WS_VISIBLE Or WS_CHILD Or _
											CBS_DROPDOWNLIST, x, y, w, h, hWnd, 0, 0, 0 )	
																						
End Function


Sub ComboBox_AddString(ByVal hWndCombo As HWND, ByVal Text As String)
	'Add a line of text. Parameters:
	'- hWndCombo = handle of combo box
	'- Text = text
  
  If text = "" Then Exit Sub  
  SendMessage(hWndCombo, CB_ADDSTRING, 0, Cast(LPARAM, StrPtr(Text)) )
     
End Sub


Sub ComboBox_DeleteString(ByVal hWndCombo As HWND, ByVal Index As Long)
	'Delete string. Parameters:
	'- hWndCombo = handle of the ComboBox
	'- Index = index (starting from 0)   
  
	SendMessage(hWndCombo, CB_DELETESTRING, Index, 0)
   
End Sub

'-------------------------------------------------------------------------------

Sub  ComboBox_InsertString(ByVal hWndCombo As HWND, ByVal Index As Long, ByVal Text As String)
   'Insert string. Parameters:
   '- hWndCombo = handle of the ComboBox
   '- Index = index (starting from 0). Index = -1: String is added at the end of
   '  the list (equivalent to ComboBox_AddString)
   '- Text = Text to be inserted
   
   If text = "" Then Exit Sub
   SendMessage(hWndCombo, CB_INSERTSTRING, Index, Cast(LPARAM, Strptr(Text)))
   
End Sub

'-------------------------------------------------------------------------------

Sub ComboBox_ReplaceString(ByVal hWndCombo As HWND, ByVal Index As Long, ByVal Text As String, _
   ByVal NewData As Long = 0)   
   'Replace a string by another. Parameters:
   '- hWndCombo = Handle of the ComboBox
   '- Index = Index of the string to be replaced
   '- Text = new Text
   '- New Data = 32-bit value associated with the combo box item
   
   If text = "" Then Exit Sub  
   SendMessage(hWndCombo, CB_DELETESTRING, Index, 0)
   Index = SendMessage(hWndCombo, CB_INSERTSTRING, Index, Cast(LPARAM, Strptr(Text)))
   SendMessage(hWndCombo, CB_SETITEMDATA, Index, NewData)
   
End Sub

'-------------------------------------------------------------------------------

Function ComboBox_GetCount(ByVal hWndCombo As HWND ) As Long
   'Returns the number of entries in the ComboBox. The returned count is one greater
   'than the index value of the last item (the index is zero-based).
   'Parameters:
   '- hWndCombo = Handle of the ComboBox   
   
   Return SendMessage(hWndCombo, CB_GETCOUNT, 0, 0)
   
End Function

'-----------------------------------------------------------------------------

Sub ComboBox_ResetContent(ByVal hWndCombo As HWND)
   'Delete the contents of the ComboBox. Parameters:
   '- hWndCombo = Handle is the ComboBox   
   
   SendMessage(hWndCombo, CB_RESETCONTENT, 0, 0)
   
End Sub


Sub ComboBox_SetCurSel(ByVal hWndCombo As HWND, ByVal Index As Long)
	'Set the current selection of the combo box. Parameters:
  '- hWndCombo = handle of combo box 
  '- Index = index (beginning from 0)
  
  SendMessage(hWndCombo, CB_SETCURSEL, Index, 0)
  	
End Sub
    

Function ComboBox_GetCurSel(ByVal hWndCombo As HWND ) As Long
  'Returns the selected index (beginning from 0. Parameters:
  '-hWndCombo = handle of combo box
  	
  Return SendMessage(hWndCombo, CB_GETCURSEL, 0, 0)
     
End Function


Function ComboBox_GetText(ByVal hWndCombo As HWND, ByVal Index As Long) As String
	'Returns the text corresponding to the index. Parameters:
	'- hWndCombo = handle of the combo box
	'- Index = hndex
  
  Dim BufferSize As Long
  Dim Buffer As String
    
	'examine text length:
	BufferSize = SendMessage(hWndCombo, CB_GETLBTEXTLEN, Index, 0)
 	Buffer = Space(BufferSize + 1)
 	
 	'load text into the buffer:
 	If SendMessage(hWndCombo, CB_GETLBTEXT, Index, Cast(LPARAM, StrPtr(Buffer))) = CB_ERR Then
 		Return ""
 	Else
 		Return RTrim(Buffer, Chr(0))
 	End If 
 	                      
End Function            


'-------------------------------------------------------------------------------
' Trackbar
'-------------------------------------------------------------------------------

Function TrackBar_New(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, _
											ByVal Style As ULong = WS_TABSTOP Or TBS_HORZ, ByVal hwnd As HWND) As HWND
	'Create a new trackbar. Parameter:
	'- x, y = top left corner
	'- w = width
	'- h = height
	'- Style: See below
	'- hwnd = handle of the window
	
	'Styles:
	'WS_TABSTOP: See description in Sub WaitEvent
	'TBS_HORZ or TBS_VERT: horizontal or vertical trackbar
   	
	Return CreateWindowEx( 0, TRACKBAR_CLASS, "", _
				Style Or WS_VISIBLE Or WS_CHILD Or TBS_ENABLESELRANGE, _
				x, y, w, h, hWnd, 0, 0, 0 )
				
End Function


Sub TrackBar_SetRange(ByVal hWndTrack As HWND, ByVal RangeMin As Long, ByVal RangeMax As Long)
	'Set range of the track bar. Parameters:
	'- hWnd = handle of the track bar
	'- RangeMin, RangeMax = Range
	
	SendMessage(hWndTrack, TBM_SETRANGEMIN, 0, RangeMin)
	SendMessage(hWndTrack, TBM_SETRANGEMAX, 0, RangeMax)
	
End Sub


Function TrackBar_GetPos(ByVal hWndTrack As HWND) As Long
	'Returns the position of the track bar. Parameter:
	'- hWndTrack = handle of the track bar

	Return SendMessage(hWndTrack, TBM_GETPOS, 0, 0 )
	
End Function


Sub TrackBar_SetPos(ByVal hWndTrack As HWND, ByVal NewPos As Long)
   'Set the position of the trackbar. Parameters:
   '- hWndTrack = handle of the track bar
   '- NewPos = new position

	SendMessage(hWndTrack, TBM_SETPOS, TRUE, NewPos)
	
End Sub


'-------------------------------------------------------------------------------
' Progressbar
'-------------------------------------------------------------------------------
		

Function ProgressBar_New(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, _
													ByVal hWnd As HWND) As HWND
	'Create new Progressbar. Parameter:
	'- x, y = top left corner
	'- w = width
	'- h = height
	'- hwnd = handle of the window	
	
	Return CreateWindowEx(0, PROGRESS_CLASS, "", WS_VISIBLE Or WS_CHILD, _
												x, y, w, h, hWnd, 0, 0, 0)
												
End Function


Sub ProgressBar_SetRange(ByVal hWndProg As HWND, ByVal RangeMin As Long, ByVal RangeMax As Long)
	'Set range of a progress bars. Parameters:
	'- hWndProgessbar = handle of the progress bar
	'- RangeMin, RangeMax = Range
	
	SendMessage(hWndProg, PBM_SETRANGE, 0, MAKELPARAM(RangeMin, RangeMax))
	
End Sub


Sub ProgressBar_SetPos(ByVal hWndProg As HWND, ByVal NewPos As Long)
  'Set the position of a progress bar. Parameter:
   '- hWndProgessbar = handle of the progress bar
   '- NewPos = new position
	
	SendMessage(hWndProg, PBM_SETPOS, NewPos, 0)
	
End Sub


'-------------------------------------------------------------------------------
' InputBox
'-------------------------------------------------------------------------------

Function InputBox(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal Titel As String,_
									ByVal Prompt As String, ByVal Text As String = "", _
									ByVal Style As ULong = WS_TABSTOP) As String
	'Create an Inputbox. Parameters:
	'- x, y = top left corner
	'- w = width
	'- Title = title
	'- Prompt = question
	'- Text = predefined text
	'- Style: see EditBox_New
	'Returns the text entered by the user
	
	Dim As HWND hWndInput, Label_Prompt, Edit_Text, Button_Ok
	Dim As MSG msg
	Dim As String s
		
	hWndInput = CreateWindowEx(0, Dialog_Box, Titel, _
															WS_OVERLAPPED Or WS_SYSMENU Or WS_VISIBLE Or WS_EX_TOPMOST, _
															x, y, w, 140, 0, 0, 0, 0)
	Label_Prompt = Label_New(10, 10, w - 20, 20, Prompt,, hWndInput)
	Edit_Text = EditBox_New(10, 40, w - 40, 20, Text, Style, hWndInput)
	Button_Ok = Button_New(w / 2 - 30, 70, 60, 20, "Ok",, hWndInput)
	
	Do
		WaitEvent(hWndInput, msg)
		If msg.hwnd = Button_Ok And msg.message = WM_LBUTTONDOWN Then
			s = EditBox_GetText(Edit_Text)
			Exit Do
		End If
	Loop
	
	DestroyWindow(hWndInput)
	Return s
	
End Function


'-------------------------------------------------------------------------------
' Menu
'-------------------------------------------------------------------------------

'Method how to create a menu:
'- Create handle of the menu and all handles of the menu items by CreateMenu()
'- Create all menu titles (Sub MenuTitle(), see below)
'- Create all menu items (Sub MenuItem(), see below)
'- Assign menu to the window by SetMenu() 
 
Sub MenuTitle(ByVal hMenu As HMENU, ByVal hMenuTitle As HMENU, ByVal Title As String)
   'Menu heading. Parameters:
   '- hMenu = handle of the menu
   '- hMenuTitle = handle of the relevant menu item (for example, hFile)
   '- Title = title of the menu item (for example, "File")
  
  InsertMenu(hMenu, 0, MF_POPUP, CInt(hMenuTitle), Title)
  
End Sub


Sub MenuItem(ByVal hMenuTitle As HMENU, ByVal MenuItemNumber As Long, ByVal MenuItemName As String)
   'Menu item (entry into a menu). Parameters:
   '- hMenuTitle = handle of the parent menu item (see Sub MenuTitle, e.g. hFile)
   '- MenuItemNumber = number of the entry
   '- MenuItemName = name of the entry (eg "open")
  
  AppendMenu(hMenuTitle, 0, MenuItemNumber, MenuItemName)
  
End Sub


