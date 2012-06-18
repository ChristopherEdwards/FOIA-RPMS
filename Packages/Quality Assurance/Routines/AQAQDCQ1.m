AQAQDCQ1 ;IHS/ANMC/LJF - QUEUE DELINQUENT CHARTS BY PROV; [ 05/27/92  11:22 AM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
 ;***> set # of working days
 S X1=DT,X2=-30 D C^%DTC S AQAQDEL=X  ;# of working days
 ;
 S AQAQADD=1  ;let calculate know this is rtn to add data to file
 ;
 G ^AQAQDCC   ;go to claculate rtn
