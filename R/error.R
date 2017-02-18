
# This file contains exception checking and error handling functions

#
# exception handling function for malformed input in lindia
#
handle_exception <- function(input, function_name){
   
   type = class(input)
   
   # exception handling : input not lm object
   if (type != "lm" && type != "glm"){
      stop(paste(function_name, "doesn't know how to handle non-lm object"))
   }
   
}

