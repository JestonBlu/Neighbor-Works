rm(list = ls())

library(sas7bdat)
library(plyr)
library(reshape)
library(ggplot2)
library(ggmap)

dta = read.sas7bdat("data/taxi_sample.sas7bdat")
dta$TIP = ifelse(dta$TIP_AMOUNT > 0, 1, 0)
dta$TOLL = ifelse(dta$TOLLS_AMOUNT > 0, 1, 0)

colnames(dta) = casefold(colnames(dta))

cab = dta[, c("month", "vendor_id", "pickup_time", "passenger_count", "trip_distance", "dropoff_time",
              "payment_type", "fare_amount", "tip", "toll", "tip_amount", "dropoff_longitude", "dropoff_latitude",
              "pickup_longitude", "pickup_latitude")]

cab$pickup_time = cab$pickup_time / 60 / 60
cab$dropoff_time = cab$dropoff_time / 60 / 60
cab$tip_pct = with(cab, tip_amount/fare_amount)


## Univariate Summaries of variables
cab.counts = list(
  month = ddply(cab, .(month), 
                summarise, 
                prop_tip = sum(tip)/10000),
  vendor_id = ddply(cab, .(vendor_id), 
                    summarise, 
                    prop_tip = sum(tip)/length(tip)),
  pickup_time = ddply(cab, .(hour = round_any(pickup_time, 1, floor)), 
                      summarise, 
                      prop_tip = sum(tip)/length(tip)),
  passenger_count = ddply(cab, .(passenger_count), 
                          summarise, 
                          prop_tip = sum(tip)/length(tip), 
                          count = length(tip)),
  trip_distance = ddply(cab, .(trip_distance = round_any(trip_distance, 1, ceiling)), 
                        summarise, 
                        prop_tip = sum(tip)/length(tip),
                        count = length(tip)),
  payment_type = ddply(cab, .(payment_type), 
                       summarise, 
                       prop_tip = sum(tip)/length(tip), 
                       count = length(tip)),
  fare_amount = ddply(cab, .(fare_amount = round_any(fare_amount, 10, floor)), 
                      summarise, 
                      prop_tip = sum(tip)/length(tip), 
                      count = length(tip)),
  toll = ddply(cab, .(toll), 
               summarise, 
               prop_tip = sum(tip)/length(tip), 
               count = length(tip)),
  tip_pct = ddply(cab, .(tip_pct = round_any(tip_pct, .05, ceiling)), 
                  summarise, 
                  count = length(tip)))

## Apply some constraints to the outliers
cab = subset(cab, passenger_count > 0 & 
               trip_distance <= 30 & trip_distance > 0 &
               payment_type %in% c("CRD") & 
               fare_amount <= 100 & fare_amount > 0 &
               tip_pct >= 0 & tip_pct <= 1)

## Round time to 1 hour
cab$dropoff_time_round = round_any(cab$dropoff_time, 4, floor)


## Move map to the right to cover the data area
nyc2 = get_map(location = c(lon = -73.9, lat = 40.75), zoom = 11, color = "bw")

## Trim some bad locations
cab = subset(cab, pickup_longitude < 0 & dropoff_longitude < 0)

## Get rid of the outlier locations
cab2 = subset(cab, dropoff_longitude > -74.03 & dropoff_longitude < -73.75 &
                pickup_longitude > -74.03 & pickup_longitude < -73.75)
cab2 = subset(cab2, dropoff_latitude > 40.6 & dropoff_latitude < 40.9 &
                pickup_latitude > 40.6 & pickup_latitude < 40.9)


## KMeans  on Pickup Locations
k = kmeans(x = cab2[, c("pickup_latitude", "pickup_longitude")], centers = 50)
k.cen = as.data.frame(k$centers)

pickup.centers = c()

for (i in 1:nrow(k.cen)) {
  z = revgeocode(location = c(k.cen$pickup_longitude[i], k.cen$pickup_latitude[i]))
  pickup.centers = c(pickup.centers, z)
}

k.cen$pickup.centers = pickup.centers
k.cen$pickupID = 1:50

## KMeans on Dropoff locations
i = kmeans(x = cab2[, c("dropoff_latitude", "dropoff_longitude")], centers = 50)
i.cen = as.data.frame(i$centers)

dropoff.centers = c()

for (m in 1:nrow(i.cen)) {
  z = revgeocode(location = c(i.cen$dropoff_longitude[m], i.cen$dropoff_latitude[m]))
  dropoff.centers = c(dropoff.centers, z)
}

i.cen$dropoff.centers = dropoff.centers
i.cen$dropoffID = 1:50


## Add the clusters so the data
cab2$pickupID = k$cluster
cab2$dropoffID = i$cluster

## Clean up column names
colnames(k.cen) = c("pickup_lat_cen", "pickup_lon_cen", "pickup_location", "pickupID")
k.cen$pickup_location_id = paste('P', k.cen$pickupID, sep = "")

colnames(i.cen) = c("dropoff_lat_cen", "dropoff_lon_cen", "dropoff_location", "dropoffID")
i.cen$dropoff_location_id = paste('D', i.cen$dropoffID, sep = "")

cab2$pickup_time = round_any(cab2$pickup_time, accuracy = 1, f = floor)
cab2$dropoff_time = round_any(cab2$dropoff_time, accuracy = 1, f = floor)

colnames(cab2)[9:10] = c("tip_ind", "toll_ind")

cab.final = cab2[, c("month", "pickup_time", "dropoff_time", "passenger_count", "trip_distance",
                     "fare_amount", "tip_amount", "tip_pct", "tip_ind", "toll_ind", 
                     "pickup_longitude", "pickup_latitude", "dropoff_longitude", "dropoff_latitude",
                     "pickupID", "dropoffID")]

cab.final = join(cab.final, k.cen)
cab.final = join(cab.final, i.cen)

cab.final = cab.final[, -(15:16)]

save("cab.final", file = "data/prepped_cab_data.rda")
write.csv(cab.final, file = "data/cab_final.csv", row.names = FALSE)

################################################################################



## KMeans with Dropoff data
ggmap(nyc2) +
  geom_point(aes(x = dropoff_longitude, y = dropoff_latitude), data = cab.final, alpha = .05) +
  geom_point(aes(x = dropoff_lon_cen, y = dropoff_lat_cen), data = cab.final, color = "red") +
  ggtitle("Data with KMeans Centers")

library(gridExtra)


## Centers for Pickup Data
g1 = ggmap(nyc2) +
  geom_point(aes(x = pickup_longitude, y = pickup_latitude, color = pickup_location_id), 
             data = cab.final, alpha = .05) +
  geom_point(aes(x = pickup_lon_cen, y = pickup_lat_cen), data = cab.final) +
  scale_color_discrete(guide = FALSE) +
  ggtitle("KMeans Clusters for Pickup Locations") +
  theme(plot.title = element_text(hjust = .5),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank())


## Centers for Dropoff Data
g2 = ggmap(nyc2) +
  geom_point(aes(x = dropoff_longitude, y = dropoff_latitude, color = dropoff_location_id), 
             data = cab.final, alpha = .05) +
  geom_point(aes(x = dropoff_lon_cen, y = dropoff_lat_cen), 
             data = cab.final) +
  scale_color_discrete(guide = FALSE) +
  ggtitle("KMeans Clusters for Dropoff Locations") +
  theme(plot.title = element_text(hjust = .5),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank())

grid.arrange(g1, g2, nrow = 1)

ggsave(filename = "Taxi/Plots/KMeans.png")
