os+="Score: "+rdc(thread(t).score,2)+" IOC: "+rdc(thread(t).ioc,4)+" Multiplicity: "+rdc(thread(t).multiplicity,4)+stt(thread(t).sectime)+lb
if solvesub_advstats=1 then
	os+=str(thread(t).repeats)+lb
	if solvesub_nosub=0 then os+="PC-cycles: "+str(thread(t).pccycles)+lb
	'if ngram_standardalphabet=1 then os+=" Word-flow: "+rdc(thread(t).wordflow,2)
end if