
library(ggplot2)
library(gridExtra)

# setting up test lm
cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)
plots <- gg_resX(cars_lm)
grid.arrange(plots[[1]], plots[[2]], plots[[3]], nrow = 1)

function_1 <- function(lm_object){
   # extract model matrix
   model_matrix = model.matrix(lm_object)
   
   # extract relevant explanatory variables in model matrix
   var_names = colnames(model_matrix)[-1]
   dim = length(var_names)
   
   # create a list to hold all residual plots
   plots = vector("list", dim)
   
   for (i in 1:dim){
      var = var_names[i]
      plots[[i]] <- (ggplot(data = lm_object, aes(x = model_matrix[, var_names[i]], y = lm_object$residuals)) + 
                        geom_point() + 
                        labs(x = var_names[i], y = "residuals") +
                       geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3"))
   }
   
   # rename plots in the array
   names(plots) = var_names
   
   plots
   
   plots[[1]] <- (ggplot(data = lm_object, aes(x = model_matrix[, var_names[1]], y = lm_object$residuals)) + 
                     geom_point() + 
                     labs(x = var_names[1], y = "residuals") +
                     geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3"))
   plots[[2]] <- (ggplot(data = lm_object, aes(x = model_matrix[, var_names[2]], y = lm_object$residuals)) + 
                     geom_point() + 
                     labs(x = var_names[2], y = "residuals") +
                     geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3"))
   plots[[3]] <- (ggplot(data = lm_object, aes(x = model_matrix[, var_names[3]], y = lm_object$residuals)) + 
                     geom_point() + 
                     labs(x = var_names[3], y = "residuals") +
                     geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3"))
   
   # rename plots in the array
   names(plots) = var_names
   
   plots
}

function2 <- function(lm_object){
   # extract model matrix
   model_matrix = model.matrix(lm_object)
   
   # extract relevant explanatory variables in model matrix
   var_names = colnames(model_matrix)[-1]
   dim = length(var_names)
   
   # create a list to hold all residual plots
   plots = vector("list", dim)

   
   plots[[1]] <- (ggplot(data = lm_object, aes(x = model_matrix[, var_names[1]], y = lm_object$residuals)) + 
                     geom_point() + 
                     labs(x = var_names[1], y = "residuals") +
                     geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3"))
   plots[[2]] <- (ggplot(data = lm_object, aes(x = model_matrix[, var_names[2]], y = lm_object$residuals)) + 
                     geom_point() + 
                     labs(x = var_names[2], y = "residuals") +
                     geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3"))
   plots[[3]] <- (ggplot(data = lm_object, aes(x = model_matrix[, var_names[3]], y = lm_object$residuals)) + 
                     geom_point() + 
                     labs(x = var_names[3], y = "residuals") +
                     geom_hline(yintercept = 0, linetype = "dashed", color = "indianred3"))
   
   # rename plots in the array
   names(plots) = var_names
   
   plots
}

# plotting plots
plots <- function_1(cars_lm)
grid.arrange(plots[[1]], plots[[2]], plots[[3]], nrow = 1)

plots <- function_2(cars_lm)
grid.arrange(plots[[1]], plots[[2]], plots[[3]], nrow = 1)