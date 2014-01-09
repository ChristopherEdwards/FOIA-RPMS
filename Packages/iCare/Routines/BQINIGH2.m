BQINIGH2 ;VNGT/HS/ALA-Continuation of the nightly job ; 19 Feb 2010  2:02 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**1**;Apr 18, 2012;Build 43
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
 S BQINIGHT=1
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLRF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S USR=""
 F  S USR=$O(^BQICARE("AC","N",USR)) Q:'USR  D
 . ; Check for terminated users
 . I ($P($G(^VA(200,USR,0)),U,11)'=""),(+$P($G(^VA(200,USR,0)),U,11)<DT) Q
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
 ... D NNOTF^BQIPLRF(USR,PNL,SUBJECT)
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
 . ; Check for terminated users
 . I ($P($G(^VA(200,USR,0)),U,11)'=""),(+$P($G(^VA(200,USR,0)),U,11)<DT) Q
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
 .. ;D PEN^BQIPLDSC(USR,PNL,.DESC)
 .. D DESC^BQIPDSCM(USR,PNL,.DESC)
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
 NEW DA,BQTSK
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.2)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.21)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 F BQTSK="BQIAHOC","BQIBDP","BQIDCAPH","BQIDCASN","BQIPLLK","BQIPLPP","BQIPQMAN" K ^TMP(BQTSK,UID)
 Q
 ;
CMA ;EP - Do Community Alerts
 NEW DA,BQTSK
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.16)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.18)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB D UNWIND^%ZTER"
 D ^BQICALRT
 D ^BQICASUI
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.17)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.18)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 F BQTSK="BQIALRTTMP","BQIPRCR","BQITAX","BQIALERT" K ^TMP(BQTSK,UID)
 ;
 ; Do Export
 D ^BQICAEXP
 Q
 ;
ARM ;EP - Check and set up the 'ALL REMINDERS' Patient Health Summary Definition if needed
 I '$$FIND1^DIC(9001015,"","","ALL REMINDERS","B","","") D
 . N X,Y,DA,DR,DIC,DLAYGO,CMPNDX,REMNDX
 . ;
 . ; Create top level for 'ALL REMINDERS' Hlth Summary
 . S X="ALL REMINDERS",DIC(0)="LZ",DLAYGO=9001015,DIC="^APCHSCTL("
 . D FILE^DICN
 . ;
 . ; Build Sort Order Sub-File
 . N DIC,DA,DIE,DR,X,BQIUPD
 . S DLAYGO=9001015.01
 . S (DA(1),REMNDX)=+Y,DA=10,DIC(0)="LZ",DIC="^APCHSCTL("_DA(1)_",1,"
 . D FILE^DICN
 . ;
 . ; Add Component IEN for Reminders (from 9001016) to Hlth Summary
 . S CMPNDX=$$FIND1^DIC(9001016,"","","HEALTH MAINTENANCE REMINDERS","B","","")
 . Q:'CMPNDX
 . S DA(1)=REMNDX,DA=10,DIE=DIC
 . S DR=".01////"_DA_";1////"_CMPNDX
 . D ^DIE
 . ;
 . ; Build Health Summary nodes.
 . N DIC,DA,NDX,NDX2,RMNDR,X,Y,DR
 . S DA(1)=REMNDX,DLAYGO=9001015.06,DIC(0)="LZ"
 . S DIC="^APCHSCTL("_DA(1)_",5,"
 . D FILE^DICN
 . S NDX=""
 . F  S NDX=$O(^APCHSURV("AC",NDX)) Q:NDX=""  D
 .. S RMNDR=""
 .. F  S RMNDR=$O(^APCHSURV("AC",NDX,RMNDR)) Q:RMNDR=""  D
 ... I $$GET1^DIQ(9001018,RMNDR,.07,"I")'="R" Q
 ... I $$GET1^DIQ(9001018,RMNDR,.03,"I")'="D" D
 .... S (DA,NDX2)=(NDX*100)+RMNDR,DIE=DIC
 .... S DR=".01////"_NDX2_";1////"_RMNDR
 .... D ^DIE
 .... Q
 Q
 ;
IMM ;EP - Set up Immunizations
 ; Clean out immunizations
 NEW DA,DIK
 S DA=0,DA(1)=8,DIK="^BQI(90506.5,"_DA(1)_",10,"
 F  S DA=$O(^BQI(90506.5,8,10,DA)) Q:'DA  D ^DIK
 ;
 ; Set up immunizations
 NEW BN,CT,CD
 S BN=0,CT=0
 F  S BN=$O(^AUTTIMM(BN)) Q:'BN  D
 . I $P(^AUTTIMM(BN,0),U,7)=1 Q
 . S NM=$P(^AUTTIMM(BN,0),U,2)
 . S CT=CT+1
 . S CD="I_"_$E("0000",$L(CT),2)_CT
 . S ^BQI(90506.5,8,10,CT,0)=CD_"^8^"_NM_U_BN_"^D^D^"
 . S ^BQI(90506.5,8,10,"B",CD,CT)=""
 ;
 S ^BQI(90506.5,8,10,0)="^90506.51^"_CT_U_CT
 Q
