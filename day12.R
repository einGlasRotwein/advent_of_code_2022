
## PART 1 ----------------------------------------------------------------------

source("day12_functions.R")

# day12 <- readLines("inputs/day12_ex.txt")
day12 <- readLines("inputs/day12.txt")

tic <- Sys.time()

day12 <- strsplit(day12, "")
# Mark S as 1, and E as 27
day12 <- lapply(day12, function(x) match(x, c("S", letters, "E")))

day12 <- do.call(rbind, day12)

# Start with S location
current_paths <- list(which(day12 == 1))

# Stop if the top is found
while (!any(sapply(current_paths, function(x) 28 %in% day12[x]))) {
  current_paths <- dijkstra(current_paths, day12)
}

# Get shortest path (they should all have the same length at this point, but 
# you never know ...)
min(
  sapply(
    current_paths[sapply(current_paths, function(x) 28 %in% day12[x])],
    length
  )
) - 1 # minus 1, because it's 1 step less than nodes

# 408

Sys.time() - tic

## PART 2 ----------------------------------------------------------------------

# Clean up from previous run
rm(list = ls())
gc()

source("day12_functions.R")

# day12 <- readLines("inputs/day12_ex.txt")
day12 <- readLines("inputs/day12.txt")

tic <- Sys.time()

day12 <- strsplit(day12, "")
# Mark S as 1, and E as 27
day12 <- lapply(day12, function(x) match(x, c("S", letters, "E")))

day12 <- do.call(rbind, day12)

# Start at all locations that are 2 (== a)
current_paths <- lapply(which(day12 == 2), function(x) x)

# Stop if the top is found
while (!any(sapply(current_paths, function(x) 28 %in% day12[x]))) {
  current_paths <- dijkstra(current_paths, day12)
}

# Get shortest path (they should all have the same length at this point, but 
# you never know ...)
min(
  sapply(
    current_paths[sapply(current_paths, function(x) 28 %in% day12[x])],
    length
  )
) - 1 # minus 1, because it's 1 step less than nodes

# 399
Sys.time() - tic
