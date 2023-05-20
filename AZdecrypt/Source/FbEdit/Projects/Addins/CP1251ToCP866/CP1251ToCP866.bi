
Dim Shared hInstance As HINSTANCE
Dim Shared hooks As ADDINHOOKS
Dim Shared lpHandles As ADDINHANDLES Ptr
Dim Shared lpFunctions As ADDINFUNCTIONS Ptr
Dim Shared lpData As ADDINDATA Ptr
Dim Shared lpOldEditProc As Any Ptr
Dim Shared bFirst As Integer
Dim Shared bConvert As Integer
' Convertion tables
Dim Shared CP866 As ZString*256
Dim Shared CP1251 As ZString*256
