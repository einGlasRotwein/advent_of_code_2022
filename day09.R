
instructions <- read.table("inputs/day09.txt")
# instructions <- read.table("inputs/day09_ex.txt")

names(instructions) <- c("direction", "moves")

source("day09_functions.R")

## PART 1 ----------------------------------------------------------------------

tic <- Sys.time()

# Track all individual positions of T, because we will need it to determine the 
# unique positions of T later.
# Also save H so we can build a cool plot.
positions <- 
  data.frame(
    xH = c(0, rep(NA, sum(instructions$moves))),
    yH = c(0, rep(NA, sum(instructions$moves))),
    xT = c(0, rep(NA, sum(instructions$moves))),
    yT = c(0, rep(NA, sum(instructions$moves)))
  )

# Because we're tracking every step anyways, we'll just turn the instructions 
# into a series of steps of size 1
instructions <- rep(instructions$direction, times = instructions$moves)

# Initial tail positions
newT <- c(0, 0)
newH <- c(0, 0)

for (i in 1:length(instructions)) {
  # move head first
  newH <- move(instructions[i], c(positions$xH[i], positions$yH[i]))
  
  # drag tail along
  newT <- drag(newH, newT)
  
  positions$xT[i + 1] <- newT[1]
  positions$yT[i + 1] <- newT[2]
  positions$xH[i + 1] <- newH[1]
  positions$yH[i + 1] <- newH[2]
}

# Get all unique positions of T
nrow(unique(positions[c("xT", "yT")]))
# 6011

Sys.time() - tic

## PART 2 ----------------------------------------------------------------------

tic <- Sys.time()

positions <- 
  data.frame(
    xK1 = c(0, rep(NA, length(instructions))),
    yK1 = c(0, rep(NA, length(instructions)))
  )

n_knots <- 10

for (i in 2:n_knots) {
  positions[[paste0("xK", i)]] <- c(0, rep(NA, length(instructions)))
  positions[[paste0("yK", i)]] <- c(0, rep(NA, length(instructions)))
}

for (i in 1:length(instructions)) {
  # move head first
  positions[i + 1, 1:2] <- move(instructions[i], c(positions$xK1[i], positions$yK1[i]))
  
  # drag the other knots - each is dragged to the previous knot
  for (j in 2:n_knots) {
    positions[i + 1, (j * 2 - 1):(j * 2)] <- 
      drag(
        positions[i + 1, ((j - 1) * 2 - 1):((j - 1) * 2)], 
        positions[i, (j * 2 - 1):(j * 2)]
      )
  }
}

# Get all unique positions of the tail
nrow(unique(positions[c("xK10", "yK10")]))
# 2419

Sys.time() - tic

# save(positions, file = "day09.RData")
