if local_advstats=1 then
	select case solver_output
		case 0,2,4,6 'substitution, no-substitution, higher-order, bigram, mono-groups, row-bound
			thread(tn).repeats=m_repeats(thread(tn).sol(),l,0)
			'if ngram_standardalphabet=1 then thread(tn).wordflow=m_wordflow(thread(tn).sol(),l)
			if local_pcmode=0 then 'use transposed texts
				if solvesub_nosub=0 then thread(tn).pccycles=m_pccycles_longshort(thread(tn).sol(),nba(),l,s)
			else 'use untransposed texts
				if solvesub_nosub=0 then
					dim as short utp_nba(l),utp_sol(l)
					for i=1 to l
						utp_nba(thread(tn).key(i))=nba(i)
						utp_sol(thread(tn).key(i))=thread(tn).sol(i)
					next i
					thread(tn).pccycles=m_pccycles_shortshort(utp_sol(),utp_nba(),l,s)
				end if
			end if
		case 1,3,7 'poly, sparse, vigenere
			if local_advstats=1 then
				thread(tn).repeats=m_repeats(thread(tn).sol(),l,0)
				thread(tn).pccycles=m_pccycles_longshort(thread(tn).sol(),nba(),l,s)
				'if ngram_standardalphabet=1 then thread(tn).wordflow=m_wordflow(thread(tn).sol(),l)
			end if
		case 5 'mergeseqhom
			if local_advstats=1 then
				thread(tn).repeats=m_repeats(thread(tn).sol(),l,thread(tn).num)
				thread(tn).pccycles=m_pccycles_longshort(thread(tn).key(),nba(),l,s)
			end if
	end select
end if