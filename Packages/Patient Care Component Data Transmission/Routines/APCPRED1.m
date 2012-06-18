APCPRED1 ; IHS/TUCSON/LAB - CONTINUATION OF APCPREDO AUGUST 14, 1992 ; [ 04/17/02 11:19 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**1,6**;APR 03, 1998
 ;IHS/CMI/LAB - no longer process APC,INPT,CHA
 ;
INIT ;EP
 D CHKOLD^APCPDRI2
 Q:APCP("QFLG")
 S DIC="^APCPLOG(",DIC(0)="AEQ",DIC("S")="I $D(^(21)),$P(^(0),U,9)=DUZ(2),'$P(^(0),U,27)" D ^DIC K DIC
 I Y<0 S APCP("QFLG")=99 Q
 S APCP("RUN LOG")=+Y
 ;
 S X=^APCPLOG(APCP("RUN LOG"),0),APCP("RUN BEGIN")=$P(X,U),APCP("RUN END")=$P(X,U,2),APCP("COUNT")=$P(X,U,6),APCP("ORIG TX DATE")=$P($P(X,U,3),".")
 S Y=APCP("RUN BEGIN") X ^DD("DD") S APCP("PRINT BEGIN")=Y
 S Y=APCP("RUN END") X ^DD("DD") S APCP("PRINT END")=Y
 S APCP("VISITS")=$P(^APCPLOG(APCP("RUN LOG"),21,0),U,4)
 W !!,"Log entry ",APCP("RUN LOG")," was for date range ",APCP("PRINT BEGIN")," through",!,APCP("PRINT END")," and generated ",APCP("COUNT")," transactions from ",APCP("VISITS")," visits."
 ;
 W !!,"This routine will re-generate the following transaction types:"
 ;W:$D(APCPS("APC")) !?15,"APC - AMBULATORY SYSTEM " ;IHS/CMI/LAB - no apc records
 ;W:$D(APCPS("INPT")) !?15,"INPATIENT - DIRECT INPATIENT" ;IHS/CMI/LAB - no inpt records
 ;W:$D(APCPS("CHA")) !?15,"CHA - COMMUNITY HEALTH ACTIVITY" ;IHS/CMI/LAB - no cha records
 W !?15,"STATISTICAL DATABASE RECORDS" ;IHS/CMI/LAB - all sites send stat records
RDD ;
 S DIR(0)="Y",DIR("A")="Do you want to regenerate the transactions for this run",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT)!'Y S APCP("QFLG")=99 Q
 K ^APCPLOG(APCP("RUN LOG"),51)
 S APCP("COUNT")=0
 Q
