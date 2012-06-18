AMHEGR1 ; IHS/CMI/LAB - GROUP ENTRY ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
 ;
DEL ;EP - called from protocol
 ;add code to not allow delete unless they have the key
 I '$D(^XUSEC("AMHZ DELETE RECORD",DUZ)) W !!,"You do not have the security access to delete a Group entry.",!,"Please see your supervisor or program manager.",! D PAUSE,EXIT^AMHEGR Q
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT^AMHEGR Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT^AMHEGR Q
 S AMHG=0 S AMHG=^TMP($J,"AMHEGR","IDX",R,R)
 I '$D(^AMHGROUP(AMHG,0)) W !,"Not a valid GROUP." K AMHRDEL,R,AMHG,R1 D PAUSE D EXIT^AMHEGR Q
 I $P(^AMHGROUP(AMHG,0),U,18),'$D(^XUSEC("AMHZ DELETE SIGNED NOTE",DUZ)) W !!,"This Group has been signed and you do not have security access to delete ",!,"a signed group.  See your supervisor.",! D PAUSE,EXIT^AMHEGR Q
 D FULL^VALM1
 S DA=AMHG,DIC="^AMHGROUP(" D EN^DIQ
 W !
 S AMHDELT=2
 ;W !!,"Option 1 should be chosen if your intent is to just delete the group"
 ;W !,"definition but retain all of the individual patient encounter records"
 ;W !,"for this group.  This option is used primarily to manage the size of"
 ;W !,"the group definition list view."
 ;W !!,"Option 2 should be chosen if your intent is to delete the group definition"
 ;W !,"and delete all the individual encounter records associated with this group."
 ;W !,"This option is used primarily when a group is entered in error."
 ;W !
 ;S DIR(0)="S^1:Delete the Group Definition Only;2:Delete Group Definition and patient encounter records",DIR("A")="Do you wish to",DIR("B")="1" KILL DA D ^DIR KILL DIR
 ;I $D(DIRUT) D EXIT^AMHEGR Q
 ;S AMHDELT=+Y
 ;K DIR
 ;I AMHDELT=1 D
 ;.W !!,"Removing the group definition will only remove/delete the group"
 ;.W !,"definition from the list.  It will not remove/delete the individual"
 ;.W !,"patient encounter records associated with the group."
 ;.W !
 ;.S DIR("A")="Are you sure you want to delete the group definition only"
 I AMHDELT=2,$P(^AMHGROUP(AMHG,0),U,18),'$D(^XUSEC("AMHZ DELETE SIGNED NOTE",DUZ)) D  D PAUSE,EXIT^AMHEGR Q
 .W !,"The SOAP/Progress notes associated with this group have been signed."
 .W !,"You cannot delete both the group definition and the visits."
 I AMHDELT=2 D
 .W !,"This option will remove/delete both the group definition and the "
 .W !,"associated patient encounter records."
 .W !!,"Are you sure you want to remove/delete both the group defintion and all "
 .S DIR("A")="associated individual patient records"
 S DIR(0)="Y",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT^AMHEGR Q
 I 'Y D EXIT^AMHEGR Q
 I AMHDELT=1 S DA=AMHG,DIK="^AMHGROUP(" D ^DIK K DIK D EXIT^AMHEGR Q
 I AMHDELT=2 D  S DA=AMHG,DIK="^AMHGROUP(" D ^DIK K DIK
 .S AMHX=0 F  S AMHX=$O(^AMHGROUP(AMHG,61,AMHX)) Q:AMHX'=+AMHX  D
 ..S AMHR=$P($G(^AMHGROUP(AMHG,61,AMHX,0)),U)
 ..S AMHGRPDE=1 D DELR K AMHGRPDE
 D EXIT^AMHEGR
 Q
PAUSE ;EP
 K DIR
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
DELR ;EP
 I '$D(^XUSEC("AMHZ DELETE SIGNED NOTE",DUZ)),$P($G(^AMHREC(AMHR,11)),U,12)]"" D  Q
 .W !!,$$VAL^XBDIQ1(9002011,AMHR,.01),?20,$$VAL^XBDIQ1(9002011,AMHR,.08)
 .W !!,"The progress note associated with this visit has been signed.  You cannot delete this visit.",!,"Please see your supervisor or program manager.",!
 I $$IINTAKE^AMHLEDEL(AMHR) W !!,"This visit has an Initial Intake with Updates, it can not be deleted",!,"until the update documents have been deleted." D PAUSE Q
 S AMHVDLT=$P(^AMHREC(AMHR,0),U,16),AMHACTN=4
 S AMHRDEL=AMHR
 D EN^XBNEW("DEL^AMHLEE","AMHR;AMHVDLT;AMHACTN;AMHGRPDE")
 Q
SOAP ;EP - put in standard soap
 S (X,C)=0 F  S X=$O(^AMHGROUP(AMHNG,31,X)) Q:X'=+X  S C=C+1,^AMHREC(AMHR,31,C,0)=^AMHGROUP(AMHNG,31,X,0)
 S ^AMHREC(AMHR,31,0)="^^"_C_"^"_C_"^"_DT_"^^"
 D ^XBFMK
 S DIE="^AMHREC(",DA=AMHR,DR=3101 D ^DIE
 S AMHOKAY=0 D RECCHECK^AMHLE2 I AMHOKAY W !,"Incomplete record!! Deleting record!!"  D DELR Q
 ;update 61 multiple
 D ^XBFMK
 S X=AMHR
 S DA(1)=AMHNG,DIC="^AMHGROUP("_AMHNG_",61,",DIC(0)="AELQ",DIC("P")=$P(^DD(9002011.67,6101,0),U,2)
 K DD,DO D FILE^DICN
 I Y=-1 W !!,"adding record to group failed."
 ;call pcc link
 ;S AMHIAIG=1 D PCCLINK^AMHLE2
 ;K AMHIAIG
 D EXIT^AMHEGR
 Q
PRTEF ;EP
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT^AMHEGR Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT^AMHEGR Q
 S AMHNG=0 S AMHNG=^TMP($J,"AMHEGR","IDX",R,R)
 I '$D(^AMHGROUP(AMHNG,0)) W !,"Not a valid GROUP." K R,AMHNG,R1 D PAUSE,EXIT^AMHEGR Q
 D FULL^VALM1
 I '$O(^AMHGROUP(AMHNG,61,0)) W !!,"There were no visits created for this group." D PAUSE,EXIT^AMHEGR Q
 W !!,"Forms will be generated for the following patient visits:"
 S AMHY=0 F  S AMHY=$O(^AMHGROUP(AMHNG,61,AMHY)) Q:'AMHY  S AMHR=$P(^AMHGROUP(AMHNG,61,AMHY,0),U) I $D(^AMHREC(AMHR,0)) D
 .W !?2,$$VAL^XBDIQ1(9002011,AMHR,.08),?34,$$VAL^XBDIQ1(9002011,AMHR,.01)
 .S AMHLEGP("RECS ADDED",AMHY)=AMHR
 K AMHEFT,AMHEFTH
 W !! S DIR(0)="S^F:Full Encounter Form;S:Suppressed Encounter Form;B:Both a Suppressed & Full;T:2 copies of the Suppressed;E:2 copies of the Full"
 S DIR("B")=$S($P(^AMHSITE(DUZ(2),0),U,23)]"":$P(^AMHSITE(DUZ(2),0),U,23),1:"B") K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S (AMHEFT,AMHEFTH)=Y
 S AMHGRPN=$P(^AMHGROUP(AMHNG,0),U,3)
 S XBRP="PRINT^AMHLEGPP",XBRC="COMP^AMHLEGPP",XBRX="XIT^AMHLEGPP",XBNS="AMH"
 D ^XBDBQUE
 D EXIT^AMHEGR
 Q
DISP ;EP - called from protocol
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT^AMHEGR Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT^AMHEGR Q
 S AMHG=0 S AMHG=^TMP($J,"AMHEGR","IDX",R,R)
 I '$D(^AMHGROUP(AMHG,0)) W !,"Not a valid GROUP." K AMHRDEL,R,AMHG,R1 D PAUSE,EXIT^AMHEGR Q
 D FULL^VALM1
 D DIQ^XBLM(9002011.67,AMHG)
 D EXIT^AMHEGR
 Q
ESIGGRP ;
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No Group selected." D EXIT^AMHEGR Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No Group selected." D EXIT^AMHEGR Q
 S AMHNG=0 S AMHNG=^TMP($J,"AMHEGR","IDX",R,R)
 I '$D(^AMHGROUP(AMHNG,0)) W !,"Not a valid GROUP." K R,AMHNG,R1 D PAUSE,EXIT^AMHEGR Q
 D FULL^VALM1
 I '$O(^AMHGROUP(AMHNG,61,0)) W !!,"There were no visits created for this group." D PAUSE,EXIT^AMHEGR Q
 I $P(^AMHGROUP(AMHNG,0),U,18) W !!,"The notes for this group have already been signed.",!! D PAUSE,EXIT^AMHEGR Q
 S P=$$PP^AMHEGR(AMHNG)
 I $D(^AMHSITE(DUZ(2),19,"B",P)) W !!,"No E-Sig Required.  Provider opted out of E-Sig." D PAUSE,EXIT^AMHEGR Q
 D SIGN^AMHEGR
 Q
GATHER ;EP
 K ^TMP($J,"AMHEGR")
 S AMHLINE=0,AMHD=$$FMADD^XLFDT(AMHRED,1)
 F  S AMHD=$O(^AMHGROUP("B",AMHD),-1) Q:AMHD'=+AMHD!($P(AMHD,".")<AMHRBD)  D
 .S AMHX=0 F  S AMHX=$O(^AMHGROUP("B",AMHD,AMHX)) Q:AMHX'=+AMHX  D
 ..S AMHN=$G(^AMHGROUP(AMHX,0))
 ..Q:'$$ALLOWV^AMHUTIL(DUZ,$P(AMHN,U,5))
 ..S AMHPRVM=""
 ..I $O(^AMHSITE(DUZ(2),16,"B",DUZ,0)) S AMHPRVM=1
 ..I '$O(^AMHSITE(DUZ(2),16,"B",DUZ,0)) D
 ...I $$PRVG^AMHGU(AMHX,DUZ) S AMHPRVM=1 Q  ;quit if not provider who entered
 ...I $$GET1^DIQ(9002011.67,AMHX,.12,"I")=DUZ S AMHPRVM=1 Q
 .. Q:'$G(AMHPRVM)
 ..S AMHLINE=AMHLINE+1,X=AMHLINE_")",$E(X,5)=$S('$P(^AMHGROUP(AMHX,0),U,18):"*",1:""),$E(X,7)=$E(AMHD,4,5)_"/"_$E(AMHD,6,7)_"/"_$E(AMHD,2,3),$E(X,16)=$E($P(AMHN,U,3),1,20)
 ..S A=$P(AMHN,U,7) I A S A=$P(^AMHTACT(A,0),U,2),A=$E(A,1,9),$E(X,37)=A
 ..S $E(X,48)=$E($P(AMHN,U,2),1)
 ..S $E(X,52)=$E($$VAL^XBDIQ1(9002011.67,AMHX,.14),1,5)
 ..S $E(X,59)=$E($$PPINI(AMHX),1,8)
 ..S $E(X,69)=$E($$VAL^XBDIQ1(9002011.67,AMHX,.08),1,3)
 ..S $E(X,73)=$$POV(AMHX)
 ..S ^TMP($J,"AMHEGR",AMHLINE,0)=X,^TMP($J,"AMHEGR","IDX",AMHLINE,AMHLINE)=AMHX
 Q
PPINI(R) ;
 I 'R Q ""
 NEW Y,X
 S X=0,Y="" F  S X=$O(^AMHGROUP(R,11,X)) Q:X'=+X!(Y]"")  I $P($G(^AMHGROUP(R,11,X,0)),U,2)="P" S Y=$P(^AMHGROUP(R,11,X,0),U),Y=$P(^VA(200,Y,0),U,1)
 Q Y
POV(R) ;
 I 'R Q ""
 NEW Y,X,P
 S X=0,Y="" F  S X=$O(^AMHGROUP(R,21,X)) Q:X'=+X!(Y]"")  S P=$P(^AMHGROUP(R,21,X,0),U),Y=$P(^AMHPROB(P,0),U,1)_" - "_$P(^AMHPROB(P,0),U,2)
 Q Y
DUP ;EP
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT^AMHEGR Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT^AMHEGR Q
 S AMHG=0 S AMHG=^TMP($J,"AMHEGR","IDX",R,R)
 I '$D(^AMHGROUP(AMHG,0)) W !,"Not a valid GROUP." K AMHRDEL,R,AMHG,R1 D PAUSE D EXIT^AMHEGR Q
 D FULL^VALM1
 W !
 K DIR S DIR(0)="D^:DT:EP",DIR("A")="Enter Date for the new group entry" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT^AMHEGR Q
 S AMHD=Y,AMHDATE=Y
 S X=AMHD,DIC="^AMHGROUP(",DLAYGO=9002011.67,DIADD=1,DIC(0)="L" K DD,DO D FILE^DICN
 I Y=-1 W !!,"entry of new group failed." K DIADD,DLAYGO D ^XBFMK D EXIT^AMHEGR Q
 S AMHNG=+Y
 K DIADD,DLAYGO D ^XBFMK
 K ^AMHGROUP("B",AMHD,AMHNG)
 M ^AMHGROUP(AMHNG)=^AMHGROUP(AMHG)
 K ^AMHGROUP(AMHNG,61) ;get rid of records
 K ^AMHGROUP(AMHNG,71) ;get rid of patient ed topics per BJ 5.13.09
 ;per BJ 5/13/09 - get rid of deceased patients
 NEW AMHX,P
 S AMHX=0 F  S AMHX=$O(^AMHGROUP(AMHNG,51,AMHX)) Q:AMHX'=+AMHX  D
 .S P=$P($G(^AMHGROUP(AMHNG,51,AMHX,0)),U)
 .Q:P=""
 .I $$DOD^AUPNPAT(P)]"" D
 ..S DA(1)=AMHNG,DA=AMHX,DIK="^AMHGROUP("_DA(1)_",51," D ^DIK K DA,DIK
 S DA=AMHNG,DIE="^AMHGROUP(",DR=".01///"_AMHD_";.04////"_DT_";.12////"_DUZ_";.13////"_DT_";.15////"_DUZ_";.16///@;.18///@;.19///@;.21///@" D ^DIE
 S DA=AMHNG,DIK="^AMHGROUP(" D IX1^DIK
 D EDITGRP^AMHEGR
 Q
PCCLINK ;EP
 W !!,"Processing PCC Link for all visits..."
 NEW AMHGX
 S AMHACTN=1
 S AMHGX=0 F  S AMHGX=$O(^AMHGROUP(AMHNG,61,AMHGX)) Q:AMHGX'=+AMHGX  D
 .S AMHR=$P(^AMHGROUP(AMHNG,61,AMHGX,0),U)
 .I '$D(^AMHREC(AMHR,0)) W !!,"a previously entered visit has been deleted, skipping signature for that visit" Q
 .I $P($$ESIG^AMHESIG(AMHR,1),U,1) W !,"Signing note for ",$$VAL^XBDIQ1(9002011,AMHR,.08) D
 ..S DIE="^AMHREC(",DA=AMHR,DR="1112///NOW;1113///"_$P($G(^VA(200,DUZ,20)),U,2)_";1116///"_$P(^VA(200,DUZ,20),U,3) D ^DIE K DA,DIE,DR
 ..I $D(Y) W !!,"Error updating electronic signature...see your supervisor for programmer help."
 .S AMHACTN=1
 .W !,"Processing PCC Link for ",$$VAL^XBDIQ1(9002011,AMHR,.08)
 .S AMHDATE=$P($P(^AMHGROUP(AMHNG,0),U),".")
 .S AMHPTYPE=$P(^AMHGROUP(AMHNG,0),U,2)
 .S AMHLOC=$P(^AMHGROUP(AMHNG,0),U,5)
 .D PCCLINK^AMHLE2
 I AMHSIGN K DIE,DA,DR,Y,DIU,DIV S DIE="^AMHGROUP(",DA=AMHNG,DR=".21///NOW;.19///"_$P($G(^VA(200,DUZ,20)),U,2)_";.18///1" D ^DIE K DA,DIE,DR
 Q
