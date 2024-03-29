% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gg_cooksd.R
\name{gg_cooksd}
\alias{gg_cooksd}
\title{Plot cook's distance graph}
\usage{
gg_cooksd(
  fitted.lm,
  label = TRUE,
  show.threshold = TRUE,
  threshold = "convention",
  scale.factor = 0.5
)
}
\arguments{
\item{fitted.lm}{a fitted linear model (i.e. lm, glm) that contains fitted regression}

\item{label}{logical; whether or not to label observation number larger than threshold.
Default to TRUE.}

\item{show.threshold}{logical; determine whether or not threshold line is to be shown. Default to TRUE.}

\item{threshold}{string; determining the cut off label of cook's distance. Choices are
"baseR" (0.5 and 1), "matlab" (mean(cooksd)*3), and "convention" (4/n and 1). Default to "convention".}

\item{scale.factor}{numeric; scales the point size and linewidth to allow customized viewing. Defaults to 0.5.}
}
\value{
A ggplot object that contains a cook's distance plot
}
\description{
Plot cook's distance graph
}
\examples{
library(MASS)
data(Cars93)
cars_lm <- lm(Price ~ Passengers + Length + RPM, data = Cars93)
gg_cooksd(cars_lm)

}
