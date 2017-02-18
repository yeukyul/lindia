

#' Plot residual versus leverage plot in ggplot. 
#'
#' @param fitted.lm a fitted linear model (i.e. lm, glm) that contains fitted regression
#' @param method smoothing method of fitted line on scale-location plot. 
#'          eg. "lm", "glm", "gam", "loess", "rlm". See \url{http://docs.ggplot2.org/current/geom_smooth.html}
#'          for more details.
#' @return A ggplot object that contains residual vs. leverage graph 
#' @examples library(MASS)
#' data(Cars93)
#' cars_lm <- lm(Price ~ Passengers + Length + RPM, data = Cars93)
#' gg_resleverage(cars_lm)
#' @export
gg_resleverage <- function(fitted.lm, method = "loess") {
   
   handle_exception(fitted.lm, "gg_resleverage")
   
   #obtain stardardized residual and fitted values from fitted.lm
   std_res = rstandard(fitted.lm)
   leverage = hatvalues(fitted.lm)
   
   df = data.frame(leverage, std_res)
   names(df) = c("leverage", "std_res")
   return (ggplot(data = df, aes(x = leverage, y = std_res)) + 
              geom_point() +
              geom_smooth(method = method, se = FALSE) + 
              ggtitle("Residual vs. Leverage"))
   
}