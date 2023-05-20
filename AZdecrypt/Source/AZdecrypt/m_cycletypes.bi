'if cta(101)=1 then 'periodically transposed cycle patterns
'	k=0
'	for i=1 to cta(102) 'period
'		for j=1 to cl step cta(102) 'period
'			k+=1
'			if cta(103)=0 then 'untransposes
'				z2(j)=z(k)
'			else 'transposed	
'				z2(k)=z(j)
'			end if	
'		next j
'	next i
'	for i=1 to cl
'		z(i)=z2(i)
'	next i
'end if
for ct=1 to ctmax
	if cta(ct)=1 then
		score=0
		select case ct
			'case 0 'cycle ngrams
			'	select case cta(104) 'ngram size
			'		case 3
			'			for i=1 to cl-(cta(104)-1)
			'				n=z(i)+(z(i+1)*n1)+(z(i+2)*n2)
			'				cng(n)+=1
			'			next i
			'		case 4
			'			for i=1 to cl-(cta(104)-1)
			'				n=z(i)+(z(i+1)*n1)+(z(i+2)*n2)+(z(i+3)*n3)
			'				cng(n)+=1
			'			next i
			'		case 5
			'			for i=1 to cl-(cta(104)-1)
			'				n=z(i)+(z(i+1)*n1)+(z(i+2)*n2)+(z(i+3)*n3)+(z(i+4)*n4)
			'				cng(n)+=1
			'			next i
			'		case 6
			'			for i=1 to cl-(cta(104)-1)
			'				n=z(i)+(z(i+1)*n1)+(z(i+2)*n2)+(z(i+3)*n3)+(z(i+4)*n4)+(z(i+5)*n5)
			'				cng(n)+=1
			'			next i
			'		case 7
			'			for i=1 to cl-(cta(104)-1)
			'				n=z(i)+(z(i+1)*n1)+(z(i+2)*n2)+(z(i+3)*n3)+(z(i+4)*n4)+(z(i+5)*n5)+(z(i+6)*n6)
			'				cng(n)+=1
			'			next i
			'		case 8
			'			for i=1 to cl-(cta(104)-1)
			'				n=z(i)+(z(i+1)*n1)+(z(i+2)*n2)+(z(i+3)*n3)+(z(i+4)*n4)+(z(i+5)*n5)+(z(i+6)*n6)+(z(i+7)*n7)
			'				cng(n)+=1
			'			next i
			'	end select
			case 1 'normal cycles
				al=cl-(cs-1)
				for i=1 to cl-(cs-1)
					e=1
					for j=i to i+(cs-2)
						for k=j+1 to i+(cs-1)
							if z(j)=z(k) then
								e=0
								exit for,for
							end if
						next k
					next j
					z2(i)=e
				next i
				a=0
				for i=1 to cl-(cs-1)
					a+=z2(i)
				next i
				score=a*(a/al)
			case 2 'increasingly random cycles
				al=cl-(cs-1)
				for i=1 to cl-(cs-1)
					e=1
					for j=i to i+(cs-2)
						for k=j+1 to i+(cs-1)
							if z(j)=z(k) then
								e=0
								exit for,for
							end if
						next k
					next j
					z2(i)=e
				next i
				al=cl-(cs-1)
				if al mod 2=1 then
					al1=1:al2=(al-1)/2
				else 
					al1=0:al2=al/2
				end if
				p1=0:p2=0
				for i=1 to al2
					p1+=z2(i)
					p2+=z2(i+al1+al2)
				next i
				if p1-p2>0 then score=((p1+p2)/al2)*(p1-p2)
			case 3 'decreasingly random cycles
				al=cl-(cs-1)
				for i=1 to cl-(cs-1)
					e=1
					for j=i to i+(cs-2)
						for k=j+1 to i+(cs-1)
							if z(j)=z(k) then
								e=0
								exit for,for
							end if
						next k
					next j
					z2(i)=e
				next i
				al=cl-(cs-1)
				if al mod 2=1 then
					al1=1:al2=(al-1)/2
				else 
					al1=0:al2=al/2
				end if
				p1=0:p2=0	
				for i=1 to al2
					p1+=z2(i)
					p2+=z2(i+al1+al2)
				next i
				if p2-p1>0 then score=((p1+p2)/al2)*(p2-p1)
			case 4 'shortened cycles
				p1=0:p2=0
				dim as short z3(cl,cs)
				dim as short e1=1
				for i=1 to cl 'increment cycle position
					for a=1 to cs 'decrement cycle size
						b=cs-(a-1) 'cycle size
						for j=1 to b
							cf(j)=0
						next j
						e=1
						for j=0 to b-1
							if cf(z(i+j))=1 then
								e=0
								exit for
							end if
							cf(z(i+j))+=1
						next j
						if e=1 then exit for
					next a
					
					'if i>1 andalso z2(p1)-b>0 then 'compare versus previous cycle
					'	e=1
					'	if b<z2(p1) then a=b else a=z2(p1)
					'	for j=i to i+(a-1)
					'		if z(j)<>z(j-z2(p1)) then
					'			e=0
					'			exit for
					'		end if
					'	next j
					'	if e=1 then p2+=z2(p1)
					'end if
					
					p1+=1
					for j=0 to b-1
						z3(p1,j+1)=z(i+j)
					next j
					for j=b+1 to cs
						z3(p1,j)=0
					next j
					z2(p1)=b
					i+=b-1
				next i
				a=0:b=0
				for i=1 to p1
					if z2(i)>a then
						a=z2(i)
						b=i
					end if
				next i
				for i=1 to p1
					for j=1 to a
						if z3(i,j)<>0 andalso z3(b,j)<>z3(i,j) then e1=0
					next j
				next i
				if e1=1 then
					e=0
					for i=1 to p1-1
						if z2(i)-z2(i+1)>0 then e+=1
						if z2(i)-z2(i+1)<0 then e-=1
					next i
					if e>0 then score=e*(e/(p1-1)) 'e*(e/p1)
				end if
			case 5 'lengthened cycles
				p1=0:p2=0
				for i=1 to cl 'increment cycle position
					for a=1 to cs 'decrement cycle size
						b=cs-(a-1) 'cycle size
						for j=1 to b
							cf(j)=0
						next j
						e=1
						for j=0 to b-1
							if cf(z(i+j))=1 then
								e=0
								exit for
							end if
							cf(z(i+j))+=1
						next j
						if e=1 then exit for
					next a
					if i>1 andalso z2(p1)-b<0 then 'compare versus previous cycle
						e=1
						if b<z2(p1) then a=b else a=z2(p1)
						for j=i to i+(a-1)
							if z(j)<>z(j-z2(p1)) then
								e=0
								exit for
							end if
						next j
						if e=1 then p2+=b
					end if
					p1+=1
					z2(p1)=b
					i+=b-1
				next i
				e=0
				p1-=1
				for i=1 to p1
					if z2(i+1)-z2(i)>0 then e+=1
					if z2(i+1)-z2(i)<0 then e-=1
				next i
				if e>0 then score=p2*(e/p1) '(e/p1) 'e*(e/p1)
			case 6 'alternating length cycles
				p1=0:p2=0
				dim as short z3(cl,cs)
				dim as short e1=1
				for i=1 to cl 'increment cycle position
					for a=1 to cs 'decrement cycle size
						b=cs-(a-1) 'cycle size
						for j=1 to b
							cf(j)=0
						next j
						e=1
						for j=0 to b-1
							if cf(z(i+j))=1 then
								e=0
								exit for
							end if
							cf(z(i+j))+=1
						next j
						if e=1 then exit for
					next a
					p1+=1
					for j=0 to b-1
						z3(p1,j+1)=z(i+j)
					next j
					for j=b+1 to cs
						z3(p1,j)=0
					next j
					z2(p1)=b
					i+=b-1	
				next i	
				a=0:b=0
				for i=1 to p1
					if z2(i)>a then
						a=z2(i)
						b=i
					end if
				next i
				for i=1 to p1
					for j=1 to a
						if z3(i,j)<>0 andalso z3(b,j)<>z3(i,j) then e1=0
					next j
				next i
				e=1
				if e1=1 then
					for i=3 to p1 step 2
						if z2(1)<>z2(i) then e=0
					next i
					for i=4 to p1 step 2
						if z2(2)<>z2(i) then e=0
					next i
					if e=1 andalso z2(1)<>z2(2) then score=cl
				end if
			case 7 'uneven palindromic cycles
				e=0
				for i=2 to cl-1
					b=0
					if i-1<cl-i then a=i-1 else a=cl-i
					for j=1 to a
						if z(i-j)=z(i+j) then b+=1
					next j
					if a=b andalso a>e then e=a
				next i
				if cl mod 2=0 then 'even cl
					score=e*(e/((cl-2)/2))
				else 'uneven cl
					score=e*(e/((cl-1)/2))
				end if
			'case 6 'even palindromic cycles, bugged ???
			'	e=0
			'	for i=2 to cl-2
			'		b=0
			'		if i-1<cl-i then a=i-1 else a=cl-i
			'		if z(i)=z(i+1) then b+=1
			'		for j=1 to a
			'			if z(i)=z(i-j) then b+=1
			'			if z(i+1)=z(i+1+j) then b+=1
			'		next j
			'		if (a*2)+1=b andalso a>e then e=a
			'	next i
			'	if cl mod 2=0 then 'even cl
			'		score=e*(e/((cl-2)/2))
			'	else 'uneven cl
			'		score=e*(e/((cl-1)/2))
			'	end if
			case 8 'anti cycles
				a=0
				for i=1 to cl-1
					if z(i)<>z(i+1) then a+=1
				next i
				if a=cs-1 then score=cl '*(cl-1)
			case 11 'unique cycles
				a=0:b=0
				for i=1 to cl-(cs-1) step cs
					e=1
					b+=1
					for j=i to i+(cs-2)
						for k=j+1 to i+(cs-1)
							if z(j)=z(k) then
								e=0
								exit for,for
							end if
						next k
					next j	 
					if e=1 then a+=1
				next i
				if a=b then score=a
			case 12 'pattern cycles
				p1=0
				a=(cl-cl mod 2)/2
				for b=cs+1 to a 'increment fragment size
					for i=1 to cl-((b*2)-1) 'slide get fragment
						for j=1 to cs
							cf(j)=0
						next j
						e=0
						for j=0 to b-1
							cf(z(i+j))+=1
						next j
						for j=1 to cs
							if cf(j)=0 then e=0:exit for 'include all symbols
							if cf(j)>1 then e=1 'include at least 1 rep
						next j
						if e=1 then
							d=0
							for j=i+b to cl-(b-1) 'slide compare fragment
								e=1
								for k=0 to b-1
									if z(i+k)<>z(j+k) then
										e=0
										exit for
									end if
								next k
								if e=1 then
									d+=1
									j+=b-1
								end if
								if j>cl-(b-1) then exit for
							next j
							if d>p1 then
								p1=d
								p2=b
							end if
						end if
					next i
				next b
				score=(p1*p2)*((p1*p2)/cl) 'p1*p2
			case 13 'random shift cycles
				e=1
				for i=1 to cl-1
					if z(i)=z(i+1) then e=0
				next i
				for i=0 to cs
					for j=0 to cs
						cscf(i,j)=0
 					next j
				next i
				for i=1 to cs
					for j=i to cl step cs
						cscf(i,z(j))+=1
						if cscf(i,z(j))>cscf(i,0) then cscf(i,0)=cscf(i,z(j))
					next j
				next i
				a=0
				for i=1 to cs
					a+=cscf(i,0)
				next i
				if e=1 then score=(cl-a)*((cl-a)/cl)
		end select
		cto(cs,ct,0,0)+=score
		if recbestcycle=1 then
			lowscore=999999999
			for i=1 to 10 'find lowest
				if cto(cs,ct,i,0)<lowscore then
					lowscore=cto(cs,ct,i,0)
					a=i
				end if
			next i	
			if score>lowscore then 'record best cycle
				cto(cs,ct,a,0)=score
				cto(cs,ct,a,1)=cl
				for j=1 to cl
					select case z(j)
						case 1:cto(cs,ct,a,j+1)=l1
						case 2:cto(cs,ct,a,j+1)=l2
						case 3:cto(cs,ct,a,j+1)=l3
						case 4:cto(cs,ct,a,j+1)=l4
						case 5:cto(cs,ct,a,j+1)=l5
						case 6:cto(cs,ct,a,j+1)=l6
						case 7:cto(cs,ct,a,j+1)=l7
					end select
				next j
			end if
		end if
	end if
next ct