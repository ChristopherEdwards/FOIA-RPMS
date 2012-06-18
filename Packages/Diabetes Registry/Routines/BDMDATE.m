BDMDATE ; cmi/anch/maw - UTILITY TO SET BEGINNING AND ENDING DATES ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;;AUG 11, 2006
 ;UTILITY TO SET BEGINNING AND ENDING DATES
 ;
DATES ;EP;TO SET DATES
 S DIR(0)="DO"
 S DIR("A")="Beginning Date"
 S DIR("?")="Enter the earliest date you want to include."
 W !
 D DIR^BDMFDIC
 I Y<1 S BDMQUIT="" Q
 K BDMQUIT
 S BDMBEGIN=+Y
 S BDMEND=""
 I BDMBEGIN D  Q:$D(BDMQUIT)
 .S DIR(0)="DO"
 .S DIR("A")="Ending Date..."
 .S DIR("?",1)="Enter the latest date you want to include."
 .S DIR("?")="Do not enter any date if you want to include all dates."
 .D DIR^BDMFDIC
 .I $E(X)[U S BDMQUIT="" Q
 .K BDMQUIT
 .S BDMEND=$S('Y:DT,1:Y)
 Q
