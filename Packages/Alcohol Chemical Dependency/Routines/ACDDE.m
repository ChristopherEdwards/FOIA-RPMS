ACDDE ;IHS/ADC/EDE/KML - CDMIS DATA ENTRY;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;This is the data entry driver routine for CDMIS.  This
 ;routine will ask for COMPONENT CODE/TYPE, then for TYPE CONTACT,
 ;then for PROVIDER if not CS, then VISIT DATE.  The form of the
 ;date will vary based on TYPE CONTACT.  If client/patient
 ;related the client/patient is then selected.  In any case,
 ;control is then passed to the appropriate INPUT TEMPLATE for
 ;that TYPE CONTACT.
 ;
 Q  ;          cannot enter from top
 ;
ADD ; EP - ADD CDMIS FORMS
 S ACDMODE="A"
 D MAIN
 Q
 ;
MAIN ; MAINLINE LOGIC
 D INIT^ACDDE2
 I ACDQ D EOJ Q
 F  D OUTERLP Q:ACDQ  ; loop at outer level (for CS)
 D EOJ
 Q
 ;
OUTERLP ; OUTER LOOP FOR CS (NO PRIMARY PROVIDER)
 S ACDLPTYP=1
 S (ACDCONT,ACDCONTL)=""
 D HDR^ACDDEU
 D GETTC^ACDDE2 ;      get type contact
 Q:ACDQ
 I ACDCONT="CS" D  F  D DATELP Q:ACDQ  ;loop at date level
 . S DIC=6,DIC(0)="AEMQZ",DIC("A")="Enter default provider to credit workload: " D DIC^ACDFMC
 . Q:Y<0
 . S ACDCSDP=Y(0,0) ;  save name of default provider
 . Q
 Q:ACDQ
 S ACDBYPAS=1
 F  D PROVLP Q:ACDQ  ; loop at provider level
 Q
 ;
PROVLP ; LOOP AT PROVIDER LEVEL
 S (ACDPROV,ACDPROVN)=""
 D HDR^ACDDEU
 D GETPROV^ACDDE2 ;   get primary provider
 Q:ACDQ
 F  D TCDLP Q:ACDQ  ; loop at type contact and date level
 S ACDQ=0
 Q
 ;
TCDLP ; LOOP AT TYPE CONTACT AND DATE LEVEL
 S:'$G(ACDBYPAS) (ACDCONT,ACDCONTL)=""
 S (ACDVDTI,ACDVDTE)=""
 D HDR^ACDDEU
 D:'$G(ACDBYPAS) GETTC^ACDDE2 ;     get type contact
 K ACDBYPAS
 Q:ACDQ
 S:ACDCONT="CS" ACDCSDP=ACDPROVN ;  set name of default provider
 Q:ACDQ
 D GETVDATE^ACDDE2 ;  get visit date
 Q:ACDQ
 ; IR and OT not patient related so do and get out
 I ACDCONT="IR" D ADDTC Q
 I ACDCONT="OT" D ADDTC Q
 F  D PATLP Q:ACDQ  ; loop at patient level
 S ACDQ=0
 Q
 ;
DATELP ; LOOP AT DATE LEVEL FOR CS ONLY
 S ACDLPTYP=2
 S (ACDVDTI,ACDVDTE)=""
 D HDR^ACDDEU
 D GETVDATE^ACDDE2 ;  get visit date
 Q:ACDQ
 F  D PATLP Q:ACDQ  ; loop at patient level
 S ACDQ=0
 Q
 ;
PATLP ; LOOP AT PATIENT LEVEL
 D HDR^ACDDEU
 S ACDQ=1
 D ^ACDDEGP ;         get patient
 Q:ACDQ
 D GETVSITS^ACDDEU ;  gather all cdmis visits for this client
 D ADDTC ;            add data based on type contact
 I ACDQ,'$D(DTOUT),'$D(DUOUT) D:ACDQ=1 DSPHIST^ACDDEU,PAUSE^ACDDEU Q
 I ACDCONT="IN"!(ACDCONT="TD")!(ACDCONT="RE") S ACDQ=1
 Q
 ;
ADDTC ; ADD DATA BASED ON TYPE CONTACT
 S ACDVIEN=0
 D @("ADD"_ACDCONT_"^ACDDE3")
 Q:'ACDVIEN
 ; Do not delete visit if timed out and contact type is CS
 I ACDVIEN,ACDCONT'="CS",$D(DTOUT) S ACDVISP=ACDVIEN D AUTO^ACDDIK Q
 S ACDVISP=ACDVIEN
 D CHK
 I ACDFHCP,$G(ACDDFNP),$D(ACDPCCL(ACDDFNP)) D SAVBILL
 I ACDFPCC,$G(ACDDFNP),$D(ACDPCCL(ACDDFNP)) D ^ACDPCCL
 Q
 ;
CHK ;
 NEW ACDVIEN
 I $G(ACDDFNP) S X=ACDDFNP NEW ACDDFNP S ACDDFNP=X
 Q:'$D(ACDVISP)
 K ACDTOUT
 I $O(^ACDIIF("C",ACDVISP,0)) Q  ;  quit if entry in ^ACDIIF
 ;
 ;If the visit was a 'TDC' ask user to duplicate with an
 ;initial or re-open visit
 I $O(^ACDTDC("C",ACDVISP,0)) NEW ACDCONT,ACDCOMC,ACDCOMT D EN^ACDAUTO Q
 ;
 ;If the visit was a new client service visit or an old client
 ;service visit to which client services were added then ask
 ;the user to exactly duplicate them for other patients.
 I $G(ACDDECSN)!($D(ACDCS)) D EN^ACDAUTO1 Q
 ;
 Q:ACDCONT="CS"  ;     allow a CS visit with no CS entries
 ; if I get here visit is incomplete
 S ACDTOUT=1 K:((ACDFHCP+ACDFPCC)&($G(ACDDFNP))) ACDPCCL(ACDDFNP,ACDVISP) D AUTO^ACDDIK
 Q
 ;
SAVBILL ; EP-SAVE DATA FOR BILLING
 ; Note - should get here once for each CDMIS VISIT
 ; Local array set as CDMIS entries added or edited:
 ;     ACDPCCL(patient ien,visit ien)=""
 ;     ACDPCCL(patient ien,visit ien,"CS",cs ien)=""
 ;     ACDPCCL(patient ien,visit ien,"IIF",iif ien)=""
 ;     ACDPCCL(patient ien,visit ien,"TDC",tdc ien)=""
 ;
 D SAVBILL2
 I 'ACDFPCC K ACDPCCL(ACDDFNP,ACDVIEN)
 Q
 ;
SAVBILL2 ;
 I ACDFHCPT,'$D(ACDFHCPT(ACDCOMC)) Q  ;  quit if not wanted component
 NEW ACDBFT,ACDBIEN,ACDCSIEN
 S ACDBFT=$S(ACDCONT="CS":3,ACDCONT="TD":2,1:1)
 I '$O(ACDPCCL(ACDDFNP,ACDVIEN,$S(ACDBFT=3:"CS",ACDBFT=2:"TDC",1:"IIF"),0)) Q  ;                          should never happen
 S X=DT,DIC="^ACDBILL(",DIC(0)="L",DIC("DR")=".02////"_ACDDFNP_";.03////"_ACDBFT_";.04////"_ACDVIEN_$S(ACDMODE="E":";.09////1",1:"")
 I ACDBFT'=3 S DIC("DR")=DIC("DR")_";"_$S(ACDBFT=2:".06",1:".05")_"////"_$O(ACDPCCL(ACDDFNP,ACDVIEN,$S(ACDBFT=2:"TDC",1:"IIF"),0))
 D FILE^ACDFMC
 I Y<0 W !!,"Adding of CDMIS BILL RECORD failed.  Notify programmer.",!! Q
 Q:ACDBFT'=3  ;           quit if not CS
 S ACDBIEN=+Y
 S ACDCSIEN=0
 F  S ACDCSIEN=$O(ACDPCCL(ACDDFNP,ACDVIEN,"CS",ACDCSIEN)) Q:'ACDCSIEN  D
 .  S X=ACDCSIEN,DA(1)=ACDBIEN,DIC="^ACDBILL("_DA(1)_",21,",DIC(0)="L",DIC("P")=$P(^DD(9002172.9,2100,0),U,2)
 .  D FILE^ACDFMC
 .  I Y<0 W !!,"Adding of CS pointer failed.  Notify programmer.",!! Q
 .  Q
 Q
 ;
EOJ ; END OF JOB
 D ^ACDKILL
 Q
