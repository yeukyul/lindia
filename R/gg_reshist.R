

#' Generate histogram of residuals in ggplot.
#'
#' @param fitted.lm a fitted linear model (i.e. lm, glm) that contains fitted regression
#' @param bins bin size for histogram
#' @return A ggplot object
#' @examples
#' library(MASS)
#' data(Cars93)
#' cars_lm <- lm(Price~ Passengers + Length + RPM, data = Cars93)
#' gg_reshist(cars_lm)
#' # specify number of bins
#' gg_reshist(cars_lm, bins = 20)
#' @export
#'
gg_reshist <- function(fitted.lm, bins = NULL) {

   handle_exception(fitted.lm, "gg_reshist")

   #obtain residual and fitted values from fitted.lm
   res = data.frame(residuals = rstandard(fitted.lm))

   ggplot(data = res, aes(x = residuals)) +
      geom_histogram(
         mapping = aes(y = ..density..),
         position = "stack",
         color = "black",
         fill = "white",
         bins = bins
      ) +
      stat_function(fun = dnorm, color = "blue") +
      labs(
         title = "Histogram of Residuals",
         x = "Standardized Residuals",
         y = "Density"
      )
}
