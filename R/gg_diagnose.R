
#' Plot all diagnostic plots given fitted linear regression line.
#'
#' @param fitted.lm lm object that contains fitted regression
#' @param theme ggplot graphing style using `ggplot::theme()`. A ggplot graphing style to apply to all plots. Default to null.
#' @param ncol specify number of columns in resulting plot per page. Default to make a square matrix of the output.
#' @param plot.all logical; determine whether plot will be returned as
#' an arranged grid. When set to false, the function
#' will return a list of diagnostic plots. Parameter defaults to TRUE.
#' @param mode A string. Specifies which set of diagnostic plots to return:
#'   * `all` (the default)
#'   * `base_r`: only graphs included in the base R `plot(lm(...))` (i.e. residual vs fitted, QQ plot, scale location, residual vs leverage)
#' @param scale.factor numeric; scales the point size, linewidth, labels in all diagnostic plots to allow optimal viewing. Defaults to 0.5.
#' @param boxcox logical; detemine whether boxcox plot will be included. Parameter defaults to FALSE.
#' @param max.per.page numeric; maximum number of plots allowed in one page.
#' @return An arranged grid of linear model diagnostics plots in ggplot.
#' If plot.all is set to FALSE, a list of ggplot objects will be returned instead.
#' Name of the plots are set to respective variable names.
#' @examples
#' library(MASS)
#' data(Cars93)
#' # a regression with categorical variable
#' cars_lm <- lm(Price ~ Passengers + Length + RPM + Origin, data = Cars93)
#' gg_diagnose(cars_lm)
#' # customize which diagnostic plot is included
#' plots <- gg_diagnose(cars_lm, plot.all = FALSE)
#' names(plots)     # get name of the plots
#' exclude_plots <- plots[-c(1, 3) ]    #exclude certain diagnostics plots
#' include_plots <- plots[c(1, 3)]      # include certain diagnostics plots
#' plot_all(exclude_plots)              # make use of plot_all() in lindia
#' plot_all(include_plots)
#' @export
#' @import ggplot2
#' @importFrom gridExtra grid.arrange
#' @importFrom stats fitted formula hatvalues qchisq qnorm quantile residuals rstandard
gg_diagnose <- function(fitted.lm, theme = NULL, ncol = NA, plot.all = TRUE, mode = "all",
                        scale.factor = 0.5, boxcox = FALSE, max.per.page = NA) 
   {

   handle_exception(fitted.lm, "gg_diagnose")
  
   if(!(plot.all %in% c(TRUE, FALSE, "base_r"))) {
     plot.all = TRUE
     message("`plot.all` defaulting to TRUE: incorrect value supplied in function call.")
   }

   plots = list()
   # get all plots
   plots[["residual_hist"]] <- gg_reshist(fitted.lm)
   plots = append(plots, gg_resX(fitted.lm, plot.all = FALSE, scale.factor = scale.factor))
   plots[["res_fitted"]] <- gg_resfitted(fitted.lm, scale.factor = scale.factor)
   plots[["qqplot"]] <- gg_qqplot(fitted.lm, scale.factor = scale.factor)
   plots[["scalelocation"]] <- gg_scalelocation(fitted.lm, scale.factor = scale.factor)
   plots[["resleverage"]] <- gg_resleverage(fitted.lm, scale.factor = scale.factor)
   plots[["cooksd"]] <- gg_cooksd(fitted.lm, scale.factor = scale.factor)
   if (boxcox) {
      plots[["boxcox"]] <- gg_boxcox(fitted.lm, scale.factor = scale.factor)
   }

   # apply style to all the plots
   if (!(is.null(theme))) {
      plots = lapply(plots, function(plot) { plot + theme })
   }
   
   # handle malformed max.per.page request 
   if (is.na(max.per.page)) {
      max.per.page = length(plots)
   } else if ((!inherits(max.per.page, "numeric")) || max.per.page < 1) {
      message("Maximum plots per page invalid; switch to default")
      max.per.page = length(plots)
   }
   
   if (mode == "base_r") {
     plots = plots[c("res_fitted","qqplot","scalelocation","resleverage")]
   } else if (mode != "all") {
     message("`mode` has invalid value, using 'all'")
   }
  
   # determine to plot the plots, or return a list of plots
   if (plot.all == TRUE) {
     return(arrange.plots(plots, max.per.page, ncol))
   } else {
     return (plots)
   }

}
