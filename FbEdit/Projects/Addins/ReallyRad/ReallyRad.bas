#include once "windows.bi"
#Include Once "win/commctrl.bi"
#Include Once "win/richedit.bi"

#Include "..\..\FbEdit\Inc\Addins.bi"
#Include "..\..\FbEdit\Inc\RAResEd.bi"
#Include "..\..\FbEdit\Inc\RAProperty.bi"
#Include "ReallyRad.bi"
#Include "CreateFile.bas"

#define IDD_DLGREALLYRAD        1000
#define IDC_CBOFILE             1001
#define IDC_CBOTEMPLATE         1002
#define IDC_STCFILE             1003
#define IDC_STCTEMPLATE         1004
#define IDC_STCPROCNAME         1005
#define IDC_EDTPROCNAME         1006
#Define IDC_STCDESCRIPTION      1007

#Define IDD_DLGREALLYRADCTRL    1100
#Define IDC_EDTPROCNAMECTRL     1102

Function JumpToCode() As Boolean
	Dim rapn As RAPNOTIFY

	If Len(szProc) Then
		If SendMessage(lpHandles->hpr,PRM_FINDFIRST,Cast(WPARAM,StrPtr("p")),Cast(LPARAM,@szProc)) Then
			rapn.nid=SendMessage(lpHandles->hpr,PRM_FINDGETOWNER,0,0)
			rapn.nline=SendMessage(lpHandles->hpr,PRM_FINDGETLINE,0,0)
			rapn.nmhdr.hwndFrom=lpHandles->hpr
			rapn.nmhdr.idFrom=1008
			rapn.nmhdr.code=LBN_DBLCLK
			SendMessage(lpHandles->hwnd,WM_NOTIFY,rapn.nmhdr.idFrom,Cast(LPARAM,@rapn))
			Return TRUE
		EndIf
	EndIf
	Return FALSE

End Function

Function ReallyRadProc(ByVal hWin As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer
	Dim As Long id, Event, x, nSel
	Dim buff As ZString*MAX_PATH
	Dim wfd As WIN32_FIND_DATA
	Dim hwfd As HANDLE
	Dim hMem As HGLOBAL
	Dim s As ZString*32768
	Dim f As Integer
	Dim sf As String
	Dim chrg As CHARRANGE

	Select Case uMsg
		Case WM_INITDIALOG
			nSel=0
			x=SendDlgItemMessage(hWin,IDC_CBOFILE,CB_ADDSTRING,0,Cast(LPARAM,@szOutput))
			x=SendDlgItemMessage(hWin,IDC_CBOFILE,CB_SETITEMDATA,x,0)
			id=1
			Do While id<256
				GetPrivateProfileString(StrPtr("File"),Str(id),@szNULL,@buff,SizeOf(buff),@lpData->ProjectFile)
				If Len(buff) Then
					If LCase(Right(buff,4))=".bas" Then
						x=SendDlgItemMessage(hWin,IDC_CBOFILE,CB_ADDSTRING,0,Cast(LPARAM,@buff))
						If lstrcmpi(@buff,@szFile)=0 Then
							nSel=x
						EndIf
						x=SendDlgItemMessage(hWin,IDC_CBOFILE,CB_SETITEMDATA,x,id)
					EndIf
				EndIf
				id+=1
			Loop
			id=1001
			Do While id<1256
				GetPrivateProfileString(StrPtr("File"),Str(id),@szNULL,@buff,SizeOf(buff),@lpData->ProjectFile)
				If Len(buff) Then
					If LCase(Right(buff,4))=".bas" Then
						x=SendDlgItemMessage(hWin,IDC_CBOFILE,CB_ADDSTRING,0,Cast(LPARAM,@buff))
						If lstrcmpi(@buff,@szFile)=0 Then
							nSel=x
						EndIf
						x=SendDlgItemMessage(hWin,IDC_CBOFILE,CB_SETITEMDATA,x,id)
					EndIf
				EndIf
				id+=1
			Loop
			SendDlgItemMessage(hWin,IDC_CBOFILE,CB_SETCURSEL,nSel,0)
			nSel=0
			x=SendDlgItemMessage(hWin,IDC_CBOTEMPLATE,CB_ADDSTRING,0,Cast(LPARAM,@szNone))
			buff=lpData->AppPath & "\Templates\*.rad"
			hwfd=FindFirstFile(@buff,@wfd)
			If hwfd<>INVALID_HANDLE_VALUE Then
				id=1
				While id
					id=SendDlgItemMessage(hWin,IDC_CBOTEMPLATE,CB_ADDSTRING,0,Cast(LPARAM,@wfd.cFileName))
					If lstrcmpi(@szTemplate,@wfd.cFileName)=0 Then
						nSel=id
					EndIf
					id=FindNextFile(hwfd,@wfd)
				Wend
			EndIf
			FindClose(hwfd)
			SendDlgItemMessage(hWin,IDC_CBOTEMPLATE,CB_SETCURSEL,nSel,0)
			If Len(szProc)=0 Then
				szProc=szDefProc
			EndIf
			SetDlgItemText(hWin,IDC_EDTPROCNAME,@szProc)
			SendMessage(hWin,WM_COMMAND,(CBN_SELCHANGE Shl 16) Or IDC_CBOFILE,Cast(WPARAM,GetDlgItem(hWin,IDC_CBOFILE)))
			SendMessage(hWin,WM_COMMAND,(CBN_SELCHANGE Shl 16) Or IDC_CBOTEMPLATE,Cast(WPARAM,GetDlgItem(hWin,IDC_CBOTEMPLATE)))
			'
		Case WM_COMMAND
			id=LoWord(wParam)
			Event=HiWord(wParam)
			Select case Event
				Case BN_CLICKED
					Select Case id
						Case IDCANCEL
							EndDialog(hWin, 0)
							'
						Case IDOK
							GetDlgItemText(hWin,IDC_EDTPROCNAME,szProc,SizeOf(szProc))
							If Len(szTemplate) Then
								buff=lpData->AppPath & "\Templates\" & szTemplate
								hMem=CreateOutputFile(buff)
								If Len(szFile) Then
									' To file
									lstrcpy(@buff,@lpData->ProjectPath)
									buff=buff & "\" & szFile
									lpFunctions->OpenTheFile(buff,FALSE)
									chrg.cpMin=-1
									chrg.cpMax=-1
									SendMessage(lpHandles->hred,EM_EXSETSEL,0,Cast(LPARAM,@chrg))
									SendMessage(lpHandles->hred,EM_SCROLLCARET,0,0)
									SendMessage(lpHandles->hred,EM_REPLACESEL,TRUE,Cast(LPARAM,hMem))
'									lstrcpy(@s,Cast(ZString Ptr,hMem))
'									lpFunctions->TextToOutput(s)
'									lpFunctions->ShowOutput(TRUE)
								Else
									' To output
									lstrcpy(@s,Cast(ZString Ptr,hMem))
									lpFunctions->TextToOutput(s)
									lpFunctions->ShowOutput(TRUE)
								EndIf
								GlobalFree(hMem)
							EndIf
							buff=szTemplate & "," & szFile & "," & szProc
							WritePrivateProfileString(StrPtr("ReallyRad"),@szName,@buff,@lpData->ProjectFile)
							EndDialog(hWin, 0)
							'
					End Select
					'
				Case CBN_SELCHANGE
					If id=IDC_CBOTEMPLATE Then
						id=SendDlgItemMessage(hWin,IDC_CBOTEMPLATE,CB_GETCURSEL,0,0)
						If id Then
							id=SendDlgItemMessage(hWin,IDC_CBOTEMPLATE,CB_GETLBTEXT,id,Cast(LPARAM,@szTemplate))
							f=FreeFile
							Open lpData->AppPath & "\Templates\" & szTemplate For Input As #f
							' Skip description
							Line Input #f,buff
							Close
							SetDlgItemText(hWin,IDC_STCDESCRIPTION,@buff)
						Else
							szTemplate=""
						EndIf
					ElseIf id=IDC_CBOFILE Then
						id=SendDlgItemMessage(hWin,IDC_CBOFILE,CB_GETCURSEL,0,0)
						If id Then
							id=SendDlgItemMessage(hWin,IDC_CBOFILE,CB_GETLBTEXT,id,Cast(LPARAM,@szFile))
						Else
							szFile=""
						EndIf
					EndIf
					'
			End Select
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

Function ReallyRadCtlProc(ByVal hWin As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer
	Dim As Long id, Event
	Dim buff As ZString*MAX_PATH

	Select Case uMsg
		Case WM_INITDIALOG
			SetDlgItemText(hWin,IDC_EDTPROCNAMECTRL,@szProc)
			'
		Case WM_COMMAND
			id=LoWord(wParam)
			Event=HiWord(wParam)
			If Event=BN_CLICKED Then
				Select Case id
					Case IDCANCEL
						EndDialog(hWin, 0)
						'
					Case IDOK
						GetDlgItemText(hWin,IDC_EDTPROCNAMECTRL,szProc,SizeOf(szProc))
						buff=szTemplate & "," & szFile & "," & szProc
						WritePrivateProfileString(StrPtr("ReallyRad"),@szName,@buff,@lpData->ProjectFile)
						JumpToCode
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

' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
function InstallDll CDECL alias "InstallDll" (byval hWin as HWND,byval hInst as HINSTANCE) as ADDINHOOKS ptr EXPORT

	' The dll's instance
	hInstance=hInst
	' Get pointer to ADDINHANDLES
	lpHandles=Cast(ADDINHANDLES ptr,SendMessage(hWin,AIM_GETHANDLES,0,0))
	' Get pointer to ADDINDATA
	lpData=Cast(ADDINDATA ptr,SendMessage(hWin,AIM_GETDATA,0,0))
	' Get pointer to ADDINFUNCTIONS
	lpFunctions=Cast(ADDINFUNCTIONS ptr,SendMessage(hWin,AIM_GETFUNCTIONS,0,0))
	' Messages this addin will hook into
	hooks.hook1=HOOK_CTLDBLCLK
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	return @hooks

end Function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
function DllFunction CDECL alias "DllFunction" (byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool EXPORT
	Dim buff As ZString*MAX_PATH
	Dim As Integer x, id

	select case uMsg
		case AIM_CTLDBLCLK
			lpCTLDBLCLICK=Cast(CTLDBLCLICK Ptr,lParam)
			If lstrlen(lpCTLDBLCLICK->lpDlgName) Then
				lstrcpy(@szName,lpCTLDBLCLICK->lpDlgName)
			Else
				szName=Str(lpCTLDBLCLICK->nDlgId)
			EndIf
			szTemplate=""
			szFile=""
			szProc=""
			GetPrivateProfileString(StrPtr("ReallyRad"),@szName,@szNULL,@buff,SizeOf(buff),@lpData->ProjectFile)
			If Len(buff) Then
				x=InStr(buff,",")
				If x Then
					szTemplate=Left(buff,x-1)
					buff=Mid(buff,x+1)
					x=InStr(buff,",")
					If x Then
						szFile=Left(buff,x-1)
						szProc=Mid(buff,x+1)
					EndIf
				EndIf
			EndIf
			If lstrlen(lpCTLDBLCLICK->lpDlgName) Then
				x=lstrcmp(lpCTLDBLCLICK->lpDlgName,lpCTLDBLCLICK->lpCtlName)
			Else
				x=lpCTLDBLCLICK->nCtlId-lpCTLDBLCLICK->nDlgId
			EndIf
			If x=0 Then
				' Dialog dblclicked
				DialogBoxParam(hInstance,Cast(ZString Ptr,IDD_DLGREALLYRAD),hWin,@ReallyRadProc,lParam)
			Else
				' Control dblclicked
				If JumpToCode Then
					Return FALSE
				EndIf
				DialogBoxParam(hInstance,Cast(ZString Ptr,IDD_DLGREALLYRADCTRL),hWin,@ReallyRadCtlProc,lParam)
			EndIf
			'
		case AIM_CLOSE
			'
	end select
	return FALSE

end function
