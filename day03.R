
## PART 1 ----------------------------------------------------------------------

day3 <- readLines("inputs/day03.txt")

tic <- Sys.time()

# split in individual characters
day3 <-  strsplit(day3, split = "")

# Split each list into two compartments and compare these
target_items <- 
  sapply(day3, function(x) {
    intersect(
      x[1:(length(x)/2)],
      x[(length(x)/2 + 1):length(x)]
    )
  })

# Score items
# Lowercase item types a through z have priorities 1 through 26.
# Uppercase item types A through Z have priorities 27 through 52.
score <- c(letters, LETTERS)

sum(match(target_items, score))
# 7990

Sys.time() - tic

## PART 2 ----------------------------------------------------------------------

rm(list = ls())

day3 <- readLines("inputs/day03.txt")

tic <- Sys.time()

# split in individual characters
day3 <-  strsplit(day3, split = "")

# Split list into groups of 3 elfs
day3 <- split(day3, rep(1:100, each = 3))

# Intersection of the three sub-lists (elfs) per list (elf group)
target_items <- sapply(day3, function(x) Reduce(intersect, x))

# Score items
score <- c(letters, LETTERS)

sum(match(target_items, score))
# 2602

Sys.time() - tic
