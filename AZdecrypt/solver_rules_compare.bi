cc=0
for ii=1 to l-(ngs_b-1)
	for jj=1 to l-(ngs_b-1)
		ee=1
		for kk=0 to ngs_b-1
			if pos3(jj+kk)<>pos1(ii+kk) then
				ee=0
				exit for
			end if
		next kk
		if ee=1 then exit for
	next jj
	if ee=0 then
		cc+=1
		info_out(cc)=ii
	end if
next ii
ccmax=cc*2
for ii=1 to l-(ngs_b-1)
	for jj=1 to l-(ngs_b-1)
		ee=1
		for kk=0 to ngs_b-1
			if pos1(jj+kk)<>pos3(ii+kk) then
				ee=0
				exit for
			end if
		next kk
		if ee=1 then exit for
	next jj
	if ee=0 then
		cc+=1
		info_out(cc)=ii
	end if
	if cc=ccmax then exit for
next ii