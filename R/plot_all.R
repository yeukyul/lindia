#' Plot all given plots in a square matrix form.
#'
#' @param plots a list of plots
#' @param ncol numeric; the number of column that the arranged grid need to be.
#'              defaults to fitting all plots in square matrix
#' @param max.per.page numeric; maximum number of plots allowed in one page.
#' 
#' @return plots in a given list arrangeed using gridExtra
#' @examples 
#'          library(MASS)
#'          data(Cars93)
#'          # a regression with categorical variable
#'          cars_lm <- lm(Price ~ Passengers + Length + RPM + Origin, data = Cars93)
#'          plots <- gg_diagnose(cars_lm, plotAll = FALSE)
#'          names(plots)
#'          selected.plots <- plots[-c(2, 5)]
#'          plot_all(selected.plots)
#'          
#' @export
plot_all <- function(plots, ncol = NA, max.per.page = NA) {
   
   if (class(plots) != "list") {
      stop("plot_all() doesn't know how to handle non-list input")
   }
   
   if (is.na(ncol)) {
      ncol = get_ncol(length(plots))
   }

   # handle malformed max.per.page request 
   if (is.na(max.per.page)) {
      max.per.page = length(plots)
   } else if (class(max.per.page) != "numeric" || max.per.page < 1) {
      message("Maximum plots per page invalid; switch to default")
      max.per.page = length(plots)
   }
   
   return(arrange.plots(plots, max.per.page, ncol))
}