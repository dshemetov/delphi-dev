# Slides link: https://www.stat.cmu.edu/~ryantibs/statcomp/lectures/iteration.html

# Indexing
x <- rnorm(6)
x
x[3]
x[c(3, 4, 5)]
x[3:5]
x[c(3, 5, 4)]
x[-3]
x[c(-3, -4, -5)]
x[-c(3, 4, 5)]
x[-(3:5)]
x[-3:0]

# Matrix indexing
x.mat <- matrix(x, 3, 2)
x.mat
x.mat[2, 2]
x.mat[5]
x.mat[2, ]
x.mat[1:2, ]
x.mat[, 1]
x.mat[, -1]

# List indexing
x.list <- list(x, letters, sample(c(TRUE, FALSE), size = 4, replace = TRUE))
x.list
# Third element
x.list[[3]]
# Third element, kept as a list (why would you want this?)
x.list[3]
x.list[1:2]
x.list[-1]

# Index with booleans
x[c(F, F, T, F, F, F)]
x[c(T, T, F, T, T, T)]
pos.vec <- x > 0
pos.vec
x[pos.vec]
x[x > 0]

# Index with names
names(x.list) <- c("normals", "letters", "bools")
x.list
x.list[["letters"]]
x.list$letters
x.list[c("normals", "bools")]

# Control flow
x <- 0.5

if (x >= 0) {
    x
} else {
    x
}

x <- -2
if (x^2 < 1) {
    x^2
} else if (x >= 1) {
    2 * x - 1
} else {
    -2 * x + 1
}

ifelse(x >= 0, x, -x)

type.of.summary <- "mode"
switch(type.of.summary,
    mean = mean(x),
    median = median(x),
    mode = {
        tab <- table(x)
        as.numeric(names(tab)[tab == max(tab)])
    },
    "unknown summary type"
)

u.vec <- runif(10, -1, 1)
u.vec
u.vec[-0.5 < u.vec & u.vec < 0.5] <- 999
u.vec

(0 > 0) && all(matrix(0, 2, 2) == matrix(0, 3, 3))
(0 > 0) && (NotDefinedVariable == 0)

for (str in c("Prof", "Ryan", "Tibs")) {
    cat(paste(str, "declined to comment\n"))
}

for (str in list(a = "Prof", b = "Ryan", c = "Tibs")) {
    cat(paste(str, "declined to comment\n"))
}
