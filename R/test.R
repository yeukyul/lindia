
# sample lm for testing lindia 
library(MASS)
data(Cars93)
cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)
cars_lm_2 <- lm(Rev.per.mile ~ Passengers + Length + RPM + Manufacturer, data = Cars93)
cars_lm_3 <- lm(Rev.per.mile ~ Passengers + Length + RPM + Manufacturer + Weight * Length, data = Cars93)
cars_lm_4 <- lm(Rev.per.mile ~ Passengers + Length + RPM + Manufacturer + Type + Make * Origin , data = Cars93)
