
# day7 <- readLines("inputs/day07_exp.txt") # test with example data
day7 <- readLines("inputs/day07.txt")

## META LEVEL DESCRIPTION ------------------------------------------------------

# This code is a bit clunky, but here's what it does:

# I first find all directories that don't contain any subdirectories (i.e. omly
# files). I calculate their size, extract their name and store that in a table. 
# Then, I delete the files of those subdirectories, and replace the directories 
# for which I know the size with their size. That means they will be treated 
# as files in later iterations, allowing me to calculate the size of the upper 
# level folders correctly.

# For example, say I have the following structure:

# $ cd /
# $ ls
# 113975 bqpslnv
# 50243 btttmt.nmb
# dir gbjh
# dir hlpzbht
# 43500 lblt
# $ cd gbjh
# $ ls
# 64971 dhmprc.qpl
# 123 abc

# gbjh only contains files (total size 65094). I delete all those files ...

# $ cd /
# $ ls
# 113975 bqpslnv
# 50243 btttmt.nmb
# dir gbjh
# dir hlpzbht
# 43500 lblt

# ... and deplace dir gbjh (line 5) with it's size

# $ cd /
# $ ls
# 113975 bqpslnv
# 50243 btttmt.nmb
# 65094
# dir hlpzbht
# 43500 lblt

# Now I can calculate the size of /, because it only consists of "files"

## PART 1 ----------------------------------------------------------------------

tic <- Sys.time()

# call the first directory "cd main", because I don't want to deal with the \
day7[day7 == "$ cd /"] <- "$ cd main"

# Caution: In the original data, some dirs have the same name! (But they are 
# different dirs.) If we assume each dir is only cd-ed once, we can give them 
# unique IDs
all_cds <- day7[grepl("cd [a-z]+", day7)]

# All cds that appear more than once
more_than_once <- table(all_cds)[table(all_cds) > 1]

# Give them individual names (number them)
for (i in names(more_than_once)) {
  day7[day7 == i] <- paste0(i, "-", letters[1:length(day7[day7 == i])])
}

# Now all cd calls have unique names, enabling us to distinguish folders 
# with the same name. However, the dir names ("dir x") are not unique at this 
# point. This is handled later in the code.

# Where we will store the dir sizes later.
dir_table <- 
  data.frame(
    dir_name = sub("\\$ cd ", "", day7[grepl("cd [a-z]+", day7)]),
    size = NA
  )

# Everything with numbers is a file - remove anything that's not a number in 
# the files names to make it easier to calculate the size later.
day7[grepl("[0-9]", day7)] <- gsub("[^0-9]", "", day7[grepl("[0-9]", day7)])

# For my approach, I can ignore $ cd .. or $ ls
day7 <- day7[!day7 %in% c("$ cd ..", "$ ls")]

# Loop through the commands until dir_table is filled

while (any(is.na(dir_table$size))) {
  # Does not seem to stop the loop when it should?
  
  # Files count as FALSE, and non-files count as TRUE (handy for sum calculation)
  day7_nonfiles <- !grepl("([0-9]+)", day7)
  
  # Count cds
  cd_no <- cumsum(grepl("\\$ cd", day7))
  
  # All groups where all elements (minus the first, which is the cd command) are 
  # FALSE
  dir_stats <- by(day7_nonfiles, cd_no, function(x) sum(x[-1]))
  
  # Name of directories is in the first element of each group
  dir_names <- by(day7, cd_no, function(x) sub("\\$ cd ", "", x[1]))
  
  # Sum of all files (only meaningful for our target directories)
  dir_sizes <- by(day7, cd_no, function(x) sum(as.numeric(x[grepl("[0-9]+", x)])))
  
  # Check which dirs only contain files (index sum == 0) and store their size in 
  # our table
  target_dirs <- names(dir_stats)[dir_stats == 0]
  
  for (i in target_dirs) {
    temp_name <- dir_names[as.numeric(i)]
    dir_table$size[dir_table$dir_name == temp_name] <- dir_sizes[as.numeric(i)]
  }
  
  # Exit here when while condition is fulfilled
  if (!any(is.na(dir_table$size))) break
  
  # Remove the directories for which we identified a size and replace them with 
  # a string containing their size. Start with the last group - otherwise, we'll 
  # mess up the indices by removing stuff.
  for (i in rev(target_dirs)) {
    temp_idx <- which(cd_no == i)
    # Delete files of directory
    day7 <- day7[-temp_idx]
    
    # Replace directory name ("dir x") with its size.
    # Problem: We have directories that have the same name (but are different).
    # At the cd level, I gave them unique names, but that is not the case for 
    # dir. It should work to only replace the first directory that corresponds 
    # to the name (without the unique identifier) from the END of the command 
    # chain.
    temp_dir_name <- dir_names[as.numeric(i)]
    dir_idx <- which(day7 == paste0("dir ", sub("-[a-z]", "", temp_dir_name)))
    
    # We need to replace first index BEFORE temp_idx with the file size.
    # The first dir x before temp_idx is the folder for which we just 
    # calculated the size.
    day7[max(dir_idx[dir_idx < min(temp_idx)])] <- 
      as.character(dir_sizes[as.numeric(i)])
  }
}

# Sum of all directories where the size is at most 100000
sum(dir_table$size[dir_table$size <= 100000])

# 2061777

Sys.time() - tic

## PART 2 ----------------------------------------------------------------------

tic <- Sys.time()

disk_space <- 70000000
space_needed <- 30000000

# unused space: disk space - main
unused_space <- disk_space - dir_table$size[dir_table$dir_name == "main"]

# delete a directory with a size of at least:
min_delete <- space_needed - unused_space

dir_table <- dir_table[order(dir_table$size), ]

min(dir_table$size[dir_table$size >= min_delete])
# 4473403

Sys.time() - tic
