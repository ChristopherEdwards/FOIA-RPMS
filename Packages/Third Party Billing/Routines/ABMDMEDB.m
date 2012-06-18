ABMDMEDB ;IHS/ASDST/DMJ - MEDICARE B CLAIM SPLIT  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/DMJ - 09/11/01 - V2.4 Patch 7 - NOIS HQW-0701-100066
 ;     This is a new routine related to Medicare Part B.
 ;
 ; IHS/ASDS/DMJ - 10/19/01 - V2.4 Patch 9 - NOIS HQW-1001-100086
 ;     Allow one Part B claim for free standing clinics.
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM16055
 ;    Corrected global reference
 ;
 ; *********************************************************************
 ;
START ;set start
 Q:$G(^ABMCNVRT("MEDB","START"))
 S ^ABMCNVRT("MEDB","START")=$H
ALL ;all sites
 S ABMDUZ2=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'DUZ(2)  Q:DUZ(2)'=+DUZ(2)  D
 .D ONE
 S DUZ(2)=ABMDUZ2
 K ABMDUZ2
 S ^ABMCNVRT("MEDB","STOP")=$H
 Q
ONE ;one site
 Q:$P($G(^ABMDPARM(DUZ(2),1,5)),U)
 W !!,"Site= ",$P(^AUTTLOC(DUZ(2),0),"^",2)
 S ABMDT=3010700
 F  S ABMDT=$O(^ABMDCLM(DUZ(2),"AD",ABMDT)) Q:'ABMDT  D
 .S ABMCLM=0
 .F  S ABMCLM=$O(^ABMDCLM(DUZ(2),"AD",ABMDT,ABMCLM)) Q:'ABMCLM  D
 ..D CLAIM
 Q
CLAIM ;one claim
 S ABMINS=+$P(^ABMDCLM(DUZ(2),ABMCLM,0),"^",8)
 Q:$P($G(^AUTNINS(ABMINS,2)),U)'="R"
 Q:$P(^ABMDCLM(DUZ(2),ABMCLM,0),"^",7)=999
 D MAIN^ABMDSPLB(ABMCLM)
 W "."
 Q
