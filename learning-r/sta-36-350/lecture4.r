library(tidyverse)
my.list <- list(
    nums = seq(0.1, 0.6, by = 0.1), chars = letters[1:12],
    bools = sample(c(TRUE, FALSE), 6, replace = TRUE)
)
map(my.list, length)
lapply(my.list, length)

map_dbl(my.list, length)
map_chr(my.list, length)

as.numeric(sapply(my.list, length))
as.numeric(unlist(lapply(my.list, length)))
vapply(my.list, FUN = length, FUN.VALUE = numeric(1))

pak::pkg_install("repurrrsive") # Install package
library(repurrrsive) # Load Game of Thrones data set
class(got_chars)
class(got_chars[[1]])
names(got_chars[[1]])
map_chr(got_chars, function(x) {
    return(x$name)
})
map_chr(got_chars, \(x) pluck(x, "name"))
map_chr(got_chars, pluck("name"))
map_chr(got_chars, "name")
map_lgl(got_chars, "alive")
sapply(got_chars, `[[`, "name")

map_dfr(got_chars, `[`, c("name", "alive"))
data.frame(
    name = sapply(got_chars, `[[`, "name"),
    alive = sapply(got_chars, `[[`, "alive")
)

head(mtcars)
filter(mtcars, (mpg >= 20 & disp >= 200) | (drat <= 3))
subset(mtcars, (mpg >= 20 & disp >= 200) | (drat <= 3))
mtcars[(mtcars$mpg >= 20 & mtcars$disp >= 200) | (mtcars$drat <= 3), ]

head(group_by(mtcars, cyl), 2)

summarize(mtcars, mpg = mean(mpg), hp = mean(hp))
summarize(group_by(mtcars, cyl), mpg = mean(mpg), hp = mean(hp))
c("mpg" = mean(mtcars$mpg), "hp" = mean(mtcars$hp))
cbind(
    tapply(mtcars$mpg, mtcars$cyl, mean),
    tapply(mtcars$hp, mtcars$cyl, mean)
)
sapply(split(mtcars, mtcars$cyl), FUN = function(x) {
    return(c("mpg" = mean(x$mpg), "hp" = mean(x$hp)))
})
aggregate(mtcars[, c("mpg", "hp")], by = list(mtcars$cyl), FUN = mean)
