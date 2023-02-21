# AZDecrypt <a name="azdecrypt"></a>

AZdecrypt is a fast and powerful hillclimbing classical cipher solver written in [FreeBASIC](https://www.freebasic.net/).

Latest binaries can be found here:  
- https://zodiackiller.net/community/zodiac-cipher-mailings-discussion/azdecrypt-1-19b/
- https://www.freebasic.net/forum/viewtopic.php?p=203927#p203927

[Additional README](https://raw.githubusercontent.com/doranchak/azdecrypt/main/AZdecrypt/Readme.txt)

# Table of Contents
1. [Solvers](#solvers)
2. [Settings](#settings)
3. [Build Steps](#build)
4. [Stats](#stats)
5. [Notes, Tips, and Tricks](#notes)
6. [Release History](#releases)

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

```
1   3   5   7   9   11  13  15  17  19  21  23  25  27  29  31  33
35  37  39  41  43  45  47  49  51  53  55  57  59  61  63  65  67
69  71  73  75  77  79  81  83  85  87  89  91  93  95  97  99  101
103 105 107 109 111 113 115 117 119 118 116 114 112 110 108 106 104
102 100 98  96  94  92  90  88  86  84  82  80  78  76  74  72  70
68  66  64  62  60  58  56  54  52  50  48  46  44  42  40  38  36
34  32  30  28  26  24  22  20  18  16  14  12  10  8   6   4   2
```

A) Say we put the first letter of the plaintext at position 1, the second letter at pos 2, then pos 3 etc. (transposition)

If we use the methodology [explained here](https://zodiackiller.net/community/postid/88297/) we end up with the following period map:

```
118  -117 116  -115 114  -113 112  -111 110  -109 108  -107 106  -105 104  -103 102
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

```
1   119 2   118 3   117 4   116 5   115 6   114 7   113 8   112 9
111 10  110 11  109 12  108 13  107 14  106 15  105 16  104 17  103
18  102 19  101 20  100 21  99  22  98  23  97  24  96  25  95  26
94  27  93  28  92  29  91  30  90  31  89  32  88  33  87  34  86
35  85  36  84  37  83  38  82  39  81  40  80  41  79  42  78  43
77  44  76  45  75  46  74  47  73  48  72  49  71  50  70  51  69
52  68  53  67  54  66  55  65  56  64  57  63  58  62  59  61  60
```

And if we extract the period map now we get:

```
2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2
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

```
AZdecrypt transposition matrix stats for: test.txt
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

# Release History <a name="releases"></a>

## 1.22 - Feb 20, 2023

https://drive.google.com/file/d/12ngl8-_hd7EvofHRKkNB7VtBNBceB2Tl/view?usp=share_link

New features:

- Ciphers up to 4000 characters long, up from 2000

- Non-substitution Nulls and skips solver

- Automatic word spacing and dedicated n-grams for the following latin alphabet languages: Danish, Dutch, English, Finnish, French, German, Italian, Portuguese, Spanish and Swedish

- Chi-squared test for the languages above as well, (under Statistics)

- N-gram tools to convert/output existing n-grams to text or binary format. Plus downscaling of existing n-grams, from letter 5-grams to letter 4-grams etc (under File, N-gram tools)

- "Substitution + crib grid" can now be used in junction with "Substitution + simple transposistion". Have the pop-up windows of both solvers open and enable the "Use Substitution + crib grid" option in the Simple transposition solver window to have it work.

- Homophone weight setting (under Settings, Solver settings) that works for all solvers that output the number of homophones in the Output window, and the latter being a new addition as well.

- Added some error checking for loading n-grams, possible problems will show up as *** WARNINGS ***

- Lots of bugfixes, small additions and improvements

## 1.21 - Apr 23, 2022

## 1.20 - Mar 28, 2022

https://drive.google.com/file/d/1gfdgnbuntedRPyG472QekZo-bImGR3D6/view?usp=sharing

Added a whole bunch of transpositions solvers that operate on non-subsitution ciphers:

Non-substitution (scores your plain text + detailed n-gram stats)
Columnar transposition (keyed)
Columnar rearrangement (keyed)
Grid rearrangement (keyed)
Periodic transposition (can solve a whole variety of transposition ciphers keyed or unkeyed as long as the transposition can be summarized by a limited set of periodic rules)
Simple transposition (the same solver as the Substitution + simple transposition but does not perform substitution)

Also File, Batch ciphers (non-subsitution) has been added.

Additional n-gram downloads:

7-gram beijinghouse v6: https://drive.google.com/file/d/1lvh3Ih_P9OShWzQVub7wsTk8f1YtLQg8/view?usp=sharing (420 MB download)
8-gram beijinghouse v6: https://drive.google.com/file/d/1v9xvmKQoARyerV2lIK3tphdeGiw_JmZ7/view?usp=sharing (5 GB download)

## 1.19 - Nov 11, 2020

https://drive.google.com/file/d/1_lP82NAvj5-vzd8O33e5aggWViHd-THJ/view?usp=sharing

What's new?

- Spacing between words for English text is now added to the solutions but can be disabled through Options, Solvers, Add spaces to output: No. You can also add spaces to text via the Input window and then Format, Add spaces to plaintext.
- Solvers Substitution + polyphones [auto] and [user] have been merged into Substitution + polyphones. Using the solver will open up a new menu that includes all the old functionality and more plus a new Hafer shifts solver mode!
- In previous versions results were not output until the thread was completely finished and that resulted in a possible wait time on very long runs. That's no longer the case.
- The solvers that use a additional hill-climber on top now update the Output window every second and the best result is now persistent between restarts.
- Re-enabled the 7-gram functionality. beijinghouse v6 7-grams download: https://drive.google.com/file/d/1lvh3Ih_P9OShWzQVub7wsTk8f1YtLQg8/view?usp=sharing (418 MB)
- Very noteworthy across-the-board improved solver efficiency.
- Size reduced beijinghouse v6 5 and 6-grams included.

Example output with the new word spacing (not perfect but pretty good):

```
Score: 24636.42 IOC: 0.0589 Multiplicity: 0.1882 Seconds: 0.12
Repeats: ANALYS CIPHER COULD MEAN TOBE LESS AND YST THE
PC-cycles: 490

ALTERNATIVELY AND FAR LESS GLORIOUSLY THE 
CIPHERS COULD BE THE BACKLASH OF A LUCKY 
LOW DOWN CRIMINAL WITH A TEXTBOOK ON HOW 
TO BEAT FREQUENCY ANALYSIS THE FIRST CIPHER 
WAS SOLVED BY A HUSBAND AND WIFE TEAM OF 
A MATEUR CRYSTANALYSTS OUT OF THEIR HOME 
AN ANNOYED KILLER COULD HAVE TAKEN THE RECIPE 
FOR CODE MAKING AND BE GUN CONVOLUTING IT 
UNTIL IT BECAME MEANING LESS ENOUGH TO BE 
UNBREAKABLE I FIND THE LATTER SOME
```

## 1.18 - Jul 12, 2020

https://drive.google.com/file/d/1v0nyazUTqFGKse8qAoi2FYeQASqRz152/view?usp=sharing

I made a huge effort to simplify the program in many ways and the overlapping n-gram systems have been removed. And thus, old n-grams may no longer work and 7-grams have been removed in favor of 8-grams. N-gram sizes 2 to 6 use the default system and n-gram size 8 uses beijinghouse's system.

- New beijinghouse and reddit n-grams.
- Binary n-gram file format which results in much smaller files and faster loading times.
- 8-grams will dynamically load into memory to the constraints of the system and will work even with as little as 1 GB of free RAM. Under "Options, Solvers" a setting can be found to force the 8-grams to a certain memory size.
- 8-gram caching, a setting under "Options, Solvers" will increase speed by up to 30% at the cost of more RAM and some warm-up time.
- In general almost all solvers have a 2x to 8x efficiency increase resulting in much faster solve times for all ciphers.
- The "simple transposition" solver has support for batch solving. (suggested by doranchak)
- Higher-order homophonic solver.
- Monoalphabetic groups solver (for Nick Pelling's challenge ciphers, idea and concept by beijnghouse: https://ciphermysteries.com/2020/01/07/nicks-challenge-cipher-1-cracked-by-louie-helm)
- Batch ciphers bigram repeats filter under "Options, Solvers"
- Load n-gram bias now supports files up to 10 MB.
- Performance mode removed.
- Bug fixes.

Download 6-grams_english_beijinghouse_v6: https://drive.google.com/file/d/1aXzSQoBcQ9MXD5fcH3jvq6UbqpU3GXaQ/view?usp=sharing (200 MB)
Download 8-grams_english_beijinghouse_v6: https://drive.google.com/file/d/1v9xvmKQoARyerV2lIK3tphdeGiw_JmZ7/view?usp=sharing (5 GB)
Download 8-grams_english_jarlve_reddit: https://drive.google.com/file/d/1V1N0dp8iMoT0f7fz62eAvYAaOJVvLq52/view?usp=sharing (1.2 GB)

## 1.17 - Dec 25, 2019

https://drive.google.com/open?id=1Sw0P9N9svMlx4QNtObZ56vEtDJHk6sZ8

What's new?

- Version 5 of beijinghouse's fantastic n-grams. His 8-grams as a separate 5 GB download: https://drive.google.com/open?id=1eDrhQMqL-jak1_Gvlij42sQUXkky1AY8
- New solver "Bigram substitution + crib grid" (which broke Klaus' 750 and 1000 world record challenges using beijinghouse's 8-grams).
- New solver "Substitution + row bound fragments" (idea by smokie treats).
- Improved convergence especially for hard ciphers, up to 5x faster solve.
- New Statistic "Observations" which automatically outputs some general observations (to be improved upon).
- Improved "Batch settings" functionality (suggested by beijinghouse).
- Start of a Linux harness (suggested by beijinghouse).
- Source now included with program.
- New Reddit n-grams version 1907.
- Fixes here and there.

Important note: I changed all normal n-grams (non-beijinghouse) to 1-byte log values. If you have any old n-grams from sizes 2 to 6 then you need to change the n-gram .ini file from "N-gram size=5" to "N-gram size=old5" to get it to work again.

## 1.16 - Oct 8, 2019

https://drive.google.com/open?id=1vB1G8IAeelsz6mZU6chQ7azthSv8seky

What's new?

- Version 4 of beijinghouse's 6-grams and 7-grams included which use a special low memory no-compromise n-gram system. For example, beijinghouse's 7-grams only take up 2 GB of ram and can thus be used on 4 or 8 GB system. His new version 4 n-grams are also much more dense and boast ridiculously good convergence rates. Version 4 of beijinghouse's 8-grams are available as a separate 4 GB download and require a 24 GB RAM system: https://drive.google.com/open?id=1vB1G8IAeelsz6mZU6chQ7azthSv8seky Thank you beijinghouse for all your work on this!

- Added timer to solver output so that the user knows how much time to program took to arrive at a certain solution.
- Added the option the add the PC-cycles stat the solver output "(General) Add PC-cycles to file output format".
- Fixed IOC inflation bug with Row bound solver that happened with certain ciphers.
- Fixed bug with Vigenère solver when using entropy weight other than 1.
- Fixed possible crash with Batch settings.
- Minor bug fixes and improvements all over the place.
- Compiled with the new FreeBASIC 1.07.1 release.

## 1.15 - May 25, 2019

https://drive.google.com/open?id=1YOBOXIz6ElHd5ej48E-FA7z7FYJsVuVg

Again a huge update and I will illustrate some examples of the new functionality during the next days.

- beijinghouse made a special 8-gram system that is only 50% slower than 7-grams and uses only 8 GB of memory! It works very well and he can elaborate on how exactly he achieved this. Get his 8-grams here: https://drive.google.com/open?id=1oIHa67MUJEABCF6RpRVo_JISz5nLU94c You will still need about 12 GB of ram to use these.
- beijinghouse also came up with a speed optimization that aborts the n-gram score calculation when it is known that the new_score cannot be higher than the old_score. This works very well with sparse n-grams such as 7-grams or higher. For now it is only used with beijinghouse's 8-grams.

- Added extensive cipher and plain text library, it can be found in the "Ciphers/" folder.
- Internally the score calculation is now using entropy instead of the index of coincidence. This may change the scores you are used to seeing a little bit. A small adjustment to the n-gram ini files has been made to reflect this. Old ini files still work via internal conversion.
- You may notice a slowdown of the solving speed (about 20%) due to a big improvement to most of the solvers such that for example 500,000 iterations are now worth about 1,000,000 iterations with a greater effect on ciphers that tend to get stuck.
- New function "Bias n-grams", bejinghouse asked for this, it can be found under "File, Load n-gram bias" and it tunes the n-grams in memory to some text of your choice. For example: to offer support for rare occurring n-grams such as names.
- "Batch ciphers (substitution)" now supports plain text accuracy testing, a example can be found in the "Ciphers/Batch/" folder.
- New solver "Substitution + units", it allows to solve a variety of cipher schemes such as masootz's cipher or operations on symbols, rows or columns such as remove, expand, separate into 2nd key, replace and reverse.
- New option "(Substitution + sequential homophones) Sequential weight: 5", setting it lower will decrease the weight of the sequential homophones and setting it higher will increase it.
- New function "Normalize n-gram factor", the button can be found under "Options, Solvers" and it will normalize the n-gram factor to some internal plain text. This ensures that AZdecrypt performs optimally with your n-grams.
- Fixed major 1.14 issues with the following solvers: columnar transpostion & rearrangement, nulls and skips, and poly [auto, user].
- Removed many code redundancies in the source (merged solvers etc) and it is about 33% smaller.
- New function "Batch settings" to optimize temperature etc, suggested by beijinghouse.
- Solvers are using much less memory outside of the regular n-gram memory use.
- Vigenère solver works much better now.

beijnghouse's new 7-grams: https://drive.google.com/open?id=1NFV-Ph6xJUsfwA8f3dGMzR35wlL47CFC

## 1.14 - Mar 24, 2019

What has changed?

First of all a big thank you to beijinghouse for his code contributions:

- beijinghouse recoded the loading routine and it is now loads n-grams up to 20 times as fast! It also supports loading n-gram files directly from .gz files.
- beijinghouse also made some speed optimizations to the variable types, random number generator and IOC calculations of the solver and this sped up the solvers by up to 10%.
- beijinghouse excellent all-around 6-grams are included with the download. I like to see these as a 6-gram version of the Practical cryptography 5-grams.
- Download link to beijinghouse's 7-grams: https://drive.google.com/open?id=1eEWCO0ABE72WV4YEbwQou-29c2ijw3_f

```
is there how to rearrange varies columns at the same time ??! I say, for example, use an argument as 3,2,4,7,8,10,17,1,5,6,9,11,12,13,14,15,16.
```

- @ Marclean: added, go to Functions, Transposition and look for Rearrange columns or rows. In the A1 "key#" field enter a key such as you described separated by commas or spaces.

```
The text in the input window is now transposed correctly. If you now click on "Solve", the cipher will still be solved. Apparently the previously loaded cipher is still stored somewhere. If you copy the transposed cipher and insert it again, "Solve" does not lead to any result anymore (as desired). Something is obviously not updated correctly.
```

- @ Largo: issued, this was actually part of some hidden functionality which is now disabled.
- Renamed the "Substitution + transposition" to "Substitution + simple transposition" and added an interface. All transposition operations that have a smaller set of possible arguments will be housed here. Added Spiral and L-route transpositions as well as Largo's Split transposition idea:

```
I've added this transposition to my solver for the next AZdecrypt release. It has solved your cipher and no results on the 340 so far. It can pick any set of dimensions and then make a horizontal or vertical split at any offset of which each part could have its own transposition (none, mirrored, flipped, columnars, diagonals).
```

- Improved "Substitution + row bound" solver.
- Improved the solve rate of mostly all solvers a bit.
- Added solver "Substitution + crib list" by request of beijinghouse. Go to the Misc folder and look to the readme.txt for an explanation. It basically allows you to batch cribs at the positions of your choosing.
- Included a new build of my Reddit n-grams. These are great when first-person language is expected such as the Zodiac communications.
- Fixed issue with status display. MIPS is now more accurate. Also added the average IOC.
- Compiled with the new 2019 FreeBASIC 1.06.0 release.
- Many bug fixes. New source can be found in: https://drive.google.com/open?id=0B5r0rDAOuzIQd0p1NmljRWJvYkU

Updated the readme.txt with added names of the people that have helped me over the years plus some links to other people's work. Let me know if I have forgotten you!

## 1.13 - Jan 1, 2019

What is new?

- Crib grid solver. This allows some very basic cribbing functionality.
- Pause button that works with all solvers.
- Refurbished menus and statistics.
- Bug fixes.

The statistics may use sigma's here and there, that is, the amount of standard deviations something is away from the mean. These will however likely not convert properly to the odds usually associated with them. They are there to give a quick indication only.

## 1.12 - Nov 03, 2018

What is new?

- Optimized "nulls and skips" solver with the help of smokie treats.
- Updated Reddit n-grams. This however increased the download to about 560 megabytes.
- Much faster Solver performance mode, which can be toggled on or off from the Options menu.
- Fixed an issue with the "row bound" solver so that it now correctly displays the "N-grams" and "PC-cycles" statistics scores.
- AZdecrypt determines the number of CPU threads available to your system and automatically assigns 3/4 of it to the solvers. The number of CPU threads can still be changed through the Options, Solvers menu.
- Support for up to 65536 CPU threads.
- Slightly overhauled look and feel.
- Fixed lots of small issues.

## 1.11 - Apr 7, 2018
   
What is new?

- Improvements to the substitution solver.
- Some of the Stats 1 and Stats 2 are improved.
- The program should no longer crash after exiting on some systems.
- New solver, Substitution + columnar rearrangement. Solves rearrangements of columns. The amount of columns and more can be set via Options, Solver, (Substitution + columnar transposition & rearrangement) ...
- New solver, Substitution + columnar transposition. Solves keyed columnar transposition. The amount of columns and more can be set via Options, Solver, (Substitution + columnar transposition & rearrangement) ...
- New solver, Substitution + period + nulls & skips. Solves unkeyed columnar transposition with nulls & skips. Similarly, its settings can be found via Options, Solvers, (Substitution + period + nulls & skips) ...
- Added a Misc directory with a file trithemius.txt, this can be used in conjunction with the Substitution + vigenère wordlist solver to crack trithemius ciphers.
- Added a Versions directory which houses versions that have been compiled to work faster on newer CPU architectures.
- Added a Benchmark which can be found via Options, Benchmark.
- Solver performance mode. Up to 40% faster solvers but only works with English ngrams. Enabled via Options, Toggle solver performance mode. If the toggle is successful this message should appear:

```
5-gram solver performance mode enabled, supported:
--------------------------------------------------------
- Substitution
- Substitution + columnar rearrangement
- Substitution + columnar transposition
- Substitution + period + nulls & skips
- Substitution + transposition
- Batch ciphers (substitution)
```

And the ngram file should have a [PM] next to it:

```
Task: none
[PM] 5-grams_english_practicalcryptography_wortschatz.txt
--------------------------------------------------------
Can be auto-enabled via Options, Solver, set (General) Use performance mode ngrams if applicable to 1.
```

## 1.09 - Dec 5, 2017
   
What is new?

- Slightly improved substitution solver.
- Batch ciphers (substitution) is faster when processing ciphers with a reasonably low number of iterations and restarts.
- The vigenère solver can be set to solve by rows under the options, solver menu by changing by columns to 0.
- Fixed a bug where the 7-gram substitution solver was erroneously linked to a polyalphabetic solver.
- Fixed a bug with the 6-gram vigenère solver.
- Added some stats and various other bugfixes.

## 1.08 - Sep 7, 2017
   
What is new?

- New solver: Substitution + polyphones [auto]. It can solve wildcard ciphers automatically and more. The number of extra letters to use can be changed via the options menu. I recommend that you use 6-grams and a multiplicity weight of 1 or lower/higher. This multiplicity weight ensures that the solver uses as few extra letters as possible.
- Renamed the Substitution + user defined polyphones solver to Substitution + polyphones [user].
- Improved solver: Substitution + transposition and added some options to alter.
- New solver: Merge seq. homophones with options to alter. Works very well on sequential homophonic substitution ciphers without much encoding randomization.
- Added option: (General) output to batch. Will output all solutions of a solver in a file instead of many when set to 1.
- Added option: (General) output additional stats. Ngram score of solution and plaintext to ciphertext cycles score.
- Slightly improved n-gram loading times.
- Improved options menus.
- Bugfixes.

## 1.07 - Aug 5, 2017
   
What is new?

- Substitution + null symbols solver. It decrypts ciphers were a bunch of symbols are to be removed, assuming that every instance of that symbol needs to be removed.
- The Stats menu has been split into Stats and More stats.
- Encoding randomization tests have been added to More stats, it attempts to find sections of randomization in sequential homophonic substitution ciphers.
- Stats options has been added to the options menu. It allows to change some settings that pertain to the encoding randomization and plaintext/encoding direction tests.
- 2 and 3-symbol cycles output with details has been added to More stats.
- Renamed the Substitution + by rows solver to Substitution + row bound.
- Various other updates and bug fixes.

## 1.06 - Jul 20, 2017
   
What is new?

- Substitution + light polyalphabetism solver. It aims to decrypt homophonic substitution + up to about 20% polyalphabetism/randomization considering 408/340 multiplicity. Using 6-grams is recommended and take in mind that this solver converges very slowly on the solution. You could let it run overnight.

There is a new setting (match weight) under the solver options menu, this will let you control how much polyalphabetism it targets. Which is indicated with the solutions the solver returns. For example, the solver might return a solution that includes "Match 0.80123". This means that 80.123% of the plaintext correctly matches the ciphertext and that the other 19.877% is freely assigned by the solver. Increasing the match weight (under the solver options menu) will force the solver to higher match ratios while decreasing it allows for more polyalphabetism.

- Renamed Substitution + polyphones solver to Substitution + user defined polyphones.
- Various other updates and bug fixes.

## 1.05 - Jun 15, 2017
   
What is new?

- Substitution + by rows solver. Concept by smokie treats; It does not cross row boundaries and uses a combination of ngram sizes to compensate for the loss of information.
- Support for CTRL-A in the input and output windows.
- Some new stats and bugfixes.
   
## 1.04 - Apr 29, 2017
   
What is new?

- Substitution + vigenère solver. Set a keyword length size in the solver menu under options.
- Substitution + vigenère wordlist solver. Will simply go through all words in a list and could double as a one time pad solver. Words in the list must use the same alphabet as defined in the ngram .ini file (case sensitive).
- Vigenère encoder. Under functions -> manipulation.
- Digraph subtitution encoder. Under functions -> manipulation.
- Added a few extra stats here and there such as odd/even bigrams. (thanks smokie)
- Added undo button to create transposition matrix.
- Easier to navigate menus with spacers.
- Bugfixes and many little things. (thanks again Largo)

The substitution + vigenère solver can solve 63 symbol 340 character homophonic substitution + vigenère ciphers with keywords up to a length of 10 (and probably much longer) without any problems but it may take a while. With homophonic substitution it is assumed that the vigenère is actual at the plaintext level. The solver is _very much_ susceptible to nulls.
   
## [??? - Apr 17, 2017](https://zodiackiller.net/community/postid/52032/)

What is new?

- Support for 4, 7 and 8-grams added
- Substitution + polyphones solver
- Create transposition matrix
- Bugfixes and stuff

The amount of polyphones/letters per symbol for the new substitution + polyphones solver have to be set through the symbols menu (under functions).

The new create transposition matrix (under functions) requires you to open a cipher with the dimensions you want to create a matrix in first. Then left mouse click on the button-grid to set a number one by one, it increments automatically. A right mouse click draws (when possible) a horizontal, vertical or diagonal line between the last number and your new position. 
   
## 1.0c - Mar 7, 2017
   
- Bug fixes.
- Faster solver.
- Wider window.
- Added new stats and format options.
- Added demo version of a transposition solver, let it run for a very long time.
   
## 1.0b - Jan 27, 2017
   
- Bug fixes.
- Added symbols menu.
- Added and improved stats.
- Added transposition schemes.
- Changed and moved some stuff, if you can't find something please ask.
- Added "Batch ngrams" under File. Open "languages.txt" under "/Ngrams/Languages/" for example functionality.

If there are any issues please let me know and I will fix them asap. Marclean, your transposition idea can be found under Functions -> Transposition -> Offset rectangular chain.
