# AZDecrypt 

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
Can solve a whole variety of transposition ciphers keyed or unkeyed as long as the transposition can be summarized by a limited set of periodic rules
Select "Periodic transposition [auto]" or "Periodic transposition inverted [auto]" if you want the solver to try to automatically determine the transposition.
Note that the transposition solver will write additional output to the Output folder (for example, the transposition matrices it finds)
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

