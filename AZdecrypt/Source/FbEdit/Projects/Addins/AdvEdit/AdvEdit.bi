
#Define IDM_MAKE_QUICKRUN					10147
#Define IDB_QUICKRUN							100

Dim Shared hInstance As HINSTANCE
Dim Shared hooks As ADDINHOOKS
Dim Shared lpHandles As ADDINHANDLES ptr
Dim Shared lpFunctions As ADDINFUNCTIONS ptr
Dim Shared lpData As ADDINDATA ptr
Dim Shared hSubMnu As HMENU

' Below are id's for the commands.
Dim Shared IdSelectWord As Integer
Dim Shared IdCopyWord As Integer
Dim Shared IdCutWord As Integer
Dim Shared IdDeleteWord As Integer

Dim Shared IdSelectLine As Integer
Dim Shared IdCopyLine As Integer
Dim Shared IdCutLine As Integer
Dim Shared IdDeleteLine As Integer
Dim Shared IdDuplicateLine As Integer
' Tooltip text
'Const szQuickRun="Quick run"
Dim Shared szQuickRun As ZString*64
