BCHEXLOG ; IHS/TUCSON/LAB - UPDATE LOG ;  [ 06/27/00  2:18 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**7,10**;OCT 28, 1996
 ;IHS/CMI/LAB - new 0 node format for Y2K
 ;IHS/CMI/LAB - patch 10 new record format
 ;
 ;
 ;
 ;
LOG ; UPDATE LOG
 W:'$D(ZTQUEUED) !!,BCH("COUNT")," transactions were generated." ;TUCSON/LAB added '$D(ZTQUEUED) patch 3
 W:'$D(ZTQUEUED) !,"Updating log entry."
 D NOW^%DTC S BCH("RUN STOP")=%
 S ^BCHRDATA(0)=BCH("RUN LOCATION")_"^"_$P(^DIC(4,DUZ(2),0),U)_"^"_$$DATE^BCHEXD21($E(BCH("RUN START"),1,7))_"^"_$$DATE^BCHEXD21(BCH("RUN BEGIN"))_"^"_$$DATE^BCHEXD21(BCH("RUN END"))_"^"_BCH("COUNT")
 ;S $P(^BCHRDATA(1),U,2)=BCH("RUN LOCATION")_"        "_$$LZERO^BCHEXD2(BCH("BATCH"),5)_" "_$$LZERO^BCHEXD2(BCH("COUNT"),5)_"B "_$P(BCH("RUN START"),".")_" "_$$RBLK^BCHEXD2($P(^DIC(4,DUZ(2),0),U),30)_"   " ;IHS/CMI/LAB
 ;SET BATCH NUMBER INTO SITE FILE FOR NEXT RUN
 S DA=DUZ(2),DIE="^BCHSITE(",DR=".11///"_BCH("BATCH") D ^DIE K DIE,DR,DA I $D(Y) S BCH("QFLG")=26 Q
 S DA=BCH("RUN LOG"),DIE="^BCHXLOG(",DR=".04////"_BCH("RUN STOP")_";.05////"_BCH("ERROR COUNT")_";.06////"_BCH("COUNT")_";.08///"_BCH("VISIT COUNT") D CALLDIE^BCHUTIL
 I $D(Y) S BCH("QFLG")=26 Q
 S DA=BCH("RUN LOG"),DIE="^BCHXLOG(",DR=".11////"_BCH("U")_";.13////"_BCH("D")_";.15///P;.17///"_BCH("BATCH") D CALLDIE^BCHUTIL
 I $D(Y) S BCH("QFLG")=26 Q
 K DR,DIE,DA,DIV,DIU
 ;
 Q
 ;
DATE(D) ;EP convert date
 I $G(D)="" Q ""
 Q (1700+$E(D,1,3))_$E(D,4,7)
 ;
