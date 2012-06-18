TIUPNAPI ; SLC/JER - API to Replace GMRPAPI ;14-JUN-1999 13:26:25
 ;;1.0;TEXT INTEGRATION UTILITIES;**57,140**;Jun 20, 1997
NEW(TIUIFN,DFN,TIUAUTH,TIURDT,TIUTITLE,TIULOC,TIUES,TIUPRT,TIUESBY,TIUASKVS) ;
 ; -- Create new note
 ; Return variable (must pass by reference):
 ;      TIUIFN (pass by ref) = New note IFN in file 8925, -1 if error,
 ;                           = IFN^0 if note filed, w/o signature when
 ;                             TIUES=1
 ; Required Input parameters:
 ;      DFN                  = Patient IFN in file #2
 ;      TIUAUTH              = Author IFN in file #200
 ;      TIURDT               = Date/time of note in FM format
 ;      TIUTITLE             = Title IFN in file 8925.1
 ; Required global variable:
 ;      ^TMP("TIUP",$J)      = Array root for text in format compatible
 ;                             w/FM Word-processing fields. e.g.,
 ;                             ^TMP("TIUP",$J,0)=^^1^1^2961216^
 ;                             ^TMP("TIUP",$J,1,0)=Testing the TIUPNAPI.
 ; 
 ;                             NOTE: you no longer need to use the
 ;                             additional subscript to designate where
 ;                             the text should go (e.g., 10 for Admission
 ;                             Note).
 ; Optional Input variables:
 ;      TIULOC              = Patient Location IFN in file #44
 ;      TIUES               = 1 if TIU should prompt/process E-SIG
 ;      TIUPRT              = 1 if TIU should prompt user to print note
 ;      TIUESBY             = Signer IFN in file #200:  Calling App is
 ;                            resonsible for Electronic Signature
 ;      TIUASKVS            = BOOLEAN flag indicating whether to ask for visit
 ;      NOTE: If TIUESBY is passed, the document will be marked as
 ;            signed at the time the encrypted signature block name
 ;            and title are filed...It is NOT necessary to pass a
 ;            signature date/time, as GNEW^GMRPAPI permitted
 N TIUX,TIUCHNG,TIUHIT,TIUPRM0,TIUPRM1,TIUTYP,TIUOUT,TIUDPRM,TIUVSTR
 S TIUIFN=-1
 I $D(^TMP("TIUP",$J))'>9 Q  ; If no text, quit
 I '$D(^DPT(+$G(DFN),0)) G EXIT ; if not valid patient, clean-up & quit
 I '$D(^VA(200,+$G(TIUAUTH),0)) G EXIT ; if not valid author, clean-up & quit
 I '$D(^TIU(8925.1,+$G(TIUTITLE),0)) G EXIT ; if not valid title, clean-up & quit
 I $S(+$G(TIURDT)'>0:1,+$G(TIURDT)>+$$NOW^XLFDT:1,+$$FMTH^XLFDT(TIURDT)'>0:1,1:0) G EXIT
 I $S('$D(DUZ)#2:1,'$D(^VA(200,DUZ,0)):1,1:0) G EXIT
 S TIUASKVS=+$G(TIUASKVS)
 ; -- Okay, create new note
 S TIUX(1202)=TIUAUTH,TIUX(1301)=TIURDT
 ; get doc parameters
 D DOCPRM^TIULC1(TIUTITLE,.TIUDPRM)
 I +$$REQCOSIG^TIULP(TIUTITLE,"",TIUAUTH) D  G:+$G(TIUOUT) EXIT
 . Q:$D(ZTQUEUED)  ; If called from a task, don't go interactive
 . Q:$D(XWBOS)  ; If called from RPCBroker app, don't go interactive
 . S TIUX(1506)=1
 . S TIUX(1208)=$$GETCOSNR
 . I TIUX(1208)'>0 S TIUOUT=1,TIUIFN=-1
 I +TIUASKVS D  G:+$G(TIUOUT) EXIT
 . N TIUBY,TIU,TIUY
 . D ENPN^TIUVSIT(.TIU,DFN,1)
 . I '$D(TIU) S TIUOUT=1,TIUIFN=-1 Q
 . S TIUY=$$CHEKPN^TIULD(.TIU,.TIUBY)
 . I '+TIUY S TIUOUT=1,TIUIFN=-1 Q
 . I '$L($G(TIU("VSTR"))) S TIUOUT=1,TIUIFN=-1 Q
 . S TIUVSTR=$G(TIU("VSTR")),TIULOC=+$G(TIU("LOC"))
 . I +$G(TIU("STOP")),(+$P(TIUDPRM(0),U,14)'=1) S TIUX(.11)=1
 M TIUX("TEXT")=^TMP("TIUP",$J)
 D MAKE^TIUSRVP(.TIUIFN,DFN,TIUTITLE,TIURDT,$G(TIULOC),"",.TIUX,$G(TIUVSTR))
 I +TIUIFN'>0 S TIUIFN=-1 G EXIT
 I '+$G(TIUESBY),(+$G(TIUES)>0) D
 . N VALMBCK
 . D EXSTNOTE^TIUBR1(DFN,TIUIFN)
 . I +$P(^TIU(8925,+TIUIFN,0),U,5)<6 S TIUIFN=TIUIFN_"^-1"
 I +$G(TIUESBY) D MARKSIGN(.TIUIFN,+$G(TIUESBY))
 D SEND^TIUALRT(+TIUIFN)
EXIT K ^TMP("TIUP",$J)
 Q
WHATITLE(X) ; -- Given a freetext title, return pointer to file 8925.1
 Q $$WHATITLE^TIUPUTU(X)
GETCOSNR() ; Ask Expected Cosigner
 N TIUY
 S TIUY=$$READ^TIUU("P^200:AEMQ","EXPECTED COSIGNER")
 Q +$G(TIUY)
MARKSIGN(TIUDA,TIUESBY) ; Mark note as electronically signed
 N ESNAME,ESTITLE,ESBLOCK
 I $S(+$G(TIUESBY)'>0:1,'$D(^VA(200,+TIUESBY,0)):1,+$$CANDO^TIULP(TIUDA,"SIGNATURE")'>0:1,1:0) S TIUDA=TIUDA_U_-1 Q
 S ESNAME=$P($G(^VA(200,TIUESBY,20)),U,2),ESTITLE=$P($G(^(20)),U,3)
 S ESBLOCK="1^"_ESNAME_U_ESTITLE
 D ES^TIURS(TIUDA,ESBLOCK)
 I +$P(^TIU(8925,+TIUIFN,0),U,5)<6 S TIUDA=TIUDA_"^-1"
 Q
TEST ; Interactive Test
 N DUOUT,DFN,TITLE,TIUTYP,TIURDT,TIUDA,DIC K ^TMP("TIUP",$J)
 W !,"First, collect the data to pass to the API...",!
 S DFN=+$$PATIENT^TIULA Q:+DFN'>0
 D DOCSPICK^TIULA2(.TIUTYP,3,"1A","","","+$$CANPICK^TIULP(+Y),+$$CANENTR^TIULP(+Y)")
 S TITLE=$P($G(TIUTYP(1)),U,2) Q:+TITLE'>0
 S TIURDT=+$$NOW^XLFDT
 S DIC="^TMP(""TIUP"",$J," D EN^DIWE
 W !,"NOW, call the API!",!
 D NEW(.TIUDA,DFN,DUZ,TIURDT,TITLE,"",1,1,"",1)
 Q
