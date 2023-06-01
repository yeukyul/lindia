
#' Generate residual plot of residuals against fitted value
#'
#' @param fitted.lm a fitted linear model (i.e. lm, glm) that contains fitted regression
#' @param method smoothing method of fitted line on scale-location plot.
#'          eg. "lm", "glm", "gam", "loess", "rlm". See \url{http://docs.ggplot2.org/current/geom_smooth.html}
#'          for more details.
#' @param se logical; determines whether se belt should be plotted on plot
#' @param scale.factor numeric; scales the point size and linewidth to allow customized viewing. Defaults to 1.
#' @return A ggplot object
#' @examples library(MASS)
#' data(Cars93)
#' cars_lm <- lm(Price ~ Passengers + Length + RPM, data = Cars93)
#' gg_resfitted(cars_lm)
#'
#' @export
#'
gg_resfitted <- function(fitted.lm, method = 'loess', scale.factor = 1, se = FALSE) {

   handle_exception(fitted.lm, "gg_resfitted")

   #obtain residual and fitted values from fitted.lm
   res = residuals(fitted.lm)
   fitted_values = fitted(fitted.lm)

   # to center residual plot around y = 0 line
   limit = max(abs(res))
   margin_factor = 5
   margin = round(limit / margin_factor)

   df = data.frame(res, fitted_values)
   names(df) = c("residuals", "fitted_values")
   return (ggplot(data = df, aes(y = residuals, x = fitted_values)) +
              geom_point(size = scale.factor) +
              geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3", size = scale.factor)  +
              geom_smooth(method = method, se = se, size = scale.factor, color = "indianred3") +
              labs(y = "Residuals", x = "Fitted Values") +
              ylim(-(limit + margin), limit + margin) +
              ggtitle("Residual vs. Fitted Value"))
}
