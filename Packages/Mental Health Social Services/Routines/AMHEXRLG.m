AMHEXRLG ; IHS/CMI/LAB - UPDATE LOG IN REDO AUGUST 14, 1992 ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
LOG ; UPDATE LOG
 W:'$D(ZTQUEUED) !!,AMH("COUNT")," transactions were generated."
 W:'$D(ZTQUEUED) !,"Updating Log entry."
 S ^AMHSDATA(0)=AMH("RUN LOCATION")_"^"_$P(^DIC(4,DUZ(2),0),U)_"^"_$E(AMH("RUN START"),1,7)_"^"_AMH("RUN BEGIN")_"^"_AMH("RUN END")_"^^"_AMH("COUNT")_"^^"
 D NOW^%DTC S AMH("RUN STOP")=%
 S X=^AMHXLOG(AMH("RUN LOG"),0),$P(X,U,3)="",$P(X,U,4)="",$P(X,U,5)="",$P(X,U,6)="",$P(X,U,7)="",$P(X,U,11)="",$P(X,U,12)="",$P(X,U,13)="",$P(X,U,15)="",^AMHXLOG(AMH("RUN LOG"),0)=X
 S DA=AMH("RUN LOG"),DIE="^AMHXLOG(",DR=".03////"_AMH("RUN START")_";.04////"_AMH("RUN STOP")_";.05////"_AMH("ERROR COUNT")_";.06////"_AMH("COUNT")_";.15///P"
 D CALLDIE^AMHLEIN
 I $D(Y) S AMH("QFLG")=30 Q
 S DA=AMH("RUN LOG"),DIE="^AMHXLOG(",DR=".11////"_AMH("A")_";.12////"_AMH("M")_";.13////"_AMH("D") D CALLDIE^AMHLEIN
 I $D(Y) S AMH("QFLG")=30 Q
 Q
 ;
 ;
