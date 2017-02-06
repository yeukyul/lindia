
# This file contains unimplemented functions

#
# get_resplot returns a ggplot object of scatterplot of interaction terms 
#
# input : model_matrix - model matrix of an lm object
#        interactions - interactions terms' var name
# output : ggplot object that contains scatterplot of interaction terms
#
# unimplemented yet because of concerns over multi-dimensional interaction plots
#
get_interplot <- function(model_matrix, interactions) {
   if (length(interactions) > 2) {
      stop("lindia doesn't know how to handle interaction terms with dimension greater than 2")
   }
   
   return (ggplot(data = model_matrix, aes(x = interaction[1], y = interaction[2])) +
              ggtitle(paste("Interaction between", interaction[1], "and", interaction[2])))
}