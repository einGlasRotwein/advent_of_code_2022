
## PART 1 ----------------------------------------------------------------------

day10 <- readLines("inputs/day10.txt")

tic <- Sys.time()

# Extract numbers only
day10 <- as.numeric(gsub("[^0-9-]+", "", day10))

cycles <- 0
cycle <- 0
xs <- 1
x <- 1

for (i in 1:length(day10)) {
  if (is.na(day10[i])) {
    cycle <- cycle + 1
    cycles <- c(cycles, cycle)
    xs <- c(xs, x)
  } else {
    cycle <- cycle + 1
    cycles <- c(cycles, cycle)
    xs <- c(xs, x)
    cycle <- cycle + 1
    x <- x + day10[i]
    cycles <- c(cycles, cycle)
    xs <- c(xs, x)
  }
}

sum(xs[cycles %in% (seq(20, 220, 40) - 1)] * seq(20, 220, 40))
# 13180

Sys.time() - tic

## PART 2 ----------------------------------------------------------------------

library(ggplot2)

tic <- Sys.time()

# cycle is the x position (modulo 40)
# (x - 1) : (x + 1) is the sprite
data <- 
  data.frame(
    x = xs,
    cycle = cycles,
    xpos = cycles %% 40,
    ypos = floor(cycles / 40)
  )

data$is_in_sprite <- data$xpos >= data$x -1 & data$xpos <= data$x +1

aoc_green <- "#009900"
aoc_gold <- "#ffff66"
github_grey <- "#0d1117"

day10_theme <- 
  theme(
    panel.background = element_rect(fill = NA, colour = NA, size = 1),
    panel.grid = element_blank(),
    plot.background = element_rect(fill = github_grey, colour = github_grey),
    plot.title = element_text(colour = "white", size = 20),
    strip.background = element_rect(fill = NA, colour = NA),
    strip.text = element_text(size = 16, colour = aoc_green),
    axis.text = element_blank(),
    axis.title = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "none"
  )

day10_plot <- 
  ggplot(
    aes(x = xpos, y = ypos, colour = is_in_sprite),
    data = data[-nrow(data), ]
  ) +
  geom_point(shape = 15, size = 5) +
  scale_colour_manual(values = c(github_grey, aoc_green)) +
  scale_y_reverse(expand = c(3, 0)) +
  scale_x_continuous(expand = c(.2, 0)) +
  day10_theme

Sys.time() - tic
