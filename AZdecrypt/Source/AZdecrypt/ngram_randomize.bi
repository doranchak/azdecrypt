select case ngram_system
	case 3 'nn
		for i=0 to nn_items-1
			nn1(i)=int(rnd*2)
		next i
		'#include "ngram_nn1_tables.bi"
		ui_editbox_settext(output_text,"N-gram values randomized")
end select