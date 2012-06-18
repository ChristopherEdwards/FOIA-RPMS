BMEMSTIL ; IHS/PHXAO/TMJ - Print STILL ELIGIBLE to Master List for a specific Log ; 
 ;;1.0T1;MEDICAID ELIGIBILITY DOWNLOAD;;JUN 25, 2003
 ;
START ;Do INFORM THEN ASK
 D INFORM
ASK ;Ask For Specific Log
 S BMELOG=""
 S BMEALL=0
 S BMEBY=0
 ;
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
 S DIC=90333,DIC(0)="AEMQ",DIC("A")="Enter Log Run Date or Number: "
 D ^DIC K DIC
 ;
 Q:$D(DIRUT)
 G:Y=0 ASK
 S BMELOG=+Y
 G:+BMELOG<0 ASK
 S BMEALL=1
 ;
 S BMELOGDT=$P(^BMEMLOG(BMELOG,0),U,1)
 S BMELOGDT=$P(BMELOGDT,".",1)
 G:BMELOGDT="" ASK
 S BMEBY=1
PRINT ;PRINT CLOSED DISCLOSURES BY DATE
 ;W !
 S BMEBY=$S(BMEBY=0:"[BME MASTER ELIGIBLE]",1:"@INTERNAL(#.04)")
 S FLDS="[BME MASTER STILL]",BY=BMEBY,DIC="^BMEMASTR(",L=0
 I BMEALL=1 S FR=BMELOGDT,TO=BMELOGDT
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K BMEBD,BMEED,X,DD0,B,BMEALL,BMEBY,BMELOG Q
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
