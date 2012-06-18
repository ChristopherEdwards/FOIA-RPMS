BQI202PS ;VNGT/HS/ALA-Version 2.0 Patch 2 Post-Install ; 11 Dec 2008  1:47 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN ; Entry point
 ;
 NEW IEN
 S IEN=$O(^BQI(90507,"B","ASTHMA",""))
 I IEN'="" S BQIUPD(90507,IEN_",",.01)="Asthma" D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; Set up the new specialty providers
 D DSPM^BQINIGH1
 ;
 ; Update default value to optional
 S DIEN=$O(^BQI(90506.1,"B","PADD",""))
 I DIEN'="" S $P(^BQI(90506.1,DIEN,3),U,4)="O"
 ;
 ; Change NEW CATEGORY value
 D CAT^BQI202PU
 ;
 ; Inactivate Case Manager as it will now be part of the specialty providers
 S DIEN=$O(^BQI(90506.1,"B","CM",""))
 S $P(^BQI(90506.1,DIEN,0),U,10)=1,$P(^BQI(90506.1,DIEN,0),U,11)=DT
 ;
 ; Set Task to clean up old format CRS data
 S ZTDESC="ICARE CRS CLEANUP",ZTRTN="CRS^BQI202PS",ZTIO=""
 S JBDATE=$$FMADD^XLFDT($$NOW^XLFDT(),,,3)
 S ZTDTH=JBDATE
 D ^%ZTLOAD
 K ZTDESC,ZTRTN,ZTIO,JBDATE,ZTDTH,ZTSK
 ;
ASM ; Add Allergy entries to 90506.1 and set up Allergy View
 D EN^DDIOL("Updating new Allergy Care Management View items")
 ; Clean up inactive flags and dates
 NEW NM
 S NM="AS"
 F  S NM=$O(^BQI(90506.1,"B",NM)) Q:NM=""!($E(NM,1,2)'="AS")  D
 . I NM["ASHMR" Q
 . I NM["AST_" Q
 . S IEN=$O(^BQI(90506.1,"B",NM,"")) Q:IEN=""
 . S BQIUPD(90506.1,IEN_",",.1)="@"
 . S BQIUPD(90506.1,IEN_",",.11)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 NEW TEXT,BQIUPD,ERROR,BI,BJ,NDATA,ND,VAL,TXT,IEN,BK
 F BI=1:1 S TEXT=$P($T(VIEW+BI),";;",2) Q:TEXT=""  D  W "."
 . F BJ=1:1:$L(TEXT,"~") D
 .. S NDATA=$P(TEXT,"~",BJ)
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. I ND=0 D
 ... NEW DIC
 ... S DIC(0)="LQZ",DIC="^BQI(90506.1,",X=$P(VAL,U,1)
 ... D ^DIC
 ... S IEN=+Y
 ... I IEN=-1 K DO,DD D FILE^DICN S IEN=+Y
 .. I ND=1 S BQIUPD(90506.1,IEN_",",1)=VAL Q
 .. I ND=5 S BQIUPD(90506.1,IEN_",",5)=VAL Q
 .. F BK=1:1:$L(VAL,"^") D
 ... S BN=$O(^DD(90506.1,"GL",ND,BK,""))
 ... I $P(VAL,"^",BK)'="" S BQIUPD(90506.1,IEN_",",BN)=$P(VAL,"^",BK)
 . D FILE^DIE("","BQIUPD","ERROR")
 ;
 F TXT="ASCSMGR","ASDD","ASLFEF","ASLPEF","ASMGPLDT","ASSEVDT" D
 . S IEN=$O(^BQI(90506.1,"B",TXT,"")) I IEN="" Q
 . S BQIUPD(90506.1,IEN_",",.1)=1,BQIUPD(90506.1,IEN_",",.11)=DT
 . S BQIUPD(90506.1,IEN_",",3.05)="@"
 ;
 S IEN=$O(^BQI(90506.5,"B","Asthma",""))
 I IEN'="" S BQIUPD(90506.5,IEN_",",.04)=1
 S IEN=$O(^BQI(90507,"B","Asthma",""))
 I IEN'="" S BQIUPD(90507,IEN_",",.16)=1
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; Set tooltips
 D TPS^BQI202PU
 ;
 S DIK="^BQI(90506.1,"
 D IXALL^DIK
 ;
 ; Set community taxonomies
 D CTX^BQI202PU
 ;
 ; Check to reset diagnosis code pointers
 D DX^BQI202PU
 ;
 ;Special code to remove H1N1 Associated Community Alert from 90507.6
 N CMIEN,ATIEN,DCIEN,DXCAT
 S CMIEN=0 F  S CMIEN=$O(^BQI(90507.6,CMIEN)) Q:'CMIEN  D
 . S ATIEN=0 F  S ATIEN=$O(^BQI(90507.6,CMIEN,1,ATIEN)) Q:'ATIEN  D
 .. S DCIEN=0 F  S DCIEN=$O(^BQI(90507.6,CMIEN,1,ATIEN,1,DCIEN)) Q:'DCIEN  D
 ... S DXCAT=$P($G(^BQI(90507.6,CMIEN,1,ATIEN,1,DCIEN,0)),U)
 ... Q:DXCAT'["H1N1 Associated"
 ... N DA,DIK
 ... S DA(2)=CMIEN,DA(1)=ATIEN,DA=DCIEN
 ... S DIK="^BQI(90507.6,"_DA(2)_",1,"_DA(1)_",1,"
 ... D ^DIK
 ;
 ;Validate Panel Layout structures
 D PNLFX^BQI202PU
 ;
 ;Set the version number
 NEW DA
 S DA=$O(^BQI(90508,0))
 S BQIUPD(90508,DA_",",.08)="2.0.2.15"
 S BQIUPD(90508,DA_",",.09)="2.0.2T15"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ;  Set up Asthma care management data program
 S ZTDESC="ICARE ASTHMA UPDATE",ZTRTN="CMGT^BQITASK3",ZTIO=""
 S JBNOW=$$NOW^XLFDT()
 S JBDATE=$S($E($P(JBNOW,".",2),1,2)<20:DT,1:$$FMADD^XLFDT(DT,+1))
 S ZTDTH=JBDATE_".20"
 D ^%ZTLOAD
 K ZTDESC,ZTRTN,ZTIO,JBNOW,JBDATE,ZTDTH,ZTSK
 ;
 D ^BQISCHED
 ;
CBP ; Update CVD Best Practice Prompts for Health Summary
 NEW BQTIEN,NAME,AIEN,BQIUPD,INACT
 I $O(^APCHSURV("A"),-1)'=$P(^APCHSURV(0),U,3) S $P(^APCHSURV(0),U,3)=$O(^APCHSURV("A"),-1)
 S BQTIEN=0
BP S BQTIEN=$O(^BQI(90508.5,BQTIEN)) Q:'BQTIEN
 S NAME=$P(^BQI(90508.5,BQTIEN,0),U,1),INACT=$P(^(0),U,4)
 S AIEN=$$FIND1^DIC(9001018,"","BX",NAME,"","","ERROR")
 ; If it does not exist and is inactive, go to next one
 I 'AIEN,INACT G BP
 ; If it exists and is inactive, set it to "deleted"
 I AIEN,INACT S BQIUPD(9001018,AIEN_",",.03)="D"
 I 'AIEN D ADD
 S BQIUPD(9001018,AIEN_",",.03)=1
 S BQIUPD(9001018,AIEN_",",.07)="T"
 D FILE^DIE("","BQIUPD","ERROR")
 S BQIUPD(9001018,AIEN_",",.05)="CVD-RELATED"
 S BQIUPD(9001018,AIEN_",",1)="APCH;BQITRPHS"
 D FILE^DIE("E","BQIUPD","ERROR")
 D WP^DIE(9001018,AIEN_",",2,"","^BQI(90508.5,BQTIEN,3)")
 D WP^DIE(9001018,AIEN_",",1300,"","^BQI(90508.5,BQTIEN,4)")
 G BP
 ;
ADD ;
 NEW DIC,DLAYGO,X
 S DIC="^APCHSURV(",DLAYGO=9001018,DIC("P")=DLAYGO,X=NAME,DIC(0)="L"
 K DO,DD D FILE^DICN
 S AIEN=+Y
 Q
 ;
CM ; EP - Replace case manager layout entries with new case manager
 ;        values loaded from DSPM
 NEW CM,BDPCM,CMIEN,BDPIEN,DA,DIK,IENS,BQIUPD,SHRIEN
 S CM=$O(^BQI(90506.1,"B","CM","")) Q:CM=""
 S BDPCM=$O(^BQI(90506.1,"B","BDPCM","")) Q:BDPCM=""
 ;
 S OWNR=0
 F  S OWNR=$O(^BQICARE(OWNR)) Q:'OWNR  D
 . S PLIEN=0
 . F  S PLIEN=$O(^BQICARE(OWNR,1,PLIEN)) Q:'PLIEN  D
 .. S CMIEN=$O(^BQICARE(OWNR,1,PLIEN,20,"B",CM,"")) Q:CMIEN=""
 .. Q:'$D(^BQICARE(OWNR,1,PLIEN,20,CMIEN,0))
 .. K ERROR
 .. S BDPIEN=$O(^BQICARE(OWNR,1,PLIEN,20,"B",BDPCM,""))
 .. D
 ... ; If both exist delete CM entry
 ... I BDPIEN'="",$D(^BQICARE(OWNR,1,PLIEN,20,BDPIEN,0)) D  Q
 ....  S DA(2)=OWNR,DA(1)=PLIEN,DIK="^BQICARE("_DA(2)_",1,"_DA(1)_",20,"
 ....  S DA=CMIEN
 ....  D ^DIK
 ....  K DA,DIK
 ... ;
 ... ; Replace old case manager with new case manager
 ... S DA(2)=OWNR,DA(1)=PLIEN,DA=CMIEN
 ... S IENS=$$IENS^DILF(.DA)
 ... S BQIUPD(90505.05,IENS,.01)=BDPCM
 ... D FILE^DIE("","BQIUPD","ERROR")
 ... K BQIUPD
 .. ;
 .. D PTYP(22,90505.122) ; Reminders View
 .. D PTYP(25,90505.125) ; GPRA View
 .. ;
 .. ; Shared Users
 .. S SHRIEN=0
 .. F  S SHRIEN=$O(^BQICARE(OWNR,1,PLIEN,30,SHRIEN)) Q:'SHRIEN  D
 ... S CMIEN=$O(^BQICARE(OWNR,1,PLIEN,30,SHRIEN,20,"B",CM,"")) Q:CMIEN=""
 ... Q:'$D(^BQICARE(OWNR,1,PLIEN,30,SHRIEN,20,CMIEN,0))
 ... K ERROR
 ... S BDPIEN=$O(^BQICARE(OWNR,1,PLIEN,30,SHRIEN,20,"B",BDPCM,""))
 ... D
 .... ; If both exist delete CM entry
 .... I BDPIEN'="",$D(^BQICARE(OWNR,1,PLIEN,30,SHRIEN,20,BDPIEN,0)) D  Q
 .....  S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=SHRIEN
 .....  S DIK="^BQICARE("_DA(3)_",1,"_DA(2)_",30,"_DA(1)_",20,"
 .....  S DA=CMIEN
 .....  D ^DIK
 .....  K DA,DIK
 .... ;
 .... ; Replace old case manager with new case manager
 .... S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=SHRIEN,DA=CMIEN
 .... S IENS=$$IENS^DILF(.DA)
 .... S BQIUPD(90505.06,IENS,.01)=BDPCM
 .... D FILE^DIE("","BQIUPD","ERROR")
 .... K BQIUPD,IENS
 ... ;
 ... D STYP(22,90505.322) ; Reminders View
 ... D STYP(25,90505.325) ; GPRA View
 Q
 ;
PTYP(ND,FIL) ; EP - PANEL VIEWS
 ;
 ;Input
 ;  ND - Node associated with specified view
 ;  FIL - File number for the view
 ;
 S CMIEN=$O(^BQICARE(OWNR,1,PLIEN,ND,"B","CM","")) Q:CMIEN=""
 Q:'$D(^BQICARE(OWNR,1,PLIEN,ND,CMIEN,0))
 K ERROR
 S BDPIEN=$O(^BQICARE(OWNR,1,PLIEN,ND,"B","BDPCM",""))
 ;
 ; If both exist delete CM entry
 I BDPIEN'="",$D(^BQICARE(OWNR,1,PLIEN,ND,BDPIEN,0)) D  Q
 . S DA(2)=OWNR,DA(1)=PLIEN,DIK="^BQICARE("_DA(2)_",1,"_DA(1)_","_ND_","
 . S DA=CMIEN
 . D ^DIK
 . K DA,DIK
 ;
 ; Replace old case manager with new case manager
 S DA(2)=OWNR,DA(1)=PLIEN,DA=CMIEN
 S IENS=$$IENS^DILF(.DA)
 S BQIUPD(FIL,IENS,.01)="BDPCM"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
STYP(ND,FIL) ; EP - SHARED USERS VIEWS
 ;
 ;Input
 ;  ND - Node associated with specified view
 ;  FIL - File number for the view
 ;
 S CMIEN=$O(^BQICARE(OWNR,1,PLIEN,30,SHRIEN,ND,"B","CM","")) Q:CMIEN=""
 Q:'$D(^BQICARE(OWNR,1,PLIEN,30,SHRIEN,ND,CMIEN,0))
 S BDPIEN=$O(^BQICARE(OWNR,1,PLIEN,30,SHRIEN,ND,"B","BDPCM",""))
 K ERROR
 ;
 ; If both exist delete CM entry
 I BDPIEN'="",$D(^BQICARE(OWNR,1,PLIEN,30,SHRIEN,ND,BDPIEN,0)) D  Q
 . S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=SHRIEN
 . S DIK="^BQICARE("_DA(3)_",1,"_DA(2)_",30,"_DA(1)_","_ND_","
 . S DA=CMIEN
 . D ^DIK
 . K DA,DIK
 ;
 ; Replace old case manager with new case manager
 S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=SHRIEN,DA=CMIEN
 S IENS=$$IENS^DILF(.DA)
 S BQIUPD(FIL,IENS,.01)="BDPCM"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD,IENS
 Q
 ;
CRS ;EP - Clean up deceased patient's CRS measures
 NEW DFN,CRSN
 S DFN=0
 F  S DFN=$O(^BQIPAT(DFN)) Q:'DFN  D
 . I $G(^BQIPAT(DFN,0))="" K ^BQIPAT(DFN) Q
 . ; If the CRS version is old, delete it
 . I $P(^BQIPAT(DFN,0),"^",2)<2008 K ^BQIPAT(DFN,30)
 . ; Clean up flag levels
 . NEW FL,DIK,DA
 . S FL=0
 . F  S FL=$O(^BQIPAT(DFN,10,FL)) Q:'FL  D
 .. I $O(^BQIPAT(DFN,10,FL,5,0))="" D
 ... S DA(1)=DFN,DA=FL,DIK="^BQIPAT("_DA(1)_",10," D ^DIK
 . S CRSN=0
 . F  S CRSN=$O(^BQIPAT(DFN,30,CRSN)) Q:'CRSN  D
 .. ; If the first piece is still a strict pointer instead of YEAR_#, then it is the
 .. ; old format and needs to be deleted
 .. I $P(^BQIPAT(DFN,30,CRSN,0),"^",1)?.N K ^BQIPAT(DFN,30) Q
 . ; Check for no data at all
 . NEW DA,DIK
 . S DIK="^BQIPAT("
 . I $O(^BQIPAT(DFN,10,0))="",$O(^BQIPAT(DFN,20,0))="",$O(^BQIPAT(DFN,30,0))="",$O(^BQIPAT(DFN,40,0))="",$O(^BQIPAT(DFN,50,0))="" S DA=DFN D ^DIK
 ; 
 ; Update panels with existing NUMVIS filter to include "'<" since number of
 ; visits was originally a minimum value
 ;
 NEW OWNR,PLIEN,FLTR,NUMVIS
 S OWNR=0
 F  S OWNR=$O(^BQICARE(OWNR)) Q:'OWNR  D
 . S PLIEN=0
 . F  S PLIEN=$O(^BQICARE(OWNR,1,PLIEN)) Q:'PLIEN  D
 .. S FLTR=$O(^BQICARE(OWNR,1,PLIEN,15,"B","NUMVIS","")) Q:FLTR=""
 .. S NUMVIS=$G(^BQICARE(OWNR,1,PLIEN,15,FLTR,0))
 .. Q:NUMVIS'?1"NUMVIS^"1N.N
 .. S NUMVIS=$S(NUMVIS="NUMVIS^0":"NUMVIS^<1",1:"NUMVIS^'<"_$P(NUMVIS,U,2)),^BQICARE(OWNR,1,PLIEN,15,FLTR,0)=NUMVIS
 .. ; Update generated description to reflect change
 .. NEW DA,IENS
 .. S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 .. K DESC
 .. D PEN^BQIPLDSC(OWNR,PLIEN,.DESC)
 .. D WP^DIE(90505.01,IENS,5,"","DESC")
 .. K DESC,BMXSEC
 ;
 D CM
 Q
 ;
VIEW ; Add new View Items
 ;;0|EMAIL^^Email Address^^9000001^1802^^T00065EMAIL^^^^^^^^1~1|~3|1^^Address^O^34~5|
 ;;0|COM^9^Community^D^9000001^1117^^T00030COM^O^^^O^O^^95~1|~3|1^^Demographics^D^9~5|
 ;;0|ASACON^^Asthma Control^^^^^T00030ASACON~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^D^7~5|S VAL="",OTHER="",VISIT="",VAL=$$LASTACON^APCHSMAS(DFN,4),OTHER=$$FMTE^BQIUL1($$LASTACON^APCHSMAS(DFN,2))
 ;;0|ASACT^^Last Action Plan^^^^^T01024ASACT~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^D^9~5|S VAL=$$FED^BQITRUTL("",DFN,"ASM-SMP"),VISIT=$P(VAL,U,4),VAL=$$FMTE^BQIUL1($P(VAL,U,2)),OTHER=""
 ;;0|ASAQC^^Asthma Quality of Care^^^^^T00003ASAQC~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^D^^^^^1~5|S VAL=$P($$AQC^BQIRGASU(DFN),U,1)
 ;;0|ASCNTRL^^On Controller Meds^^^^^T00003ASCNTRL~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^O^18~5|S VAL=$$CNTRL^BQIRGASU(DFN),OTHER=$P(VAL,U,2),VISIT=$P(VAL,U,3),VAL=$P(VAL,U,1)
 ;;0|ASCSMGR^6^Case Manager^O^90181.01^.12^^T00035ASCSMGR^^1^3090317~1|~3|4^^^D^6~5|
 ;;0|ASDD^3^Due Date^O^90181.01^.07^^D00015ASDD^^1^3090317~1|~3|4^^^D^3^^^D~5|
 ;;0|ASFHX^^Asthma Family History^^^^^T01024ASFHX~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^O^15~5|S VAL=$$ASFHX^BQIRGASU(DFN),OTHER=$P(VAL,U,3),VAL=$P(VAL,U)
 ;;0|ASFLU^^Last Flu Shot^^^^^T01024ASFLU~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^D^10~5|S VAL=$$LASTFLU^APCLAPI4(DFN,"","","A"),VISIT=$P(VAL,U,4),VAL=$$FMTE^BQIUL1($P(VAL,U))
 ;;0|ASIHSD^^On Inhaled Steroids^^^^^T00003ASIHSD~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^O^20~5|S VAL=$$INHST^BQIRGASU(DFN),OTHER=$P(VAL,U,2),VISIT=$P(VAL,U,3),VAL=$P(VAL,U,1)
 ;;0|ASLADM^^Work/School Days Missed^^^^^T00003ASLADM~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^O^13~5|S VAL=$$MEAS^BQIDCUTL(DFN,"ADM"),OTHER=$P(VAL,U,2),VISIT=$P(VAL,U,4),VAL=$P(VAL,U,3)
 ;;0|ASLBPF^^Best Peak Flow^^^^^T00003ASLBPF~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^D^5~5|S VAL=$$MEAS^BQIDCUTL(DFN,"BPF"),OTHER=$P(VAL,U,2),VISIT=$P(VAL,U,4),VAL=$P(VAL,U,3)
 ;;0|ASLEUV^^Last Asthma ER/UC Visit^^^^^T00030ASLEUV~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^O^16~5|S VAL=$$LERUC^BQIRGASU(DFN),VISIT=$P(VAL,U,2),VAL=$P(VAL,U,1)
 ;;0|ASLFD^^Symptom Free Days^^^^^T00003ASLFD~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^O^12~5|S VAL=$$MEAS^BQIDCUTL(DFN,"ASFD"),OTHER=$P(VAL,U,2),VISIT=$P(VAL,U,4),VAL=$P(VAL,U,3)
 ;;0|ASLFEF^9^Last FEF 25^O^^^^N00003ASLFEF^^1^3090317~1|S VAL=$P($$MEAS^BQIDCUTL(DFN,"FEF"),U,3)~3|4^^^^9~5|
 ;;0|ASLFEV^8^FEV1/FVC^O^^^^T00003ASLFEV^^^~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^D^8~5|S VAL=$$MEAS^BQIDCUTL(DFN,"FVFC"),OTHER=$P(VAL,U,2),VISIT=$P(VAL,U,4),VAL=$P(VAL,U,3)
 ;;0|ASLHSV^^Last Asthma Hospital Visit^^^^^T00030ASLHSV~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^O^17~5|S VAL=$$LHOSV^BQIRGASU(DFN),VISIT=$P(VAL,U,2),VAL=$P(VAL,U,1)
 ;;0|ASLPEF^10^Last PEF/Best PF^O^^^^T00003ASLPEF^^1^3090317~1|S VAL=$$MEAS^BQIRGUTL(DFN,"PEF",HDR)~3|4^^^^10~5|
 ;;0|ASLPF^^Last Peak Flow^^^^^T00003ASLPF~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^D^6~5|S VAL=$$MEAS^BQIDCUTL(DFN,"PF"),OTHER=$P(VAL,U,2),VISIT=$P(VAL,U,4),VAL=$P(VAL,U,3)
 ;;0|ASLV^2^Last Asthma Visit^O^^^^T00030ASLV^^^~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^D^4^^^D~5|S VAL=$$ASVIS^BQIRGASU(DFN),VISIT=$P(VAL,U,2),VAL=$$FMTE^BQIUL1($P(VAL,U,1))
 ;;0|ASMGPLDT^7^Asthma Management Plan Date^O^90181.01^.093^^D00015ASMGPLDT^^1^3090317~1|~3|4^^^^7^^^D~5|
 ;;0|ASRLVR^^On Reliever Meds^^^^^T00003ASRLVR~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^O^19~5|S VAL=$$RLVR^BQIRGASU(DFN),OTHER=$P(VAL,U,2),VISIT=$P(VAL,U,3),VAL=$P(VAL,U,1)
 ;;0|ASSEV^4^Asthma Severity^O^^^^T00001ASSEV^^^~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^D^2~5|S VAL=$$LASTSEV^APCHSAST(DFN,1)
 ;;0|ASSEVDT^5^Severity Date^O^^^^T00030ASSEVDT^^1^3090317~1|S VAL=$$FMTE^BQIUL1($$LASTSEV^APCHSAST(DFN,2))~3|4^^^^5^^^D~5|
 ;;0|ASSTAT^^Asthma Tag Status^O^90181.01^.02^^T00001ASSTAT^^^^^^^^1~1|S VAL=$$CTAG^BQITDUTL(DFN,"Asthma")~3|4^^^D^3~5|S VAL=$$CTAG^BQITDUTL(DFN,"Asthma")
 ;;0|ASTBHF^^Last Tobacco Health Factor^^^^^T00030ASTBHF~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^O^14~5|S VAL=$$TOB^BQIRGASU(DFN),OTHER=$P(VAL,U,2),VAL=$P(VAL,U,1),VISIT=$P(VAL,U,3)
 ;;0|ASTRIG^^Asthma Triggers^^^^^T01024ASTRIG~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|4^^^O^11~5|S VAL=$$ASTRIG^BQIRGASU(DFN),OTHER=$P(VAL,U,2),VAL=$P(VAL,U,1)
 Q
