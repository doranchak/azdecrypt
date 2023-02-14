# AZDecrypt <a name="azdecrypt"></a>

AZdecrypt is a fast and powerful hillclimbing classical cipher solver written in [FreeBASIC](https://www.freebasic.net/).

Latest binaries can be found here:  https://zodiackiller.net/community/zodiac-cipher-mailings-discussion/azdecrypt-1-19b/

# Table of Contents
1. [Solvers](#solvers)
2. [Settings](#settings)
3. [Build Steps](#build)
4. [Stats](#stats)
5. [Notes, Tips, and Tricks](#notes)

# Solvers <a name="solvers"></a>

AZDecrypt's main window has a list of solvers.  Each one is a type of hillclimber that specializes in different types of ciphers:

## Substitution

Simple substitution ciphers (including homophonic substitution)

## Substitution + columnar rearrangement

A combination of simple substitution and moving columns around.

## Substitution + columnar transposition

A combination of simple substitution and [columnar transposition](https://en.wikipedia.org/wiki/Transposition_cipher#Columnar_transposition).
## Substitution + crib grid
This solver displays a grid that is the same shape as the input cipher.  You can enter your guesses for portions of the plaintext.  Then, the solver will search for the rest of the plaintext but maintain the plaintext entries you've made.
## Substitution + crib list
## Substitution + monoalphabetic groups
## Substitution + nulls and skips
Tries to figure out if certain symbols in a substitution cipher don't actually contribute towards the plaintext.
A "null" is a position in the cipher text that does not translate to plaintext (and is ignored during decryption).  The solver will consider different positions to be nulls, and exclude them prior to the next steps of decryption.
A "skip" is a missing symbol that is inserted at some position in the cipher.  The solver will put them in different positions of the ciphertext before proceeding to the next steps of decryption.
[More info](http://www.zodiackillersite.com/viewtopic.php?f=81&t=4125)
## Substitution + polyphones
## Substitution + row bound
## Substitution + row bound fragments
## Substitution + sequential homophones
## Substitution + simple transposition
## Substitution + sparse polyalphabetism
## Substitution + units
Jarl's note on using this solver on nomenclator type ciphers:
* After launching the solver a menu will pop up. You can set the Unit as Symbol or Horizontal sequence, the Mode to Replace with new symbols. If selected Horizontal sequence set the Horizontal sequence to 1. The Key length start determines the amount of Symbols or Horizontal sequences to be replaced. And set Replace, # of symbols per instance to 2 if you want to replace symbols with bigrams for example.
## Substitution + vigenere
## Substitution + vigenere word list
## Bigram substitution
## Higher-order homophonic
## Merge sequential homophones
## Non-substitution
Scores your plain text and provides detailed n-gram stats
## Columnar transposition (keyed)
## Columnar rearrangement (keyed)
[Demonstration](https://www.freebasic.net/forum/viewtopic.php?p=291162&sid=bc32599734174f3a33be0cb32188da84#p291162)
## Grid rearrangement (keyed)
## Periodic transposition

[Demonstration of partial solve on transposed Z340 plaintext](https://zodiackiller.net/community/postid/88298/)

Can solve a whole variety of transposition ciphers keyed or unkeyed as long as the transposition can be summarized by a limited set of periodic rules.
Select "Periodic transposition [auto]" or "Periodic transposition inverted [auto]" if you want the solver to try to automatically determine the transposition.
Note that the transposition solver will write additional output to the Output folder (for example, the transposition matrices it finds).

One of the factors that guides this solver is *periodic redundancy*, a measurement that looks at periodicity in candidate transposition matrices.  Matrices that have a lot of periodic behavior will have a lot of repeating periods, which increases periodic redundancy.  If there is more randomness to the matrix, periodic redundancy will be low.  This measurement is balanced against the n-grams score to try to arrive at the correct transposition matrix.  [More info here in Jarl's post](https://zodiackiller.net/community/postid/88297/).

**Normal vs inverted transposition matrices**

Say we have the following transposition matrix:

```1   3   5   7   9   11  13  15  17  19  21  23  25  27  29  31  33
35  37  39  41  43  45  47  49  51  53  55  57  59  61  63  65  67
69  71  73  75  77  79  81  83  85  87  89  91  93  95  97  99  101
103 105 107 109 111 113 115 117 119 118 116 114 112 110 108 106 104
102 100 98  96  94  92  90  88  86  84  82  80  78  76  74  72  70
68  66  64  62  60  58  56  54  52  50  48  46  44  42  40  38  36
34  32  30  28  26  24  22  20  18  16  14  12  10  8   6   4   2
```

A) Say we put the first letter of the plaintext at position 1, the second letter at pos 2, then pos 3 etc. (transposition)

If we use the methodology I explained in the link we end up with the following period map:

```118  -117 116  -115 114  -113 112  -111 110  -109 108  -107 106  -105 104  -103 102
-101 100  -99  98   -97  96   -95  94   -93  92   -91  90   -89  88   -87  86   -85
84   -83  82   -81  80   -79  78   -77  76   -75  74   -73  72   -71  70   -69  68
-67  66   -65  64   -63  62   -61  60   -59  58   -57  56   -55  54   -53  52   -51
50   -49  48   -47  46   -45  44   -43  42   -41  40   -39  38   -37  36   -35  34
-33  32   -31  30   -29  28   -27  26   -25  24   -23  22   -21  20   -19  18   -17
16   -15  14   -13  12   -11  10   -9   8    -7   6    -5   4    -3   2    -1
```

These are all unique periods so the solver could never get it. Study the matrices and see why.

Now, if we go back to step A, instead of putting, we get the letter from position 1, then we get the letter from pos 2 etc. (untransposition)

It would equal to the following matrix (for putting, transposition)

```1   119 2   118 3   117 4   116 5   115 6   114 7   113 8   112 9
111 10  110 11  109 12  108 13  107 14  106 15  105 16  104 17  103
18  102 19  101 20  100 21  99  22  98  23  97  24  96  25  95  26
94  27  93  28  92  29  91  30  90  31  89  32  88  33  87  34  86
35  85  36  84  37  83  38  82  39  81  40  80  41  79  42  78  43
77  44  76  45  75  46  74  47  73  48  72  49  71  50  70  51  69
52  68  53  67  54  66  55  65  56  64  57  63  58  62  59  61  60
```

And if we extract the period map now we get:

```2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2
2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2
2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2
2  2  2  2  2  2  2  2  -1 -2 -2 -2 -2 -2 -2 -2 -2
-2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2
-2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2
-2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2
```

So now it's periodic again. So by inverting the matrix in the solver we can solve these more difficult cases.

Jarl made a tool for analyzing transposition matrices as of AZdecrypt 1.21: *Stats, transposition matrix analysis*.

Also, if you go to *Format*, and then *Convert*, there are tools to extract period maps and invert matrices, etc.

Put in the first matrix, the one that starts with `1 3 5` etc and click *transposition matrix analysis*.

Output should be:

```AZdecrypt transposition matrix stats for: test.txt
---------------------------------------------------------
Locality (linear distance between numbers): 98.31%, 0.83%
Locality (distance from natural positions): 33.89%, 33.89%

Periodic stepping: redundancy% (inverted, standard)
--------------------------------------------------
1: 84.57%, 0%
2: 83.62%, 85.44%
3: 82.67%, 0%
4: 81.70%, 85.39%
5: 80.71%, 0%
6: 79.71%, 85.33%
```

It shows that the logarithmic periodic redundancy at stepping 1 inverted is 84.57%, meaning that it should be easy to solve.

More difficult cases require higher stepping levels to solve.

## Simple transposition
The same solver as the Substitution + simple transposition but does not perform substitution

---

# Settings <a name="settings"></a>

Under "Options -> Solvers":

## [General] CPU Threads

## [General] Thread wait

## [General] Entropy weight

## [General] Iterations

The number of total iterations performed during the search by the main hill climber (aka, the "inner" hill climber.  see "Hill climber iterations" below).  Note: When AZdecrypt writes results to the Output directory, it will write intermediate output files after 60 seconds of no output.  This is more likely to occur when the solver takes a while to run, such as when iterations are high.

List of solvers that use only the inner hill climber (and thus, "hill climber iterations" setting will have no additional effect):

* Substitution
* Substitution + crib grid
* Substitution + crib list
* Substitution + monoalphabetic groups
* Substitution + polyphones: User defined polyphones
* Substitution + polyphones: Hafer shifts: -N/+N
* Substitution + row bound
* Substitution + sequential homophones
* Substitution + sparse polyalphabetism
* Substitution + vigenère word list
* Bigram substitution
* Higher-order homophonic
* Merge sequential homophones

## [General] Iterations factor

## [General] Hill climber iterations

Some solvers use two hill climbers: An "inner" hill climber, and an "outer" hill climber.  The "iterations" setting is for the inner hill climber (substitution solver etc), and the "hill climber iterations" setting is for a secondary hill-climber on top of the substitution hill-climber.  For example, solvers that use a secondary hill-climber have the following on top in the Output window: Restart: 1 Hill climber: 90/5000 @ 500000. The 5000 here are the hill-climber iterations and the 500000 the iterations.

List of solvers that use both the inner and outer hill climbers:

* Substitution + columnar rearrangement
* Substitution + columnar transposition
* Substitution + nulls and skips
* Substitution + polyphones: User defined polyphones + extra letters
* Substitution + polyphones: Hafer shifts: any 2 shifts
* Substitution + row bound fragments
* Substitution + simple transposition
* Substitution + units
* Substitution + vigenère

## [General] Hill climber iterations factor
## [General] N-gram factor
## [General] Multiplicity weight

This value will "punish" solutions that are produced by increasing the multiplicity (ratio of unique symbols to cipher length) of the cipher text.  Defaults to 0 which means this punishment will not occur.  A value of 1 is a good starting point for including the punishment.

Jarl says:  It follows this calculation: `score/=1+((unique_symbols/cipher_length)*multiplicity_weight)`. The higher the multiplicity, the more the score will be reduced. It may prevent some of the solvers from inflating the score by changes that increase multiplicity. It will still do that but now there is a trade off.  Secondly it can also be used as a filter, in case of using the Substitution + units solver for removing the spaces as nulls, the key size (amount of null symbols) will increase with every hill-climber iteration and eventually the multiplicity will become very high and the solver may find non-solutions that exceed the score of the underlying plain text, in that case the multiplicity weight will punish these and the best solution (according to the multiplicity weight trade off) will still be on top, sort of.

## [General] Output to file
## [General] Output to batch
## [General] Output scores over
## [General] Output improvements only
## [General] Output additional stats
## [General] Overwrite existing solver output
## [General] Add PC-cycles to file output format
## [General] Restarts
## [General] Temperature
## [General] Enable memory checks
## [General] Enable screen size checks
## [General] 8-gram memory limit
## [General] 8-gram caching
## [General] Add spaces to output
## [General] Add spaces to output iterations
## [General] N-gram log value cut-off

---

# Build steps <a name="build"></a>

1. Unzip the 3 folders in the root of C drive. (`AZdecrypt`, `FbEdit` and `FreeBASIC-1.09.0-winlibs-gcc-9.3.0`)
2. Open `FbEdit` under `FbEdit`.
3. Open `AZdecrypt.bas`.
4. Click the green play icon to compile and run.

Next to the green play icon there is `Windows GCC` which can be changed to `Windows GAS` for much faster compilation time. But GAS builds a slower program.

Options, Build Options to change compiler flags.

Options, Path Options to change paths.

The substitution solver = `sub azdecrypt_234567810g(byval tn_ptr as any ptr)`.

# Stats <a name="stats"></a>

## Unigrams

[Jarl demonstrates how to extract periodicities from a transposition matrix entered in the input window](https://zodiackiller.net/community/postid/88297/), and explains Entropy vs Normalized Entropy.

## Symbol n-grams

## Encoding

## Observations

## Alphabets

## Hafer shifts

## Output graphs

## Periodic analysis

## Transposition matrix analysis

## Compare input and output

## Find vigenere keyword length

## Find omnidirectional repeats

## Find plaintext direction

## Find encoding direction

## Find perfect n-symbol cycles

## Find n-symbol cycle types

## Find n-symbol cycle patterns

## Find sequential homphonic randomizations

## Find post sequential homophonic row or columnar rearrangement

---

# Notes, tips and tricks <a name="notes">

## Pangrams

AZDecrypt was not able to solve this cipher with default settings:

`ABC DEFGH IJKLM NKO PEQRS KTCJ U VUWX YKZ RUGH QX IKO LFAB NFTC YKWCM VFDEKJ PEZS`

The plaintext consists of two pangrams:

`THE QUICK BROWN FOX JUMPS OVER A LAZY DOG PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS`

Jarl's fix, under "Options -> Solvers":

* Boost Entropy weight to 10
* Click the "Normalize n-gram factor" button

Now it can solve the cipher.

## Batch mode

In batch mode (processing multiple ciphers), under default settings, AZDecrypt will not write output files if newly cracked ciphers' scores are not higher than previously cracked ciphers' scores.  To change this, set "Output improvements only" to "No" in "Options -> Solvers"

In v1.2, "Batch ciphers (non-substitution)" has been added to the File menu.

## Solving "Ambiguous Caesar shift" ciphers (aka Hafer ciphers or Hafer homophonic ciphers)

Instructions and details on configuring AZDecrypt to solve these kinds of ciphers [can be found here](https://zodiackiller.net/community/postid/78642/)  ([old broken link](http://zodiackillersite.com/viewtopic.php?p=81511#p81511))

The description of the encipherment system [is here](http://zodiackillersite.com/viewtopic.php?p=81498#p81498).

Jarlve posted a new version of AZDecrypt that can solve Hafer ciphers [here](http://zodiackillersite.com/viewtopic.php?p=81853#p81853).

## Polyphone solver improvements

Jarl has added improvements to the polyphone solver.  [Details here](http://zodiackillersite.com/viewtopic.php?p=81694#p81694).

## Compute score for a given plaintext

Select the "Non-substitution" solver.

Before that feature was available, it was achievable like this: Use the "Substitution + crib grid" solver, click on Show cipher and then type in the letters of the plain text. Though you will have to leave one letter uncribbed for it to work.

## Homophonic substitution with spaces

Sometimes a homophonic substitution cipher will encode spaces with one or more symbols.  

To solve it:  Go to File, Load n-grams, navigate to `AZdecrypt/N-grams/Spaces` and select "5-grams_english+spaces_jarlve_reddit".

Before that method was available, one way was to select the Substitution + units solver with the standard settings, Unit: symbol, Mode: Remove and perhaps Multiplicity weight: 1.   [Thread](http://zodiackillersite.com/viewtopic.php?f=81&t=5059#p82408)

## Using AZDecrypt to auto-insert spaces in input

Sometimes you have a plaintext that lacks spaces and want to automatically add spaces between words (or what might seem like words).  Steps:

* Put a plaintext into the Input window and go to Format, Add spaces to plaintext.
* The spacing is based on the two letter 5-grams files inside the N-grams\Spaces directory.
* Under Options, Solver options there are two settings related to it:
    * (General) Add spaces to output
    * (General) Add spaces to output iterations
* It uses a small hill climber for the function so upping the iterations may improve quality slightly.

