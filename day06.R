
## READ IN INPUT ---------------------------------------------------------------

day6 <- readLines("inputs/day06.txt")

tic <- Sys.time()

# Split into single characters
day6 <- unlist(strsplit(day6, ""))

## PART 1 ----------------------------------------------------------------------

# One obvious solution would have been to use a sliding window across the 
# characters and see when a unique string is detected. For some reason, I 
# thought it might be faster to group the data into groups of 4, and then check 
# which group is unique. In the first example, we need to do this 4 times, 
# because when there are 4 characters, we need to slide our grouping to the 
# right 4 times. (After sliding the groups 4 times, the result is equivalent 
# to the first grouping minus the first group.)
# Not sure whether it actually IS faster (it might be when the match is only
# found right at the end of a very long string), but anyways, here's wonderwall.

# Initialise vector that will store the position of the last character of the 
# first  four unique characters
first_unique <- vector(mode = "numeric")

# We're looking for 4 unique characters
nchars <- 4

# Loop from 0 - 2, because we need only 3 iterations (4 would be 
# equivalent to the first iteration.)
for (i in 0:(nchars - 2)) {
  # Grouping variable: Divide vector in groups of 4. The first group id is 2, 
  # not 1, because we want to add group 1 at the beginning of the grouping 
  # vector to slide the groups to the right from the 2nd iteration onwards.
  groups <- rep(2:(round(length(day6) / nchars + 1)), each = nchars)
  
  # Add a buffer to "slide" the groups: I.e. in the 2nd iteration, the groups 
  # would be 1, 2, 2, 2, 2, 3 ...
  groups <- c(rep(1, i), groups)
  groups <- groups[1:length(day6)] # cut to input length
  
  # Get number of unique characters per group
  n_unique <- by(day6, groups, function(x) length(unique(x)))
  
  # 1) Get the first group that consist of 4 unique characters
  # 2) Get the maximum index that correspond to the name of that group 
  #    (because we want the last character of that group)
  first_unique[i + 1] <- max(which(groups == names(which(n_unique == nchars)[1])))
}

# Use the minimum index we found across all iterations
min(first_unique)
# 1198

Sys.time() - tic

## PART 2 ----------------------------------------------------------------------

tic <- Sys.time()

# Same problem, but now for 14 instead of 4 characters
first_unique <- vector(mode = "numeric")

nchars <- 14

for (i in 0:(nchars - 2)) {
  groups <- rep(2:(round(length(day6) / nchars + 1)), each = nchars)
  groups <- c(rep(1, i), groups)
  groups <- groups[1:length(day6)]
  
  n_unique <- by(day6, groups, function(x) length(unique(x)))
  
  # The only difference is that we have to add some checks for the case 
  # when there are no groups with 14 unique characters.
  if (sum(n_unique == nchars) == 0) {
    first_unique[i + 1] <- NA
  } else {
    first_unique[i + 1] <- max(which(groups == names(which(n_unique == nchars)[1]))) 
  }
}

min(first_unique, na.rm = TRUE)
# 3120

Sys.time() - tic
