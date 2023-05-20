#Define IDD_DIALOG			1000
#Define IDC_RAEDIT			1001
#Define IDC_SBR1				1002

#Define IDM_MENU				10000
#Define IDM_FILE_EXIT		10001
#Define IDM_FILE_OPEN		10002
#Define IDM_FILE_SAVE		10003
#Define IDM_FILE_NEW			10004
#Define IDM_HELP_ABOUT		10101

Dim Shared hInstance As HMODULE
Dim Shared CommandLine As ZString Ptr
Dim Shared hLib As HMODULE
Dim Shared hWnd As HWND
Dim Shared hREd As HWND

Const ClassName="DLGCLASS"
Const AppName="Dialog as main"
Const AboutMsg=!"FbEdit Dialog as main\13\10Copyright © FbEdit 2007"
Const szLib="RAEdit.dll"
Const szHighlight1="#define #include once"
Const szHighlight2="print input private public function sub end"

Dim Shared szFileName As ZString*260

' Block definitions. max 10 block definitions
Dim Shared bd(9) As RABLOCKDEF
Dim szSt(9) As ZString*64
Dim szEn(9) As ZString*64
' Comment blocks
bd(0).lpszStart=@szSt(0)
bd(0).lpszEnd=@szEn(0)
szSt(0)="/'"
szEn(0)="'/"
bd(0).flag=BD_INCLUDELAST Or BD_COMMENTBLOCK
' Function
bd(1).lpszStart=@szSt(1)
bd(1).lpszEnd=@szEn(1)
szSt(1)="%private %public function $"
szEn(1)="End Function"
bd(1).flag=BD_INCLUDELAST Or BD_DIVIDERLINE
' Sub
bd(2).lpszStart=@szSt(2)
bd(2).lpszEnd=@szEn(2)
szSt(2)="%private %public sub $"
szEn(2)="End Sub"
bd(2).flag=BD_INCLUDELAST Or BD_DIVIDERLINE
