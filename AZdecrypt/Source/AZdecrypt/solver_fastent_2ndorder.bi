select case solvesub_fastent
	case 0:new_score(n)=new_ngram_score(n)*ngfal*fastpow1_single(entropy(n),entweight)
	case 1:new_score(n)=new_ngram_score(n)*ngfal*entropy(n)^0.25
	case 2:new_score(n)=new_ngram_score(n)*ngfal*entropy(n)^0.5
	case 3:new_score(n)=new_ngram_score(n)*ngfal*entropy(n)^0.75
	case 4:new_score(n)=new_ngram_score(n)*ngfal*entropy(n)
	case 5:new_score(n)=new_ngram_score(n)*ngfal*entropy(n)^1.5
	case 6:new_score(n)=new_ngram_score(n)*ngfal*entropy(n)*entropy(n)
end select