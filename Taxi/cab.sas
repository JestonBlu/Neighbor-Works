%LET DTA = 'cab_final.csv';

proc import datafile=&dta out=cab;
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
ods graphics off;

