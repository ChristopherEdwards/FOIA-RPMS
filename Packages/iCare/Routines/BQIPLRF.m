BQIPLRF ;PRXM/HC/ALA-Panel Refresh ; 11 Jul 2006  10:05 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
ALOG(DATA,FAKE) ;EP -- BQI AUTOPOP LOGIN
 NEW UID,II,USR,PNL,LGLOB,LOCK,X,CSTA,PLIDEN,LFLG
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J),II=0
 S DATA=$NA(^TMP("BQIPLRF",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLRF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 S USR=DUZ,PNL=""
 ;
 I $O(^BQICARE(USR,1,"AC","A",PNL))="" G DLOG
 ;
 F  S PNL=$O(^BQICARE(USR,1,"AC","A",PNL)) Q:'PNL  D
 . ; Lock panel to be repopulated
 . S LOCK=$$LCK(USR,PNL)
 . ; If not able to lock panel, clear status, send notification and go to next one
 . I 'LOCK D  Q
 .. D STA(USR,PNL)
 .. D NNOTF(USR,PNL)
 . ;
 . ; Check if locked panel has panel filters
 . NEW PLSUCC,SUBJECT,LOCK,POWNR,PPLIEN
 . S PLSUCC=$$CPFL^BQIPLUTL(USR,PNL)
 . ; If panel contains panel filters and were not successful in being locked,
 . ;  clear status, send notification and go to next panel in list
 . I 'PLSUCC D  Q
 .. D STA(USR,PNL)
 .. D ULK(USR,PNL)
 .. S SUBJECT="Unable to lock panel(s) that are filters for panel: "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)
 .. S LOCK="0^"_$P(PLSUCC,U,2),POWNR=$P(PLSUCC,U,4),PPLIEN=$P(PLSUCC,U,5)
 .. I $P(PLSUCC,U,3)'="" S BMXSEC=$P(PLSUCC,U,3),SUBJECT=""
 .. D NNOTF(OWNR,PLIEN,SUBJECT)
 . ;
 . ; Check if panel is a panel filter
 . S PLIDEN=USR_$C(26)_$P(^BQICARE(USR,1,PNL,0),"^",1)
 . I $D(^BQICARE("AD",PLIDEN)) D  Q:LFLG
 .. S LFLG=0 D PFILL^BQIPLUTL(USR,PNL,PLIDEN)
 .. ; If not able to lock any of the owning panels, unlock owning panel, clear status, unlock panel and quit
 .. I LFLG D PFILU^BQIPLUTL(USR,PNL,PLIDEN),STA(USR,PNL),ULK(USR,PNL)
 . ; Set status to currently running
 . D STA(USR,PNL,1)
 ;
 ; Refresh panel list
 D EVT("BQI REFRESH PANEL LIST",$$PLID^BQIUG1(USR,0))
 ;
 K PLIDEN
 S PNL=""
 F  S PNL=$O(^BQICARE(USR,1,"AC","A",PNL)) Q:'PNL  D
 . ;  For each panel, check current status, if not currently running, quit
 . S CSTA=+$$CSTA(USR,PNL) I 'CSTA Q
 . ; repopulate
 . D POP^BQIPLPP("",USR,PNL,"",USR)
 . ; Reset description
 . NEW DA,IENS
 . S DA(1)=USR,DA=PNL,IENS=$$IENS^DILF(.DA)
 . K DESC
 . D PEN^BQIPLDSC(USR,PNL,.DESC)
 . D WP^DIE(90505.01,IENS,5,"","DESC")
 . K DESC
 . ; clear status
 . D STA(USR,PNL)
 . ; unlock panel
 . D ULK(USR,PNL)
 . ; unlock any panels that are filters
 . D CPFLU^BQIPLUTL(USR,PNL)
 . ; unlock any owning panels
 . S PLIDEN=USR_$C(26)_$P(^BQICARE(USR,1,PNL,0),"^",1)
 . I $D(^BQICARE("AD",PLIDEN)) D PFILU^BQIPLUTL(USR,PNL,PLIDEN)
 . ; refresh panel list
 . D EVT("BQI REFRESH PANEL LIST",$$PLID^BQIUG1(USR,PNL))
 ;
 ;  refresh flag list
 D EVT("BQI REFRESH FLAG LIST",USR)
 ;
DLOG S II=II+1,@DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 K PLIDEN
 Q
 ;
MAN(DATA,OWNR,PLIEN,RETAIN) ;EP -- BQI MANUAL POP
 NEW UID,II,LGLOB,LOCK,X,PLIDEN,LFLG
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J),II=0
 S DATA=$NA(^TMP("BQIPLRF",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLRF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S RETAIN=$G(RETAIN,"")
 S LOCK=$$LCK(OWNR,PLIEN)
 I 'LOCK D  G EXT
 . D STA(OWNR,PLIEN)
 . D NNOTF(OWNR,PLIEN)
 ;
 ; Check if panel contains panel filters and try to lock them
 NEW PLSUCC,SUBJECT,LOCK,POWNR,PPLIEN
 S PLSUCC=$$CPFL^BQIPLUTL(OWNR,PLIEN)
 I 'PLSUCC D  G EXT
 . D STA(OWNR,PLIEN)
 . S SUBJECT="Unable to lock panel(s) that are filters for panel: "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)
 . S LOCK="0^"_$P(PLSUCC,U,2),POWNR=$P(PLSUCC,U,4),PPLIEN=$P(PLSUCC,U,5)
 . I $P(PLSUCC,U,3)'="" S BMXSEC=$P(PLSUCC,U,3),SUBJECT=""
 . D NNOTF(OWNR,PLIEN,SUBJECT)
 ;
 ; Check if panel is a panel filter and try to lock all panels using this one
 S PLIDEN=OWNR_$C(26)_$P(^BQICARE(OWNR,1,PLIEN,0),"^",1)
 I $D(^BQICARE("AD",PLIDEN)) D  I LFLG G EXT
 . S LFLG=0 D PFILL^BQIPLUTL(OWNR,PLIEN,PLIDEN)
 . I LFLG D PFILU^BQIPLUTL(OWNR,PLIEN,PLIDEN),STA(OWNR,PLIEN),ULK(OWNR,PLIEN) Q
 D STA(OWNR,PLIEN,1)
 ;
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 D EVT("BQI REFRESH PANEL LIST",$$PLID^BQIUG1(OWNR,PLIEN))
 ;
 K PLIDEN
 ; populate panel
 D POP^BQIPLPP("",OWNR,PLIEN,RETAIN)
 ; Reset description
 NEW DA,IENS
 S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 K DESC
 D PEN^BQIPLDSC(OWNR,PLIEN,.DESC)
 D WP^DIE(90505.01,IENS,5,"","DESC")
 K DESC
 ;
 D STA(OWNR,PLIEN)
 D ULK(OWNR,PLIEN)
 D CPFLU^BQIPLUTL(OWNR,PLIEN)
 S PLIDEN=OWNR_$C(26)_$P(^BQICARE(OWNR,1,PLIEN,0),"^",1)
 I $D(^BQICARE("AD",PLIDEN)) D PFILU^BQIPLUTL(OWNR,PLIEN,PLIDEN)
 ;
EXT D EVT("BQI REFRESH PANEL LIST",$$PLID^BQIUG1(OWNR,PLIEN))
 D EVT("BQI REFRESH FLAG LIST",OWNR)
 ;
 S II=II+1,@DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 ;
 K RETAIN,OWNR,PLIEN,PLIDEN
 Q
 ;
LCK(USR,PNL) ;EP -- Try to lock panel
 S LGLOB=$NA(^TMP("BQIPLRF",UID))
 D LOCK^BQIPLLK(.LGLOB,USR,PNL)
 I $G(BMXSEC) Q 0
 ; Strip off trailing $C(30)
 I $P($G(@LGLOB@(1)),U,1)=0 Q 0_U_$$TKO^BQIUL1($P(@LGLOB@(1),U,3),$C(30))
 Q 1
 ;
ULK(USR,PNL) ;EP -- Unlock panel
 S LGLOB=$NA(^TMP("BQIPLRF",UID))
 D UNLOCK^BQIPLLK(.LGLOB,USR,PNL)
 K ^TMP("BQIPLLK",UID)
 Q
 ;
EVT(NAME,PARMS) ;EP -- Raise the event
 D EVENT^BMXMEVN(NAME,PARMS)
 Q
 ;
STA(USR,PNL,VAL) ;EP -- Set status
 I $G(VAL)="" S VAL="@"
 NEW DA,IENS
 S DA(1)=USR,DA=PNL,IENS=$$IENS^DILF(.DA)
 S BQIUPD(90505.01,IENS,3.4)=$G(VAL)
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
CSTA(USR,PNL) ;EP -- Current status value
 NEW DA,IENS
 S DA(1)=USR,DA=PNL,IENS=$$IENS^DILF(.DA)
 Q $$GET1^DIQ(90505.01,IENS,3.4,"I")
 ;
NOT(USR,PNL,LCKBY) ;EP -- Send a notification
 NEW SUBJECT,DA,IENS,USRNM
 S DA(1)=USR,DA=PNL,IENS=$$IENS^DILF(.DA)
 S USRNM=$$GET1^DIQ(200,USR_",",.01,"E")
 S SUBJECT="Panel "_$$GET1^DIQ(90505.01,IENS,.01,"E")_" was unable to be autorefreshed"
 I $G(LCKBY)]"" S SUBJECT=SUBJECT_" because it was locked by "_$S(LCKBY[USRNM:"you",1:LCKBY)
 D ADD^BQINOTF("",USR,SUBJECT)
 Q
 ;
ERR ;
 ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $G(USR)'=""&($G(PNL)'="") D
 . D STA(USR,PNL)
 . D ULK(USR,PNL)
 . D EVT("BQI REFRESH PANEL LIST",$$PLID^BQIUG1(USR,PNL))
 I $G(OWNR)'=""&($G(PLIEN)'="") D
 . D STA(OWNR,PLIEN)
 . D ULK(OWNR,PLIEN)
 . D EVT("BQI REFRESH PANEL LIST",$$PLID^BQIUG1(OWNR,PLIEN))
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)="-1"_$C(30)
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
NNOTF(OWNR,PLIEN,SUBJECT) ;EP - Not able to lock notification message
 S SUBJECT=$G(SUBJECT,"")
 I $G(BMXSEC)=""&(SUBJECT="") D NOT(OWNR,PLIEN,$P(LOCK,U,2)) Q
 I SUBJECT="" S SUBJECT="Unable to lock because "_BMXSEC
 D ADD^BQINOTF("",OWNR,SUBJECT)
 Q
