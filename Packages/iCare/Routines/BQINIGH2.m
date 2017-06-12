BQINIGH2 ;VNGT/HS/ALA-Continuation of the nightly job ; 19 Feb 2010  2:02 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
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
 . I ($P($G(^VA(200,USR,0)),U,11)'=""),(+$P($G(^VA(200,USR,0)),U,11)<DT)!($P($G(^VA(200,USR,0)),U,13)'="") D FIX Q
 . ; Check for DISUSER (user has not signed on in a while)
 . I $P($G(^VA(200,USR,0)),U,7)=1 D  Q
 .. NEW LOGIN
 .. S LOGIN=$P($G(^BQICARE(USR,0)),U,6)
 .. I LOGIN="" D FIX Q
 .. I ($E(DT,1,3)-$E(LOGIN,1,3)>0) D FIX Q
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
 K PLIDEN,^XTMP("BQISYTSK")
 D ORD^BQIPLPU
 NEW ORD
 S ORD=""
 F  S ORD=$O(^BQICARE("AF",ORD)) Q:ORD=""  D
 . S USR=""
 . F  S USR=$O(^BQICARE("AF",ORD,USR)) Q:USR=""  D
 .. ; Check for terminated users
 .. ;I ($P($G(^VA(200,USR,0)),U,11)'=""),(+$P($G(^VA(200,USR,0)),U,11)<DT)!($P($G(^VA(200,USR,0)),U,13)'="") Q
 .. S PNL=""
 .. F  S PNL=$O(^BQICARE("AF",ORD,USR,PNL)) Q:'PNL  D
 ... ;  For each panel, check current status, if not currently running, quit
 ... S CSTA=+$$CSTA^BQIPLRF(USR,PNL) I 'CSTA Q
 ... ; Check what tasks are running
 ... ;D ^BQISYTSK
 ... ; repopulate
 ... D POP^BQIPLPP("",USR,PNL,"",USR)
 ... ; Reset description
 ... NEW DA,IENS
 ... S DA(1)=USR,DA=PNL,IENS=$$IENS^DILF(.DA)
 ... K DESC
 ... ;D PEN^BQIPLDSC(USR,PNL,.DESC)
 ... D DESC^BQIPDSCM(USR,PNL,.DESC)
 ... D WP^DIE(90505.01,IENS,5,"","DESC")
 ... K DESC
 ... ; clear status
 ... D STA^BQIPLRF(USR,PNL)
 ... ; unlock panel
 ... D ULK^BQIPLRF(USR,PNL)
 ... ; unlock any panels that are filters
 ... D CPFLU^BQIPLUTL(USR,PNL)
 ... ; unlock any owning panels
 ... S PLIDEN=USR_$C(26)_$P(^BQICARE(USR,1,PNL,0),"^",1)
 ... I $D(^BQICARE("AD",PLIDEN)) D PFILU^BQIPLUTL(USR,PNL,PLIDEN)
 ;
 NEW DA,BQTSK
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.2)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.21)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 F BQTSK="BQIAHOC","BQIBDP","BQIDCAPH","BQIDCASN","BQIPLLK","BQIPLPP","BQIPQMAN" K ^TMP(BQTSK,UID)
 F BQTSK="BQIAHOC","BQIBDP","BQIDCAPH","BQIDCASN","BQIPLLK","BQIPLPP","BQIPQMAN" K ^TMP(UID,BQTSK)
 Q
 ;
FIX ; Fix panels
 NEW DA,IENS,BQIUPD
 S DA(1)=USR,DA=""
 F  S DA=$O(^BQICARE("AC","N",USR,DA)) Q:DA=""  D
 . S IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90505.01,IENS,.06)="@"
 D FILE^DIE("","BQIUPD","ERROR")
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
 ;
 ; Clean up HL7 CANES messages
 NEW MSGIEN,OLD,NODE,WHEN
 S OLD=$$FMADD^XLFDT($$DT^XLFDT,-45)
 S MSGIEN=0
 F  S MSGIEN=$O(^HLB(MSGIEN)) Q:'MSGIEN  D
 . S NODE=$G(^HLB(MSGIEN,0))
 . I $P(NODE,U,5)'="CANES" Q
 . S WHEN=$P(NODE,U,16)
 . I WHEN="" D
 .. NEW HLA
 .. S HLA=$P(NODE,U,2)
 .. S WHEN=$P($G(^HLA(HLA,0)),U,1)\1
 . I WHEN,WHEN<OLD D DELETE^HLOPURGE(MSGIEN)
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
PRN ;EP - Set up Prenatal lab tests
 NEW TN
 S TN=$O(^ATXLAB("B","BQI PRENATAL TAX","")) I TN="" Q
 I $O(^ATXLAB(TN,21,0))="" Q
 D LBT^BQIRGPG
 Q
 ;
HCV ;EP - Set up HCV lab tests
 NEW TN1,TN2
 S TN1=$O(^ATXLAB("B","BQI HCV OTHER LAB TESTS",""))
 S TN2=$O(^ATXLAB("B","BQI HCV BASELINE LAB TESTS",""))
 I TN1="",TN2="" Q
 I $O(^ATXLAB(TN1,21,0))="",$O(^ATXLAB(TN2,21,0))="" Q
 D LBT^BQIRGHPC
 Q
 ;
DMA ;EP - Set up DM Audit fields
 NEW CMIEN
 S CMIEN=$O(^BQI(90506.5,"B","DM Audit","")) I CMIEN="" Q
 I $P(^BQI(90506.5,CMIEN,0),"^",10)=1 Q
 D EN^BQIRGDMA
 Q
 ;
IMM ;EP - Set up Immunizations
 ; Clean out immunizations
 NEW DA,IENS
 S DA=0,DA(1)=8
 F  S DA=$O(^BQI(90506.5,8,10,DA)) Q:'DA  D
 . S IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90506.51,IENS,.09)=1
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; Set up immunizations
 NEW BN,CT,CD,INAC,DA,IENS,DIC,DESC
 S BN=0
 F  S BN=$O(^AUTTIMM(BN)) Q:'BN  D
 . S INAC=$P(^AUTTIMM(BN,0),U,7)=1
 . S NM=$P(^AUTTIMM(BN,0),U,2)
 . S IEN=$O(^BQI(90506.5,8,10,"C",NM,""))
 . I IEN'="" D
 .. I INAC Q
 .. S DA(1)=8,DA=IEN,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90506.51,IENS,.09)="@"
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. S DESC(1)="Most recent immunization event is displayed."
 .. D WP^DIE(90506.51,IENS,4,"","DESC")
 . I IEN="" D
 .. S CT=$P(^BQI(90506.5,8,10,0),U,3),CT=CT+1
 .. S CD="I_"_$E("0000",$L(CT),2)_CT
 .. S DA(1)=8,X=CD,DIC="^BQI(90506.5,"_DA(1)_",10,",DIC(0)="L",DLAYGO=90506.51
 .. K DO,DD D FILE^DICN S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90506.51,IENS,.02)=8,BQIUPD(90506.51,IENS,.03)=NM
 .. S BQIUPD(90506.51,IENS,.04)=BN,BQIUPD(90506.51,IENS,.05)="D"
 .. S BQIUPD(90506.51,IENS,.06)="D",BQIUPD(90506.51,IENS,.08)="A"
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. S DESC(1)="Most recent immunization event is displayed."
 .. D WP^DIE(90506.51,IENS,4,"","DESC")
 ;
TBL ; Set up other tables
 ; Set up Cause of Death
 NEW DN,CD
 K ^XTMP("BQICOD")
 S ^XTMP("BQICOD",0)=$$FMADD^XLFDT(DT,7)_U_DT_U_"Cause of Death Values"
 S DN=0
 F  S DN=$O(^AUPNPAT(DN)) Q:DN=""  D
 . S CD=$P($G(^AUPNPAT(DN,11)),U,14) I CD="" Q
 . S ^XTMP("BQICOD",CD)=""
 ;
 ; Set up Language
 NEW DN,LG,LAN
 K ^XTMP("BQILANG")
 S ^XTMP("BQILANG",0)=$$FMADD^XLFDT(DT,7)_U_DT_U_"Preferred Language Values"
 S DN=0
 F  S DN=$O(^AUPNPAT(DN)) Q:'DN  D
 . S LG=0
 . F  S LG=$O(^AUPNPAT(DN,86,LG)) Q:'LG  D
 .. S LAN=$P(^AUPNPAT(DN,86,LG,0),U,4) I LAN="" Q
 .. S ^XTMP("BQILANG",LAN)=""
 ;
 ; Set up Divisions
 I '$D(^XTMP("BQISYDIV")) D FND^BQISYDIV
 Q
 ;
PRF ;EP - Communication Preference
 NEW VFIEN,PFIEN,BI,TXT,QFL,CODE,DDATA,PDATA,NDATA,BQIX,NPDATA,NNDATA
 S VFIEN=$O(^BQI(90506.3,"B","Patient Edit",""))
 I VFIEN="" Q
 S PFIEN=$O(^BQI(90506.3,VFIEN,10,"AC","REMMETH",""))
 I PFIEN="" Q
 S DDATA=$P($G(^DD(9000001,4002,0)),U,3),QFL=0
 F BI=1:1:$L(DDATA,";") D
 . S TXT=$P($P(DDATA,";",BI),":",2) I TXT="" Q
 . I '$D(^BQI(90506.3,VFIEN,10,PFIEN,5,"B",TXT)) S QFL=1
 I QFL D
 . NEW DA,DIK
 . S DA(2)=VFIEN,DA(1)=PFIEN,DA=0,DIK="^BQI(90506.3,"_DA(2)_",10,"_DA(1)_",5,"
 . F  S DA=$O(^BQI(90506.3,DA(2),10,DA(1),5,DA)) Q:'DA  D ^DIK
 . F BI=1:1:$L(DDATA,";") D
 .. S TXT=$P($P(DDATA,";",BI),":",2),CODE=$P($P(DDATA,";",BI),":",1)
 .. NEW DA,DIC,X
 .. S DA(2)=VFIEN,DA(1)=PFIEN,X=TXT
 .. S DIC="^BQI(90506.3,"_DA(2)_",10,"_DA(1)_",5,",DIC(0)="L"
 .. K DO,DD D FILE^DICN
 .. S DA=+Y
 .. NEW IENS
 .. S IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90506.315,IENS,.02)=CODE
 .. D FILE^DIE("","BQIUPD","ERROR")
 ;
 S PDATA=$P($G(^DD(90509.4,.02,0)),U,3)
 S NDATA=$P($G(^DD(90509.4,.03,0)),U,3)
 F BI=1:1:$L(DDATA,";") D
 . S TXT=$P($P(DDATA,";",BI),":",2),CODE=$P($P(DDATA,";",BI),":",1)
 . I CODE="" Q
 . I TXT["NOT NOTIFY" Q
 . S BQIX(CODE)=TXT
 S OK=1 F BI=1:1:$L(PDATA,";") D
 . S TXT=$P($P(PDATA,";",BI),":",2),CODE=$P($P(PDATA,";",BI),":",1)
 . I CODE="" Q
 . I $G(BQIX(CODE))=TXT Q
 . S OK=0
 I 'OK D
 . S CODE="",NPDATA=""
 . F  S CODE=$O(BQIX(CODE)) Q:CODE=""  S NPDATA=NPDATA_CODE_":"_BQIX(CODE)_";"
 . S $P(^DD(90509.4,.02,0),U,3)=NPDATA
 S OK=1 F BI=1:1:$L(NDATA,";") D
 . S TXT=$P($P(NDATA,";",BI),":",2),CODE=$P($P(NDATA,";",BI),":",1)
 . I CODE="" Q
 . I $G(BQIX(CODE))=TXT Q
 . S OK=0
 I 'OK D
 . S CODE="",NNDATA=""
 . F  S CODE=$O(BQIX(CODE)) Q:CODE=""  S NNDATA=NNDATA_CODE_":"_BQIX(CODE)_";"
 . S $P(^DD(90509.4,.03,0),U,3)=NNDATA
 Q
