

#' Plot residual versus leverage plot in ggplot. 
#'
#' @param lm lm object that contains fitted regression
#' @param method smoothing method of fitted line on scale-location plot. 
#'          eg. "lm", "glm", "gam", "loess", "rlm". See \url{http://docs.ggplot2.org/current/geom_smooth.html}
#'          for more details.
#' @return A ggplot object that contains residual vs. leverage graph 
#' @examples gg_resleverage()
#' @export
gg_resleverage <- function(lm_object, method = "loess") {
   
   handle_exception(lm_object, "gg_resleverage")
   
   #obtain stardardized residual and fitted values from lm_object
   std_res = rstandard(lm_object)
   leverage = hatvalues(lm_object)
   
   df = data.frame(leverage, std_res)
   names(df) = c("leverage", "std_res")
   return (ggplot(data = df, aes(x = leverage, y = std_res)) + 
              geom_point() +
              geom_smooth(method = method, se = FALSE) + 
              ggtitle("Residual vs. Leverage"))
   
}