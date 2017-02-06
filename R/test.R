# 
# 
# library(MASS)
# data(Cars93)
# cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)
# cars_lm_2 <- lm(Rev.per.mile ~ Passengers + Length + RPM + Manufacturer, data = Cars93)
# cars_lm_3 <- lm(Rev.per.mile ~ Passengers + Length + RPM + Manufacturer + Weight * Length, data = Cars93)
# cars_lm_4 <- lm(Rev.per.mile ~ Passengers + Length + RPM + Manufacturer + Type + Make * Origin , data = Cars93)
# 
# 
# gg_resfitted(cars_lm)
# 
# 
# get_varnames <- function(lm_object) {
#    
#    lm_formula = as.character(formula(lm_object))
#    var_names_list = strsplit(lm_formula, ' ~ ')
#    var_name_vec = strsplit_vec(lm_formula, ' ~ ')
#    
#    # drop response variable
#    args_str = var_name_vec
#    
#    # parse args in lm
#    args = unlist(strsplit_vec(args_str, " \\+ "))
#    n_args = length(args)
#    predictors = c()
#    interaction = list()
#    
#    # count how many interaction terms there are
#    # used for storing variables in return list
#    n_inter = 1
#    
#    # find interaction terms
#    for (i in 1:n_args) {
#       term = args[i]
#       
#       # check if it is interaction term
#       # !! caution: check if it works with multiple interaction
#       if (grepl(' \\* ', term)) {
#          inter_terms = unlist(strsplit(term, " \\* "))
#          predictors = c(predictors, inter_terms)
#          interaction[[n_inter]] = inter_terms
#          n_inter = n_inter + 1
#       }
#       else {
#          predictors = c(predictors, term)
#       }
#    }
#    
#    # clean up duplicated predictors from extracting from interaction terms
#    predictors = unique(predictors)
#    
#    return (list(predictors = predictors, interactions = interaction))
# }
# 
# # returns a vector as a result of string splitting
# strsplit_vec <- function(str, split) {
#    return (unlist(strsplit(str, split))[-1])
# }
# 
# 
# # testing
# n_cat(get_varnames(cars_lm_3)$predictor, model.matrix(cars_lm_3)) # expect 1
# n_cat(get_varnames(cars_lm_2)$predictor, model.matrix(cars_lm_2)) # expect 1
# n_cat(get_varnames(cars_lm_4)$predictor, model.matrix(cars_lm_4)) # expect 4
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# library(ggplot2)
# library(gridExtra)
# 
# # setting up test lm
# cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)
# plots <- gg_resX(cars_lm)
# grid.arrange(plots[[1]], plots[[2]], plots[[3]], nrow = 1)
# 
# function_1 <- function(lm_object){
#    # extract model matrix
#    model_matrix = model.matrix(lm_object)
#    
#    # extract relevant explanatory variables in model matrix
#    var_names = colnames(model_matrix)[-1]
#    dim = length(var_names)
#    
#    # create a list to hold all residual plots
#    plots = vector("list", dim)
#    
#    for (i in 1:dim){
#       var = var_names[i]
#       plots[[i]] <- (ggplot(data = lm_object, aes(x = model_matrix[, var_names[i]], y = lm_object$residuals)) + 
#                         geom_point() + 
#                         labs(x = var_names[i], y = "residuals") +
#                         geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3"))
#    }
#    
#    # rename plots in the array
#    names(plots) = var_names
#    
#    plots
# }
# 
# function2 <- function(lm_object){
#    # extract model matrix
#    model_matrix = model.matrix(lm_object)
#    
#    # extract relevant explanatory variables in model matrix
#    var_names = colnames(model_matrix)[-1]
#    dim = length(var_names)
#    
#    # create a list to hold all residual plots
#    plots = vector("list", dim)
#    
#    
#    plots[[1]] <- (ggplot(data = lm_object, aes(x = model_matrix[, var_names[1]], y = lm_object$residuals)) + 
#                      geom_point() + 
#                      labs(x = var_names[1], y = "residuals") +
#                      geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3"))
#    plots[[2]] <- (ggplot(data = lm_object, aes(x = model_matrix[, var_names[2]], y = lm_object$residuals)) + 
#                      geom_point() + 
#                      labs(x = var_names[2], y = "residuals") +
#                      geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3"))
#    plots[[3]] <- (ggplot(data = lm_object, aes(x = model_matrix[, var_names[3]], y = lm_object$residuals)) + 
#                      geom_point() + 
#                      labs(x = var_names[3], y = "residuals") +
#                      geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3"))
#    
#    # rename plots in the array
#    names(plots) = var_names
#    
#    plots
# }
# 
# # plotting plots
# plots <- function_1(cars_lm)
# grid.arrange(plots[[1]], plots[[2]], plots[[3]], nrow = 1)
# 
# plots <- function_2(cars_lm)
# grid.arrange(plots[[1]], plots[[2]], plots[[3]], nrow = 1)
