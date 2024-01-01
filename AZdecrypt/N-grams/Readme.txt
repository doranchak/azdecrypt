AZdecrypt can use 2, 3, 4, 5, 6, 7, 8, and 9 letter n-grams with most of its solvers. By default AZdecrypt uses 5-grams. To use another n-gram size click on File and then click Load letter n-grams.

The n-gram text format for 5-grams is as following: "EXAMP123XAMPL 9AMPLE 77" or "EXAMP123XAMPL009AMPLE077". The numeric value is the log score of each n-gram and may not exceed 255.

A full example of this is included with the program as "AZdecrypt/N-grams/5-grams_english_practicalcryptography_wortschatz.txt".

Each n-gram file also needs to have a valid .ini file with the same name expect the extension.

Only the symbols (alphabet) that are defined in the n-grams .ini file (for example ABCDEFGHIJKLMNOPQRSTUVWXYZ) can be used in the n-gram file. That said, one may choose the alphabet freely, as long as they match.

There is currently no support for Unicode.

The format can also be in binary where each byte is a n-gram log byte value from 0 to 255 from n-gram AAAAA, AAAAB, AAAAC to n-gram ZZZZZ.

AZdecrypt can auto-detect between text and binary format. But can be forced to read the n-grams in text or binary by using either the "t" or "b" prefix in the n-grams .ini file as follows "N-gram size=t5" or "N-gram size=b5".

AZdecrypt can read n-gram files directly from compressed .gz files.

The 8-gram format requires a secondary table file be present as well. This file specifies the 4-sub-gram indexes. For a 26 letter alphabet, the table has 26^4 = 456,976 entries. Each entry has a 2-byte low word followed by a 2-byte high word. All 456,976 permutations of letters in the alphabet must be explicitly enumerated (even if zero). For example, if the alphabet is ABCDEFGHIJKLMNOPQRSTUVWXYZ, then the first entry represents the index number for the 4-sub-gram AAAA, the next is AAAB, and so on in lexicographical order according to the alphabet specification in the .ini file (all the way to ZZZZ in this case). This file must be named the same as the main file except end with "_table.txt" or "_table.txt.gz" or "_table.gz".

The main 8-gram file itself is a 2-d byte array with each byte signifying values from 0-255 for log score of the first and second 4-sub-gram indexes at that position in the array. By convention, the zero index is also populated with actual zeros. This requires a small amount of extra disk and memory space, but allows for direct addressing of the table without gate checking table lookups. Because of this, the size of the main 8-gram file is equal to the square of one more than the largest index in the table file. It is of course wise to enumerate table indexes in order from 1 and going higher, without skipping any values. It is also wise to order indexes with lowest values representing the most vital 4-sub-grams since AZdecrypt will drop the highest indexes when instructed to limit memory usage.


Jarlve's n-gram files draws heavily upon the collection of language data at:
https://wortschatz.uni-leipzig.de/en/usage
https://creativecommons.org/licenses/by-nc/4.0/