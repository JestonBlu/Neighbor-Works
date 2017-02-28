libname dta '\\arpdnas01.nas.cat.com\userdata04\blubaj';

data dta;
set dta.ReducedData;
Years_log = log(Years_Adj);
run;

* Final Model;
proc mixed data=dta covtest;
class PoliceRatingCat FeelSafeDayCat OwnRent Neighborhood_id TrashRatingCat;
model Years_log = Age OwnRent PoliceRatingCat FeelSafeDayCat TrashRatingCat Neighborhood_ID / CL DDFM=KR solution;
lsmeans PoliceRatingCat FeelSafeDayCat OwnRent Neighborhood_ID / adjust=tukey diff;
contrast 'Neighborhood 1,2,3 vs 4' neighborhood_id -1 -1 -1  3;
contrast 'Neighborhood 1,2,4 vs 3' neighborhood_id -1 -1  3 -1;
contrast 'Neighborhood 1,3,4 vs 2' neighborhood_id -1  3 -1 -1;
contrast 'Neighborhood 2,3,4 vs 1' neighborhood_id  3 -1 -1 -1;
run;

/* Regression Plots */
proc sgplot data=dta;
reg x=Age y=Years_adj / group=Policeratingcat;
run;
proc sgplot data=dta;
reg x=Age y=Years_adj / group=FeelSafeDayCat;
run;
proc sgplot data=dta;
reg x=Age y=Years_adj / group=OwnRent;
run;
