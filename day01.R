
## PART 1 ----------------------------------------------------------------------

day1 <- data.frame(
  calories = as.numeric(readLines("inputs/day01.txt"))
)

day1$elf_no <- cumsum(is.na(day1$calories))
day1 <- day1[!is.na(day1$calories), ]

calorie_sums <- by(day1$calories, day1$elf_no, sum)

max(calorie_sums)

## PART 2 ----------------------------------------------------------------------

sum(sort(calorie_sums, decreasing = TRUE)[1:3])
