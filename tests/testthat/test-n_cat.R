

context("Test n_cat\n")

test_that("Testing n_cat()", {
   data(Cars93)
   
   cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)
   cars_lm_2 <- lm(Rev.per.mile ~ Passengers + Length + RPM + Manufacturer, data = Cars93)
   cars_lm_3 <- lm(Rev.per.mile ~ Passengers + Length + RPM + Manufacturer + Weight * Length, data = Cars93)
   
   mm1 <- model.matrix(cars_lm)
   mm2 <- model.matrix(cars_lm_2)
   mm3 <- model.matrix(cars_lm_3)
   
   
   expect_equal(n_cat(varnames1, mm1), 0)
   expect_equal(n_cat(varnames2, mm2), 1)
   expect_equal(n_cat(varnames3, mm3), 2)
})