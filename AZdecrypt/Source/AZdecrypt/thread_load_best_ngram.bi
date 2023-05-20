select case ngram_size
		
	case 2
		
		redim g2b(0,0)
		redim g2b(1,ngram_alphabet_size-1)
		dim as ubyte hn(1,1)
		for x1=0 to ngram_alphabet_size-1
			for i=0 to ngram_alphabet_size-1
				if g2(i,x1)>hn(1,0) then hn(1,0)=g2(i,x1):hn(1,1)=i
				if g2(x1,i)>hn(0,0) then hn(0,0)=g2(x1,i):hn(0,1)=i
			next i
			for i=0 to 1
				if hn(i,0)>0 then g2b(i,x1)=hn(i,1) else g2b(i,x1)=ngram_alphabet_size
			next i
			erase hn
		next x1
		
	case 3
		
		redim g3b(0,0,0)
		redim g3b(2,ngram_alphabet_size-1,ngram_alphabet_size-1)
		dim as ubyte hn(2,1)
		for x1=0 to ngram_alphabet_size-1
			for x2=0 to ngram_alphabet_size-1
				for i=0 to ngram_alphabet_size-1
					if g3(i,x1,x2)>hn(2,0) then hn(2,0)=g3(i,x1,x2):hn(2,1)=i
					if g3(x1,i,x2)>hn(1,0) then hn(1,0)=g3(x1,i,x2):hn(1,1)=i
					if g3(x1,x2,i)>hn(0,0) then hn(0,0)=g3(x1,x2,i):hn(0,1)=i
				next i
				for i=0 to 2
					if hn(i,0)>0 then g3b(i,x1,x2)=hn(i,1) else g3b(i,x1,x2)=ngram_alphabet_size
				next i
				erase hn
			next x2
		next x1
		
	case 4
		
		redim g4b(0,0,0,0)
		redim g4b(3,ngram_alphabet_size-1,ngram_alphabet_size-1,ngram_alphabet_size-1)
		dim as ubyte hn(3,1)
		for x1=0 to ngram_alphabet_size-1
			for x2=0 to ngram_alphabet_size-1
				for x3=0 to ngram_alphabet_size-1
					for i=0 to ngram_alphabet_size-1
						if g4(i,x1,x2,x3)>hn(3,0) then hn(3,0)=g4(i,x1,x2,x3):hn(3,1)=i
						if g4(x1,i,x2,x3)>hn(2,0) then hn(2,0)=g4(x1,i,x2,x3):hn(2,1)=i
						if g4(x1,x2,i,x3)>hn(1,0) then hn(1,0)=g4(x1,x2,i,x3):hn(1,1)=i
						if g4(x1,x2,x3,i)>hn(0,0) then hn(0,0)=g4(x1,x2,x3,i):hn(0,1)=i
					next i
					for i=0 to 3
						if hn(i,0)>0 then g4b(i,x1,x2,x3)=hn(i,1) else g4b(i,x1,x2,x3)=ngram_alphabet_size-1
					next i
					erase hn
				next x3
			next x2
		next x1
		
	case 5
		
		redim g5b(0,0,0,0,0)
		redim g5b(4,ngram_alphabet_size-1,ngram_alphabet_size-1,ngram_alphabet_size-1,ngram_alphabet_size-1)
		dim as ubyte hn(4,1)
		for x1=0 to ngram_alphabet_size-1
			for x2=0 to ngram_alphabet_size-1
				for x3=0 to ngram_alphabet_size-1
					for x4=0 to ngram_alphabet_size-1
						for i=0 to ngram_alphabet_size-1
							if g5(i,x1,x2,x3,x4)>hn(4,0) then hn(4,0)=g5(i,x1,x2,x3,x4):hn(4,1)=i
							if g5(x1,i,x2,x3,x4)>hn(3,0) then hn(3,0)=g5(x1,i,x2,x3,x4):hn(3,1)=i
							if g5(x1,x2,i,x3,x4)>hn(2,0) then hn(2,0)=g5(x1,x2,i,x3,x4):hn(2,1)=i
							if g5(x1,x2,x3,i,x4)>hn(1,0) then hn(1,0)=g5(x1,x2,x3,i,x4):hn(1,1)=i
							if g5(x1,x2,x3,x4,i)>hn(0,0) then hn(0,0)=g5(x1,x2,x3,x4,i):hn(0,1)=i
						next i
						for i=0 to 4
							if hn(i,0)>0 then g5b(i,x1,x2,x3,x4)=hn(i,1) else g5b(i,x1,x2,x3,x4)=ngram_alphabet_size
						next i
						erase hn
					next x4
				next x3
			next x2
		next x1
		
	case 6
		
		redim g6b(0,0,0,0,0,0)
		redim g6b(5,ngram_alphabet_size-1,ngram_alphabet_size-1,ngram_alphabet_size-1,ngram_alphabet_size-1,ngram_alphabet_size-1)
		dim as ubyte hn(5,1)
		for x1=0 to ngram_alphabet_size-1
			for x2=0 to ngram_alphabet_size-1
				for x3=0 to ngram_alphabet_size-1
					for x4=0 to ngram_alphabet_size-1
						for x5=0 to ngram_alphabet_size-1
							for i=0 to ngram_alphabet_size-1
								if g6(i,x1,x2,x3,x4,x5)>hn(5,0) then hn(5,0)=g6(i,x1,x2,x3,x4,x5):hn(5,1)=i
								if g6(x1,i,x2,x3,x4,x5)>hn(4,0) then hn(4,0)=g6(x1,i,x2,x3,x4,x5):hn(4,1)=i
								if g6(x1,x2,i,x3,x4,x5)>hn(3,0) then hn(3,0)=g6(x1,x2,i,x3,x4,x5):hn(3,1)=i
								if g6(x1,x2,x3,i,x4,x5)>hn(2,0) then hn(2,0)=g6(x1,x2,x3,i,x4,x5):hn(2,1)=i
								if g6(x1,x2,x3,x4,i,x5)>hn(1,0) then hn(1,0)=g6(x1,x2,x3,x4,i,x5):hn(1,1)=i
								if g6(x1,x2,x3,x4,x5,i)>hn(0,0) then hn(0,0)=g6(x1,x2,x3,x4,x5,i):hn(0,1)=i
							next i
							for i=0 to 5
								if hn(i,0)>0 then g6b(i,x1,x2,x3,x4,x5)=hn(i,1) else g6b(i,x1,x2,x3,x4,x5)=ngram_alphabet_size
							next i
							erase hn
						next x5
					next x4
				next x3
			next x2
		next x1
	
	case 7
		
		'j=0
		redim g7b(0,0,0,0,0,0,0)
		redim g7b(6,ngram_alphabet_size-1,ngram_alphabet_size-1,ngram_alphabet_size-1,ngram_alphabet_size-1,ngram_alphabet_size-1,ngram_alphabet_size-1)
		'dim as ubyte hn(6,1)
		'for x1=0 to nm1
		'	for x2=0 to nm1
		'		#include "ngram_table_progress.bi"
		'		for x3=0 to nm1
		'			for x4=0 to nm1
		'				for x5=0 to nm1
		'					for x6=0 to nm1
		'						j+=1
		'						for i=0 to nm1
		'							if g7(i,x1,x2,x3,x4,x5,x6)>hn(6,0) then hn(6,0)=g7(i,x1,x2,x3,x4,x5,x6):hn(6,1)=i
		'							if g7(x1,i,x2,x3,x4,x5,x6)>hn(5,0) then hn(5,0)=g7(x1,i,x2,x3,x4,x5,x6):hn(5,1)=i
		'							if g7(x1,x2,i,x3,x4,x5,x6)>hn(4,0) then hn(4,0)=g7(x1,x2,i,x3,x4,x5,x6):hn(4,1)=i
		'							if g7(x1,x2,x3,i,x4,x5,x6)>hn(3,0) then hn(3,0)=g7(x1,x2,x3,i,x4,x5,x6):hn(3,1)=i
		'							if g7(x1,x2,x3,x4,i,x5,x6)>hn(2,0) then hn(2,0)=g7(x1,x2,x3,x4,i,x5,x6):hn(2,1)=i
		'							if g7(x1,x2,x3,x4,x5,i,x6)>hn(1,0) then hn(1,0)=g7(x1,x2,x3,x4,x5,i,x6):hn(1,1)=i
		'							if g7(x1,x2,x3,x4,x5,x6,i)>hn(0,0) then hn(0,0)=g7(x1,x2,x3,x4,x5,x6,i):hn(0,1)=i
		'						next i
		'						for i=0 to 6
		'							if hn(i,0)>0 then g7b(i,x1,x2,x3,x4,x5,x6)=hn(i,1) else g7b(i,x1,x2,x3,x4,x5,x6)=nm1+1
		'						next i
		'						erase hn
		'					next x6
		'				next x5
		'			next x4
		'		next x3
		'	next x2
		'next x1
		
end select