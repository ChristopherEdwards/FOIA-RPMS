BGOVAMI1 ; MSC/JS - VAMI Utilities ;28-Feb-2014 10:27;DU
 ;;1.1;BGO COMPONENTS;**13,14**;Mar 20, 2007;Build 16
 ;
 ;01.23.14 MSC/JS - Move GETVFIEN and NARR here to keep routine within 15k size limits
 ;02.06.14 MSC/MGH - Changed refusal to try and find exisiting one on edit
 ;
NARR(DESCT,NARR) ;Provider narrative is now provider text | descriptive SNOMED CT
 N NARRPTR,RET
 S NARRPTR=0
 S NARR=NARR_"|"_DESCT
 I $L(NARR) D  Q:RET
 .S RET=$$FNDNARR^BGOUTL2(NARR)
 .S:RET>0 NARRPTR=RET,RET=""
 Q NARRPTR
 ; Fetch V File entries
 ;  INP = Patient IEN (for entries associated with a patient) [1] ^
 ;        V File IEN (for single entry) [2] ^
 ;        Visit IEN (for entries associated with a visit) [3]
GETVFIEN(RET,INP) ;EP
 N DFN,GBL,VFIEN,VIEN,XREF
 S RET=0,GBL=$$ROOT^DILFD($$FNUM,,1)
 I '$L(GBL) S RET=$$ERR^BGOUTL(1069) Q
 S DFN=+INP
 S VFIEN=$P(INP,U,2)
 S VIEN=$P(INP,U,3)
 ; If the VFIEN is present, then use that.
 I VFIEN D
 .I '$D(@GBL@(VFIEN,0)) S RET=$$ERR^BGOUTL(1070)
 .E  S RET=1,RET(1)=VFIEN
 E  I VIEN D
 .S (RET,VFIEN)=0
 .F  S VFIEN=$O(@GBL@("AD",VIEN,VFIEN)) Q:'VFIEN  S RET=RET+1,RET(RET)=VFIEN
 E  I DFN D
 .S VFIEN="",XREF=$$VFPTXREF^BGOUTL2
 .; Return the records newest to oldest
 .F  S VFIEN=$O(@GBL@(XREF,DFN,VFIEN),-1) Q:'VFIEN  S RET=RET+1,RET(RET)=VFIEN
 E  S RET=$$ERR^BGOUTL(1008)
 Q
 ;Add entry to file #9000022 PATIENT REFUSALS FOR SERVICE/NMI for patient refused Therapy
 ;  INP = Refusal IEN [1] ^ Refusal Type [2] ^ Item IEN [3] ^ Patient IEN [4] ^
 ;        Refusal Date [5] ^ Comment [6] ^ Provider IEN [7] ^ Reason [8]
SETREF(DFN,REFRES,REFDT,VFNEW) ; EP
 S RET=""
 I $G(DFN)="" Q RET
 N TYPE,DTDONE,CPT,SNO,RIEN,FOUND
 S RIEN=""
 S TYPE="CPT"
 S CPT=$$GET^XPAR("ALL","BGO AMI THROMBO NOT DONE",1,"E")
 S CPT=$O(^ICPT("BA",$G(CPT)_" ",0))
 S:CPT="" CPT=92975 ;    default to CPT code DISSOLVE CLOT, HEART VESSEL
 I '+REFRES S REFRES=23
 S DTDONE=$P(REFDT,".",1)
 I DTDONE="" S DTDONE="TODAY",DTDONE=$$DT^CIAU(DTDONE)
 I 'VFNEW D
 .S FOUND=0
 .N INV,Y
 .S INV="" F  S INV=$O(^AUPNPREF("AA",DFN,81,CPT,INV)) Q:INV=""!(FOUND=1)  D
 ..S Y=9999999-INV
 ..Q:Y'=DTDONE
 ..S REFIEN=$O(^AUPNPREF("AA",DFN,81,CPT,INV,""))
 ..I +REFIEN S RIEN=REFIEN,FOUND=1
 S INP=RIEN_U_TYPE_U_CPT_U_DFN_U_DTDONE_U_U_DUZ_U_REFRES
 D SET^BGOREF(.RET,INP)
 I RET="" S RET=1
 Q RET
 ;
 ;Delete entry from PATIENT REFUSALS FOR SERVICE/NMI file #9000022 for V AMI record logical delete
 ;  INP = V AMI file ien VFIEN
DELREF(VFIEN) ; EP
 S RET=""
 I $G(VFIEN)="" Q RET
 ;I $G(^AUPNVAMI(VFIEN,5))="" Q RET  ; not a deleted record
 N DECDT,DFN,DNIRDT,DNIRDUZ,FNUM,INVDATE,NOD0,FILIEN,REFIEN,TYPE,CPT
 S NOD0=$G(^AUPNVAMI(VFIEN,0))
 S DFN=$P(NOD0,"^",2),DNIRDT=$P($P(NOD0,"^",15),".",1),DNIRDUZ=$P(NOD0,"^",16)
 I DNIRDT="" S DNIRDT=$P($P(NOD0,"^",12),".",1)  ;Get entered date if it was an edit
 ;I $G(DFN)=""!($G(DNIRDT)="")!($G(DNIRDUZ)="") Q RET
 I $G(DFN)=""!($G(DNIRDT)="") Q RET
 S INVDATE=9999999-DNIRDT
 S CPT=$$GET^XPAR("ALL","BGO AMI THROMBO NOT DONE",1,"E")
 S TYPE=+$$CPT^ICPTCOD(CPT)
 I TYPE<0  Q RET
 N FNUM S FNUM=81 ;  p13 CPT codes only
 S DECDT=0
 F  S DECDT=$O(^AUPNPREF("AA",DFN,FNUM,TYPE,DECDT)) Q:'DECDT  D
 .Q:DECDT'=INVDATE
 .S FILIEN="",FILIEN=$O(^AUPNPREF("AA",DFN,FNUM,TYPE,DECDT,FILIEN))
 .N ENTBY,NOD12
 .S NOD12=$G(^AUPNPREF(FILIEN,12)),ENTBY=$P(NOD12,U,17)
 .Q:ENTBY=""
 .I ENTBY=DNIRDUZ!(DNIRDUZ="") S REFIEN=FILIEN
 I $G(REFIEN)="" Q RET
 N DELRET
 D DEL^BGOREF(.DELRET,REFIEN)
 I DELRET="" S RET=1
 Q RET
 ;
 ;Display V AMI entry fld#.17 DID NOT INIT FIB REASON Snomed code + XPAR CPT code
 ;  DNIR = fld #.17 Snomed code [1]
 ;  checks DNIR value with API call to verify CONCEPT ID code is valid, if not defaults to:
 ;     REFUSAL REASONS file #9999999.102 IEN 17   CONCEPT ID: 275936005
 ;     USE WITH MEDICATION REFUSAL: YES      .07 CODE VALUE: DECLINED SERVICE
 ;     SCREEN: ALL
 ;     CONCEPT ID PREFERRED TERM (c): Patient noncompliance - general (situation)
GETREF(DNIR) ; EP
 N SNOINFO
 S SNOINFO=""
 I +$G(DNIR)="" Q SNOINFO
 NEW CPT,CPTDESC,IN,SNOCHEK,SNODESC
 ;check for valid Snomed ID, input IN (Snomed ID)
 ;Output -
 ; Function returns - [1]^[2]^[3]^[4]
 ; [1] - Description Id of Fully Specified Name
 ; [2] - Fully Specified Name
 ; [3] - Description Id of Preferred Term
 ; [4] - Preferred Term
 S IN=$G(DNIR)_"^^^1" D
 .K ^TMP("BSTSCMCL",$J)
 .S SNOCHEK=$$CONC^BSTSAPI(IN)
 .K ^TMP("BSTSCMCL",$J)
 .S SNODESC=$P(SNOCHEK,"^",2)
 .I SNODESC="" D  ;  stored V Stroke field invalid, use default ID
 ..S IN=275936005_"^^^1"
 ..K ^TMP("BSTSCMCL",$J)
 ..S SNOCHEK=$$CONC^BSTSAPI(IN)
 ..K ^TMP("BSTSCMCL",$J)
 ..S SNODESC=$P(SNOCHEK,"^",2)
 S CPT=$$GET^XPAR("SYS","BGO AMI THROMBO NOT DONE")
 S:CPT="" CPT=92975
 S CPTDESC=$$GET1^DIQ(81,CPT,2,"E")
 S SNOINFO=$G(SNODESC)_" - "_CPTDESC
 Q SNOINFO
DEL(RET2,VFIEN,SUBIEN,SUBFILE) ;Delete subfile entry
 N ERR,DA,DIK,NODE
 S ERR=""
 S DA(1)=VFIEN,DA=+SUBIEN
 S DIK="^AUPNVAMI(DA(1),"_SUBFILE_","
 S:DA ERR=$$DELETE^BGOUTL(DIK,.DA)
 I ERR'="" S RET=RET_"^"_ERR
 Q
 ;
 ; Return V File #
 ; This method signature allows this to be called as a Remote Procedure.
FNUM(RET,INP) S RET=9000010.62
 Q RET
