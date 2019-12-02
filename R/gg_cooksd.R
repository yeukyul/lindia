
#' Plot cook's distance graph
#'
#' @param fitted.lm a fitted linear model (i.e. lm, glm) that contains fitted regression
#' @param label logical; whether or not to label observation number larger than threshold.
#' Default to TRUE.
#' @param threshold string; determining the cut off label of cook's distance. Choices are
#' "baseR" (0.5 and 1), "matlab" (mean(cooksd)*3), "theoretical" (based on normal assumption) and "convention" (4/n and 1). Default to "convention".
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
   else if (threshold == "theoretical") {
      k <- length(fitted.lm$coefficients)
      leverage <- lm_matrix[, ".hat"]
      alpha <- 0.05
      nauth <- alpha * n
      noutliers <- max(sum(cooksd * (1 - leverage) / leverage * k / (n-k) > qbeta(1 - alpha, shape1 = 1/2, shape2 = (n - k - 1) / 2)) - nauth, 0)
      ioutliers <- order(cooksd, decreasing = TRUE)[seq_len(noutliers)]
      threshold <- cooksd[ioutliers[noutliers]]
      if (length(threshold) == 0) threshold <- 1.05 * max(cooksd)
   }
   else {
      stop("invalid threshold specified for gg_cooksd")
   }

   # window limit
   limit = max(cooksd, na.rm = T)
   margin_factor = 5
   margin = round(limit / margin_factor)
   max_cook = limit + margin

   .cooksd <- NULL

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
      base_plot = base_plot + geom_text(label = lm_matrix[, "rowname"], nudge_x = 3, color = "indianred3")
   }

   # showing threshold for outliers
   if (show.threshold) {
      if (min(threshold) > max_cook) {
         message(paste0("Cut-off for outliers (", threshold, ") is larger than all Cook's distances. The cut-off line might therefore not appear on the plot."))
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
