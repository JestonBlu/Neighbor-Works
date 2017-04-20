%LET DTA = 'cab_final.csv';

proc import datafile=&dta out=cab;
run;

ods pdf file = "models.pdf";
proc contents data = cab; run;

data cab;
    set cab;
    log_tip = log(tip_amount);
run;

/* Mixed Model with Random Var Dropoff Locations and Times */
ods graphics on;
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id;
	model tip_amount = trip_distance 
                       passenger_count 
                       month 
                       toll_ind 
                       / ddfm=kr;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	lsmeans month / adjust=tukey;
run;

*add fare amount;
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id passenger_count;
	model tip_amount = trip_distance 
                       passenger_count 
                       month 
                       toll_ind
                       fare_amount
                       / ddfm=kr;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	lsmeans month / adjust=tukey;
        lsmeans passenger_count / adjust=tukey;
run;

proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id;
	model log_tip = trip_distance 
                       passenger_count 
                       month 
                       toll_ind 
                       / ddfm=kr;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	lsmeans month / adjust=tukey;
run;

proc glimmix data=cab plots=studentpanel;
      class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id;
      model  trip_distance =  
                     passenger_count 
                     month 
                     toll_ind 
                     / ddfm=kr;
      random pickup_location_id dropoff_location_id pickup_time dropoff_time;
      lsmeans month / adjust=tukey;
run;

proc glimmix data=cab plots=studentpanel;
      class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id;
      model fare_amount = trip_distance 
                     passenger_count 
                     month 
                     toll_ind 
                     / ddfm=kr;
      random pickup_location_id dropoff_location_id pickup_time dropoff_time;
      lsmeans month / adjust=tukey;
run;
ods graphics off;

ods pdf close;
