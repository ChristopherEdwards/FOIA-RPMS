AQAQDCQ ;IHS/ANMC/LJF - QUEUE DELINQUENT CHARTS BY PROV; [ 07/09/1999  2:28 PM ]
 ;;2.2;STAFF CREDENTIALS;**8**;JULY 9, 1999
 ;;AQAQ*2*8;Y2K FIX;CS;2990708
 ;
 W !!!?20,"DELINQUENT CHARTS BY PROVIDER",!!
 ;***> set # of working days
 S X1=DT,X2=-$$LMT S:X2=0 X2=-30 D C^%DTC S AQAQDEL=X ;PATCH FOR MAS5
 W !!?15,"Charts with a discharge date earlier than "
 ;BEGIN Y2K FIX BLOCK
 ;W !?29,$E(AQAQDEL,4,5)_"/"_$E(AQAQDEL,6,7)_"/"_$E(AQAQDEL,2,3)
 W !?29,$E(AQAQDEL,4,5)_"/"_$E(AQAQDEL,6,7)_"/"_($E(AQAQDEL,1,3)+1700) ; Y2000
 ;END Y2K FIX BLOCK
 W !?20,"will be considered delinquent!",!!
 ;
 S AQAQADD=0  ;let calculate know this is review, not add to file
 ;
 ;***> get print device
DEV S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^AQAQDCC
QUE K IO("Q") S ZTRTN="^AQAQDCC",ZTDESC="DELQNT CHARTS"
 S ZTSAVE("AQAQDEL")="",ZTSAVE("AQAQADD")=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
 ;
END K DIR,AQAQDEL D HOME^%ZIS Q
 ;
LMT() ; -- returns # of days til chart is delinquent;PATCH FOR MAS5
 Q $$VAL^XBDIQ1(43,1,9999999.23)
