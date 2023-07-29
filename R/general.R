
# This file contains general helper functions used in lindia

# strsplit_vec - splits a string and returns a vector
#
# input: str - string to be splitted
#        split - character to be splitted by 
# output: a vector as a result of string splitting
#
strsplit_vec <- function(str, split) {
   return (unlist(strsplit(str, split))[-1])
}


#
# n_cat - returns the index of categorical varible in given regression
#
# input : varnames - vector of variable name strings
#         model_matrix - model_matrix of the fitted lm
# output : index of categorical varible in given regression
#
n_cat <- function(varnames, model_matrix) {
   cat_inds = c()
   modelvars = colnames(model_matrix)
   for (i in 1:length(varnames)) {
      name = varnames[i]
      if (!(name %in% modelvars)) {
         cat_inds = c(cat_inds, i)
      }
   }
   return (cat_inds)
}

#
# get_ncols - returns the appropriate number of columns to arrange number of plots
#              into a square display grid. ncol returned would at least be 1.
#
# input : n_plots - number of plots
# output : a number represents number of column needed to organize the plots into a square grid
#
get_ncol <- function(n_plots) {
   return(max(floor(sqrt(n_plots)), 1))
}


#
# get_varnames - returns variable names in a lm.
#
# input : lm_object - fitted lm
# output : list of two items
#                    [[1]] : string variable names in fitted lm
#                    [[2]] : vector of interaction terms
#
get_varnames <- function(lm_object) {
   
   lm_formula = as.character(formula(lm_object))
   var_names_list = strsplit(lm_formula, ' ~ ')
   var_name_vec = strsplit_vec(lm_formula, ' ~ ')
   
   # drop response variable
   args_str = var_name_vec
   
   # parse args in lm
   if (grepl(args_str, " \\+ ")) {
     # if there is more than one term
     args = unlist(strsplit_vec(args_str, " \\+ "))
   } else {
     args = c(args_str)
   }
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