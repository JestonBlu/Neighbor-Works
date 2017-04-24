 %LET DTA = 'cab_final2.csv';
libname out "/cm/home/m1srn00/FIN/STAT653/project/part2";
proc import datafile=&dta out=cab replace;
run;

*proc contents data = cab; run;
ods pdf file = "interaction_models.pdf";
data cab;
    set cab;
    log_tip = log(tip_amount + 1);
    log_dist = log(trip_distance);
    log_fare = log(fare_amount);
run;

/* Mixed Model with Random Var Dropoff Locations and Times */
ods graphics on;
ods listing close;
ods output SolutionR = out.RandomEffects
title 'Log Model-response and distance logged, month and toll interactions-- Best Model';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time 
	toll_ind pickup_location_id dropoff_location_id 
 	rate_code;
	model log_tip = log_dist 
                        passenger_count 
                        month 
                        toll_ind
                        rate_code
                        passenger_count*month
                        passenger_count*toll_ind
                        passenger_count*rate_code
                        passenger_count*log_dist
                        month*toll_ind
                        month*rate_code
                        month*log_dist
                        toll_ind*rate_code
                        toll_ind*log_dist
                        rate_code*log_dist
                        passenger_count*month*toll_ind
                        passenger_count*month*rate_code
                        passenger_count*month*log_dist
                        passenger_count*toll_ind*rate_code
                        passenger_count*toll_ind*log_dist
                        passenger_count*rate_code*log_dist
                        month*toll_ind*rate_code
                        month*toll_ind*log_dist
                        month*rate_code*log_dist
                        passenger_count*month*toll_ind*rate_code
                        passenger_count*month*toll_ind*log_dist
                        passenger_count*rate_code*toll_ind*log_dist
                        month*toll_ind*log_dist*rate_code
                        passenger_count*rate_code*toll_ind*log_dist*month
                        / ddfm=kr solution;
	random pickup_location_id 
                        dropoff_location_id 
                        pickup_time 
                        dropoff_time /solution;
      output out=PRED pred=p resid=r pearson=presid;
      *lsmeans passenger_count / oddsratio adjust=tukey cl;
      lsmeans month / oddsratio adjust=tukey cl;
      lsmeans toll_ind / oddratio adjust=tukey cl;
      lsmeans rate_code / oddsratio adjust=tukey cl;  
run;
ods listing;

title 'Log Model-response and distance logged, month and toll interactions-- Best Model';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time 
	toll_ind pickup_location_id dropoff_location_id 
 	rate_code;
	model log_tip = log_dist 
                        passenger_count 
                        month 
                        toll_ind
                        rate_code
                        passenger_count*month
                        passenger_count*toll_ind
                        passenger_count*rate_code
                        passenger_count*log_dist
                        month*toll_ind
                        month*rate_code
                        month*log_dist
                        toll_ind*rate_code
                        toll_ind*log_dist
                        rate_code*log_dist
                        /*passenger_count*month*toll_ind*/
                        passenger_count*month*rate_code
                        passenger_count*month*log_dist
                        /*passenger_count*toll_ind*rate_code*/
                        /*passenger_count*toll_ind*log_dist*/
                        /*passenger_count*rate_code*log_dist*/
                        /*month*toll_ind*rate_code*/
                        /*month*toll_ind*log_dist*/
                        /*month*rate_code*log_dist*/
                        / ddfm=kr solution;
	random pickup_location_id 
                        dropoff_location_id 
                        pickup_time 
                        dropoff_time /solution;
      output out=PRED pred=p resid=r pearson=presid;
      *lsmeans passenger_count / oddsratio adjust=tukey cl;
      lsmeans month / oddsratio adjust=tukey cl;
      lsmeans toll_ind / oddratio adjust=tukey cl;
      lsmeans rate_code / oddsratio adjust=tukey cl;  
run;

title 'Log Model-response and distance logged, month and toll interactions-- Best Model';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time 
		  toll_ind pickup_location_id dropoff_location_id 
 		  rate_code passenger_count;
	model log_tip = log_dist 
                       passenger_count 
                       month 
                       toll_ind
                       rate_code
		       passenger_count*month
		       passenger_count*toll_ind
		       passenger_count*rate_code
		       passenger_count*log_dist
		       month*toll_ind
		       month*rate_code
                       month*log_dist
		       toll_ind*rate_code
                       toll_ind*log_dist
		       rate_code*log_dist
		       passenger_count*month*toll_ind
		       passenger_count*month*rate_code
		       passenger_count*toll_ind*rate_code
		       month*toll_ind*rate_code
                       / ddfm=kr;
	random pickup_location_id 
			dropoff_location_id 
			pickup_time 
			dropoff_time;    
run;
/*title 'Best Model with time random effects removed';
proc glimmix data=cab plots=studentpanel;
	class month toll_ind pickup_location_id dropoff_location_id rate_code;
	model log_tip = log_dist 
                       passenger_count 
                       month 
                       toll_ind
                       rate_code
                       month*log_dist
                       toll_ind*log_dist
   		       month*toll_ind*passenger_count
                       / ddfm=kr solution;
	random pickup_location_id dropoff_location_id dropoff_time;
	output out=PRED pred=p resid=r pearson=presid;
	lsmeans passenger_count / oddsratio adjust=tukey cl;
	lsmeans month / oddsratio adjust=tukey cl;
	lsmeans toll_ind / oddratio adjust=tukey cl;
	lsmeans rate_code / oddsratio adjust=tukey cl;
run;

PROC UNIVARIATE data=pred;
var presid;
run;
*/
ods graphics off;
ods pdf close;
