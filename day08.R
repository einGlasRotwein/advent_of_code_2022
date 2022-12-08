
## PART 1 ----------------------------------------------------------------------

day8 <- readLines("inputs/day08.txt")

tic <- Sys.time()

day8 <- strsplit(day8, "")
day8 <- lapply(day8, as.numeric)
day8 <- as.data.frame(do.call(rbind, day8))

hidden_or_not <- function(forest, roi = NULL, coi = NULL) {
  
  if (!is.null(roi)) {
    if (roi == 1 | roi == nrow(forest)) {
      is_visible <- TRUE
    } else {
      forest_slice_before <- day8[1:(roi - 1), ]
      forest_slice_after <- day8[(roi + 1):nrow(forest), ]
      toi <- day8[roi, ] # trees of interest
      
      # max tree height per column
      max_heights_before <- apply(forest_slice_before, 2, max)
      max_heights_after <- apply(forest_slice_after, 2, max)
      
      is_visible <- toi > max_heights_before | toi > max_heights_after
    }
  }
  
  if (!is.null(coi)) {
    if (coi == 1 | coi == ncol(forest)) {
      is_visible <- TRUE
    } else {
      forest_slice_before <- day8[1:(coi - 1)]
      forest_slice_after <- day8[(coi + 1):ncol(forest)]
      toi <- day8[ , coi] # trees of interest
      
      max_heights_before <- apply(forest_slice_before, 1, max)
      max_heights_after <- apply(forest_slice_after, 1, max)
      
      is_visible <- toi > max_heights_before | toi > max_heights_after
    }
  }
  
  return(is_visible)
}

# dataframe to code if visible or not - all FALSE initially
forest_map <- day8 < 0

for (i in 1:nrow(day8)) {
  forest_map[i, ] <- hidden_or_not(day8, roi = i)
}

for (i in 1:ncol(day8)) {
  forest_map[ , i] <- forest_map[ , i] | hidden_or_not(day8, coi = i)
}

# Number of trees that are visible
sum(forest_map)
# 1814

Sys.time() - tic

## PART 2 ----------------------------------------------------------------------

tic <- Sys.time()

scenic_score <- function(forest, x, y) {
  location_height <- forest[x, y]
  
  if (y == ncol(forest)) {
    see_right <- 0
  } else {
    see_right <- which(forest[x, (y + 1):ncol(forest)] >= location_height)
    if (length(see_right) == 0) {
      see_right <- length(forest[x, (y + 1):ncol(forest)])
    } else {
      see_right <- min(see_right)
    }
  }
  
  if (x == nrow(forest)) {
    see_down <- 0
  } else {
    see_down <- which(forest[(x + 1):nrow(forest), y] >= location_height)
    if (length(see_down) == 0) {
      see_down <- length(forest[(x + 1):nrow(forest), y])
    } else {
      see_down <- min(see_down)
    }
  }
  
  if (y == 1) {
    see_left <- 0
  } else {
    see_left <- which(forest[x, 1:(y - 1)] >= location_height)
    if (length(see_left) == 0) {
      see_left <- length(forest[x, 1:(y - 1)])
    } else {
      see_left <- y - max(see_left)
    }
  }
  
  if (x == 1) {
    see_up <- 0
  } else {
    see_up <- which(forest[1:(x - 1), y] >= location_height)
    if (length(see_up) == 0) {
      see_up <- length(forest[1:(x - 1), y])
    } else {
      see_up <- x - max(see_up)
    }
  }
  
  scenic_score <- see_right * see_left * see_down * see_up
  return(scenic_score)
}

scenic_map <- day8

for (x in 1:nrow(day8)) {
  for (y in 1:ncol(day8)) {
    scenic_map[x, y] <- scenic_score(day8, x, y)
  }
}

max(scenic_map)
# 330786

Sys.time() - tic
