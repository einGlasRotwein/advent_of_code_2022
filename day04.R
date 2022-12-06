
## PART 1 ----------------------------------------------------------------------

day4 <- readLines("inputs/day04.txt")

tic <- Sys.time()

day4 <- strsplit(day4, split = "[,-]")

overlapping <- 
  sapply(day4, function(x) {
    elf1 <- as.numeric(x[1]):as.numeric(x[2])
    elf2 <- as.numeric(x[3]):as.numeric(x[4])
    
    all(elf1 %in% elf2) | all(elf2 %in% elf1)
  })

sum(overlapping)
# 459

Sys.time() - tic

## PART 2 ----------------------------------------------------------------------

tic <- Sys.time()

overlapping <- 
  sapply(day4, function(x) {
    elf1 <- as.numeric(x[1]):as.numeric(x[2])
    elf2 <- as.numeric(x[3]):as.numeric(x[4])
    
    any(elf1 %in% elf2)
  })

sum(overlapping)
# 779

Sys.time() - tic
