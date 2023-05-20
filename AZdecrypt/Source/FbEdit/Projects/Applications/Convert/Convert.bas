''
'' This is a bi to api file converter.
''
'' 1. From command prompt: copy *.bi mybi.bi
''    This creates one file from many files.
'' 2. Use this program to convert mybi.bi to myout.bas
'' 3. Use FbEdit to have a look at the result
'' 4. Use FbEdit to export properties from myout.bas
'' 5. Copy result from output window to an api file.
''
'' Thats all

' option explicit

#include once "windows.bi"
#include once "win/commctrl.bi"
#include once "win/commdlg.bi"

#include "Convert.bi"

declare function DlgProc(byval hWnd as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	DialogBoxParam(GetModuleHandle(NULL),Cast(zstring ptr,1000),NULL,@DlgProc,NULL)
	''
	'' Program has ended
	''

	ExitProcess(0)
	end

'''
''' Program end
'''

Sub Convert(byval sInputFile as string,byval sOutputFile as string)
  Dim sLine As String
  Dim sApi As String
  Dim i As Integer
  Dim iPos As Integer

  Open sInputFile For Input As #1
  Open sOutputFile For Output As #2
  Do While Not EOF(1)
    Line Input #1, sLine
    If LCase(Left(sLine, 8)) = "declare " Then
      sLine=Mid(sLine,9)
    EndIf
    If LCase(Left(sLine, 9)) = "function " Or Left(sLine, 4) = "sub " Then
      iPos = InStr(sLine, """")
      If iPos Then
        i = InStr(iPos + 1, sLine, """")
        If i Then
          sLine = Left(sLine, iPos - 1) & Mid(sLine, i + 1)
        EndIf
      EndIf
      iPos = InStr(LCase(sLine), " alias ")
      If iPos Then
        sLine = Left(sLine, iPos - 1) & Mid(sLine, iPos + 7)
      EndIf
      iPos = InStr(LCase(sLine), " cdecl")
      If iPos Then
        sLine = Left(sLine, iPos - 1) & Mid(sLine, iPos + 6)
      EndIf
      If LCase(Left(sLine, 9)) = "function " Then
        Print #2, sLine
        Print #2, "end function"
      ElseIf LCase(Left(sLine, 4)) = "sub " Then
        Print #2, sLine
        Print #2, "end sub"
      End If
    ElseIf LCase(Left(sLine, 8)) = "#define " Then
      If InStr(sLine,"__") = 0 Then
        Print #2, sLine
      End If
    ElseIf LCase(Left(sLine, 5)) = "type " Then
      if InStr(LCase(sLine)," as ") = 0 Then
        Print #2, sLine
        Do
          Line Input #1, sLine
	       Print #2, sLine
        Loop Until InStr(LCase(sLine),"end type")
      End If
    End If
  Loop
  Close #1
  Close #2

End Sub

function DlgProc(byval hWin as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer
	dim sInp as zstring*260
	dim sOut as zstring*260
	dim ofn as OPENFILENAME

	select case uMsg
		case WM_INITDIALOG
			'
		case WM_CLOSE
			EndDialog(hWin, 0)
			'
		case WM_COMMAND
			if hiword(wParam)=BN_CLICKED then
				select case loword(wParam)
					case IDOK
						GetDlgItemText(hWin,1001,@sInp,260)
						GetDlgItemText(hWin,1003,@sOut,260)
						if lstrlen(sOut)>0 and lstrlen(sInp)>0 then
							Convert(sInp,sOut)
							MessageBox(hWin,"Done!","Convert",MB_OK)
						endif
						'
					case IDCANCEL
						EndDialog(hWin, 0)
						'
					case 1002
						ofn.lStructSize=sizeof(OPENFILENAME)
						ofn.hwndOwner=hWin
						ofn.hInstance=GetModuleHandle(NULL)
						sInp=string(260,0)
						ofn.lpstrFile=@sInp
						ofn.nMaxFile=260
						ofn.lpstrFilter=0
						ofn.lpstrTitle=StrPtr("Input File")
						ofn.Flags=OFN_PATHMUSTEXIST or OFN_HIDEREADONLY or OFN_FILEMUSTEXIST or OFN_EXPLORER
						if GetOpenFileName(@ofn) then
							SetDlgItemText(hWin,1001,@sInp)
						endif
						'
					case 1004
						ofn.lStructSize=sizeof(OPENFILENAME)
						ofn.hwndOwner=hWin
						ofn.hInstance=GetModuleHandle(NULL)
						sOut=string(260,0)
						ofn.lpstrFile=@sOut
						ofn.nMaxFile=260
						ofn.lpstrFilter=0
						ofn.lpstrTitle=StrPtr("Ouput File")
						ofn.Flags=OFN_PATHMUSTEXIST or OFN_HIDEREADONLY or OFN_OVERWRITEPROMPT or OFN_EXPLORER
						if GetSaveFileName(@ofn) then
							SetDlgItemText(hWin,1003,@sOut)
						endif
						'
				end select
			endif
		case else
			return FALSE
			'
	end select
	return TRUE

end function
