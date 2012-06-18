BCHEXRLG ; IHS/TUCSON/LAB - UPDATE LOG IN REDO AUGUST 14, 1992 ;  [ 06/27/00  2:20 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**7,10**;OCT 28, 1996
 ;IHS/CMI/LAB - new 0 node format for export
LOG ; UPDATE LOG
 W:'$D(ZTQUEUED) !!,BCH("COUNT")," transactions were generated."
 W:'$D(ZTQUEUED) !,"Updating Log entry."
 S ^BCHRDATA(0)=BCH("RUN LOCATION")_"^"_$P(^DIC(4,DUZ(2),0),U)_"^"_$$DATE^BCHEXD21($E(BCH("RUN START"),1,7))_"^"_$$DATE^BCHEXD21(BCH("RUN BEGIN"))_"^"_$$DATE^BCHEXD21(BCH("RUN END"))_"^"_BCH("COUNT")
 ;S $P(^BCHRDATA(1),U,2)=BCH("RUN LOCATION")_"        "_$$LZERO^BCHEXD2(BCH("BATCH"),5)_" "_$$LZERO^BCHEXD2(BCH("COUNT"),5)_"B "_$P(BCH("RUN START"),".")_" "_$$RBLK^BCHEXD2($P(^DIC(4,DUZ(2),0),U),30)_"   "
 D NOW^%DTC S BCH("RUN STOP")=%
 S X=^BCHXLOG(BCH("RUN LOG"),0),$P(X,U,3)="",$P(X,U,4)="",$P(X,U,5)="",$P(X,U,6)="",$P(X,U,7)="",$P(X,U,11)="",$P(X,U,12)="",$P(X,U,13)="",$P(X,U,15)="",^BCHXLOG(BCH("RUN LOG"),0)=X
 S DA=BCH("RUN LOG"),DIE="^BCHXLOG(",DR=".03////"_BCH("RUN START")_";.04////"_BCH("RUN STOP")_";.05////"_BCH("ERROR COUNT")_";.06////"_BCH("COUNT")_";.15///P"
 D CALLDIE^BCHUTIL
 I $D(Y) S BCH("QFLG")=30 Q
 S DA=BCH("RUN LOG"),DIE="^BCHXLOG(",DR=".11////"_BCH("U")_";.13////"_BCH("D")_";.15///P" D CALLDIE^BCHUTIL
 I $D(Y) S BCH("QFLG")=30 Q
 Q
 ;
 ;
