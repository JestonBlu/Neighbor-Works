rm(list = ls())

library(sas7bdat)
library(plyr)
library(reshape)
library(ggplot2)
library(ggmap)

dta = read.sas7bdat("~/Projects/neighbor-works/data/taxi_sample.sas7bdat")
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
  month = ddply(cab, .(month), summarise, prop_tip = sum(tip)/10000),
  vendor_id = ddply(cab, .(vendor_id), summarise, prop_tip = sum(tip)/length(tip)),
  pickup_time = ddply(cab, .(hour = round_any(pickup_time, 1, floor)), summarise, prop_tip = sum(tip)/length(tip)),
  passenger_count = ddply(cab, .(passenger_count), summarise, prop_tip = sum(tip)/length(tip), count = length(tip)),
  trip_distance = ddply(cab, .(trip_distance = round_any(trip_distance, 1, ceiling)), summarise, 
                        prop_tip = sum(tip)/length(tip), count = length(tip)),
  payment_type = ddply(cab, .(payment_type), summarise, prop_tip = sum(tip)/length(tip), count = length(tip)),
  fare_amount = ddply(cab, .(fare_amount = round_any(fare_amount, 10, floor)), summarise, 
                      prop_tip = sum(tip)/length(tip), count = length(tip)),
  toll = ddply(cab, .(toll), summarise, prop_tip = sum(tip)/length(tip), count = length(tip)),
  tip_pct = ddply(cab, .(tip_pct = round_any(tip_pct, .05, ceiling)), summarise, count = length(tip)))

## Apply some constraints to the outliers
cab = subset(cab, passenger_count > 0 & 
               trip_distance <= 30 & trip_distance > 0 &
               payment_type %in% c("CRD") & 
               fare_amount <= 100 & fare_amount > 0 &
               tip_pct >= 0 & tip_pct <= 1)

cab$dropoff_time_round = round_any(cab$dropoff_time, 4, floor)

row.names(cab) = 1:nrow(cab)

mdl = glm(log(tip_amount+1) ~ month + vendor_id + pickup_time + passenger_count + log(trip_distance) + log(fare_amount) + toll, data = cab)

nyc = get_map(location = c(lon = -73.98, lat = 40.75), zoom = 13, color = "bw")

ggmap(nyc) +
  stat_density2d(aes(x = pickup_longitude, y = pickup_latitude, fill = ..level.., alpha = ..level..),
                 bins = 5, geom = "polygon", data = cab) +
  facet_wrap(~tip) +
  scale_fill_continuous(guide = FALSE) +
  scale_alpha_continuous(guide = FALSE) +
  ggtitle("Tip Distribution") +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        plot.title = element_text(hjust = .5))

ggmap(nyc) +
  stat_density2d(aes(x = pickup_longitude, y = pickup_latitude, fill = ..level.., alpha = ..level..),
                 bins = 5, geom = "polygon", data = cab) +
  facet_grid(tip~dropoff_time_round) +
  scale_fill_continuous(guide = FALSE) +
  scale_alpha_continuous(guide = FALSE) +
  ggtitle("Tip Distribution", subtitle = "(Tip by 4 Hour Segment)") +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5))











