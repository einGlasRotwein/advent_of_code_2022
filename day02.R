
library(dplyr)

## PART 1 ----------------------------------------------------------------------

# Code:
# X for Rock, Y for Paper, and Z for Scissors
# A for Rock, B for Paper, and C for Scissors

# Score:
# 1 for Rock, 2 for Paper, and 3 for Scissors

day2 <- read.table("inputs/day02.txt")
names(day2) <- c("elf", "me")

day2$numeric_elf <- as.numeric(factor(day2$elf))
day2$numeric_me <- as.numeric(factor(day2$me))

day2 <- 
  day2 %>% 
  mutate(
    outcome = case_when(
      numeric_elf == numeric_me ~ 3, # draw
      numeric_elf == 3 & numeric_me == 1 ~ 6, # win
      numeric_elf == 1 & numeric_me == 3 ~ 0, # loss
      numeric_elf < numeric_me ~ 6, # win
      numeric_elf > numeric_me ~ 0 # loss
    )
  )

day2$score <- day2$numeric_me + day2$outcome

sum(day2$score)
# 12156

## PART 2 ----------------------------------------------------------------------

rm(list = ls())

day2 <- read.table("inputs/day02.txt")
names(day2) <- c("elf", "target_outcome")

day2$n_elf <- as.numeric(factor(day2$elf))
day2$n_target_outcome <- as.numeric(factor(day2$target_outcome))

# X means you need to lose, Y means you need to end the round in a draw, 
# and Z means you need to win

day2 <- 
  day2 %>% 
  mutate(
    n_me = case_when(
      n_target_outcome == 2 ~ n_elf,
      n_target_outcome == 3 ~ ifelse(n_elf == 3, 1, n_elf + 1),
      n_target_outcome == 1 ~ ifelse(n_elf == 1, 3, n_elf - 1)
    )
  )

day2$outcome <- (day2$n_target_outcome - 1) * 3

day2$score <- day2$n_me + day2$outcome

sum(day2$score)
# 10835
