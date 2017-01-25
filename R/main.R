# reference: http://docs.ggplot2.org/dev/vignettes/extending-ggplot2.html

library(ggplot2)
library(roxygen2)

#' Generate residual plot of residuals against fitted value
#'
#' @param lm lm object that contains regression
#' @return A ggplot object
#' @examples
#' 
gg_resfitted <- function(lm_object){
      # exception handling : input not lm object
   
      #obtain residual and fitted values from lm_object
      res = residuals(lm_object)
      fitted_values = fitted(lm_object)
      
      df = data.frame(res, fitted_values)
      names(df) = c("residuals", "fitted_values")
      return (ggplot(data = df, aes(x = residuals, y = fitted_values)) + geom_point())
}

# only works for continuous variables
# Exceptions:
#        (1) lm object contains categorical variables
#        (2) input not lm object

#' Generate residual plot of residuals against predictors
#'
#' @param lm_object lm object that contains fitted regression
#' @return A list of ggplot objects that contains residual plot
#' of residuals against predictor values
#' @examples
#' 
gg_resX <- function(lm_object){

   # extract model matrix
   model_matrix = model.matrix(lm_object)
   
   # extract relevant explanatory variables in model matrix
   var_names = colnames(model_matrix)[-1]
   dim = length(var_names)
   
   # create a list to hold all residual plots
   plots = vector("list", dim)
   for (i in 1:dim){
      var = var_names[i]
      this_plot = ggplot(data = lm_object, aes(x = model_matrix[, var], y = lm_object$residuals)) + 
                        geom_point() + 
                        labs(x = var, y = "residuals") +
                        geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3")
      plots[[i]] = this_plot
   }
   
   # rename plots in the array
   names(plots) = var_names
   
   plots
}

#' Generates QQPlot
#'
#' @param lm lm object that contains regression
#' @return A qqplot with fitted qqline
#' @examples
#' 
gg_qqplot <- function(lm_object){
   
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
                  geom_abline(data = qq_line ,aes(intercept = intercept ,slope = slope), color = "indianred3")
   qq_plot
}
