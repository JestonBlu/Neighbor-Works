%LET DTA = '\\arpdnas01.nas.cat.com\userdata04\blubaj\cab_final.csv';

filename outpdf '\\arpdnas01.nas.cat.com\userdata04\blubaj\Final_Model_Full_Solution.pdf';
filename outpdf2 '\\arpdnas01.nas.cat.com\userdata04\blubaj\Final_Model_Reduced_Solution.pdf';

proc import datafile=&dta out=cab replace;
run;


data cab;
    set cab;
    log_tip = log(tip_amount + 1);
    log_dist = log(trip_distance);
    log_fare = log(fare_amount);
run;

/* Mixed Model with Random Var Dropoff Locations and Times */

ods pdf file=outpdf;
ods graphics on;


title 'Full Model';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id rate_code passenger_count;
	model log_tip = log_dist 
                        passenger_count 
                        month 
                        toll_ind
                        rate_code
                        passenger_count*month
                        passenger_count*toll_ind
                        passenger_count*rate_code
                        month*toll_ind
                        month*rate_code
                        toll_ind*rate_code
                        passenger_count*month*toll_ind
                        passenger_count*month*rate_code
                        passenger_count*toll_ind*rate_code
			month*toll_ind*rate_code
			passenger_count*month*toll_ind*rate_code
                        / ddfm=kr;
	random pickup_location_id dropoff_location_id pickup_time dropoff_time;
    output out=PRED pred=p resid=r pearson=presid;
run;


ods graphics off;
ods pdf close;


ods pdf file=outpdf2;
ods graphics on;

title 'Reduced Model';
proc glimmix data=cab plots=studentpanel;
	class month pickup_time dropoff_time toll_ind pickup_location_id dropoff_location_id rate_code passenger_count;
	model log_tip = log_dist 
                        passenger_count 
                        month 
                        toll_ind
                        rate_code
                        passenger_count*month
                        passenger_count*toll_ind
                        passenger_count*rate_code
                        month*toll_ind
                        month*rate_code
                        toll_ind*rate_code
                        passenger_count*month*toll_ind / ddfm=kr solution;
	random pickup_location_id dropoff_location_id dropoff_time / solution;
    output out=PRED pred=p resid=r pearson=presid;
	lsmeans passenger_count / adjust=tukey cl;
	lsmeans month / adjust=tukey cl;
	lsmeans toll_ind / adjust=tukey cl;
	lsmeans rate_code / adjust=tukey cl;
	lsmeans toll_ind*rate_code / cl adjust=tukey;
	lsmeans passenger_count*month*toll_ind / cl;
	lsmeans passenger_count*rate_code / adjust=tukey cl;
	lsmeans passenger_count*toll_ind / adjust=tukey cl;
run;

title 'Pearson Residuals';
proc univariate data=pred;
var presid;
run;


ods graphics off;
ods pdf close;