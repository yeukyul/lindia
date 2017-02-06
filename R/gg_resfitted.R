
#' Generate residual plot of residuals against fitted value
#'
#' @param lm lm object that contains a fitted regression
#' @return A ggplot object
#' @examples gg_resfitted()
#' 
#' @export
#' 
gg_resfitted <- function(lm_object) {
   
   handle_exception(lm_object, "gg_resfitted")
   
   #obtain residual and fitted values from lm_object
   res = residuals(lm_object)
   fitted_values = fitted(lm_object)
   
   # to center residual plot around y = 0 line
   limit = max(abs(res))
   margin_factor = 5
   margin = round(limit / margin_factor)
   
   df = data.frame(res, fitted_values)
   names(df) = c("residuals", "fitted_values")
   return (ggplot(data = df, aes(y = residuals, x = fitted_values)) + 
              geom_point() +
              geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3")  +
              ylim(-(limit + margin), limit + margin) + 
              ggtitle("Residual vs. Fitted Value")) 
}