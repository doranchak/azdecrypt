#Include "windows.bi"

Const As Integer TEST1=1,TEST2=2
Dim As Integer xx,yy
Var v="abc"

Namespace MyClass

	Type a

	   Declare Constructor (ByVal z As Integer)
		Declare Destructor ()
		Declare Sub s(ByVal z As Integer)

		Declare Property p() As Integer
		Declare Property p(ByVal z As Integer)
		Declare Operator *=(ByVal z As Integer)

	Private:
		x As Integer

	End Type

	Constructor a(ByVal z As Integer)
		MessageBox(0,Str(z),"Constructor a(ByVal z As Integer)",MB_OK)
		this.x = z
	End Constructor

	Destructor a()
		MessageBox(0,Str(x),"Destructor a()",MB_OK)
	End Destructor

	Sub a.s(ByVal z As Integer)
		x=z*2
		this.x=z*2
		MessageBox(0,Str(x),"Sub a.b(ByVal z As Integer)",MB_OK)
	End Sub

	Property a.p() As Integer
		MessageBox(0,Str(x),"Get: Property a.p() As Integer",MB_OK)
		Return x
	End Property

	Property a.p(ByVal z As Integer)
		x=z
		MessageBox(0,Str(x),"Set: Property a.p(ByVal z As Integer)",MB_OK)
	End Property

	Operator a.*= (ByVal z As Integer)
		x=x*z
		this.x=this.x*z
		MessageBox(0,Str(x),"Operator a.*= (ByVal z As Integer)",MB_OK)
	End Operator

End Namespace

Namespace MyNamespace
	
	Sub s(ByVal z As Integer)
		MessageBox(0,Str(z),"Sub s(ByVal z As Integer)",MB_OK)
	End Sub

End Namespace

Sub mysub
	' Constructor called
	Dim c As MyClass.a=123
	Dim rect(3) As RECT

	' Sub called
	c.s(1)
	' Property Get / Set called
	c.p=c.p+1
	' Operator called
	c*=2

	With c
		' Sub called
		.s(1)
		' Property Get / Set called
		.p=c.p+1
		' Operator called
		c*=2
	End With

	With rect(0)
		.right=.right+1
		.left=.left+1
	End With
	rect(0).left=2
	
	MyNamespace.s(3)

Using MyNamespace
	s(2)

End Sub

mysub
MyNamespace.s(5)
