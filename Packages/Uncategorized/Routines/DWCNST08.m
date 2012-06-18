DWCNST08 ;NEW PROGRAM [ 04/28/97  8:35 AM ]
 ;WRITTEN BY DAN WALZ PIMC TO DISPLAY LOGIN USER'S
 ;CLINICAL CONSULTATIONS REQUESTS
 ;
 I '$D(DUZ) W !,"DUZ not set ABORTING..." H 3 Q
 I '$D(^VA(200,DUZ,0)) W "Unable to verify user. ABORTING..." H 3 Q
 S USR=$P(^VA(200,DUZ,0),"^",1)
 D ^DWSETSCR,^%AUCLS,HEAD,FQ G:$D(XIT) XIT D DTSEL G:Y<0 XIT D PRT
XIT K XIT,USR,IOP,DIR,EDT,SDT
 D KILL^DWSETSCR
 Q
 ;
PRT K IOP
 Q:'$D(FLDS)
 S DIC=1966180,L=0,BY=".01,'4",FR(1)=SDT,FR(2)=USR,TO(1)=EDT,TO(2)=USR
 S DHD="Consult Requests by "_USR_" from "_$E(SDT,4,5)_"/"_$E(SDT,6,7)_"/"_$E(SDT,2,3)_" to "_$E(EDT,4,5)_"/"_$E(EDT,6,7)_"/"_$E(EDT,2,3)_" *CONFIDENTIAL*"
 D EN1^DIP
 Q
 ;
HEAD W ?26,HI_"*****************************",!,?26,"*",?54,"*",!,?26,"* PIMC CONSULTATION REQUEST *",!,?26,"*",?54,"*",!,?26,"*",?31,"My Consult Requests",?54,"*",!,?26,"*",?54,"*",!,?26,"*****************************"_NO,!!!
 W IV_"Display consult requests by "_USR_NO,!
 Q         
FQ S DIR(0)="S^Q:Quick List;F:Full List",DIR("A")="Select the Type of Report ",DIR("B")="Q",DIR("?")="Select 'Q' for a short report, or 'F' for a full report."
 D ^DIR
 K DIR
 I $D(DTOUT)!($D(DUOUT)) S XIT="" Q
 S FLDS=$S(Y="Q":"[1966180-MY-REQUESTS-QUICK]",1:"[1966180-FULL]")
 Q
DTSEL S %DT="AE",%DT("A")="Enter STARTING consult date: ",%DT("B")="T-7"
 D ^%DT
 I Y<0 S XIT="" Q
 S SDT=+Y
 S %DT="AE",%DT("A")="Enter ENDING consult date: ",%DT("B")="T"
 D ^%DT
 I Y<0 S XIT="" Q
 S EDT=+Y
 I EDT<SDT W $C(7)," ?? - Invalid date pair!" G DTSEL
 Q
