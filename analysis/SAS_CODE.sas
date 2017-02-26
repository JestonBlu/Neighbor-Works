libname dta '\\arpdnas01.nas.cat.com\userdata04\blubaj';

data dta;
set dta.ReducedData;
run;


* Full Model;
proc mixed;
class Neighborhood_ID SatLevelCat RecommendCat ParticipationScoreCat 
	  PoliceRatingCat TrashRatingCat SnowRemovalCat FeelSafeDayCat 
	  FeelSafeNightCat OwnRent Gender Race;
model Years_Adj = Neighborhood_ID SatLevelCat RecommendCat ParticipationScoreCat 
	  PoliceRatingCat TrashRatingCat SnowRemovalCat FeelSafeDayCat FeelSafeNightCat 
	  OwnRent Gender Race Age;
run;

/* Didnt include all of the code for removing the variables on by one */

* Final Model;
proc mixed data=dta covtest;
class PoliceRatingCat FeelSafeDayCat OwnRent;
model Years_Adj = PoliceRatingCat FeelSafeDayCat OwnRent Age Age*OwnRent / CL DDFM=KR solution;
lsmeans PoliceRatingCat FeelSafeDayCat OwnRent / adjust=tukey diff;
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
