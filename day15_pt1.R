
## PART 1 ----------------------------------------------------------------------

# day15 <- readLines("inputs/day15_ex.txt")
day15 <- readLines("inputs/day15.txt")

tic <- Sys.time()

sensors <- stringr::str_match(day15, "at\\s*(.*?)\\s*:")[ ,2]
sensors <- lapply(strsplit(sensors, ","), function(x) as.numeric(gsub("[^-0-9]", "", x)))

beacons <- stringr::str_match(day15, "is at\\s*(.*?)\\s*$")[ ,2]
beacons <- lapply(strsplit(beacons, ","), function(x) as.numeric(gsub("[^-0-9]", "", x)))

# row of interest
# roi <- 10 # example
roi <- 2000000

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
  }
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

no_beacon <- unique(no_beacon)

# Remove all known beacon positions from the list

# Which are in the roi?
boi <- unique(beacons[sapply(beacons, function(x) x[2] == roi)])

beacons_to_exlude <- 0

for (i in seq_along(boi)) {
  beacons_to_exlude <- 
    beacons_to_exlude + 
    any(sapply(no_beacon, function(x) boi[[i]][1] >= x[1] & boi[[i]][1] <= x[2]))
}

# Count positions where there definitely is no beacon
n_no_beacon <- 0

for (i in seq_along(no_beacon)) {
  n_no_beacon <- n_no_beacon + diff(no_beacon[[i]]) + 1
}

# Exclude know beacons
n_no_beacon - beacons_to_exlude
# 5125700

Sys.time() - tic
