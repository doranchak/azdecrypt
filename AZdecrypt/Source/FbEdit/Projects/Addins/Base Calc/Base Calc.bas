#include once "windows.bi"
#include once "win/commctrl.bi"
#Include Once "win/commdlg.bi"

#include once "..\..\FbEdit\Inc\Addins.bi"

#include "Base Calc.bi"

Declare Function DlgProc(ByVal hWnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer
Declare Function HexSubclassProc( Byval hWnd As HWND, Byval uMsg As UINT, Byval wParam As WPARAM, Byval lParam As LPARAM ) As Integer

' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
Function InstallDll CDECL alias "InstallDll" (byval hWin as HWND,byval hInst as HINSTANCE) as ADDINHOOKS ptr EXPORT
	Dim mii As MENUITEMINFO

	' The dll's instance
	hInstance=hInst
	' Get pointer to ADDINHANDLES
	lpHandles=Cast(ADDINHANDLES ptr,SendMessage(hWin,AIM_GETHANDLES,0,0))
	' Get pointer to ADDINDATA
	lpData=Cast(ADDINDATA ptr,SendMessage(hWin,AIM_GETDATA,0,0))
	' Get pointer to ADDINFUNCTIONS
	lpFunctions=Cast(ADDINFUNCTIONS ptr,SendMessage(hWin,AIM_GETFUNCTIONS,0,0))
	
	
	' Get handle to 'Tools' popup
	mii.cbSize=SizeOf(MENUITEMINFO)
	mii.fMask=MIIM_SUBMENU
	GetMenuItemInfo(lpHANDLES->hmenu,10151,FALSE,@mii)
	' Add our menu item to Tools menu
	IDM_BASECALC=SendMessage(hWin,AIM_GETMENUID,0,0)
	AppendMenu(mii.hSubMenu,MF_STRING,IDM_BASECALC,StrPtr("Base Calc"))	
	' Messages this addin will hook into
	hooks.hook1=HOOK_COMMAND
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	return @hooks

end function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
function DllFunction CDECL alias "DllFunction" (byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool EXPORT

	select case uMsg
		case AIM_COMMAND
			if loword(wParam)=IDM_BASECALC then
				DialogBoxParam(hInstance,Cast(zstring ptr,FORMCALC),hWin,@DlgProc,NULL)
			EndIf
		case AIM_CLOSE
			'
	end select
	return FALSE

end Function

Function HexSubclassProc( Byval hWnd As HWND, Byval uMsg As UINT, Byval wParam As WPARAM, Byval lParam As LPARAM ) As Integer
	Select Case uMsg
		Case WM_CHAR
			Select Case wParam
				
				'' Pass the WM_CHAR message to the original control (window)
				'' procedure only if the character code is in the allowable
				'' set. The character code for backspace is included so the
				'' key will function normally.
				Case &h30 To &h39, &h41 To &h46, &h61 To &h66, 8
					Return CallWindowProc( HexProc, hWnd, uMsg, wParam, lParam )
			End Select
		Case WM_PASTE
			'' This effectively disables the WM_PASTE message, preventing
			'' the user from pasting non-allowable characters.
		Case Else
			'' Pass any other messages to the original control procedure.
			Return CallWindowProc( HexProc, hWnd, uMsg, wParam, lParam )
	End Select
	Return 0
End Function

Function OctSubclassProc( Byval hWnd As HWND, Byval uMsg As UINT, Byval wParam As WPARAM, Byval lParam As LPARAM ) As Integer
	Select Case uMsg
		Case WM_CHAR
			Select Case wParam
				
				'' Pass the WM_CHAR message to the original control (window)
				'' procedure only if the character code is in the allowable
				'' set. The character code for backspace is included so the
				'' key will function normally.
				Case &h30 To &h37, 8
					Return CallWindowProc( OctProc, hWnd, uMsg, wParam, lParam )
			End Select
		Case WM_PASTE
			'' This effectively disables the WM_PASTE message, preventing
			'' the user from pasting non-allowable characters.
		Case Else
			'' Pass any other messages to the original control procedure.
			Return CallWindowProc( OctProc, hWnd, uMsg, wParam, lParam )
	End Select
	Return 0
End Function

Function BinSubclassProc( Byval hWnd As HWND, Byval uMsg As UINT, Byval wParam As WPARAM, Byval lParam As LPARAM ) As Integer
	Select Case uMsg
		Case WM_CHAR
			Select Case wParam
				
				'' Pass the WM_CHAR message to the original control (window)
				'' procedure only if the character code is in the allowable
				'' set. The character code for backspace is included so the
				'' key will function normally.
				Case &h30, &h31, 8
					Return CallWindowProc( BinProc, hWnd, uMsg, wParam, lParam )
			End Select
		Case WM_PASTE
			'' This effectively disables the WM_PASTE message, preventing
			'' the user from pasting non-allowable characters.
		Case Else
			'' Pass any other messages to the original control procedure.
			Return CallWindowProc( BinProc, hWnd, uMsg, wParam, lParam )
	End Select
	Return 0
End Function

Function DlgProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As integer
	Dim As long id, Event, x, y
	Dim stringHex As zString * 260 
	Dim stringBin As zString * 260 
	Dim stringDec As zString * 260 
	Dim stringOct As ZString * 260
	Dim hexHnd As HWND
	Dim decHnd As HWND
	Dim binHnd As HWND
	Dim octHnd As HWND
	
	
	Select Case uMsg
		Case WM_INITDIALOG
			stringHex = "0"
			stringDec = "0"
			stringBin = "00000000"
			stringOct = "0"
			SetDlgItemText(hWin,IDC_HEX,@stringHex)
			SetDlgItemText(hWin,IDC_DEC,@stringDec)
			SetDlgItemText(hWin,IDC_BIN,@stringBin)
			SetDlgItemText(hWin,IDC_OCT,@stringOct)
			hexHnd = GetDlgItem(hWin,IDC_HEX)
			SendMessage(hexHnd,EM_SETLIMITTEXT,2,0)
			decHnd = GetDlgItem(hWin,IDC_DEC)
			SendMessage(decHnd,EM_SETLIMITTEXT,3,0)
			binHnd = GetDlgItem(hWin,IDC_BIN)
			SendMessage(binHnd,EM_SETLIMITTEXT,8,0)
			octHnd = GetDlgItem(hWin,IDC_OCT)
			SendMessage(octHnd,EM_SETLIMITTEXT,3,0)
			hasChanged(0) = 1
			hasChanged(1) = 1
			hasChanged(2) = 1
			hasChanged(3) = 1
			HexProc = cast(WNDPROC,SetWindowLong( hexHnd, GWL_WNDPROC, cast(Long,@HexSubclassProc)))
			OctProc = cast(WNDPROC,SetWindowLong( octHnd, GWL_WNDPROC, cast(Long,@OctSubclassProc)))
			BinProc = cast(WNDPROC,SetWindowLong( binHnd, GWL_WNDPROC, cast(Long,@BinSubclassProc)))
		Case WM_CLOSE
			EndDialog(hWin, 0)
			'
		Case WM_COMMAND
			id=LoWord(wParam)
			Event=HiWord(wParam)
			Select Case id
				Case IDC_HEX
					If Event = EN_CHANGE Then
						If hasChanged(0) = 0  Then
							GetDlgItemText(hWin,IDC_HEX,@stringHex,260)
							stringDec = Str(Val("&h" & stringHex))
							stringBin = Bin(Val("&h" & stringHex),8)
							stringOct = Oct(Val("&h" & stringHex))
							SetDlgItemText(hWin,IDC_DEC,@stringDec)
							SetDlgItemText(hWin,IDC_BIN,@stringBin)
							SetDlgItemText(hWin,IDC_OCT,@stringOct)
							hasChanged(1) = 1
							hasChanged(2) = 1
							hasChanged(3) = 1
						Else
							hasChanged(0) = 0
						EndIf
					ElseIf Event = EN_KILLFOCUS Then
						GetDlgItemText(hWin,IDC_DEC,@stringDec,260)
						stringHex = Hex(Val(stringDec))
						SetDlgItemText(hWin,IDC_HEX,@stringHex)
						hasChanged(0) = 1
					EndIf
				Case IDC_DEC
					If Event = EN_CHANGE Then
						If hasChanged(1) = 0  Then
							GetDlgItemText(hWin,IDC_DEC,@stringDec,260)
							stringHex = Hex(Val(stringDec))
							stringBin = Bin(Val(stringDec),8)
							stringOct = Oct(Val(stringDec))
							SetDlgItemText(hWin,IDC_HEX,@stringHex)
							SetDlgItemText(hWin,IDC_BIN,@stringBin)
							SetDlgItemText(hWin,IDC_OCT,@stringOct)
							hasChanged(0) = 1
							hasChanged(2) = 1
							hasChanged(3) = 1
						Else
							hasChanged(1) = 0
						EndIf
					ElseIf Event = EN_KILLFOCUS Then
						GetDlgItemText(hWin,IDC_HEX,@stringHex,260)
						stringDec = Str(Val("&h" & stringHex))
						SetDlgItemText(hWin,IDC_DEC,@stringDec)
						hasChanged(1) = 1
					EndIf
				Case IDC_BIN
					If Event = EN_CHANGE Then
						If hasChanged(2) = 0  Then
							GetDlgItemText(hWin,IDC_BIN,@stringBin,260)
							stringDec = Str(Val("&b" & stringBin))
							stringHex = Hex(Val("&b" & stringBin))
							stringOct = Oct(Val("&b" & stringBin))
							SetDlgItemText(hWin,IDC_HEX,@stringHex)
							SetDlgItemText(hWin,IDC_DEC,@stringDec)
							SetDlgItemText(hWin,IDC_OCT,@stringOct)
							hasChanged(0) = 1
							hasChanged(1) = 1
							hasChanged(3) = 1
						Else
							hasChanged(2) = 0
						EndIf
					ElseIf Event = EN_KILLFOCUS Then
						GetDlgItemText(hWin,IDC_DEC,@stringDec,260)
						stringBin = Bin(Val(stringDec),8)
						SetDlgItemText(hWin,IDC_BIN,@stringBin)
						hasChanged(2) = 1
					EndIf
				Case IDC_OCT
					If Event = EN_CHANGE Then
						If hasChanged(3) = 0  Then
							GetDlgItemText(hWin,IDC_OCT,@stringOct,260)
							stringDec = Str(Val("&o" & stringOct))
							stringHex = Hex(Val("&o" & stringOct))
							stringBin = Bin(Val("&o" & stringOct),8)
							SetDlgItemText(hWin,IDC_HEX,@stringHex)
							SetDlgItemText(hWin,IDC_DEC,@stringDec)
							SetDlgItemText(hWin,IDC_BIN,@stringBin)
							hasChanged(0) = 1
							hasChanged(1) = 1
							hasChanged(2) = 1
						Else
							hasChanged(3) = 0
						EndIf
					ElseIf Event = EN_KILLFOCUS Then
						GetDlgItemText(hWin,IDC_DEC,@stringDec,260)
						stringOct = Oct(Val(stringDec))
						SetDlgItemText(hWin,IDC_OCT,@stringOct)
						hasChanged(3) = 1
					EndIf
			End Select
		Case Else
			Return FALSE
	End Select
	Return TRUE

End Function
