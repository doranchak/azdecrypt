dim as integer tn=cint(tn_ptr) 'thread number
dim as uinteger seed=tn 'seed for rnd
thread(tn).thread_active=1
thread(tn).thread_stop=0
thread(tn).solver_waiting=1

dim as integer e,f,g,h,i,j,k,r
dim as integer lv,lr,rr,lvmax 'sub-restarts
dim as integer blt,bls 'pick letter
dim as integer b,bl,bm 'ext_hc
dim as integer solution_improved,improved,accept,wi
dim as integer local_advstats,local_pcmode,local_outputdir,local_outputbatch,local_outputimp,local_over 'locals
dim as integer al,ll,new_letter,old_letter,curr_symbol,older_letter,new_ngram_score,old_ngram_score,ioc_int,frcmax
dim as integer shifts 'hafer
dim as integer ns,rp,acu,rc0_symbol,rc0_number,rc1_symbol,rc1_poly,rchange,pos1,prev_es,old_poly 'poly
dim as integer num_ngrams,z,z1,z2 'bh
dim as integer cl,cs,low,mii,cal,tcs 'seqhom
dim as integer cur_its,cur_pos,match_int,old_match_int,old_mpp2,nl2 'sparse
dim as integer ngrf,ngrt,ngs 'row-bound
dim as integer subtract,vig_letter 'vigenere

dim as uinteger it,iterations,random_restarts
dim as long state 'faster than 64-bit integer

dim as double m,ls
dim as double d,mc,mc_minus 'pick letter
dim as double bbest,bioc 'ext_hc
dim as double new_score,old_score,best_score,ioc,temp,temp_min,start_temp
dim as double entweight,ngramfactor,multiplicityweight,curr_temp,ngf,ngfal,ngfent
dim as double entropy,old_entropy,onesixl,ent_score_norm,tempdiv,solution_timer
dim as double tes,rndroll 'poly
dim as double hi,ent2,score_needed 'bh
dim as double new_cycle_score,old_cycle_score,cycle_new,cycle_old 'seqhom
dim as double norm,old_norm 'groups
dim as double total_ngrams,total_ngrams2,avgngs,rowscore 'row-bound
dim as double entropy1,entropy2 'vigenere

dim as string filename,solstring