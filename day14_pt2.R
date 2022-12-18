
## PART 2 ----------------------------------------------------------------------

# day14 <- readLines("inputs/day14_ex.txt")
day14 <- readLines("inputs/day14.txt")

tic <- Sys.time()

# Draw rock lines
day14 <- strsplit(day14, " -> ")
day14 <- lapply(day14, function(x) lapply(strsplit(x, ","), as.numeric))

# Get min/max X and Y to draw cave
min_x <- min(rapply(day14, function(x) min(x[1])))
max_x <- max(rapply(day14, function(x) max(x[1])))
min_y <- 0 # Sand falls from 500, 0
max_y <- max(rapply(day14, function(x) max(x[2])))

# Set top left corner of matrix to 1
ncols <- length(min_x:max_x - min_x + 1)
nrows <- length(min_y:max_y - min_y + 1)

# Two more rows
cave <- matrix(nrow = nrows + 2, ncol = ncols)

# Draw rocks
for (rock_path in seq_along(day14)) {
  for (rock_line in 1:(length(day14[[rock_path]]) - 1)) {
    start <- day14[[rock_path]][[rock_line]]
    end <- day14[[rock_path]][[rock_line + 1]]
    
    # Adjust coordinates so top left corner is 1,1
    temp_x <- start[1]:end[1] - min_x + 1
    temp_y <- start[2]:end[2] - min_y + 1
    
    # Rock is 9
    cave[cbind(temp_y, temp_x)] <- 9
  }
  day14[[rock_path]]
}

# bottom line is rocks
cave[nrow(cave), ] <- 9

initial_sand_x <- 500 - min_x + 1
initial_sand_y <- 1

# Let sand fall
top_not_reached <- TRUE
sand_falling <- TRUE
sand_resting <- 0

# while(sand_resting < 120) {
while(top_not_reached) {
  sand_x <- initial_sand_x
  sand_y <- initial_sand_y
  sand_falling <- TRUE
  
  while (sand_falling) {
    
    # If the sand can't move left, we need to add another column/row
    if (sand_x - 1 == 0) {
      cave <- cbind(c(rep(NA, nrow(cave) - 1), 9), cave)
      initial_sand_x <- initial_sand_x + 1
      sand_x <- sand_x + 1
    }
    
    # If the sand can't move right, we need to add another column/row
    if (sand_x + 1 == (ncol(cave) + 1)) {
      cave <- cbind(cave, c(rep(NA, nrow(cave) - 1), 9))
    }
    
    down_ok <- is.na(cave[cbind(sand_y + 1, sand_x)])
    down_left_ok <- is.na(cave[cbind(sand_y + 1, sand_x - 1)])
    down_right_ok <- is.na(cave[cbind(sand_y + 1, sand_x + 1)])
    
    # Try to move down
    if (down_ok) {
      sand_y <- sand_y + 1
      # Try to move bottom left
    } else if (down_left_ok) {
      sand_y <- sand_y + 1
      sand_x <- sand_x - 1
      # Try to move bottom right
    } else if (down_right_ok) {
      sand_y <- sand_y + 1
      sand_x <- sand_x + 1
      # Otherwise, the sand stays where it is (sand = 0)
    } else {
      if (sand_y == 1) {
        print("top reached")
        top_not_reached <- FALSE
      }
      cave[cbind(sand_y, sand_x)] <- 0
      sand_resting <- sand_resting + 1
      sand_falling <- FALSE
    }
  }
}

sand_resting
# 27194

Sys.time() - tic

