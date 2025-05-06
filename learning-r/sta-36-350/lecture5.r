library(tidyverse)

1 %>%
    exp() %>%
    log()

state_df <- data.frame(state.x77)
state.region %>%
    tolower() %>%
    tapply(state_df$Income, ., summary)

x <- "Prof Tibs really loves piping"
x %>%
    strsplit(split = " ") %>%
    .[[1]] %>%
    nchar() %>%
    max()

mtcars %>%
    arrange(mpg) %>%
    head(4)
mpg_inds <- order(mtcars$mpg)
head(mtcars[mpg_inds, ], 4)

mtcars %>%
    arrange(desc(mpg)) %>%
    head(4)
mpg_inds_decr <- order(mtcars$mpg, decreasing = TRUE)
head(mtcars[mpg_inds_decr, ], 4)

mtcars %>%
    arrange(desc(gear), desc(hp)) %>%
    head(8)

mtcars %>%
    select(cyl, disp, hp) %>%
    head(2)
head(mtcars[, c("cyl", "disp", "hp")], 2)

mtcars %>%
    select(starts_with("d")) %>%
    head(2)
d_colnames <- grep(x = colnames(mtcars), pattern = "^d")
head(mtcars[, d_colnames], 2)

mtcars %>%
    select(ends_with("t")) %>%
    head(2)
mtcars %>%
    select(ends_with("yl")) %>%
    head(2)
mtcars %>%
    select(contains("ar")) %>%
    head(2)

mtcars <- mtcars %>% mutate(hp_wt = hp / wt, mpg_wt = mpg / wt)
mtcars$hp_wt <- mtcars$hp / mtcars$wt
mtcars$mpg_wt <- mtcars$mpg / mtcars$wt

mtcars <- mtcars %>% mutate(hp_wt_again = hp / wt, hp_wt_cyl = hp_wt_again / cyl)
mtcars$hp_wt_again <- mtcars$hp / mtcars$wt
mtcars$hp_wt_cyl <- mtcars$hp_wt_again / mtcars$cyl

mtcars <- mtcars %>% mutate_at(c("hp_wt", "mpg_wt"), log)
mtcars$hp_wt <- log(mtcars$hp_wt)
mtcars$mpg_wt <- log(mtcars$mpg_wt)

pak::pkg_install("rstudio/EDAWR")

library(EDAWR)

EDAWR::cases
EDAWR::cases %>% pivot_longer(names_to = "year", values_to = "n", cols = 2:4)
EDAWR::cases %>% pivot_longer(names_to = "year", values_to = "n", -country)
