lindia
======

lindia is an extention to ***ggplot2*** to allow easy plotting of linear diagnostic plots:

``` r
library(MASS)
data(Cars93)
cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)
```

------------------------------------------------------------------------
