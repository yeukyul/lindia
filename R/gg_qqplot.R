

#' Plot quantile-quantile plot (QQPlot) in ggplot with qqline shown.
#'
#' @param lm lm object that contains regression
#' @return A qqplot with fitted qqline
#' @examples gg_qqplot()
#' @export
gg_qqplot <- function(lm_object){
   
   handle_exception(lm_object, "gg_qqplot")
   
   # extract residuals from lm object
   res = residuals(lm_object)
   
   # calculate slope and interncept for qqline
   slope = (quantile(res, .75) - quantile(res, .25)) / (qnorm(.75) - qnorm(.25)) 
   intercept = quantile(res,.25) - slope*qnorm(.25) 
   qq_line = data.frame(intercept = intercept, slope = slope) 
   
   # generate ggplot for qqplot
   qq_plot <- ggplot(data = lm_object) + 
      stat_qq(aes(sample = res)) + 
      labs(x = "theoractical_quantile", y = "standardized_residual") +
      geom_abline(data = qq_line ,aes(intercept = intercept ,slope = slope), color = "indianred3") +
      ggtitle("Normal-QQ Plot")
   qq_plot
}