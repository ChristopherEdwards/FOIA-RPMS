ABMRSUBN ; IHS/SD/SDR - Resubmission Number Entry ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; For data entry of resubmission number for claims.  Claim doesn't
 ; need to be cancelled but number will be entered and then claim
 ; reprinted in order for it to show up.
 ;
 ; IHS/SD/SDR - v2.5 p13 - IM25920
 ;   Changed field to free-text with length of 29
 ;
 ;pick bill/patient; display info and confirm selection
 K DIR,DIE,DIC
 K ABMP
 D BILL^ABMDBDIC  ;returns ABMP("BDFN") and ABMP("PDFN")
 Q:$G(ABMP("BDFN"))=""
 S DIR(0)="YO"
 S DIR("A")="Bill "_$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)
 S DIR("B")="Y"
 D ^DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 ;
 ;prompt for changes
 K DIR,DIE,DIC,X,Y
 S DIR(0)="NOA^111:999"
 S DIR("A")="Bill type: "
 S DIR("B")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,2)
 D ^DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMP(".02")=Y
 ;
 K DIR,DIE,DIC,X,Y
 S DIR(0)="FAO^1:29"
 S DIR("A")="Resubmission (Control) Number: "
 S DIR("B")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4)),U,9)
 D ^DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMP(".49")=Y
 ;
 K DIR,DIE,DIC,X,Y
 S DIR(0)="FAO^3:80"
 S DIR("A")="Resubmission (Control) note: "
 S DIR("B")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4)),U,11)
 D ^DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMP("411")=Y
 ;
 ;display bill info
 W !!
 S ABM("STATUS")=$P(^DD(9002274.4,.04,0),"^",3)
 S ABM("CNT")=0
 S ABMP("PDFN")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)
 S ABM("ZERO")=^ABMDBILL(DUZ(2),ABMP("BDFN"),0)
 N J F J=1:1:12 S ABM(J)=$P(ABM("ZERO"),U,J)
 S ABM(7,1)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)
 S ABM(2,1)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U)
 S ABM(4)=$P(ABM("STATUS"),ABM(4)_":",2),ABM(4)=$P(ABM(4),";",1)
 W ?5,"Bill# ",ABM(1)
 W ?20,$$SDT^ABMDUTL(ABM(7,1))
 W ?30,$P($G(^ABMDVTYP(+ABM(7),0)),U)
 W ?51,$P($G(^DIC(40.7,+ABM(10),0)),U)
 W ?67,$P($G(^AUTTLOC(+ABM(3),0)),U,2)
 W !,?6,$P($G(^ABMDEXP(+ABM(6),0)),U)
 W ?18,$E(ABM(4),1,15)
 W ?37,$P($G(^AUTNINS(+ABM(8),0)),U)
 W ?70,$J($FN(ABM(2,1),",",2),10)
 ;
 ;display would be changes before filing on bill
 W !!
 W ?5,"Bill Type: ",ABMP(".02")
 W ?40,"User: ",$P($G(^VA(200,DUZ,0)),U)
 W !?5,"Resubmission Number: ",ABMP(".49")
 W ?40,"Date: ",$$SDT^ABMDUTL(DT)
 W !?5,"Notes: ",ABMP("411")
 ;
 ;confirm changes before filing on bill
 W !!
 K DIR,DIE,DIC,X,Y
 S DIR(0)="YA"
 S DIR("A")="Correct? "
 S DIR("B")="Y"
 D ^DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 Q:Y'=1
 ;
 ;
 ;file changes if YES
 K DIC,DIE,X,Y,DA
 S DIE="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 S DR=".02////"_ABMP(".02")
 S DR=DR_";.49////"_ABMP(".49")
 S DR=DR_";411////"_ABMP("411")
 D ^DIE
 ;
 ;reprint bill?
 W !
 K DIR,DIE,DIC,X,Y
 S DIR(0)="YA"
 S DIR("A")="Reprint bill? "
 S DIR("B")="Y"
 D ^DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 Q:Y'=1
 ;
 S ABMY("FORM")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,6)
 S ABMY("FORM")=ABMY("FORM")_"^"_$P($G(^ABMDEXP(ABMY("FORM"),0)),U)
 S ABMY(ABMP("BDFN"))=""
 S ABMY("TOT")="0^0^0"
 S ABMP("XMIT")=0
 D ZIS^ABMDFRDO
 Q
