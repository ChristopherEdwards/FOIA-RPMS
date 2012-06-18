BTIURS ; IHS/ITSC/LJF - Electronic signature actions ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ; Copy of TIURS so calls from IHS reports to sign documents work
 ;         -- removed VA code to update list
 ;
ELSIG ; Sign rec
 N ASK,TIUEVNT,TIULST,TIUSLST,TIURJCT,TIUDA,TIUDATA,TIUES,TIUI,X,X1,Y
 I '$D(TIUPRM0) D SETPARM^TIULE
 I $P(TIUPRM0,U,2)'>0 W !,"Electronic signature not yet enabled." H 3 G ELSIGX
 I '$D(VALMY) D EN^VALM2(XQORNOD(0))
 S (ASK,TIUI)=0 I $D(VALMY)>9 D CLEAR^VALM1
 F  S TIUI=$O(VALMY(TIUI)) Q:+TIUI'>0  D
 . N TIU0,TIU12,TIUSTAT,TIUEVNT,TIUTYPE,TIUPOP,TIU15 S TIUPOP=0
 . S TIUDATA=$G(^TMP("TIURIDX",$J,TIUI))
 . S TIUDA=$P(TIUDATA,U,2)
 . S TIU0=$G(^TIU(8925,+TIUDA,0)),TIU12=$G(^(12)),TIU15=$G(^(15))
 . S TIUSTAT=+$P(TIU0,U,5)
 . S TIUTYPE=$$PNAME^TIULC1(+$G(^TIU(8925,+TIUDA,0)))
 . S TIUEVNT=$S(+TIUSTAT'>5:"SIGNATURE",1:"COSIGNATURE")
 . D RESTORE^TIULM(TIUI)
 . S ASK=$$CANDO^TIULP(TIUDA,TIUEVNT)
 . I +ASK'>0,$P(ASK,U,2)]"" D
 . . D FULL^VALM1
 . . W !!,"Item #",TIUI,": ",$P(ASK,U,2),! K VALMY(TIUI)
 . . W !,"Removed from signature list.",!
 . . I $$READ^TIUU("FOA","Press RETURN to continue...")
 . E  D
 . . I $S(+$$REQCOSIG^TIULP(+TIU0,+TIUDA,DUZ):1,+$P(TIU15,U,6):1,1:0),(+$P(TIU12,U,8)'>0) D  Q:+TIUPOP
 . . . N COSIGNER
 . . . W !!,"Item #",TIUI,": ",TIUTYPE," for "
 . . . W $$PTNAME^TIULC1($P(TIU0,U,2))," will need cosignature..."
 . . . S COSIGNER=$$ASKCSNR(TIUDA,DUZ)
 . . . I +COSIGNER'>0 D
 . . . . S TIUPOP=1
 . . . . W !!,"Item #",TIUI,": MUST have a cosigner, before you may sign."
 . . . . W !!,"Removed from signature list.",!
 . . . . I $$READ^TIUU("FOA","Press RETURN to continue...")
 . . N TIU,TIUY
 . . D EN^VALM("TIU SIGN/COSIGN")
 I $D(TIUSLST)'>9 D  G ELSIGX
 . S VALMSG="** Signature List Empty...Nothing signed. **"
 . D FIXLST^TIULM
 I $D(TIUSLST)>9 D
 . S TIUES=$$ASKSIG^TIULA1
 . I '+TIUES S VALMSG="** Nothing Signed. **" D FIXLST^TIULM Q
 . D FULL^VALM1
 . S TIUI=0 F  S TIUI=$O(TIUSLST(TIUI)) Q:+TIUI'>0  D
 . . S TIUDATA=$G(^TMP("TIURIDX",$J,TIUI)),TIUDA=$P(TIUDATA,U,2)
 . . S TIULST=$G(TIULST)_$S($G(TIULST)]"":", ",1:"")_TIUI
 . . D ES(TIUDA,TIUES,TIUI)
 . . ;I '$D(^TMP("TIUR",$J,"CTXT")) D UPDATE^TIURL(TIUDATA)  ;original VA
 . . ;I $D(^TMP("TIUR",$J,"CTXT")) D RBLD^TIUROR             ;original VA
 . . D RESET^BTIURPT                                         ;use IHS reset code
 I $G(TIULST)']"" S VALMSG="** Nothing Signed. **" D FIXLST^TIULM
 E  S VALMSG="** Item"_$S($L(TIULST,",")>1:"s ",$L(TIULST,"-")>1:"s ",1:" ")_TIULST_" Signed. **"
ELSIGX K VALMY S VALMBCK="R"
 Q
SIGLIST(VALMY,TIUI,TIUTYPE) ; Handles processing of signature list
 N TIUMSG
 S TIUMSG="Is this "_TIUTYPE_" ready for signature"
 W ! S TIUY=$$READ^TIUU("YO",TIUMSG,"NO","^D SIG^TIUDIRH")
 I TIUY'>0 D
 . K VALMY(TIUI)
 . S TIURJCT=$G(TIURJCT)_$S($G(TIURJCT)]"":",",1:"")_TIUI
 . W !!,"Removed from signature list." H 2
 Q
ACCEPT(TIUSLST,TIUI) ; Adds item(s) to signature list
 N TIUSGN
 I +$G(TIUDA),($G(TIUEVNT)]"") D  Q:'+$G(TIUSGN)
 . S TIUSGN=$$CANDO^TIULP(TIUDA,TIUEVNT)
 . I '+TIUSGN D
 . . D FULL^VALM1
 . . W !!,"Document has changed...",!,$P(TIUSGN,U,2)
 . . W !!,"Item #",TIUI,": Removed from signature list.",!
 . . W:$$READ^TIUU("EA","Press RETURN to continue...") ""
 S TIUSLST(TIUI)=""
 W !,"Item #",TIUI,": Added to signature list." H 2
 Q
EDSIG(TIUDA,TIUADD,TIUPASK) ; Call from Edit action to sign rec
 N TIU,TIU0,TIU12,ASK,X,X1,TIUTYPE,SIGNER,COSIGNER,TIUTYPE,TIUMSG,TIUSTAT
 N TIUES,TIUACT,TIUDPRM,XTRASGNR,TIUCOM,TIU15
 I +$D(TIUSIGN),(TIUSIGN=0) Q
 I '$D(TIUPRM0) D SETPARM^TIULE
 ; If Electronic Signature is not yet enabled, then quit
 I '+$P(TIUPRM0,U,2) S VALMBCK="R" Q
 S TIUADD=1
 S TIU0=$G(^TIU(8925,+TIUDA,0)),TIU12=$G(^(12)),TIU15=$G(^(15))
 S SIGNER=$S(+$P(TIU12,U,4):$P(TIU12,U,4),1:$P(TIU12,U,2))
 S COSIGNER=$P(TIU12,U,8)
 I (DUZ'=SIGNER),(DUZ'=COSIGNER) S XTRASGNR=+$O(^TIU(8925.7,"AE",+TIUDA,+DUZ,0))
 S TIUSTAT=+$P(TIU0,U,5)
 S TIUACT=$S(TIUSTAT'>5:"SIGNATURE",+$G(XTRASGNR):"SIGNATURE",1:"COSIGNATURE")
 S ASK=$$CANDO^TIULP(TIUDA,TIUACT)
 S TIUTYPE=$$PNAME^TIULC1(+TIU0)
 I +ASK'>0 D  Q
 . S VALMBCK="R"
 . I +$$ISA^USRLM(+$G(DUZ),"MEDICAL INFORMATION SECTION"),(+$$ISPN^TIULX(+TIU0)'>0) Q
 . I +$$ISA^USRLM(+$G(DUZ),"MAS TRANSCRIPTIONIST") Q
 . I +$$ISA^USRLM(+$G(DUZ),"TRANSCRIPTIONIST") Q
 . W !,$P(ASK,U,2)
 . I $$READ^TIUU("EA","Press RETURN to continue...") ; pause
 W:$G(VALMAR)'="^TMP(""TIUVIEW"",$J)" !
 I $S(+$$REQCOSIG^TIULP(+TIU0,+TIUDA,+SIGNER):1,+$P(TIU15,U,6):1,1:0),(+COSIGNER'>0) D  Q:+COSIGNER'>0
 . S COSIGNER=$$ASKCSNR(TIUDA,SIGNER)
 . I +COSIGNER'>0 D
 . . W !!,"This ",TIUTYPE," MUST have a cosigner before you may sign.",!
 . . I $$READ^TIUU("EA","Press RETURN to continue...") ; pause
 I TIUSTAT=5,$G(DUZ)'=SIGNER D
 . S TIUMSG="Author hasn't signed, are you SURE you want to sign "_TIUTYPE
 W ! I $G(TIUMSG)]"",$$READ^TIUU("YO",TIUMSG,"NO","^D SIG^TIUDIRH")'>0 S VALMBCK="R" Q
 L +^TIU(8925,+TIUDA):1
 E  W !?5,$C(7),"Another user is editing this entry.",! W:$$READ^TIUU("EA","Press RETURN to continue...") "" S TIUQUIT=2 Q
 S TIUES=$$ASKSIG^TIULA1 L -^TIU(8925,+TIUDA) I '+TIUES Q
 I $D(VALMAR) D FULL^VALM1
 I +$G(XTRASGNR) D ADDSIG^TIURS1(TIUDA,XTRASGNR)
 I '+$G(XTRASGNR) D ES(TIUDA,TIUES)
 I $G(TIUACT)="COSIGNATURE",(+$$ISADDNDM^TIULC1(TIUDA)'>0) D  Q:+TIUCOM
 . N TIUADDND S TIUCOM=0
 . S TIUADDND=$$READ^TIUU("YO","Do you wish to add your comments in an addendum","NO")
 . I +TIUADDND D ADD^TIUADD(TIUDA,.TIUCHNG) S TIUCOM=1
 ; --- If required, prompt for print
 I '+$G(TIUPASK) Q
 D DOCPRM^TIULC1(+TIU0,.TIUDPRM,TIUDA)
 I +$P($G(TIUDPRM(0)),U,8) D PRINT^TIUEPRNT(TIUDA)
 Q
ASKCSNR(DA,SIGNER) ; Ask for cosigner, require a response
 N DR,DIE,TIUY,TIUDCSNR,TIUPREF,TIUFLD
 S TIUPREF=$$PERSPRF^TIULE(SIGNER)
 S TIUDCSNR=$$PERSNAME^TIULC1($P(TIUPREF,U,9))
 I TIUDCSNR="UNKNOWN" S TIUDCSNR=""
 S TIUFLD=$S(+$$ISDS^TIULX(+$G(^TIU(8925,+DA,0))):"ATTENDING PHYSICIAN",1:"EXPECTED COSIGNER")
 D FULL^VALM1
AGN W !!,$C(7),"You must designate an ",TIUFLD,"...",!
 L +^TIU(8925,+DA):1
 E  W !?5,$C(7),"Another user is editing this entry.",! W:$$READ^TIUU("EA","Press RETURN to continue...") "" G ASKCOUT
 I $E(TIUFLD)="A" S DR="1209R//^S X=TIUDCSNR;1208////^S X=$P(^TIU(8925,DA,12),U,9);1506////1"
 E  S DR="1208R//^S X=TIUDCSNR;1506////1"
 S DIE="^TIU(8925," D ^DIE
ASKCOUT L -^TIU(8925,+DA)
 S TIUY=+$P($G(^TIU(8925,+DA,12)),U,8)
 ;I 'TIUY G AGN
 Q TIUY
ES(DA,TIUES,TIUI) ; Setup ^DIE call for elec sig
 N SIGNER,DR,DIE,ESDT,TIUSTAT,TIUSTNOW,COSIGNER,SVCHIEF,CSREQ,TIUPRINT
 N CSNEED,TIUTTL,TIUPSIG
 S TIUSTAT=$P($G(^TIU(8925,+DA,0)),U,5),ESDT=$$NOW^TIULC
 S SVCHIEF=+$$ISA^USRLM(DUZ,"CLINICAL SERVICE CHIEF")
 S SIGNER=$P(^TIU(8925,+DA,12),U,4),COSIGNER=$P(^(12),U,8),CSREQ=0
 S CSNEED=+$P($G(^TIU(8925,+DA,15)),U,6)
 I +CSNEED,(DUZ'=COSIGNER),'+$G(SVCHIEF) S CSREQ=1
 I TIUSTAT=5 D
 . S DR=".05////"_$S(+CSREQ:6,1:7)_";1501////"_ESDT_";1502////"_+DUZ
 . I '+$G(CSREQ),+CSNEED,$S(DUZ=COSIGNER:1,+$G(SVCHIEF):1,1:0) D
 . . S DR=DR_";1506////0;1507////"_ESDT_";1508////"_+DUZ_";1509///^S X=$P(TIUES,U,2);1510///^S X=$P(TIUES,U,3);1511////E"
 I TIUSTAT=6 S DR=".05////7;1506////0;1507////"_ESDT_";1508////"_+DUZ
 Q:'$D(DR)
 S DIE=8925 D ^DIE W:'$D(XWBOS) "."
 I TIUSTAT=5 S DR="1503///^S X=$P(TIUES,U,2);1504///^S X=$P(TIUES,U,3);1505////E"
 I TIUSTAT=6 D
 . N TIUSBY S DR="",TIUSBY=$P($G(^TIU(8925,+DA,15)),U,2)
 . I +TIUSBY>0 S DR="1503///^S X=$$SIGNAME^TIULS("_TIUSBY_");1504///^S X=$$SIGTITL^TIULS("_TIUSBY_");"
 . S DR=$G(DR)_"1509///^S X=$P(TIUES,U,2);1510///^S X=$P(TIUES,U,3);1511////E"
 S DIE=8925 D ^DIE W:'$D(XWBOS) "." S:'+$G(TIUCHNG) TIUCHNG=1
 D SEND^TIUALRT(DA),SIGNIRT^TIUDIRT(+DA)
 I +$$ISADDNDM^TIULC1(DA) S DA=+$P(^(0),U,6)
 I +$G(CSREQ)'>0 D MAIN^TIUPD(DA,"S") I 1
 I +$P(^TIU(8925,+DA,0),U,11) D CREDIT^TIUVSIT(DA)
 ; If the document has a post-signature action, execute it
 S TIUTTL=+$G(^TIU(8925,+DA,0)),TIUPSIG=$$POSTSIGN^TIULC1(TIUTTL)
 I +$L(TIUPSIG),'+$G(CSREQ) X TIUPSIG
 Q
