/'

	This app uses a thread to scan your harddrive for *.txt files.
	Files that are found are added to the listbox.
	Double click on a file to open it.

'/

#Include Once "windows.bi"
#Include Once "win/shellapi.bi"

#Include "FindFile.bi"

Sub FindFiles(ByVal sFile As String)
	Dim wfd As WIN32_FIND_DATA
	Dim hwfd As HANDLE
	Dim sPath As String

	' Get path from sFile
	i=InStrRev(sFile,"\")
	If i Then
		sPath=Left(sFile,i)
	EndIf
	' Find *.txt files in current path
	hwfd=FindFirstFile(sFile,@wfd)
	If hwfd<>INVALID_HANDLE_VALUE Then
		While TRUE
			If (wfd.dwFileAttributes And FILE_ATTRIBUTE_DIRECTORY)=0 Then
				' A file is found, is it a *.txt file
				If LCase(Right(wfd.cFileName,4))=szFilter Then
					' Add it to the listbox
					szTmp=sPath & wfd.cFileName
					i=SendDlgItemMessage(hWnd,IDC_LSTFILES,LB_ADDSTRING,0,Cast(LPARAM,@szTmp))
					' Update the count
					SetDlgItemInt(hWnd,IDC_STCFILES,i,FALSE)
				EndIf
			Else
				' A new path is found
				If wfd.cFileName<>"." And wfd.cFileName<>".." Then
					' Call myself to scan this path
					szTmp=sPath & wfd.cFileName & "\*.*"
					FindFiles(szTmp)
				EndIf
			EndIf
			If FindNextFile(hwfd,@wfd)=FALSE Then
				' No more files in this path
				Exit While
			EndIf
		Wend
		' Close the find handle
		FindClose(hwfd)
	EndIf

End Sub

Function ThreadProc(ByVal hWin As HWND) As Integer
	Dim hCtl As HWND
	Dim buff As ZString*MAX_PATH

	' Clear the listbox
	hCtl=GetDlgItem(hWin,IDC_LSTFILES)
	SendMessage(hCtl,LB_RESETCONTENT,0,0)
	' Get path to search
	GetDlgItemText(hWin,IDC_EDTPATH,@buff,SizeOf(buff))
	If Right(buff,1)="\" Then
		buff=buff & "*.*"
	Else
		buff=buff & "\*.*"
	EndIf
	' Get files to find
	GetDlgItemText(hWin,IDC_EDTFILE,@szFilter,SizeOf(szFilter))
	szFilter=Mid(LCase(szFilter),2)
	' Find the files
	FindFiles(buff)
	' Show the [Start] button
	hCtl=GetDlgItem(hWin,IDC_BTNSTOP)
	ShowWindow(hCtl,SW_HIDE)
	hCtl=GetDlgItem(hWin,IDC_BTNSTART)
	ShowWindow(hCtl,SW_SHOW)
	' Close thread handle
	CloseHandle(hThread)
	hThread=0
	' Exit the thread
	Return 0

End Function

Function DlgProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer
	Dim As Integer id,Event,nInx
	Dim hCtl As HWND
	Dim rect As RECT
	Dim buff As ZString*MAX_PATH

	Select Case uMsg
		Case WM_INITDIALOG
			hWnd=hWin
			SendDlgItemMessage(hWin,IDC_EDTPATH,EM_LIMITTEXT,64,0)
			SetDlgItemText(hWin,IDC_EDTPATH,@szDefPath)
			SendDlgItemMessage(hWin,IDC_EDTFILE,EM_LIMITTEXT,16,0)
			SetDlgItemText(hWin,IDC_EDTFILE,@szDefFile)
			'
		Case WM_CLOSE
			EndDialog(hWin, 0)
			'
		Case WM_COMMAND
			id=LoWord(wParam)
			Event=HiWord(wParam)
			Select Case Event
				Case BN_CLICKED
					Select Case id
						Case IDOK
							' End the app
							If hThread Then
								' If the thread is still running, terminate it.
								TerminateThread(hThread,0)
								CloseHandle(hThread)
							EndIf
							EndDialog(hWin, 0)
							'
						Case IDC_BTNSTART
							' Create the thread
							hThread=CreateThread(NULL,NULL,Cast(Any Ptr,@ThreadProc),hWin,NORMAL_PRIORITY_CLASS,@id)
							' Show [Stop] button.
							hCtl=GetDlgItem(hWin,IDC_BTNSTART)
							ShowWindow(hCtl,SW_HIDE)
							hCtl=GetDlgItem(hWin,IDC_BTNSTOP)
							ShowWindow(hCtl,SW_SHOW)
							'
						Case IDC_BTNSTOP
							' Terminate the thread and show [Start] button.
							TerminateThread(hThread,0)
							CloseHandle(hThread)
							hThread=0
							hCtl=GetDlgItem(hWin,IDC_BTNSTOP)
							ShowWindow(hCtl,SW_HIDE)
							hCtl=GetDlgItem(hWin,IDC_BTNSTART)
							ShowWindow(hCtl,SW_SHOW)
							'
					End Select
					'
				Case LBN_DBLCLK
					' Get the filename from the listbox
					nInx=SendDlgItemMessage(hWin,IDC_LSTFILES,LB_GETCURSEL,0,0)
					SendDlgItemMessage(hWin,IDC_LSTFILES,LB_GETTEXT,nInx,Cast(LPARAM,@buff))
					' Open the file in notepad
					ShellExecute(hWin,@szOpen,@buff,NULL,NULL,SW_SHOWNORMAL)
					'
			End Select
		Case WM_SIZE
			' Size and move the controls
			GetClientRect(hWin,@rect)
			hCtl=GetDlgItem(hWin,IDC_EDTPATH)
			MoveWindow(hCtl,0,0,rect.right-100,22,TRUE)
			hCtl=GetDlgItem(hWin,IDC_EDTFILE)
			MoveWindow(hCtl,rect.right-100,0,100,22,TRUE)

			hCtl=GetDlgItem(hWin,IDC_LSTFILES)
			MoveWindow(hCtl,0,25,rect.right,rect.bottom-40-25,TRUE)
			hCtl=GetDlgItem(hWin,IDOK)
			MoveWindow(hCtl,rect.right-100,rect.bottom-35,97,31,TRUE)
			hCtl=GetDlgItem(hWin,IDC_BTNSTART)
			MoveWindow(hCtl,rect.right-200,rect.bottom-35,97,31,TRUE)
			hCtl=GetDlgItem(hWin,IDC_BTNSTOP)
			MoveWindow(hCtl,rect.right-200,rect.bottom-35,97,31,TRUE)
			hCtl=GetDlgItem(hWin,IDC_STCFILES)
			MoveWindow(hCtl,0,rect.bottom-30,75,16,TRUE)
			'
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	hInstance=GetModuleHandle(NULL)
	DialogBoxParam(hInstance,Cast(ZString Ptr,IDD_DLG1),NULL,@DlgProc,NULL)
	''
	'' Program has ended
	''

	ExitProcess(0)
	End

'''
''' Program end
'''
