#Define IDD_DLG1 1000 
#Define IDC_BTN1 1001
#Define IDC_GRD1 1002
#Define IDC_BTN2 1003

Dim Shared hLib As HMODULE
Dim Shared hGrd As HWND

Type ROWDATA
	lpszName As ZString ptr			' Data for Name column. Pointer to string
	lpszAddress As ZString ptr		' Data for Address column. Pointer to string
	nPoints As Integer				' Data for Points column. Integer value
	lpszButton1 As ZString ptr		' Data for Button column
End Type

' Just some row data
Const szName1="Name#1"
Const szAddress1="Address#1"
Const szName2="Name#2"
Const szAddress2="Address#2"
Const szName3="Name#3"
Const szAddress3="Address#3"
Const szName4="Name#4"
Const szAddress4="Address#4"

Dim Shared rdta1 As ROWDATA=(@szName1,@szAddress1,2000,@szAddress1)
Dim Shared rdta2 As ROWDATA=(@szName2,@szAddress2,4000,@szAddress2)
Dim Shared rdta3 As ROWDATA=(@szName3,@szAddress3,3000,@szAddress3)
Dim Shared rdta4 As ROWDATA=(@szName4,@szAddress4,5000,@szAddress4)

