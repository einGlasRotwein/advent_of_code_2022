
## READ IN INPUT ---------------------------------------------------------------

day5 <- readLines("inputs/day05.txt")

tic <- Sys.time()

# Instructions from line 11 onwards
instructions <- day5[11:length(day5)]

instructions <- strsplit(instructions, split = "(move|from|to)")

# elements in each vector: move, from, to
instructions <- 
  lapply(instructions, function(x) {
    as.numeric(trimws(x[x != ""]))
  })

# Note that in my previous solution, I hardcoded the crates, because they 
# were a massive pain to read in. I was young and really needed these gold 
# stars within a reasonable time. But since my boss accused me of being a 
# cheater, here's some ugly code that reads in the crate stack from the 
# input file. I hope you see this, Gordon.

# Crates are in line 1 to 8 (ignoring line 9 which numbers the crates)
effing_crates <- day5[1:8]

# Split characters, because R doesn't index strings
effing_crates <- strsplit(effing_crates, "")

# Put in a data frame, because the crates are stacked in columns
effing_crates <- as.data.frame(do.call(rbind, effing_crates))

# Keep columns that contain letters
letter_cols <- apply(effing_crates, 2, function(x) any(x %in% LETTERS))
effing_crates <- effing_crates[letter_cols]

# Store columns in a list. While we're at it, remove the spaces, and 
# also reverse the column, so each vector in the list begins with 
# the bottom crate (makes it easier to append things later).
crate_stacks <- 
  lapply(
    seq_along(effing_crates), 
    function(i) {
      rev(effing_crates[,i][effing_crates[,i] != " "])
    }
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

Sys.time() - tic

## PART 2 ----------------------------------------------------------------------

tic <- Sys.time()

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

Sys.time() - tic
