
## PART 1 ----------------------------------------------------------------------

# day18 <- readLines("inputs/day18_ex.txt")
day18 <- readLines("inputs/day18.txt")

tic <- Sys.time()

day18 <- lapply(strsplit(day18, ","), as.numeric)
day18 <- do.call("rbind", day18)
day18 <- as.data.frame(day18)
names(day18) <- c("x", "y", "z")

day18_collapsed <- apply(day18, 1, paste, collapse = ".")

# Find the six potential neighbours of each cube.
# Cube is a dataframe with x,y,z
get_neighbours <- function(cube) {
  to_add <- 
    data.frame(
      x = c(-1, 1, rep(0, 4)),
      y = c(0, 0, -1, 1, 0, 0),
      z = c(rep(0, 4), -1, 1)
    )
  
  neighbours <- to_add + do.call("rbind", replicate(6, temp_cube, simplify = FALSE))
  return(neighbours)
}

surface_area <- 0

for (i in 1:nrow(day18)) {
  temp_cube <- day18[i, ]
  temp_neighbours <- get_neighbours(temp_cube)
  
  # How many neighbours are covered by another cube?
  temp_neighbours_collapsed <- apply(temp_neighbours, 1, paste, collapse = ".")
  open_sides <- sum(!temp_neighbours_collapsed %in% day18_collapsed)
  surface_area <- surface_area + open_sides
}

surface_area
# 3526

Sys.time() - tic
