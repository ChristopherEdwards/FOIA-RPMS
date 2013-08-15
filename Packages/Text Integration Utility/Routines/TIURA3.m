TIURA3 ; SLC/JER - Review screen actions ; 11/7/06
 ;;1.0;TEXT INTEGRATION UTILITIES;**220**;Jun 20, 1997;Build 4
 ; Call to ISA^USRLM supported by DBIA 2324
EDITCOS ; Edit Expected Cosigner
 ; Modeled after EDIT^TIURA
 N TIUDA,TIUDATA,TIUCHNG,TIUI,DIROUT,TIUDAARY
 N TIULST,MSGVERB,TIUXNOD
 S TIUXNOD=$G(XQORNOD(0))
 I $P(TIUXNOD,U,3)="EC" W "Edit Cosigner",! S $P(TIUXNOD,U,4)="EC="_$P($P(TIUXNOD,U,4),"==",2)
 S TIUI=0
 I '$D(VALMY) D EN^VALM2(TIUXNOD)
 F  S TIUI=$O(VALMY(TIUI)) Q:+TIUI'>0  D  Q:$D(DIROUT)
 . N RSTRCTD
 . S TIUDATA=$G(^TMP("TIURIDX",$J,TIUI))
 . D CLEAR^VALM1 W !!,"Editing #",+TIUDATA
 . S TIUDA=+$P(TIUDATA,U,2) S RSTRCTD=$$DOCRES^TIULRR(TIUDA)
 . I RSTRCTD D  Q
 . . W !!,$C(7),"Ok, no harm done...",!
 . . I $$READ^TIUU("EA","RETURN to continue...") ; pause
 . S TIUDAARY(TIUI)=TIUDA
 . S TIUCHNG=0
 . I +$D(^TIU(8925,+TIUDA,0)) D EDITCOS1
 . I +$G(TIUCHNG) D
 . . S TIULST=$G(TIULST)_$S($G(TIULST)]"":",",1:"")_TIUI
 ; -- Update or Rebuild list, restore video: --
 S TIUCHNG("UPDATE")=1
 D UPRBLD^TIURL(.TIUCHNG,.VALMY) K VALMY
 S VALMBCK="R"
 S MSGVERB="edited"
 D VMSG^TIURS1($G(TIULST),.TIUDAARY,MSGVERB)
 Q
EDITCOS1 ; Edit expected cosigner/attending for single record
 ; Receives TIUDA
 ; Modeled after Input template for document type
 I '+$G(TIUDA) W !,"No Documents selected." H 2 Q
 ; Evaluate edit privilege
 N NODE0,STATUS,OK2CHNG,CANTMSG,NODE12,REQCOSIG,PROBMSG
 N ECSIGNER,ESIGNER,OKCLASS,TIUISDS,DA,DR,DIE,X
 N ALTNODE0,ALTTIUDA,NESIGNR,NECSIGNR,ATTEND,NATTEND,CHKSUM
 S NODE0=^TIU(8925,TIUDA,0),STATUS=$P(NODE0,U,5),(OK2CHNG,OKCLASS)=1
 S ALTNODE0=NODE0,ALTTIUDA=TIUDA,NODE12=$G(^TIU(8925,TIUDA,12))
 I $$ISADDNDM^TIULC1(TIUDA) D
 . S ALTTIUDA=$P(NODE0,U,6)
 . S ALTNODE0=^TIU(8925,ALTTIUDA,0)
 S TIUISDS=$$ISDS^TIULX(+ALTNODE0)
 I '$$ISPN^TIULX(+ALTNODE0),'TIUISDS,'$$ISA^TIULX(+ALTNODE0,$$CLASS^TIUCNSLT()) S OKCLASS=0
 I 'OKCLASS S PROBMSG="This action is valid only for Progress Notes, Discharge Summaries, and Consults." G COS1X
 I STATUS>6 S PROBMSG="This document is already Complete!" G COS1X
 I STATUS<5 S PROBMSG="This document still needs Release or Verification!" G COS1X
 ; -- Status = 5 unsigned or 6 uncosigned.
 ;    Try rules for EDIT COSIGNER:
 S OK2CHNG=$$CANDO^TIULP(TIUDA,"EDIT COSIGNER")
 I 'OK2CHNG S CANTMSG=OK2CHNG G:STATUS=6 COS1X
 ; -- If docmt is unsigned and EDIT COSIGNER rules failed,
 ;    try EDIT RECORD rules:
 I STATUS=5,'OK2CHNG D  G:'OK2CHNG COS1X
 . S OK2CHNG=$$CANDO^TIULP(TIUDA,"EDIT RECORD")
 . I 'OK2CHNG S CANTMSG="0^You are not authorized to edit this document."
 ; -- DUZ may change Expected Cosigner/attending.
 S DA=TIUDA,DIE=8925
 ; -- If docmt is a Progress Note or Consult:
 I 'TIUISDS D  G COS1X
 . ; -- Does Expected Signer Require Cosignature?
 . S ESIGNER=$P(NODE12,U,4)
 . S ECSIGNER=$P(NODE12,U,8)
 . I ESIGNER']"" S PROBMSG="This document has no Expected Signer!" Q
 . S REQCOSIG=$$REQCOSIG^TIULP(+NODE0,+TIUDA,ESIGNER)
 . ; -- If cosig not required:
 . I 'REQCOSIG D  Q
 . . ; -- If status is uncosigned, "see IRM" and quit:
 . . I STATUS=6 S PROBMSG="Cosignature not required!  See IRM." Q
 . . ; -- If (status is unsigned) & has no exp cosgnr, say so and quit:
 . . I ECSIGNER="" S PROBMSG="Cosignature not required." Q
 . . ; -- If (status is unsigned), has exp cosgnr, fix it:
 . . I ECSIGNER]"" D  Q
 . . . S PROBMSG="Cosignature not required. Expected Cosigner deleted."
 . . . S DR="1208///@;1506///@" D ^DIE
 . ; --Cosig is required so get it or change it:
 . W !!,"You may edit the Expected Cosigner:"
 . S DR="1208R//;1506////1" D ^DIE
 . S NECSIGNR=$P(^TIU(8925,TIUDA,12),U,8)
 . I NECSIGNR'=ECSIGNER D  Q
 . . W !!,"Expected Cosigner edited." H 1 S TIUCHNG=1
 ; -- Docmt is a Discharge Summary:
 S ATTEND=$P($G(^TIU(8925,TIUDA,12)),U,9)
 W !!,"You may edit the Attending Physician:"
 S DR="1209R//" D ^DIE
 S NATTEND=$P(^TIU(8925,TIUDA,12),U,9)
 I STATUS=6,NATTEND=$P(NODE12,U,2) D  G COS1X
 . S PROBMSG="You may not change the Attending of a signed"
 . S PROBMSG=PROBMSG_" summary to the author."
 . S DR="1209////^S X=ATTEND" D ^DIE
 S NESIGNR=$$WHOSIGNS^TIULC1(DA),NECSIGNR=$$WHOCOSIG^TIULC1(DA)
 S DR="1204////^S X=NESIGNR"
 S DR=DR_";1208////^S X=NECSIGNR"
 S DR=DR_";1506////^S X=$S(+NESIGNR=+NATTEND:0,1:1)"
 D ^DIE
 I NATTEND'=ATTEND D
 . W !!,"Attending Physician edited" H 1 S TIUCHNG=1
COS1X ;
 I $G(TIUCHNG),$G(STATUS)=6 D  ; Audit uncosigned docmts only
 . S CHKSUM=+$$CHKSUM^TIULC("^TIU(8925,"_+TIUDA_",""TEXT"")")
 . D AUDIT^TIUEDI1(TIUDA,CHKSUM,CHKSUM)
 I $D(PROBMSG) W !!,PROBMSG
 I 'OK2CHNG W !!,$P(CANTMSG,U,2)
 I $D(PROBMSG)!'OK2CHNG I $$READ^TIUU("EA","RETURN to continue...")
 D SEND^TIUALRT(TIUDA)
 Q
 ;
