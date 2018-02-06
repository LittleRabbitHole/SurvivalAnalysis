option nodate nocenter;

%include "C:\Users\yingding.PITT\Box Sync\Biost2054\Program\data_Sec1_3.sas"; 

/*proc contents; run;*/
/*proc print data = bone_marrow; run;*/

data all;
  set bone_marrow;
  if g = 1;
run;

proc sql;
  create table summary as
  select  t2, sum(dfree) as num_event, count(t2) as sub_total from all
  group by t2;
proc print data = summary; run;

data summary2;
  set summary ;
  lagtotal = lag(sub_total);
  * survival function;
  retain num_risk 38;
  if _n_ > 1 then do;
  num_risk = num_risk - lagtotal; end;
  if num_event~=0;
  retain surv 1 varpart2 0;
  surv = surv*(1-num_event/num_risk);
  varpart2 = varpart2 + num_event/(num_risk*(num_risk-num_event));
  var =(surv**2)*varpart2;
  stderrS = var**.5;
  linear = (surv-.5)/stderrS;
  logtrans = (log(-log(surv))-log(-log(.5)))*surv*log(surv)/stderrS;
  arcsinetrans = 2*(arsin(surv**.5)-arsin(.5**.5))*(surv*(1-surv))**.5/stderrS;
  keep t2 num_event num_risk surv stderrS linear logtrans arcsinetrans;
run;

ods rtf file="E:\Teaching\STAT2261\Spring2017\notes\Ch4_NparEstBasicQuantities\Table4_7.rtf";
title "Example 4.2";
proc print data = summary2 noobs;
run;
ods rtf close;

