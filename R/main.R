# reference: http://docs.ggplot2.org/dev/vignettes/extending-ggplot2.html

library(ggplot2)
library(roxygen2)
library(gridExtra)
library(MASS)


#' Generate histogram of residuals in ggplot.
#'
#' @param lm lm object that contains a fitted regression
#' @param bins bin size for histogram
#' @return A ggplot object
#' @examples gg_reshist()
#' 
#' @export
#' 
gg_reshist <- function(lm_object, bins = NULL) {
   
   handle_exception(lm_object, "gg_reshist")
   
   #obtain residual and fitted values from lm_object
   res = data.frame(residuals(lm_object))
   
   if (is.null(bins)) {
      return (ggplot(data = res, aes(x = res)) + geom_histogram(color = "white") +
                 ggtitle("Histogram of Residuals") + 
                 labs(x = "residuals"))
   }
   else {
      return (ggplot(data = res, aes(x = res)) + geom_histogram(color = "white", bins = bins) +
                 ggtitle("Histogram of Residuals") +
                 labs(x = "residuals"))
   }
   
}


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
   
   df = data.frame(res, fitted_values)
   names(df) = c("residuals", "fitted_values")
   return (ggplot(data = df, aes(y = residuals, x = fitted_values)) + geom_point())
}

# only works for continuous variables
# Exceptions:
#        (1) lm object contains categorical variables
#        (2) input not lm object

#' Generate residual plot of residuals against predictors
#'
#' @param lm_object lm object that contains fitted regression
#' @param select vector represents all variables that wanted ot be included
#' in output. Default to all variables.
#' @return A list of ggplot objects that contains residual plot
#' of residuals against predictor values
#' @examples gg_resX()
#' 
#' @export
gg_resX <- function(lm_object, select = NULL){
   
   handle_exception(lm_object, "gg_resX")
   
   # extract model matrix
   model_matrix = model.matrix(lm_object)
   
   # extract relevant explanatory variables in model matrix
   var_names = colnames(model_matrix)[-1]
   dim = length(var_names)
   
   # create a list to hold all residual plots
   plots = vector("list", dim)
   
   for (i in 1:dim){
      var = var_names[i]
      plots[[i]] <- get_resplot(var, model_matrix, lm_object)
   }
   
   # rename plots in the array
   names(plots) = var_names
   
   plots
}

#
# get_resplot returns a ggplot object of residuals in lm_object against var in model_matrix
#
get_resplot <- function(var, model_matrix, lm_object){
   
   # handle categorical and continuous variables
   x = model_matrix[, var]
   base_plot = ggplot(data = lm_object, aes(x = model_matrix[, var], y = lm_object$residuals)) + 
                  labs(x = var, y = "residuals") + 
                  ggtitle(paste("Residual Plot of", var))
   
   #if (is.numeric(x)) {
   return (base_plot + 
              geom_point() +
              geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3"))
   #}
   #else {
   #   return (base_plot + geom_boxplot())
   #}
}


#
# get_resplot returns a ggplot object of scatterplot of interaction terms 
get_interplot <- function(model_matrix, interactions) {
   # !!!! multi dimensional interacton plot?
   if (length(interactions) > 2) {
      stop("lindia doesn't know how to handle interaction terms with dimension greater than 2")
   }
   
   return (ggplot(data = model_matrix, aes(x = interaction[1], y = interaction[2])) +
              ggtitle(paste("Interaction between", interaction[1], "and", interaction[2])))
}


#' Plot quantile-quantile plot (QQPlot) in ggplot with qqline shown.
#'
#' @param lm lm object that contains regression
#' @return A qqplot with fitted qqline
#' @examples gg_qqplot*()
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


#' Plot boxcox graph in ggplot with suggested lambda transformation and 95% confidence level.
#'
#' @param lm lm object that contains fitted regression
#' @param showlambda logical which controls whether lambda value should be displayed on graph. Defaults to TRUE
#' @param lambdaSF controls to how many significant figure is lambda rounded to. Defaults to 3.
#' @return A ggplot object that contains boxcox graph 
#' @examples gg_boxcox()
#' @export
gg_boxcox <- function(lm_object, showlambda = TRUE, lambdaSF = 3){
   
   handle_exception(lm_object, "gg_boxcox")
   
   # compute boxcox graph points
   boxcox_object <- boxcox(lm_object, plotit = FALSE)
   
   # create new dataframe to hold all x and y points
   x <- unlist(boxcox_object$x)
   y <- unlist(boxcox_object$y)
   
   # compute start and end of each line segment
   xstart <- x[-1]
   ystart <- y[-1]
   xend <- x[-(length(x))]
   yend <- y[-(length(y))]
   boxcox_unlist <- data.frame(xstart, ystart, xend, yend)
   
   # obtain best lamda
   best_lambda <- x[which.max(y)]
   rounded_lambda <- round(best_lambda, lambda_sf)
   min_y <- min(y)
   
   # compute accepted range of lambda transformation 
   accept_range <- x[y > max(y) - 1/2 * qchisq(.95,1)]
   conf_lo <- round(min(accept_range), lambda_sf)
   conf_hi <- round(max(accept_range), lambda_sf)
   
   plot <- ggplot(data = boxcox_unlist) + 
      geom_segment(aes(x = xstart, y = ystart, xend = xend, yend = yend)) +
      labs(x = "lambda", y = "log-likelihood") +
      ggtitle("Boxcox Plot") + 
      geom_vline(xintercept = best_lambda, linetype = "dotted") + 
      geom_vline(xintercept = conf_lo, linetype = "dotted") + 
      geom_vline(xintercept = conf_hi, linetype = "dotted")
   
   # add label if show lambda range
   if (showLambda) {
      return(plot +  
                geom_text(aes(x = best_lambda, label = as.character(rounded_lambda), y = min_y), color = "indianred3") +
                geom_text(aes(x = conf_lo, label = as.character(conf_lo), y = min_y)) +
                geom_text(aes(x = conf_hi, label = as.character(conf_hi), y = min_y)))
   }
   else {
      return (plot)
   }
}

#' Plot scale-location (also called spread-location plot) in ggplot. 
#'
#' @param lm lm object that contains fitted regression
#' @param method smoothing method of fitted line on scale-location plot. 
#'          eg. "lm", "glm", "gam", "loess", "rlm". See \url{http://docs.ggplot2.org/current/geom_smooth.html}
#'          for more details.
#' @return A ggplot object that contains scale-location graph 
#' @examples gg_scalelocation()
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

#' Plot all diagnostic plots given fitted linear regression line.
#'
#' @param lm lm object that contains fitted regression
#' @param theme A graphing style to apply to all plots. Default to null.
#' @param ncol specify number of columns in resulting plot. Default to make a square matrix of the output.
#' @return A ggplot object that contains residual vs. leverage graph 
#' @examples gg_diagnose()
#' @export
gg_diagnose <- function(lm_object, theme = NULL, ncol = NULL) {
   
   handle_exception(lm_object, "gg_diagnose")
   
   # compute total number of diagnostic plots
   n_plots = cols(model.matrix(lm_object)) - 1
   n_plot = n_plot + 5
   
   # compute the best dimension for resulting plot
   if (is.null(ncol)) {
      nCol = max(floor(sqrt(n_plots)), 1)
   }
   else {
      nCol = ncol
   }
   
   # get all plots
   # !!!! not implemented: should ignore plots that cannot be generated
   plots[["residual_hist"]] <- gg_reshist(lm_object)
   plots[["res_fitted"]] <- gg_resfitted(lm_object)
   plots[["res_X"]] <- gg_resX(lm_object)
   plots[["gg_qqplot"]] <- gg_qqplot(lm_object)
   plots[["gg_boxcox"]] <- gg_boxcox(lm_object)
   plots[["gg_scalelocation"]] <- gg_scalelocation(lm_object)
   plots[["gg_resleverage"]] <- gg_resleverage(lm_object)
   
   return (do.call("grid.arrange", c(plots, ncol = nCol)))
   
}

#'Return all variables names in a given lm object
#'
#'@export 
get_varnames <- function(lm_object) {
   
   lm_formula = as.character(formula(lm_object))
   var_names_list = strsplit(lm_formula, ' ~ ')
   var_name_vec = strsplit_vec(lm_formula, ' ~ ')
   
   # drop response variable
   args_str = var_name_vec
   
   # parse args in lm
   args = unlist(strsplit_vec(args_str, " \\+ "))
   n_args = length(args)
   predictors = c()
   interaction = list()
   
   # count how many interaction terms there are
   # used for storing variables in return list
   n_inter = 1
   
   # find interaction terms
   for (i in 1:n_args) {
      term = args[i]
      
      # check if it is interaction term
      # !! caution: check if it works with multiple interaction
      if (grepl(' \\* ', term)) {
         inter_terms = unlist(strsplit(term, " \\* "))
         predictors = c(predictors, inter_terms)
         interaction[[n_inter]] = inter_terms
         n_inter = n_inter + 1
      }
      else {
         predictors = c(predictors, term)
      }
   }
   
   # clean up duplicated predictors from extracting from interaction terms
   predictors = unique(predictors)
   
   return (list(predictors = predictors, interactions = interaction))
}

# returns a vector as a result of string splitting
strsplit_vec <- function(str, split) {
   return (unlist(strsplit(str, split))[-1])
}

#
# exception handling function for malformed input in lndia
#
handle_exception <- function(input, function_name){
   
   # exception handling : input not lm object
   if (class(input) != "lm"){
      stop(paste(function_name, "doesn't know how to handle non-lm object"))
   }
   
}


