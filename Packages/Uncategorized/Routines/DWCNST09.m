DWCNST09 ;NEW PROGRAM [ 07/07/1999  11:13 AM ]
 ;WRITTEN BY DAN WALZ PIMC TO DISPLAY LOGIN USER'S SERVICE
 ;CLINICAL CONSULTATIONS BY DATE RANGE
 ;
 I '$D(DUZ) W !,"DUZ not set ABORTING..." H 3 D XIT Q
 I '$D(^VA(200,DUZ,0)) W "Unable to verify user. ABORTING..." H 3 D XIT Q
 S USR=$P(^VA(200,DUZ,0),"^",1)
 ;
 ;switch service if user found in ^DWNCST03 1966195
 K SVCN I $D(^DWCNST03("B",DUZ)) D OTHER
 ;
 ;the following line is temporary remove after Dr. Hays is
 ;no longer acting chief of OB/GYN
 ;;;I DUZ=1483 W !!,"Dr. Hays, run this report for OB/GYN rather than Anesthesia" S %=2 D YN^DICN I %=1 S SVCN=40
 ;the following line needed while Dr. M. Horton is chief of both 
 ;SERVICE/SECTION:  `23 OPHTHALMOLOGY       `24 OTOLARYNGOLOGY (ENT)
 ;I DUZ=975 W !!,"Dr. Horton, run this report for ENT rather than EYE" S %=2 D YN^DICN I %=1 S SVCN=24
 I DUZ=975 W !!,"Dr. Horton, run this report for EYE rather than ENT" S %=2 D YN^DICN I %=1 S SVCN=23
 ;end temporary lines
 ;
 I '$D(SVCN) I '$D(^VA(200,DUZ,5)) W "Unable to locate Service - ABORTING.." H 3 D XIT Q
 I '$D(SVCN) S SVCN=+^(5) I SVCN=0 W "Unable to locate Service - ABORTING.." H 3 D XIT Q
 I '$D(^DIC(49,SVCN,0)) W "Unable to locate Service - ABORTING.." H 3 D XIT Q
 S SVC=$P(^(0),"^",1)
 ;
 D ^DWSETSCR,^%AUCLS,HEAD,FQ G:$D(XIT) XIT D DTSEL^DWCNST08 G:Y<0 XIT D PRT
XIT K XIT,USR,IOP,SVCN,SVC,DIR,OSIE,SDT,EDT,%
 D KILL^DWSETSCR
 Q
 ;
PRT K IOP
 Q:'$D(FLDS)
 S DIC=1966180,L=0,BY="1,.01;S1",FR(1)=SVC,FR(2)=SDT,TO(1)=SVC,TO(2)=EDT
 S DHD="All Consults for "_SVC_" Service from "_$E(SDT,4,5)_"/"_$E(SDT,6,7)_"/"_$E(SDT,2,3)_" to "_$E(EDT,4,5)_"/"_$E(EDT,6,7)_"/"_$E(EDT,2,3)_" **CONFIDENTIAL**"
 D EN1^DIP
 Q
 ;
HEAD W ?26,HI_"*****************************",!,?26,"*",?54,"*",!,?26,"* PIMC CONSULTATION REQUEST *",!,?26,"*",?54,"*",!,?26,"*",?28,"Service Consults by date",?54,"*",!,?26,"*",?54,"*",!,?26,"*****************************"_NO,!!!
 W IV_"Display consults for "_SVC_" by selected date(s)"_NO,!
 Q         
FQ S DIR(0)="S^Q:Quick List;F:Full List",DIR("A")="Select the Type of Report ",DIR("B")="Q",DIR("?")="Select 'Q' for a short report, or 'F' for a full report."
 D ^DIR
 K DIR
 I $D(DTOUT)!($D(DUOUT)) S XIT="" Q
 S FLDS=$S(Y="Q":"[1966180-MY-REQUESTS-QUICK]",1:"[1966180-FULL]")
 Q
OTHER ;replace usual service with the entry in ^DWCNST03 1966195 
 S OSIE=+$O(^DWCNST03("B",DUZ,0))
 I '$D(^DWCNST03(OSIE,0)) Q
 S SVCN=+$P(^(0),"^",2) I SVCN=0 K SVCN
 ;the following line is temporary remove after Dr. Hays is
 ;no longer acting chief of OB/GYN
 I DUZ=1483 W !!,"Dr. Hays, run this report to OB/GYN rather than Anesthesia" S %=2 D YN^DICN I %=1 S SVCN=40
 Q
