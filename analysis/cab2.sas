%LET DTA = 'cab_final2.csv';

proc import datafile=&dta out=cab;
run;

ods pdf file = "models_v2.pdf";
*proc contents data = cab; run;

data cab;
    set cab;
    log_tip = log(tip_amount);
    log_dist = log(trip_distance);
    log_fare = log(fare_amount);
run;

/* Mixed Model with Random Var Dropoff Locations and Times */
ods graphics on;
/*title 'Initial Model';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id;
	model log_tip = trip_distance 
                       passenger_count 
                       month 
                       toll_ind 
                       / ddfm=kr;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	lsmeans month / adjust=tukey;
run;*/

/*title 'Log Model-response and distance logged';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id;
	model tip_amount = log_dist 
                       passenger_count 
                       month 
                       toll_ind 
                       / ddfm=kr;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	lsmeans month / adjust=tukey;
run;*/

/*title 'Log Model-response and distance logged, month*dist interaction';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id;
	model tip_amount = log_dist 
                       passenger_count 
                       month 
                       toll_ind
                       month*log_dist 
                       / ddfm=kr;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	lsmeans month / adjust=tukey;
run;*/


title 'Log Model-response and distance logged, all dist interactions';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id rate_code;
	model log_tip = log_dist 
                       passenger_count 
                       month 
                       toll_ind
                       rate_code
                       month*log_dist
                       passenger_count*LOG_DIST
                       toll_ind*log_dist
                       rate_code*log_dist
                       / ddfm=kr solution;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	*lsmeans month / adjust=tukey;
run;

title 'Log Model-response and distance logged,removed pass*dist interaction';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id rate_code;
	model log_tip = log_dist 
                       passenger_count 
                       month 
                       toll_ind
                       rate_code
                       month*log_dist
                       toll_ind*log_dist
                       rate_code*log_dist
                       / ddfm=kr solution;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
*lsmeans month*LOG_DIST / slice=month slicediff = month adjust=tukey;
        
run;

title 'Log Model-response and distance logged,removed pass*dist and rate_code*dist interactions-- Best Model';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id rate_code passenger_count;
	model log_tip = log_dist 
                       passenger_count 
                       month 
                       toll_ind
                       rate_code
                       month*log_dist
                       toll_ind*log_dist
                       / ddfm=kr solution;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
*lsmeans month*LOG_DIST / slice=month slicediff = month adjust=tukey;
        
run;

title 'Log Model-response and distance logged,removed pass*dist and rate_code*dist interactions-- Best Model';
proc glimmix data=cab plots=studentpanel;
	class month toll_ind pickup_location_id dropoff_location_id rate_code passenger_count;
	model log_tip = log_dist 
                       passenger_count 
                       month 
                       toll_ind
                       rate_code
                       month*log_dist
                       toll_ind*log_dist
                       / ddfm=kr solution;
	random pickup_location_id dropoff_location_id ;
*lsmeans month*LOG_DIST / slice=month slicediff = month adjust=tukey;
        
run;

/*title 'Log Model-response and fare logged';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id;
	model log_tip = log_fare 
                       passenger_count 
                       month 
                       toll_ind 
                       / ddfm=kr;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	lsmeans month / adjust=tukey;
run;*/

title 'Log Model-response and fare logged, all interactions';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id rate_code passenger_count;
	model log_tip = log_fare 
                       passenger_count 
                       month 
                       toll_ind
                       rate_code
                       log_fare*month
                       passenger_count*LOG_fare
                       toll_ind*log_fare
                       rate_code*log_fare
                       / ddfm=kr solution;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	*lsmeans month / adjust=tukey;
run;

title 'Log Model-response and fare logged, removed fare*ratecode';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id passenger_count;
	model log_tip = log_fare 
                       passenger_count 
                       month 
                       toll_ind
                       log_fare*month
                       passenger_count*LOG_fare
                       toll_ind*log_fare
                       / ddfm=kr solution;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	*lsmeans month / adjust=tukey;
run;

title 'Log Model-response and fare logged, removed fare*ratecode';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id passenger_count;
	model log_tip = log_fare 
                       passenger_count 
                       month 
                       toll_ind
                       log_fare*month
                       passenger_count*LOG_fare
                       / ddfm=kr solution;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	*lsmeans month / adjust=tukey;
run;
title 'Log Model-response and fare logged, removed fare*ratecode, month';
proc glimmix data=cab plots=studentpanel;
	class pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id passenger_count;
	model log_tip = log_fare 
                       passenger_count 
                       toll_ind
                       passenger_count*LOG_fare
                       / ddfm=kr solution;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	*lsmeans month / adjust=tukey;
run;

title 'Log Model-response and fare logged';
proc glimmix data=cab plots=studentpanel;
	class pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id passenger_count;
	model log_tip = log_fare 
                       passenger_count 
                       toll_ind
                       / ddfm=kr solution;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
	*lsmeans month / adjust=tukey;
run;

/*title 'Log Model- fare, removing Months';
proc glimmix data=cab plots=studentpanel;
	class pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id;
	model log_tip = log_fare 
                       passenger_count  
                       toll_ind 
                       / ddfm=kr;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
run;*/

/*title 'Log Model- distance,removing Months';
proc glimmix data=cab plots=studentpanel;
	class pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id;
	model log_tip = log_dist 
                       passenger_count  
                       toll_ind 
                       / ddfm=kr;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
run;
title 'Log Model- adding rate code, keep months';
proc glimmix data=cab plots=studentpanel;
	class pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id rate_code month;
	model log_tip = log_fare 
                       passenger_count
                       month 
                       toll_ind
                       rate_code 
                       / ddfm=kr;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
run;
title 'Log Model- adding rate code';
proc glimmix data=cab plots=studentpanel;
	class pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id rate_code;
	model log_tip = log_fare 
                       passenger_count  
                       toll_ind
                       rate_code 
                       / ddfm=kr;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
run;


*add fare amount;
/*proc glimmix data=cab plots=studentpanel;
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
*remove months and log other continuous variables;
*add fare_amount;
*correlation between distance and fare amount=.96;
* tip and distance: .796;
* tip and fare: .816;
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
	model log_tip = log_dist 
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
run;*/
*ods graphics off;

ods pdf close;


ods pdf file = "best_models.pdf";
title 'Log Model-response and distance logged, month and toll interactions-- Best Model';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id rate_code passenger_count;
	model log_tip = log_dist 
                       passenger_count 
                       month 
                       toll_ind
                       rate_code
                       month*log_dist
                       toll_ind*log_dist
                       / ddfm=kr solution;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
*lsmeans month*LOG_DIST / slice=month slicediff = month adjust=tukey;
        
run;

title 'Best Model with time random effects removed';
proc glimmix data=cab plots=studentpanel;
	class month toll_ind pickup_location_id dropoff_location_id rate_code passenger_count;
	model log_tip = log_dist 
                       passenger_count 
                       month 
                       toll_ind
                       rate_code
                       month*log_dist
                       toll_ind*log_dist
                       / ddfm=kr solution;
	random pickup_location_id dropoff_location_id ;
*lsmeans month*LOG_DIST / slice=month slicediff = month adjust=tukey;
        
run;

ods pdf close;
ods graphics off;
