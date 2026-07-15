os+="Score: "+rdc(thread(t).score,2)+" IOC: "+rdc(thread(t).ioc,4)+" Multiplicity: "+rdc(thread(t).multiplicity,4)+stt(thread(t).sectime)+lb
if solvesub_advstats=1 then
	if thread(t).repeats<>"" then os+=str(thread(t).repeats)+lb
	if solvesub_nosub=0 then 
		select case thread(t).solver_outputid
			case 0,1
				os+="PC-cycles: "+str(thread(t).pccycles)
				os+=" Homophones: "+str(thread(t).homophones)+lb
			case 9
				'os+=lb
			case else
				os+="PC-cycles: "+str(thread(t).pccycles)
				os+=lb
		end select
	end if
	'if ngram_standardalphabet=1 then os+=" Word-flow: "+rdc(thread(t).wordflow,2)
end if