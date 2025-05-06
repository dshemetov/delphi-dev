# pak::pkg_install("sloop")
library(sloop)


time <- strptime(c("2017-01-01", "2020-05-04 03:21"), "%Y-%m-%d")

str(time)
s3_dispatch(str(time))
str

typeof(time)
unclass(time)

s3_get_method(str.POSIXt)

s3_methods_generic("as.data.frame")
