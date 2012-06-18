DWCNST05 ;NEW PROGRAM [ 04/11/97  8:32 AM ]
 ;WRITTEN BY DAN WALZ PIMC TO DISPLAY LOGIN USER'S SERVICE ACTIVE
 ;CLINICAL CONSULTATIONS
 ;
 I '$D(DUZ) W !,"DUZ not set ABORTING..." H 3 D XIT Q
 I '$D(^VA(200,DUZ,0)) W "Unable to verify user. ABORTING..." H 3 D XIT Q
 S USR=$P(^VA(200,DUZ,0),"^",1)
 ;switch service if user found in ^DWNCST03 1966195
 K SVCN I $D(^DWCNST03("B",DUZ)) D OTHER
 I '$D(SVCN) I '$D(^VA(200,DUZ,5)) W "Unable to locate Service - ABORTING.." H 3 D XIT Q
 I '$D(SVCN) S SVCN=+^(5) I SVCN=0 W "Unable to locate Service - ABORTING.." H 3 D XIT Q
 I '$D(^DIC(49,SVCN,0)) W "Unable to locate Service - ABORTING.." H 3 D XIT Q
 S SVC=$P(^(0),"^",1)
 ;
 D ^DWSETSCR,^%AUCLS,HEAD,FQ G:$D(XIT) XIT D PRT
XIT K XIT,USR,IOP,SVCN,SVC,DIR,OSIE
 D KILL^DWSETSCR
 Q
 ;
PRT K IOP
 Q:'$D(FLDS)
 S DIC=1966180,L=0,BY="3,1,.01;S1",FR(1)="A",FR(2)=SVC,FR(3)=2900101,TO(1)="A",TO(2)=SVC,TO(3)=3901231
 S DHD="Active Consults for "_SVC_" Service.  ( **CONFIDENTIAL** )"
 D EN1^DIP
 Q
 ;
HEAD W ?26,HI_"*****************************",!,?26,"*",?54,"*",!,?26,"* PIMC CONSULTATION REQUEST *",!,?26,"*",?54,"*",!,?26,"*",?28,"My Service Active Cnslts",?54,"*",!,?26,"*",?54,"*",!,?26,"*****************************"_NO,!!!
 W IV_"Display ACTIVE consults for "_SVC_NO,!
 Q         
FQ S DIR(0)="S^Q:Quick List;F:Full List",DIR("A")="Select the Type of Report ",DIR("B")="Q",DIR("?")="Select 'Q' for a short report, or 'F' for a full report."
 D ^DIR
 K DIR
 I $D(DTOUT)!($D(DUOUT)) S XIT="" Q
 S FLDS=$S(Y="Q":"[1966180-MY-ACTIVE-QUICK]",1:"[1966180-FULL]")
 Q
OTHER ;replace usual service with the entry in ^DWCNST03 1966195 
 S OSIE=+$O(^DWCNST03("B",DUZ,0))
 I '$D(^DWCNST03(OSIE,0)) Q
 S SVCN=+$P(^(0),"^",2) I SVCN=0 K SVCN
 Q
