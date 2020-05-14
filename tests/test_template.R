
try1 <- try(1==1,silent = TRUE)

test_that("no error in testing ...", {
  
  expect_false(inherits(try1, "try-error"))
  
})