BQINIGH2 ;VNGT/HS/ALA-Continuation of the nightly job ; 19 Feb 2010  2:02 PM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
NGHT ;EP - Nightly Update of panels
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.19)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.21)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 NEW USR,PNL,LGLOB,LOCK,BQINIGHT,PLIDEN,LFLG,CSTA
 ;NEW UID,USR,PNL,LGLOB,LOCK,BQINIGHT,PLIDEN,LFLG,CSTA
 ;S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S BQINIGHT=1
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLRF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S USR=""
 F  S USR=$O(^BQICARE("AC","N",USR)) Q:'USR  D
 . S PNL=""
 . F  S PNL=$O(^BQICARE("AC","N",USR,PNL)) Q:'PNL  D
 .. ; Lock panel to be repopulated
 .. S LOCK=$$LCK^BQIPLRF(USR,PNL)
 .. ; If not able to lock panel, clear status, send notification and go to next one
 .. I 'LOCK D  Q
 ... D STA^BQIPLRF(USR,PNL)
 ... D NNOTF^BQIPLRF(USR,PNL)
 .. ;
 .. ; Check if locked panel has panel filters
 .. NEW PLSUCC,SUBJECT,LOCK,POWNR,PPLIEN
 .. S PLSUCC=$$CPFL^BQIPLUTL(USR,PNL)
 .. ; If panel contains panel filters and were not successful in being locked,
 .. ;  clear status, send notification and go to next panel in list
 .. I 'PLSUCC D  Q
 ... D STA^BQIPLRF(USR,PNL)
 ... D ULK^BQIPLRF(USR,PNL)
 ... S SUBJECT="Unable to lock panel(s) that are filters for panel: "_$P(^BQICARE(USR,1,PNL,0),U,1)
 ... S LOCK="0^"_$P(PLSUCC,U,2),POWNR=$P(PLSUCC,U,4),PPLIEN=$P(PLSUCC,U,5)
 ... I $P(PLSUCC,U,3)'="" S BMXSEC=$P(PLSUCC,U,3),SUBJECT=""
 ... D NNOTF^BQIPLRF(OWNR,PLIEN,SUBJECT)
 .. ;
 .. ; Check if panel is a panel filter
 .. S PLIDEN=USR_$C(26)_$P(^BQICARE(USR,1,PNL,0),"^",1)
 .. I $D(^BQICARE("AD",PLIDEN)) D  Q:LFLG
 ... S LFLG=0 D PFILL^BQIPLUTL(USR,PNL,PLIDEN)
 ... ; If not able to lock any of the owning panels, unlock owning panel, clear status, unlock panel and quit
 ... I LFLG D PFILU^BQIPLUTL(USR,PNL,PLIDEN),STA^BQIPLRF(USR,PNL),ULK^BQIPLRF(USR,PNL)
 .. ; Set status to currently running
 .. D STA^BQIPLRF(USR,PNL,1)
 ;
 K PLIDEN
 S USR=""
 F  S USR=$O(^BQICARE("AC","N",USR)) Q:USR=""  D
 . S PNL=""
 . F  S PNL=$O(^BQICARE("AC","N",USR,PNL)) Q:'PNL  D
 .. ;  For each panel, check current status, if not currently running, quit
 .. S CSTA=+$$CSTA^BQIPLRF(USR,PNL) I 'CSTA Q
 .. ; repopulate
 .. D POP^BQIPLPP("",USR,PNL,"",USR)
 .. ; Reset description
 .. NEW DA,IENS
 .. S DA(1)=USR,DA=PNL,IENS=$$IENS^DILF(.DA)
 .. K DESC
 .. D PEN^BQIPLDSC(USR,PNL,.DESC)
 .. D WP^DIE(90505.01,IENS,5,"","DESC")
 .. K DESC
 .. ; clear status
 .. D STA^BQIPLRF(USR,PNL)
 .. ; unlock panel
 .. D ULK^BQIPLRF(USR,PNL)
 .. ; unlock any panels that are filters
 .. D CPFLU^BQIPLUTL(USR,PNL)
 .. ; unlock any owning panels
 .. S PLIDEN=USR_$C(26)_$P(^BQICARE(USR,1,PNL,0),"^",1)
 .. I $D(^BQICARE("AD",PLIDEN)) D PFILU^BQIPLUTL(USR,PNL,PLIDEN)
 ;
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.2)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.21)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
