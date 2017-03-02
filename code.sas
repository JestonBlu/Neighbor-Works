*Question 1;
data heart;
 input patient sequence $ visit basehr basefev1 hr1h fev11h 
        drug $ cop cob coa;
datalines;
201        B         2        92      2.14       84    2.36     p      0     0     0
201        B         3        92      2.30      104    3.41     c      1     0     0
201        B         4        68      2.46       72    2.68     a      0     1     0
202        E         2        54      2.91       64    3.92     c      0     0     0
202        E         3        64      3.37       54    3.03     p      0     1     0
202        E         4        80      3.50       72    3.95     a      1     0     0
203        F         2        84      1.88       82    1.99     p      0     0     0
203        F         3        84      2.08       74    2.52     a      1     0     0
203        F         4        88      1.96       84    2.28     c      0     0     0
204        D         2        72      3.44       72    4.08     a      0     0     1
204        D         3        78      3.02       98    4.43     c      0     0     1
204        D         4        96      3.10       80    3.24     p      0     1     0
205        C         2        80      3.26       72    4.55     c      0     0     0
205        C         3        96      2.80       64    4.09     a      0     1     0
205        C         4        72      2.91       60    3.35     p      0     0     1
206        B         2        68      2.29       62    3.04     p      0     0     0
206        B         3        80      2.29       88    4.25     c      1     0     0
206        B         4        64      2.36       78    3.79     a      0     1     0
207        A         2       100      1.77       68    3.82     a      0     0     0
207        A         3        78      2.20       80    2.46     p      0     0     1
207        A         4       106      1.96      100    3.00     c      1     0     0
208        A         2        60      2.64       56    3.67     a      0     0     0
208        A         3        60      2.70       56    2.85     p      0     0     1
208        A         4        72      2.70       60    4.06     c      1     0     0
209        D         2        88      2.30       84    4.12     a      0     0     0
209        D         3       102      2.50       84    4.37     c      0     0     1
209        D         4        84      2.25       86    3.45     p      0     1     0
210        C         2        92      2.35       80    2.83     c      0     0     0
210        C         3        76      2.27       64    2.77     a      0     1     0
210        C         4        64      2.48       60    2.56     p      0     0     1
211        E         2        88      2.34       78    4.06     c      0     0     0
211        E         3        86      2.12       76    2.19     p      0     1     0
211        E         4        78      2.44       68    3.77     a      1     0     0
212        F         2       102      2.37       88    2.14     p      0     0     0
212        F         3        98      2.04       86    2.00     a      1     0     0
212        F         4        88      2.20       86    2.82     c      0     0     1
214        D         2        84      2.77       80    3.36     a      0     0     0
214        D         3        78      2.78       78    3.18     c      0     0     1
214        D         4        82      2.73       76    2.57     p      0     1     0
215        E         2       104      3.43       84    4.39     c      0     0     0
215        E         3        92      3.15       84    2.90     p      0     1     0
215        E         4        76      2.96       72    4.31     a      1     0     0
216        A         2        92      3.11       64    3.88     a      0     0     0
216        A         3        72      2.52       68    3.02     p      0     0     1
216        A         4        80      3.07       88    3.90     c      1     0     0
217        B         2        92      1.48       84    1.35     p      0     0     0
217        B         3        96      1.21       96    2.31     c      1     0     0
217        B         4        88      1.47       84    1.97     a      0     1     0
218        A         2        72      2.73       76    2.91     a      0     0     0
218        A         3        88      2.52       84    2.61     p      0     0     1
218        A         4        92      2.60      100    3.19     c      1     0     0
219        E         2        72      2.61       80    3.54     c      0     0     0
219        E         3        84      2.90       78    2.91     p      0     1     0
219        E         4        80      3.25       88    3.59     a      1     0     0
220        F         2        80      2.83       78    2.78     p      0     0     0
220        F         3        84      2.73       72    2.88     a      1     0     0
220        F         4        76      2.48       72    2.99     c      0     0     1
221        B         2        72      3.50       68    3.81     p      0     0     0
221        B         3        80      3.73       60    4.37     c      1     0     0
221        B         4        68      3.30       60    4.04     a      0     1     0
222        C         2        88      2.54       88    3.26     c      0     0     0
222        C         3        96      2.85       96    3.38     a      0     1     0
222        C         4        82      2.86       80    3.06     p      0     0     1
223        C         2        88      2.83       80    4.72     c      0     0     0
223        C         3        72      2.72       76    4.49     a      0     1     0
223        C         4        96      2.42       80    2.87     p      0     0     1
224        F         2        88      3.66       64    3.98     p      0     0     0
224        F         3        80      3.68       80    4.17     a      1     0     0
224        F         4        88      3.47       80    4.27     c      0     0     1
232        D         2        78      2.49       68    3.73     a      0     0     0
232        D         3        88      2.79       84    4.10     c      0     0     1
232        D         4        80      2.88       80    3.04     p      0     1     0
;
run;

ODS graphics on;
ods pdf file="output.pdf";

proc sgplot data=heart;
    reg y=hr1h x=basehr / group=drug visit sequence;
run;


proc sgplot data=heart;
    reg y=hr1h x=basehr / group=drug;
run;

proc sgplot data=heart;
    reg y=hr1h x=basehr / group=visit;
run;


proc sgplot data=heart;
    reg y=hr1h x=basehr / group=sequence;
run;

proc mixed data=heart; 
   class drug visit sequence patient;
   model hr1h=basehr drug visit sequence basehr*drug basehr*visit basehr*sequence / ddfm=kr solution outpred=pred;
   random patient;
   estimate 'slope for seq E '  basehr 1 basehr*sequence 0 0 0 0 1 0 basehr*drug 0 1 0 basehr*visit 1 0 0 ;
   /*estimate 'slope for drug c' basehr 1  basehr*drug 0 1 0;
   estimate 'slope for visit 2' basehr 1 basehr*visit 1 0 0;*/
   lsmeans drug/ at basehr=54;
   lsmeans visit/ at basehr=54;
   lsmeans sequence/ at basehr=54;
run; 

proc mixed data=heart; 
   class drug visit sequence patient;
   model hr1h=basehr drug visit sequence basehr*drug basehr*sequence / ddfm=kr solution outpred=pred;
   random patient;
run;


proc mixed data=heart; 
   class drug visit sequence patient;
   model hr1h=basehr drug visit sequence basehr*drug / ddfm=kr solution outpred=pred;
   random patient;
run;

proc mixed data=heart; 
   class drug visit sequence patient;
   model hr1h=basehr drug visit sequence / ddfm=kr solution outpred=pred;
   random patient;
   lsmeans drug / diff;
   lsmeans drug / at basehr=100 diff;
   lsmeans drug / at basehr=72 diff;
run;


*Question 2;
data sscores;
   input  material $ teacher $ student $  score  ;
datalines;
  A  1  1  92
  A  1  2  93
  A  1  3  88
  A  1  4  91
  A  1  5  95
  A  1  6  89
  A  2  1  94
  A  2  2  86
  A  2  3  91
  A  2  4  98
  A  2  5  82
  A  2  6  95
  A  3  1  91
  A  3  2  99
  A  3  3  92
  A  3  4 100
  A  3  5  92
  A  3  6  88
  A  4  1  91
  A  4  2  99
  A  4  3  97
  A  4  4  98
  A  4  5  94
  A  4  6  97
  A  5  1  92
  A  5  2  90
  A  5  3  91
  A  5  4  89
  A  5  5  95
  A  5  6  90
  B  1  1 104
  B  1  2 102
  B  1  3 102
  B  1  4 105
  B  1  5 106
  B  1  6 106
  B  2  1  85
  B  2  2  86
  B  2  3  79
  B  2  4  88
  B  2  5  79
  B  2  6  86
  B  3  1  84
  B  3  2  83
  B  3  3  87
  B  3  4  86
  B  3  5  87
  B  3  6  86
  B  4  1  85
  B  4  2  73
  B  4  3  83
  B  4  4  78
  B  4  5  82
  B  4  6  86
  B  5  1  92
  B  5  2  93
  B  5  3  86
  B  5  4  88
  B  5  5  85
  B  5  6  87
  C  1  1  98
  C  1  2  98
  C  1  3  97
  C  1  4 106
  C  1  5  97
  C  1  6  96
  C  2  1  92
  C  2  2  90
  C  2  3  98
  C  2  4  85
  C  2  5  87
  C  2  6  86
  C  3  1  86
  C  3  2  86
  C  3  3  92
  C  3  4  91
  C  3  5  76
  C  3  6  89
  C  4  1  95
  C  4  2  86
  C  4  3  80
  C  4  4  76
  C  4  5  85
  C  4  6  85
  C  5  1  80
  C  5  2  80
  C  5  3  89
  C  5  4  75
  C  5  5  79
  C  5  6  85
  D  1  1 100
  D  1  2  92
  D  1  3  87
  D  1  4  95
  D  1  5  98
  D  1  6  95
  D  2  1  92
  D  2  2  91
  D  2  3  99
  D  2  4  89
  D  2  5  89
  D  2  6  86
  D  3  1  80
  D  3  2  83
  D  3  3  82
  D  3  4  89
  D  3  5  82
  D  3  6  80
  D  4  1  92
  D  4  2  91
  D  4  3  85
  D  4  4  84
  D  4  5  92
  D  4  6  93
  D  5  1  90
  D  5  2  95
  D  5  3  92
  D  5  4  89
  D  5  5  88
  D  5  6  94
  ;
run;

proc mixed data=sscores cl;
class material teacher;
model score=material;
random teacher(material);
run;


proc mixed data=sscores cl method=type3 ;
class material teacher;
model score=material  ;
random teacher(material);
run;

ods pdf close;


