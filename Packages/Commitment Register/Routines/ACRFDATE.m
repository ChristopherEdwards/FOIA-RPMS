ACRFDATE ;IHS/OIRM/DSD/THL,AEF - UTILITY TO SET BEGINNING AND ENDING DATES; [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;UTILITY TO SET BEGINNING AND ENDING DATES
 ;
DATES ;EP;TO SET DATES
 S DIR(0)="DO^::E"
 S DIR("A")="Beginning Date"
 S DIR("?")="Enter the earliest date you want to include."
 D DIR^ACRFDIC
 I $E(X)[U S ACRQUIT="" Q
 K ACRQUIT
 S ACRBEGIN=+Y
 S ACREND=""
 I ACRBEGIN D  Q:$D(ACRQUIT)
 . S DIR(0)="DO^::E"
 .S DIR("A")="Ending Date..."
 .S DIR("?",1)="Enter the latest date you want to include."
 .S DIR("?")="Do not enter any date if you want to include all dates."
 .D DIR^ACRFDIC
 .I $E(X)[U S ACRQUIT="" Q
 .K ACRQUIT
 .S ACREND=$S('Y:DT,1:Y)
 Q
