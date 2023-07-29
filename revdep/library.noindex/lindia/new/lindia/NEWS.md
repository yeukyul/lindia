# lindia 0.10

## Breaking changes

* `gg_boxcox()` now renders spline interpolation by default. If you want to turn it off, update settings for boxcox graph or use `packageVersion("lindia") = "0.9"`.

## New features

* New `mode` param to `gg_diagnose()` to render predetermine set of graphs (`all` or `base_r`) (@Sid1204, #8)

* Added spline interpolation to `gg_boxcox()` (@ColeConte, #5)


## Minor improvements and fixes

* `gg_scalelocation` now has correct labels on x and y axis (previously flipped) (@Sid1204, #8)


* Fixed error when `lm` object only has one predictor term (@yeukyul)

