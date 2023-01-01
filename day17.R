
## PART 1 ----------------------------------------------------------------------

options(scipen = 999)

# To manage the size of the matrix, we remove the parts where no rock can 
# possibly fall anymore. The most conservative criterion is: When a row is 
# entirely filled with rocks, it becomes the new bottom.

# Alternatively, we can cut the cave below a row that has gaps that are no 
# wider than 1 unit and no more than 4 units deep (so even the upright shape 
# would not fit through).

# jets <- readLines("inputs/day17_ex.txt")
jets <- readLines("inputs/day17.txt")

tic <- Sys.time()

jets <- unlist(strsplit(jets, ""))

# is rock, 0 is empty space.
# 3 lines of empty space
cave <- t(matrix(rep(0, 7 * 3), nrow = 7))

shapes_add_rows <- vector("numeric", length = 5)
coordinates <- list()

## FALLING ROCK SHAPES ---------------------------------------------------------

# 1)
#   ####

shapes_add_rows[1] <- 1 # add 1 row to the matrix
# Then, the coordinates are ...
coordinates[[1]] <- 
  data.frame(
    x = 1,
    y = 3:6
  )

# 2)
#   .#.
#   ###
#   .#.

shapes_add_rows[2] <- 3
coordinates[[2]] <- 
  data.frame(
    x = c(1, rep(2, 3), 3),
    y = c(4, 3:5, 4)
  )

# 3)
#   ..#
#   ..#
#   ###

shapes_add_rows[3] <- 3
coordinates[[3]] <- 
  data.frame(
    x = c(1, 2, rep(3, 3)),
    y = c(5, 5, 3:5)
  )

# 4)
#   #
#   #
#   #
#   #

shapes_add_rows[4] <- 4
coordinates[[4]] <- 
  data.frame(
    x = 1:4,
    y = 3
  )

# 5)
#   ##
#   ##

shapes_add_rows[5] <- 2
coordinates[[5]] <- 
  data.frame(
    x = c(1, 1, 2, 2),
    y = c(3, 4, 3, 4)
  )

## LET ROCKS FALL --------------------------------------------------------------

# n_rocks <- 1000000000000
n_rocks <- 2022
jet_no <- 1
stack_height <- 0

pb <- txtProgressBar(min = 0, max = n_rocks, initial = 0, style = 3)

for (i_rock in 1:n_rocks) {
  setTxtProgressBar(pb, i_rock)
  
  # Check whether there are three empty rows above the highest point
  cave_stats <- rle(apply(cave, 1, sum))
  
  if (cave_stats$values[1] != 0) {
    # make three empty rows appear on top
    cave <- rbind(matrix(rep(0, ncol(cave) * 3), nrow = 3), cave)
  } else if (cave_stats$lengths[1] != 3) {
    # add required number or subtract it
    row_diff <- 3 - cave_stats$lengths[1]
    
    if (row_diff < 0) {
      cave <- cave[-(1:abs(row_diff)), ]
    } else {
      cave <- rbind(matrix(rep(0, ncol(cave) * row_diff), nrow = row_diff), cave)
    }
  }
  
  # Rock appears
  rock_no <- ifelse(i_rock %% length(coordinates) == 0, length(coordinates), i_rock %% length(coordinates))
  temp_coordinates <- coordinates[[rock_no]]
  rock_falling <- TRUE
  
  # Add rows to accommodate the new rock
  cave <- 
    rbind(
      matrix(rep(0, ncol(cave) * shapes_add_rows[rock_no]), nrow = shapes_add_rows[rock_no]), 
      cave
    )
  
  # Jets and downward movement until rock stops
  while (rock_falling) {
    # Jet
    temp_jet <- jets[jet_no]
    new_coordinates <- temp_coordinates
    
    if (temp_jet == ">") { # try moving right
      new_coordinates$y <- new_coordinates$y + 1
    } else if (temp_jet == "<") { # try moving left
      new_coordinates$y <- new_coordinates$y - 1
    }
    
    coordinates_valid <- all(new_coordinates$y %in% 1:(ncol(cave)))
    if (coordinates_valid) {
      hit_no_rock <- sum(cave[cbind(new_coordinates$x, new_coordinates$y)]) == 0 
    } else {
      hit_no_rock <- FALSE
    }
    
    if (coordinates_valid & hit_no_rock) temp_coordinates <- new_coordinates
    jet_no <- ifelse((jet_no + 1) %% length(jets) == 0, length(jets), (jet_no + 1) %% length(jets))
    
    # move down
    new_coordinates <- temp_coordinates
    new_coordinates$x <- new_coordinates$x + 1
    
    coordinates_valid <- all(new_coordinates$x %in% 1:(nrow(cave)))
    if (coordinates_valid) {
      hit_no_rock <- sum(cave[cbind(new_coordinates$x, new_coordinates$y)]) == 0 
    } else {
      hit_no_rock <- FALSE
    }
    
    if (coordinates_valid & hit_no_rock) {
      temp_coordinates <- new_coordinates
    } else {
      cave[cbind(temp_coordinates$x, temp_coordinates$y)] <- 3
      rock_falling <- FALSE
    }
  }
  
  # Rows that have gaps that are no more than 1 unit wide
  target_rows <- 
    which(
      apply(cave, 1, function(x) {
        all(rle(x)$lengths[rle(x)$values == 0] == 1)
      })
    )
  
  if (length(target_rows) > 1) {
    # Which of these gaps are no more than 4 units deep?
    for (i_row in seq_along(target_rows)) {
      endpoint <- ifelse(target_rows[i_row] + 4 > nrow(cave), nrow(cave), target_rows[i_row] + 4)
      
      if (is.null(ncol(cave[target_rows[i_row]:endpoint, ]))) next
      
      gotcha <- 
        all(
          apply(
            cave[target_rows[i_row]:endpoint, ],
            2,
            sum
          ) != 0
        )
      if (gotcha & (target_rows[i_row] + 5 <= nrow(cave))) {
        new_bottom <- target_rows[i_row] + 4
        break
      } else {
        new_bottom <- NULL
      }
    }
    
    if (!is.null(new_bottom)) {
      if (!is.null(nrow(cave[(new_bottom + 1):nrow(cave), ]))) {
        stack_height <- stack_height + nrow(cave[(new_bottom + 1):nrow(cave), ])
        cave <- cave[1:new_bottom, ]
      }
    }
  }
  
}

# Remove empty rows at top
row_sums <- apply(cave, 1, sum)
if (rle(row_sums)$values[1] == 0) cut_rows <- rle(row_sums)$lengths[1]
cave <- cave[-(1:cut_rows), ]

nrow(cave) + stack_height
# 3153

Sys.time() - tic
