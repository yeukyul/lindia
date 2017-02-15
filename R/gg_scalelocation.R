
#' Plot scale-location (also called spread-location plot) in ggplot. 
#'
#' @param lm lm object that contains fitted regression
#' @param method smoothing method of fitted line on scale-location plot. 
#'          eg. "lm", "glm", "gam", "loess", "rlm". See \url{http://docs.ggplot2.org/current/geom_smooth.html}
#'          for more details.
#' @return A ggplot object that contains scale-location graph 
#' @examples library(MASS)
#' data(Cars93)
#' cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)
#' gg_scalelocation(cars_lm)
#' @export
gg_scalelocation <- function(lm_object, method = 'loess') {
   
   handle_exception(lm_object, "gg_scalelocation")
   
   #obtain stardardized residual and fitted values from lm_object
   fitted_values = fitted(lm_object)
   std_res = rstandard(lm_object)
   
   df = data.frame(std_res, fitted_values)
   names(df) = c("sqrt(std_res)", "fitted_values")
   return (ggplot(data = df, aes(y = std_res, x = fitted_values)) + 
              geom_point() +
              geom_smooth(method = method, se = FALSE) +
              ggtitle("Scale-Location Plot"))
}