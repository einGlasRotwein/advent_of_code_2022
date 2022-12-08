
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

scenic_score <- function(forest, roi = NULL, coi = NULL) {
  
  if (!is.null(roi)) {
    if (roi == 1 | roi == nrow(forest)) {
      scenic_score <- 0
    } else {
      forest_slice_before <- day8[1:roi, ]
      forest_slice_after <- day8[roi:nrow(forest), ]
      toi <- day8[roi, ] # trees of interest
      
      score_up <- 
        apply(forest_slice_before, 2, function(x) {
          comparison <- which(x[-length(x)] >= x[length(x)])
          ifelse(length(comparison) == 0, roi - 1, roi - max(comparison))
        })
      
      score_down <- 
        apply(forest_slice_after, 2, function(x) {
          comparison <- which(x[-1] >= x[1])
          ifelse(length(comparison) == 0, nrow(forest) - roi, min(comparison))
        })
      
      scenic_score <- score_up * score_down
    }
  }
  
  if (!is.null(coi)) {
    if (coi == 1 | coi == ncol(forest)) {
      scenic_score <- 0
    } else {
      forest_slice_before <- day8[1:coi]
      forest_slice_after <- day8[coi:ncol(forest)]
      toi <- day8[ , coi] # trees of interest
      
      score_left <- 
        apply(forest_slice_before, 1, function(x) {
          comparison <- which(x[-length(x)] >= x[length(x)])
          ifelse(length(comparison) == 0, coi - 1, coi - max(comparison))
        })
      
      score_right <- 
        apply(forest_slice_after, 1, function(x) {
          comparison <- which(x[-1] >= x[1])
          ifelse(length(comparison) == 0, ncol(forest) - coi, min(comparison))
        })
      
      scenic_score <- score_left * score_right
    }
  }
  
  return(scenic_score)
}

scenic_map <- day8

scenic_score(day8, roi = 20)

for (i in 1:nrow(day8)) {
  scenic_map[i, ] <- scenic_score(day8, roi = i)
}

for (i in 1:ncol(day8)) {
  scenic_map[ , i] <- scenic_map[ , i] * scenic_score(day8, coi = i)
}

max(scenic_map)
# 330786

Sys.time() - tic
