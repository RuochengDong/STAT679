# homework 1: shell tools and regular expressions

## background (may be skipped)

SNaQ is a method to estimate the phylogenetic (~ genealogical) networks.
Given input data, SNaQ seeks the network that minimizes a **score**
(negative log pseudo-likelihood).
This score has a rough surface, often with local minima,
and the space of networks is a complex space to explore.
Therefore, each SNaQ analysis does **multiple runs**,
then returns the best network across all the runs.

Several SNaQ analyses were performed, always on the same input data,
with varying values of tuning parameters. These parameters control
how the search is done and when it is stopped. The goal of this study
was to find a combination of tuning parameters that makes the analyses
faster but almost as accurate, compared to the default parameters.

In this assignment, you will perform data cleaning tasks.
In exercise 1, you will clean data file names. In exercise 2 and 3,
you will extract relevant information from paired `out` and `log` files,
and organize this information in a new clean table.

## data files

For each analysis, 2 files were created:
`xxx.out` in the directory `out` (main output file)
and `xxx.log` in the directory `log` (to record the parameter values and
details on the individual runs of a single analysis).
Here, `xxx` is an arbitrary name chosen by the analyst.

## exercise 1

Create a shell script `normalizeFileNames.sh` to change all file names
`timetesty_snaq.log` to `timetest0y_snaq.log`,
where "y" is a digit between 1 and 9.
For example, your script should change the name of file
`log/timetest3_snaq.log` to `log/timetest03_snaq.log`.
But it should preserve the name of file `log/timetest13_snaq.log`.
(The desired outcome is to have `timetest03_snaq.log` appear
before `timetest13_snaq.log` when sorted alphabetically, for example.)

Similarly, your script should change
`timetesty_snaq.out` to `timetest0y_snaq.out`.

When you are done, follow these
[instructions](https://github.com/UWMadison-computingtools-master/general-info#submit-your-assignment)
to submit your assignment.

## exercise 2

### tag the current version of your project

After you are 100% sure to be done with exercise 1,
and before doing *any* work for exercise 2,
**tag** your git repository with tag `v1.1`
(to mean homework 1, exercise 1). To do so, make sure that your
current directory is somewhere inside this homework folder, then do

```shell
git tag v1.1
```

Also push your tag to your github repository:

```shell
git push origin v1.1   # or
git push origin --tags
```

(You can go to your github repository online and check that your tag
appears there: click on the box saying "Branch:master" then "Tags".)

### task

Create a shell script `summarizeSNaQres.sh` to start a summary of the results
from all these analyses. The script should produce a table in `csv` format,
with 1 row per analysis and 3 columns:

- "analysis": the file name root ("xxx")
- "h": the maximum number of hybridizations allowed during the analysis: `hmax`
- "CPUtime": total CPU time, or "Elapsed time".

### requirements and details

learning goals: get practice with basic shell commands,
`for` loops, and regular expressions.

For this exercise, use *only* the commands we have seen so far:
like `head`, `echo`, pipes, redirection, regular expressions,
and `grep` to search for things.  
Do **not** used tools like `sed`, `basename` and/or `dirname`:
exercise 3 below will provide practice with these other tools.  
Do **not** use R or Python: the goal here is to learn shell scripting.

Hint: start by finding one or a set of commands to work with a single
analysis, like the analysis whose results are in `log/bT1.log`
and `out/bT1.out`:

- find a command to extract the "root" name of this analysis (`bt1` here),
  and to capture it in a variable.
- find a single command to extract one piece only (like h), again just
  for this `bt1` analysis.
- find another command to extract the CPU time for that analysis.

Once you have commands that work on a single analysis
(to extract info from a single pair of files: log and out), then wrap these up
into loop, in a script, to apply this to all analyses/files.

requirements about output:

- have the 3 columns in the exact order and with the exact column names
  as specified above (a script will be used to check that the output is
  as expected)
- use csv format correctly: commas `,` to separate values (columns),
  no spaces around commas,
  no comma at the end after the last value on each row,
  no comments. For example, the first line should contain this exactly:
  `analysis,h,CPUtime`

When you are done,
[submit](https://github.com/UWMadison-computingtools-master/general-info#submit-your-assignment)
your assignments like for exercise 1.

## exercise 3

### tag the current version of your project

After you are 100% sure to be done with exercise 2,
create a tag to get back to your exercise 2 script easily in the future:

```shell
git tag v1.2
```

The version name 1.2 is to remember that it's the version for
homework 1, exercise 2.
Again, push your tag to your github repository:

```shell
git push origin v1.2   # or
git push origin --tags
```

### task

Modify your script `summarizeSNaQres.sh` that summarizes the results,
to add more information. You may comment out parts of your script that
you no longer need (use `#` for comments), or you can delete these parts
altogether, because you can always go back to them using git anyway
(check your tag on github for instance).

The script should still produce a table in `csv` format
with 1 row per analysis,
the same columns as before and additional columns:

- analysis: file name root ("xxx"), like in exercise 2
- h: the maximum number of hybridizations allowed during the analysis: `hmax`
- CPUtime: total CPU time, or "Elapsed time"
- Nruns: number of runs
- Nfail: tuning parameter, "max number of failed proposals"
- fabs: tuning parameter called "ftolAbs" in the log file (tolerated
  difference in the absolute value of the score function, to stop the search)
- frel: "ftolRel"
- xabs: "xtolAbs"
- xrel: "xtolRel"
- seed: main seed, i.e. seed for the first runs
- under3450: number of runs that returned a network with a score
  (`-loglik` value) better than (below) 3450

### requirements and details

The learning **goal** of this exercise is to get practice writing
a shell script, using shell loops and test statements (for, if/then),
using regular expression and text search & replace tools.

requirements about coding:

- this time, **use `sed`** at least once,
  and any other shell command seen earlier
- also **use `basename`** and/or `dirname`
- use **at least one `if`** statement
- have at least one `for` loop (like for exercise 2)
- again, do *not* use R or Python; the goal here is to learn shell scripting
- do *not* use the basic calculator `bc` either:
  a major goal of the exercise is to use regular expressions.

Hint: all -loglik values are over 3430, as the output of this command shows:
`grep -oh "loglik [0-9]*\." out/*.out | sort `.
You can modify this command to capture only the values under 3450
(because they should start with 343 or 344), and from a single analysis only.
Then pipe your modified command to some other command to count how many times
such values (under 3450) were found, in a given analysis file.

requirements about output:

- have the columns in the exact order and with the exact column names
  as specified above (a script will be used to check that the output is
  as expected)
- correct csv format: commas `,` to separate values (columns),
  no spaces around commas,
  no comma at the end after the last value on each row,
  no comments

requirements about documentation:

Make sure to put a comment near each command that uses a regular expression
(like `sed`), to explain what your command is meant to do.
This is to make your code human-readable.
Regular expressions are notoriously hard to read.

Also modify the [readme.md](readme.md) file to indicate what
scripts were run, when, from which directory,
and where the output was created.
