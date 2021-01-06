
Function ExecFunc(ByVal f As Integer,ByRef pres1 As RES,ByRef pres2 As RES) As Integer
	Dim res As RES

	Select Case f
		Case FADD
			' +
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval+pres2.dval
			ElseIf pres1.ntyp=ISTR And pres2.ntyp=ISTR Then
				pres1.sval=pres1.sval & pres2.sval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FSUB
			' -
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval-pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FSHL
			' Shl
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval Shl pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FSHR
			' Shr
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval Shr pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FMOD
			' Mod
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval Mod pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FIDIV
			' \
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval\pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FMUL
			' *
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval*pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FDIV
			' *
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval/pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FNEG
			If pres2.ntyp=INUM Then
				pres1.ntyp=INUM
				pres1.dval=-pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FEXP
			' ^
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval^pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FLE
			' <
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval<pres2.dval
			ElseIf pres1.ntyp=ISTR And pres2.ntyp=ISTR Then
				pres1.dval=pres1.sval<pres2.sval
				pres1.ntyp=INUM
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FLEEQ
			' <=
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval<=pres2.dval
			ElseIf pres1.ntyp=ISTR And pres2.ntyp=ISTR Then
				pres1.dval=pres1.sval<=pres2.sval
				pres1.ntyp=INUM
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FEQ
			' =
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval=pres2.dval
			ElseIf pres1.ntyp=ISTR And pres2.ntyp=ISTR Then
				pres1.dval=pres1.sval=pres2.sval
				pres1.ntyp=INUM
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FNEQ
			' <>
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval<>pres2.dval
			ElseIf pres1.ntyp=ISTR And pres2.ntyp=ISTR Then
				pres1.dval=pres1.sval<>pres2.sval
				pres1.ntyp=INUM
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FGTEQ
			' >=
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval>=pres2.dval
			ElseIf pres1.ntyp=ISTR And pres2.ntyp=ISTR Then
				pres1.dval=pres1.sval>=pres2.sval
				pres1.ntyp=INUM
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FGT
			' >
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval>pres2.dval
			ElseIf pres1.ntyp=ISTR And pres2.ntyp=ISTR Then
				pres1.dval=pres1.sval>pres2.sval
				pres1.ntyp=INUM
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FNOT
			' Not
			If pres2.ntyp=INUM Then
				pres1.dval=Not pres2.dval
				pres1.ntyp=INUM
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FAND
			' And
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval And pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FLOR
			' Or
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval Or pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FXOR
			' Xor
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval Xor pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FEQV
			' Eqv
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval Eqv pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FIMP
			' Imp
			If pres1.ntyp=INUM And pres2.ntyp=INUM Then
				pres1.dval=pres1.dval Imp pres2.dval
			Else
				pres1.ntyp=IERR
				Return -1
			EndIf
		Case FSADD
			' &
			pres1.sval=pres1.sval & pres2.sval
	End Select
	Return 0

End Function

Function ImmFunc(ByRef px As Integer,ByVal n As Integer,ByVal f As Integer,ByRef pres As RES) As Integer
	Dim As Integer l

	Select Case f
		Case INUM
			l=szCompiled[px]
			px+=1
			pres.ntyp=f
			pres.dval=Val(Mid(szCompiled,px+1,l))
			px+=l
		Case ISTR
			l=szCompiled[px]
			px+=1
			pres.ntyp=f
			pres.sval=Mid(szCompiled,px+1,l)
			px+=l
	End Select
	Return 0

End Function

Function ArgFunc(ByRef px As Integer,pres() As RES) As Integer
	Dim As Integer i,lret

	lret=EvalFunc(px,0,pres(i),FALSE)
	i+=1
	While szCompiled[px]=MFUN And szCompiled[px+1]=FCOMMA
		px+=2
		lret=EvalFunc(px,0,pres(i),FALSE)
		i+=1
	Wend
	Return i

End Function

Function NumFunc(ByRef px As Integer,ByVal f As Integer,ByRef pres As RES) As Integer
	Dim lret As Integer
	Dim res(8) As RES

	lret=ArgFunc(px,res())
	pres.ntyp=INUM
	Select Case f
		Case NASC
			If lret=1 And res(0).ntyp=ISTR Then
				pres.dval=Asc(res(0).sval)
			ElseIf lret=2 And res(0).ntyp=ISTR And res(1).ntyp=INUM Then
				pres.dval=Asc(res(0).sval,res(1).dval)
			Else
				GoTo NErr
			EndIf
		Case NLEN
			If lret=1 And res(0).ntyp=ISTR Then
				pres.dval=Len((res(0).sval))
			Else
				GoTo NErr
			EndIf
		Case NINSTR
			If lret=2 And res(0).ntyp=ISTR And res(1).ntyp=ISTR Then
				pres.dval=InStr(res(0).sval,res(1).sval)
			ElseIf lret=3 And res(0).ntyp=INUM And res(1).ntyp=ISTR And res(2).ntyp=ISTR Then
				pres.dval=InStr(res(0).dval,res(1).sval,res(2).sval)
			Else
				GoTo NErr
			EndIf
		Case NINSTRREV
			If lret=2 And res(0).ntyp=ISTR And res(1).ntyp=ISTR Then
				pres.dval=InStrRev(res(0).sval,res(1).sval)
			ElseIf lret=3 And res(0).ntyp=ISTR And res(1).ntyp=ISTR And res(2).ntyp=INUM Then
				pres.dval=InStrRev(res(0).sval,res(1).sval,res(2).dval)
			Else
				GoTo NErr
			EndIf
	End Select
	If szCompiled[px]=MFUN And szCompiled[px+1]=FRPA Then
		px+=2
		Return 0
	EndIf
NErr:
	pres.ntyp=IERR
	Return -1

End Function

Function StrFunc(ByRef px As Integer,ByVal f As Integer,ByRef pres As RES) As Integer
	Dim As Integer lret,i
	Dim res(8) As RES

	lret=ArgFunc(px,res())
	pres.ntyp=ISTR
	Select Case f
		Case SSTR
			If lret=1 And res(0).ntyp=INUM Then
				pres.sval=Str(res(0).dval)
			Else
				GoTo SErr
			EndIf
		Case SCHR
			pres.sval=""
			For i=0 To lret-1
				If res(i).ntyp=INUM Then
					pres.sval &=Chr(res(i).dval)
				Else
					GoTo SErr
				EndIf
			Next
		Case SLEFT,SRIGHT
			If lret=2 And res(0).ntyp=ISTR And res(1).ntyp=INUM Then
				If f=SLEFT Then
					pres.sval=Left(res(0).sval,res(1).dval)
				Else
					pres.sval=Right(res(0).sval,res(1).dval)
				EndIf
			Else
				GoTo SErr
			EndIf
		Case SMID
			If lret=2 And res(0).ntyp=ISTR And res(1).ntyp=INUM Then
				pres.sval=Mid(res(0).sval,res(1).dval)
			ElseIf lret=3 And res(0).ntyp=ISTR And res(1).ntyp=INUM And res(2).ntyp=INUM Then
				pres.sval=Mid(res(0).sval,res(1).dval,res(2).dval)
			Else
				GoTo SErr
			EndIf
		Case SSPACE
			If lret=1 And res(0).ntyp=INUM Then
				pres.sval=Space(res(0).dval)
			Else
				GoTo SErr
			EndIf
		Case SSTRING
			If lret=2 And res(0).ntyp=INUM Then
				If res(1).ntyp=ISTR Then
					pres.sval=String(res(0).dval,res(1).sval)
				Else
					pres.sval=String(res(0).dval,res(1).dval)
				EndIf
			Else
				GoTo SErr
			EndIf
	End Select
	If szCompiled[px]=MFUN And szCompiled[px+1]=FRPA Then
		px+=2
		Return 0
	EndIf
SErr:
	pres.ntyp=IERR
	Return -1

End Function

Function GetVarVal(ByVal typ As Integer,ByVal adr As Integer,ByRef pres As RES) As Integer
	Dim As ZString*512 buff
	Dim As ZString*32 bval
	Dim As Integer l,sadr

	Select Case typ
		Case 0
			' Proc
			' Unknown type
			nErr=5
			Return -1
		Case 1
			' Integer
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@bval,4,0)
				pres.dval=Peek(Integer,@bval)
				pres.ntyp=INUM
			EndIf
		Case 2
			' Byte
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@bval,1,0)
				pres.dval=Peek(Byte,@bval)
				pres.ntyp=INUM
			EndIf
		Case 3
			' UByte
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@bval,1,0)
				pres.dval=Peek(UByte,@bval)
				pres.ntyp=INUM
			EndIf
		Case 4
			' Char
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@buff,65,0)
				If Len(buff)>64 Then
					buff=Left(buff,64) & "..."
				EndIf
				pres.sval=buff
				pres.ntyp=ISTR
			EndIf
		Case 5
			' Short
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@bval,2,0)
				pres.dval=Peek(Short,@bval)
				pres.ntyp=INUM
			EndIf
		Case 6
			' UShort
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@bval,2,0)
				pres.dval=Peek(UShort,@bval)
				pres.ntyp=INUM
			EndIf
		Case 7
			' Void
			' Unknown type
			nErr=5
			Return -1
		Case 8
			' UInteger
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@bval,4,0)
				pres.dval=Peek(UInteger,@bval)
				pres.ntyp=INUM
			EndIf
		Case 9
			' Longint
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@bval,8,0)
				pres.dval=Peek(LongInt,@bval)
				pres.ntyp=INUM
			EndIf
		Case 10
			' ULongint
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@bval,8,0)
				pres.dval=Peek(ULongInt,@bval)
				pres.ntyp=INUM
			EndIf
		Case 11
			' Single
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@bval,4,0)
				pres.dval=Peek(Single,@bval)
				pres.ntyp=INUM
			EndIf
		Case 12
			' Double
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@bval,8,0)
				pres.dval=Peek(Double,@bval)
				pres.ntyp=INUM
			EndIf
		Case 13
			' String
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@bval,12,0)
				pres.sval=""
				adr=Peek(Integer,@bval)
				l=Peek(Integer,@bval+4)
				If adr>0 And l>0 Then
					pres.sval=Space(l)
					sadr=Peek(Integer,@pres.sval)
					ReadProcessMemory(dbghand,Cast(Any Ptr,adr),Cast(Any Ptr,sadr),l,0)
				EndIf
				pres.ntyp=ISTR
			EndIf
		Case 14
			' ZString
			If adr Then
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@buff,65,0)
				If Len(buff)>64 Then
					buff=Left(buff,64) & "..."
				EndIf
				pres.sval=buff
				pres.ntyp=ISTR
			EndIf
		Case 15
			' PChar
			' Unknown type
			nErr=5
			Return -1
		Case Else
			' Unknown type
			nErr=5
			Return -1
	End Select
	Return 0

End Function

Function GetArrOfs(ByRef px As Integer,ByVal typ As Integer,ByVal lpArr As tarr Ptr,ByVal lpUdtArr As taudt ptr) As Integer
	Dim As Integer i,n,siz,ofs
	Dim arr(8) As RES

	If szCompiled[px]=MFUN And szCompiled[px+1]=FLPA Then
		' Array
		If lpArr<>0 Or lpUdtArr<>0 Then
			px+=2
			n=ArgFunc(px,arr())
			If szCompiled[px]=MFUN And szCompiled[px+1]=FRPA Then
				px+=2
				siz=udt(typ).lg
				If lpArr Then
					If n=lpArr->dmn Then
						For i=n-1 To 0 Step -1
							If arr(i).ntyp=INUM Then
								If arr(i).dval<lpArr->nlu(i).lb Or arr(i).dval>lpArr->nlu(i).ub Then
									' Index out of range
									nErr=4
									Return -1
								EndIf
							Else
								' Syntax error
								nErr=1
								Return -1
							EndIf
							ofs+=siz*arr(i).dval
							siz*=(lpArr->nlu(i).ub+1)
						Next
					Else
						' Index out of range
						nErr=4
						Return -1
					EndIf
				Else
					If n=lpUdtArr->dm Then
						For i=n-1 To 0 Step -1
							If arr(i).ntyp=INUM Then
								If arr(i).dval<lpUdtArr->nlu(i).lb Or arr(i).dval>lpUdtArr->nlu(i).ub Then
									' Index out of range
									nErr=4
									Return -1
								EndIf
							Else
								' Syntax error
								nErr=1
								Return -1
							EndIf
							ofs+=siz*arr(i).dval
							siz*=(lpUdtArr->nlu(i).ub+1)
						Next
					Else
						' Index out of range
						nErr=4
						Return -1
					EndIf
				EndIf
			Else
				' Syntax error
				nErr=1
				Return -1
			EndIf
		Else
			' Array given, but not array
			nErr=1
			Return -1
		EndIf
	ElseIf lpArr<>0 Or lpUdtArr<>0 Then
		' Array, but no array given
		nErr=1
		Return -1
	EndIf
	Return ofs

End Function

Function IsLocal(ByVal svar As String) As Integer
	Dim i As Integer

	i=1
	While i<=vrbnb
		If svar=vrb(i).nm And vrb(i).pn=procsv Then
			Return i
		EndIf
		i+=1
	Wend
	Return 0

End Function

Function IsGlobal(ByVal svar As String) As Integer
	Dim i As Integer

	i=1
	While i<=vrbnb
		If svar=vrb(i).nm And vrb(i).pn=0 Then'<0 And vrb(i).sr=proc(procsv).sr Then
			Return i
		EndIf
		i+=1
	Wend
	Return 0

End Function

Function GetVarAdr(ByRef px As Integer,ByRef typ As Integer) As Integer
	Dim As Integer i,adr,ofs,fGlobal,fParam
	Dim svar As ZString*256
	Dim lpArr As tarr Ptr

	i=szCompiled[px]
	px+=1
	svar=UCase(Mid(szCompiled,px+1,i))
	px+=i
Again:
	i=1
	adr=0
	i=IsLocal(svar)
	If i=0 Then
		i=IsGlobal(svar)
	EndIf
	If i Then
		typ=vrb(i).typ
		Select Case vrb(i).mem
			Case 1
				' Shared
				adr=vrb(i).adr
				fGlobal=1
				'
			Case 2
				' Static
				adr=vrb(i).adr
				fGlobal=1
				'
			Case 3
				' ByRef
				adr=ebp_this+vrb(i).adr
				ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@adr,4,0)
				fParam=2
				'
			Case 4
				' ByVal
				adr=ebp_this+vrb(i).adr
				fParam=1
				'
			Case 5
				' Local
				adr=ebp_this+vrb(i).adr
				'
			Case 6
				' Common
				adr=vrb(i).adr
				fGlobal=1
				'
			Case Else
				nErr=5
				Return -1
		End Select
		ofs=GetArrOfs(px,typ,vrb(i).arr,0)
		If ofs=-1 Then
			Return -1
		EndIf
		adr+=ofs
Nxt:
		If typ>15 Then
			' UDT
			If szCompiled[px]=UFUN And szCompiled[px+1]=UFUN Then
				px+=2
				i=szCompiled[px]
				px+=1
				svar=UCase(Mid(szCompiled,px+1,i))
				px+=i
				For i=udt(typ).lb To udt(typ).ub
					If svar=cudt(i).nm Then
						adr+=cudt(i).ofs
						typ=cudt(i).typ
						If cudt(i).arr Then
							ofs=GetArrOfs(px,typ,0,@audt(cudt(i).arr))
						Else
							ofs=GetArrOfs(px,typ,0,0)
						EndIf
						If ofs=-1 Then
							Return -1
						EndIf
						adr+=ofs
						Exit For
					EndIf
				Next
				GoTo Nxt
			Else
				If udt(typ).lb=udt(typ).ub And cudt(udt(typ).lb).nm="I" Then
					' Foreign Integer
					typ=1
				Else
					nErr=1
					Return -1
				EndIf
			EndIf
		EndIf
		Return adr
	Else
		If szCompiled[px]=UFUN And szCompiled[px+1]=UFUN Then
			' Namespace
			px+=2
			i=szCompiled[px]
			px+=1
			svar="NS : " & svar & "." & UCase(Mid(szCompiled,px+1,i))
			px+=i
			GoTo Again
		EndIf
	EndIf
	nErr=3
	Return -1

End Function

Function VarFunc(ByRef px As Integer,ByRef pres As RES,ByRef typ As Integer) As Integer
	Dim As Integer adr,lret

	If hThread Then
		adr=GetVarAdr(px,typ)
		If adr=-1 Then
			Return -1
		EndIf
		Return GetVarVal(typ,adr,pres)
	EndIf
	' Only in debug mode
	nErr=2
	Return -1

End Function

Function EvalFunc(ByRef px As Integer,ByVal pf As Integer,ByRef pres As RES,ByVal bset As Integer) As Integer
	Dim As Integer n,f,lret,typ
	Dim res As RES

	While TRUE
Nxt:
		If lret=-1 Then
			pres.ntyp=IERR
			Return -1
		EndIf
		n=szCompiled[px]
		f=szCompiled[px+1]
		Select Case n
			Case IFUN
				px+=2
				lret=ImmFunc(px,n,f,res)
				GoTo Nxt
			Case NFUN
				px+=2
				If szCompiled[px]=MFUN And szCompiled[px+1]=FLPA Then
					px+=2
					lret=NumFunc(px,f,res)
					GoTo Nxt
				EndIf
				pres.ntyp=IERR
				Return -1
			Case SFUN
				px+=2
				If szCompiled[px]=MFUN And szCompiled[px+1]=FLPA Then
					px+=2
					lret=StrFunc(px,f,res)
					GoTo Nxt
				EndIf
				pres.ntyp=IERR
				Return -1
			Case VFUN
				px+=2
				If bset Then
					pres.dval=GetVarAdr(px,typ)
					pres.ntyp=typ
					If pres.dval=-1 Then
						Return -1
					EndIf
					If szCompiled[px]=MFUN And szCompiled[px+1]=FEQ Then
						px+=2
					Else
						nErr=1
						Return -1
					EndIf
					Return 0
				Else
					lret=VarFunc(px,res,typ)
					GoTo Nxt
				EndIf
			Case 0,MFUN
				Select Case f
					Case FLPA
						px+=2
						lret=EvalFunc(px,f,res,FALSE)
						If szCompiled[px]=MFUN And szCompiled[px+1]=FRPA Then
							px+=2
							lret=ExecFunc(pf,pres,res)
							GoTo Nxt
						Else
							pres.ntyp=IERR
							Return -1
						EndIf
					Case FRPA,FCOMMA
						f=0
				End Select
				Select Case pf
					Case FXOR,FIMP,FEQV
						' Xor, Imp, Eqv
						If f<FLOR Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FLOR
						' Or
						If f<FAND Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FAND
						' And
						If f<FNOT Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FNOT
						' Not
						If f<FGTEQ Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FGTEQ
						' >=
						If f<FLEEQ Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FLEEQ
						' <=
						If f<FGT Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FGT
						' >
						If f<FLE Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FLE
						' <
						If f<FNEQ Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FNEQ
						' <>
						If f<FEQ Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FEQ
						' =
						If f<FADD Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FADD,FSUB
						' +,-
						If f<FSHL Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FSHL,FSHR
						' Shl, Shr
						If f<FMOD Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FMOD
						' Mod
						If f<FIDIV Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FIDIV
						' \
						If f<FMUL Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FMUL,FDIV
						' *,/
						If f<FNEG Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FNEG
						' -
						If f<FEXP Then
							Return ExecFunc(pf,pres,res)
						EndIf
					Case FEXP
						' ^
						Return ExecFunc(pf,pres,res)
					Case FSADD
						' &
						Return ExecFunc(pf,pres,res)
				End Select
			Case Else
				Return -1
		End Select
		If f Then
			px+=2
			lret=EvalFunc(px,f,res,FALSE)
		Else
			pres.ntyp=res.ntyp
			pres.dval=res.dval
			pres.sval=res.sval
			Return 0
		EndIf
	Wend
	pres.ntyp=IERR
	Return -1

End Function

Function FindFunction(lpBuff As ZString Ptr) As Integer
	Dim x As Integer
	Dim buff As ZString*256

	buff=LCase(*lpBuff)
	For x=0 To 255
		If buff=fn(x).szText Then
			*lpBuff=buff
			Return fn(x).nID
		EndIf
	Next
	Return 0

End Function

Sub AddFunction(n As Integer,ftyp As Integer,lpBuff As ZString Ptr)

	Select Case n
		Case IFUN,VFUN
			szCompiled &=Chr(n) & Chr(ftyp) & Chr(Len(*lpBuff)) & *lpBuff
			*lpBuff=""
		Case UFUN
			If Left(*lpBuff,1)="." Then
				' .
				*lpBuff=Mid(*lpBuff,2)
			Else
				' ->
				*lpBuff=Mid(*lpBuff,3)
			EndIf			
			szCompiled &=Chr(n) & Chr(ftyp) & Chr(Len(*lpBuff)) & *lpBuff
			*lpBuff=""
		Case MFUN,NFUN,SFUN
			szCompiled &=Chr(n) & Chr(ftyp)
			*lpBuff=""
	End Select

End Sub

Function Compile(lpLine As ZString Ptr) As Integer
	Dim As Integer i,x,c,c2,ftyp,npara
	Dim buff As ZString*512
	
	szCompiled=String(SizeOf(szCompiled),0)
	For x=0 To Len(*lpLine)-1
		c=lpLine[x]
		c2=lpLine[x+1]
		If ftyp=ISTR Then
			If c=34 Then
				AddFunction(IFUN,ftyp,@buff)
				ftyp=0
			Else
				buff &=Chr(c)
			EndIf
		ElseIf (c>=48 And c<=57) Then
			'0 to 9
			If ftyp=INUM Or (ftyp=0 And Len(buff)=0) Then
				buff &=Chr(c)
				ftyp=INUM
			ElseIf ftyp=0 Then
				buff &=Chr(c)
			Else
				nErr=1
				Return -1
			EndIf
		ElseIf c=46 Then
			' .
			c=lpLine[x+1]
			If ftyp=INUM Then
				buff &="."
			ElseIf ftyp=0 And Len(buff)=0 And c>=48 And c<=57 Then
				buff &="."
				ftyp=INUM
			ElseIf ftyp=0 Then
				If Len(buff) Then
					' Variable
					If hThread Then
						If Left(buff,1)="." Or Left(buff,2)="->" Then
							AddFunction(UFUN,UFUN,@buff)
						Else
							AddFunction(VFUN,VFUN,@buff)
						EndIf
					Else
						nErr=2
						Return -1
					EndIf
				EndIf
				buff="."
			Else
				nErr=1
				Return -1
			EndIf
		ElseIf c=45 And c2=63 Then
			' ->
			x+=1
			If Len(buff) Then
				' Variable
				If hThread Then
					If Left(buff,1)="." Or Left(buff,2)="->" Then
						AddFunction(UFUN,UFUN,@buff)
					Else
						AddFunction(VFUN,VFUN,@buff)
					EndIf
				Else
					nErr=2
					Return -1
				EndIf
			EndIf
			buff="->"
		ElseIf c=34 Then
			' "
			If ftyp=0 Then
				buff=""
				ftyp=ISTR
			Else
				nErr=1
				Return -1
			EndIf
		ElseIf c=32 Or c=9 Or c=40 Or c=41 Or c=43 Or c=45 Or c=42 Or c=47 Or c=94 Or c=60 Or c=61 Or c=62 Or c=38 Or c=44 Or c=92 Then
			' (, ), +, -, *, /, ^, <, =, >, &, \, ,
			If buff<>"" Then
				If ftyp Then
					AddFunction(IFUN,ftyp,@buff)
				Else
					ftyp=FindFunction(@buff)
					If ftyp Then
						If ftyp<32 then
							' Math
							AddFunction(MFUN,ftyp,@buff)
						ElseIf ftyp<128 Then
							' Numeric
							AddFunction(NFUN,ftyp,@buff)
						Else
							' String
							AddFunction(SFUN,ftyp,@buff)
						EndIf
					Else
						' Variable
						If hThread Then
							If Left(buff,1)="." Or Left(buff,2)="->" Then
								AddFunction(UFUN,UFUN,@buff)
							Else
								AddFunction(VFUN,VFUN,@buff)
							EndIf
						Else
							nErr=2
							Return -1
						EndIf
					EndIf
				EndIf
			EndIf
			If c<>32 And c<>9 Then
				buff=Chr(c)
				If c=60 Then
					' <
					c=lpLine[x+1]
					If c=61 Or c=62 Then
						' <=, <>
						buff &=Chr(c)
						x+=1
					EndIf
				ElseIf c=62 Then
					' >
					c=lpLine[x+1]
					If c=61 Then
						' >=
						buff &=Chr(c)
						x+=1
					EndIf
				EndIf
				ftyp=FindFunction(@buff)
				If ftyp=FSUB Then
					i=Len(szCompiled)
					If i>1 Then
						If szCompiled[i-2]=MFUN Then
							If szcompiled[i-1]=FSUB Then
								szCompiled[i-1]=FADD
								buff=""
								ftyp=0
							ElseIf szcompiled[i-1]=FADD Then
								szCompiled[i-1]=FSUB
								buff=""
								ftyp=0
							ElseIf szcompiled[i-1]=FNEG Then
								szcompiled=Left(szcompiled,i-2)
								buff=""
								ftyp=0
							Else
								ftyp=FNEG
							EndIf
						EndIf
					ElseIf i=0 Then
						ftyp=FNEG
					EndIf
				EndIf
				If ftyp Then
					AddFunction(MFUN,ftyp,@buff)
					If ftyp=FLPA Then
						npara+=1
					ElseIf ftyp=FRPA Then
						npara-=1
					EndIf
				EndIf
			EndIf
			ftyp=0
		Else
			buff &=Chr(c)
		EndIf
	Next
	If buff<>"" Then
		If ftyp Then
			AddFunction(IFUN,ftyp,@buff)
		Else
			ftyp=FindFunction(@buff)
			If ftyp Then
				If ftyp<32 Then
					' Math
					AddFunction(MFUN,ftyp,@buff)
				ElseIf ftyp<128 Then
					' Numeric
					AddFunction(NFUN,ftyp,@buff)
				Else
					' String
					AddFunction(SFUN,ftyp,@buff)
				EndIf
			Else
				' Variable
				If hThread Then
					If Left(buff,1)="." Or Left(buff,2)="->" Then
						AddFunction(UFUN,UFUN,@buff)
					Else
						AddFunction(VFUN,VFUN,@buff)
					EndIf
				Else
					nErr=2
					Return -1
				EndIf
			EndIf
		EndIf
	EndIf
	If npara Then
		nErr=1
		Return -1
	EndIf
	'buff=" ("
	'For i=0 To Len(szCompiled)
	'	buff &=Str(szCompiled[i]) & ","
	'Next
	'buff=Left(buff,Len(buff)-1) & ")"
	'SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@buff))
	Return 0

End Function

Sub WatchVars
	Dim i As Integer
	Dim szLine As ZString*256
	Dim buff As ZString*4096
	Dim x As Integer
	Dim typ As Integer
	Dim res As RES
	Dim bRed As Boolean

	If W(0).sVar<>"" Then
		SendMessage(lpHandles->himm,WM_SETTEXT,0,0)
		For i=0 To WATCHMAX
			If W(i).sVar<>"" Then
				bRed=FALSE
				szLine=W(i).sVar
				Compile(@szLine)
				x=2
				If VarFunc(x,res,typ)<>-1 Then
					If res.ntyp=INUM Then
						buff=W(i).sVar & "=" & Str(res.dval) & szCRLF
						If W(i).sVal<>Str(res.dval) Then
							bRed=TRUE
							W(i).sVal=Str(res.dval)
						EndIf
					ElseIf res.ntyp=ISTR Then
						buff=W(i).sVar & "=" & Chr(34) & res.sval & Chr(34) & szCRLF
						If W(i).sVal<>res.sval Then
							bRed=TRUE
							W(i).sVal=res.sval
						EndIf
					EndIf
				Else
					buff=W(i).sVar & " Variable not found. " & szCRLF
				EndIf
				SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@buff))
				If bRed Then
					SendMessage(lpHandles->himm,REM_LINEREDTEXT,i,TRUE)
				EndIf
			EndIf
		Next
	EndIf

End Sub

Function Immediate() As Integer
	Dim buff As ZString*256
	Dim As Integer lret,x,adr,typ,ival,sadr,i,j
	Dim As Single sval
	Dim As LongInt lval
	Dim res As RES

	nErr=0
	buff=String(SizeOf(buff),0)
	lret=SendMessage(lpHandles->himm,EM_GETSEL,0,0)
	lret=LoWord(lret)
	lret=SendMessage(lpHandles->himm,EM_LINEFROMCHAR,lret,0)
	buff[0]=255
	lret=SendMessage(lpHandles->himm,EM_GETLINE,lret,Cast(LPARAM,@buff))
	buff[lret]=0
	If Left(buff,1)="?" Then
		buff=Mid(buff,2)
		lret=Compile(@buff)
		If lret=0 Then
			x=0
			lret=EvalFunc(x,0,res,FALSE)
			If lret=0 Then
				Select Case res.ntyp
					Case INUM
						buff=szCRLF & Str(res.dval) & szCRLF
						SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@buff))
					Case ISTR
						buff=szCRLF & res.sval & szCRLF
						SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@buff))
				End Select
			EndIf
		EndIf
	ElseIf InStr(buff,"=") Then
		If hThread Then
			' Only in debug mode
			lret=Compile(@buff)
			If lret=0 Then
				lret=EvalFunc(x,0,res,TRUE)
				If lret=0 Then
					adr=res.dval
					typ=res.ntyp
					lret=EvalFunc(x,0,res,FALSE)
					If lret=0 Then
						If res.ntyp=INUM Then
							Select Case typ
								Case 1,8,2,3,5,6
									' Integer, UInteger, Byte, UByte, Short, UShort
									ival=res.dval
									WriteProcessMemory(dbghand,Cast(Any Ptr,adr),@ival,udt(typ).lg,0)
								Case 9,10
									' Longint, ULongint
									lval=res.dval
									WriteProcessMemory(dbghand,Cast(Any Ptr,adr),@lval,8,0)
								Case 11
									' Single
									sval=res.dval
									WriteProcessMemory(dbghand,Cast(Any Ptr,adr),@lval,4,0)
								Case 12
									' Double
									WriteProcessMemory(dbghand,Cast(Any Ptr,adr),@res.dval,8,0)
								Case Else
									nErr=6
									lret=-1
							End Select
						Else
							Select Case typ
								Case 4
									' Char
									buff=res.sval
									WriteProcessMemory(dbghand,Cast(Any Ptr,adr),@buff,Len(buff)+1,0)
								Case 13
									' String
									ReadProcessMemory(dbghand,Cast(Any Ptr,adr),@buff,12,0)
									x=Peek(Integer,@buff+8)
									If Len((res.sval))<x Then
										x=Len((res.sval))
										WriteProcessMemory(dbghand,Cast(Any Ptr,adr+4),@x,4,0)
										adr=Peek(Integer,@buff)
										sadr=Peek(Integer,@res.sval)
										WriteProcessMemory(dbghand,Cast(Any Ptr,adr),Cast(Any Ptr,sadr),x,0)
									Else
										nErr=7
										lret=-1
									EndIf
								Case 14
									' ZString
									buff=res.sval
									WriteProcessMemory(dbghand,Cast(Any Ptr,adr),@buff,Len(buff)+1,0)
								Case Else
									nErr=6
									lret=-1
							End Select
						EndIf
						If lret=0 Then
							SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@szCRLF))
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			nErr=2
			lret=-1
		EndIf
	ElseIf UCase(buff)="UDT" Then
		If hThread Then
			' Only in debug mode
			SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@szCRLF))
			For x=1 To udtnb
				buff=Str(x) & " " & udt(x).nm & Chr(9) & Str(udt(x).typ)
				buff=buff & szCRLF
				SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@buff))
			Next
		EndIf
	ElseIf UCase(buff)="DUMP" Then
		If hThread Then
			' Only in debug mode
			SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@szCRLF))
			For x=1 To vrbnb
				Select Case vrb(x).mem
					Case 1
						buff="Shared"
						'
					Case 2
						buff="Static"
						'
					Case 3
						buff="ByRef"
						'
					Case 4
						buff="ByVal"
						'
					Case 5
						buff="Local"
						'
					Case 6
						buff="Common"
						'
					Case Else
						buff="Unknown"
				End Select
				If vrb(x).arr Then
					If vrb(x).arr<&H400000 Then
						buff=buff & " " & vrb(x).nm & "() As " & udt(vrb(x).typ).nm
					Else
						buff=buff & " " & vrb(x).nm & "("
						For i=0 To vrb(x).arr->dmn-1
							buff=buff & Str(vrb(x).arr->nlu(i).lb) & " To " & Str(vrb(x).arr->nlu(i).ub) & ","
						Next
						buff=Left(buff,Len(buff)-1) & ") As " & udt(vrb(x).typ).nm
					EndIf
				Else
					buff=buff & " " & vrb(x).nm & " As " & udt(vrb(x).typ).nm
				EndIf
				buff=buff & szCRLF
				SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@buff))
			Next
		Else
			nErr=2
			lret=-1
		EndIf
	ElseIf UCase(Left(buff,8))="DUMP VRB" Then
		If hThread Then
			' Only in debug mode
			SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@szCRLF))
			buff=UCase(Trim(Mid(buff,9)))
			For x=1 To vrbnb
				If vrb(x).nm=buff Then
					recup="vrb(i).nm=" & vrb(x).nm & " vrb(i).typ=" & Str(vrb(x).typ) & " vrb(i).sr=" & Str(vrb(x).sr) & " vrb(i).adr=" & Str(vrb(x).adr) & " vrb(i).mem=" & Str(vrb(x).mem) & " vrb(i).arr=" & Str(vrb(x).arr) & " vrb(i).pt=" & Str(vrb(x).pt) & " vrb(i).pn=" & Str(vrb(x).pn)
					recup=recup & szCRLF
					SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@recup))
				EndIf
			Next
			recup="procsv=" & Str(procsv) & " proc(procsv).nm=" & proc(procsv).nm & " proc(procsv).sr=" & Str(proc(procsv).sr) & szCRLF
			SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@recup))
		Else
			nErr=2
			lret=-1
		EndIf
	ElseIf UCase(Left(buff,4))="DUMP" Then
		If hThread Then
			' Only in debug mode
			SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@szCRLF))
			buff=UCase(Trim(Mid(buff,5)))
			For i=1 To udtnb
				If buff=udt(i).nm Then
					For x=udt(i).lb To udt(i).ub
						If cudt(x).arr Then
							recup=cudt(x).nm & "("
							For j=0 To audt(cudt(x).arr).dm-1
								recup=recup & Str(audt(cudt(x).arr).nlu(j).lb) & " To " & Str(audt(cudt(x).arr).nlu(j).ub) & ","
							Next
							recup=Left(recup,Len(recup)-1) & ")"
						Else
							recup=cudt(x).nm
						EndIf
						recup=recup & " As "  & udt(cudt(x).typ).nm & szCRLF
						SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@recup))
					Next
					Exit For
				EndIf
			Next
		Else
			nErr=2
			lret=-1
		EndIf
	ElseIf Left(UCase(buff),5)="WATCH" Then
		SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@szCRLF))
		For i=0 To WATCHMAX
			W(i).sVar=""
			W(i).sVal=Chr(255,254,253)
		Next
		buff=Trim(Mid(buff,6))
		i=0
		While Len(buff) And i<30
			x=InStr(buff,",")
			If x Then
				W(i).sVar=Left(buff,x-1)
				buff=Trim(Mid(buff,x+1))
			Else
				W(i).sVar=buff
				buff=""
			EndIf
			i+=1
		Wend
	ElseIf UCase(buff)="STABS" Then
		If hThread Then
			' Only in debug mode
			SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@szCRLF))
			For x=1 To stabnb
				recup=stab(x) & szCRLF
				SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@recup))
			Next
		Else
			nErr=2
			lret=-1
		EndIf
	ElseIf UCase(buff)="FILES" Then
		If hThread Then
			' Only in debug mode
			SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@szCRLF))
			For x=1 To sourcenb
				recup=source(x).file & szCRLF
				SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@recup))
			Next
		Else
			nErr=2
			lret=-1
		EndIf
	ElseIf UCase(buff)="STAT" Then
		If hThread Then
			' Only in debug mode
			SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@szCRLF))
			buff="Number of procs: " & Str(procnb) & szCRLF
			SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@buff))
			buff="Number of variables: " & Str(vrbnb) & szCRLF
			SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@buff))
			buff="Number of code producing lines: " & Str(linenb) & szCRLF
			SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@buff))
			buff="Number of UDT's: " & Str(udtnb) & szCRLF
			SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@buff))
		Else
			nErr=2
			lret=-1
		EndIf
	Else
		nErr=1
		lret=-1
	EndIf
	If lret=-1 Then
		Select Case nErr
			Case 1
				buff="Syntax error"
			Case 2
				buff="Variables only in debug mode"
			Case 3
				buff="Variable not found"
			Case 4
				buff="Index out of range"
			Case 5
				buff="Unknown variable type"
			Case 6
				buff="Type mismatch"
			Case 7
				buff="String too long"
			Case 8
				buff="Not in current scope"
			Case 9
				buff="Unknown source"
			Case Else
				buff="Unknown error"
		End Select
		buff=szCRLF & buff & szCRLF
		SendMessage(lpHandles->himm,EM_REPLACESEL,0,Cast(LPARAM,@buff))
	EndIf
	Return 0

End Function
