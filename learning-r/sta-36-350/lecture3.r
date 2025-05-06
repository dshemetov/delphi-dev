# Slides link: https://www.stat.cmu.edu/~ryantibs/statcomp/lectures/apply.html

# Data frames
my.df <- data.frame(
    nums = seq(0.1, 0.6, by = 0.1),
    chars = letters[1:6],
    bools = sample(c(TRUE, FALSE), 6,
        replace = TRUE
    )
)
my.df

# Indexing
my.df[, 1]
my.df[, "nums"]
my.df$nums
my.df$chars
my.df[["chars"]]

# Create data frame from a matrix
class(state.x77)
head(state.x77)
class(state.region)
head(state.region)
class(state.division)
head(state.division)

state.df <- data.frame(state.x77, Region = state.region, Division = state.division)
class(state.df)
head(state.df)

# Adding columns
state.df <- data.frame(state.df, Cool = sample(c(T, F), nrow(state.df), replace = TRUE))
head(state.df, 4)

state.df$Score <- sample(1:100, nrow(state.df), replace = TRUE)
head(state.df, 4)

# Delete columns
state.df <- state.df[, -ncol(state.df)]
head(state.df, 4)

state.df$Cool <- NULL
head(state.df, 4)

# Boolean indexing
mean(state.df[state.df$Division == "New England", "Frost"])
mean(state.df[state.df$Division == "Pacific", "Frost"])

# Subset
state.df.ne.1 <- subset(state.df, Division == "New England")
state.df.ne.2 <- state.df[state.df$Division == "New England", ]
all(state.df.ne.1 == state.df.ne.2)

mean(subset(state.df, Division == "New England")$Frost)
mean(state.df.ne.1$Frost)
mean(subset(state.df, Division == "Pacific")$Frost)

# Apply
apply(state.x77, MARGIN = 2, FUN = min)
apply(state.x77, MARGIN = 2, FUN = max)
apply(state.x77, MARGIN = 2, FUN = which.max)
apply(state.x77, MARGIN = 2, FUN = summary)

# Apply a custom function
trimmed.mean <- function(v) {
    q1 <- quantile(v, probs = 0.1)
    q2 <- quantile(v, probs = 0.9)
    return(mean(v[v >= q1 & v <= q2]))
}
apply(state.x77, MARGIN = 2, FUN = trimmed.mean)

# Applying a function with extra arguments
trimmed.mean <- function(v, p1, p2) {
    q1 <- quantile(v, probs = p1)
    q2 <- quantile(v, probs = p2)
    return(mean(v[v >= q1 & v <= q2]))
}
apply(state.x77, MARGIN = 2, FUN = trimmed.mean, p1 = 0.1, p2 = 0.9)

# What's the return arg from apply?
# If my.fun() returns a single value, then apply() returns a vector.
# If my.fun() returns a vector, then apply() returns a matrix.
# If my.fun() returns different length outputs, then apply() returns a list.
# If my.fun() returns a list, then apply() returns a list.

x <- matrix(rnorm(9), 3, 3)
x
# Don't do this (much slower for big matrices)
apply(x, MARGIN = 1, function(v) {
    return(sum(v > 0))
})
# Do this instead
rowSums(x > 0)

# lapply (output is always a list)
my.list <- list(
    nums = seq(0.1, 0.6, by = 0.1), chars = letters[1:12],
    bools = sample(c(TRUE, FALSE), 6, replace = TRUE)
)
my.list
lapply(my.list, FUN = length)
lapply(my.list, FUN = summary)

# sapply (attempts to simplify output to a vector or matrix, but returns a list
# if it cant')
sapply(my.list, FUN = mean)
sapply(my.list, FUN = length)
sapply(my.list, FUN = summary)

# tapply (levels of a factor vector; like groupby)
tapply(state.x77[, "Frost"], INDEX = state.region, FUN = mean)
tapply(state.x77[, "Frost"], INDEX = state.region, FUN = sd)

# mapply (multiple arguments)
mapply(rep, 1:4, 4:1)
mapply(
    function(x, y) seq_len(x) + y,
    c(a = 1, b = 2, c = 3), # names from first
    c(A = 10, B = 0, C = -10)
)

# split (split a vector by a factor)
split(state.x77[, "Frost"], state.region)

state.by.reg <- split(data.frame(state.x77), state.region)
class(state.by.reg)
names(state.by.reg[[1]])
class(state.by.reg[[1]])
state.by.reg
lapply(state.by.reg, FUN = head, n = 3)

m <- rbind(
    matrix(1:12, 3, 4),
    matrix(c(NA, 2, 3, 5), 1, 4)
)
m
apply(m, MARGIN = 1, FUN = function(r) {
    return(any(is.na(r)))
})
