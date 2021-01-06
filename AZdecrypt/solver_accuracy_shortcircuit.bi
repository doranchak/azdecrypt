if solvesub_accshortcircuit=1 andalso thread(tn).solkey=1 andalso new_score>10000 then 'accuracy short-circuit
	e=1
	for i=1 to l
		if thread(tn).key(i)<>42 then 'wildcard
			if thread(tn).sol(i)<>thread(tn).key(i) then
				e=0
				exit for
			end if
		end if
	next i
	if e=1 then
		for g=1 to s 'curr_symbol
			for h=0 to abc_sizem1 'new_letter
				if h<>stl(g) then
					curr_symbol=g
					old_letter=stl(g)
					new_letter=h
					dim as double entropy2=entropy
					dim as integer new_ngram_score2=new_ngram_score
					for i=1 to map1(curr_symbol,0) 'do
						sol(map1(curr_symbol,i))=new_letter
					next i
					#include "solver_ngram_main.bi"
					entropy2+=enttable(frq(old_letter)-mape2(curr_symbol))-enttable(frq(old_letter))
					entropy2+=enttable(frq(new_letter)+mape2(curr_symbol))-enttable(frq(new_letter))
					#include "solver_fastent.bi"
					if new_score>best_score then 'improvement found
						e=0
						exit for,for
					end if
					for i=1 to map1(curr_symbol,0) 'undo
						sol(map1(curr_symbol,i))=old_letter
					next i
				end if
			next h
		next g
		if e=1 then
			thread(tn).iterations_completed+=1
			exit for,for,for,for,for
		end if
	end if
end if