#Include "crt/setjmp.bi"

Namespace __exception

	Type exdata
		jump        As jmp_buf Pointer
		code        As Integer
		msg			As String
		file        As String
		proc        As String
		line        As Integer
	End Type
       
	Dim Shared exception	As exdata
	
	Sub Alloc Constructor
		exception.jump = New jmp_buf       
	End Sub
	
	Sub Free Destructor
		Delete exception.jump
	End Sub
       

End Namespace


#Define TRY __exception.exception.code = setjmp(__exception.exception.jump): If (__exception.exception.code = 0) Then

#Macro CATCH(e, _type)
	Elseif __exception.exception.code = _type Then
		Dim As __exception.exdata Pointer e = VarPtr(__exception.exception)
#EndMacro

#Macro CATCH_ANY(e)
	Else
		Dim As __exception.exdata Pointer e = VarPtr(__exception.exception)
#EndMacro

#Define END_TRY End If

#Define THROWMSG(_type, _msg) __exception.exception.code = _type: __exception.exception.msg = _msg: __exception.exception.file = __FILE__: __exception.exception.proc = __FUNCTION__:  __exception.exception.line = __LINE__: longjmp(__exception.exception.jump, _type)

#Define THROW(_type) THROWMSG(_type, "")

#Define THROWNEW(_ex) THROWMSG(__EX_CODE_##_ex, __EX_TEXT_##_ex)

#Define FINALLY End If: If 1 Then:

#Macro DIM_AS_EXCEPTION( _name, _code, _text )
	#Define __EX_CODE_##_name _code
	#Define __EX_TEXT_##_name _text
#EndMacro