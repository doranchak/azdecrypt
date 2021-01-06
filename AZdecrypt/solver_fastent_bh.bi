select case solvesub_fastent
	case 0:ent2=fastpow1_single(entropy,entweight)
	case 1:ent2=entropy^0.25
	case 2:ent2=entropy^0.5
	case 3:ent2=entropy^0.75
	case 4:ent2=entropy
	case 5:ent2=entropy^1.5
	case 6:ent2=entropy*entropy
end select