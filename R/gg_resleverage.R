

#' Plot residual versus leverage plot in ggplot.
#'
#' @param fitted.lm a fitted linear model (i.e. lm, glm) that contains fitted regression
#' @param method smoothing method of fitted line on scale-location plot.
#'          eg. "lm", "glm", "gam", "loess", "rlm". See \url{http://docs.ggplot2.org/current/geom_smooth.html}
#'          for more details.
#' @param se logical; determines whether se belt should be plotted on plot
#' @param scale.factor numeric; scales the point size and linewidth to allow customized viewing. Defaults to 0.5.
#' @return A ggplot object that contains residual vs. leverage graph
#' @examples library(MASS)
#' data(Cars93)
#' cars_lm <- lm(Price ~ Passengers + Length + RPM, data = Cars93)
#' gg_resleverage(cars_lm)
#' @export
#'
gg_resleverage <- function(fitted.lm, method = "loess", se = FALSE, scale.factor = 0.5) {

   handle_exception(fitted.lm, "gg_resleverage")

   #obtain stardardized residual and fitted values from fitted.lm
   std_res = rstandard(fitted.lm)
   leverage = hatvalues(fitted.lm)

   df = data.frame(leverage, std_res)
   names(df) = c("leverage", "std_res")
   return (ggplot(data = df, aes(x = leverage, y = std_res)) +
              geom_point(size = scale.factor) +
              geom_smooth(method = method, se = se, color = "indianred3", size = scale.factor) +
              ggtitle("Residual vs. Leverage") +
              labs(y = "standardized residuals"))

}
