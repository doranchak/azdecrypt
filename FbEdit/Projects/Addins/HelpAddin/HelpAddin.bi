
' FbEdit menu id's
#define IDM_HELPF1							10231
#define IDM_HELPCTRLF1						10232

' RAEdit commands
#define REM_BASE								WM_USER+1000
#define REM_GETWORD							REM_BASE+15		' wParam=BuffSize, lParam=lpBuff

dim SHARED hInstance as HINSTANCE
dim SHARED hooks as ADDINHOOKS
dim SHARED lpHandles as ADDINHANDLES ptr
dim SHARED lpFunctions as ADDINFUNCTIONS ptr
dim SHARED lpData as ADDINDATA ptr

' fb keywords
CONST fbwords=	" date err pen play screen seek shell stack strig time timer" & _
					" beep bload bsave call calls chain chdir chdrive clear close cls color com common const data def defcur defdbl defint deflng defsng defstr dim do environ erase error event exit field files for get gosub goto input ioctl key kill let line locate lock loop lprint lset mkdir name next on open option out poke pokebyte pokecurr pokelong pokeword print put randomize read redim rem reset restore resume return rmdir rset run shared signal sleep sound static stop" & _
					" abs asc atn bin$ cast cbyt ccur cdbl chr chr$ cint clng command$ compileline compileline$ cos csng csrlin curdir$ cvb cvc cvd cvi cvl cvs dir$ environ$ eof erdev erdev$ erl error$ exp fileattr fix fre freefile hex$ inkey$ inp input$ instr int ioctl$ lbound lcase$ left$ len loc lof log lpos ltrim$ mkb$ mkc$ mkd$ mki$ mkl$ mks$ oct$ peek peekbyte peekcurr peeklong peekword pos right$ rnd rtrim$ sadd setmem sgn sin space$ spc sqr sseg ssegadd stick str str$ string$ tab tan test testnot trim$ ubound ucase$ val varptr varptr$ varseg" & _
					" #else #elseif #endif #endmacro #error #if #ifdef #ifndef #inclib #libpath #line #macro #pragma #print #undef #define #include access alias any append as base basic binary byref byval cdecl disablebopt disablefold disableincdec disableperiodmsg disableshifts disabletest disabletrim explicit fortran go is lib linenumber list local off offset once output pascal pointer preserve random seg seg$ stdcall step syscall to until using wincon wingui" & _
					" $begin debug dynamic finish ignore inc include linesize list module name ocode option page pageif pagesize process skip start static stringpool subtitle title" & _
					" and eqv imp mod not or rol ror shl shr xor" & _
					" abs access acos alias allocate append as asc asin asm atan2 atn base beep bin$ binary bit bitreset bitset bload bsave byref byval call callocate cbyte cdbl cdecl chain chdir chr cint circle clear clng clngint close cls color command common continue cos cshort csign csng csrlin cubyte cuint culngint cunsg curdir cushort cvd cvi cvl cvs data date deallocate defbyte defined defshort defubyte defuint defushort dim dir do draw dylibfree dylibload dylibsymbol dynamic enum environ environ eof eqv erase err error escape exec exepath exit exp explicit export extern" & _
					" fix flip for fre freefile get getkey getmouse gosub goto hex hibyte hiword iif imp inkey inp input instr int is kill lbound lcase left len let lib line lobyte loc local locate lock lof log loop loword lset ltrim mid mkd mkdir mki mkl mklongint mks mkshort mod multikey name next oct on open option out output overload paint palette pascal pcopy peek peeki peeks pmap point poke pokei pokes pos preserve preset private procptr pset public put random randomize read reallocate redim reset restore resume resume return rgb right right$ rmdir rnd rset rtrim run" & _
					" bin command condbroadcast condcreate conddestroy condsignal condwait date dir hex ltrim mkd mki mkl mks mutexcreate mutexdestroy mutexlock mutexunlock oct rtrim sadd screen screencopy screeninfo screenlock screenptr screenres screenset screenunlock seek setenviron sgn shared shell short sin sizeof sleep space spc sqr static stdcall step stop str strcat strchr strcmp strcpy string strlen strncat strncmp strncpy strptr strrchr strstr swap system tab tan threadcreate threadwait time timer to trim ubound ucase union unlock until using va_arg va_first va_next val val64 valint varptr view wait wend while width window windowtitle with write" & _
					" case constructor declare destructor else elseif end endif function if namespace property scope select sub then type" & _
					" __date__ __fb_bigendian__ __fb_debug__ __fb_dos__ __fb_err__ __fb_lang__ __fb_linux__ __fb_main__ __fb_min_version__ __fb_signature__ __fb_version__ __fb_win32__ __fb_ver_major__ __fb_ver_minor__ __fb_ver_patch__ __file__ __file_nq__ __function__ __function_nq__ __fb_mt__ __fb_option_byval__ __fb_option_dynamic__ __fb_option_escape__ __fb_option_explicit__ __fb_option_private__ __fb_out_dll__ __fb_out_exe__ __fb_out_lib__ __fb_out_obj__ __line__ __path__ __time__" & _
					" byte ubyte short ushort integer uinteger long longint ulongint single double string zstring wstring pointer ptr "

