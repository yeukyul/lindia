
#' Plot cook's distance graph
#'
#' @param fitted.lm a fitted linear model (i.e. lm, glm) that contains fitted regression
#' @param label logical; whether or not to label observation number larger than threshold.
#' Default to TRUE.
#' @param threshold string; determining the cut off label of cook's distance. Choices are
#' "baseR" (0.5 and 1), "matlab" (mean(cooksd)*3), and "convention" (4/n and 1). Default to "convention".
#' @param scale.factor numeric; scales the point size and linewidth to allow customized viewing. Defaults to 0.5.
#' @param show.threshold logical; determine whether or not threshold line is to be shown. Default to TRUE.
#' @return A ggplot object that contains a cook's distance plot
#' @examples library(MASS)
#' data(Cars93)
#' cars_lm <- lm(Price ~ Passengers + Length + RPM, data = Cars93)
#' gg_cooksd(cars_lm)
#'
#' @export
gg_cooksd <- function(fitted.lm, label = TRUE, show.threshold = TRUE, threshold = "convention", scale.factor = 0.5) {

   handle_exception(fitted.lm, "gg_cooksd")

   # obtain linear model matrix
   lm_matrix <- fortify(fitted.lm)
   lm_matrix[, "rowname"] <- 1:nrow(lm_matrix)

   # threshold for outliar
   cooksd = lm_matrix[, ".cooksd"]
   n = nrow(lm_matrix)

   # compute the threshold value for cook's distance plot
   if (threshold == "matlab") {
      threshold = mean(cooksd) * 3
   }
   else if (threshold == "baseR") {
      threshold = c(0.5, 1)
   }
   else if (threshold == "convention") {
      threshold = c(4/n, 1)
   }
   else {
      stop("invalid threshold specified for gg_cooksd")
   }

   # window limit
   limit = max(cooksd)
   margin_factor = 5
   margin = round(limit / margin_factor)
   max_cook = limit + margin

   base_plot <- (ggplot(fitted.lm, aes(1:nrow(lm_matrix), .cooksd, ymin = 0, ymax = cooksd)) +
              geom_point(size = scale.factor) +
              geom_linerange(size = scale.factor) +
              xlab("Observation Number") +
              ylab("Cook's distance") +
              ggtitle("Cook's Distance Plot") +
              ylim(0, max_cook))

   # labelling of potential outliers
   if (label) {
      out_inds <- which(cooksd < min(threshold))
      lm_matrix[out_inds, "rowname"] <- rep("", length(out_inds))
      base_plot = base_plot + geom_text(label = lm_matrix[, "rowname"], nudge_x = 4, color = "indianred3")
   }

   # showing threshold for outliers
   if (show.threshold) {
      if (min(threshold) > max_cook) {
         message("Cut-off for outliers too big to be shown in Cook's Distance plot.")
      }
      else {
         for (i in 1:length(threshold)) {
            if (threshold[i] > max_cook) {
               next
            }
            base_plot = base_plot + geom_hline(yintercept = threshold[i], linetype = "dashed", color = "indianred3", size = scale.factor)
         }
      }
   }

   return(base_plot)
}
