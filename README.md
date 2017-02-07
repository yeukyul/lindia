lindia
======

lindia is an extention to ***ggplot2*** to provide a streamlined plotting feature of linear diagnostic plots. The following demonstrates basic plotting features of `lindia`. All functions in `lindia` takes in lm object and return linear diagnostic plots in types of `ggplot`.

``` r
library(MASS)
library(ggplot2)
library(lindia)
data(Cars93)
cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)
gg_diagnose(cars_lm)
```

![](figures/README-unnamed-chunk-2-1.png)

All themes in `lindia` plots can be overwritten by a call to `ggplot::theme()`.

``` r
gg_reshist(cars_lm) + theme_bw()
```

![](figures/README-unnamed-chunk-3-1.png)

Please note that `lindia` does not provide ***all*** diagnostic plots necessary for checking linear model assumptions. Refer to ggpairs to check if multicolinearity assumption has been violated.

Overview
========

Followed are functions implemented in `lindia`:

-   `gg_reshist()`: plotting the histogram of distribution of residuals
-   `gg_resfitted()`: residual plot of residuals by fitted value
-   `gg_resX()`: a list of residual plots of all predictors by fitted value (continuous variables only for now. Categorical and interaction terms are developing.)
-   `gg_qqplot()`: Normaility quantile-quantile plot (QQPlot) with qqline overlayed on top
-   `gg_boxcox()`: boxcox graph with optimal transformation labeled on graph
-   `gg_scalelocation()`: scale-location plot (also called spread-location plot).
-   `gg_resleverage()`: residual vs. leverage plot. (cook distance indicators not implemented for now)
-   `gg_diagnose()`: all diagnostic plots being layed out on a grid (not functional yet).

`gg_resX()` and `gg_diagnose()` would return multiple plots after a call to the function. By default, they would return one aggregate plot of all diagnostic plots as one arranged grid. If user, however, needs more flexibility in determining graphical elements and inclusion of certain plot, set `plotAll` parameter in the function call to `FALSE`. It will return a list of all plots, which user can manipulate.

In addition, `lindia` provides a `plotAll()` feature that allows users pass in a list of plots and output as a formatted grid of plots using `grid.arrange()` in `gridExtra`.

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

### gg\_boxocx

Plots boxcox graph of given lm object, with labels showing optimal transforming power. Can hide labels by setting `showlambda` to `FALSE`.

``` r
gg_boxcox(cars_lm)
```

![](figures/README-unnamed-chunk-7-1.png)

Package Dependency
==================

Lindia is built on top of the following few packages:

-   `ggplot2`

-   `gridExtra`

How to Install
==============

-   From Github: `devtools::install_github("yeukyul/lindia")`
