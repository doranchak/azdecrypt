
;#########################################################################
;		Include files

	include windows.inc
	include kernel32.inc
	include user32.inc
	include comctl32.inc
	include shell32.inc
	include gdi32.inc
	include zlib\zlibstat.inc

;#########################################################################
;		Libraries

	includelib kernel32.lib
	includelib user32.lib
	includelib comctl32.lib
	includelib shell32.lib
	includelib gdi32.lib
	includelib zlib\zlibstat.lib

;#########################################################################
;		RadASM Add In Include

	include FbEdit.inc

;#########################################################################
;		VKim's Debug

	include \RadASM\masm\inc\debug.inc
	includelib \RadASM\masm\lib\debug.lib
	include masm32.inc
	includelib masm32.lib
	includelib \RadASM\Masm\Lib\Debug.lib

	DBGWIN_DEBUG_ON = 1		; include debug info into the program
	DBGWIN_EXT_INFO = 0		; include extra debug info into the program

;#########################################################################
;		Prototypes

;	DLLProc				PROTO :DWORD, :DWORD, :DWORD, :DWORD
;	InstallDLL			PROTO :DWORD, :DWORD

	TextOutput			PROTO :DWORD
	clrOutput			PROTO 
	HexOutput			PROTO :DWORD
	GetLangString		PROTO :DWORD,:DWORD

	IDB_FILE			equ 100
	IDD_DIALOG1			equ 101
	IDC_LSTSORT			equ 1001
	IDC_BTNEXIT			equ 2
	IDC_BTNZIP			equ 1004
;	IDC_BTNMAIL			equ 1002
	IDC_LSVFILELIST		equ 1003
	IDC_EDTFOLDER		equ 1005
	IDC_BTNFOLDER		equ 1006
	IDC_EDTCURRENT		equ 1008
	IDC_BTNSELECTALL	equ 1007
	IDC_BTNZIPPROJECT	equ 1011

	FILEINFO struct
		dwSizeLow	dd ?
		dwSizeHigh	dd ?
		dwTimeLow	dd ?
		dwTimeHigh	dd ?
	FILEINFO ends

	POS struct
		x			dd ?
		y			dd ?
		wt			dd ?
		ht			dd ?
	POS ends

.const

	szProjectZip		db 'Project zipper',0
	szName				db 'Name',0;2000
	szSize				db 'Size',0;2001
	szDate				db 'Date',0;2002
	szSizeFmt			db '%lu',0
	szDateFmt			db "MM'-'dd'-'yyyy' '",0
	szTimeFmt			db "hh':'mm':'ss",0
	szDateFmtFile		db '_yyMMdd',0
	szTimeFmtFile		db '_HHmmss',0
	szArchive			db '\Archive',0
	szCreate			db 'Creating zip ',0;2003
	szOverwrite			db 'Overwrite existing file?',0Dh,0;2004
	szError				db 'Could not create file',0Dh,0;2005
	szApp				db 'ProjectZip',0
	szKeySkip			db 'skip',0
	szKeyFolder			db 'folder',0
	szKeyPos			db 'pos',0
	szKeyOpt			db 'opt',0
	szNULL				db 0
	szAdded				db 'Added to zip: ',0;2006
	szDone				db 0Dh,'Done.',0;2007
	szCr				db 0Dh,0
	szAppName			db 'ProjectZip',0
	szFile				db 'File',0
	szPOS				db '4444',0

.data?

	hInstance			dd ?	;Dll's module handle
	lpHandles			dd ?	;Pointer to handles struct
	lpProc				dd ?	;Pointer to proc struct
	lpData				dd ?	;Pointer to data struct
	IDAddIn				dd ?	;Unique ID for this AddIn

	szSourceFolder		db MAX_PATH dup(?)
	szDestFolder		db MAX_PATH dup(?)
	szZipFile			db MAX_PATH dup(?)
	szTemp				db MAX_PATH dup(?)
	szSkip				db MAX_PATH dup(?)
	szCurrentFolder		db MAX_PATH dup(?)
	hDlg				dd ?
	hIml				dd ?
	hLV					dd ?
	hLB					dd ?
	hED					dd ?
	OldListViewProc		dd ?
	ftw					FILETIME <?>
	ftl					FILETIME <?>
	zipfi				zip_fileinfo <>
	fatdate				dw ?
	fattime				dw ?
	fh					dd ?
	fsize				dd ?
	hFile				dd ?
	gMem				dd ?
	bread				dd ?
	counter				dd ?
	pidl				dd ?
	bri					BROWSEINFO  <?>
	fHook				ADDINHOOKS <?>
	pos					POS <?>
	fOption				dd ?

.code

;#########################################################################
;		Output Window procs

ShowOutput proc

   pushad
   mov   ebx,esp
   push  TRUE
   mov   eax,lpProc
   call  [eax].ADDINFUNCTIONS.ShowOutput
   mov   esp,ebx
   popad
   ret

ShowOutput endp

TextOutput proc lpszStr

	pushad
	mov		ebx,lpHandles
	invoke SendMessage,[ebx].ADDINHANDLES.hout,EM_SETSEL,-1,-1
	invoke SendMessage,[ebx].ADDINHANDLES.hout,EM_REPLACESEL,0,lpszStr
	invoke SendMessage,[ebx].ADDINHANDLES.hout,EM_REPLACESEL,0,addr szCr
	popad
	ret

TextOutput endp

;#########################################################################

clrOutput proc

	pushad
	mov		ebx,lpHandles
	invoke SendMessage,[ebx].ADDINHANDLES.hout,WM_SETTEXT,0,addr szNULL
	popad	
	ret

clrOutput endp

;#########################################################################

HexOutput proc val:DWORD
	
	pushad
	
;	push  val
;	mov   eax,lpProc
;	call  [eax].ADDINFUNCTIONS.lpHexOut
	
	popad
	ret

HexOutput endp

CreateTheZip proc pszFileName:DWORD
	LOCAL	buffer[MAX_PATH]:BYTE

	invoke ShowOutput
	invoke clrOutput
	invoke GetLangString,2003,offset szCreate
	invoke lstrcpy,addr buffer,eax
	invoke lstrcat,addr buffer,pszFileName
	invoke TextOutput,addr buffer
	invoke zipOpen,pszFileName,0
	mov		fh,eax
	ret

CreateTheZip endp

CloseTheZip proc

	invoke zipClose,fh,0       
	ret

CloseTheZip endp

AddFileToZip proc uses ebx esi edi,pszFileName:DWORD
	LOCAL	buffer[MAX_PATH]:BYTE

	mov		edi,pszFileName
	invoke lstrlen,edi
	lea		edi,[edi+eax]
	.while byte ptr [edi]!='.' && edi>pszFileName
		dec		edi
	.endw
	mov		esi,offset szSkip
	.while byte ptr [esi]
		.if byte ptr [esi]=='.'
			invoke lstrcmpi,esi,edi
			or		eax,eax
			je		Ex
		.endif
		invoke lstrlen,esi
		lea		esi,[esi+eax+1]
	.endw
	invoke CreateFile,pszFileName,GENERIC_READ or GENERIC_WRITE,FILE_SHARE_READ or FILE_SHARE_WRITE,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
	.if eax!=INVALID_HANDLE_VALUE
		mov		hFile,eax
		invoke GetFileTime,hFile,0,0,addr ftw
		invoke FileTimeToLocalFileTime,addr ftw,addr ftl
		invoke FileTimeToDosDateTime,addr ftl,addr fatdate,addr fattime
		mov 	ax,fatdate
		shl 	eax,16
		or		ax,fattime
		mov		zipfi.dosDate,eax
		mov		esi,pszFileName
		lea		edi,buffer
		.while byte ptr [esi]
			lodsb
			.if al=='\'
				mov		al,'/'
			.endif
			stosb
		.endw
		mov		byte ptr [edi],0
		invoke zipOpenNewFileInZip,fh,addr buffer,addr zipfi,0,0,0,0,0,Z_DEFLATED,Z_DEFAULT_COMPRESSION
	
		invoke GetFileSize,hFile,0
		mov		fsize,eax
		.if eax
			invoke GlobalAlloc,GMEM_FIXED,fsize
			mov		gMem,eax
			invoke ReadFile,hFile,gMem,fsize,addr bread,0
			invoke CloseHandle,hFile
			mov		esi,gMem
			mov		eax,fsize
			mov		ecx,100
			cdq
			div		ecx
			mov		ebx,eax;chunk size
			mov		edi,edx
			mov counter,100
			invoke zipWriteInFileInZip,fh,esi,edi ;write first
			add		esi,edi ;next pointer
			@@:
			invoke zipWriteInFileInZip,fh,esi,ebx ;write next
			add 	esi,ebx
			dec 	counter
			jnz		@B
			invoke GlobalFree,gMem
		.endif
		invoke GetLangString,2006,offset szAdded
		invoke lstrcpy,addr buffer,eax
		invoke lstrcat,addr buffer,pszFileName
		invoke TextOutput,addr buffer
		invoke zipCloseFileInZip,fh
	.endif
  Ex:
	ret

AddFileToZip endp