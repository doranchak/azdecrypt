select case solvesub_fastent
	case 0:new_score=new_ngram_score*ngfal*fastpow1_single(entropy,entweight)
	case 1:new_score=new_ngram_score*ngfal*entropy^0.25
	case 2:new_score=new_ngram_score*ngfal*entropy^0.5
	case 3:new_score=new_ngram_score*ngfal*entropy^0.75
	case 4:new_score=new_ngram_score*ngfal*entropy
	case 5:new_score=new_ngram_score*ngfal*entropy^1.5
	case 6:new_score=new_ngram_score*ngfal*entropy*entropy
end select