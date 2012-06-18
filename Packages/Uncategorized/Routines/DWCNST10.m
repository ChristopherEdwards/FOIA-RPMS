DWCNST10 ;NEW PROGRAM [ 07/16/97  1:04 PM ]
 ;WRITTEN BY DAN WALZ PIMC TO DISPLAY LOGIN USER'S SERVICE
 ;CLINICAL CONSULTATIONS BY DATE RANGE
 ;
 I '$D(DUZ) W !,"DUZ not set ABORTING..." H 3 D XIT Q
 I '$D(^VA(200,DUZ,0)) W "Unable to verify user. ABORTING..." H 3 D XIT Q
 S USR=$P(^VA(200,DUZ,0),"^",1)
 ;
 D ^DWSETSCR,^%AUCLS,HEAD,WARD Q:WARD=0  D FQ G:$D(XIT) XIT  D DTSEL^DWCNST08 G:Y<0 XIT D PRT
 
XIT K XIT,USR,IOP,DIR,OSIE,SDT,EDT,%,WARD
 D KILL^DWSETSCR
 Q
 ;
PRT K IOP
 Q:'$D(FLDS)
 S DIC=1966180,L=0,BY="11,'.01,8",FR(1)=WARD,FR(2)=SDT,TO(1)=WARD,TO(2)=EDT,FR(3)="A",TO(3)="ZZZZZZZZZZZZZ"
 S DHD="All inpatient consults for "_WARD_" from "_$E(SDT,4,5)_"/"_$E(SDT,6,7)_"/"_$E(SDT,2,3)_" to "_$E(EDT,4,5)_"/"_$E(EDT,6,7)_"/"_$E(EDT,2,3)_" **CONFIDENTIAL**"
 D EN1^DIP
 Q
 ;
HEAD W ?26,HI_"*****************************",!,?26,"*",?54,"*",!,?26,"* PIMC CONSULTATION REQUEST *",!,?26,"*",?54,"*",!,?26,"*",?28," Ward Consults by Date  ",?54,"*",!,?26,"*",?54,"*",!,?26,"*****************************"_NO,!!!
 W HI_"The report will include ONLY current inpatients for the selected ward.",!!,"Use the consult patient INQUIRY option to display consults for discharged",!,"patients or outpatient consults."_NO,!!
 Q         
FQ S DIR(0)="S^Q:Quick List;F:Full List",DIR("A")="Select the Type of Report ",DIR("B")="Q",DIR("?")="Select 'Q' for a short report, or 'F' for a full report."
 D ^DIR
 K DIR
 I $D(DTOUT)!($D(DUOUT)) S XIT="" Q
 S FLDS=$S(Y="Q":"[1966180-MY-REQUESTS-QUICK]",1:"[1966180-FULL]")
 Q
WARD S DIC(0)="AEMQ",DIC="^SC(",DIC("A")="Select Ward: ",DIC("S")="I $D(^SC(Y,0)) I $P(^(0),""^"",3)=""W"""
 D ^DIC
 I Y<0 S WARD=0 K DIC Q
 S WARD=$P(^SC(+Y,0),"^",1) K DIC
 Q
