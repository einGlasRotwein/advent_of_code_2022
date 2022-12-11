
## PREPARE DATA ----------------------------------------------------------------

# day11 <- readLines("inputs/day11_ex.txt")
day11 <- readLines("inputs/day11.txt")

tic <- Sys.time()

day11 <- day11[day11 != ""]
n_monkeys <- length(day11) / 6

# Each monkey is represented by 6 lines.
# 1: name
# 2: items
# 3: operation
# 4: test
# 5: true
# 6: false

initial_items <- vector("list", length = n_monkeys)
operations <- vector("list", length = n_monkeys)
test <- vector("numeric", length = n_monkeys)
true_throw <- vector("numeric", length = n_monkeys)
false_throw <- vector("numeric", length = n_monkeys)

for (i in 1:n_monkeys) {
  temp_items <- day11[2 + 6 * (i - 1)]
  temp_items <- gsub("[^0-9,]", "", temp_items)
  initial_items[[i]] <- as.numeric(unlist(strsplit(temp_items, ",")))
  
  # call eval() to evaluate later
  temp_operation <- day11[3 + 6 * (i - 1)]
  operations[[i]] <- parse(text = sub(".*?= ", "", temp_operation))
  
  temp_test <- day11[4 + 6 * (i - 1)]
  test[i] <- as.numeric(gsub("[^0-9]", "", temp_test))
  
  temp_true <- day11[5 + 6 * (i - 1)]
  true_throw[i] <- as.numeric(gsub("[^0-9]", "", temp_true)) + 1 # index at 1
  
  temp_false <- day11[6 + 6 * (i - 1)]
  false_throw[i] <- as.numeric(gsub("[^0-9]", "", temp_false)) + 1 # index at 1
}

## PART 1 ----------------------------------------------------------------------

items <- initial_items
n_inspected <- rep(0, n_monkeys)

n_rounds <- 20

for (i_round in 1:n_rounds) {
  for (j_monkey in 1:n_monkeys) {
    if (length(items[[j_monkey]]) == 0) next
    n_inspected[j_monkey] <- n_inspected[j_monkey] + length(items[[j_monkey]])
    for (k_item in items[[j_monkey]]) {
      old <- k_item
      temp_worry <- eval(operations[[j_monkey]])
      temp_worry <- floor(temp_worry / 3)
      if (temp_worry %% test[j_monkey] == 0) {
        items[[true_throw[j_monkey]]] <- c(items[[true_throw[j_monkey]]], temp_worry)
      } else {
        items[[false_throw[j_monkey]]] <- c(items[[false_throw[j_monkey]]], temp_worry)
      }
      items[[j_monkey]] <- items[[j_monkey]][-1]
    }
  }
}

prod(sort(n_inspected, decreasing = TRUE)[1:2])
# 55930

Sys.time() - tic

## PART 2 ----------------------------------------------------------------------

tic <- Sys.time()

items <- initial_items
n_inspected <- rep(0, n_monkeys)

# We can't divide by 3 anymore, but we should be able to keep the worry low by 
# using the modulo of the lowest common multiple of the test number of all 
# monkeys
library(DescTools)
lcm_monkey <- LCM(test)

n_rounds <- 10000

for (i_round in 1:n_rounds) {
  for (j_monkey in 1:n_monkeys) {
    if (length(items[[j_monkey]]) == 0) next
    n_inspected[j_monkey] <- n_inspected[j_monkey] + length(items[[j_monkey]])
    for (k_item in items[[j_monkey]]) {
      old <- k_item
      temp_worry <- eval(operations[[j_monkey]])
      temp_worry <- temp_worry %% lcm_monkey
      if (temp_worry %% test[j_monkey] == 0) {
        items[[true_throw[j_monkey]]] <- c(items[[true_throw[j_monkey]]], temp_worry)
      } else {
        items[[false_throw[j_monkey]]] <- c(items[[false_throw[j_monkey]]], temp_worry)
      }
      items[[j_monkey]] <- items[[j_monkey]][-1]
    }
  }
}

prod(sort(n_inspected, decreasing = TRUE)[1:2])
# 14636993466

Sys.time() - tic
