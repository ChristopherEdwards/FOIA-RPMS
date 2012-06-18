ABMPST10 ; IHS/ASDS/LSL - V2.4 Patch 10 Post init  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - V2.4 Patch 10 - NOIS QBA-1201-130010
 ;     loop MCR part B that were created in patch 7 and
 ;     make Medicare active.
 ;
 ; *********************************************************************
PATCH10 ;
 Q:$G(^ABMCNVRT("MCRC","START"))
 S ^ABMCNVRT("MCRC","START")=$H
 ;
 ; *********************************************************************
ALL ;
 ; all sites
 S ABMDUZ2=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'DUZ(2)  Q:DUZ(2)'=+DUZ(2)  D
 .D ONE
 S DUZ(2)=ABMDUZ2
 K ABMDUZ2
 S ^ABMCNVRT("MCRC","STOP")=$H
 Q
 ;
 ; *********************************************************************
ONE ;
 ; one site
 Q:$P($G(^ABMDPARM(DUZ(2),5)),U)
 W !!,"Site= ",$P(^AUTTLOC(DUZ(2),0),"^",2)
 S ABMDT=3010700
 F  S ABMDT=$O(^ABMDCLM(DUZ(2),"AD",ABMDT)) Q:'ABMDT  D
 . S ABMCLM=0
 . F  S ABMCLM=$O(^ABMDCLM(DUZ(2),"AD",ABMDT,ABMCLM)) Q:'ABMCLM  D
 . . Q:'$D(^ABMDCLM(DUZ(2),ABMCLM))
 . . Q:$P(^ABMDCLM(DUZ(2),ABMCLM,0),"^",7)'=999  ;must be prof comp
 . . D CLAIM
 Q
 ;
 ; *********************************************************************
CLAIM ;
 ; one claim
 S (ABMPRI,ABMDONE)=0
 F  S ABMPRI=$O(^ABMDCLM(DUZ(2),ABMCLM,13,"C",ABMPRI)) Q:'+ABMPRI  D  Q:ABMDONE
 . S ABM13=0
 . F  S ABM13=$O(^ABMDCLM(DUZ(2),ABMCLM,13,"C",ABMPRI,ABM13))  Q:'+ABM13  D  Q:ABMDONE
 . . Q:'$D(^ABMDCLM(DUZ(2),ABMCLM,13,ABM13))
 . . S ABMINS=$P($G(^ABMDCLM(DUZ(2),ABMCLM,13,ABM13,0)),U)
 . . I $P($G(^AUTNINS(ABMINS,2)),U)="R" S ABMDONE=1 Q
 Q:'ABMDONE
 Q:$P($G(^ABMDCLM(DUZ(2),ABMCLM,13,ABM13,0)),U,3)'="C"
 S ABMBILL=$O(^ABMDBILL(DUZ(2),"B",ABMCLM_" "))
 ;
 ; If no bill for this claim do the following:
 I ABMCLM'=+ABMBILL D
 . W !,ABMCLM
 . Q
 . S DIE="^ABMDCLM(DUZ(2),"
 . S DA=ABMCLM
 . S DR=".08////^S X=ABMINS"
 . D ^DIE
 . S DIE="^ABMDCLM(DUZ(2),"_ABMCLM_",13,"
 . S DA(1)=ABMCLM
 . S DA=ABM13
 . S DR=".03////I"
 . D ^DIE
 . K DR,DA,DIE
 Q
