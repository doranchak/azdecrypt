if currkey>maxkey then
	maxkey=currkey
	redim preserve ssconf(maxkey)
	redim preserve sscheck(maxkey)
	redim preserve ssscore(maxkey)
	redim preserve sskey(maxkey,key1to,1)
	redim preserve pbest(maxkey)
	redim preserve flat_score(maxkey)
	redim preserve latches(maxkey)
	redim preserve pkey(maxkey,key1to,1)
	redim preserve keysize(maxkey)
end if