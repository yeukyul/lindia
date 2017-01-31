

library(MASS)
data(Cars93)
cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)

gg_resfitted(cars_lm)
