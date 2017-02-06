

#' Generate histogram of residuals in ggplot.
#'
#' @param lm lm object that contains a fitted regression
#' @param bins bin size for histogram
#' @return A ggplot object
#' @examples gg_reshist()
#' 
#' @export
#' 
gg_reshist <- function(lm_object, bins = NULL) {
   
   handle_exception(lm_object, "gg_reshist")
   
   #obtain residual and fitted values from lm_object
   res = data.frame(residuals(lm_object))
   
   if (is.null(bins)) {
      return (ggplot(data = res, aes(x = res)) + geom_histogram(color = "white") +
                 ggtitle("Histogram of Residuals") + 
                 labs(x = "residuals"))
   }
   else {
      return (ggplot(data = res, aes(x = res)) + geom_histogram(color = "white", bins = bins) +
                 ggtitle("Histogram of Residuals") +
                 labs(x = "residuals"))
   }
   
}