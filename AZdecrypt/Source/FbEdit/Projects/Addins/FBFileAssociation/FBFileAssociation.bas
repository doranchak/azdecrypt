
#include "FBFileAssociation.bi"

#Define BAS_FILE "FBEditBasFile"
#Define BAS_FILE_D "FreeBasic Source File"
#Define BI_FILE "FBEditBiFile"
#Define BI_FILE_D "FreeBasic Header File"
#define RC_FILE "FBEditRcFile"
#Define RC_FILE_D "FreeBasic Resource File"
#define FBP_FILE "FBEditFbpFile"
#Define FBP_FILE_D "FBedit Project File"




function DlgProc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer
	dim as long id, event
	Dim regBasName  as RegLib=RegLib(HKEY_CLASSES_ROOT,".bas")
	Dim regBasClass as RegLib=RegLib(HKEY_CLASSES_ROOT,BAS_FILE)
	Dim regBasIcon  as RegLib=RegLib(HKEY_CLASSES_ROOT,BAS_FILE+"\DefaultIcon")
	Dim regBasCmd   as RegLib=RegLib(HKEY_CLASSES_ROOT,BAS_FILE+"\shell\open\command")
	Dim regBiName   as RegLib=RegLib(HKEY_CLASSES_ROOT,".bi")
	Dim regBiClass  as RegLib=RegLib(HKEY_CLASSES_ROOT,BI_FILE)
	Dim regBiIcon   as RegLib=RegLib(HKEY_CLASSES_ROOT,BI_FILE+"\DefaultIcon")
	Dim regBiCmd    as RegLib=RegLib(HKEY_CLASSES_ROOT,BI_FILE+"\shell\open\command")
	Dim regRcName   as RegLib=RegLib(HKEY_CLASSES_ROOT,".rc")
	Dim regRcClass  as RegLib=RegLib(HKEY_CLASSES_ROOT,RC_FILE)
	Dim regRcIcon   as RegLib=RegLib(HKEY_CLASSES_ROOT,RC_FILE+"\DefaultIcon")
	Dim regRcCmd    as RegLib=RegLib(HKEY_CLASSES_ROOT,RC_FILE+"\shell\open\command")
	Dim regFbpName  as RegLib=RegLib(HKEY_CLASSES_ROOT,".fbp")
	Dim regFbpClass as RegLib=RegLib(HKEY_CLASSES_ROOT,FBP_FILE)
	Dim regFbpIcon  as RegLib=RegLib(HKEY_CLASSES_ROOT,FBP_FILE+"\DefaultIcon")
	Dim regFbpCmd   as RegLib=RegLib(HKEY_CLASSES_ROOT,FBP_FILE+"\shell\open\command")
	Dim Cmd as String=Chr(34)+lpData->AppPath+"\FBEdit.exe"+Chr(34)+" "+Chr(34)+"%1"+Chr(34)
	Dim basIco as String=Chr(34)+lpData->AppPath+"\Addins\FBFileAssociation.dll"+Chr(34)+",0"
	Dim biIco as String=Chr(34)+lpData->AppPath+"\Addins\FBFileAssociation.dll"+Chr(34)+",1"
	Dim fbpIco as String=Chr(34)+lpData->AppPath+"\Addins\FBFileAssociation.dll"+Chr(34)+",2"
	Dim rcIco as String=Chr(34)+lpData->AppPath+"\Addins\FBFileAssociation.dll"+Chr(34)+",3"
	Dim buff As ZString*256

	select case uMsg
		case WM_INITDIALOG
			lpFunctions->TranslateAddinDialog(hDlg,"FBFileAssociation")
			'.bas
			if regBasName.exists and regBasName.default=BAS_FILE and _
				regBasClass.exists and regBasClass.default=BAS_FILE_D and _
				regBasIcon.exists and regBasIcon.default=basIco and _
				regBasCmd.exists and regBasCmd.default=Cmd then
				CheckDlgButton(hDlg,baBAS,BST_CHECKED)
			else
				CheckDlgButton(hDlg,baBAS,BST_UNCHECKED)
			endif
			'.bi
			if regBiName.exists and regBiName.default=BI_FILE and _
				regBiClass.exists and regBiClass.default=BI_FILE_D and _
				regBiIcon.exists and regBiIcon.default=biIco and _
				regBiCmd.exists and regBiCmd.default=Cmd then
				CheckDlgButton(hDlg,baBI,BST_CHECKED)
			else
				CheckDlgButton(hDlg,baBI,BST_UNCHECKED)
			endif			
			'.fbp
			if regFbpName.exists and regFbpName.default=FBP_FILE and _
				regFbpClass.exists and regFbpClass.default=FBP_FILE_D and _
				regFbpIcon.exists and regFbpIcon.default=fbpIco and _
				regFbpCmd.exists and regFbpCmd.default=Cmd then
				CheckDlgButton(hDlg,baFBP,BST_CHECKED)
			else
				CheckDlgButton(hDlg,baFBP,BST_UNCHECKED)
			endif		
			'.rc
			if regRcName.exists and regRcName.default=RC_FILE and _
				regRcClass.exists and regRcClass.default=RC_FILE_D and _
				regRcIcon.exists and regRcIcon.default=rcIco and _
				regRcCmd.exists and regRcCmd.default=Cmd then
				CheckDlgButton(hDlg,baRC,BST_CHECKED)
			else
				CheckDlgButton(hDlg,baRC,BST_UNCHECKED)
			endif					
		case WM_CLOSE
			EndDialog(hDlg, 0)
			'
		case WM_COMMAND
			id=loword(wParam)
			event=hiword(wParam)
			select case id
				case baCLOSE
					EndDialog(hDlg, 0)
				case baDOIT
					if IsDlgButtonChecked(hDlg,baBAS) then
						regBasName.createMe()
						regBasClass.createMe()
						regBasIcon.createMe()
						regBasCmd.createMe()
						regBasName.default=BAS_FILE
						regBasClass.default=BAS_FILE_D
						regBasIcon.default=basIco
						regBasCmd.default=Cmd							
					else
						regBasCmd.deleteMe()
						regBasIcon.deleteMe()
						Dim tmp as RegLib=RegLib(HKEY_CLASSES_ROOT,BAS_FILE+"\shell\open")
						tmp.deleteMe()
						tmp=RegLib(HKEY_CLASSES_ROOT,BAS_FILE+"\shell")
						tmp.deleteMe()
						regBasClass.deleteMe()
						regBasName.deleteMe()
					endif
					if IsDlgButtonChecked(hDlg,baBI) then
						regBiName.createMe()
						regBiClass.createMe()
						regBiIcon.createMe()
						regBiCmd.createMe()
						regBiName.default=BI_FILE
						regBiClass.default=BI_FILE_D
						regBiIcon.default=biIco
						regBiCmd.default=Cmd							
					else
						regBiCmd.deleteMe()
						regBiIcon.deleteMe()
						Dim tmp as RegLib=RegLib(HKEY_CLASSES_ROOT,BI_FILE+"\shell\open")
						tmp.deleteMe()
						tmp=RegLib(HKEY_CLASSES_ROOT,BI_FILE+"\shell")
						tmp.deleteMe()
						regBiClass.deleteMe()
						regBiName.deleteMe()
					endif
					if IsDlgButtonChecked(hDlg,baFBP) then
						regFbpName.createMe()
						regFbpClass.createMe()
						regFbpIcon.createMe()
						regFbpCmd.createMe()
						regFbpName.default=FBP_FILE
						regFbpClass.default=FBP_FILE_D
						regFbpIcon.default=fbpIco
						regFbpCmd.default=Cmd							
					else
						regFbpCmd.deleteMe()
						regFbpIcon.deleteMe()
						Dim tmp as RegLib=RegLib(HKEY_CLASSES_ROOT,FBP_FILE+"\shell\open")
						tmp.deleteMe()
						tmp=RegLib(HKEY_CLASSES_ROOT,FBP_FILE+"\shell")
						tmp.deleteMe()
						regFbpClass.deleteMe()
						regFbpName.deleteMe()
					endif		
					if IsDlgButtonChecked(hDlg,baRC) then
						regRcName.createMe()
						regRcClass.createMe()
						regRcIcon.createMe()
						regRcCmd.createMe()
						regRcName.default=RC_FILE
						regRcClass.default=RC_FILE_D
						regRcIcon.default=rcIco
						regRcCmd.default=Cmd							
					else
						regRcCmd.deleteMe()
						regRcIcon.deleteMe()
						Dim tmp as RegLib=RegLib(HKEY_CLASSES_ROOT,RC_FILE+"\shell\open")
						tmp.deleteMe()
						tmp=RegLib(HKEY_CLASSES_ROOT,RC_FILE+"\shell")
						tmp.deleteMe()
						regRcClass.deleteMe()
						regRcName.deleteMe()
					EndIf
					buff=lpFunctions->FindString(lpData->hLangMem,"FBFileAssociation","10001")
					If buff="" Then
						buff="File Association changed!"+Chr(13)+"FBEdit path is:"
					EndIf

					MessageBox(hDlg,buff+Chr(13)+lpData->AppPath,"FBEdit",MB_OK)
					EndDialog(hDlg, 0)
			end select
		case WM_SIZE
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function


' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
function InstallDll CDECL alias "InstallDll" (byval hWin as HWND,byval hInst as HINSTANCE) as ADDINHOOKS ptr EXPORT
	Dim buff As ZString*256
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
	GetMenuItemInfo(lpHANDLES->hmenu,10161,FALSE,@mii)
	' Add our menu item to Tools menu
	IDM_FILEASSOC=SendMessage(hWin,AIM_GETMENUID,0,0)
	buff=lpFunctions->FindString(lpData->hLangMem,"FBFileAssociation","10000")
	If buff="" Then
		buff="File Association"
	EndIf
	AppendMenu(mii.hSubMenu,MF_STRING,IDM_FILEASSOC,StrPtr(buff))
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
			if loword(wParam)=IDM_FILEASSOC then
'				MessageBox(hWin,"Cool","caption",MB_OK)
				DialogBoxParam(hInstance,Cast(zstring ptr,IDD_DLG1),hWin,@DlgProc,NULL)
			endif
		case AIM_CLOSE
			'
	end select
	return FALSE

end function
