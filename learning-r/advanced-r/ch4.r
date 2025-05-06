# pak::pkg_install("bench")
library(bench)

mean1 <- function(x) mean(x)
mean2 <- function(x) sum(x) / length(x)
x <- runif(1e3)
x <- as.integer(x)

bench::mark(
  mean1(x),
  mean2(x)
)[c("expression", "min", "median", "itr/sec", "n_gc")]


