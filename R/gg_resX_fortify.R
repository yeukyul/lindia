
#' Generate residual plot of residuals against predictors
#'
#' @param lm_object a fitted linear model (i.e. lm, glm) that contains fitted regression
#' @param data original dataset
#' @param plotAll boolean value to determine whether plot will be return as 
#' a plot arranged using `grid.arrange()`. When set to false, the function
#' would return a list of residual plots. Parameter defaults to TRUE.
#' @return A list of ggplot objects that contains residual plot
#' of residuals against predictor values
#' @examples gg_resX()
#' library(MASS)
#' data(Cars93)
#' # a regression with categorical variable
#' cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM + Origin, data = Cars93)
#' gg_resX(cars_lm, data = Cars93)
#' # customize which diagnostic plot is included by have gg_resX to return a list of plots
#' plots <- gg_resX(cars_lm, data = Cars93, plotAll = FALSE)
#' names(plots)     # get name of the plots
#' exclude_plots <- plots[-1 ]    #exclude certain residual plots
#' include_plots <- plots[1]      # include certain residual plots
#' plot_all(exclude_plots)              # make use of plot_all() in lindia
#' plot_all(include_plots)
#' @export
gg_resX <- function(lm_object, plotAll = TRUE){
   
   handle_exception(lm_object, "gg_resX")
   
   # extract model matrix
   lm_matrix = fortify(lm_object)
   
   # extract relevant explanatory variables in model matrix
   var_names = get_varnames(lm_object)$predictor
   dim = length(var_names)
   
   # create a list to hold all residual plots
   plots = vector("list", dim)
   
   # number of plots so far
   n = 1
   
   for (i in 1:length(var_names)){
      var = var_names[i]
      this_plot <- get_resplot(var, lm_matrix, lm_object)
      if (!is.null(this_plot)) {
         plots[[n]] <- this_plot
         n = n + 1
      }
      
   }
   
   names(plots) = var_names
   
   
   if (plotAll) {
      nCol = get_ncol(dim)
      return (do.call("grid.arrange", c(plots, ncol = nCol)))
   }
   else {
      return (plots)
   }
   
}


#
# get_resplot - returns a ggplot object of residuals in lm_object against var in lm_matrix
#
# input : var - variable name string the residual plot is about
#         lm_matrix - model matrix of the fitted lm
#        lm_object : fitted lm
#        data : original dataset (optional)
#
# output : a ggplot object of var vs. residual of fitted lm
#
get_resplot <- function(var, lm_matrix, lm_object){
   
   # to center residual plot around y = 0 line
   res = residuals(lm_object)
   limit = max(abs(res))
   margin_factor = 5
   margin = round(limit / margin_factor)
   
   n_var_threshold = 4    # if more number of variables than threshold, tilt label to 45 degrees
   
   # handle categorical and continuous variables
   x = lm_matrix[, var]
   
   # handle numeric variable
   if (is.numeric(x)) {
      return (ggplot(data = lm_object, aes(x = lm_matrix[, var], y = lm_object$residuals)) + 
                 labs(x = var, y = "residuals") + 
                 ggtitle(paste("Residual vs.", var)) + 
                 geom_point() +
                 geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3") +
                 ylim(-(limit + margin), limit + margin))
   }
   else {
      base_plot = ggplot(data = data.frame(lm_matrix), aes(x = lm_matrix[, var], y = lm_object$residuals)) + 
         labs(x = var, y = "residuals") + 
         ggtitle(paste("Residual vs.", var)) + 
         geom_boxplot()
      if (nlevels(lm_matrix[, var]) > n_var_threshold) {
         return (base_plot + theme(axis.text.x = element_text(angle = 45, hjust = 1)))
      }
      else {
         return (base_plot)
      }
      return(base_plot)
   }
}
