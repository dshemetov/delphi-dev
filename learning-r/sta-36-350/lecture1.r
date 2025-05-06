# Slides link: https://www.stat.cmu.edu/~ryantibs/statcomp/lectures/intro.html

# Types
typeof(7)
is.numeric(7)
is.na(7)
is.na(7 / 0)
is.na(0 / 0)
is.character(7)
is.character("7")
is.character("seven")
is.na("seven")

as.character(5 / 6)
5 / 6 == as.numeric(as.character(5 / 6))
1 == 1 + 1 / 10^15
1 == 1 + 1 / 10^16

pi
cos(pi)

# Defined variables
circumference <- 2 * pi
ls()
rm("circumference")
# Erase everything
# rm(list = ls()) 

# Vectors
x <- c(7, 8, 10, 45)
is.vector(x)
1:5 == c(1, 2, 3, 4, 5)
x[1]
x[-1] # Everything but element 1

weekly.hours <- vector(length = 5)
weekly.hours[5] <- 8
weekly.hours

# Vector arithmetic
y <- c(-7, -8, -10, -45)
x + y
x * y
x + c(-7, -8) # Recycling repeat elements
x ^ c(1, 0, -1, 0.5)
x > 9
identical(x, -y)
all.equal(c(0.5 - 0.3, 0.3 - 0.1), c(0.3 - 0.1, 0.5 - 0.3))

# Functions of vectors
mean(x)
median(x)
sd(x)
var(x)
max(x)
min(x)
length(x)
sum(x)
sort(x)
hist(x)
ecdf(x)
summary(x)
any(x > 8)
all(x > 8)

# Indexing vectors
identical(x[c(2, 4)], x[c(-1, -3)])
x[x > 9]
y[x > 9]
which(x > 9)

# Named components
names(x) <- c("v1", "v2", "v3", "fred")
names(x)
x
x[c("v1", "v2")]
which(names(x) == "v1")

# Arrays
x <- c(7, 8, 10, 45)
x.arr <- array(x, dim = c(2, 2))
x.arr
dim(x.arr)
is.vector(x.arr)
is.array(x.arr)
typeof(x.arr)
x.arr[1, 2]
x.arr[3]
x.arr[c(1, 2), 2]
x.arr
x.arr[, 2, drop = FALSE]
which(x.arr > 9)

# Matrix
z.mat <- matrix(c(40, 1, 60, 3), nrow = 2)
z.mat
is.array(z.mat)
is.matrix(z.mat)
z.mat <- matrix(c(40, 1, 60, 3), ncol = 2, byrow = TRUE)
z.mat
six.sevens <- matrix(rep(7, 6), ncol = 3)
six.sevens
z.mat %*% six.sevens # Matrix multiply
rowSums(z.mat)
colSums(z.mat)
rowMeans(z.mat)
colMeans(z.mat)
diag(z.mat)
diag(z.mat) <- c(35, 4)
z.mat
diag(c(3, 4))
diag(2)
t(z.mat) # transpose
det(z.mat) # transpose
solve(z.mat) # inverse
z.mat %*% solve(z.mat)
colnames(z.mat) <- c("lol", "kek")
z.mat

# Lists
my.dist <- list("exponential", 7, FALSE)
my.dist
my.dist[2]
my.dist[[2]]
my.dist <- c(my.dist, 9)
my.dist
length(my.dist)
length(my.dist) <- 3
my.dist
my.dist[-2]
names(my.dist) <- c("family", "mean", "is.symmetric")
my.dist
my.dist[["family"]]
my.dist["family"]

another.dist <- list(family = "gaussian", mean = 7, sd = 1, is.symmetric = TRUE)
another.dist
my.dist$was.estimated <- FALSE
my.dist[["last.updated"]] <- "2021-01-01"
my.dist
my.dist$was.estimated <- NULL
my.dist

# Data frames
a.mat <- matrix(c(35, 8, 10, 4), nrow = 2)
colnames(a.mat) <- c("v1", "v2")
a.mat
a.mat[, "v1"]
a.mat[, c("v1", "v2")]
a.df <- data.frame(a.mat, logicals = c(TRUE, FALSE))
a.df
a.df[1, ]
colMeans(a.df)
rbind(a.df, list(v1 = -3, v2 = -5, logicals = TRUE))
rbind(a.df, c(3, 4, 6))
