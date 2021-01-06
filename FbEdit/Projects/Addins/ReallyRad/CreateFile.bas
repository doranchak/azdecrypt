Dim Shared lpDLGHEAD As DLGHEAD Ptr
Dim Shared lpDIALOG As DIALOG Ptr
Dim Shared lpMNUHEAD As MNUHEAD Ptr
Dim Shared lpMNUITEM As MNUITEM Ptr

Function ConvertLine(ByVal sLine As String,ByVal sFunction As String,ByVal sName As String) As String
	Dim x As Integer

	x=InStr(sLine,sFunction)
	If x Then
		Return Left(sLine,x-1) & sName & Mid(sLine,x+Len(sFunction))
	EndIf
	Return sLine

End Function

Function FindFirstCtrl(ByVal nType As Integer) As Integer

	lpDIALOG=lpCTLDBLCLICK->lpDlgMem
	While lpDIALOG->hwnd
		If lpDIALOG->hwnd>0 And lpDIALOG->ntype=nType Then
			Return 1
		EndIf
		lpDIALOG=Cast(DIALOG Ptr,Cast(Integer,lpDIALOG)+SizeOf(DIALOG))
	Wend
	Return 0

End Function

Function FindNextCtrl(ByVal nType As Integer) As Integer

	While lpDIALOG->hwnd
		lpDIALOG=Cast(DIALOG Ptr,Cast(Integer,lpDIALOG)+SizeOf(DIALOG))
		If lpDIALOG->hwnd>0 And lpDIALOG->ntype=nType Then
			Return 1
		EndIf
	Wend
	Return 0

End Function

Function CreateIDEvents(ByVal nType As Integer, ByRef sLine As String,ByRef hMem As HGLOBAL) As Integer
	Dim nButton As Integer
	Dim sTmp As String
	Dim i As Integer

	nButton=FindFirstCtrl(nType)
	While nButton
		If lstrlen(lpDIALOG->idname) Then
			sTmp=ConvertLine(sLine,szCONTROLNAME,lpDIALOG->idname)
		Else
			sTmp=ConvertLine(sLine,szCONTROLNAME,Str(lpDIALOG->id))
		EndIf
		lstrcat(Cast(ZString Ptr,hMem),sTmp)
		lstrcat(Cast(ZString Ptr,hMem),@szCRLF)
		i+=1
		nButton=FindNextCtrl(nType)
	Wend
	Return i

End Function

Function CreateMenuIDEvents(ByRef sLine As String,ByRef hMem As HGLOBAL) As Integer
	Dim nButton As Integer
	Dim sTmp As String
	Dim i As Integer

	If lpMNUHEAD Then
		lpMNUITEM=Cast(MNUITEM Ptr,Cast(Integer,lpMNUHEAD)+SizeOf(MNUHEAD))
		While lpMNUITEM->itemflag
			If lpMNUITEM->itemflag<>-1 Then
				If Len(lpMNUITEM->itemname) And lpMNUITEM->itemid>0 Then
					sTmp=ConvertLine(sLine,szCONTROLNAME,lpMNUITEM->itemname)
					sTmp=ConvertLine(sTmp,szCONTROLID,Str(lpMNUITEM->itemid))
					lstrcat(Cast(ZString Ptr,hMem),sTmp)
					lstrcat(Cast(ZString Ptr,hMem),@szCRLF)
					i+=1
				EndIf
			EndIf
			lpMNUITEM=Cast(MNUITEM Ptr,Cast(Integer,lpMNUITEM)+SizeOf(MNUITEM))
		Wend
	EndIf
	Return i

End Function

Function CreateOutputFile(ByVal sTemplate As String) As HGLOBAL
	Dim hMem As HGLOBAL
	Dim f As Integer
	Dim nMode As Integer
	Dim sLine As String
	Dim sTmp As String
	Dim i As Integer
	Dim lpEvent As Integer
	Dim lpSubEvent As Integer
	Dim nEventType As Integer
	Dim nEvents As Integer

	hMem=GlobalAlloc(GMEM_FIXED Or GMEM_ZEROINIT,128*1024)
	f=FreeFile
	Open sTemplate For Input As #f
	' Skip description
	Line Input #f,sLine
	While Not Eof(f)
		Line Input #f,sLine
		Select Case nMode
			Case 0
				If InStr(sLine,szBEGINDEF) Then
					lpDLGHEAD=Cast(DLGHEAD Ptr,Cast(Integer,lpCTLDBLCLICK->lpDlgMem)-SizeOf(DLGHEAD))
					lpDIALOG=lpCTLDBLCLICK->lpDlgMem
					lpMNUHEAD=0
					lpMNUITEM=0
					If lpDLGHEAD->lpmnu Then
						lpMNUHEAD=Cast(MNUHEAD Ptr,lpDLGHEAD->lpmnu)
						lpMNUITEM=Cast(MNUITEM Ptr,Cast(Integer,lpDLGHEAD->lpmnu)+SizeOf(MNUHEAD))
					EndIf
					nMode=1
				ElseIf InStr(sLine,szBEGINCREATE) Then
					nMode=2
				ElseIf InStr(sLine,szBEGINPROC) Then
					nMode=3
				ElseIf InStr(sLine,szBEGINCODE) Then
					nMode=6
				EndIf
			Case 1
				If InStr(sLine,szENDDEF) Then
					nMode=0
				Else
					While lpDIALOG->hwnd
						If lpDIALOG->hwnd>0 Then
							If Len(lpDIALOG->idname) And lpDIALOG->id>0 Then
								sTmp=ConvertLine(sLine,szCONTROLNAME,lpDIALOG->idname)
								sTmp=ConvertLine(sTmp,szCONTROLID,Str(lpDIALOG->id))
								lstrcat(Cast(ZString Ptr,hMem),sTmp)
								lstrcat(Cast(ZString Ptr,hMem),@szCRLF)
							EndIf
						EndIf
						lpDIALOG=Cast(DIALOG Ptr,Cast(Integer,lpDIALOG)+SizeOf(DIALOG))
					Wend
					If lpMNUITEM Then
						While lpMNUITEM->itemflag
							If Len(lpMNUITEM->itemname) And lpMNUITEM->itemid>0 Then
								sTmp=ConvertLine(sLine,szCONTROLNAME,lpMNUITEM->itemname)
								sTmp=ConvertLine(sTmp,szCONTROLID,Str(lpMNUITEM->itemid))
								lstrcat(Cast(ZString Ptr,hMem),sTmp)
								lstrcat(Cast(ZString Ptr,hMem),@szCRLF)
							EndIf
							lpMNUITEM=Cast(MNUITEM Ptr,Cast(Integer,lpMNUITEM)+SizeOf(MNUITEM))
						Wend
					EndIf
				EndIf
				'
			Case 2
				If InStr(sLine,szENDCREATE) Then
					nMode=0
				Else
					sLine=ConvertLine(sLine,szDIALOGNAME,szName)
					sLine=ConvertLine(sLine,szDIALOGPROC,szProc)
					lstrcat(Cast(ZString Ptr,hMem),sLine)
					lstrcat(Cast(ZString Ptr,hMem),@szCRLF)
				EndIf
				'
			Case 3
				If InStr(sLine,szENDPROC) Then
					nMode=0
				ElseIf InStr(sLine,szBEGINEVENT) Then
					lpEvent=lstrlen(hMem)
					nMode=4
				Else
					sLine=ConvertLine(sLine,szDIALOGPROC,szProc)
					lstrcat(Cast(ZString Ptr,hMem),sLine)
					lstrcat(Cast(ZString Ptr,hMem),@szCRLF)
				EndIf
				'
			Case 4
				If InStr(sLine,szENDEVENT) Then
					nMode=3
				ElseIf InStr(sLine,szBEGINBN_CLICKED) Then
					lpSubEvent=Cast(Integer,hMem)+lstrlen(hMem)
					nEventType=BN_CLICKED
					nMode=5
				ElseIf InStr(sLine,szBEGINMNUSEL) Then
					lpSubEvent=Cast(Integer,hMem)+lstrlen(hMem)
					nEventType=99
					nMode=5
				ElseIf InStr(sLine,szBEGINEN_CHANGE) Then
					lpSubEvent=Cast(Integer,hMem)+lstrlen(hMem)
					nEventType=EN_CHANGE
					nMode=5
				ElseIf InStr(sLine,szBEGINLBN_SELCHANGE) Then
					lpSubEvent=Cast(Integer,hMem)+lstrlen(hMem)
					nEventType=LBN_SELCHANGE
					nMode=5
				Else
					lstrcat(Cast(ZString Ptr,hMem),sLine)
					lstrcat(Cast(ZString Ptr,hMem),@szCRLF)
				EndIf
				'
			Case 5
				If InStr(sLine,szENDBN_CLICKED) Then
					nMode=4
				ElseIf InStr(sLine,szENDMNUSEL) Then
					If nEvents=0 Then
						Poke lpSubEvent,0
					EndIf
					nMode=4
				ElseIf InStr(sLine,szENDEN_CHANGE) Then
					If nEvents=0 Then
						Poke lpSubEvent,0
					EndIf
					nMode=4
				ElseIf InStr(sLine,szENDLBN_SELCHANGE) Then
					If nEvents=0 Then
						Poke lpSubEvent,0
					EndIf
					nMode=4
				ElseIf InStr(sLine,szBEGINSELECTCASEID) Then
					nMode=98
				Else
					lstrcat(Cast(ZString Ptr,hMem),sLine)
					lstrcat(Cast(ZString Ptr,hMem),@szCRLF)
				EndIf
				'
			Case 6
				If InStr(sLine,szENDCODE) Then
					nMode=0
				Else
					sLine=ConvertLine(sLine,szDIALOGNAME,szName)
					sLine=ConvertLine(sLine,szDIALOGPROC,szProc)
					lstrcat(Cast(ZString Ptr,hMem),sLine)
					lstrcat(Cast(ZString Ptr,hMem),@szCRLF)
				EndIf
			Case 98
				If InStr(sLine,szENDSELECTCASEID) Then
					nMode=5
				ElseIf InStr(sLine,szBEGINCASEID) Then
					nMode=99
				Else
					lstrcat(Cast(ZString Ptr,hMem),sLine)
					lstrcat(Cast(ZString Ptr,hMem),@szCRLF)
				EndIf
			Case 99
				If InStr(sLine,szENDCASEID) Then
					nMode=98
				Else
					Select Case nEventType
						Case BN_CLICKED
							' Buttons
							nEvents=CreateIDEvents(4,sLine,hMem)
							' Check boxes
							nEvents+=CreateIDEvents(5,sLine,hMem)
							' Radio buttons
							nEvents+=CreateIDEvents(6,sLine,hMem)
						Case 99
							' Menu items
							nEvents=CreateMenuIDEvents(sLine,hMem)
						Case EN_CHANGE
							' Textbox
							nEvents=CreateIDEvents(1,sLine,hMem)
						Case LBN_SELCHANGE
							' Listbox
							nEvents=CreateIDEvents(7,sLine,hMem)
							' Combobox
							nEvents+=CreateIDEvents(8,sLine,hMem)
					End Select
				EndIf
		End Select
	Wend
	Close
	Return hMem

End Function
