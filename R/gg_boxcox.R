

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
   rounded_lambda <- round(best_lambda, lambdaSF)
   min_y <- min(y)
   
   # compute accepted range of lambda transformation 
   accept_inds <- which(y > max(y) - 1/2 * qchisq(.95,1))
   accept_range <- x[accept_inds]
   conf_lo <- round(min(accept_range), lambdaSF)
   conf_hi <- round(max(accept_range), lambdaSF)
   
   plot <- ggplot(data = boxcox_unlist) + 
      geom_segment(aes(x = xstart, y = ystart, xend = xend, yend = yend)) +
      labs(x = "lambda", y = "log-likelihood") +
      ggtitle("Boxcox Plot") + 
      geom_vline(xintercept = best_lambda, linetype = "dotted") + 
      geom_vline(xintercept = conf_lo, linetype = "dotted") + 
      geom_vline(xintercept = conf_hi, linetype = "dotted") +
      geom_hline(yintercept = y[min(accept_inds)], linetype = "dotted")
   
   # add label if show lambda range
   if (showlambda) {
      return(plot +  
                geom_text(aes(x = best_lambda, label = as.character(rounded_lambda), y = min_y), color = "indianred3") +
                geom_text(aes(x = conf_lo, label = as.character(conf_lo), y = min_y)) +
                geom_text(aes(x = conf_hi, label = as.character(conf_hi), y = min_y)))
   }
   else {
      return (plot)
   }
}