BDWRED1 ; IHS/CMI/LAB - REDO CONT ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;IHS/CMI/LAB - no longer process APC,INPT,CHA
 ;
INIT ;EP
 D CHKOLD^BDWRDRI2
 Q:BDW("QFLG")
 S DIC="^BDWXLOG(",DIC(0)="AEQ",DIC("S")="I $D(^(21)),$P(^(0),U,9)=DUZ(2),$P(^(0),U,15)=""C""" D ^DIC K DIC
 I Y<0 S BDW("QFLG")=99 Q
 S BDW("RUN LOG")=+Y
 ;
 S X=^BDWXLOG(BDW("RUN LOG"),0),BDW("RUN BEGIN")=$P(X,U),BDW("RUN END")=$P(X,U,2),BDW("COUNT")=$P(X,U,6),BDW("ORIG TX DATE")=$P($P(X,U,3),".")
 S Y=BDW("RUN BEGIN") X ^DD("DD") S BDW("PRINT BEGIN")=Y
 S Y=BDW("RUN END") X ^DD("DD") S BDW("PRINT END")=Y
 S BDW("OLD VISITS")=$P(^BDWXLOG(BDW("RUN LOG"),21,0),U,4)
 W !!,"Log entry ",BDW("RUN LOG")," was for date range ",BDW("PRINT BEGIN")," through",!,BDW("PRINT END")," and generated ",BDW("COUNT")," transactions from ",BDW("OLD VISITS")," visits."
 ;
 W !!,"This routine will re-generate the Data Warehouse Records."
RDD ;
 S DIR(0)="Y",DIR("A")="Do you want to regenerate the transactions for this run",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT)!'Y S BDW("QFLG")=99 Q
 K ^BDWXLOG(BDW("RUN LOG"),51)
 S BDW("COUNT")=0
 Q
