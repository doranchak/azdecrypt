
/' Alien invaders by KetilO 2006

	compile with:	fbc -s gui alien.rc alien.bas

'/

#include once "windows.bi"
#include once "win/commctrl.bi"

#include "Alien.bi"

sub SetupAliens
	dim as Integer i,x,y

	aliensmovex=2
	aliensmovey=0
	caliens=6
	naliens=MALIENSX*MALIENSY
	x=0
	y=0
	for i=0 to MALIENSX*MALIENSY-1
		if i=(i\MALIENSX)*MALIENSX then
			x=0
			y=y+16
		endif
		aliens(i).state=(i and 1)+1
		aliens(i).x=x
		aliens(i).y=y
		x=x+20
	next i

end sub

sub DrawGuns
	dim as Integer i,x

	x=2
	for i=1 to nguns
		ImageList_Draw(hIml,0,mDC,x,0,ILD_TRANSPARENT)
		x=x+14
	next i
	ImageList_Draw(hIml,0,mDC,gunx,256-12,ILD_TRANSPARENT)

end sub

sub DrawShields
	dim i as Integer

	for i=0 to (MSHIELDS-1)*2 step 2
		if shields(i).state then
			ImageList_Draw(hIml,shields(i).state*2-1,mDC,shields(i).x,shields(i).y,ILD_TRANSPARENT)
		endif
		if shields(i+1).state then
			ImageList_Draw(hIml,shields(i+1).state*2,mDC,shields(i+1).x,shields(i+1).y,ILD_TRANSPARENT)
		endif
	next i

end sub

sub DrawAliens
	dim as Integer i,x

	for i=0 to MALIENSX*MALIENSY-1
		if aliens(i).state then
			ImageList_Draw(hIml,aliens(i).state+6,mDC,aliens(i).x,aliens(i).y,ILD_TRANSPARENT)
			if Rnd*64<5 and halt=0 then
				' Drop bomb if possible
				for x=0 to MBOMBS-1
					if bombs(x).state=0 then
						bombs(x).state=1
						bombs(x).x=aliens(i).x+6
						bombs(x).y=aliens(i).y+12
						exit for
					endif
				next x
			endif
		endif
	next i

end sub

sub MoveAliens
	dim i as Integer
	dim xm as Integer

	xm=0
	for i=0 to MALIENSX*MALIENSY-1
		if aliens(i).state then
			aliens(i).state=(aliens(i).state and 1)+1
			aliens(i).x=aliens(i).x+aliensmovex
			aliens(i).y=aliens(i).y+aliensmovey
			if aliens(i).x>242 then
				xm=-1
			elseif aliens(i).x<2 then
				xm=1
			endif
			if aliens(i).y>240 then
				halt=1
				goy=350
			endif
		endif
	next i
	if xm then
		if aliensmovey then
			aliensmovex=2*xm
			aliensmovey=0
		else
			aliensmovex=0
			aliensmovey=8
		endif
	endif

end sub

sub DrawShots
	dim as Integer i,c

	for i=0 to MSHOTS-1
		if shots(i).state then
			c=GetPixel(mDC,shots(i).x,shots(i).y)
			if c=0 then
				shots(i).y=shots(i).y-3
				SetPixel(mDC,shots(i).x,shots(i).y,&HFFFFFF)
				SetPixel(mDC,shots(i).x,shots(i).y-1,&HFFFFFF)
				SetPixel(mDC,shots(i).x,shots(i).y-2,&HFFFFFF)
				if shots(i).y<16 then
					shots(i).state=0
				endif
			else
				shots(i).state=0
				if c=&HFFFF then
					' Hit shield
					for c=0 to MSHIELDS*2-1
						if shots(i).x>=shields(c).x and shots(i).x<shields(c).x+12 then
							shields(c).state=shields(c).state-1
							exit for
						endif
					next c
				elseif c=&HFFFFFF then
					' Hit bomb
				else
					' Hit alien
					for c=0 to MALIENSX*MALIENSY-1
						if aliens(c).state then
							if shots(i).x>=aliens(c).x and shots(i).x<aliens(c).x+12 and shots(i).y>=aliens(c).y and shots(i).y<aliens(c).y+12 then
								points=points+5
								aliens(c).state=0
								naliens=naliens-1
								exit for
							endif
						endif
					next c
					if naliens=0 then
						SetupAliens
					endif
				endif
			endif
		endif
	next i

end sub

sub DrawBombs
	dim as Integer i,c

	for i=0 to MBOMBS-1
		if bombs(i).state then
			c=GetPixel(mDC,bombs(i).x,bombs(i).y)
			if c=&HFFFF or c=&HFFFFFF or c=&HFF0000 then
				' Hit something
				bombs(i).state=0
				if c=&HFFFF then
					' Hit shield
					for c=0 to MSHIELDS*2-1
						if bombs(i).x>=shields(c).x and bombs(i).x<shields(c).x+12 then
							shields(c).state=shields(c).state-1
							exit for
						endif
					next c
				elseif c=&HFF0000 then
					' Hit gun
					nguns=nguns-1
					if nguns>=0 then
						MessageBeep(&HFFFFFFFF)
						gunx=0
					elseif halt=0 then
						MessageBeep(&HFFFFFFFF)
						goy=350
						halt=1
					endif
				endif
			else
				bombs(i).y=bombs(i).y+3
				SetPixel(mDC,bombs(i).x,bombs(i).y,&HFFFFFF)
				SetPixel(mDC,bombs(i).x,bombs(i).y-1,&HFFFFFF)
				SetPixel(mDC,bombs(i).x,bombs(i).y-2,&HFFFFFF)
				if bombs(i).y>256 then
					bombs(i).state=0
				endif
			endif
		endif
	next i

end sub

sub PaintBoard(byval hWin as HWND,byval hDC as HDC)
	dim rect as RECT
	dim buffer as ZString*32

	rect.left=0
	rect.top=0
	rect.right=256
	rect.bottom=256
	FillRect(mDC,@rect,GetStockObject(BLACK_BRUSH))
	if halt=0 then
		caliens=caliens-1
		if caliens=0 then
			MoveAliens
			caliens=4
			if naliens=2 then
				caliens=1
			elseif naliens<=5 then
				caliens=2
			endif
		endif
	endif
	DrawShields
	DrawAliens
	DrawGuns
	DrawShots
	DrawBombs
	SetBkMode(mDC,TRANSPARENT)
	SetTextColor(mDC,&HFFFFFF)
	DrawText(mDC,Str(points),-1,@rect,DT_RIGHT)
	if goy then
		rect.top=goy-70
		DrawText(mDC,StrPtr("And so ended life on"),-1,@rect,DT_CENTER)
		rect.top=rect.top+20
		DrawText(mDC,StrPtr("earth as we know it ..."),-1,@rect,DT_CENTER)
		rect.top=rect.top+30
		DrawText(mDC,StrPtr("KetilO (L) 2006"),-1,@rect,DT_CENTER)
		goy=goy-1
	endif
	GetClientRect(hWin,@rect)
	StretchBlt(hDC,0,0,rect.right,rect.bottom,mDC,0,0,256,256,SRCCOPY)

end sub

function BoardProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer
	dim ps as PAINTSTRUCT

	if uMsg=WM_PAINT then
		BeginPaint(hWin,@ps)
		PaintBoard(hWin,ps.hdc)
		EndPaint(hWin,@ps)
		return 0
	endif
	return CallWindowProc(lpOldBoardProc,hWin,uMsg,wParam,lParam)

end function

sub SetupBoard
	dim as Integer i,x,y

	goy=0
	halt=0
	gunx=0
	nguns=3
	x=6
	for i=0 to MSHIELDS*2-1 step 2
		shields(i).state=3
		shields(i).x=x
		shields(i).y=256-32
		x=x+12
		shields(i+1).state=3
		shields(i+1).x=x
		shields(i+1).y=256-32
		x=x+42
	next i
	for i=0 to MSHOTS-1
		shots(i).state=0
	next i
	for i=0 to MBOMBS-1
		bombs(i).state=0
	next i
	SetupAliens

end sub

sub TimerProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM)
	dim as Integer ks,i

	if halt=0 then
		ks=GetKeyState(VK_LEFT) and &H80
		if ks<>0 and gunx<>0 then
			gunx=gunx-2
		endif
		ks=GetKeyState(VK_RIGHT) and &H80
		if ks<>0 and gunx<256-12 then
			gunx=gunx+2
		endif
		ks=GetKeyState(VK_SPACE) and &H80
		if shot=0 then
			if ks then
				for i=0 to MSHOTS-1
					if shots(i).state=0 then
						shots(i).state=1
						shots(i).x=gunx+6
						shots(i).y=256-16
						exit for
					endif
				next i
				shot=1
			endif
		else
			if ks=0 then
				shot=0
			endif
		endif
	endif
	if halt=0 or goy then
		InvalidateRect(hShp,NULL,TRUE)
	endif

end sub

function DlgProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer
	dim rect as RECT
	dim hBmp as HBITMAP
	dim hDC as HDC
	dim i as Integer

	select case uMsg
		case WM_INITDIALOG
			hWnd=hWin
			hDC=GetDC(NULL)
			mDC=CreateCompatibleDC(hDC)
			hBmp=CreateCompatibleBitmap(hDC,256,256)
			hOldBmp=SelectObject(mDC,hBmp)
			hShp=GetDlgItem(hWin,IDC_SHP1)
			lpOldBoardProc=Cast(any ptr,SetWindowLong(hShp,GWL_WNDPROC,Cast(integer,@BoardProc)))
			hIml=ImageList_Create(12,12,ILC_COLOR4 or ILC_MASK,5,0)
			hBmp=LoadBitmap(hInstance,Cast(zstring ptr,IDB_ALIEN))
			ImageList_AddMasked(hIml,hBmp,0)
			DeleteObject(hBmp)
			SetupBoard
			halt=1
			SetTimer(hWin,200,MTIMER,Cast(any ptr,@TimerProc))
			'
		case WM_CLOSE
			DeleteObject(SelectObject(mDC,hOldBmp))
			DeleteDC(mDC)
			ImageList_Destroy(hIml)
			DestroyWindow(hWin)
			PostQuitMessage(0)
			'
		case WM_COMMAND
			select case loword(wParam)
				case IDM_FILE_EXIT
					SendMessage(hWin,WM_CLOSE,0,0)
					'
				case IDM_FILE_NEW
					SetupBoard
					'
				case IDM_FILE_PAUSE
					halt=halt xor 1
					'
			end select
		case WM_SIZE
			GetClientRect(hWin,@rect)
			MoveWindow(hShp,0,0,rect.right,rect.bottom,TRUE)
			InvalidateRect(hShp,NULL,TRUE)
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	hInstance=GetModuleHandle(NULL)
	hAcl=LoadAccelerators(hInstance,Cast(zstring ptr,IDR_ACCEL))
	CreateDialogParam(hInstance,Cast(zstring ptr,IDD_DLG1),NULL,@DlgProc,NULL)
	do while GetMessage(@msg,NULL,0,0)
		if TranslateAccelerator(hWnd,hAcl,@msg)=0 then
			TranslateMessage(@msg)
			DispatchMessage(@msg)
		endif
	loop
	''
	'' Program has ended
	''

	ExitProcess(0)
	end

'''
''' Program end
'''
