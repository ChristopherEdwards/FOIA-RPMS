AMHEXLOG ; IHS/CMI/LAB - UPDATE LOG ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 ;
 ;
LOG ; UPDATE LOG
 W:'$D(ZTQUEUED) !!,AMH("COUNT")," transactions were generated."
 W:'$D(ZTQUEUED) !,"Updating log entry."
 D NOW^%DTC S AMH("RUN STOP")=%
 S ^AMHSDATA(0)=AMH("RUN LOCATION")_"^"_$P(^DIC(4,DUZ(2),0),U)_"^"_$E(AMH("RUN START"),1,7)_"^"_AMH("RUN BEGIN")_"^"_AMH("RUN END")_"^^"_AMH("COUNT")_"^^"
 S DA=AMH("RUN LOG"),DIE="^AMHXLOG(",DR=".04////"_AMH("RUN STOP")_";.05////"_AMH("ERROR COUNT")_";.06////"_AMH("COUNT")_";.08///"_AMHCNTR D CALLDIE^AMHLEIN
 I $D(Y) S AMH("QFLG")=26 Q
 S DA=AMH("RUN LOG"),DIE="^AMHXLOG(",DR=".11////"_AMH("A")_";.12////"_AMH("M")_";.13////"_AMH("D")_";.15///P" D CALLDIE^AMHLEIN
 I $D(Y) S AMH("QFLG")=26 Q
 K DR,DIE,DA,DIV,DIU
 ;
 Q
