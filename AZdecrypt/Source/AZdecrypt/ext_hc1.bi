bm=1
select case ext_hc
	case 1 'columnar rearrangement bigram beam
		ext_bigram_beam_columnarrearrangement(tn,l,s,solvesub_ctcolumns)
	case 2 'columnar rearrangement azd beam
		bbest=0
		ext_azd_beam_columnarrearrangement(tn,l,s,solvesub_ctcolumns)
		bm=extcip(tn,1,0)
	case 3 'columnar transposition bigram beam
		ext_bigram_beam_columnartransposition(tn,l,s,solvesub_ctcolumns)
	case 4 'columnar transposition azd beam
		bbest=0
		ext_azd_beam_columnartransposition(tn,l,s,solvesub_ctcolumns)
		bm=extcip(tn,1,0)
	case 5 'nulls and skips azd beam
		bbest=0
		ext_azd_beam_nullsandskips(tn,l,s,solvesub_pnkl)
		bm=extcip(tn,1,0)
end select