
#Define IDM_FILE_NEW_RESOURCE				10006
#Define IDM_FILE_OPEN_HEX					10060
#Define IDM_FORMAT							10061

#Define IDM_VIEW								10091
#Define IDM_VIEW_DIALOG						10095
#Define IDM_VIEW_SPLITSCREEN				10096
#Define IDM_VIEW_FULLSCREEN				10097
#Define IDM_VIEW_DUALPANE					10098
#Define IDM_RESOURCE							10121

#Define IDM_MAKE								10141
#Define IDM_MAKE_RUNDEBUG					10145

#Define IDM_TOOLS								10151
#Define IDM_OPTIONS_DIALOG					10163
#Define IDM_OPTIONS_DEBUG					10165
#Define IDM_OPTIONS_EXTERNALFILES		10167
#Define IDM_OPTIONS_TOOLS					10169

Dim Shared hInstance As HINSTANCE
Dim Shared hooks As ADDINHOOKS
Dim Shared lpHandles As ADDINHANDLES Ptr
Dim Shared lpFunctions As ADDINFUNCTIONS Ptr
Dim Shared lpData As ADDINDATA Ptr

Const Caption As String="FbEdit Lite"
Const Install As String=!"Activate FbEdit Lite for beginners?\13\10\13\10If Yes then you must restart FbEdit."
Const Addins As String=!"AdvEdit.dll=1\0" & _
							  !"FileTabStyle.dll=0\0" & _
							  !"HelpAddin.dll=1\0" & _
							  !"SnipletAddin.dll=0\0" & _
							  !"Toolbar.dll=1\0" & _
							  !"FBFileAssociation.dll=0\0" & _
							  !"fbshowvars.dll=0\0" & _
							  !"TortoiseSVN.dll=0\0" & _
							  !"CustomFontAddin.dll=0\0" & _
							  !"Base Calc.dll=0\0" & _
							  !"ProjectZip.dll=0\0" & _
							  !"ControlDefs.dll=0\0" & _
							  !"ReallyRad.dll=0\0" & _
							  !"QuickEval.dll=0\0" & _
							  !"FbDebug.dll=0\0" & _
							  !"ChartabDBCS.dll=0\0" & _
							  !"CP1251ToCP866.dll=1\0" & _
							  !"beautify.dll=1\0" & _
							  !"fbide-toolbar.dll=1\0" & _
							  !"FbEditLite.dll=1\0\0"
