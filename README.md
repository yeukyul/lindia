lindia
======

lindia is an extention to ***ggplot2*** to allow easy plotting of linear diagnostic plots. The following demonstrates basic plotting features of `lindia`. All functions in `lindia` takes in lm object and return linear diagnostic plots in types of `ggplot`.

``` r
library(MASS)
library(ggplot2)
library(lindia)
data(Cars93)
cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)
gg_resfitted(cars_lm)
```

![](figures/README-unnamed-chunk-2-1.png)

All themes in `lindia` plots can be overwritten by a call to `ggplot::theme()`.

``` r
gg_reshist(cars_lm) + theme_bw()
```

![](figures/README-unnamed-chunk-3-1.png)

Functions in Lindia
===================

### gg\_reshist

Plot distribution of residuals in histograms. Number of bins picked by default.

``` r
gg_reshist(cars_lm)
```

![](figures/README-unnamed-chunk-4-1.png)

Can also specify number of bins using `bins` argument:

``` r
gg_reshist(cars_lm, bins = 20)
```

![](figures/README-unnamed-chunk-5-1.png)

### gg\_resfitted

Plots residual against fitted value.

``` r
gg_resfitted(cars_lm)
```

![](figures/README-unnamed-chunk-6-1.png)

How to Install
==============

-   From Github: `devtools::install_github("yeukyul/lindia")`
