
## READ IN INPUT ---------------------------------------------------------------

tic <- Sys.time()

day5 <- readLines("inputs/day05.txt")

# Instructions from line 11 onwards
instructions <- day5[11:length(day5)]

instructions <- strsplit(instructions, split = "(move|from|to)")

# elements in each vector: move, from, to
instructions <- 
  lapply(instructions, function(x) {
    as.numeric(trimws(x[x != ""]))
  })

# No point in reading in the crates automatically

# Each stack from bottom to top
crate_stacks <- 
  list(
    c("Q", "M", "G", "C", "L"),
    c("R", "D", "L", "C", "T", "F", "H", "G"),
    c("V", "J", "F", "N", "M", "T", "W", "R"),
    c("J", "F", "D", "V", "Q", "P"),
    c("N", "F", "M", "S", "L", "B", "T"),
    c("R", "N", "V", "H", "C", "D", "P"),
    c("H", "C", "T"),
    c("G", "S", "J", "V", "Z", "N", "H", "P"),
    c("Z", "F", "H", "G")
  )

## PART 1 ----------------------------------------------------------------------

move_crates <- function(stacks, n, from, to) {
  # get top (= last) n crates
  temp_crates <- 
    stacks[[from]][(length(stacks[[from]]) - n + 1):length(stacks[[from]])]
  
  # Delete crates from old stack
  stacks[[from]] <- stacks[[from]][1:(length(stacks[[from]]) - n)]
  
  # Move them to stack in reversed order
  stacks[[to]] <- c(
    stacks[[to]],
    temp_crates[length(temp_crates):1]
  )
  
  return(stacks)
}

# Keep original crate stacks untouched
o_crate_stacks <- crate_stacks

for (i in seq_along(instructions)) {
  crate_stacks <- 
    move_crates(
      crate_stacks, 
      instructions[[i]][1], 
      instructions[[i]][2], 
      instructions[[i]][3]
    )
}

# Get top item from each stack
paste0(
  unlist(
    lapply(crate_stacks, function(x) x[length(x)])
  ), collapse = ""
)

# VCTFTJQCG

pt1 <- Sys.time() - tic

## PART 2 ----------------------------------------------------------------------

# Same, but crates stay in the same order when moved

move_crates2 <- function(stacks, n, from, to) {
  # get top (= last) n crates
  temp_crates <- 
    stacks[[from]][(length(stacks[[from]]) - n + 1):length(stacks[[from]])]
  
  # Delete crates from old stack
  stacks[[from]] <- stacks[[from]][1:(length(stacks[[from]]) - n)]
  
  # Move them to stack in the same order
  stacks[[to]] <- c(
    stacks[[to]],
    temp_crates
  )
  
  return(stacks)
}

# Recover original crate stacks
crate_stacks <- o_crate_stacks

for (i in seq_along(instructions)) {
  crate_stacks <- 
    move_crates2(
      crate_stacks, 
      instructions[[i]][1], 
      instructions[[i]][2], 
      instructions[[i]][3]
    )
}

# Get top item from each stack
paste0(
  unlist(
    lapply(crate_stacks, function(x) x[length(x)])
  ), collapse = ""
)

# GCFGLDNJZ
pt2 <- Sys.time() - tic
