AZANSTIL ; IHS/PHXAO/TMJ - Print STILL ELIGIBLE to Master List for a specific Log [ 02/03/03  11:54 AM ]
 ;;1.0;MEDICAID DOWNLOAD;;JUL 10, 2000
 ;
START ;Do INFORM THEN ASK
 D INFORM
ASK ;Ask For Specific Log
 S AZAMLOG=""
 S AZAMALL=0
 S AZAMBY=0
 ;
 ;S AZXASTBD="C",AZXASTED="O"
 W ! S DIR(0)="Y0",DIR("A")="Would you like to INCLUDE ONLY a specific LOG Run for STILL ELIGIBLE's",DIR("B")="NO"
 S DIR("?")="To RESTRICT to a particular LOG RUN  - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) END
 G:Y<0 END
 G:$D(DIRUT) ASK
 I 'Y G PRINT
 ;
LOG ;Select a Log Run
 W !
 S DIC=1180006,DIC(0)="AEMQ",DIC("A")="Enter Log Run Date or Number: "
 D ^DIC K DIC
 ;
 Q:$D(DIRUT)
 G:Y=0 ASK
 S AZAMLOG=+Y
 G:+AZAMLOG<0 ASK
 S AZAMALL=1
 ;
 S LOGDT=$P(^AZAMEDLG(AZAMLOG,0),U,1)
 S LOGDT=$P(LOGDT,".",1)
 G:LOGDT="" ASK
 S AZAMBY=1
PRINT ;PRINT CLOSED DISCLOSURES BY DATE
 ;W !
 S AZAMBY=$S(AZAMBY=0:"[AZAM MASTER ELIGIBLE]",1:"@INTERNAL(#.04)")
 S FLDS="[AZAM MASTER STILL]",BY=AZAMBY,DIC="^AZAMASTR(",L=0
 I AZAMALL=1 S FR=LOGDT,TO=LOGDT
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K AZAMBD,AZAMED,X,DD0,B,AZAMALL,AZAMBY,AZAMLOG Q
 ;
INFORM ;Report Description Introduction
 W !,?7,"***This Report prints Patient Records from the RPMS MASTER File***",!!
 W "The MASTER File contains each Patient's Historical Processing Dates, as follows:",!
 W ?10,"(First Added, Last Update, Last Still Eligible, & Last Fall Off)",!
 W !,"The User may print all STILL ELIGIBLE Records or choose a specific Monthly Log.",!
 W "   **Log Runs Only Display Records with the same Date as the Log Run**",!!
 ;
 ;
 Q
