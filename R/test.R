

library(MASS)
data(Cars93)
cars_lm <- lm(Rev.per.mile ~ Passengers + Length + RPM, data = Cars93)
cars_lm_2 <- lm(Rev.per.mile ~ Passengers + Length + RPM + Manufacturer, data = Cars93)
cars_lm_3 <- lm(Rev.per.mile ~ Passengers + Length + RPM + Manufacturer + Weight * Length, data = Cars93)


gg_resfitted(cars_lm)


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
