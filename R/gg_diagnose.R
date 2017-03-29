

#' Plot all diagnostic plots given fitted linear regression line.
#'
#' @param lm lm object that contains fitted regression
#' @param theme ggplot graphing style using `ggplot::theme()`. A ggplot graphing style to apply to all plots. Default to null.
#' @param ncol specify number of columns in resulting plot. Default to make a square matrix of the output.
#' @param plotAll logical; determine whether plot will be returned as
#' an arranged grid. When set to false, the function
#' will return a list of diagnostic plots. Parameter defaults to TRUE.
#' @param scale.factor numeric; scales the point size, linewidth, labels in all diagnostic plots to allow optimal viewing. Defaults to 0.5.
#' @param boxcox logical; detemine whether boxcox plot will be included. Parameter defaults to FALSE.
#' @return An arranged grid of linear model diagnostics plots in ggplot.
#' If plotall is set to FALSE, a list of ggplot objects will be returned instead.
#' Name of the plots are set to respective variable names.
#' @examples
#' library(MASS)
#' data(Cars93)
#' # a regression with categorical variable
#' cars_lm <- lm(Price ~ Passengers + Length + RPM + Origin, data = Cars93)
#' gg_diagnose(cars_lm
#' # customize which diagnostic plot is included
#' plots <- gg_diagnose(cars_lm, data = Cars93, plotAll = FALSE)
#' names(plots)     # get name of the plots
#' exclude_plots <- plots[-c(1, 3) ]    #exclude certain diagnostics plots
#' include_plots <- plots[c(1, 3)]      # include certain diagnostics plots
#' plot_all(exclude_plots)              # make use of plot_all() in lindia
#' plot_all(include_plots)
#' @export
gg_diagnose <- function(fitted.lm, theme = NULL, ncol = NULL, plotAll = TRUE, scale.factor = 0.5, boxcox = FALSE) {

   handle_exception(fitted.lm, "gg_diagnose")

   # compute total number of diagnostic plots
   n_plots = length(get_varnames(fitted.lm)[[1]])
   n_plots = n_plots + 7

   if (!boxcox) {
      n_plots = n_plots - 1
   }

   # compute the best dimension for resulting plot
   if (is.null(ncol)) {
      nCol = get_ncol(n_plots)
   }
   else {
      nCol = ncol
   }

   plots = list()
   # get all plots
   plots[["residual_hist"]] <- gg_reshist(fitted.lm)
   plots = append(plots, gg_resX(fitted.lm, plotAll = FALSE, scale.factor = scale.factor))
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

   if (plotAll) {
      return (do.call("grid.arrange", c(plots, ncol = nCol)))
   }
   else {
      return(plots)
   }

}
