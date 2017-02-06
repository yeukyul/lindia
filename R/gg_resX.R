
#' Generate residual plot of residuals against predictors
#'
#' @param lm_object lm object that contains fitted regression
#' @param data original dataset
#' @param select vector represents all variables that wanted ot be included
#' in output. Default to all variables.
#' @param plotAll boolean value to determine whether plot will be return as 
#' a plot arranged using `grid.arrange()`. When set to false, the function
#' would return a list of residual plots. Parameter defaults to TRUE.
#' @return A list of ggplot objects that contains residual plot
#' of residuals against predictor values
#' @examples gg_resX()
#' 
#' @export
gg_resX <- function(lm_object, data = NULL, select = NULL, plotAll = TRUE){
   
   handle_exception(lm_object, "gg_resX")
   
   # extract model matrix
   model_matrix = model.matrix(lm_object)
   
   # extract relevant explanatory variables in model matrix
   var_names = get_varnames(lm_object)$predictor
   dim = length(var_names)
   cat_inds = c()
   
   # if didn't pass in data, check how many categorical variables there are
   if (is.null(data)) {
      cat_inds = n_cat(var_names, model_matrix)
      dim = dim - length(cat_inds)
   }
   
   # create a list to hold all residual plots
   plots = vector("list", dim)
   
   # number of plots so far
   n = 1
   
   for (i in 1:length(var_names)){
      
      # if encounter categorical variable, skip
      if (i %in% cat_inds) {
         warning(paste("Find categorical variable `", var_names[i],"`. Should pass in the dataset as 'data' parameter to allow plotting. Lindia ignores plot for now."))
         next
      }
      
      var = var_names[i]
      this_plot <- get_resplot(var, model_matrix, lm_object, data = data)
      if (!is.null(this_plot)) {
         plots[[n]] <- this_plot
         n = n + 1
      }
      
   }
   
   # rename plots in the array
   if (length(cat_inds) > 0) {
      names(plots) = var_names[-cat_inds]
   }
   else {
      names(plots) = var_names
   }
   
   
   if (plotAll) {
      nCol = get_ncol(dim)
      return (do.call("grid.arrange", c(plots, ncol = nCol)))
   }
   else {
      return (plots)
   }
   
}
