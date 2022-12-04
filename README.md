README
================

    ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──

    ✔ ggplot2 3.3.6      ✔ purrr   0.3.4 
    ✔ tibble  3.1.8      ✔ dplyr   1.0.10
    ✔ tidyr   1.2.0      ✔ stringr 1.4.0 
    ✔ readr   2.1.2      ✔ forcats 0.5.1 

    ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()

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
my code. It’s a crude measure of runtime[^2], where I simply calculate
the difference in `Sys.time()` at the beginning and the end of part 1,
and the beginning and end of part 2 . That means in some occasions, the
runtime for part 2 will be much shorter because part of the code needed
to solve part 2 was already run in part 1 .

| Day | Title                   | Completion Time     | Rank        | Runtime          |
|-----|-------------------------|---------------------|-------------|------------------|
| 1   | Calorie Counting        | 00:05:11 (00:07:02) | 2767 (2329) | 9.34 (0.88) ms   |
| 2   | Rock Paper Scissors     | 00:17:34 (00:24:30) | 7120 (6282) | 13.54 (12.02) ms |
| 3   | Rucksack Reorganization | 00:17:28 (00:29:45) | 6247 (6570) | 13.67 (9.34) ms  |
| 4   | Camp Cleanup            | 00:06:35 (00:07:24) | 2348 (1292) | 19.91 (13.86) ms |

[^1]: For the first puzzle, I got up when it was released (6 am where I
    live, so manageable) to maybe have a shot at the leaderboard. Only
    the first 100 people to solve the puzzle get points. Let’s just say
    that 5 min completion time is too slow for that :-D

[^2]: I know these stats are basically meaningless for anyone else’s
    computer, but to put things into perspective, here are my computer
    stats: Razer Blade 15 Base Model, Intel Core i7-10750H CPU @
    2.60GHz, 259 Mhz, 6 Cores, 12 Logical Processors, 16 GB RAM
