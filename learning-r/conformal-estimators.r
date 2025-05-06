# These were scratch simulations while following Ryan's conformal estimators
# talk.
library(httpgd)
library(ggplot2)

hgd()

# Naive
m <- 300
x.ecdf <- ecdf(c(rnorm(m), Inf))
plot(x.ecdf, xlim = c(0, 4))

n <- 50000
x.test <- rnorm(n)
length(x.test[x.test <= quantile(x.ecdf, .9)]) / n

# Conformal
m <- 300
x <- rnorm(x)
y <- 3 * x + rnorm(m)
l <- lm(y ~ x, data = list("x" = x))

n <- 5000
x.test <- rnorm(n)
y.test <- 3 * x.test + rnorm(n)
r <- abs(y.test - predict(l, newdata = list("x" = x.test)))
length(x.test[x.test <= quantile(ecdf(c(r, Inf)), .9)]) / n
