rm(list = ls())

library(sas7bdat)
library(plyr)
library(reshape)
library(ggplot2)
library(ggmap)
library(scales)
library(gridExtra)


load("data/prepped_cab_data.rda")


dta = read.sas7bdat("analysis/randomeffectsreduced.sas7bdat")
dta = arrange(dta, desc(Estimate))

pick.up = subset(dta, Effect == 'pickup_location_id')
drop.off = subset(dta, Effect == 'dropoff_location_id')

pick.up = pick.up[, c("pickup_location_id", "Estimate", "Probt")]
drop.off = drop.off[, c("dropoff_location_id", "Estimate", "Probt")]

colnames(pick.up) = c("pickup_location_id", "pickup_estimate", "pickup_Probt")
colnames(drop.off) = c("dropoff_location_id", "dropoff_estimate", "dropoff_Probt")


lkp.pickup = unique(cab.final[, c("pickup_location_id", "pickup_lat_cen", "pickup_lon_cen", "pickup_location")])
lkp.dropoff = unique(cab.final[, c("dropoff_location_id", "dropoff_lat_cen", "dropoff_lon_cen", "dropoff_location")])


pick.up = join(pick.up, lkp.pickup)
drop.off = join(drop.off, lkp.dropoff)

pick.up$pickup.sig = ifelse(pick.up$pickup_Probt < .05, "Y", "N")
drop.off$dropoff.sig = ifelse(drop.off$dropoff_Probt < .05, "Y", "N")





## Move map to the right to cover the data area
nyc2 = get_map(location = c(lon = -73.9, lat = 40.75), zoom = 11, color = "bw")

ggmap(nyc2) +
  geom_point(aes(x = pickup_lon_cen, y = pickup_lat_cen, color = pickup_estimate), 
             data = subset(pick.up, pickup.sig == 'Y')) +
  scale_color_gradient2(low = "#b30101", midpoint = 0, mid = "#eec900", high = "#118b45")

ggmap(nyc2) +
  geom_point(aes(x = dropoff_lon_cen, y = dropoff_lat_cen, color = dropoff_estimate), 
             data = subset(drop.off, dropoffsig == 'Y')) +
  scale_color_gradient2(low = "#b30101", midpoint = 0, mid = "#eec900", high = "#118b45")



nyc3 = get_map(location = c(lon = -73.95, lat = 40.75), zoom = 12, color = "bw")

ggmap(nyc3) +
  geom_point(aes(x = pickup_lon_cen, y = pickup_lat_cen, color = pickup_estimate), size = 2,
             data = subset(pick.up, pickup.sig == 'Y')) +
  scale_color_gradient2(low = "#b30101", midpoint = 0, mid = "#eec900", high = "#118b45")

ggmap(nyc3) +
  geom_point(aes(x = dropoff_lon_cen, y = dropoff_lat_cen, color = dropoff_estimate), 
             data = subset(drop.off, dropoff.sig == 'Y')) +
  scale_color_gradient2(low = "#b30101", midpoint = 0, mid = "#eec900", high = "#118b45")





### Plot Original data for the significant locations
cab.final = join(cab.final, pick.up[, c("pickup_location_id", "pickup_estimate", "pickup.sig", "pickup_location")])
cab.final = join(cab.final, drop.off[, c("dropoff_location_id", "dropoff_estimate", "dropoff.sig", "dropoff_location")])

g1 = ggmap(nyc2) +
  geom_point(aes(x = pickup_longitude, y = pickup_latitude, color = pickup_estimate), alpha = .02,
             data = subset(cab.final, pickup.sig == 'Y')) +
  geom_point(aes(x = pickup_lon_cen, y = pickup_lat_cen), size = 1, data = subset(pick.up, pickup.sig == 'Y')) +
  scale_color_gradient2("", low = "#b30101", midpoint = 0, mid = "#eec900", high = "#118b45", labels = percent) +
  ggtitle("Tip Effect by Pickup Location", subtitle = "Significant Effects Only") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank())


g2 = ggmap(nyc2) +
  geom_point(aes(x = dropoff_longitude, y = dropoff_latitude, color = dropoff_estimate), alpha = .02,
             data = subset(cab.final, dropoff.sig == 'Y')) +
  geom_point(aes(x = dropoff_lon_cen, y = dropoff_lat_cen), size = 1, data = subset(drop.off, dropoff.sig == 'Y')) +
  scale_color_gradient2("", low = "#b30101", midpoint = 0, mid = "#eec900", high = "#118b45", labels = percent) +
  ggtitle("Tip Effect by Dropoff Location", subtitle = "Significant Effects Only") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank())


nyc3 = get_map(location = c(lon = -73.98, lat = 40.74), zoom = 13, color = "bw")


g3 = ggmap(nyc3) +
  geom_point(aes(x = pickup_longitude, y = pickup_latitude, color = pickup_estimate), alpha = .02,
             data = subset(cab.final, pickup.sig == 'Y')) +
  geom_point(aes(x = pickup_lon_cen, y = pickup_lat_cen), size = 2, data = subset(pick.up, pickup.sig == 'Y')) +
  scale_color_gradient2("", low = "#b30101", midpoint = 0, mid = "#eec900", high = "#118b45", labels = percent) +
  ggtitle("Tip Effect by Pickup Location", subtitle = "Manhattan Area: Significant Effects Only") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank())

g4 = ggmap(nyc3) +
  geom_point(aes(x = dropoff_longitude, y = dropoff_latitude, color = dropoff_estimate), alpha = .02,
             data = subset(cab.final, dropoff.sig == 'Y')) +
  geom_point(aes(x = dropoff_lon_cen, y = dropoff_lat_cen), size = 2, data = subset(drop.off, dropoff.sig == 'Y')) +
  scale_color_gradient2("", low = "#b30101", midpoint = 0, mid = "#eec900", high = "#118b45", labels = percent) +
  ggtitle("Tip Effect by Dropoff Location", subtitle = "Manhattan Area: Significant Effects Only") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank())


grid.arrange(g1, g2, nrow = 1)

grid.arrange(g3, g4, nrow = 1)

