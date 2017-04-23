rm(list = ls())

library(sas7bdat)
library(plyr)
library(reshape)
library(ggplot2)
library(ggmap)


load("data/prepped_cab_data.rda")


x = ddply(cab.final, .(pickup_location_id, dropoff_location_id), summarise,
          avg_distance = mean(trip_distance),
          avg_tip = mean(tip_amount))

x2 = arrange(ddply(x, .(pickup_location_id), summarise, avg = mean(avg_distance)), avg)
x3 = arrange(ddply(x, .(dropoff_location_id), summarise, avg = mean(avg_distance)), avg)

x$pickup_location_id = factor(x$pickup_location_id, levels = as.character(x2$pickup_location_id))
x$dropoff_location_id = factor(x$dropoff_location_id, levels = as.character(x3$dropoff_location_id))


ggplot(x, aes(x = pickup_location_id, y = dropoff_location_id, fill = avg_distance)) +
  geom_tile() +
  geom_point(aes(alpha = avg_tip))


ggplot(cab.final, aes(x = log(trip_distance), y = log(tip_amount/trip_distance), 
                      color = factor(rate_code))) +
  stat_summary()


y = ddply(cab.final, .(pickup_location_id, dropoff_location_id, rate_code), summarise,
          avg_distance = mean(trip_distance),
          avg_tip = mean(tip_amount))

ggplot(y) +
  geom_density(aes(x = avg_tip, color = factor(rate_code))) +
  scale_color_discrete("Rate Code") +
  scale_x_continuous("Tip Amount") +
  scale_y_continuous("Density") +
  ggtitle("Density Plot of Tip by Rate Code") +
  theme(plot.title = element_text(hjust = .5))


ggsave()