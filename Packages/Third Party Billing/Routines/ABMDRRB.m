ABMDRRB ;IHS/ASDST/LSL - MEDICARE B CLAIM SPLIT FOR RAILROAD  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - 10/01/01 - V2.4 Patch 9 - NOIS HQW-0701-100066
 ;     This routine will go back to visit date 7/1/01 and split already
 ;     created RailRoad Retirement claims for Part B
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM16055
 ;   Corrected global reference
 ;
 ; *********************************************************************
 ;
START ;
 ; set start
 Q:$G(^ABMCNVRT("RRB","START"))
 S ^ABMCNVRT("RRB","START")=$H
 ;
ALL ;
 ; all sites
 S ABMDUZ2=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'DUZ(2)  Q:DUZ(2)'=+DUZ(2)  D
 . D ONE
 S DUZ(2)=ABMDUZ2
 K ABMDUZ2
 S ^ABMCNVRT("RRB","STOP")=$H
 Q
 ;
 ; *********************************************************************
ONE ;
 ; one site
 Q:$P($G(^ABMDPARM(DUZ(2),1,5)),U)
 W !!,"Site= ",$P(^AUTTLOC(DUZ(2),0),"^",2)
 S ABMDT=3010700
 F  S ABMDT=$O(^ABMDCLM(DUZ(2),"AD",ABMDT)) Q:'ABMDT  D
 . S ABMCLM=0
 . F  S ABMCLM=$O(^ABMDCLM(DUZ(2),"AD",ABMDT,ABMCLM)) Q:'ABMCLM  D
 . . D CLAIM
 Q
 ;
 ; *********************************************************************
CLAIM ;
 ; one claim
 S ABMINS=+$P(^ABMDCLM(DUZ(2),ABMCLM,0),"^",8)
 Q:$P($G(^AUTNINS(ABMINS,2)),U)'="R"
 Q:$P(^ABMDCLM(DUZ(2),ABMCLM,0),"^",7)=999
 D MAIN(ABMCLM)
 W "."
 Q
 ;
 ; *********************************************************************
MAIN(ABMCF)        ;
 ; Main section
 ; x = claim to clone
 D CHK
 I $G(ABMQUIT) K ABMQUIT Q
 D ADD^ABMDSPLB
 Q:Y<0
 D EDIT^ABMDSPLB
 D DEL^ABMDSPLB
 D XREF^ABMDSPLB
 K ABMCF,ABMC2
 Q
 ;
 ; *********************************************************************
CHK ;
 ; checks create claim or quit
 S ABMQUIT=1
 Q:'$D(^ABMDCLM(DUZ(2),ABMCF,0))
 S ABMCLM(0)=$G(^ABMDCLM(DUZ(2),ABMCF,0))
 S ABMPAT=$P(ABMCLM(0),U)
 S ABMDT=$P(ABMCLM(0),U,2)
 S ABMVTYP=$P(ABMCLM(0),U,7)
 S ABMINS=$P(ABMCLM(0),U,8)
 Q:ABMDT<3010701
 I '$$PARTB(ABMPAT,ABMDT) Q
 D DUP^ABMDSPLB
 I $G(ABMDUP) Q
 K ABMQUIT
 Q
 ;
 ; *********************************************************************
PARTB(X,Y)         ;
 ; Check for  part b
 ; x = patient dfn
 ; y = date
 I 'X S Z=0 Q Z
 I 'Y S Z=0 Q Z
 S Z=0
 N I
 S I=0 F  S I=$O(^AUPNRRE(X,11,I)) Q:'I  D
 .S ABMZERO=^AUPNRRE(X,11,I,0)
 .D BSUB^ABMDSPLB
 K ABMZERO
 Q Z
