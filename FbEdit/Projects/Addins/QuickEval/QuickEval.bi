
Dim Shared hooks As ADDINHOOKS
Dim Shared lpHandles As ADDINHANDLES Pointer

Type WNDPROC As Function(ByVal hwnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer 

Dim Shared wpOrigWinProc As WNDPROC

Enum ValueType
	fbNumber
	fbString
End Enum

Type Mixed
	value	As Any Pointer
End Type

#Define REM_BASE			(WM_USER  + 1000)
#Define REM_SUBCLASS		(REM_BASE + 29)


Declare Function Evaluate(expression As String) As String
Declare Sub NextChar
Declare Function LookString(length As Integer) As String
Declare Function MatchString(token As String) As Integer
Declare Function MatchOperator(token As String) As Integer
Declare Sub Match(char As String)
Declare Sub SkipToken(length As Integer)
Declare Sub SkipWhite

Declare Function EvalExpression As String
Declare Function EvalOrExp As String
Declare Function EvalAndExp As String
Declare Function EvalNotExp As String
Declare Function EvalCompareExp As String
Declare Function EvalShiftExp As String
Declare Function EvalAddExp As String
Declare Function EvalModExp As String
Declare Function EvalIntDivExp As String
Declare Function EvalMulExp As String
Declare Function EvalNegExp As String
Declare Function EvalPowExp As String
Declare Function EvalValue As String



Declare Function OutputWndProc(ByVal hwnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer
