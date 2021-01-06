AZdecrypt can use 2, 3, 4, 5, 6 and 8 letter n-grams with most of its solvers. By default AZdecrypt uses 5-grams. To use another n-gram size click on File and then pick Load n-grams.

The n-gram format for 5-grams is as following: "EXAMP123XAMPL  9AMPLE 77" or "EXAMP123XAMPL009AMPLE077". The numeric value is the log score of each n-gram and may not exceed 255.

Or in binary where each byte is a n-gram log value from 0 to 255 from n-gram AAAAA, AAAAB, AAAAC to n-gram ZZZZZ.

AZdecrypt can read n-gram files directly from .gz files.