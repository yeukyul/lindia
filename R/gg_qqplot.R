

#' Plot quantile-quantile plot (QQPlot) in ggplot with qqline shown.
#'
#' @param fitted.lm a fitted linear model (i.e. lm, glm) that contains fitted regression
#' @param scale.factor numeric; scales the point size and linewidth to allow customized viewing. Defaults to 0.5.
#' @return A qqplot with fitted qqline
#' @examples library(MASS)
#' data(Cars93)
#' cars_lm <- lm(Price ~ Passengers + Length + RPM, data = Cars93)
#' gg_qqplot(cars_lm)
#' @export
gg_qqplot <- function(fitted.lm, scale.factor = 0.5){

   handle_exception(fitted.lm, "gg_qqplot")

   # extract residuals from lm object
   res = residuals(fitted.lm)

   # calculate slope and interncept for qqline
   slope = (quantile(res, .75) - quantile(res, .25)) / (qnorm(.75) - qnorm(.25))
   intercept = quantile(res,.25) - slope*qnorm(.25)
   qq_line = data.frame(intercept = intercept, slope = slope)

   # generate ggplot for qqplot
   qq_plot <- ggplot(data = fitted.lm) +
      stat_qq(aes(sample = res), size = scale.factor) +
      labs(x = "theoretical_quantile", y = "standardized_residual") +
      geom_abline(data = qq_line ,aes(intercept = intercept ,slope = slope), color = "indianred3", size = scale.factor) +
      ggtitle("Normal-QQ Plot")
   qq_plot
}
