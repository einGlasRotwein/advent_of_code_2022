
# We need to move in steps of 1, because we need to update the position of the 
# tail after each step.
move <- function(direction, pos) {
  if (direction == "R") {
    pos[1] <- pos[1] + 1
  } else if (direction == "L") {
    pos[1] <- pos[1] - 1
  } else if (direction == "D") {
    pos[2] <- pos[2] - 1
  } else if (direction == "U") {
    pos[2] <- pos[2] + 1
  }
  
  return(pos)
}

drag <- function(posH, posT) {
  
  diffx <- posH[1] - posT[1]
  diffy <- posH[2] - posT[2]
  
  # Gordon's brilliant idea: We move the tail directly to the right of the 
  # head if it's ANYWHERE right of the head, directly below the head if it's 
  # ANYWHERE below the head etc.
  
  # Special case for part 2 when the knot is off by 2 on BOTH axes. Then it makes 
  # a single diagonal movement in one of four possible directions.
  if (diffx == 2 & diffy == 2) { # move down left
    posT[1] <- posH[1] -1
    posT[2] <- posH[2] -1
  } else if (diffx == 2 & diffy == -2) { # move up left
    posT[1] <- posH[1] -1
    posT[2] <- posH[2] +1
  } else if (diffx == -2 & diffy == -2) { # move up right
    posT[1] <- posH[1] +1
    posT[2] <- posH[2] +1
  } else if (diffx == -2 & diffy == 2) { # move down right
    posT[1] <- posH[1] +1
    posT[2] <- posH[2] -1
  } else if (diffx == 2) { # move left of the head
    posT[2] <- posH[2]
    posT[1] <- posH[1] -1
  } else if (diffx == -2) { # move right of the head
    posT[2] <- posH[2]
    posT[1] <- posH[1] +1
  } else if (diffy == 2) { # move below the head
    posT[1] <- posH[1]
    posT[2] <- posH[2] -1
  } else if (diffy == -2) { # move above the head
    posT[1] <- posH[1]
    posT[2] <- posH[2] +1
  }
  
  # If diffx and diffy are not > 1, the tail stays where it is
  
  return(posT)
}
