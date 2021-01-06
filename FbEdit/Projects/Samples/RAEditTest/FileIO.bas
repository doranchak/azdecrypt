
Function StreamIn(ByVal hFile As HANDLE,ByVal pBuffer As ZString Ptr,ByVal NumBytes As Long,ByVal pBytesRead As Long Ptr) As Boolean

	Return ReadFile(hFile,pBuffer,NumBytes,pBytesRead,0) Xor 1

End Function

Function StreamOut(ByVal hFile As HANDLE,ByVal pBuffer As ZString Ptr,ByVal NumBytes As Long,ByVal pBytesWritten As Long Ptr) As Boolean

	Return WriteFile(hFile,pBuffer,NumBytes,pBytesWritten,0) Xor 1

End Function

Sub ReadTheFile(ByVal hWin As HWND,ByVal lpFile As ZString Ptr)
	Dim hFile As HANDLE
	Dim nSize As Integer
	Dim dwRead As Integer
	Dim editstream As EDITSTREAM

	' Open the file
	hFile=CreateFile(lpFile,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0)
	If hFile<>INVALID_HANDLE_VALUE Then
		' Clear current text
		SendMessage(hWin,WM_SETTEXT,0,Cast(Integer,StrPtr("")))
		' Stream in the text
		editstream.dwCookie=Cast(Integer,hFile)
		editstream.pfnCallback=Cast(Any Ptr,@StreamIn)
		SendMessage(hWin,EM_STREAMIN,SF_TEXT,Cast(Integer,@editstream))
		' Close the file
		CloseHandle(hFile)
		' Set modified to FALSE
		SendMessage(hWin,EM_SETMODIFY,FALSE,0)
		' Set comment blocks
		SendMessage(hWin,REM_SETCOMMENTBLOCKS,Cast(WPARAM,StrPtr("/'")),Cast(LPARAM,StrPtr("'/")))
		' Set block bookmarks
		SendMessage(hWin,REM_SETBLOCKS,0,0)
		szFileName=*lpFile
	EndIf

End Sub

Function WriteTheFile(ByVal hWin As HWND,ByVal lpFile As ZString Ptr) As Integer
	Dim editstream As EDITSTREAM
	Dim hFile As HANDLE

	hFile=CreateFile(lpFile,GENERIC_WRITE,FILE_SHARE_READ,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0)
	If hFile<>INVALID_HANDLE_VALUE Then
		editstream.dwCookie=Cast(Integer,hFile)
		editstream.pfnCallback=Cast(Any Ptr,@StreamOut)
		SendMessage(hWin,EM_STREAMOUT,SF_TEXT,Cast(LPARAM,@editstream))
		CloseHandle(hFile)
		SendMessage(hWin,EM_SETMODIFY,FALSE,0)
		Return TRUE
	EndIf
	Return FALSE

End Function

Function OpenAFile(ByVal hWin As HWND) As Integer
	Dim ofn As OPENFILENAME
	Dim buff As ZString*260

	ofn.lStructSize=SizeOf(OPENFILENAME)
	ofn.hwndOwner=hWin
	ofn.hInstance=hInstance
	ofn.lpstrInitialDir=StrPtr("C:\")
	buff=String(260,0)
	ofn.lpstrFile=@buff
	ofn.nMaxFile=260
	ofn.Flags=OFN_PATHMUSTEXIST Or OFN_HIDEREADONLY Or OFN_EXPLORER
	If GetOpenFileName(@ofn) Then
		ReadTheFile(hWin,@buff)
		Return TRUE
	EndIf
	Return FALSE

End Function

Sub SaveAFile(ByVal hWin As HWND,ByVal lpFile As ZString Ptr)
	Dim ofn As OPENFILENAME

	If *lpFile="" Then
		ofn.lStructSize=SizeOf(OPENFILENAME)
		ofn.hwndOwner=hWin
		ofn.hInstance=hInstance
		ofn.lpstrInitialDir=StrPtr("C:\")
		ofn.lpstrFile=StrPtr(szFileName)
		ofn.nMaxFile=260
		ofn.lpstrDefExt=StrPtr("bas")
		ofn.Flags=OFN_EXPLORER Or OFN_HIDEREADONLY Or OFN_PATHMUSTEXIST Or OFN_OVERWRITEPROMPT
		If GetSaveFileName(@ofn) Then
			WriteTheFile(hWin,@szFileName)
		EndIf
	Else
		WriteTheFile(hWin,@szFileName)
	EndIf

End Sub

Function WantToSave(ByVal hWin As HWND) As Integer
	Dim x As Integer
	
	If SendMessage(hWin,EM_GETMODIFY,0,0) Then
		Select Case  MessageBox(hWin,"Want to save changes?",AppName,MB_YESNOCANCEL Or MB_ICONQUESTION)
			Case IDYES
				SaveAFile(hWin,@szFileName)
				'
			Case IDCANCEL
				Return FALSE
				'
		End Select
	EndIf
	Return TRUE

End Function

