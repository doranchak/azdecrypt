
#Include "debug.bi"

Declare Function decouparray(As String,As Integer,As Byte) As Integer
Declare Function decoupscp(As Byte) As Integer
Declare Sub WatchVars

Sub PutString(ByVal lpStr As ZString Ptr)
	Dim chrg As CHARRANGE

	chrg.cpMin=-1
	chrg.cpMax=-1
	SendMessage(lpHandles->hout,EM_EXSETSEL,0,Cast(LPARAM,@chrg))
	SendMessage(lpHandles->hout,EM_REPLACESEL,FALSE,Cast(LPARAM,lpStr))
	SendMessage(lpHandles->hout,EM_REPLACESEL,FALSE,Cast(LPARAM,@szCRLF))

End Sub

Sub readstab()

	If ReadProcessMemory(dbghand,Cast(Any Ptr,basestab),@recupstab,12,0)=0 Then
		PutString("Error reading memory at " & Hex(basestab))
	End If

End Sub

Sub readstabs(ByVal ad As UInteger)
	Dim lret As Integer
	Dim b As Byte

	b=1
	recup=""
	While b
		b=0
		lret=ReadProcessMemory(dbghand,Cast(Any Ptr,ad+basestabs),@b,1,0)
		If lret=0 Then
			PutString("Error reading memory at " & Hex(ad+basestabs))
		End If
		recup &=Chr(b)
		ad+=1
	Wend
	stabnb+=1
	stab(stabnb)=recup

End Sub

Function decoupnames(strg As String) As String
	Dim As Integer p,d
	Dim As String nm,strg2,nm2

	strg2=Mid(strg,5)
	p=Val(strg2)
	If p>9 Then d=3 Else d=2
	nm=Mid(strg2,d,p)
	strg2=Mid(strg2,d+p)
	p=Val(strg2)
	If p>9 Then d=3 Else d=2
	nm2=Mid(strg2,d,p)
	Return "NS : "+nm+"."+nm2

End Function

Function decoupproc(strg As String) As String
	Dim As Integer p,d
	Dim As String nm,strg2,nm2

	If Left(strg,3)<>"__Z" Then Return strg
	If strg[3]=Asc("N") Then
		strg2=Mid(strg,5)
		p=Val(strg2)
		If p>9 Then d=3 Else d=2
		nm=Mid(strg2,d,p)
		strg2=Mid(strg2,d+p)
		p=Val(strg2)
		If p Then
			If p>9 Then d=3 Else d=2
			nm2=Mid(strg2,d,p)
			p=InStr(nm2,"__get__")
			If p Then
				Return "Get property : "+nm+"."+Left(nm2,p-1)
			Else
				p=InStr(nm2,"__set__")
				If p Then
					Return "Set property : "+nm+"."+Left(nm2,p-1)
				Else
					Return "Function : "+nm+"."+nm2
				EndIf
			EndIf
		Else
			Select Case Left(strg2,2)
				Case "cv"
					strg2=Mid(strg2,3)
					p=Val(strg2)
					If p>9 Then d=3 Else d=2
					Return "Cast : "+nm+"-->"+Mid(strg2,d,p)
				Case "C1"
					Return "Constructor : "+nm
				Case "D1"
					Return "Destructor : "+nm
				Case Else
					Return "Unknown"+strg2
			End Select
		EndIf
	Else
		'operator
		Return "Operator : "+strg
	EndIf

End Function

Function FindUdt(ByVal typ As Integer,ByVal sr As UByte) As Integer
	Dim i As Integer

	For i=udtnb To 1 Step -1
		If typ=udt(i).typ And sr=udt(i).sr Then
			Return i
		EndIf
	Next
	Return 0
	
End Function

Sub decoup2(gv As String,f As Byte)
	Dim p As Integer=1,c As UShort,e As Integer,gv2 As String,typ As UShort

	If InStr(gv,"=")=0 Then
		If f=TYUDT Then
			typ=Val(Mid(gv,p))
			If typ<=15 Then
				cudt(cudtnb).typ=typ
			Else
				cudt(cudtnb).typ=FindUdt(typ,sourcenb)
			EndIf
		Else
			typ=Val(Mid(gv,p))
			If typ<=15 Then
				vrb(vrbnb).typ=typ
			Else
				vrb(vrbnb).typ=FindUdt(typ,sourcenb)
			EndIf
			vrb(vrbnb).sr=sourcenb
		End If
	Else
		If InStr(gv,"=ar1") Then
			arrnb+=1
			p=decouparray(gv,InStr(gv,"=ar1")+1,f)
		EndIf
		gv2=Mid(gv,p)
		For p=0 To Len(gv2)-1
			If gv2[p]=Asc("*") Then
				c+=1
			EndIf
			If gv2[p]=Asc("=") Then
				e=p+1
			EndIf
		Next
		If c Then
			' Pointer
			If InStr(gv2,"=f") Then
				' Procedure
				If InStr(gv2,"=f7") Then
					' Sub
					p=200+c
				Else
					' Function
					p=220+c
				EndIf
			Else
				p=c
				e+=1
			End If
		Else
			p=0
		End If
		If f=TYUDT Then
			cudt(cudtnb).pt=p
			cudt(cudtnb).typ=Val(Mid(gv2,e+1))
		Else
			vrb(vrbnb).pt=p
			typ=Val(Mid(gv2,e+1))
			If typ<=15 Then
				vrb(vrbnb).typ=typ
			Else
				vrb(vrbnb).typ=FindUdt(typ,sourcenb)
			EndIf
			vrb(vrbnb).sr=sourcenb
		End If
	EndIf

End Sub

Sub decoupudt(readl As String)
	Dim As UShort p,q
	Dim As String tnm

	udtnb+=1
	p=InStr(readl,":")
	tnm=Left(readl,p-1)
	p+=3
	q=InStr(readl,"=")
	udt(udtnb).nm=tnm
	udt(udtnb).typ=Val(Mid(readl,p,q-p))
'	udt(udtnb).typ=FindUdt(Val(Mid(readl,p,q-p)),sourcenb)
	udt(udtnb).sr=sourcenb
	p=q+2
	q=p-1
	While readl[q]<64
		q+=1
	Wend
	q+=1
	udt(udtnb).lg=Val(Mid(readl,p,q-p))
	p=q
	udt(udtnb).lb=cudtnb+1
	While readl[p-1]<>Asc(";")
		cudtnb+=1
		q=InStr(p,readl,":")
		' Variable name
		cudt(cudtnb).nm=Mid(readl,p,q-p)
		p=q+1
		q=InStr(p,readl,",")
		' Variable type
		decoup2(Mid(readl,p,q-p),TYUDT)
		p=q+1
		q=InStr(p,readl,",")
		' Offset data
		cudt(cudtnb).ofs=Val(Mid(readl,p,q-p))\8
		p=q+1
		q=InStr(p,readl,";")
		' Lenght in bits, not used
		'Val(Mid(readl,p,q-p))
		p=q+1
	Wend
	udt(udtnb).ub=cudtnb
	If udt(udtnb).lb=udt(udtnb).ub And cudt(udt(udtnb).lb).nm="I" Then
		If Right(udt(udtnb).nm,2)="__" Then
			udt(udtnb).nm=Left(udt(udtnb).nm,Len(udt(udtnb).nm)-2)
		EndIf
	EndIf

End Sub

Sub decoup(gv As String)
	Dim p As Integer

	If InStr(gv,"=-") Or Left(gv,8)="string:t" Or Left(gv,7)="pchar:t" Then
		Exit Sub
	EndIf
	If gv[0]=Asc(":") Then
		' Return value
		Exit Sub
	End If
	If InStr(gv,";;") Then
		' Defined type or redim var
		If InStr(gv,":Tt") Then
			' UDT
			decoupudt(gv)
		Else
			' REDIM
			' Var or parameter
			vrbnb+=1
			vrb(vrbnb).nm=Left(gv,InStr(gv,":")-1)
			vrb(vrbnb).sr=sourcenb
			vrb(vrbnb).arr=Cast(Any Ptr,recupstab.ad)
			' Just to have the next beginning
			proc(procnb+1).vr=vrbnb+1
			' First caracter after ":"
			decoupscp(gv[InStr(gv,":")])
			decoup2(Mid(gv,InStr(gv,";;")+2),TYRDM)
		EndIf
	Else
		' Dim
		vrbnb+=1
		If Left(gv,4)="__ZN" And InStr(gv,":") Then
			' Namespace
			vrb(vrbnb).nm=decoupnames(gv)
		Else
			vrb(vrbnb).nm=Left(gv,InStr(gv,":")-1) 'var ou parametre
		End If
		vrb(vrbnb).sr=sourcenb
		' Just to have the next beginning
		proc(procnb+1).vr=vrbnb+1
		' First caracter after ":"
		p=decoupscp(gv[InStr(gv,":")])
		decoup2(Mid(gv,InStr(gv,":")+p),TYDIM)
	EndIf

End Sub

Function decoupscp(gv As Byte) As Integer

	Select Case gv
		Case Asc("S")
			'shared
			vrb(vrbnb).mem=1
			vrb(vrbnb).pn=0
			Return 2
		Case Asc("V")
			'static
			vrb(vrbnb).mem=2
			vrb(vrbnb).pn=procnb
			Return 2
		Case Asc("v")
			'byref parameter
			vrb(vrbnb).mem=3
			vrb(vrbnb).pn=procnb
			Return 2
		Case Asc("p")
			'byval parameter
			vrb(vrbnb).mem=4
			vrb(vrbnb).pn=procnb
			Return 2
		Case Asc("G")
			'common
			vrb(vrbnb).mem=6
			vrb(vrbnb).pn=0
			Return 2
		Case Else
			'local
			vrb(vrbnb).mem=5
			vrb(vrbnb).pn=procnb
			Return 1
	End Select

End Function

Function decouparray(gv As String,d As Integer,f As Byte) As Integer
	Dim As Integer p=d,q,c

	While gv[p-1]=Asc("a")
		' Skip ar1
		p+=4
		q=InStr(p,gv,";")
		If f=TYDIM Then
			' Lbound
			arr(arrnb).nlu(c).lb=Val(Mid(gv,p,q-p))
		Else
			audtnb+=1
			audt(audtnb).nlu(c).lb=Val(Mid(gv,p,q-p))
			cudt(cudtnb).arr=audtnb
		End If
		p=q+1
		q=InStr(p,gv,";")
		If f=TYDIM Then
			' Ubound
			arr(arrnb).nlu(c).ub=Val(Mid(gv,p,q-p))
			' Dim
			arr(arrnb).nlu(c).nb=arr(arrnb).nlu(c).ub-arr(arrnb).nlu(c).lb+1
		Else
			audt(audtnb).nlu(c).ub=Val(Mid(gv,p,q-p))
			audt(audtnb).nlu(c).nb=audt(audtnb).nlu(c).ub-audt(audtnb).nlu(c).lb
		End If
		p=q+1
		c+=1
	Wend
	If f=TYDIM Then
		' nb dim
		arr(arrnb).dmn=c
		vrb(vrbnb).arr=@arr(arrnb)
	Else
		audt(audtnb).dm=c
	End If
	Return p

End Function

Sub ParseDebugInfo()
	Dim As UInteger i,j
	Dim As Boolean bNoDebug
	
	' Beginning of section area
	pe=&h400086
	ReadProcessMemory(dbghand,Cast(Any Ptr,pe),@secnb,2,0)
	pe=&h400178
	For i=1 To secnb
		' Init var
		secnm=String(8,0)
		' Read 8 bytes max section name size
		ReadProcessMemory(dbghand,Cast(Any Ptr,pe),@secnm,8,0)
		If secnm=".stab" Then
			ReadProcessMemory(dbghand,Cast(Any Ptr,pe+12),@basestab,4,0)
		ElseIf secnm=".stabstr" Then
			ReadProcessMemory(dbghand,Cast(Any Ptr,pe+12),@basestabs,4,0)
		EndIf
		pe+=40
	Next
	If basestab Then
		basestab+=&h400000+12
		basestabs+=&h400000
		While TRUE
			readstab()
			If recupstab.code=0 Then
				Exit While
			EndIf
			If recupstab.stabs Then
				readstabs(recupstab.stabs)
				Select Case recupstab.code
					Case 36
						' Proc
						procfg=1
						procad=recupstab.ad:procnb+=1
						proc(procnb).sr=sourceix
						'proc(procnb).sr=sourcenb
						proc(procnb).ad=recupstab.ad
						proc(procnb).nm=decoupproc(Left(recup,InStr(recup,":")-1))
						' Return value
						proc(procnb).rv=Val(Mid(recup,InStr(recup,":F")+2,5))
						proc(procnb).nu=recupstab.nline
						bNoDebug=FALSE
						For i=0 To 299
							If NoDebug(i)=UCase(proc(procnb).nm) Then
								bNoDebug=TRUE
								Exit For
							EndIf
						Next
					Case 38,40,128,160
						' Init var
						decoup(recup)
						If recupstab.ad Then
							vrb(vrbnb).adr=recupstab.ad
						EndIf
					Case 100
						' Main Source
						'PutString("Main " & recup)
						If Right(recup,1)="/" Or Right(recup,1)="\" Then
							source(0).file=recup
						Else
							sourcenb+=1
							source(sourcenb).file=source(0).file & recup
							sourceix=sourcenb
						EndIf
						i=1
						While i
							i=InStr(i,source(sourcenb).file,"/")
							If i Then
								source(sourcenb).file[i-1]=Asc("\")
							EndIf
						Wend
					Case 130
						' Include RAS
						'PutString("include RAS " & recup)
					Case 132
						' Include
						'PutString("Include: " & Str(recup))
						sourcenb+=1
						source(sourcenb).file=recup
						sourceix=sourcenb
						i=1
						While i
							i=InStr(i,source(sourcenb).file,"/")
							If i Then
								source(sourcenb).file[i-1]=Asc("\")
							EndIf
						Wend
					Case 42
						' Main RAS
						'PutString("Main RAS " & recup)
					Case Else
						PutString("UNKNOWN ")
				End Select
			Else
				Select Case recupstab.code
					Case 68
						' Avoid to stop on sub or function line
						If recupstab.ad And bNoDebug=FALSE Then
							' Do not include label in asm block
							If recupstab.ad<>linead Then
								linead=recupstab.ad
								linenb+=1
							EndIf
							rline(linenb).ad=recupstab.ad+procad
							rLine(linenb).nu=recupstab.nline
							rLine(linenb).pr=procnb
							rLine(linenb).sv=-1
						End If
					Case 192
						If procfg Then
							' Begin. block proc
							procfg=0
							proc(procnb).db=recupstab.ad+procad
						Else
							' Begin. of block"
						End If
					Case 224
						' End of block
						procsv=recupstab.ad+procad
					Case 36
						' End of proc
						proc(procnb).fn=procsv
					Case 162
						' End include
						sourceix=1
					Case 100
						' End of file
						'Exit While
					Case Else
						PutString("UNKNOWN " & recupstab.code & "," & recupstab.stabs & "," & recupstab.nline & "," & recupstab.ad)
				End Select
			End If
			basestab+=12
		Wend
		PutString("Main Source: " & source(1).file)
		'PutString("sourcenb " & sourcenb)
		'PutString("linenb " & linenb)
		'PutString("procnb " & procnb)
		'PutString("vrbnb " & vrbnb)
		'PutString("udtidx " & udtidx)
		'PutString("cudtnb " & cudtnb)
		'PutString("audtnb " & audtnb)
		'For i=0 To sourcenb
		'	PutString(source(i).file)
		'Next
		'For i=1 To vrbnb
		'	PutString(vrb(i).nm)
		'Next
		'For i=1 To udtidx
		'	PutString("i: " & i & " " & udt(i).nm & " lb: " & udt(i).lb & " ub: " & udt(i).ub & " lg: " & udt(i).lg)
		'Next
		'For i=1 To cudtnb
		'	PutString("i: " & i & " " & cudt(i).nm & " Typ: " & cudt(i).typ & " ofs: " & cudt(i).ofs & " arr: " & cudt(i).arr & " pt: " & cudt(i).pt)
		'Next
		'For i=1 To audtnb
		'	PutString("i: " & i & " dm: " & audt(i).dm & " nlu.nb: " & audt(i).nlu(0).nb)
		'Next
	Else
		PutString("No debug info found. Compile with the -g option.")
	EndIf

End Sub

'------------------------------------------------------

Sub SetBreakPoints(ByVal nLnRunTo As Integer)
	Dim As Integer i,j,bpinx
	Dim sln As String

	For i=1 To linenb
		If rLine(i).sv=-1 And i<>linesav Then
			sln="," & Str(rLine(i).nu-1) & ","
			If InStr(bp(source(proc(rline(i).pr).sr).pInx).sBP,sln) Then
				rLine(i).sv=0
				' Save 1 byte before writing &CC
				ReadProcessMemory(dbghand,Cast(Any Ptr,rline(i).ad),@rLine(i).sv,1,0)
				' Breakpoint
				WriteProcessMemory(dbghand,Cast(Any Ptr,rline(i).ad),@breakvalue,1,0)
			EndIf
			If rline(i).nu-1=nLnRunTo And rLine(i).sv=-1 Then
				If UCase(lpData->filename)=UCase(source(proc(rline(i).pr).sr).file) Then
					rLine(i).sv=0
					' Save 1 byte before writing &CC
					ReadProcessMemory(dbghand,Cast(Any Ptr,rline(i).ad),@rLine(i).sv,1,0)
					' Breakpoint
					WriteProcessMemory(dbghand,Cast(Any Ptr,rline(i).ad),@breakvalue,1,0)
				EndIf
			EndIf
		EndIf
	Next
	fRun=0

End Sub

Sub SetBreakAll()
	Dim i As Integer

	For i=1 To linenb
		If rLine(i).sv=-1 Then
			rLine(i).sv=0
			' Save 1 byte before writing &CC
			ReadProcessMemory(dbghand,Cast(Any Ptr,rline(i).ad),@rLine(i).sv,1,0)
			' Breakpoint
			WriteProcessMemory(dbghand,Cast(Any Ptr,rline(i).ad),@breakvalue,1,0)
		EndIf
	Next

End Sub

Sub ClearBreakAll(ByVal nNotProc As Integer)
	Dim i As Integer

	For i=1 To linenb
		If rLine(i).sv<>-1 And rline(i).pr<>nNotProc Then
			' Restore 1 byte
			WriteProcessMemory(dbghand,Cast(Any Ptr,rline(i).ad),@rLine(i).sv,1,0)
			rLine(i).sv=-1
		EndIf
	Next

End Sub

Sub ClearBreakProc(ByVal nProc As Integer)
	Dim i As Integer

	For i=1 To linenb
		If rLine(i).sv<>-1 And rline(i).pr=nProc Then
			' Restore 1 byte
			WriteProcessMemory(dbghand,Cast(Any Ptr,rline(i).ad),@rLine(i).sv,1,0)
			rLine(i).sv=-1
		EndIf
	Next

End Sub

Sub seteip(ad As UInteger)
	Dim vcontext As CONTEXT

	vcontext.contextflags=CONTEXT_CONTROL
	GetThreadContext(threadcontext,@vcontext)
	procsk=vcontext.ebp
	vcontext.Eip=ad
	SetThreadContext(threadcontext,@vcontext)

End Sub

Function FindLine(ByVal ad As Integer) As Integer
	Dim i As Integer

	For i=1 To linenb
		If rline(i).ad=ad Then
			Exit For
		EndIf
	Next
	Return i

End Function

Sub gestbrk(ByVal ad As UInteger,ByVal fRun As Integer)
	Dim As UInteger i
	Dim n As ZString Ptr
	Dim chrg As CHARRANGE
	Dim hwfd As HANDLE
	Dim wfd As WIN32_FIND_DATA
	Dim szCurDir As ZString*260

	i=linesav+1
	proccurad=ad
	If rline(i).ad<>ad Then
		i=FindLine(ad)
		If i>linenb Then
			Exit Sub
		EndIf
	End If
	' Get context
	seteip(ad)
	If fRun=99 Then
		If rline(i).sv<>-1 Then
			' Restore old value for execution
			WriteProcessMemory(dbghand,Cast(Any Ptr,rLine(i).ad),@rLine(i).sv,1,0)
			rline(i).sv=-1
		EndIf
		Exit Sub
	EndIf
	linesav=i
	If procrsk>procsk Then
		' New proc
		procrnb+=1
		procrsk=procsk
		ebp_this=procsk
		procr(procrnb).sk=procrsk
		procsv=rline(i).pr
		procr(procrnb).sk=procrsk
		procr(procrnb).idx=procsv
	ElseIf procrsk<procsk Then
		' Previous proc
		procrsk=procsk
		ebp_this=procsk
		procsv=rline(i).pr
		procrnb-=1
	EndIf
	If fRun Then
		ClearBreakAll(0)
		SetBreakPoints(-1)
	Else
		SetBreakAll
		If rline(i).sv<>-1 Then
			' Restore old value for execution
			WriteProcessMemory(dbghand,Cast(Any Ptr,rLine(i).ad),@rLine(i).sv,1,0)
			rline(i).sv=-1
		EndIf
		thisprocsv=procsv
		thislinesav=i
		thisthreadcontext=threadcontext
		If lstrlen(lpData->ProjectFile) Then
			szFileName=bp(source(proc(procsv).sr).pInx).sFile
		Else
			szFileName=source(proc(procsv).sr).file
			hwfd=FindFirstFile(@szFileName,@wfd)
			If hwfd<>INVALID_HANDLE_VALUE Then
				szFileName=Left(szFileName,Len(szFileName)-Len(wfd.cFileName))
				If UCase(szFileName)=UCase(source(0).file) Then
					szFileName=source(0).file
				EndIf
				szFileName=szFileName & wfd.cFileName
				FindClose(hwfd)
			EndIf
		EndIf
		PostMessage(lpHandles->hwnd,AIM_OPENFILE,0,Cast(LPARAM,@szFileName))
		WaitForSingleObject(pinfo.hProcess,100)
		' Clear old line
		hLnDebug=lpHandles->hred
		SendMessage(hLnDebug,WM_SETREDRAW,FALSE,0)
		SendMessage(hLnDebug,EM_EXGETSEL,0,Cast(LPARAM,@chrg))
		nLnDebug=SendMessage(hLnDebug,EM_EXLINEFROMCHAR,0,chrg.cpMin)
		SendMessage(hLnDebug,REM_SETHILITELINE,nLnDebug,0)
		' Select new line
		nLnDebug=rLine(i).nu-1
		' If at top then make line abowe visible
		If nLnDebug Then
			chrg.cpMin=SendMessage(hLnDebug,EM_LINEINDEX,nLnDebug-1,0)
			chrg.cpMax=chrg.cpMin
			SendMessage(hLnDebug,EM_EXSETSEL,0,Cast(LPARAM,@chrg))
			SendMessage(hLnDebug,EM_SCROLLCARET,0,0)
		EndIf
		' If at bottom then make line below visible
		chrg.cpMin=SendMessage(hLnDebug,EM_LINEINDEX,nLnDebug+1,0)
		chrg.cpMax=chrg.cpMin
		SendMessage(hLnDebug,EM_EXSETSEL,0,Cast(LPARAM,@chrg))
		SendMessage(hLnDebug,EM_SCROLLCARET,0,0)
		' Select and highlight the line
		chrg.cpMin=SendMessage(hLnDebug,EM_LINEINDEX,nLnDebug,0)
		chrg.cpMax=chrg.cpMin
		SendMessage(hLnDebug,EM_EXSETSEL,0,Cast(LPARAM,@chrg))
		SendMessage(hLnDebug,EM_SCROLLCARET,0,0)
		SendMessage(hLnDebug,EM_EXSETSEL,0,Cast(LPARAM,@chrg))
		SendMessage(hLnDebug,REM_SETHILITELINE,nLnDebug,2)
		SendMessage(hLnDebug,WM_SETREDRAW,TRUE,0)
		SendMessage(hLnDebug,REM_REPAINT,0,TRUE)
		SuspendThread(thisthreadcontext)
		SetForegroundWindow(lpHandles->hwnd)
		SetFocus(hLnDebug)
		WatchVars
	EndIf

End Sub

Sub ClearDebugLine()

	If nLnDebug<>-1 And hLnDebug<>0 Then
		SendMessage(hLnDebug,REM_SETHILITELINE,nLnDebug,0)
		nLnDebug=-1
		hLnDebug=0
	EndIf

End Sub

Sub findthread(tid As UInteger)
	Dim i As Byte

	' If msg from thread then flag off
	For i=0 To threadnb
		If tid=thread(i).threadid Then
			threadcontext=thread(i).thread
			thread(i).threadres=0
			threadidx=i
			Exit Sub
		EndIf
	Next

End Sub

Sub ResumeAllThreads()
	Dim i As Integer
	Dim lret As Integer

	For i=0 To threadnb
		If thread(i).thread Then
			lret=1
			While lret>0
				lret=ResumeThread(thread(i).thread)
				'PutString("ResumeThread " & lret)
			Wend
		EndIf
	Next i

End Sub

Sub ClearVars()
	Dim As Integer i,j

'Dim Shared secnb As UShort
'Dim Shared pe As UInteger
'Dim Shared secnm As String*8
'Dim Shared basestab As UInteger
'Dim Shared basestabs As UInteger
'Dim Shared recupstab As udtstab
'Dim Shared recup As ZString*1000
	secnb=0
	pe=0
	secnm=""
	basestab=0
	basestabs=0
	recupstab.stabs=0
	recupstab.code=0
	recupstab.nline=0
	recupstab.ad=0
	recup=String(SizeOf(recup),0)

'Dim Shared procnb As Integer
'Dim Shared procfg As Byte
'Dim Shared As UInteger procsv,procad ,procin,procsk,proccurad
'Const PROCMAX=500
'Dim Shared proc(PROCMAX) As tproc
	procnb=0
	procfg=0
	procsv=0
	procad=0
	procin=0
	procsk=0
	proccurad=0
	For i=0 To PROCMAX
		proc(i).nm=""
		proc(i).db=0
		proc(i).fn=0
		proc(i).sr=0
		proc(i).ad=0
		proc(i).vr=0
		proc(i).rv=0
		proc(i).nu=0
	Next
	proc(1).vr=1

'Const PROCRMAX=50000
'Dim Shared procr(PROCRMAX) As tprocr 'list of running proc
'Dim Shared procrnb as Integer
'Dim Shared procrsk As UInteger
	For i=0 To PROCRMAX
		procr(i).sk=0
		procr(i).idx=0
	Next
	procrnb=0
	procrsk=4294967295'current proc stack


'Dim Shared source(SOURCEMAX) As tsource
'Dim Shared sourceix As Integer
'Dim Shared sourcenb As Integer
	For i=0 To SOURCEMAX
		source(i).file=""
		source(i).pInx=0
	Next
	sourceix=0
	sourcenb=0

'Const TYPEMAX=1500
'Dim Shared udt(TYPEMAX) As tudt
'Dim Shared udtidx As Integer
	For i=16 To TYPEMAX
		udt(i).nm=""
		udt(i).typ=0
		udt(i).lb=0
		udt(i).ub=0
		udt(i).lg=0
	Next
	udtnb=15

'Const CTYPEMAX=10000
'Dim Shared cudt(CTYPEMAX) As tcudt
'Dim Shared cudtnb As Integer
	For i=0 To CTYPEMAX
		cudt(i).nm=""
		cudt(i).typ=0
		cudt(i).ofs=0
		cudt(i).arr=0
		cudt(i).pt=0
	Next
	cudtnb=0

'Const ATYPEMAX=1000
'Dim Shared audt(ATYPEMAX) As taudt
'Dim Shared audtnb As Integer
	For i=0 To ATYPEMAX
		audt(i).dm=0
		For j=0 To 5
			audt(i).nlu(j).nb=0
			audt(i).nlu(j).lb=0
			audt(i).nlu(j).ub=0
		Next
	Next
	audtnb=0

'Const VARMAX=5000
'Dim Shared vrb(VARMAX) As tvar
'Dim Shared vrbnb As UInteger  'nb of variables
	For i=0 To VARMAX
		vrb(i).nm=""
		vrb(i).typ=0
		vrb(i).adr=0
		vrb(i).mem=0
		vrb(i).arr=0
		vrb(i).pt=0
		vrb(i).pn=0
	Next
	vrbnb=0

'Const ARRMAX=1000
'Dim Shared arr(ARRMAX) As tarr
'Dim Shared arrnb As UShort
	For i=0 To ARRMAX
		arr(i).dat=0
		arr(i).pot=0
		arr(i).siz=0
		arr(i).dmn=0
		For j=0 To 5
			arr(i).nlu(j).nb=0
			arr(i).nlu(j).lb=0
			arr(i).nlu(j).ub=0
		Next
	Next
	arrnb=0

'Const LINEMAX=250000
'Dim Shared rline(LINEMAX) As tline
'Dim Shared linenb As UInteger
'Dim Shared linesav As UInteger
	For i=0 To LINEMAX
		rline(i).ad=0
		rline(i).nu=0
		rline(i).sv=0
		rline(i).pr=0
	Next
	linenb=0
	linesav=0

'Const THREADMAX=50
'Dim Shared thread(THREADMAX) As tthread
'Dim Shared threadnb As UInteger
'Dim Shared threadcontext As HANDLE
'Dim Shared threadidx As Integer
	For i=0 To THREADMAX
		thread(i).thread=0
		thread(i).threadret=0
		thread(i).threadid=0
		thread(i).threadres=0
	Next
	threadnb=0
	threadcontext=0
	threadidx=0

'Dim Shared stabnb As Integer
'Const STABMAX=10000
'Dim Shared stab(STABMAX) As String
	For i=0 To STABMAX
		stab(i)=""
	Next
	stabnb=0

	For i=0 To WATCHMAX
		W(i).sVal=Chr(255,254,253)
	Next

	nLnDebug=-1
	hLnDebug=0
	linead=-1
	i=0
	While i<300
		NoDebug(i)=""
		i+=1
	Wend
	mainthread=0
	thisthreadcontext=0
	debugthreadcontext=0
	thislinesav=-1

End Sub

Sub SetSourceProjectInx()
	Dim As UInteger i,j
	
	For i=0 To sourcenb
		For j=0 To bpnb
			If UCase(source(i).file)=UCase(bp(j).sFile) Then
				source(i).pInx=j
				Exit For
			EndIf
		Next
	Next

End Sub

Sub StopDebugging
	Dim lret As Integer

	lret=CloseHandle(dbghand)
	lret=CloseHandle(pinfo.hThread)
	lret=CloseHandle(pinfo.hProcess)
	lret=CloseHandle(hDebugFile)
	lret=CloseHandle(hThread)
	hThread=0
	lpData->fDebug=FALSE
	ClearDebugLine
	LockFiles(FALSE)
	ClearVars
	EnableDebugMenu

End Sub

Function RunFile StdCall (ByVal lpFileName As ZString Ptr) As Integer
	Dim sinfo As STARTUPINFO
	Dim As Integer lret,fContinue,i
	Dim de As DEBUG_EVENT
	Dim buffer As ZString*260
	Dim sException As String
	Dim nln As Integer

	ClearVars
	If lstrlen(@lpData->ProjectFile) Then
		i=0
		While i<300
			GetPrivateProfileString("NoDebug",Str(i),@szNULL,@buffer,SizeOf(buffer),@lpData->ProjectFile)
			If lstrlen(buffer) Then
				NoDebug(i)=UCase(buffer)
			Else
				NoDebug(i)=""
			EndIf
			i+=1
		Wend
	EndIf
	sinfo.cb=SizeOf(STARTUPINFO)
	sinfo.dwFlags=STARTF_USESHOWWINDOW
	sinfo.wShowWindow=SW_NORMAL
	' Create process
	lret=CreateProcess(NULL,lpFileName,NULL,NULL,FALSE,NORMAL_PRIORITY_CLASS Or DEBUG_PROCESS Or DEBUG_ONLY_THIS_PROCESS,NULL,NULL,@sinfo,@pinfo)
	If lret Then
		mpid=pinfo.dwProcessId
		mtid=pinfo.dwThreadId
		WaitForSingleObject(pinfo.hProcess,10)
		dbghand=OpenProcess(PROCESS_ALL_ACCESS,TRUE,pinfo.dwProcessId)
		ParseDebugInfo
		GetBreakPoints
		SetSourceProjectInx
		SetBreakPoints(-1)
		' Debug loop
		While TRUE
			lret=WaitForDebugEvent(@de,INFINITE)
			fContinue=DBG_CONTINUE
			Select Case de.dwDebugEventCode
				Case EXCEPTION_DEBUG_EVENT
					Select Case de.Exception.ExceptionRecord.ExceptionCode
						Case EXCEPTION_BREAKPOINT
							If fExit=0 Then
								findthread(de.dwThreadId)
								If debugthreadcontext=0 Then
									If rline(FindLine(Cast(UInteger,de.Exception.ExceptionRecord.ExceptionAddress))).nu Then
										debugthreadcontext=threadcontext
									EndIf
								EndIf
								If threadcontext=debugthreadcontext Then
									gestbrk(Cast(UInteger,de.Exception.ExceptionRecord.ExceptionAddress),fRun)
								Else
									gestbrk(Cast(UInteger,de.Exception.ExceptionRecord.ExceptionAddress),99)
								EndIf
							Else
								' Stop
								fContinue=DBG_EXCEPTION_NOT_HANDLED
							EndIf
						Case EXCEPTION_ACCESS_VIOLATION
							sException="EXCEPTION_ACCESS_VIOLATION"
							fContinue=DBG_EXCEPTION_NOT_HANDLED
						Case EXCEPTION_FLT_DIVIDE_BY_ZERO
							sException="EXCEPTION_FLT_DIVIDE_BY_ZERO"
							fContinue=DBG_EXCEPTION_NOT_HANDLED
						Case EXCEPTION_INT_DIVIDE_BY_ZERO
							sException="EXCEPTION_INT_DIVIDE_BY_ZERO"
							fContinue=DBG_EXCEPTION_NOT_HANDLED
						Case EXCEPTION_DATATYPE_MISALIGNMENT
							sException="EXCEPTION_DATATYPE_MISALIGNMENT"
							fContinue=DBG_EXCEPTION_NOT_HANDLED
						Case EXCEPTION_SINGLE_STEP
							sException="EXCEPTION_SINGLE_STEP"
							fContinue=DBG_EXCEPTION_NOT_HANDLED
						Case DBG_CONTROL_C
							sException="DBG_CONTROL_C"
							fContinue=DBG_EXCEPTION_NOT_HANDLED
					End Select
					If fContinue=DBG_EXCEPTION_NOT_HANDLED Then
						If de.Exception.dwFirstChance Then
							If fexit=0 Then
								PutString(sException)
								findthread(de.dwThreadId)
								gestbrk(Cast(UInteger,de.Exception.ExceptionRecord.ExceptionAddress),0)
							EndIf
						EndIf
					EndIf
				Case CREATE_PROCESS_DEBUG_EVENT
					'PutString("CREATE_PROCESS_DEBUG_EVENT")
					With de.CreateProcessInfo
						threadnb+=1
						thread(threadnb).thread=.hThread
						thread(threadnb).threadid=de.dwThreadId
						thread(threadnb).threadres=0
						threadcontext=.hThread
						hDebugFile=.hFile
						If mainthread=0 Then
							mainthread=threadcontext
						EndIf
					End With
				Case CREATE_THREAD_DEBUG_EVENT
					PutString("CREATE_THREAD_DEBUG_EVENT Thread=" & de.CreateThread.hThread)
					With de.CreateThread
						For i=0 To threadnb
							If thread(i).thread=0 Then
								Exit For
							EndIf
						Next
						If i>threadnb Then
							threadnb=i
						EndIf
						thread(i).thread=.hThread
						thread(i).threadret=threadcontext
						thread(i).threadid=de.dwThreadId
						thread(i).threadres=99
						threadcontext=.hThread
					End With
				Case EXIT_THREAD_DEBUG_EVENT
					For i=0 To threadnb
						If thread(i).threadid=de.dwThreadId Then
							If debugthreadcontext=thread(i).thread Then
								ClearBreakAll(0)
								SetBreakPoints(-1)
								debugthreadcontext=0
							EndIf
							PutString("EXIT_THREAD_DEBUG_EVENT ExitCode=" & de.ExitThread.dwExitCode & " Exitthread=" & thread(i).thread & " Returnthread=" & thread(i).threadret)
							thread(i).thread=0
							threadcontext=thread(i).threadret
							If nLnDebug=-1 And threadcontext<>0 Then
								lret=ResumeThread(threadcontext)
							EndIf
							Exit For
						EndIf
					Next
				Case EXIT_PROCESS_DEBUG_EVENT
					PutString("EXIT_PROCESS_DEBUG_EVENT ExitCode=" & de.ExitProcess.dwExitCode)
					lret=ContinueDebugEvent(de.dwProcessId,de.dwThreadId,DBG_CONTINUE)
					If fExit Then
						PutString("Terminated by user.")
					EndIf
					Exit While
				Case LOAD_DLL_DEBUG_EVENT
					buffer=""
					GetModuleFileName(de.LoadDll.lpBaseOfDll,@buffer,256)
					PutString("LOAD_DLL_DEBUG_EVENT " & buffer)
				Case UNLOAD_DLL_DEBUG_EVENT
					buffer=""
					GetModuleFileName(de.UnloadDll.lpBaseOfDll,@buffer,256)
					PutString("UNLOAD_DLL_DEBUG_EVENT " & buffer)
				Case OUTPUT_DEBUG_STRING_EVENT
					nln=de.DebugString.nDebugStringLength
					If nln>255 Then
						nln=255
					EndIf
					lret=ReadProcessMemory(dbghand,de.DebugString.lpDebugStringData,@buffer,nln,0)
					PutString(@buffer)
				Case RIP_EVENT
					PutString("RIP_EVENT")
			End Select
			ContinueDebugEvent(de.dwProcessId,de.dwThreadId,fContinue)
		Wend
		' Process ended
		StopDebugging
	EndIf
	Return 0

End Function
