#' Compare Two Distributions with Zoom in to Tails
#'
#' @param dist1 a dataframe with 2 columns: ret = returns ; type = column type
#' @param dist2 a dataframe with 2 columns: ret = returns ; type = column type
#' @param zoom_tail currently supports "left"
#' @return ggplot object

#' @keywords tbc
#' @examples
#' library(tidyverse)
#' library(ggplot2)
#' library(highfrequency)
#' library(xts)
#' library(ggforce)
#'
#' quotes <- highfrequency::sampleQData %>% highfrequency::aggregateQuotes(alignBy = "seconds",alignPeriod = 5)%>% select(DT,ret = MIDQUOTE)
#' log_returns <- as.xts(quotes) %>% highfrequency::makeReturns()
#'
#' normal_dist_logret   <- rnorm(length(log_returns),
#'                               mean= mean(log_returns),
#'                               sd = sd(log_returns))
#'
#' dist1 <- log_returns %>% as.data.frame() %>% remove_rownames() %>% mutate(type = "logret")
#' dist2 <- normal_dist_logret %>% data.frame(ret = .) %>% mutate(type = "normdist")

#' compare_distributions(dist1,dist2,zoom_tail = "left") +
#'   scale_color_manual(name = "Distributions",
#'                      values = c("logret" = "red",
#'                                 "normdist" = "black"),
#'                      labels = c("High Frequency Log Returns","Normal Distribution"))
#' @export
compare_distributions <- function(dist1,dist2, zoom_tail = "left", ...){


  all <- bind_rows(dist1, dist2)

  ggplot(data = all,
         aes(x = ret,
             col = type)) +
    geom_density(alpha = 1,adjust = 1.5,size = 1.1) +

    scale_y_continuous() +
    labs(x = "Returns",
         y = "Density")+ #,         #title = "Comparison of the real and modelled distributions")+       #subtitle = "subtitle", #      caption = "This is a caption")+
    facet_zoom(xlim = c(mean(log_returns,na.rm = T),quantile(log_returns,0.001)),
               ylim = c(0,300),
               split = FALSE,
               horizontal = F,
               zoom.size = 1,
               show.area = TRUE,
               shrink = TRUE) +
    theme_bw()


}

