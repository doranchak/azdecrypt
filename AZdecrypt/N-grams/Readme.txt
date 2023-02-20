AZdecrypt can use 2, 3, 4, 5, 6 and 8 letter n-grams with most of its solvers. By default AZdecrypt uses 5-grams. To use another n-gram size click on File and then click Load letter n-grams.

The n-gram format for 5-grams is as following: "EXAMP123XAMPL 9AMPLE 77" or "EXAMP123XAMPL009AMPLE077". The numeric value is the log score of each n-gram and may not exceed 255.

A full example of this is included with the program as "AZdecrypt/N-grams/5-grams_english_practicalcryptography_wortschatz.txt".

Each n-gram file also needs to have a valid .ini file with the same name expect the extension.

Only the symbols (alphabet) that are defined in the n-grams .ini file (for example ABCDEFGHIJKLMNOPQRSTUVWXYZ) can be used in the n-gram file. That said, one may choose the alphabet freely, as long as they match.

There is currently no support for Unicode.

The format can also be in binary where each byte is a n-gram log byte value from 0 to 255 from n-gram AAAAA, AAAAB, AAAAC to n-gram ZZZZZ.

AZdecrypt can auto-detect between text and binary format. But can be forced to read the n-grams in text or binary by using either the "t" or "b" prefix in the n-grams .ini file as follows "N-gram size=t5" or "N-gram size=b5".

AZdecrypt can read n-gram files directly from .gz files.

AZdecrypt draws heavily upon the collection of language data at: https://wortschatz.uni-leipzig.de/en/usage
https://creativecommons.org/licenses/by-nc/4.0/