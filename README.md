README
================

# Advent of Code 2022

This repo contains my solutions for the [Advent of
Code](https://adventofcode.com/) 2022 in `R`. This is my 3rd AoC; in
2020, I got 31 stars; in 2021, I got 33 stars. Let’s see whether I can
manage at least 35 this year :-)

Follow me on [Mastodon](https://fosstodon.org/@juli_nagel), where I will
post about my solutions as well!

## TOC

The scripts for my solutions are named after the respective day
(e.g. `day01.R`). The corresponding inputs (`day01.txt`) can be found in
the folder `inputs`. Here is a table of contents showing you what each
day was about, along with some stats. Completion time refers to the time
it took me to complete the puzzle since release (part 1, and part 2 in
brackets), as tracked on the Advent of Code website[^1]. Next is my rank
for the puzzle on that day (part 1 (part 2)), and finally the runtime of
my code. It’s a crude measure of runtime, where I simply store
`Sys.time()` at the beginning of my script, and then compute the
difference to the current `Sys.time()` after the solution of part 1 and
2. I run both parts back to back, i.e. the entire code of part 1 will
run before part 2 is run, so the runtime of part 2 will always be
longer. (In most cases, at least part of the code for part 1 will be
used for part 2 as well.)

| Day | Title            | Completion Time     | Rank        | Runtime         |
|-----|------------------|---------------------|-------------|-----------------|
| 1   | Calorie Counting | 00:05:11 (00:07:02) | 2767 (2329) | 8.51 (10.14) ms |

[^1]: For the first puzzle, I got up when it was released (6 am where I
    live, so manageable) to maybe have a shot at the leaderboard. Only
    the first 100 people to solve the puzzle get points. Let’s just say
    that 5 min completion time is too slow for that :-D
