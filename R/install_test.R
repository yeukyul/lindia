

# install package
devtools::install_github(repo = "yeukyul/lindia")
library(lindia)

# sample lm object
cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)

# testing functions created
lindia::gg_resfitted(cars_lm)
res_plots <- gg_resX
lindia::gg_qqplot(cars_lm)
