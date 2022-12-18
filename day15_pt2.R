
## PART 2 ----------------------------------------------------------------------

# Not the most elegant solution, but I'll expand my solution from part 1. I'll 
# go through every row, and when I find one where I don't have to exclude 
# every single position, that is the row where the beacon must be. Then we need 
# to find the y position.

# day15 <- readLines("inputs/day15_ex.txt")
day15 <- readLines("inputs/day15.txt")

tic <- Sys.time()

sensors <- stringr::str_match(day15, "at\\s*(.*?)\\s*:")[ ,2]
sensors <- lapply(strsplit(sensors, ","), function(x) as.numeric(gsub("[^-0-9]", "", x)))

beacons <- stringr::str_match(day15, "is at\\s*(.*?)\\s*$")[ ,2]
beacons <- lapply(strsplit(beacons, ","), function(x) as.numeric(gsub("[^-0-9]", "", x)))

# row of interest
# max_roi <- 20 # example
max_roi <- 4000000
pb <- txtProgressBar(min = 0, max = max_roi, initial = 0, style = 3) 

for (i in 1:max_roi) {
  
  setTxtProgressBar(pb,i)
  
  roi <- i
  # Save start and end values of streaks where there are definitely no beacons
  no_beacon <- list()
  
  for (sensor in seq_along(sensors)) {
    # Distance between sensor and beacon
    distance <- sum(abs(sensors[[sensor]] - beacons[[sensor]]))
    
    # min and max row this sensor covers
    min_row <- sensors[[sensor]][2] - distance
    max_row <- sensors[[sensor]][2] + distance
    
    # Does this sensor cover our roi?
    if (roi >= min_row & roi <= max_row) {
      # Calculate how many fields the sensor covers at roi.
      # Distance to sensor mid row
      mid_distance <- abs(sensors[[sensor]][2] - roi)
      
      start_width <- sensors[[sensor]][1] - (distance - mid_distance)
      end_width <- sensors[[sensor]][1] + (distance - mid_distance)
      
      # We need to keep track of whether we can merge together previous 
      # start/end values.
      
      value_adjusted <- FALSE
      
      for (i in seq_along(no_beacon)) {
        if (
          start_width < no_beacon[[i]][1] &
          end_width < no_beacon[[i]][1]
        ) {
          value_adjusted <- FALSE
        } else if (
          start_width > no_beacon[[i]][2] &
          end_width > no_beacon[[i]][2]
        ) {
          value_adjusted <- FALSE
        } else if (
          start_width <= no_beacon[[i]][1] &
          end_width >= no_beacon[[i]][2]
        ) {
          no_beacon[[i]][1] <- start_width
          no_beacon[[i]][2] <- end_width
          value_adjusted <- TRUE
        } else if (
          start_width <= no_beacon[[i]][1] &
          end_width <= no_beacon[[i]][2]
        ) {
          no_beacon[[i]][1] <- start_width
          value_adjusted <- TRUE
        } else if (
          start_width >= no_beacon[[i]][1] &
          end_width >= no_beacon[[i]][2]
        ) {
          no_beacon[[i]][2] <- end_width
          value_adjusted <- TRUE
        }
      }
      
      # If no connection to previous start/end values, safe as new value pair
      if (!value_adjusted) {
        no_beacon[[length(no_beacon) + 1]] <- c(start_width, end_width) 
      }
      
      # Merge overlaps
      for (i in seq_along(no_beacon)) {
        start_width <- no_beacon[[i]][1]
        end_width <- no_beacon[[i]][2]
        
        for (j in seq_along(no_beacon)) {
          if (
            start_width < no_beacon[[j]][1] &
            end_width < no_beacon[[j]][1]
          ) {
            next
          } else if (
            start_width > no_beacon[[j]][2] &
            end_width > no_beacon[[j]][2]
          ) {
            next
          } else if (
            start_width <= no_beacon[[j]][1] &
            end_width >= no_beacon[[j]][2]
          ) {
            no_beacon[[j]][1] <- start_width
            no_beacon[[j]][2] <- end_width
          } else if (
            start_width <= no_beacon[[j]][1] &
            end_width <= no_beacon[[j]][2]
          ) {
            no_beacon[[j]][1] <- start_width
          } else if (
            start_width >= no_beacon[[j]][1] &
            end_width >= no_beacon[[j]][2]
          ) {
            no_beacon[[j]][2] <- end_width
          }
        }
      }
    }
  }
  
  no_beacon <- unique(no_beacon)
  
  # Count positions where there definitely is no beacon
  n_no_beacon <- 0
  
  for (i in seq_along(no_beacon)) {
    # Adjust for boundaries
    if (no_beacon[[i]][1] < 0) no_beacon[[i]][1] <- 0
    if (no_beacon[[i]][1] > max_roi) no_beacon[[i]][1] <- max_roi
    if (no_beacon[[i]][2] < 0) no_beacon[[i]][2] <- 0
    if (no_beacon[[i]][2] > max_roi) no_beacon[[i]][2] <- max_roi
    
    n_no_beacon <- n_no_beacon + diff(no_beacon[[i]]) + 1
  }
  
  if (n_no_beacon != (max_roi + 1)) {
    beacon_in_row <- roi
    # column: which position is missing?
    covered <- unlist(lapply(no_beacon, function(x) x[1]:x[2]))
    beacon_in_col <- (0:max_roi)[!0:max_roi %in% covered]
    break
  }
}

close(pb)

options(scipen = 999)

beacon_in_col * 4000000 + beacon_in_row

Sys.time() - tic

