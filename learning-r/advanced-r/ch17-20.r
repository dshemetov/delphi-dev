# Terminology.
#
#   Quote: a data structure that represents code
#   Quosure: a data structure that represents code and its environment (quote
#      and closure).
#   Quotation: a quote or a quosure.
#   Expression: a quote that is evaluated in the global environment.
#      Supports injections.
#   Diffusion: rlang's term for the process of quoting and unquoting.
#   Quasi-quotation: a quosure that is evaluated in a specific environment.
#   Non-standard evaluation (NSE): evaluation of an expression

# The rlang way to get a quote is to use the expr() function.
rlang::expr(a + 2)

# The way to do this in a function is to use the enexpr() function.
f <- function(x) {
  rlang::expr(x)
}
f(a + 2)
f <- function(x) {
  rlang::enexpr(x)
}
f(a + 2)
f <- function(...) {
  rlang::enexprs(...)
}
f(x = a + 2, y = b + 3)

# sym is similar to expr, but takes a string and returns a symbol. Note the
# backticks.
rlang::sym("a")
rlang::sym("a + 2")
f <- function(x) {
  rlang::sym(x)
}
f("a + 2")
f <- function(x) {
  rlang::ensym(x)
}
f("a + 2")
f <- function(...) {
  rlang::ensyms(...)
}
f(x = "a + 2", y = "b + 3")

# The base R analogue of expr() is quote(). Note that quote() does not support
# injections.
quote(a + 2)
# The base R analogue of enexpr() is substitute().
f <- function(x) {
  substitute(x)
}
f(a + 2)
# The base R analgoue of exprs is alist.
alist(x = a + 1, y = b + 22)
# The base R analogue of ensyms is as.list(substitute(...())) (undocumented).
f <- function(...) {
  as.list(substitute(...()))
}
f(x = a + 1, y = b + 22)
substitute(x * y * z, list(x = 10, y = quote(a + b)))

# Unquoting.
x <- expr(-1)
expr(f(!!x, y))

# Unquoting symbols.
a <- sym("y")
b <- 1
expr(f(!!a, !!b))
f(!!a)

# Unquoting in a function call.
rlang::call2(quote(f), !!!list(a = 1, b = 2))

# Unquoting a dataframe column name.
x <- rlang::expr(x)
rlang::expr(`$`(df, !!x))

# Unquoting many arguments.
xs <- rlang::exprs(1, a, -b)
rlang::expr(f(!!!xs, y))
# ... with names.
ys <- set_names(xs, c("a", "b", "c"))
expr(f(!!!ys, d = 4))

# !! (injection) and !!! (dynamic dots) only work inside rlang quoting
# functions.

# bquote is a base R function that supports unquoting.
xyz <- bquote((x + y + z))
bquote(-.(xyz) / 2)

var <- "x"
val <- c(4, 3, 9)
tibble::tibble(!!var := val)

# exec() is like call2(), but it's evaluated after.
args <- list(x = 1:10, na.rm = TRUE, trim = 0.1)
exec("mean", !!!args)

f <- function(x, y) {
  x + y
}
exec("f", x = "a", y = tibble(a = 1, b = 2))

f <- function(df) {
  stop("SOIEFJOIJEF")
}
asdf <- data.frame(x = rnorm(100L))
do.call(f, list(asdf))

# The rlang way to get a quosure is to use the quo() function.
rlang::quo(a + 2)

# Look at the AST of an expression.
lobstr::ast(pkg::bar(1 + 3 * (2 + 4) + a[[2]]))

capture_it <- function(x) {
  rlang::enexpr(x)
}

wrapper <- function(x) {
  capture_it(!!rlang::enexpr(x))
  # Below code is similar, using rlang's curly curly operator to quote and unquote.
  # https://rlang.r-lib.org/reference/topic-data-mask.html
  # capture_it({{ x }})
}

capture_it(g(2) + 5)
wrapper(g(2) + 5)


z <- rlang::expr(y <- x * 10)
z
x <- 4
eval(z)
class(z)
typeof(z)
is.expression(z)
rlang::is_expression(z)


z <- expression(y <- x * 10)
class(z)
typeof(z)
is.expression(z)
rlang::is_expression(z)


lobstr::ast(f(x, "y", 1))
lobstr::ast(f(g(1, 2), h(3, 4, i())))


library(rlang)
x <- 1:10
z <- rlang::call2(median, x, na.rm = TRUE)
class(z)
typeof(z)

z <- rlang::expr(median)
class(z)
typeof(z)

rlang::call2(rlang::expr(median), x, na.rm = TRUE)
rlang::call2(median, expr(x), na.rm = TRUE)
rlang::call2(rlang::expr(median), expr(x), na.rm = TRUE)


g <- function(x) {
  x + 2
}
f <- function(x) {
  g(x)
}
g <- function(x) {
  x + 3
}

f(5)
body(f)
?body
rlang::is_expression(body(f))
environment(f)[["g"]]
eval(f(1), list("g" = function(x) {
  x
}))

f <- function(x) {
  g <- function(a) {
    3
  }
  print(environment(g))
}
f()

rlang::is_expression(pairlist(1, 2))
is.expression(pairlist(1, 2))
rlang::parse_exprs("pairlist(1, 2)")

f <- function(x, y) {
  return(x + 1)
}
