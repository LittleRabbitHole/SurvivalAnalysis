option nodate nocenter;

data sec1_2;
  input pair status time_p time_6mp censor; 
  * relapse time, no censoring in placebo;
  datalines;
1  1  1 10 1
2  2  22 7 1
3  2  3 32 0
4  2 12 23 1
5  2  8 22 1
6  1 17  6 1
7  2  2 16 1
8  2 11 34 0
9  2  8 32 0
10 2 12 25 0
11 2  2 11 0
12 1  5 20 0
13 2  4 19 0
14 2  15 6 1
15 2  8 17 0
16 1 23 35 0
17 1  5  6 1
18 2 11 13 1
19 2  4  9 0
20 2  1  6 0
21 2  8 10 0
; 
* status 1: partial remission, 2: complete remission;
proc print;run;

*this is to create the calculation table
proc sql;
  create table raw_data as
  select  time_6mp, sum(censor) as num_event, count(time_6mp) as sub_total from sec1_2
  group by time_6mp;
*automatic sorting
proc print data = raw_data; run;


data raw_data1;
  set raw_data ;
  lagtotal = lag(sub_total); * bring the previous record to be the current record;
run;
*lag is to shift one row down

data raw_data2;
  set raw_data1;
  * survival function: K-M estimator;
  retain num_risk 21; *total n =21
  if _n_ > 1 then do;
  num_risk = num_risk - lagtotal; end; *lagtotal is the previous
  if num_event~=0;
  retain surv 1 varpart2 0; 
  surv = surv*(1-num_event/num_risk);
  varpart2 = varpart2 + num_event/(num_risk*(num_risk-num_event));
  var =(surv**2)*varpart2;
  stderrS = var**.5;
  * cumulative hazard function: N-A estimator;
  retain cumhazard sigma2 0;
  cumhazard = cumhazard + num_event/num_risk;
  sigma2 = sigma2 + num_event/num_risk**2;
  stderrH=sigma2**.5;
  keep time_6mp num_event num_risk surv stderrS cumhazard stderrH;
run;

*ods rtf file="C:\Users\Ying Ding\Box Sync\Biost2054\Notes\Ch4_NparEstBasicQuantities\Table4_1.rtf";
*title "Example 4.1";
proc print data = raw_data2 noobs;
run;
*ods rtf close;

