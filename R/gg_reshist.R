

#' Generate histogram of residuals in ggplot.
#'
#' @param lm lm object that contains a fitted regression
#' @param bins bin size for histogram
#' @return A ggplot object
#' @examples
#' library(MASS)
#' data(Cars93)
#' cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)
#' gg_reshist(cars_lm)
#' # specify number of bins
#' gg_reshist(cars_lm. bins = 20)
#' @export
#' 
gg_reshist <- function(lm_object, bins = NULL) {
   
   handle_exception(lm_object, "gg_reshist")
   
   #obtain residual and fitted values from lm_object
   res = data.frame(residuals = residuals(lm_object))
   
   if (is.null(bins)) {
      return (ggplot(data = res, aes(x = residuals)) + geom_histogram(color = "white") +
                 ggtitle("Histogram of Residuals") + 
                 labs(x = "residuals"))
   }
   else {
      return (ggplot(data = res, aes(x = residuals)) + geom_histogram(color = "white", bins = bins) +
                 ggtitle("Histogram of Residuals") +
                 labs(x = "residuals"))
   }
   
}