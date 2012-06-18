AMHEYRE1 ; IHS/CMI/LAB - CONT. OF REDO MHSS EXPORT ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
INIT ;EP
 D CHKOLD^AMHEYDI2
 Q:AMH("QFLG")
 S DIC="^AMHXLOG(",DIC(0)="AEQ",DIC("S")="I $D(^(21)),$P(^(0),U,9)=DUZ(2)" D ^DIC K DIC
 I Y<0 S AMH("QFLG")=99 Q
 S AMH("RUN LOG")=+Y
 ;
 S X=^AMHXLOG(AMH("RUN LOG"),0),AMH("RUN BEGIN")=$P(X,U),AMH("RUN END")=$P(X,U,2),AMH("COUNT")=$P(X,U,6),AMH("ORIG TX DATE")=$P($P(X,U,3),".")
 S Y=AMH("RUN BEGIN") X ^DD("DD") S AMH("PRINT BEGIN")=Y
 S Y=AMH("RUN END") X ^DD("DD") S AMH("PRINT END")=Y
 S AMH("RECS")=$P(^AMHXLOG(AMH("RUN LOG"),21,0),U,4)
 W !!,"Log entry ",AMH("RUN LOG"),"  was for date range ",AMH("PRINT BEGIN")," through ",AMH("PRINT END"),!,"and generated ",AMH("COUNT")," transactions from ",AMH("RECS")," records."
 ;
RDD ;
 S DIR(0)="Y",DIR("A")="Do you want to regenerate the transactions for this run",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT) S AMH("QFLG")=99 Q
 I Y=0 S AMH("QFLG")=99 Q
 Q
