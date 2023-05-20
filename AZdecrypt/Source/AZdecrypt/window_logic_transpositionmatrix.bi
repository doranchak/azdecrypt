if cm_windowup=1 then

	dim as integer ctm_change=0
	for y=1 to tma_dy 'create transposition matrix mouse controls
		for x=1 to tma_dx
			if msg.message=wm_lbuttondown and msg.hwnd=buttons_creatematrix(x,y) then 'individual entries
				if tma(x,y)="" then
					tma(x,y)=str(tma_c)
					ui_label_settext(buttons_creatematrix(x,y),str(tma_c))
					tma_c+=1
					tma_lpx=x
					tma_lpy=y
					ctm_change=1
					'exit for,for
				end if
			end if
			if msg.message=wm_rbuttondown and msg.hwnd=buttons_creatematrix(x,y) then 
				if tma(x,y)="" then
					dim as integer x1,y1,c1,c2
					if y=tma_lpy then 'check horizontal line entries
						if x>tma_lpx then 'inc
							for x1=tma_lpx+1 to x
								if tma(x1,y)="" then
									ui_label_settext(buttons_creatematrix(x1,y),str(tma_c))
									tma(x1,y)=str(tma_c)
									tma_c+=1
								end if
							next x1
							tma_lpx=x
							tma_lpy=y
							ctm_change=1
							'exit for,for
						end if
						if x<tma_lpx then 'dec
							c1=tma_lpx-1
							for x1=x+1 to tma_lpx
								if tma(c1,y)="" then
									ui_label_settext(buttons_creatematrix(c1,y),str(tma_c))
									tma(c1,y)=str(tma_c)
									tma_c+=1
								end if
								c1-=1
							next x1
							tma_lpx=x
							tma_lpy=y
							ctm_change=1
							'exit for,for
						end if
					end if		
					if x=tma_lpx then 'check if vertical line
						if y>tma_lpy then 'inc
							for y1=tma_lpy+1 to y
								if tma(x,y1)="" then
									ui_label_settext(buttons_creatematrix(x,y1),str(tma_c))
									tma(x,y1)=str(tma_c)
									tma_c+=1
								end if
							next y1
							tma_lpx=x
							tma_lpy=y
							ctm_change=1
							'exit for,for
						end if
						if y<tma_lpy then 'dec
							c1=tma_lpy-1
							for y1=y+1 to tma_lpy
								if tma(x,c1)="" then
									ui_label_settext(buttons_creatematrix(x,c1),str(tma_c))
									tma(x,c1)=str(tma_c)
									tma_c+=1
								end if
								c1-=1
							next y1
							tma_lpx=x
							tma_lpy=y
							ctm_change=1
							'exit for,for
						end if	
					end if
					if abs(x-tma_lpx)=abs(y-tma_lpy)andalso abs(x-tma_lpx)>0 then 'check if diagonal line
						x1=tma_lpx
						y1=tma_lpy
						for i=1 to abs(x-tma_lpx)
							if x<tma_lpx andalso y<tma_lpy then 'reduce block ???
								x1-=1:y1-=1
							end if
							if x>tma_lpx andalso y<tma_lpy then
								x1+=1:y1-=1
							end if
							if x<tma_lpx andalso y>tma_lpy then
								x1-=1:y1+=1
							end if
							if x>tma_lpx andalso y>tma_lpy then
								x1+=1:y1+=1
							end if
							if tma(x1,y1)="" then
								ui_label_settext(buttons_creatematrix(x1,y1),str(tma_c))
								tma(x1,y1)=str(tma_c)
								tma_c+=1
							end if
						next i
						tma_lpx=x
						tma_lpy=y
						ctm_change=1
						'exit for,for
					end if
					if abs(x-tma_lpx)>0 andalso abs(x-tma_lpx) mod 2=0 andalso abs(x-tma_lpx)/2=abs(y-tma_lpy) then 'check if hor2/ver1 line
						x1=tma_lpx
						y1=tma_lpy
						do
							if x<tma_lpx then x1-=2 else x1+=2
							if y<tma_lpy then y1-=1 else y1+=1
							if tma(x1,y1)="" then
								ui_label_settext(buttons_creatematrix(x1,y1),str(tma_c))
								tma(x1,y1)=str(tma_c)
								tma_c+=1
							end if
						loop until x=x1 andalso y=y1
						tma_lpx=x
						tma_lpy=y
						ctm_change=1
						'exit for,for
					end if	
				end if
			end if	
		next x
	next y
	if ctm_change=1 then
		tma_c2+=1
		tma_his2(tma_c2,0)=tma_lpx
		tma_his2(tma_c2,1)=tma_lpy
		tma_his2(tma_c2,2)=tma_c
		for y=1 to tma_dy
			for x=1 to tma_dx
				if val(tma(x,y))>0 then 
					tma_his1(tma_c2,x,y)=val(tma(x,y))
				else
					tma_his1(tma_c2,x,y)=0
				end if
			next x
		next y	
	end if

end if