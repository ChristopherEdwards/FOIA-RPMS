ABMDEOK ; IHS/ASDST/DMJ - Approve Claim for Billing ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/SDH - 03/12/01 - V2.4 Patch 9 - NOIS XJG-0500-160047
 ;     Remove the post pre-payment on the fly functionality
 ;
 ; IHS/ASDS/SDH - 09/26/01 - V2.4 Patch 9 - NOIS NDA-1199-180065
 ;     Modified to add prompts for Unbillable secondary stuff
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM19585
 ;    Added code to check status of active insurer; change to
 ;    initiated if complete
 ;
 ; *********************************************************************
 ;
ERR ;
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,5) D  G XIT
 . W !!,*7,"  =========================================================================== "
 . W !,"    Fatal ERRORS Exist a Bill can not be Generated until they are Resolved!    "
 . W !,"  =========================================================================== ",!
 . D HLP^ABMDERR
 ;
UNBIL ;
 I $P($G(^AUTNINS($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8),1)),U,7)=4 D  G XIT
 . W !!,*7,"  =========================================================================== "
 . W !,"    Primary Insurer is Designated as UNBILLABLE and thus can not be billed!    "
 . W !,"  =========================================================================== ",!
 . D HLP^ABMDERR
 ;
 D ^ABMDESM
 K ABMLOC
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q:($G(ABMSFLG)=1)
 I $G(ABMP("TOT"))'>0 D
 . S ABMP("TOT")=ABMP("TOT")+$G(ABMP("WO"))+$G(ABMP("CO"))
 ;
BGEN ;
 W !
 S DIR(0)="Y"
 S DIR("A")="Do You Wish to APPROVE this Claim for Billing"
 S DIR("?")="If Claim is accurate and Transfer to Accounts Receivable File is Desired"
 D ^DIR
 K DIR
 G:$D(DIRUT)!$D(DIROUT)!(Y'=1) XIT
 I Y=1,+$G(ABM("W"))'=0 D ADJMNT
 ;
BIL ;
 S DA=0
 S DIK="^ABMDBILL(DUZ(2),"
 F  S DA=$O(^ABMDTMP(ABMP("CDFN"),DA)) Q:'DA  D  K ^ABMDTMP(ABMP("CDFN"),DA)
 .Q:'$D(^ABMDBILL(DUZ(2),DA,0))
 .Q:+$P(^ABMDBILL(DUZ(2),DA,0),U)'=ABMP("CDFN")
 .Q:"BTPC"[$P(^ABMDBILL(DUZ(2),DA,0),U,4)
 .W !!,*7,"Bill Number ",$P(^ABMDBILL(DUZ(2),DA,0),U)
 .W " was previously created from this claim"
 .W !,"but was not completed. It is now being removed!..."
 .D ^DIK
 W !!,"Transferring Data...."
 ;if active insurer and status is complete, make it initiated
 S I=0
 F  S I=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I)) Q:'I  D
 .I ($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0)),U)=ABMP("INS")!($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0)),U,11)=ABMP("INS"))),"CB"[($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0)),U,3)) D
 ..S DA(1)=ABMP("CDFN")
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 ..S DA=I
 ..S DR=".03////I"
 ..D ^DIE
 ..K DR
 D ^ABMDEBIL
 I '$D(ABMP("BDFN")) D  G XIT
 . K DIR
 . S DIR(0)="EO"
 . D ^DIR
 ;
 S ABMP("OVER")=""
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 S DR=".04////U"
 D ^DIE
 K DR
 N I
 S I=0
 F  S I=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I)) Q:'I  D
 .Q:$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0),"^",3)'="I"
 .S DA(1)=DA
 .S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 .S DA=I
 .S DR=".03////B"
 .D ^DIE
 .K DR
 K ^ABMDTMP(ABMP("CDFN"))
 I $E($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U),$L($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)))="A" D
 . I $O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,0)) D
 .. S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,0))
 .. I $D(^AUPNVSIT(DA,0)) D
 ... S DIE="^AUPNVSIT("
 ... S DR="1101////"_ABMP("TOT")
 ... D ^ABMDDIE
 ;
XIT ;
 Q
 ;
 ; *********************************************************************
EOP ;
 W $$EN^ABMVDF("IOF")
 Q
 ;
 ; *********************************************************************
ADJMNT ;
 Q:$G(ABMSPLFG)=1  ;flag that transactions are split (see ^ABMPPFLR)
 S EXP=""
 S ABMCNT=0
 F  S EXP=$O(ABMP("EXP",EXP)) Q:EXP=""  S ABMCNT=ABMCNT+1
 Q:ABMCNT>1
 F  D  Q:ABMFLAG=1
 .S ABMFLAG=0
 .W !!,"CURRENT ADJUSTMENTS:"
 .I $G(ABMP("WO")) D
 ..W !,"         Write-off:  ",$G(ABMP("WO"))
 .I $G(ABMP("DED")) D
 ..W "                  Deductible:  ",$G(ABMP("DED"))
 .I $G(ABMP("NONC")) D
 ..W !,"      Non-covered:  ",$G(ABMP("NONC"))
 .I $G(ABMP("COI")) D
 ..W "              Co-insurance:  ",$G(ABMP("COI"))
 .I $G(ABMP("GRP")) D
 ..W !,"Grouper allowance:  ",$G(ABMP("GRP"))
 .I $G(ABMP("PENS")) D
 ..W !,"        Penalties:  ",$G(ABMP("PENS"))
 .I $G(ABMP("REF")) D
 ..W !,"           Refund:  ",$G(ABMP("REF"))
 .S DIR(0)="Y"
 .S DIR("A")="Include any adjustments in billed amount?"
 .S DIR("B")="Y"
 .K Y
 .D ^DIR K DIR
 .I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT) S ABMFLAG=1 Q
 .I Y'=1 S ABMFLAG=1 Q
 .I Y=1 D
 ..S DIR(0)="N^::2"
 ..S DIR("A")="Write-off Amount to bill"
 ..S DIR("B")=$G(ABMP("WO"))
 ..K Y
 ..D ^DIR K DIR
 ..I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT) S ABMFLAG=1 Q
 ..S ADJ=Y
 ..I ADJ>0 D
 ...S BILL=$G(ABMP("EXP",ABMP("EXP")))
 ...W !!,"Ok, I will add $",ADJ," to $",BILL," for a total billed amount of $",ADJ+BILL
 ...S DIR(0)="Y"
 ...S DIR("A")="OK?"
 ...S DIR("B")="Y"
 ...K Y
 ...D ^DIR K DIR
 ...I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT) S ABMFLAG=1 Q
 ...I Y=1 S ABMP("EXP",ABMP("EXP"))=$G(ABMP("EXP",ABMP("EXP")))+ADJ,ABMFLAG=1,ABMP("WO")=ABMP("WO")-ADJ
 Q
