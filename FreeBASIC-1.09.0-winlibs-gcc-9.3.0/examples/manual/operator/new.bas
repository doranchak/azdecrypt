'' examples/manual/operator/new.bas
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
'' See Also: https://www.freebasic.net/wiki/wikka.php?wakka=KeyPgOpNew
'' --------

Type Rational
	As Integer numerator, denominator
End Type

' Create and initialize a "rational" and store its address.
Dim p As Rational Ptr = New Rational(3, 4)

' Test if null return pointer
If (p = 0) Then
	Print "Error: unable to allocate memory"
Else
	Print p->numerator & "/" & p->denominator
	' Destroy the rational and give its memory back to the system.
	Delete p
End If

Sleep
