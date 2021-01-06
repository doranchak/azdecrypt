Function DlgProc(ByVal hWin As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer
	Dim As Long id, Event

	Select Case uMsg
		Case WM_INITDIALOG
			'
		Case WM_COMMAND
			id=LoWord(wParam)
			Event=HiWord(wParam)
			If Event=BN_CLICKED Then
				Select Case id
					Case IDCANCEL
						EndDialog(hWin, 0)
						'
				End Select
			EndIf
			'
		Case WM_CLOSE
			EndDialog(hWin, 0)
			'
		Case WM_SIZE
			'
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function
