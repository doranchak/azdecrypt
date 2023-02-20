AZdecrypt 1.22 by jarlve@yahoo.com (20/02/23) dd/mm/yy
--------------------------------------------------------
A powerful multi-threaded letter n-gram based substitution cipher solver for Windows since 2014. Originally written in attempt to solve the Zodiac Killer's unsolved 340 code.

FreeBASIC: http://www.freebasic.net/
Simple GUI: http://www.freebasic.net/forum/viewtopic.php?f=8&t=24617
Discussion and support: https://www.freebasic.net/forum/viewtopic.php?t=23188

- FreeBASIC version 1.09.0 using GCC 9.3.0.
- Reddit n-grams version 1912.
- beijinghouse n-grams version 6.

- Thanks to beijinghouse @ www.zodiackillersite.com for:
--------------------------------------------------------
--> Providing excellent all-around n-grams that were compiled from a multi-terabyte corpus.
--> Special no-compromise low memory n-gram format.
--> Recoding the text n-gram loading routine so that it is up to 20 times faster with the added support for loading n-grams directly from .gz files.
--> Several code optimizations to the solvers which increase speed by up to 10%.
--> N-gram score calculation abort routine which speeds up the solver when using higher n-gram sizes.
--> The many suggestions and working with me on AZdecrypt from 2019 to 2020.
--> Monoalphabetic groups solver idea.

- Thanks to Geoff L. (smokie treats @ www.zodiackillersite.com) for:
--------------------------------------------------------------------
--> Helping me design and test the "nulls and skips" solver and for the creation of countless test ciphers and cipher statistics.
--> the idea for the "row bound" and "row bound fragments" solvers.
--> the 2-symbol cycles idea.

- Thanks to David Oranchak for all his work surrounding the Zodiac ciphers and cryptology. And for spreading awareness about AZdecrypt.
- Thanks to Richard @ https://www.freebasic.net/forum/ for his fast exponentiate approximation function.
- Many thanks to the people of the Zodiackillersite cipher forums for their help and support: daikon, doranchak, glurk, Largo, Marclean, Mr lowe, smokie treats, f.reichmann, beldenge and many more.
- Many thanks to the people of the FreeBASIC forum for helping me out with code issues: counting_pine, dodicat, fxm, jj2007, Lothar Schirm, MichaelW, MrSwiss, paul doe, PaulSquires, SARG, srvaldez, St_W and many more.

Various resources:
--------------------------------------------------------------------
David Oranchak's Zodiac Ciphers wiki: http://zodiackillerciphers.com/wiki/index.php?title=Main_Page
David Oranchak's Cipher Explorer: http://zodiackillersite.com/viewtopic.php?f=81&t=3661
David Oranchak's WebToy: http://zodiackillerciphers.com/webtoy/
David Oranchak's CryptoScope: http://zodiackillerciphers.com/webtoy/stats.html
glurk's zkdecrypto: https://code.google.com/archive/p/zkdecrypto/
Largo's Peek-a-boo: http://www.zodiackillersite.com/viewtopic.php?f=81&t=3255
CrypTool: https://www.cryptool.org/en/
George Belden's Project Zenith: http://projectzenith.net/dashboard
f.reichmann's solvers: http://zodiackillersite.com/viewtopic.php?f=81&t=5013
https://ciphermysteries.com/
Cipherbrain: https://scienceblogs.de/klausis-krypto-kolumne/
Cipher challenges: https://mysterytwister.org/home/welcome/
https://www.gzip.org/
https://zlib.net/

AZdecrypt draws heavily upon the collection of language data at: https://wortschatz.uni-leipzig.de/en/usage
https://creativecommons.org/licenses/by-nc/4.0/

Let me know if I have forgotten you or something else!

AZdecrypt achievements:
-----------------------
AZdecrypt mentioned in research paper: https://ep.liu.se/ecp/158/012/ecp19158012.pdf
AZdecrypt world record 1: https://scienceblogs.de/klausis-krypto-kolumne/2019/10/27/bigram-1000-challenge-solved-new-world-record-set/
AZdecrypt world record 2: https://scienceblogs.de/klausis-krypto-kolumne/2019/12/19/bigram-750-challenge-solved-new-world-record-set/
Zodiac 340 cipher: https://www.youtube.com/watch?v=-1oQLPRE21o
Langrenus cipher: https://scienceblogs.de/klausis-krypto-kolumne/2021/02/18/jarl-van-eycke-loest-400-jahre-alte-laengengrad-botschaft/