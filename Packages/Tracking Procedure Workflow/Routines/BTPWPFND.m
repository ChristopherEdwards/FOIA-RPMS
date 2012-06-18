BTPWPFND ;VNGT/HS/ALA-Find Events for Tracking ; 22 Apr 2008  7:15 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;**1**;Feb 07, 2011;Build 37
 ;
 ;
EN(JOB) ;EP - Entry point
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPFND D UNWIND^%ZTER"
 NEW PRCN,TGLOB,USER,TMFRAME,TXN,ERROR
 ;
 ; Clean up merged visits
 D ^BTPWPFNC
 ;
 S PRCN=0,TGLOB=$NA(^XTMP("BTPWPRC"))
 S JOB=$G(JOB,"")
 S USER=$S(JOB="Nightly":JOB_" ",1:"Initial ")_"job"
 NEW BTPWUP
 S BTPWUP(90628,"1,",.06)=$$NOW^XLFDT()
 D FILE^DIE("","BTPWUP","ERROR")
 K @TGLOB
 S @TGLOB@(0)=$$FMADD^XLFDT(DT,1)_U_DT_U_"CMET Find Events"
 F  S PRCN=$O(^BTPW(90621,PRCN)) Q:'PRCN  D
 . I $P(^BTPW(90621,PRCN,0),U,3)'="" Q
 . S TXN=0
 . F  S TXN=$O(^BTPW(90621,PRCN,1,TXN)) Q:'TXN  D
 .. NEW DA,IENS,TAX,FRN,FREF,ORD,UID,TREF,GREF,MOD,FIELD,RFILE,MN,MCD,MDF,OPER,AN,MD
 .. S DA(1)=PRCN,DA=TXN,IENS=$$IENS^DILF(.DA),ORD=1
 .. S TAX=$$GET1^DIQ(90621.01,IENS,.01,"E")
 .. S FRN=$$GET1^DIQ(90621.01,IENS,.03,"I")
 .. I FRN'="" D
 ... NEW FILE,FIELD
 ... S FREF=$$GET1^DIQ(90621.1,FRN_",",.02,"I")
 ... S ORD=$$GET1^DIQ(90621.1,FRN_",",.05,"E")
 ... S FIELD=$$GET1^DIQ(90621.1,FRN_",",.03,"E")
 ... S RFILE=$$GET1^DID(FREF,FIELD,"","SPECIFIER"),RFILE=$$STRIP^XLFSTR(RFILE,"ABCDEFGHIJKLMNOPQRSTUVWXYZ*'")
 .. ; Check for modifiers
 .. I $O(^BTPW(90621,PRCN,1,TXN,1,0))'="" S MD=0 D
 ... F  S MD=$O(^BTPW(90621,PRCN,1,TXN,1,MD)) Q:'MD  D
 .... S MCD=$P(^BTPW(90621,PRCN,1,TXN,1,MD,0),U,1),OPER=$P(^BTPW(90621,PRCN,1,TXN,1,MD,0),U,2)
 .... S MDF=$O(^AUTTCMOD("B",MCD,""))
 .... I MDF'="" S MOD(MDF)=OPER
 .. ;
 .. S UID=$J,TREF=$NA(^TMP("BQITAX",UID)),GREF=$$ROOT^DILFD(FREF,"",1)
 .. K @TREF
 .. D BLD^BQITUTL(TAX,TREF)
 .. ;
 .. S TIEN=0 F  S TIEN=$O(@TREF@(TIEN)) Q:'TIEN  D
 ... S IEN=""
 ... F  S IEN=$O(@GREF@("B",TIEN,IEN),-1) Q:IEN=""  D
 .... ; if a bad record (no zero node), quit
 .... I $G(@GREF@(IEN,0))="" Q
 .... ; get patient record
 .... S DFN=$$GET1^DIQ(FREF,IEN,.02,"I") Q:DFN=""
 .... I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 .... ;I '$$HRN^BQIUL1(DFN),'$$VTHR^BQIUL1(DFN) Q
 .... I '$$HRN^BQIUL1(DFN) Q
 .... ; get the visit information
 .... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I")\1 Q:VISIT=""
 .... ; if the visit is deleted, quit
 .... I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .... ; if the visit has no dependents, quit
 .... I $$GET1^DIQ(9000010,VISIT,.09,"I")=0 Q
 .... S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 .... I $D(MOD)>0 S QFL=0,MN=0 D  Q:QFL
 ..... NEW BTJ
 ..... F  S MN=$O(MOD(MN)) Q:MN=""  D  Q:QFL
 ...... S OPER=MOD(MN)
 ...... F BTJ=.08,.09 I $$GET1^DIQ(FREF,IEN,BTJ,"I")=MN,OPER="E" S QFL=1
 ...... F BTJ=.08,.09 I $$GET1^DIQ(FREF,IEN,BTJ,"I")=MN,OPER="I" S QFL=0
 .... S BTPWIEN=$O(^BWPCD("AD",VISIT,""))
 .... I BTPWIEN'="",$P($G(^BWPCD(BTPWIEN,"PCC")),U,2)'=IEN S BTPWIEN=""
 .... S @TGLOB@(DFN,PRCN,VSDTM,ORD,VISIT,IEN)=BTPWIEN_U_FREF_U_$P(^DIC(FREF,0),U,1)
 ;
 S DFN=""
 F  S DFN=$O(@TGLOB@(DFN)) Q:DFN=""  D
 . S PIEN=""
 . F  S PIEN=$O(^BWPCD("C",DFN,PIEN)) Q:PIEN=""  D
 .. S PROC=$P(^BWPCD(PIEN,0),U,4)
 .. S PRCN=$O(^BTPW(90621,"AP",PROC,"")) I PRCN="" S PRCN="~"
 .. I PRCN'="~",$P(^BTPW(90621,PRCN,0),U,3)'="" Q
 .. S PRCDTM=$P(^BWPCD(PIEN,0),U,3)
 .. I PRCDTM="" S PRCDTM=$P(^BWPCD(PIEN,0),U,12)
 .. S PRCDTM=PRCDTM\1,ORD=1
 .. S FREF=$P(^BWPN(PROC,0),U,12),FILE="" I FREF'="" S FILE=$P(^DIC(FREF,0),U,1)
 .. I FREF="" D
 ... I $P(^BWPCD(PIEN,0),U,15)'="" S FILE="V RADIOLOGY" Q
 ... I PROC=40 S FILE="V LAB"
 .. I FREF'="" S FRN=$O(^BTPW(90621.1,"B",FILE,""))
 .. I FRN'="" S ORD=$$GET1^DIQ(90621.1,FRN_",",.05,"E")
 .. S VISIT=$P($G(^BWPCD(PIEN,"PCC")),U,1),IEN=$P($G(^BWPCD(PIEN,"PCC")),U,2)
 .. S:VISIT="" VISIT="~" S:IEN="" IEN="~"
 .. S @TGLOB@(DFN,PRCN,PRCDTM,ORD,VISIT,IEN,PROC)=PIEN_U_FREF_U_FILE
 ;
 ; Check against Radiology file
 D RAD
 ;
STOR ; Store the records found
 NEW DFN,BCT,BQARRAY
 S DFN=0
 F  S DFN=$O(@TGLOB@(DFN)) Q:DFN=""  D
 . K BQARRAY
 . D CHK(DFN,.BQARRAY)
 . S BCT=""
 . F  S BCT=$O(BQARRAY(BCT)) Q:BCT=""  D
 .. NEW PRCN,TMFRAME,VSDTM,VISIT,RIEN,FREF,RARPT,WHIEN,FRIL,FREF,ACCN,ENDT
 .. S PRCN=$P(BQARRAY(BCT),U,1)
 .. S TMFRAME=$P($G(^BTPW(90621,PRCN,5)),U,4),ENDT=""
 .. I TMFRAME'="" S TMFRAME="T-"_TMFRAME,ENDT=$$DATE^BQIUL1(TMFRAME)
 .. S VSDTM=$P(BQARRAY(BCT),U,6)
 .. S VISIT=$P(BQARRAY(BCT),U,2)
 .. S RIEN=$P(BQARRAY(BCT),U,7)
 .. S FREF=$P(BQARRAY(BCT),U,4)
 .. S RARPT=$P(BQARRAY(BCT),U,8)
 .. S WHIEN=$P(BQARRAY(BCT),U,3)
 .. S FRIL="~"
 .. I FREF'="" S FRIL=$O(^BTPW(90621.1,"C",FREF,""))
 .. I FRIL="" S FREF=$P(BQARRAY(BCT),U,5) I FREF'="" S FRIL=$O(^BTPW(90621.1,"B",FREF,""))
 .. ; Check for existence of the record already in the queue file
 .. I DFN'="",PRCN'="",VISIT'="",RIEN'="",FRIL'="",$D(^BTPWQ("C",DFN,PRCN,VISIT,RIEN,FRIL)) Q
 .. ;
 .. I TMFRAME'="",VSDTM<ENDT Q
 .. ;
 .. I $P($G(^AUPNVSIT(VISIT,0)),U,37)'="" S VISIT=$P($G(^AUPNVSIT(VISIT,0)),U,37)
 .. I DFN'="",PRCN'="",VISIT'="",RIEN'="",FRIL'="",$D(^BTPWQ("C",DFN,PRCN,VISIT,RIEN,FRIL)) Q
 .. ;
 .. I FREF=9000010.09 D
 ... I RIEN'="~",RIEN'="",WHIEN="" S ACCN=$P($G(^AUPNVLAB(RIEN,0)),U,6)
 ... I $G(ACCN)'="",$E(ACCN,1,2)="WH" S WHIEN=$O(^BPWCD("B",$E(ACCN,3,$L(ACCN)),"")) I WHIEN'="" S ACCN=""
 .. ;
 .. NEW DIC,DLAYGO,X,Y,IEN,BTPUPD,PXSEC
 .. S DIC="^BTPWQ(",DIC(0)="LMNZ",DLAYGO=90629,DIC("P")=DLAYGO
 .. S X=PRCN
 .. K DO,DD D FILE^DICN
 .. S IEN=+Y
 .. S BTPUPD(90629,IEN_",",.02)=DFN,BTPUPD(90629,IEN_",",.03)=VSDTM
 .. S BTPUPD(90629,IEN_",",.04)=VISIT,BTPUPD(90629,IEN_",",.05)=RIEN
 .. S BTPUPD(90629,IEN_",",.06)=FRIL,BTPUPD(90629,IEN_",",.07)=$$NOW^XLFDT()
 .. S BTPUPD(90629,IEN_",",.09)=WHIEN,BTPUPD(90629,IEN_",",.1)=RARPT
 .. S BTPUPD(90629,IEN_",",.15)=$G(ACCN)
 .. S BTPUPD(90629,IEN_",",.08)="P",BTPUPD(90629,IEN_",",.12)=USER
 .. S BTPUPD(90629,IEN_",",.13)=$$CAT^BTPWPDSP(PRCN,1),BTPUPD(90629,IEN_",",.11)=$$NOW^XLFDT()
 .. S BTPUPD(90629,IEN_",",.16)=$$GET1^DIQ(9000010,VISIT_",",.06,"I")
 .. ;
 .. K ACCN,WHIEN
 .. ; Check for exceptions
 .. S PSEX=$P($G(^BTPW(90621,PRCN,5)),U,1)
 .. I PSEX'="" D
 ... I $P(^DPT(DFN,0),U,2)'=PSEX S BTPUPD(90629,IEN_",",.08)="E"
 .. D FILE^DIE("","BTPUPD","ERROR")
 .. ;I $D(ERROR) D ERR Q
 .. ;
 .. ; Check to supercede previously existing record
 .. NEW PVISIT,PRIEN,PFRIL,PIEN,BTPUPD
 .. S PVISIT=$O(^BTPWQ("C",DFN,PRCN,VISIT),-1)
 .. I PVISIT'="" D
 ... S PRIEN=$O(^BTPWQ("C",DFN,PRCN,PVISIT,""))
 ... S PFRIL=$O(^BTPWQ("C",DFN,PRCN,PVISIT,PRIEN,""))
 ... S PIEN=$O(^BTPWQ("C",DFN,PRCN,PVISIT,PRIEN,PFRIL,""))
 ... I $$GET1^DIQ(90629,PIEN_",",.08,"I")="P" D
 .... S BTPUPD(90629,PIEN_",",.08)="S"
 .... D FILE^DIE("","BTPUPD","ERROR")
 .... ;I $D(ERROR) D ERR
 .. ;
 .. ; Check for possible match with future followup
 .. NEW TIEN
 .. S TIEN=""
 .. F  S TIEN=$O(^BTPWP("AE",DFN,"F",TIEN)) Q:TIEN=""  D
 ... I $P(^BTPWP(TIEN,0),U,1)'=PRCN Q
 ... S BTPUPD(90629,IEN_",",1.01)=TIEN
 ... D FILE^DIE("","BTPUPD","ERROR")
 ;
 NEW BTPWUP
 S BTPWUP(90628,"1,",.07)=$$NOW^XLFDT()
 D FILE^DIE("","BTPWUP","ERROR")
 K BCT,BQARRAY,BTPWIEN,CT,DA,DFN,DIC,DLAYGO,FILE,FREF,FRIL,FRN,IEN
 K ORD,PIEN,PRCDTM,PROC,PSEX,QFL,RADATA,RAIEN,RARPN,RARPT,RDIEN,RDTM
 K RDTM,REF,RIEN,RPRCN,STAT,TAX,TIEN,VFL,VISIT,VSDTM,WHIEN,WIEN,X,Y
 K @TREF,TREF
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $G(II)'="" S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CHK(DFN,ARRAY) ;EP - Take raw data for a patient and refine to one most recent procedure
 S CT=0,TGLOB=$NA(^XTMP("BTPWPRC")) K ARRAY
 S PRCN=""
 F  S PRCN=$O(@TGLOB@(DFN,PRCN)) Q:PRCN=""  D
 . I PRCN="~" Q
 . K BWH,BREC
 . S VSDTM=$O(@TGLOB@(DFN,PRCN,""),-1) Q:VSDTM=""  D
 .. S ORD=""
 .. S ORD=$O(@TGLOB@(DFN,PRCN,VSDTM,ORD)) Q:ORD=""  D  Q:'QFL
 ... S VISIT="",QFL=1
 ... F  S VISIT=$O(@TGLOB@(DFN,PRCN,VSDTM,ORD,VISIT)) Q:VISIT=""  D  Q:'QFL
 .... S RIEN="",STAT="",RARPT=""
 .... F  S RIEN=$O(@TGLOB@(DFN,PRCN,VSDTM,ORD,VISIT,RIEN)) Q:RIEN=""  D  Q:'QFL
 ..... S WHIEN="",BREC(VSDTM)=RIEN
 ..... I $G(@TGLOB@(DFN,PRCN,VSDTM,ORD,VISIT,RIEN))="" D
 ...... S WIEN=$O(@TGLOB@(DFN,PRCN,VSDTM,ORD,VISIT,RIEN,""))
 ...... S WHIEN=$P(@TGLOB@(DFN,PRCN,VSDTM,ORD,VISIT,RIEN,WIEN),U,1)
 ...... S REF=$P(@TGLOB@(DFN,PRCN,VSDTM,ORD,VISIT,RIEN,WIEN),U,2,3)
 ...... S RARPT=$P(@TGLOB@(DFN,PRCN,VSDTM,ORD,VISIT,RIEN,WIEN),U,4)
 ..... I $G(@TGLOB@(DFN,PRCN,VSDTM,ORD,VISIT,RIEN))'="" D
 ...... S WHIEN=$P(@TGLOB@(DFN,PRCN,VSDTM,ORD,VISIT,RIEN),U,1)
 ...... S REF=$P(@TGLOB@(DFN,PRCN,VSDTM,ORD,VISIT,RIEN),U,2,3)
 ...... S RARPT=$P(@TGLOB@(DFN,PRCN,VSDTM,ORD,VISIT,RIEN),U,4)
 .... ; 
 .... I WHIEN'="" D
 ..... I VISIT'="~" Q
 ..... S BWH(VSDTM)=WHIEN
 ..... S STAT=$P(^BWPCD(WHIEN,0),U,14)
 ..... S RARPT=$P(^BWPCD(WHIEN,0),U,15)
 ..... I RARPT="" D  Q
 ...... I VISIT="~" S VISIT=$P($G(^BWPCD(WHIEN,"PCC")),U,1),RIEN=$P($G(^BWPCD(WHIEN,"PCC")),U,2)
 ..... S RARPN=$O(^RARPT("B",RARPT,"")) I RARPN="" Q
 ..... I $P($G(^RARPT(RARPN,0)),U,2)'=$P($G(^BWPCD(WHIEN,0)),U,2) Q
 ..... S RDTM=0
 ..... F  S RDTM=$O(^RADPT(DFN,"DT",RDTM)) Q:RDTM="AP"!(RDTM="")  D
 ...... S RPRCN=0
 ...... F  S RPRCN=$O(^RADPT(DFN,"DT",RDTM,"P",RPRCN)) Q:'RPRCN  D
 ....... I $P($G(^RADPT(DFN,"DT",RDTM,"P",RPRCN,0)),U,17)'=RARPN Q
 ....... NEW DA,IENS
 ....... S DA(2)=DFN,DA(1)=RDTM,DA=RPRCN,IENS=$$IENS^DILF(.DA)
 ....... I $$GET1^DIQ(70.03,IENS,3,"E")="CANCELLED" Q
 ....... I $$GET1^DIQ(70.03,IENS,3,"E")="" Q
 ....... S VISIT=$P($G(^RADPT(DFN,"DT",RDTM,"P",RPRCN,"PCC")),U,3)
 ....... S RIEN=$P($G(^RADPT(DFN,"DT",RDTM,"P",RPRCN,"PCC")),U,2) I RIEN="" Q
 ....... I $G(^AUPNVRAD(RIEN,0))="" Q
 ....... I $P(^AUPNVRAD(RIEN,0),U,3)'=VISIT S VISIT=$P(^AUPNVRAD(RIEN,0),U,3)
 .... I VISIT="" S QFL=1,VISIT="~" Q
 .... I WHIEN="",$D(BWH(VSDTM)) S WHIEN=BWH(VSDTM) K BWH
 .... I RIEN="",$D(BREC(VSDTM)) S RIEN=BREC(VSDTM) K BREC
 .... S CT=CT+1,ARRAY(CT)=PRCN_U_VISIT_U_WHIEN_U_REF_U_VSDTM_U_RIEN_U_RARPT,QFL=0
 Q
 ;
RAD ; Radiology procedures
 ; VFL is the reference for CPT files. Searching all CPT taxonomies against the RAD/NUC MED PROCEDURES for
 ; matching CPT codes. 
 ;
 S VFL=5,PRCN=""
 F  S PRCN=$O(^BTPW(90621,"AC",VFL,PRCN)) Q:PRCN=""  D
 . S PIEN=""
 . F  S PIEN=$O(^BTPW(90621,"AC",VFL,PRCN,PIEN)) Q:PIEN=""  D
 .. S TAX=$P(^BTPW(90621,PRCN,1,PIEN,0),"^",1)
 .. S UID=$J,TREF=$NA(^TMP("BQITAX",UID))
 .. K @TREF
 .. D BLD^BQITUTL(TAX,TREF)
 .. S TIEN=""
 .. F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 ... ; if the CPT code is not found in the RAD/NUC MED PROCEDURES file, quit
 ... I '$D(^RAMIS(71,"D",TIEN)) Q
 ... S RAIEN=""
 ... F  S RAIEN=$O(^RAMIS(71,"D",TIEN,RAIEN)) Q:RAIEN=""  D
 .... ; For every radiology patient (since there is no specific cross-reference by procedure)
 .... S DFN=0
 .... F  S DFN=$O(^RADPT(DFN)) Q:'DFN  D
 ..... S RDTM=""
 ..... F  S RDTM=$O(^RADPT(DFN,"DT","AP",RAIEN,RDTM)) Q:RDTM=""  D
 ...... S RDIEN=""
 ...... F  S RDIEN=$O(^RADPT(DFN,"DT","AP",RAIEN,RDTM,RDIEN))  Q:RDIEN=""  D
 ....... S FRN=$O(^BTPW(90621.1,"B","V RADIOLOGY",""))
 ....... I FRN'="" S ORD=$$GET1^DIQ(90621.1,FRN_",",.05,"E")
 ....... S RADATA=$G(^RADPT(DFN,"DT",RDTM,"P",RDIEN,"PCC"))
 ....... NEW DA,IENS
 ....... S DA(2)=DFN,DA(1)=RDTM,DA=RDIEN,IENS=$$IENS^DILF(.DA)
 ....... I $$GET1^DIQ(70.03,IENS,3,"E")="CANCELLED" Q
 ....... I $$GET1^DIQ(70.03,IENS,3,"E")="" Q
 ....... S RARPN=$P($G(^RADPT(DFN,"DT",RDTM,"P",RDIEN,0)),U,17)
 ....... S RARPT="" I RARPN'="" S RARPT=$P(^RARPT(RARPN,0),U,1)
 ....... S PRCDTM=$P(RADATA,U,1)\1
 ....... S VISIT=$P(RADATA,U,3)
 ....... S IEN=$P(RADATA,U,2) I IEN="" Q
 ....... I $G(^AUPNVRAD(IEN,0))="" Q
 ....... I $P(^AUPNVRAD(IEN,0),U,3)'=VISIT S VISIT=$P(^AUPNVRAD(IEN,0),U,3)
 ....... S:VISIT="" VISIT="~" S:IEN="" IEN="~"
 ....... S @TGLOB@(DFN,PRCN,PRCDTM,ORD,VISIT,IEN)=U_"9000010.22"_U_"V RADIOLOGY"_U_RARPT
 Q
