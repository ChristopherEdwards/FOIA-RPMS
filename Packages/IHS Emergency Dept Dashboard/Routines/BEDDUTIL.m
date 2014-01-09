BEDDUTIL ;VNGT/HS/BEE-BEDD Utility Routine ; 08 Nov 2011  12:00 PM
 ;;1.0;BEDD DASHBOARD;;Dec 17, 2012;Build 31
 ;
 Q
 ;
CHECKAV(BEDDAV) ;EP - Authenticate AC/VC and Return DUZ
 ;
 ; Input: BEDDAV - ACCESS CODE_";"_VERIFY CODE
 ; Output: DUZ value
 ;
 N BEDDDUZ,XUF
 ;
 S:$G(U)="" U="^"
 S:$G(DT)="" DT=$$DT^XLFDT
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S XUF=0
 S BEDDDUZ=$$CHECKAV^XUS(BEDDAV)
 I BEDDDUZ=0 Q 0
 ;
 ;Return DUZ if user inactive
 I (+$P($G(^VA(200,BEDDDUZ,0)),U,11)'>0)!(+$P($G(^VA(200,BEDDDUZ,0)),U,11)'<DT) Q BEDDDUZ
 Q 0
 ;
AUTH(BEDDDUZ) ;EP - Authenticate User for DASHBAORD Access
 ;
 ; Input: BEDDDUZ - User's DUZ value
 ; Output: 0 - No Authorized/1 - Authorized
 ;
 N BEDDKEY
 ;
 S:$G(U)="" U="^"
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I $G(BEDDDUZ)<1 Q 0
 S BEDDKEY=$O(^DIC(19.1,"B","BEDDZDASH","")) I BEDDKEY="" Q 0
 I '$D(^VA(200,"AB",BEDDKEY,BEDDDUZ,BEDDKEY)) Q 0
 Q 1
 ;
SNAME(SITE) ;EP - Return Site Name from file 4
 ;
 I $G(SITE)="" Q ""
 ;
 ;S SITE=$O(^DG(40.8,"C",SITE,"")) Q:SITE="" ""
 ;S SITE=$$GET1^DIQ(40.8,SITE_",",".01","E")
 ;Q SITE
 Q $$GET1^DIQ(4,SITE_",",".01","E")
 ;
SITE(BEDDST) ;EP - Assemble List of Sites From File 40.8
 ;
 ; Input: BEDDSITE - Empty Array
 ; Output: BEDDSITE - List of file 4 entries pointed to by file 40.8 entries
 ;
 N BEDDSITE,BEDDIEN
 ;
 S:$G(U)="" U="^"
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S BEDDSITE="" F  S BEDDSITE=$O(^DG(40.8,"B",BEDDSITE)) Q:BEDDSITE=""  D
 . S BEDDIEN="" F  S BEDDIEN=$O(^DG(40.8,"B",BEDDSITE,BEDDIEN)) Q:BEDDIEN=""  D
 .. NEW INNM,INIEN
 .. S INIEN=$$GET1^DIQ(40.8,BEDDIEN_",",.07,"I") Q:INIEN=""
 .. S INNM=$$GET1^DIQ(4,INIEN_",",".01","I") Q:INNM=""
 .. S BEDDST(INNM_":"_INIEN)=INNM_U_INIEN
 Q
 ;
BEDDLST(BEDD) ;EP - Assemble Dashboard List
 ;
 ; Input: BEDD - Empty Array
 ; Output: BEDD - List of Dashboard Patients
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 K BEDD
 ;
 NEW BEDDDAY,BEDDIEN,BEDDGL,BEDDTOT,BEDDBDY
 S BEDDBDY=$P($H,",")-28,BEDDDAY=""
 S BEDDGL="^BEDD.EDVISITI(""ArrIdx"")"
 F  S BEDDDAY=$O(@BEDDGL@(BEDDDAY),-1) Q:((BEDDDAY="")!(BEDDDAY<BEDDBDY))  D
 . S BEDDIEN="" F  S BEDDIEN=$O(@BEDDGL@(BEDDDAY,BEDDIEN),-1) Q:BEDDIEN=""  D
 .. NEW TRG,ROOM,EDWTIM,EDSTAT,EDTRG,EDROOM,PTDFN
 .. S (EDSTAT,EDTRG,EDROOM,EDWTIM,PTDFN)=""
 .. ;
 .. ;Retrieve entry
 .. D BEDDED^BEDDUTW(BEDDIEN,.EDSTAT,.EDTRG,.EDROOM,.EDWTIM,.PTDFN)
 .. ;
 .. ;Strip out duplicates
 .. Q:$G(PTDFN)=""
 .. I $D(BEDD("D",PTDFN)) Q
 .. S BEDD("D",PTDFN)=""
 .. ;
 .. I EDSTAT=9 Q
 .. I EDSTAT=8 Q
 .. S TRG="" I EDTRG'="" S TRG=EDTRG
 .. S:TRG="" TRG=" "
 .. S ROOM=" " I EDROOM'="" S ROOM=EDROOM
 .. I EDSTAT=1 S BEDD(EDSTAT,BEDDIEN)=EDWTIM
 .. I EDSTAT=2 S BEDD(EDSTAT,TRG,BEDDIEN)=EDWTIM
 .. I EDSTAT=3 S BEDD(EDSTAT,ROOM,BEDDIEN)=EDWTIM
 .. I EDSTAT=4 S BEDD(EDSTAT,TRG,BEDDIEN)=EDWTIM
 .. S BEDD("SUM",EDSTAT,BEDDIEN)=EDWTIM
 .. S $P(BEDDTOT(EDSTAT),"^")=$P($G(BEDDTOT(EDSTAT)),"^")+1
 .. S $P(BEDDTOT(EDSTAT),"^",2)=$P($G(BEDDTOT(EDSTAT)),"^",2)+EDWTIM
 .. ;
 .. ;Track entries
 .. S BEDD("L",BEDDIEN)=""
 ;
 ;Assemble Totals
 S EDSTAT="" F  S EDSTAT=$O(BEDDTOT(EDSTAT)) Q:EDSTAT=""  D
 . NEW CNT,WTG,AVG
 . S CNT=$P(BEDDTOT(EDSTAT),"^")
 . S WTG=$P(BEDDTOT(EDSTAT),"^",2)
 . S AVG="" I CNT>0,WTG>0 S AVG=WTG\CNT
 . S BEDD("TSUM",EDSTAT)=CNT_"^"_WTG_"^"_AVG
 ;
 ;Check (and Repair) Room Occupancy
 D RMAV^BEDDUTW(.BEDD)
 ;
 Q
 ;
GETCC(BEDDIEN,BEDDCOMP) ;EP - Get V NARRATIVE TEXT
 ;
 ; Input:
 ; BEDDIEN - V NARRATIVE TEXT Entry IEN
 ; BEDDCOMP - BEDD.EDVISIT - Complaint field value
 ;
 ; Output:
 ; V NARRATIVE TEXT (1st) or Complaint value (2nd)
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW BEDDCTXT
 S BEDDIEN=$G(BEDDIEN,""),BEDDCOMP=$G(BEDDCOMP,"")
 S BEDDCTXT=""
 ;
 I $G(BEDDIEN)]"",$D(^AUPNVNT("AD",BEDDIEN)) D
 . NEW BEDDCC
 . S BEDDCC=$O(^AUPNVNT("AD",BEDDIEN,""),-1)
 . I $D(^AUPNVNT(BEDDCC,11,0)) D
 .. N LN
 .. S LN=0 F  S LN=$O(^AUPNVNT(BEDDCC,11,LN)) Q:LN=""  D
 ... S BEDDCTXT=$G(BEDDCTXT)_$S(BEDDCTXT="":"",1:" ")_$G(^AUPNVNT(BEDDCC,11,LN,0))
 ;
 S:BEDDCTXT="" BEDDCTXT=BEDDCOMP
 ;
 Q BEDDCTXT
 ;
GETF(BEDDFILE,BEDDIEN,BEDDFLD,BEDDIE) ; EP - Retrieve value from specified file/field
 ;
 ; Input:
 ; BEDDFILE - RPMS file number
 ; BEDDIEN  - File IEN
 ; BEDDFLD  - Field to retrieve
 ; BEDDIE   - Internal/External display
 ;
 ; Output:
 ; Value in the specified field
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I BEDDFILE=""!(BEDDFLD="") Q ""
 I $TR(BEDDIEN,",")'?1N.N Q ""
 S:$G(BEDDIE)="" BEDDIE="E"
 S:$E(BEDDIEN,$L(BEDDIEN))'="," BEDDIEN=BEDDIEN_","
 Q $$GET1^DIQ(BEDDFILE,BEDDIEN,BEDDFLD,BEDDIE)
 ;
GETOSTAT(DFN) ; EP - Get Order Summary By Package Type
 ;
 ; Input:
 ; DFN - Patient IEN
 ;
 ; Output:
 ; Package Order Summary for T and T-1
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW BEDDORD,BEDDOST,BEDDIX,BYDT,X,X1,X2,YDT
 ;
 I $G(DFN)="" Q ""
 ;
 S:$G(DT)="" DT=$$DT^XLFDT
 S X1=DT,X2=-1 D C^%DTC S YDT=X
 S BYDT=9999999-YDT
 ;
 S BEDDIX="" F  S BEDDIX=$O(^OR(100,"AC",DFN_";DPT(",BEDDIX)) Q:BEDDIX>BYDT!'BEDDIX  D
 . NEW BEDDOIEN S BEDDOIEN="" F  S BEDDOIEN=$O(^OR(100,"AC",DFN_";DPT(",BEDDIX,BEDDOIEN)) Q:BEDDOIEN=""  D
 .. NEW BEDDOSTS,BEDDORDT,BEDDOITM,BEDDOPRF
 .. S BEDDOSTS=$$GET1^DIQ(100,BEDDOIEN_",",5,"E") Q:BEDDOSTS=""
 .. S BEDDORDT=$$GET1^DIQ(100,BEDDOIEN_",",4,"I")
 .. Q:BEDDORDT<YDT
 .. ;
 .. S BEDDOITM=$$GET1^DIQ(100,BEDDOIEN_",",7,"E")
 .. S:BEDDOITM="" BEDDOITM=$$GET1^DIQ(100,BEDDOIEN_",",2,"E")
 .. S BEDDOPRF=$$GET1^DIQ(100,BEDDOIEN_",",33,"E")
 .. S BEDDOITM=$E(BEDDOITM,1,2)
 .. S BEDDOITM=$S(BEDDOITM="LR":"LAB",BEDDOITM="RA":"RAD",BEDDOITM="PS":"RX",BEDDOITM="GM":"CONSULT",1:BEDDOITM)
 .. Q:BEDDOITM=""
 .. S BEDDORD(BEDDOITM,BEDDOSTS)=$G(BEDDORD(BEDDOITM,BEDDOSTS))+1
 ;
 S (BEDDORD,BEDDIX)="" F  S BEDDIX=$O(BEDDORD(BEDDIX)) Q:BEDDIX=""  D
 . N BEDDIX1 S BEDDIX1="" F  S BEDDIX1=$O(BEDDORD(BEDDIX,BEDDIX1)) Q:BEDDIX1=""  D
 .. S BEDDORD=$G(BEDDORD)_BEDDORD(BEDDIX,BEDDIX1)_" "_BEDDIX1_" "_BEDDIX_"; "
 Q BEDDORD
 ;
LOGSEC(DUZ,DFN) ;EP - Adds/updates entry in DG Security Log file
 ;
 ; Input:
 ; DUZ - User IEN
 ; DFN - Patient IEN
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW DGOPTI,DGOPT2
 ;
 S DGOPTI=$O(^DIC(19,"B","BEDDEDIT",0)) Q:DGOPTI=""
 S DGOPT2=$P(^DIC(19,DGOPTI,0),"^",1)_"^"_$P(^DIC(19,DGOPTI,0),"^",2)
 I $TR(DGOPT2,"^","")]"" D SETLOG1^DGSEC(DFN,DUZ,,DGOPT2)
 ;
 Q
 ;
PPR(BEDDVIEN,OBJID,DFN) ;EP - Retrieve the Primary Provider
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW PPR,EDOBJ,PIEN
 ;
 S PPR=""
 I $G(BEDDVIEN)="" Q ""
 S PIEN="" F  S PIEN=$O(^AUPNVPRV("AD",BEDDVIEN,PIEN),-1) Q:PIEN=""  I $$GET1^DIQ(9000010.06,PIEN_",",.04,"I")="P" S PPR=$$GET1^DIQ(9000010.06,PIEN_",",.01,"E") Q
 ;
 I $G(DFN)]"",PPR="" S PPR=$$PTPCP^BEDDUTIL(DFN)
 I $G(OBJID)]"",PPR'="" D UPPRV^BEDDUTW(OBJID,PPR)
 Q PPR
 ;
XNOW(FORM) ;EP - Return Current External Date and Time
 ;
 ; Input:
 ; FORM (Optional) - Second parameter of XLFDT call
 ;
 ; Output:
 ; Date/Time in MMM DD,CCYY@HH:MM:SS format
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S FORM=$G(FORM,"")
 NEW %,%H,%I,X
 D NOW^%DTC
 Q $$FMTE^XLFDT(%,FORM)
 ;
FNOW() ;EP - Return Current FileMan Date and Time
 ;
 ; Input:
 ; None
 ;
 ; Output:
 ; Date/Time in FileMan CYYMMDD.HHMMSS format
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW %,%H,%I,X
 D NOW^%DTC
 Q %
 ;
DATE(DATE) ;EP - Convert standard date/time to a FileMan date/time
 ;
 ; Input:
 ; DATE - In a standard format
 ;
 ; Output:
 ; Date/Time in FileMan CYYMMDD.HHMMSS format
 ; -1 is if it couldn't convert to a FileMan date
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW %DT,X,Y
 I DATE[":" D
 . I DATE["/",$L(DATE," ")=3 S DATE=$P(DATE," ",1)_"@"_$P(DATE," ",2)_$P(DATE," ",3) Q
 . I $L(DATE," ")=3 S DATE=$P(DATE," ",1,2)_"@"_$P(DATE," ",3)
 . I $L(DATE," ")>3 S DATE=$P(DATE," ",1,3)_"@"_$P(DATE," ",4,99)
 S %DT="TS",X=DATE D ^%DT
 I Y=-1 S Y=""
 ;
 Q Y
 ;
NEW(D,AMERDFN,D0,D1,DFN,NODSP) ;EP - Create Dashboard Entry - Called from AMER routine
 ;
 ; Input:
 ; D   - Current entry information - Quit if defined
 ; AMERDFN/DFN - Patient's DFN entry
 ; D0/D1 - VIEN/ADT info
 ; NODSP - Do not display to screen
 ;
 NEW BEDDSYS,BEDDADT,BEDDDFN,VIEN,ID,X
 ;
 S BEDDADT=$G(D1),BEDDDFN=$G(DFN),VIEN=$G(D0),NODSP=$G(NODSP)
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;Check if entry already defined
 I $G(D)]"" Q
 ;
 I '$G(NODSP) W !,"Setting data for Dashboard..."
 ;
 D EDSYS^BEDDUTW(.BEDDSYS)
 ;
 S ID=$$NEW^BEDDUTW(AMERDFN,VIEN) I ID=0 Q
 ;
 ;Report/Label Displays
 I '$G(NODSP) D
 . I $D(BEDDSYS("MRC")) W !!!,"Select printer for PATIENT MEDICATION WORKSHEET...",!! D EN^BEDDMREC(BEDDDFN,VIEN)
 . I $D(BEDDSYS("PRS")) W !!!,"Select printer for PATIENT ROUTING SLIP...",!! D EN^BEDDEHRS(BEDDDFN)
 . I $D(BEDDSYS("ARM")) D
 .. W !!!,"Select printer for Patient WristBand/Embossed Card...",!! H 1
 .. S DFN=BEDDDFN S X="AGCARD" D HDR^AG,DFN^AGCARD D PHDR^AG
 ;
 ;Special Code to Update MODE OF TRANSPORT field
 S X=$$MDTRN^BEDDUTID(BEDDDFN)
 ;
 Q
 ;
XCLIN(CODE) ;EP - Return External Clinic
 ;
 ; Input:
 ; CODE - CODE field value from 40.7
 ;
 ; Output:
 ; NAME (.01) 40.7 value
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW DIC,X,Y
 ;
 S DIC="^DIC(40.7,",X=CODE,DIC(0)="M"
 D ^DIC
 ;
 Q $P(Y,"^",2)
 ;
PTALG(DFN) ;EP - Return Patient Allergies
 ;
 ; Input:
 ; DFN - Patient IEN
 ;
 ; Output:
 ; List of Allergies
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW PTALG,X,BEDDI
 ;
 S PTALG=""
 ;
 K ^TMP("PTADR",$J)
 ;
 S X=$$MAIN^TIULADR(DFN,,"^TMP(""PTADR"",$J)",0)
 S BEDDI="" F  S BEDDI=$O(^TMP("PTADR",$J,BEDDI)) Q:BEDDI=""  S PTALG=PTALG_" "_$G(^TMP("PTADR",$J,BEDDI,0))
 ;
 K ^TMP("PTADR",$J)
 Q PTALG
 ;
PTPCP(DFN) ;EP - Return Patient PCP
 ;
 ; Input:
 ; DFN - Patient IEN
 ;
 ; Output:
 ; Patient PCP
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 Q $P($$DPCP(DFN),"^",2)
 ;
TRGUPD(VIEN) ;EP - Update ER ADMISSION TRIAGE NURSE/ADMITTING PROV/ACUITY
 ;
 ; Input:
 ; VIEN - Pointer to 9000010 VISIT file
 ;
 ; Output
 ; Pointer to TRG MEASUREMENT TYPE (if defined)
 ;
 I $G(VIEN)="" Q ""
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW AMUPD,ERROR,BEDDTRG,BEDDTRGD,BEDDTRGN,BEDDTRGI,DFN,MYTRG
 ;
 S (BEDDTRG,BEDDTRGD,BEDDTRGN)=""
 S BEDDTRGI=$O(^AUTTMSR("B","TRG",""))
 I $D(^AUPNVMSR("AD",VIEN)) D
 . NEW MIEN
 . S MIEN="" F  S MIEN=$O(^AUPNVMSR("AD",VIEN,MIEN)) Q:'MIEN  D
 .. I BEDDTRGD="" S BEDDTRGD=$$GET1^DIQ(9000010.01,MIEN_",",1201,"I"),BEDDTRGN=$$GET1^DIQ(9000010.01,MIEN_",",1204,"I")
 .. I BEDDTRGI]"",BEDDTRG="",BEDDTRGI=$$GET1^DIQ(9000010.01,MIEN_",",.01,"I") S BEDDTRG=$$GET1^DIQ(9000010.01,MIEN_",",.04,"I")
 ;
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I") Q:'$D(^AMERADM(DFN)) BEDDTRG
 I BEDDTRG]"" D BLDTRG(.MYTRG) I $D(MYTRG(BEDDTRG)) S AMUPD(9009081,DFN_",",20)=$P(MYTRG(BEDDTRG),"^",3)
 I BEDDTRGD]"" S AMUPD(9009081,DFN_",",21)=BEDDTRGD
 I BEDDTRGN]"" S AMUPD(9009081,DFN_",",19)=BEDDTRGN
 ;
 ;Only save items when Save button is clicked
 ;I $D(AMUPD) D FILE^DIE("","AMUPD","ERROR")
 ;
 Q BEDDTRG
 ;
BLDTRG(MYTRG) ;EP - Build Acuity MYTRG array
 ;
 ; Input:
 ; None
 ;
 ; Output:
 ; MYTRG array of ^AMER(3) TRIAGE CATEGORY entries
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW TIEN,TIEN1,AC
 K MYTRG
 S TIEN=$O(^AMER(2,"B","TRIAGE CATEGORY","")) Q:TIEN=""
 S TIEN1="" F  S TIEN1=$O(^AMER(3,"AC",TIEN,TIEN1)) Q:'TIEN1  D
 . NEW ANM,CNM
 . S AC=$$GET1^DIQ(9009083,TIEN1_",",5,"E") Q:AC=""
 . S CNM=$$GET1^DIQ(9009083,TIEN1_",",.01,"E")
 . S ANM=$S(AC=1:"RESUSCITATION",AC=2:"EMERGENT",AC=4:"LESS URGENT",AC=5:"ROUTINE",1:CNM)
 . S MYTRG(AC)=TIEN1_"^"_CNM_"^"_AC_"^"_ANM
 Q
 ;
INJCAUSE(OBJID) ;EP - Retrieve Cause of Injury - Not Implemented
 Q ""
 ;
INJSTG(OBJID) ;EP - Retrieve Setting of Injury - Not Implemented
 Q ""
 ;
IND(OBJID) ;EP - Retrieve the Industry - Not Implemented
 Q ""
 ;
OCC(OBJID) ;EP - Retrieve the Occupation - Not Implemented
 Q ""
 ;
TODLH(DTTM) ;EP - Convert External Date to $H
 ;
 S DTTM=$$DATE^BEDDUTIU($G(DTTM))
 Q $$FMTH^XLFDT(DTTM)
 ;
FMTE(FMDT,FORM) ;EP - Convert FMan to Standard External Date/Time
 S:$G(FORM)="" FORM="5ZM"
 Q $TR($$FMTE^XLFDT(FMDT,FORM),"@"," ")
 ;
FM2HD(FMDT) ;EP - Convert FMan Date/Time to $H date portion
 Q $$FMTH^XLFDT(FMDT,1)
 ;
MINWTG(HDT,HTM) ;EP - Calculate Difference in Minutes from $H
 Q $P($$HDIFF^XLFDT($H,HDT_","_HTM,2)/60,".")
 ;
FM2HT(FMDT) ;EP - Convert FMan Date/Time to $H time portion
 Q $P($$FMTH^XLFDT(FMDT),",",2)
 ;
DPCP(DFN) ;EP -- Get patient's designated primary care provider
 ;
 ;Description
 ;  Checks the 'Designated Provider Management System' first
 ;  for the patient's primary care provider, otherwise it
 ;  checks the Patient file.
 ;Input
 ;  DFN - Patient internal entry number
 ;Output
 ;  DPCPN^DPCPNM
 ;    DPCPN  - Primary Care Provider internal entry number
 ;    DPCPNM - Primary Care Provider Name
 ;
 NEW DPCAT,DPIEN,DPCPN,DPCPNM
 S DPCPN=""
 S DPCAT=$O(^BDPTCAT("B","DESIGNATED PRIMARY PROVIDER",""))
 I DPCAT'="" D
 . S DPIEN=$O(^BDPRECN("AA",DFN,DPCAT,""))
 . I DPIEN="" Q
 . S DPCPN=$$GET1^DIQ(90360.1,DPIEN_",",.03,"I")
 . S DPCPNM=$$GET1^DIQ(90360.1,DPIEN_",",.03,"E")
 I DPCPN'="" Q DPCPN_"^"_DPCPNM
 ;
 S DPCPN=$$GET1^DIQ(9000001,DFN_",",.14,"I")
 S DPCPNM=$$GET1^DIQ(9000001,DFN_",",.14,"E")
 Q DPCPN_"^"_DPCPNM
 ;
ERR ;
 D ^%ZTER
 Q
