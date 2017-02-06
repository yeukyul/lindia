

#' Plot all diagnostic plots given fitted linear regression line.
#'
#' @param lm lm object that contains fitted regression
#' @param theme A graphing style to apply to all plots. Default to null.
#' @param ncol specify number of columns in resulting plot. Default to make a square matrix of the output.
#' @param plotAll boolean value to determine whether plot will be return as 
#' a plot arranged using `grid.arrange()`. When set to false, the function
#' would return a list of diagnostic plots. Parameter defaults to TRUE.
#' @param exclude specify diagnostic plots to exclude, will plot all if both include and exclude are passed in.
#' @param include specify diagnostic plots to include, will plot all if both include and exclude are passed in.
#' @return A ggplot object that contains residual vs. leverage graph 
#' @examples gg_diagnose()
#' @export
gg_diagnose <- function(lm_object, theme = NULL, ncol = NULL, include = NULL, exclude = NULL, data = NULL, 
                        plotAll = TRUE) {
   
   handle_exception(lm_object, "gg_diagnose")
   
   # compute total number of diagnostic plots
   n_plots = length(get_varnames(lm_object)[[1]])
   n_plots = n_plots + 6
   
   # compute the best dimension for resulting plot
   if (!is.null(include)) {
      nCol = get_ncol(length(include))
      n_plot = length(include)
   }
   else if (!is.null(exclude)) {
      nCol = n_plot - length(exclude)
   }
   else if (is.null(ncol)) {
      nCol = get_ncol(n_plots)
   }
   else {
      nCol = ncol
   }
   
   plots = list()
   # get all plots
   # !!!! not implemented: should ignore plots that cannot be generated
   plots[["residual_hist"]] <- gg_reshist(lm_object)
   plots = append(plots, gg_resX(lm_object, data = data, plotAll = FALSE))
   plots[["res_fitted"]] <- gg_resfitted(lm_object)
   plots[["gg_qqplot"]] <- gg_qqplot(lm_object)
   plots[["gg_boxcox"]] <- gg_boxcox(lm_object)
   plots[["gg_scalelocation"]] <- gg_scalelocation(lm_object)
   plots[["gg_resleverage"]] <- gg_resleverage(lm_object)
   
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