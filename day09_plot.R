
library(tidyverse)
library(gganimate)

load("day09.RData")

aoc_green <- "#009900"
aoc_gold <- "#ffff66"
github_grey <- "#0d1117"

aoc_theme <- 
  theme(
    panel.background = element_rect(fill = NA, colour = NA, size = 1),
    panel.grid = element_blank(),
    plot.background = element_rect(fill = github_grey, colour = github_grey),
    plot.title = element_text(colour = "white", size = 20),
    strip.background = element_rect(fill = NA, colour = NA),
    strip.text = element_text(size = 16, colour = aoc_green),
    axis.text = element_text(size = 12, colour = "white"),
    axis.title = element_text(size = 14, colour = "white"),
    axis.line = element_line(colour = "white", size = .5),
    axis.ticks = element_line(colour = "white", size = .5),
    legend.position = "none"
  )

positions <- 
  positions %>% 
  rowid_to_column("iteration") %>%
  pivot_longer(
    -iteration, 
    names_to = c(".value", "knot"), 
    names_pattern = "(.)(.[0-9]+)"
  ) %>% 
  mutate(name = ifelse(knot == "K1", "head", "knot"))

max_x <- max(positions$x)
max_y <- max(positions$y)
min_x <- min(positions$x)
min_y <- min(positions$y)

positions <- 
  positions %>% 
  mutate(knot_no = as.numeric(sub("K", "", knot)))

n_steps <- max(positions$iteration)

anim <- 
  ggplot() +
  geom_line(
    aes(x = x, y = y),
    size = .8, colour = aoc_gold,
    positions[positions$iteration %in% 1:n_steps & positions$knot_no == 10, ]
  ) +
  geom_point(
    aes(x = x, y = y, alpha = knot_no, group = knot_no),
    size = .8, colour = aoc_green,
    data = positions[positions$iteration %in% 1:n_steps, ]
  ) +
  scale_x_continuous(limits = c(min_x - 1, max_x + 1)) +
  scale_y_continuous(limits = c(min_y - 1, max_y + 1)) +
  scale_alpha(range = c(1, .1)) +
  aoc_theme +
  transition_reveal(iteration)

## ATTENTION: This takes more than 30 min!
# (The resulting gif is quite slow and long, but I haven't found a way to make 
# it faster without too many points printed to the screen at the same time ...)
# animate(anim, nframes = n_steps, duration = 120)

# anim_save("day09_anim.gif")
