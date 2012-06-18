DWCNST04 ;NEW PROGRAM [ 11/13/96  11:18 AM ]
 ;WRITTEN BY DAN WALZ PIMC TO DISPLAY LOGIN USER'S ACTIVE
 ;CLINICAL CONSULTATIONS
 ;
 I '$D(DUZ) W !,"DUZ not set ABORTING..." H 3 Q
 I '$D(^VA(200,DUZ,0)) W "Unable to verify user. ABORTING..." H 3 Q
 S USR=$P(^VA(200,DUZ,0),"^",1)
 D ^DWSETSCR,^%AUCLS,HEAD,FQ G:$D(XIT) XIT D PRT
XIT K XIT,USR,IOP,DIR
 D KILL^DWSETSCR
 Q
 ;
PRT K IOP
 Q:'$D(FLDS)
 S DIC=1966180,L=0,BY="3,16,.01;S1",FR(1)="A",FR(2)=USR,FR(3)=2900101,TO(1)="A",TO(2)=USR,TO(3)=3901231
 S DHD="Active Consults for "_USR_".  ( **CONFIDENTIAL** )"
 D EN1^DIP
 Q
 ;
HEAD W ?26,HI_"*****************************",!,?26,"*",?54,"*",!,?26,"* PIMC CONSULTATION REQUEST *",!,?26,"*",?54,"*",!,?26,"*",?32,"My Active Consults",?54,"*",!,?26,"*",?54,"*",!,?26,"*****************************"_NO,!!!
 W IV_"Display ACTIVE consults for "_USR_NO,!
 Q         
FQ S DIR(0)="S^Q:Quick List;F:Full List",DIR("A")="Select the Type of Report ",DIR("B")="Q",DIR("?")="Select 'Q' for a short report, or 'F' for a full report."
 D ^DIR
 K DIR
 I $D(DTOUT)!($D(DUOUT)) S XIT="" Q
 S FLDS=$S(Y="Q":"[1966180-MY-ACTIVE-QUICK]",1:"[1966180-FULL]")
 Q
