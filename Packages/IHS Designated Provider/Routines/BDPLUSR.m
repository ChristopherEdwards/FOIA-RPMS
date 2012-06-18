BDPLUSR ; IHS/CMI/TMJ - BDP LAST USER WHO UPDATED WORKLOAD REPORT AND (BY DATE RANGE) ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 D INFORM ;Display Report Definition
 ;
BD ;get beginning date
 W !! S DIR(0)="D^::EP",DIR("A")="Enter beginning Update Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G END
 S BDPBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_BDPBD_":DT:EP",DIR("A")="Enter ending Update Date:  "  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BDPED=Y
 S X1=BDPBD,X2=-1 D C^%DTC S BDPSD=X
 W !
 ;
 ;
ASK ;Ask if a particular User
 S BDPUSE=1,BDPUSE1=10000
 W ! S DIR(0)="Y0",DIR("A")="Want to INCLUDE a particular User Who Updated Record",DIR("B")="NO"
 S DIR("?")="To RESTRICT to a particular User  - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) BD
 I 'Y G PRINT
USER ;Get USER
 S DIC=200,DIC(0)="AEMQ",DIC("A")="Enter User Name: "
 D ^DIC K DIC
 ;
 Q:$D(DIRUT)
 G:Y=0 ASK
 S BDPUSE=+Y,BDPUSE1=+Y
 ;
 ;
PRINT ;PRINT RECORDS BY DATE
 ;W !
 S FLDS="[BDP USER UPDATE LISTING]",BY(0)="^BDPRECN(""AE""," S L(0)=3,DIC="^BDPRECN(",L=0
 S FR(0,1)=BDPUSE,TO(0,1)=BDPUSE1
 S FR(0,2)=BDPBD,TO(0,2)=BDPED
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K BDPBD,BDPED,BDPSD,BDPUSE,BDPUSE1,X,DD0,B Q
 ;
 ;
INFORM ;Report Explanation
 ;
 W !,?25,"******************************",!
 W ?10,"This Report prints a Listing of Records updated for a",!,?10,"specific date range and User who created.",!
 W ?10,"The report output includes:",!,?10,"Category Type-Patient Name-Current Provider-Date & User Who Created.",!
 W ?25,"*****************************",!
 Q
