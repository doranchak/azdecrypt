state=2480367069*state and 4294967295  ' advance state for new letter

if j<3 then
	new_letter=prior_letter(sol(j+ngram_size-h), sol(j+1+ngram_size-h), state)
elseif j>(l-2) then
	new_letter=next_letter(sol(j-3+ngram_size-h), sol(j-2+ngram_size-h), state)
else
	new_letter=mid_letter(sol(j-3+ngram_size-h), sol(j-2+ngram_size-h), sol(j+ngram_size-h), sol(j+1+ngram_size-h), state)
end if

if new_letter=old_letter then				' insure letter actually changes
	#include "solver_randomnewletter.bi"
end if