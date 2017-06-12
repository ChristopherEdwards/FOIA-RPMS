BEDDUTID ;VNGT/HS/BEE-BEDD Utility Routine 2 ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;**1**;Jun 04, 2014;Build 22
 ;
 ;Adapted from BEDDUTL1/CNDH/RPF
 ;
 Q
 ;
KEYCK(DUZ) ;EP - Determine if user has BEDDZMGR Key
 ;
 ; Input:
 ; DUZ - User IEN
 ;
 I $G(DUZ)="" Q 0
 ;
 NEW KIEN
 S KIEN=$O(^DIC(19.1,"B","BEDDZMGR","")) Q:KIEN="" 0
 I DUZ>0,$D(^VA(200,"AB",KIEN,DUZ,KIEN)) Q 1
 Q 0
 ;
ADDDX(VIEN,DXI,DUZ) ;EP - Add DX TO V POV FILE
 ;
 ; Add new DX to V POV (#9000010.07)
 ;
 ; Input:
 ; VIEN - Visit Entry Pointer
 ; DXI - Diagnosis Code - Entered from Discharge Page
 ; DUZ - User IEN
 ;
 S VIEN=$G(VIEN,""),DXI=$G(DXI,"") S:$G(U)="" U="^"
 ;
 NEW DFN,NOW,XIEN,PDX,I9,STS
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 ;Define DUZ variable
 I $G(DUZ)="" S STS="Missing DUZ" Q
 D DUZ^XUP(DUZ)
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTID D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S NOW=$$FNOW^BEDDUTIL
 S DFN=$$GETF^BEDDUTIL(9000010,VIEN,.05,"I")
 ;
 ;Add entry to PROVIDER NARRATIVE - If not there
 S XIEN=$O(^AUTNPOV("B",DXI)) I XIEN="" D
 . NEW DIC,X,Y,DINUM,DLAYGO
 . S DIC="^AUTNPOV(",DIC(0)="XML",X=DXI,DLAYGO="9999999.27"
 . K DO,DD D FILE^DICN
 . I +Y<0 Q
 . S XIEN=+Y
 I XIEN="" Q
 ;
 ;Determine if Primary/Secondary Diagnosis
 S PDX="P" I $D(^AUPNVPOV("AD",VIEN)) S PDX="S"
 ;
 ;Hardset to UNCODED DIAGNOSIS
 S I9=$O(^ICD9("AB",.9999,"")) I I9'="" D
 . NEW DIC,X,Y,DINUM,DLAYGO
 . S DIC="^AUPNVPOV(",DIC(0)="XML",X=I9,DLAYGO=9000010.07
 . S DIC("DR")=".02////"_DFN_";.03////"_VIEN_";.04////"_XIEN_";.12////"_PDX_";1201////"_NOW
 . K DO,DD D FILE^DICN
 Q
 ;
EDCON(AMERVSIT,EDCONS) ;EP - Get list of ER Consults
 ;
 ; Input:
 ; AMERVSIT - Pointer to ER VISIT file
 ;
 ; Output:
 ; EDCONS Array - List of ER Consults
 ;
 I $G(AMERVSIT)="" S EDCONS=0 Q
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTID D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW EIEN
 K EDCONS
 S EDCONS=0
 ;
 S EIEN=0 F  S EIEN=$O(^AMERVSIT(AMERVSIT,19,EIEN)) Q:'EIEN  D
 . NEW DA,IENS,COTY,DATE,CONS
 . S DA(1)=AMERVSIT,DA=EIEN,IENS=$$IENS^DILF(.DA)
 . S COTY=$$GET1^DIQ(9009080.019,IENS,.01,"E") Q:COTY=""
 . S DATE=$$FMTE^BEDDUTIL($$GET1^DIQ(9009080.019,IENS,.02,"I"))
 . S CONS=$$GET1^DIQ(9009080.019,IENS,.03,"E")
 . S EDCONS=EDCONS+1,EDCONS(EDCONS)=COTY_"^"_DATE_"^"_CONS
 ;
 Q
 ;
PROC(AMERVSIT,ERPROC) ;EP - Get list of ER Procedures Performed
 ;
 ; Input:
 ; AMERVSIT - Pointer to ER VISIT file
 ;
 ; Output:
 ; ERPROC Array - List of ER Procedures Performed
 ;
 I $G(AMERVSIT)="" S ERPROC=0 Q
 ;
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTID D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW EIEN
 K ERPROC
 S ERPROC=0
 ;
 S EIEN=0 F  S EIEN=$O(^AMERVSIT(AMERVSIT,4,EIEN)) Q:'EIEN  D
 . NEW DA,IENS,PROC
 . S DA(1)=AMERVSIT,DA=EIEN,IENS=$$IENS^DILF(.DA)
 . S PROC=$$GET1^DIQ(9009080.04,IENS,.01,"E") Q:PROC=""
 . S ERPROC=ERPROC+1,ERPROC(ERPROC)=PROC
 ;
 Q
 ;
DX(AMERVSIT,ERDX) ;EP - Get list of ER DX'S
 ;
 ; Input:
 ; AMERVSIT - Pointer to ER VISIT file
 ;
 ; Output:
 ; ERDX Array - List of DX' LOGGED BY ER
 ;
 I $G(AMERVSIT)="" S ERDX=0 Q
 ;
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTID D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW EIEN
 K ERDX
 S ERDX=0
 ;
 S EIEN=0 F  S EIEN=$O(^AMERVSIT(AMERVSIT,5,EIEN)) Q:'EIEN  D
 . NEW DA,IENS,DX,DXN
 . S DA(1)=AMERVSIT,DA=EIEN,IENS=$$IENS^DILF(.DA)
 . S DX=$$GET1^DIQ(9009080.05,IENS,.01,"E") Q:DX=""
 . S DXN=$$GET1^DIQ(9009080.05,IENS,1,"E")
 . S ERDX=ERDX+1,ERDX(ERDX)=DX_"^"_DXN
 ;
 Q
 ;
MDTRN(DFN) ;EP - Update Patient's MODE OF TRANSPORT
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTID D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 NEW MD,MDO,AMUPD,ERROR
 ;
 S MD=$$GET1^DIQ(9009081,DFN_",",6,"I") Q:MD]"" 1
 S MDO=$$GET1^DIQ(9009081,DFN_",",2.3,"I") Q:MDO="" 1
 S AMUPD(9009081,DFN_",",6)=MDO
 I $D(AMUPD) D FILE^DIE("","AMUPD","ERROR")
 Q 1
 ;
EMV(VIEN) ;EP - Return V EMERGENCY VISIT RECORD entry
 ;
 Q $O(^AUPNVER("AD",VIEN,""))
 ;
DSUM() ;EP - Return if Discharge Summary Global is defined
 ;
 I $D(^TMP("BEDDDSC",$J,"XBDT")) Q 1
 Q 0
 ;
HTIME(TM) ;EP - Given seconds portion of $H value, return time
 ;
 NEW T
 ;
 ;To use FileMan Utility add the date, and then strip it off afterwards
 S T=+$H_","_TM
 S T=$$HTE^XLFDT(T)
 Q $P(T,"@",2)
 ;
PRIMDX(VIEN,OBJID) ;EP - Retrieve/Save the Primary EHR DX
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 NEW DX
 ;
 S DX=""
 ;
 I $D(^AUPNVPOV("AD",VIEN)) D
 . NEW RIEN
 . S ICD="",ICDN="",RPFI="",RPFIN=""
 . S RIEN="" F  S RIEN=$O(^AUPNVPOV("AD",VIEN,RIEN)) Q:RIEN=""  D
 .. NEW ICD,ICDN,RPFI,RPFIN
 .. S (ICD,ICDN,RPFI,RPFIN)=""
 .. I $$GET1^DIQ(9000010.07,RIEN_",",.12,"I")="P" D
 ... S ICD=$$GET1^DIQ(9000010.07,RIEN_",",".04","I")
 ... S RPFI=$$GET1^DIQ(9000010.07,RIEN_",",".01","I")
 ... S RPFIN=$$GET1^DIQ(80,RPFI_",",.01,"I")
 .. I ICD>0 S ICDN=$$GET1^DIQ(9999999.27,ICD_",",.01,"I")
 . I ICD>0 D
 ..S DX=ICD_"^"_ICDN_"^"_RPFI_"^"_RPFIN_"^"_OBJID
 ..D SAVEDX^BEDDUTW(DX)
 Q DX
 ;
AGE(DFN) ;EP - Return Patients Age
 ;
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 Q $$AGE^AUPNPAT(DFN,,1)
 ;
 ;
DSAVE(DFN,AMERVSIT,VIEN,OBJID,DUZ,SITE,BEDDARY) ;EP - Dashboard Discharge Screen Save
 ;
 ; Input:
 ; DFN - Patient IEN
 ; BEDDARY - Array of entries to save
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 NEW AUPNVSIT,STS
 ;
 ;Define DUZ variable
 I $G(DUZ)="" S STS="Missing DUZ" Q 0
 D DUZ^XUP(DUZ)
 ;
 ;File ER ADMISSION entries
 I $G(DFN)]"" D
 . S:$D(BEDDARY("Trg")) AMUPD(9009081,DFN_",",20)=BEDDARY("Trg")
 . S:$D(BEDDARY("TrgNow")) AMUPD(9009081,DFN_",",21)=$$DATE^BEDDUTIL(BEDDARY("TrgNow"))
 . S:$D(BEDDARY("TrgN")) AMUPD(9009081,DFN_",",19)=BEDDARY("TrgN")
 . S:$D(BEDDARY("AdPvTm")) AMUPD(9009081,DFN_",",22)=$$DATE^BEDDUTIL(BEDDARY("AdPvTm"))
 . S:$D(BEDDARY("AdmPrv")) AMUPD(9009081,DFN_",",18)=BEDDARY("AdmPrv")
 ;
 ;File VISIT entries
 I $G(VIEN)]"" D
 . S:$G(BEDDARY("txcln"))]"" AMUPD(9000010,VIEN_",",.08)=$O(^DIC(40.7,"C",BEDDARY("txcln"),""))
 ;
 I $D(AMUPD) D FILE^DIE("","AMUPD","ERROR")
 ;
 ;Complete Discharge
 D DC^BEDDUTIS(DFN,OBJID,VIEN,DUZ,SITE,.BEDDARY)
 ;
 ;Flag visit as edited
 S AUPNVSIT=VIEN D MOD^AUPNVSIT
 ;
 I $D(ERROR) Q 0
 Q 1
 ;
CLIN(CLIN) ;EP - Return List of Applicable Clinics
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; CLIN Array - List of Clinics
 ;
 NEW CIEN,CTIEN,CNT
 K CLIN
 S CTIEN=$O(^AMER(2,"B","CLINIC TYPE","")) Q:CTIEN=""
 S CNT=0,CIEN="" F  S CIEN=$O(^AMER(3,"AC",CTIEN,CIEN)) Q:+CIEN=0  D
 . S CNT=CNT+1
 . S CLIN(CNT)=$$GET1^DIQ(9009083,CIEN_",",5,"I")_"^"_$$GET1^DIQ(9009083,CIEN_",",".01","I")
 Q
 ;
DISP(DISP) ;EP - Return List of Dispositions
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; DISP Array - List of Dispositions
 ;
 NEW CNT,DSIEN,DIEN,DSP
 K DISP
 S DSIEN=$O(^AMER(2,"B","DISPOSITION","")) Q:DSIEN=""
 S DIEN="" F  S DIEN=$O(^AMER(3,"AC",DSIEN,DIEN)) Q:+DIEN=0  D
 . NEW D
 . S D=$$GET1^DIQ(9009083,DIEN_",",".01","I") Q:D=""
 . S DSP(D)=DIEN_"^"_D
 ;
 ;Re-sort
 S CNT=0,DSP="" F  S DSP=$O(DSP(DSP)) Q:DSP=""  D
 . S CNT=CNT+1
 . S DISP(CNT)=DSP(DSP)
 ;
 Q
 ;
TRNF(TRNF) ;EP - Return List of Transfer Facilities
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; TRNF Array - List of Transfer Facilities
 ;
 NEW CNT,FCIEN,FIEN
 K TRNF
 S CNT=0,FCIEN="" F  S FCIEN=$O(^AMER(2.1,"B",FCIEN)) Q:FCIEN=""  D
 . S FIEN="" F  S FIEN=$O(^AMER(2.1,"B",FCIEN,FIEN)) Q:FIEN=""  D
 .. S CNT=CNT+1
 .. S TRNF(CNT)=FIEN_"^"_$$GET1^DIQ(9009082.1,FIEN_",",".01","I")
 ;
 Q
 ;
INST(INST) ;EP - Return list of Followup Instructions
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; INST Array - List of Followup Instructions
 ;
 NEW CNT,INIEN,IIEN,INS
 K INST
 S INIEN=$O(^AMER(2,"B","FOLLOW UP INSTRUCTIONS","")) Q:INIEN=""
 S IIEN="" F  S IIEN=$O(^AMER(3,"AC",INIEN,IIEN)) Q:IIEN=""  D
 . S INS=$$GET1^DIQ(9009083,IIEN_",",".01","I") Q:INS=""
 . S INS(INS)=IIEN_U_INS
 ;
 S CNT=0,INS="" F  S INS=$O(INS(INS)) Q:INS=""  D
 . S CNT=CNT+1
 . S INST(CNT)=INS(INS)
 ;
 Q
 ;
PROV(PROV) ;EP - Return List of Providers
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; PROV Array - List of Providers
 ;
 NEW CNT,PNAME,PIEN
 K PROV
 S CNT=0,PNAME="" F  S PNAME=$O(^VA(200,"AK.PROVIDER",PNAME)) Q:PNAME=""  D
 . S PIEN=0 F  S PIEN=$O(^VA(200,"AK.PROVIDER",PNAME,PIEN)) Q:+PIEN=0  D
 .. I $$GET1^DIQ(200,PIEN_",","9.2","I")]"" Q
 .. S CNT=CNT+1
 .. S PROV(CNT)=PIEN_"^"_PNAME
 ;
 Q
 ;
CCLN(CLIN) ;EP - Return Clinic Mnemonic
 Q $$GET1^DIQ(40.7,CLIN_",",1,"I")
 ;
SCLN(CLN) ;EP - Convert Clinic
 ;
 I CLN="" Q ""
 ;
 NEW CLIN,XCLIN
 S CLIN=$O(^DIC(40.7,"C",CLN,"")) Q:CLIN="" ""
 S XCLIN=$$GET1^DIQ(40.7,CLIN_",",.01,"E") Q:XCLIN="" ""
 S CLIN=$O(^AMER(3,"B",XCLIN,"")) Q:CLIN="" ""
 Q CLIN
 ;
 ;
XDATE(X)  ;EP - Convert External Date to FileMan
 ;
 NEW %DT
 ;
 S X=$TR(X," ","@")
 ;
 ;Strip off seconds
 S X=$P(X,":",1,2)
 ;
 S:X="N" X="NOW"
 S %DT="T" D ^%DT
 S:Y=-1 Y=""
 ;
 Q $$FMTE^BEDDUTIL(Y)
 ;
DXLKP(VALUE,OBJID,DUZ,FILTER) ;EP - Lookup to File 80 (DX)
 ;
 NEW VIEN,EXEC,VDT,SEX,STS
 ;
 ;Verify that the object id was passed in
 I $G(OBJID)="" Q
 ;
 ;Make sure filter is populated
 S:$G(FILTER)="" FILTER=0
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 ;Define DUZ variable
 I $G(DUZ)="" S STS="Missing DUZ" Q
 D DUZ^XUP(DUZ)
 ;
 ;Get the visit ien
 S VIEN=""
 S EXEC="S BEDDVST=""""" X EXEC
 S EXEC="S BEDDVST=##CLASS(BEDD.EDVISIT).%OpenId(OBJID,1)" X EXEC
 S EXEC="S VIEN=BEDDVST.VIEN" X EXEC
 S EXEC="S BEDDVST=""""" X EXEC
 ;
 ;Get the visit date and gender
 S VDT="" I $G(VIEN)]"" D
 .NEW DFN
 . S DFN=$$GET1^DIQ(9000010,VIEN_",",".05","I")
 . S SEX=$$GET1^DIQ(2,DFN_",",".02","I")
 . S VDT=$P($$GET1^DIQ(9000010,VIEN_",",".01","I"),".")
 S:$G(VDT)="" VDT=DT
 S:$G(SEX)="" SEX=""
 ;
 ;Get the gender
 ;
 ;Call the new lookup
 D DXLKP^BEDDPOV(VALUE,VDT,.SEX,FILTER)
 Q
 ;
ESAVE(DFN,AMERVSIT,VIEN,BEDDARY,DUZ) ;EP - Dashboard Edit Screen Save
 ;
 ; Input:
 ; DFN - Patient IEN
 ; BEDDARY - Array of entries to save
 ; DUZ
 ;
 NEW X
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 ;Define DUZ variable
 D DUZ^XUP(DUZ)
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;File ER ADMISSION entries
 I $G(DFN)]"" D
 . ;BEDD*2.0*8;Switch complaint to field 23 (from 8)
 . ;S:$D(BEDDARY("COMP")) AMUPD(9009081,DFN_",",8)=BEDDARY("COMP")
 . S:$D(BEDDARY("COMP")) AMUPD(9009081,DFN_",",23)=BEDDARY("COMP")
 . S:$D(BEDDARY("Trg")) AMUPD(9009081,DFN_",",20)=BEDDARY("Trg")
 . S:$D(BEDDARY("TrgNow")) AMUPD(9009081,DFN_",",21)=$$DATE^BEDDUTIL(BEDDARY("TrgNow"))
 . S:$D(BEDDARY("AdmPrv")) AMUPD(9009081,DFN_",",18)=BEDDARY("AdmPrv")
 . S:$D(BEDDARY("TrgN")) AMUPD(9009081,DFN_",",19)=BEDDARY("TrgN")
 . S:$D(BEDDARY("AdPvTm")) AMUPD(9009081,DFN_",",22)=BEDDARY("AdPvTm")
 ;
 ;File VISIT entries
 I $G(VIEN)]"" D
 . S:$G(BEDDARY("txcln"))]"" AMUPD(9000010,VIEN_",",.08)=$O(^DIC(40.7,"C",BEDDARY("txcln"),""))
 . S:$G(BEDDARY("txcln"))="" AMUPD(9000010,VIEN_",",.08)="@"
 . S AMUPD(9000010,VIEN_",",1401)=$S($G(BEDDARY("COMP"))]"":BEDDARY("COMP"),1:"@")
 . ;BEDDv2.0;Save Decision to admit date
 . S AMUPD(9000010,VIEN_",",1116)=$S($G(BEDDARY("DecAdmit"))]"":BEDDARY("DecAdmit"),1:"@")
 ;
 ;File ER VISIT entries
 I $G(AMERVSIT)]"" D
 . ;
 . ;Save Clinic Type
 . I $D(BEDDARY("txcln")) D
 .. NEW CLIN,XCLIN
 .. S CLIN=$O(^DIC(40.7,"C",BEDDARY("txcln"),"")) Q:CLIN=""
 .. S XCLIN=$$GET1^DIQ(40.7,CLIN_",",.01,"E") Q:XCLIN=""
 .. S CLIN=$O(^AMER(3,"B",XCLIN,"")) Q:CLIN=""
 .. S AMUPD(9009080,AMERVSIT_",",.04)=CLIN
 ;
 ;File visit entries
 I $D(AMUPD) D
 . NEW AUPNVSIT
 . D FILE^DIE("","AMUPD","ERROR")
 . ;
 . ;Flag that visit was changed
 . D MOD^AUPNVSIT
 ;
 ;BEDD*2.0*1;Update V EMERGENCY VISIT
 D VER^AMERVER($G(DFN),$G(VIEN))
 ;
 I $D(ERROR) Q 0
 Q 1
 ;
PLCHLD(OBJID,VIEN) ;EP - Look for Diagnosis Default
 ;
 I $G(OBJID)="" Q ""
 ;
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 NEW CDIEN,DXNM,DIC,X,Y,VDT,DFLTDX,BEDDPOV
 ;
 ;Get visit date, if blank use DT
 I $G(VIEN)]"" S VDT=$P($$GET1^DIQ(9000010,VIEN,".01","I"),".")
 S:$G(VDT)="" VDT=DT
 ;
 ;Quit if patient already has DX codes
 ;I $$DXCNT^BEDDUTIS(OBJID)>0 Q ""
 I $$POV^AMERUTIL("",VIEN,.BEDDPOV)>0 Q ""
 ;
 ;Determine if pre-AICD 4.0, pre-ICD-10, or post ICD-10
 S (DFLTDX,X)=".9999"
 I $$VERSION^XPDUTL("AICD")>3.51,$$IMP^ICDEXA(30)'>VDT S (DFLTDX,X)="ZZZ.999"
 ;
 S DIC="^ICD9(",DIC(0)="XMO" D ^DIC I +Y<0 Q ""
 S CDIEN=+Y
 ;
 S DXNM=$E($P($$ICDDX^AUPNVUTL(CDIEN,VDT),U,4),1,55)
 Q DFLTDX_"^"_CDIEN_"^"_DXNM
 ;
UPPER(X) ;EP - Convert to uppercase
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;
ERR ;EP - Capture the error
 D ^%ZTER
 Q
