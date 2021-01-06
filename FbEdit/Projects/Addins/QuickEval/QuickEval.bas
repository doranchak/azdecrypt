/'
	
	QuickEval Addin by Aleksandar Ruzicic
	
	adds simple and fast evaluation of expressions typed in Output window 

'/

#Include Once "windows.bi"
#Include Once "win/commctrl.bi"
#Include Once "win/richedit.bi"

#Include Once "vbcompat.bi"

#Include "../../Inc/Addins.bi"

#Include "QuickEval.bi"
#Include "exception.bi"


DIM_AS_EXCEPTION( SYNTAX_ERROR,					1, "Syntax error" 				)
DIM_AS_EXCEPTION( UNEXPECTED_TOKEN,				2, "Unexpected token"			)
DIM_AS_EXCEPTION( DIVISION_BY_ZERO,				3, "Division by zero"			)
DIM_AS_EXCEPTION( BRACE_MISSING,					4, "Unbalanced parentheses"	)
DIM_AS_EXCEPTION( ARGUMENT_COUNT_MISSMATCH,	5, "Argument count missmatch"	)
DIM_AS_EXCEPTION( UNCLOSED_STRING_CONSTANT,	6, "Unclosed string constant"	)


#Define END_OF_LINE	Chr(0)
#Define WHITESPACE	Chr(9, 32)
#Define OPERATORS		"^/*&,+\-<.>="
#Define DELIMITERS 	(!"(\")" + OPERATORS + WHITESPACE + END_OF_LINE)

Namespace Eval

	Dim Shared As Integer 		position
	Dim Shared As Integer		length
	Dim Shared As String 		expression
	Dim Shared As String * 1	lookahead

End Namespace

Function Evaluate(expression As String) As String
	
	Dim As String retVal = ""
	
	TRY
		
		Eval.expression = expression
		Eval.length = Len(expression)
		Eval.position = 1
		Eval.lookahead = Left(expression, 1)
		
		SkipWhite
		
		retVal = EvalExpression
		
		If Eval.position < Eval.length + 1 Then THROWNEW( SYNTAX_ERROR )
		
	CATCH_ANY( e )
		
		retVal = e->msg
	
	END_TRY
	
	Return retVal
	
End Function


Sub NextChar
	
	Eval.position += 1
	
	If Eval.position > Eval.length Then
	
		Eval.lookahead = END_OF_LINE
		
	Else
		
		Eval.lookahead = Mid(Eval.expression, Eval.position, 1)
			
	EndIf
	
End Sub

Function LookString(length As Integer) As String
		
	Return LCase(Mid(Eval.expression, Eval.position, length))
		
End Function

Function MatchString(token As String) As Integer
	
	If LookString(Len(token)) = LCase(token) Then
		
		If InStr(Mid(Eval.expression, Eval.position + Len(token), 1), Any DELIMITERS) > 0 Then
			
			SkipToken Len(token)
			
			Return -1
			
		EndIf
		
	EndIf
	
	Return 0
	
End Function


Function MatchOperator(token As String) As Integer
	
	SkipWhite
	
	If LookString(Len(token)) = token Then
		
		If InStr(Mid(Eval.expression, Eval.position + Len(token), 1), Any OPERATORS) < 1 Then
				
			SkipToken Len(token)
			
			Return -1	
			
		EndIf
				
	EndIf
	
	Return 0
		
End Function


Sub Match(char As String)
	
	SkipWhite
	
	If Eval.lookahead <> char Then THROWNEW(UNEXPECTED_TOKEN) 
		
	NextChar
	
	SkipWhite
	
End Sub


Sub SkipToken(length As Integer)
	
	Eval.position += length - 1
	
	NextChar
	
	SkipWhite
	
End Sub


Sub SkipWhite
	
	While InStr(Eval.lookahead, Any Chr(32, 9)) > 0
		
		NextChar
		
	Wend
	
End Sub


'
'	<Or Exp> Xor	<Expression>  
'  <Or Exp> Imp	<Expression>
'  <Or Exp> Eqv	<Expression>
'  <Or Exp> 
'
Function EvalExpression As String
	
	Dim As String lhs = EvalAndExp
	
	If MatchString("Xor") Then
		
		lhs = Str(Val(lhs) Xor Val(EvalExpression))
	
	ElseIf MatchString("Imp") Then
		
		lhs = Str(Val(lhs) Imp Val(EvalExpression))
	
	ElseIf MatchString("Eqv") Then
		
		lhs = Str(Val(lhs) Eqv Val(EvalExpression))
		
	EndIf
	
	Return lhs
		
End Function


'
'	<And Exp> Or	<Or Exp>
'
Function EvalOrExp As String
	
	Dim As String lhs = EvalAndExp
	
	If MatchString("Or") Then
		
		lhs = Str(Val(lhs) Or Val(EvalOrExp))
	
	EndIf
	
	Return lhs
	
End Function

'
'  <Not Exp> And	<And Exp>  
'  <Not Exp>
'
Function EvalAndExp As String
	
	Dim As String lhs = EvalNotExp
	
	If MatchString("And") Then
		
		lhs = Str(Val(lhs) And Val(EvalAndExp))
		
	EndIf
	
	Return lhs
	
End Function

'
'  Not	<Compare Exp>
'  <Compare Exp>
'
Function EvalNotExp As String
	
	If MatchString("Not") Then
		
		Return Str(Not Val(EvalCompareExp))
		
	EndIf
	
	Return EvalCompareExp
		
End Function

' 
'	<Shift Exp> =	<Compare Exp>
'	<Shift Exp> <>	<Compare Exp>
'	<Shift Exp> ><	<Compare Exp>
'	<Shift Exp> <	<Compare Exp>
'	<Shift Exp> >	<Compare Exp>
'	<Shift Exp> <=	<Compare Exp>
'	<Shift Exp> =<	<Compare Exp>
'	<Shift Exp> >=	<Compare Exp>
'	<Shift Exp> =>	<Compare Exp>
'	<Shift Exp>
'
Function EvalCompareExp As String
	
	Dim As String lhs = EvalShiftExp
	
	If MatchOperator("=") Then
		
		lhs = Str(Val(lhs) = Val(EvalCompareExp))
	
	ElseIf MatchOperator("<>") Or MatchOperator("><") Then
		
		lhs = Str(Val(lhs) <> Val(EvalCompareExp))
	
	ElseIf MatchOperator("<") Then
		
		lhs = Str(Val(lhs) < Val(EvalCompareExp))
	
	ElseIf MatchOperator(">") Then
		
		lhs = Str(Val(lhs) > Val(EvalCompareExp))
	
	ElseIf MatchOperator("<=") Or MatchOperator("=<") Then
		
		lhs = Str(Val(lhs) <= Val(EvalCompareExp))
	
	ElseIf MatchOperator(">=") Or MatchOperator("=>") Then
		
		lhs = Str(Val(lhs) >= Val(EvalCompareExp))
	
	EndIf
	
	Return lhs
	
End Function


'
'  <Add Exp> Shl	<Shift Exp>
'  <Add Exp> Shr	<Shift Exp>
'  <Add Exp>  
'
Function EvalShiftExp As String
	
	Dim As String lhs = EvalAddExp
	
	If MatchString("Shl") Then
		
		lhs = Str(ValInt(lhs) Shl ValInt(EvalShiftExp))
		
	ElseIf MatchString("Shr") Then
		
		lhs = Str(ValInt(lhs) Shr ValInt(EvalShiftExp))

	EndIf
	
	Return lhs
	
End Function


'
'  <Mod Exp> +	<Add Exp> 
'  <Mod Exp> -	<Add Exp>
'  <Mod Exp> &	<Add Exp>
'  <Mod Exp>  
'
Function EvalAddExp As String
	
	Dim As String lhs = EvalModExp
	
	If MatchOperator("+") Then
		
		lhs = Str(Val(lhs) + Val(EvalAddExp))
		
	ElseIf MatchOperator("-") Then
		
		lhs = Str(Val(lhs) - Val(EvalAddExp))
	
	ElseIf MatchOperator("&") Then
		
		lhs = lhs + EvalAddExp

	EndIf
	
	Return lhs
	
End Function


'
'  <Int Div Exp> Mod	<Mod Exp>
'  <Int Div Exp>  
'
Function EvalModExp As String
	
	Dim As String lhs = EvalIntDivExp
	
	If MatchString("Mod") Then
		
		Dim As Double rhs = Val(EvalModExp)
		
		If rhs = 0 Then THROWNEW( DIVISION_BY_ZERO )
		
		lhs = Str(Val(lhs) Mod rhs)
		
	EndIf
	
	Return lhs
	
End Function


'
'  <Mul Exp> \	<Int Div Exp>
'  <Mul Exp> 
'
Function EvalIntDivExp As String
	
	Dim As String lhs = EvalMulExp
	
	If MatchOperator("\") Then
		
		Dim As Double rhs = Val(EvalIntDivExp)
		
		If rhs = 0 Then THROWNEW( DIVISION_BY_ZERO )
				
		lhs = Str(Val(lhs) \ rhs)
		
	EndIf
	
	Return lhs
	
End Function


'
'  <Neg Exp> *	<Mul Exp>
'  <Neg Exp> /	<Mul Exp>
'  <Neg Exp> 
'
Function EvalMulExp As String
	
	Dim As String lhs = EvalNegExp
	
	If MatchOperator("*") Then
		
		lhs = Str(Val(lhs) * Val(EvalMulExp))
	
	ElseIf MatchOperator("/") Then
		
		Dim As Double rhs = Val(EvalMulExp) 
		
		If rhs = 0 Then THROWNEW( DIVISION_BY_ZERO )
				
		lhs = Str(Val(lhs) / rhs)
		
	EndIf
	
	Return lhs
	
End Function


'
'  -	<Pow Exp>
'  <Pow Exp>
'
Function EvalNegExp As String
	
	If MatchOperator("-") Then
		
		Return Str(-Val(EvalPowExp))
		
	EndIf
	
	Return EvalPowExp
	
End Function


'
'  <Value> ^	<Neg Exp> 
'  <Value>
'
Function EvalPowExp As String
	
	Dim As String lhs = EvalValue
	
	If Eval.lookahead = "^" Then
		
		NextChar
		
		SkipWhite
		
		lhs = Str(Val(lhs) ^ Val(EvalNegExp))
		
	EndIf
	
	Return lhs
		
End Function


'
'  (	<Expression>  )
'  [0-9]+(.[0-9]*(e[+-]?[0-9]+)?)?
'  &h[0-9a-f]+
'  &o[0-7]+
'  &b[01]+
'	[a-z_][a-z_0-9]*( <Expression> {, <Expression>} )
'  " ([^"]|"")* "
'
Function EvalValue As String
	
	If Eval.lookahead = "(" Then
		
		NextChar
		
		SkipWhite
		
		Function = EvalExpression
		
		If Eval.lookahead = ")" Then
			
			NextChar
			
			SkipWhite
			
		Else
			
			 THROWNEW( BRACE_MISSING )
			 
		EndIf
	
	ElseIf InStr(Eval.lookahead, Any "0123456789.") > 0 Then
		
		Dim As String	c, number
		Dim As Integer	dot = 0, e = 0
		
		Do While InStr(Eval.lookahead, Any "0123456789.eE") > 0
			
			c = Eval.lookahead
			number += c
			NextChar
			
			If c = "." Then
				
				If dot Then THROWNEW( SYNTAX_ERROR )
				
				dot = -1
			
			ElseIf c = "e" Or c = "E" Then
				
				If e Then THROWNEW( SYNTAX_ERROR )
				
				e = -1
				
				If InStr(Eval.lookahead, Any "+-") Then
					
					number += Eval.lookahead
					NextChar
					
				EndIf
				
				If InStr(Eval.lookahead, Any "0123456789") <= 0 Then THROWNEW( SYNTAX_ERROR )
				
			EndIf

		Loop
		
		SkipWhite
		
		Return number
	
	ElseIf Eval.lookahead = "&" Then
		
		NextChar
		
		Select Case LCase(Eval.lookahead)
			
			
			Case "h"
				
				NextChar
				
				If InStr(LCase(Eval.lookahead), Any "0123456789abcdef") <= 0 Then THROWNEW( SYNTAX_ERROR )
				
				Dim As String number = "&H"
				
				Do While InStr(LCase(Eval.lookahead), Any "0123456789abcdef") > 0
					
					number += Eval.lookahead
					NextChar
					
				Loop 
				
				SkipWhite
				
				Return Str(Val(number))
			
			
			Case "o"
				
				NextChar

				If InStr(LCase(Eval.lookahead), Any "01234567") <= 0 Then THROWNEW( SYNTAX_ERROR )
				
				Dim As String number = "&O"
				
				Do While InStr(Eval.lookahead, Any "01234567") > 0
					
					number += Eval.lookahead
					NextChar
					
				Loop 
				
				SkipWhite
				
				Return Str(Val(number))
							
			
			Case "b"
				
				NextChar
				
				If InStr(LCase(Eval.lookahead), Any "01") <= 0 Then THROWNEW( SYNTAX_ERROR )
				
				Dim As String number = "&B"
				
				Do While InStr(Eval.lookahead, Any "01") > 0
					
					number += Eval.lookahead
					NextChar
					
				Loop 
				
				SkipWhite
				
				Return Str(Val(number))
			
			Case Else
				
				THROWNEW( SYNTAX_ERROR )				
			
		End Select
	
	ElseIf Eval.lookahead = """" Then
		
		Dim As String ret
		
		NextChar
		
		Do
			If Eval.lookahead = """" Then
				NextChar
				If Eval.lookahead = """" Then
					NextChar
					ret += """"
				Else
					Exit Do
				EndIf
			ElseIf Eval.lookahead = END_OF_LINE Then
				THROWNEW( UNCLOSED_STRING_CONSTANT )
			Else
				ret += Eval.lookahead
				NextChar
			EndIf
		Loop
		
		Return ret
	
	ElseIf InStr(LCase(Eval.lookahead), Any "_abcdefghijlmnopqrstuvwxyz") > 0 Then
		
		Dim As String func = Eval.lookahead, argv()
		Dim As Integer argc = 0
		
		NextChar
		
		Do While InStr(LCase(Eval.lookahead), Any "_abcdefghijlmnopqrstuvwxyz0123456789") > 0
			
			func += Eval.lookahead
			
			NextChar
			
		Loop
		
		SkipWhite
		
		If Eval.lookahead <> "(" Then THROWNEW( SYNTAX_ERROR )
		
		NextChar
		
		Do
			
			SkipWhite
			
			argc += 1
			
			ReDim Preserve argv(1 To argc)
			
			argv(argc) = EvalExpression
			
			SkipWhite
			
			If Eval.lookahead = "," Then
				
				NextChar
			
			ElseIf Eval.lookahead = ")" Then
				
				NextChar
				
				SkipWhite
				
				Exit Do
			
			Else
				
				THROWNEW( SYNTAX_ERROR )
			
			EndIf
			
		Loop
		
		Select Case LCase(func)			
			Case "lobyte": Return Str(LoByte(Val(argv(1))))
			Case "hibyte": Return Str(HiByte(Val(argv(1))))
			Case "loword": Return Str(LoWord(Val(argv(1))))
			Case "hiword": Return Str(HiWord(Val(argv(1))))
			Case "bit"
				If argc < 2 Then THROWNEW( ARGUMENT_COUNT_MISSMATCH )
				Return Str(Bit(Val(argv(1)), Val(argv(2))))
			Case "bitreset"
				If argc < 2 Then THROWNEW( ARGUMENT_COUNT_MISSMATCH )
				Return Str(BitReset(Val(argv(1)), Val(argv(2))))
			Case "bitset"
				If argc < 2 Then THROWNEW( ARGUMENT_COUNT_MISSMATCH )
				Return Str(BitSet(Val(argv(1)), Val(argv(2))))
			Case "abs": Return Str(Abs(Val(argv(1))))
			Case "exp": Return Str(Exp(Val(argv(1))))
			Case "log": Return Str(Log(Val(argv(1))))
			Case "sqr": Return Str(Sqr(Val(argv(1))))
			Case "fix": Return Str(Fix(Val(argv(1))))
			Case "frac": Return Str(Frac(Val(argv(1))))
			Case "int": Return Str(Int(Val(argv(1))))
			Case "sgn": Return Str(Sgn(Val(argv(1))))
			Case "sin": Return Str(Sin(Val(argv(1))))
			Case "asin": Return Str(Asin(Val(argv(1))))
			Case "cos": Return Str(Cos(Val(argv(1))))
			Case "acos": Return Str(Acos(Val(argv(1))))
			Case "tan": Return Str(Tan(Val(argv(1))))
			Case "atn": Return Str(Atn(Val(argv(1))))
			Case "atan2"
				If argc < 2 Then THROWNEW( ARGUMENT_COUNT_MISSMATCH )
				Return Str(ATan2(Val(argv(1)), Val(argv(2))))
			Case "asc"
				If argc < 2 Then
					Return Str(Asc(argv(1), Val(argv(2)))) 
				Else 
					Return Str(Asc(argv(1)))
				EndIf  
				
			Case "chr":
				Select Case As Const argc
					Case 1: Return Chr(Val(argv(1)))
					Case 2: Return Chr(Val(argv(1)), Val(argv(2)))
					Case 3: Return Chr(Val(argv(1)), Val(argv(2)), Val(argv(3)))
					Case 4: Return Chr(Val(argv(1)), Val(argv(2)), Val(argv(3)), Val(argv(4)))
					Case 5: Return Chr(Val(argv(1)), Val(argv(2)), Val(argv(3)), Val(argv(4)), Val(argv(5)))
					Case 6: Return Chr(Val(argv(1)), Val(argv(2)), Val(argv(3)), Val(argv(4)), Val(argv(5)), Val(argv(6)))
					Case 7: Return Chr(Val(argv(1)), Val(argv(2)), Val(argv(3)), Val(argv(4)), Val(argv(5)), Val(argv(6)), Val(argv(7)))
					Case 8: Return Chr(Val(argv(1)), Val(argv(2)), Val(argv(3)), Val(argv(4)), Val(argv(5)), Val(argv(6)), Val(argv(7)), Val(argv(8)))
					Case Else: THROWNEW( ARGUMENT_COUNT_MISSMATCH )
				End Select
			
			Case "bin": Return Bin(Val(argv(1)))
			Case "oct": Return Oct(Val(argv(1)))
			Case "hex": Return Hex(Val(argv(1)))
			Case "format"
				If argc = 1 Then
					Return Format(Val(argv(1)))
				Else
					Return Format(Val(argv(1)), argv(2))					
				EndIf
			Case "val": Return Str(Val(argv(1)))
			Case "valint": Return Str(ValInt(argv(1)))
			Case "valuint": Return Str(ValUInt(argv(1)))
			Case "mkd": Return Mkd(Val(argv(1)))
			Case "mki": Return Mki(Val(argv(1)))
			Case "mkl": Return Mkl(Val(argv(1)))
			Case "mks": Return Mks(Val(argv(1)))
			Case "mkshort": Return MkShort(Val(argv(1)))
			Case "cvd": Return Str(Cvd(argv(1)))
			Case "cvi": Return Str(Cvi(argv(1)))
			Case "cvs": Return Str(Cvs(argv(1)))
			Case "cvshort": Return Str(CVShort(argv(1)))
			Case "left"
				If argc < 2 Then THROWNEW( ARGUMENT_COUNT_MISSMATCH )
				Return Left(argv(1), Val(argv(2)))
			Case "mid"
				If argc = 2 Then
					Return Mid(argv(1), Val(argv(2)))
				ElseIf argc = 3 Then
					Return Mid(argv(1), Val(argv(2)), Val(argv(3)))
				Else
					THROWNEW( ARGUMENT_COUNT_MISSMATCH )	
				EndIf
			Case "right"
				If argc < 2 Then THROWNEW( ARGUMENT_COUNT_MISSMATCH )
				Return Right(argv(1), Val(argv(2)))
			Case "lcase": Return LCase(argv(1))
			Case "ucase": Return UCase(argv(1))
			Case "ltrim": Return LTrim(argv(1))
			Case "rtrim": Return RTrim(argv(1))
			Case "trim": Return Trim(argv(1))
			Case "instr"
				If argc = 2 Then
					Return Str(InStr(argv(1), argv(2)))
				ElseIf argc = 3 Then
					Return Str(InStr(Val(argv(1)), argv(2), argv(3)))
				Else
					THROWNEW( ARGUMENT_COUNT_MISSMATCH )	
				EndIf
		End Select
		
	Else
		
		THROWNEW( SYNTAX_ERROR )
		
	EndIf
	
End Function


' subclasses output window
Function OutputWndProc(ByVal hwnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer
	
	Select Case uMsg
		
		Case WM_CHAR
			
			If wParam = VK_RETURN Then
				
				Dim As TEXTRANGE     trng
         	Dim As Integer       currentLine, lineLength
         	Dim As ZString Ptr   buffer
         	dim as String			lineText
        
            SendMessage( lpHandles->hOut, EM_EXGETSEL, 0, Cast(LPARAM, VarPtr(trng.chrg)) )
            
            currentLine = SendMessage( lpHandles->hOut, EM_EXLINEFROMCHAR, 0, trng.chrg.cpMin )
            
            trng.chrg.cpMin = SendMessage( lpHandles->hOut, EM_LINEINDEX, currentLine, 0 )
            
            lineLength = SendMessage( lpHandles->hOut, EM_LINELENGTH, trng.chrg.cpMin, 0)
            
            buffer = Allocate(SizeOf(ZString) * lineLength + 1)
            
            trng.lpstrText = buffer
            
            SendMessage( lpHandles->hOut, EM_GETTEXTRANGE, 0, Cast(LPARAM, @trng))
            
            lineText = Left(*buffer, lineLength)
            
            DeAllocate(buffer)
            
            If Left(lineText, 1) = "?" Then
            	
	            lineText = Chr(13, 10) + Evaluate(Mid(lineText, 2))
	            
	            SendMessage( lpHandles->hOut, EM_REPLACESEL, 0, Cast(LPARAM, StrPtr(lineText)) )            	
            	
            EndIf
				
			EndIf
		
	End Select
	
	Return CallWindowProc(wpOrigWinProc, hwnd, uMsg, wParam, lParam)
	
End Function


' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
Function InstallDll Cdecl Alias "InstallDll" (ByVal hWin As HWND, ByVal hInst As HINSTANCE) As ADDINHOOKS Pointer Export

	' Get pointer to ADDINHANDLES
	lpHandles = Cast(ADDINHANDLES Pointer, SendMessage(hWin, AIM_GETHANDLES, 0, 0))
	
	' subclass output window
	wpOrigWinProc = Cast(WNDPROC, SendMessage(lpHandles->hOut, REM_SUBCLASS, 0, Cast(LPARAM, ProcPtr(OutputWndProc))))
	
	' Messages this addin will hook into
	hooks = Type(0, 0, 0, 0)
	
	Return VarPtr(hooks)

End Function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
Function DllFunction CDecl Alias "DllFunction" (ByVal hWin As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As bool Export
	
	Return FALSE

End Function