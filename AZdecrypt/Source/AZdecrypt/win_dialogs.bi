'===============================================================================
' WinDialogs.bi
' Common Dialogs for Windows
' Created on 20.04.2015
' Last changes on 13/05/2016
'===============================================================================

'updates by Jarlve in function of AZdecrypt

#Include Once "windows.bi"
#Include Once "win\commdlg.bi"


Function LoadSaveDialog(ByVal savedlog As Long = 0, _
	Byval windowname as string ="", _
	ByVal filter As String = "", _
	ByVal fltrindex As Long = 1, _
	ByVal initdir As String = "", _
	ByVal strDefExt As String = "") As String


	'Windows dialog to choose the drive/path/file name to open or save a file
	'by Volta
	'http://www.freebasic-portal.de/code-beispiele/dateien-laufwerke/dialog-datei-oeffnen-speichern-24.html

	'Parameters:
	'------------------
	'- savedlog = 0: "Open file", 1(<>0): "Save file"
	'- windowname = "": The window name of the dialog shown in the upper left corner
	'- filter = "": "All Files", otherwise a filter according to example "fil" below
	'- fltrindex = 1, otherwise the index of the desired entry in the filter, beginning from 1
	'  (see example "fil" below)
	'- initdir = "" = ".": Current path, otherwise specified path
	'- strDefExt = "": Default extension (appended to the filename if the user fails
	'  to select an extension)
	
	'Example for a filter:
	'---------------------
	'Dim As String fil
	'fil = "Basic Files (*.bas)" + Chr(0) + "*.bas" + Chr(0) _
  '  + "Text Files (*.txt)" + Chr(0) + "*.txt" + Chr(0)_
  '  + "Image Files (*.bmp)" + Chr(0) + "*.bmp" + Chr(0)_
  '  + "Executable Files (*.exe)" + Chr(0) + "*.exe" + Chr(0)_
  '  + "All Files (*.*)" + Chr(0) + "*.*" + Chr(0, 0)
  
  'Examples:
  '---------
  
  'Dim As String FileName
  
	'Open a file without filter (easiest method):
	'FileName = LoadSaveDialog
	
	'Open a file with filter:
	'FileNameName = LoadSaveDialog (,fil)
	
	'Open a file with filter, index 2 (TXT):
	'FileName = LoadSaveDialog (,fil,2)
	
	'Open a file in path "c:\":
	'FileName = LoadSaveDialog (,,,"c:\")
	
	'Save a file:
	'DateiName = LoadSaveDialog (1)
	
	'Save a file with default extension "bak" if no extension has been defined:
	'FileName = LoadSaveDialog (1,,,,"bak")
    
   Dim FB_OFN AS OPENFILENAME
   FB_OFN.lStructSize = Len(FB_OFN)
   FB_OFN.hwndOwner = 0
   FB_OFN.hInstance = 0

   Dim strFilter As String
   If filter = "" Then
      strFilter = "All Files (*.*)" + Chr(0) +"*.*" + Chr(0, 0) 'default
   Else
      strFilter = filter + Chr(0, 0)
   End If
   FB_OFN.lpstrFilter = StrPtr(strFilter)
   FB_OFN.nFilterIndex = fltrindex

   Dim strFile As String *2048
   strFile = Space(2047) + Chr(0)
   FB_OFN.lpstrFile = StrPtr(strFile)
   FB_OFN.nMaxFile = Len(strFile)

   Dim strFileTitle As String *2048
   strFileTitle = String(2048, 0)
   FB_OFN.lpstrFileTitle = StrPtr(strFileTitle)
   FB_OFN.nMaxFileTitle = Len(strFileTitle)

   Dim strdrstr As String
   If initdir = "" Then
      strdrstr = "."     'actual path
   Else
      strdrstr = initdir
   End If
   FB_OFN.lpstrInitialDir = StrPtr(strdrstr)

   Dim strcapt As String
   If savedlog Then
	if windowname="" then windowname="Save File"
      strcapt = windowname '"Save File"
      FB_OFN.lpstrTitle = StrPtr(strcapt)
      If strDefExt > "" Then
         Dim strdext As String
         strdext = strDefExt
         FB_OFN.lpstrDefExt = StrPtr(strdext)
      End If
      FB_OFN.flags = OFN_EXPLORER Or OFN_LONGNAMES Or OFN_OVERWRITEPROMPT Or OFN_HIDEREADONLY
      If GetSaveFileName(@FB_OFN) Then LoadSaveDialog = Trim(strFile)
   Else
	if windowname="" then windowname="Load File"
      strcapt = windowname '"Open file"
      FB_OFN.lpstrTitle = StrPtr(strcapt)
      FB_OFN.flags = OFN_EXPLORER Or OFN_LONGNAMES Or OFN_CREATEPROMPT Or _
                     OFN_NODEREFERENCELINKS Or OFN_HIDEREADONLY
      If GetOpenFileName(@FB_OFN) Then LoadSaveDialog = Trim(strFile)
   End If
End Function


Function ColorPicker() As ULong
	'Windows dialog to select a color (Colorpicker) 
	'by Sebastian  
	'http://www.freebasic-portal.de/code-beispiele/windows-gui/commondialog-zur-farbauswahl-colorpicker-227.html
	'The selected color is returned in the format BGR
	
	'Example:
	'--------
	'Dim As ULong colour
	'colour = Hex(ColorPicker)
	
	#Define WIN_INCLUDEALL
	
	Dim AS CHOOSECOLOR PTR cc     'common dialog box structure
	DIM AS ULong PTR acrCustClr   'custom colors (16x4 bytes)
	DIM AS HWND hwnd              'owner window
	DIM AS HBRUSH hbrush          'brush handle
	DIM AS ULong rgbCurrent       'initial color selection
	
	rgbCurrent = 0  'default: black
	
	cc = CAllocate(sizeof(CHOOSECOLOR))
	acrCustClr = CAllocate(64)
	
	cc->lStructSize = Cast(ULong,sizeof(CHOOSECOLOR))
	cc->hwndOwner = hwnd
	cc->lpCustColors = CAST(LPDWORD, acrCustClr)
	cc->rgbResult = rgbCurrent
	cc->Flags = CC_FULLOPEN Or CC_RGBINIT
	
	if (ChooseColor(cc) = 1) Then
    hbrush = CreateSolidBrush(cc->rgbResult)
    rgbCurrent = cc->rgbResult
	Else
	  rgbCurrent = 0
	End If
		
	Return rgbCurrent

End Function


Function BGRtoRGB(ByVal colour As ULong) As ULong
   'Converts a BGR color format to RGB
   
   Dim As String BGRString, RGBString
   
   BGRString = Hex(colour, 6)
   RGBString = "&H" + Right(BGRString, 2) + Mid(BGRString, 3, 2) + Left(BGRString, 2)
   
   Return ValUInt(RGBString)  ' corrected: this gives ULong 32 bit (ValULng = ULongInt 64bit)
															' MrSwiss 17/04/2016 http://www.freebasic.net/forum/viewtopic.php?f=8&t=24617
   
End Function

