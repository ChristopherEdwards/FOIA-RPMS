BGOVSTR1 ; MSC/JS - Utility calls for V STROKE ;14-Oct-2014 11:09;DU
 ;;1.1;BGO COMPONENTS;**13,14**;Mar 20, 2007;Build 16
 ;1.10.14 MSC/JS - Move MIDGET and MIDSET calls here, add ICD10 conversion date check for Stroke Symptoms multiple subfld .01, .02
 ;1.13.14 MSC/JS - Move GETVFIEN and NARR here to keep routine BGOVSTR within 15k size limits
 ;1.14.14 MSC/JS - Delete MIDSET,MIDGET,KEYLIST,LEYFLDS,KEYNAME,KEYNAMS code since no longer used.
 ;1.24.14 MSC/JS - Changed loop to sum up 'VALUE' from 1:1:19 to 1:1:20 for filing Stroke Score in V Measurement file
 ;2.6.14  MSC/MGH- Changed refusal to try and find existing one on edit
 ;
NARR(DESCT,NARR) ;Provider narrative is now provider text | descriptive SNOMED CT
 N NARRPTR
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
 ; If the VFIEN is present, then use that
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
 ;Check/Reset Stroke Symptoms multiple .01 CONCEPT ID value, .02 DESCRIPTION ID if VISIT date VDTE is before ICD10 conversion date (10.1.14)
 ; If Stroke record is created before 10.1.14 and edited afterwards, the Snomed CT value and ICD code lookup is ICD9.
 ; 1400      STROKE SYMPTOMS (Multiple-9000010.6314), [14;0]
 ;          .01  CONCEPT ID (F), [0;1]
 ;          .02  DESCRIPTION ID (F), [0;2]
 ;
 ; INP =    Visit ien (VIEN)
 ; Returns: 0   (Visit date is after ICD10 implementation date)
 ;          1 ^ ICD9 Snomed Concept ID ^ ICD9 Snomed Description ID ^ ICD9 code
CHKICDT(RET,INP) ;
 N IMP,VDTE
 S RET=0
 S VDTE=$P($G(^AUPNVSIT(VIEN,0)),U,1)
 ;Changes added for ICD-10 conversion
 I $$AICD^BGOUTL2 D
 .S IMP=$$IMP^ICDEX("10D",DT)
 I $G(IMP)="" Q RET
 I VDTE>IMP Q RET
 ; -- add call to BSTS to get ICD9 version of Snomed Concept ID, Snomed Description ID, and ICD9 code --
 Q RET
 ;Add entry to file #9000022 PATIENT REFUSALS FOR SERVICE/NMI for patient refused Therapy
 ;  INP = Refusal IEN [1] ^ Refusal Type [2] ^ Item IEN [3] ^ Patient IEN [4] ^
 ;        Refusal Date [5] ^ Comment [6] ^ Provider IEN [7] ^ Reason [8]
SETREF(DFN,REFRES,REFDT,VFNEW) ; EP
 S RET=""
 I $G(DFN)="" Q RET
 N TYPE,DTDONE,CPT,RIEN,FOUND
 S RIEN=""
 S TYPE="CPT"
 S CPT=$$GET^XPAR("ALL","BGO STROKE TROMBO NOT DONE",1,"E")
 S CPT=$O(^ICPT("BA",$G(CPT)_" ",0))
 S:CPT="" CPT=37195 ;    default to CPT code THROMBOLYTIC THERAPY, STROKE
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
 S INP=RIEN_U_TYPE_U_CPT_U_DFN_U_DTDONE_U_U_DUZ_U_REFRES ; 23 = Refused
 D SET^BGOREF(.RET,INP)
 I RET="" S RET=1
 Q RET
 ;Delete entry from PATIENT REFUSALS FOR SERVICE/NMI file #9000022 for V Stroke record logical delete
 ;  INP = V Stroke file ien VFIEN
DELREF(VFIEN) ; EP
 S RET=""
 I $G(VFIEN)="" Q RET
 ;I $G(^AUPNVSTR(VFIEN,5))="" Q RET  ; not a deleted record
 N DECDT,DFN,DNIRDT,DNIRDUZ,FNUM,INVDATE,NOD0,FILIEN,REFIEN,TYPE,CPT
 S NOD0=$G(^AUPNVSTR(VFIEN,0))
 S DFN=$P(NOD0,"^",2),DNIRDT=$P($P(NOD0,"^",15),".",1),DNIRDUZ=$P(NOD0,"^",16)
 I DNIRDT="" S DNIRDT=$P($P(NOD0,"^",12),".",1)  ;Get entered date if it was an edit
 ;I $G(DFN)=""!($G(DNIRDT)="")!($G(DNIRDUZ)="") Q RET
 I $G(DFN)=""!($G(DNIRDT)="") Q RET
 S INVDATE=9999999-DNIRDT
 S CPT=$$GET^XPAR("ALL","BGO STROKE THROMBO NOT DONE",1,"E")
 S TYPE=+$$CPT^ICPTCOD(CPT)
 I TYPE<0 Q RET
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
 ;Display V STROKE entry fld#.17 DID NOT INIT FIB REASON Snomed code + XPAR CPT code
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
 S CPT=$$GET^XPAR("SYS","BGO STROKE TROMBO NOT DONE")
 S:CPT="" CPT=37195
 S CPTDESC=$$GET1^DIQ(81,CPT,2,"E")
 S SNOINFO=$G(SNODESC)_" - "_$G(CPTDESC)
 Q SNOINFO
 ;Add new LKW entry if onset of symptoms is entered
SETLKW(INP) ; EP
 N EVDATE,VIEN,FNUM,LKWDATE,NUM,MIEN,TYPE,VALUE,VI,VFSTR,VMIEN,VMINP,WITNESS,FOUND
 N INVDT,MEAIEN,MEAVIEN,IEN
 S FOUND=0
 S DFN=$P(INP,U,1)
 S VIEN=$P(INP,U,2)
 S VMIEN=$P(INP,U,4)
 I $G(VIEN)="" S RET="-1^Missing Visit IEN" Q RET
 I '$D(^AUPNVSIT(VIEN)) S RET=$$ERR^BGOUTL(1035) Q RET  ; Item not found
 S RET="" S FNUM=9000010.01
 S TYPE="LKW"
 S VALUE="WELL"
 S EVDATE=$P(INP,U,3)
 I VMIEN'="" D
 .I '$D(^AUPNVMSR(VMIEN)) S VMIEN=""
 .I $$GET1^DIQ(9000010.01,VMIEN,2,"I")=1 S VMIEN=""
 ;S MIEN=$O(^AUTTMSR("B","LKW",""))
 ;Q:MIEN=""
 ;S INVDT="" F  S INVDT=$O(^AUPNVMSR("AA",DFN,MIEN,INVDT)) Q:INVDT=""!(FOUND=1)  D
 ;.S MEAIEN="" F  S MEAIEN=$O(^AUPNVMSR("AA",DFN,MIEN,INVDT,MEAIEN)) Q:MEAIEN=""!(FOUND=1)  D
 ;..S MEAVIEN=$P($G(^AUPNVMSR(MEAIEN,0)),U,3)
 ;..I MEAVIEN=VIEN S VMIEN=MEAIEN,FOUND=1
 ; VMINP= Visit IEN [1] ^ V File IEN [2] ^ Type [3] ^ Value [4] ^ Date/Time [5]
 S VMINP=$G(VIEN)_U_$G(VMIEN)_U_$G(TYPE)_U_$G(VALUE)_U_$G(EVDATE)
 D SET^BGOVMSR(.RET,.VMINP)
 S VMIEN=RET
 Q RET
 ;Add/edit V Measurement NIH entry:
 ;   1.  Add entry if VFNEW and 'N' string exists  (new V STROKE entry can be added w/o NIH data)
 ;   2.  Add entry if 'VFNEW and 'N' string exists (existing V STROKE entry update, 'N' sent only if update)
SETNIH(VFIEN,VIEN,INP) ; EP
 I $G(VIEN)="" S RET="-1^Missing Visit IEN" Q RET
 I '$D(^AUPNVSIT(VIEN)) S RET=$$ERR^BGOUTL(1035) Q RET  ; Item not found
 N EVDATE,FNUM,I,VALUE,NUM,QIEN,QUAL,QUALS,SUM,TYPE,VMIEN,VCODE,VI,VFSTR,VMIEN,VMINP,SIEN,DEL,OLDVAL
 S RET="" S FNUM=9000010.01
 S NUM="" F  S NUM=$O(INP(NUM)) Q:NUM=""  D
 .S VFSTR=$G(INP(NUM)) Q:VFSTR=""
 .S VCODE=$P(VFSTR,U)
 .I VCODE="N" D
 ..;S VALUE=0 F SUM=5:1:19 S VALUE=VALUE+$P($G(VFSTR),U,SUM) ;.19 TotalStrokeScale;
 ..S VALUE=0 F SUM=6:1:20 S VALUE=VALUE+$P($G(VFSTR),U,SUM) ;.19 TotalStrokeScale;  1.24.14
 ..S IEN=$P(VFSTR,U,2)
 ..S DEL=$P(VFSTR,U,5)
 ..Q:DEL="@"
 ..S QUALS=$P(VFSTR,U,22,99)
 ..S TYPE="NSST"
 ..I IEN="" D
 ...S VMIEN=$$STRNIH($G(VIEN),$G(TYPE),$G(VALUE))    ;New Item to add
 ...S IEN=9999999
 ...S IEN=$O(^AUPNVSTR(VFIEN,15,IEN),-1)
 ..E   D
 ...S VMIEN=$$GET1^DIQ(9000010.6315,IEN_","_VFIEN_",",.2,"I")  ;Get current value
 ...I VMIEN="" S VMIEN=$$STRNIH($G(VIEN),$G(TYPE),$G(VALUE))     ;Add if nothing there
 ...E  D
 ....S OLDVAL=$$GET1^DIQ(9000010.01,VMIEN,.04)
 ....I '$D(^AUPNVMSR(VMIEN)) S VMIEN=$$STRNIH($G(VIEN),$G(TYPE),$G(VALUE)) Q   ;add if non-existent measurement
 ....I $$GET1^DIQ(9000010.01,VMIEN,2,"I")=1 S VMIEN=$$STRNIH($G(VIEN),$G(TYPE),$G(VALUE))  ;Add if measurement is EIE
 ....I OLDVAL'=VALUE D STRDEL(VMIEN) S VMIEN=$$STRNIH($G(VIEN),$G(TYPE),$G(VALUE))  ;Delete old and add new if changed
 ..D HOOK(IEN,$G(VMIEN)) S RET=VMIEN
 Q RET
STRDEL(VMIEN) ;Do the delete
 N INP
 S INP=VMIEN_"^4"
 D SETEIE
 Q
STRNIH(VIEN,TYPE,VALUE) ;Store the NSST
 N NIHEV S NIHEV=$P(VFSTR,U,3) ;.02 NIH EventDateTime
 I NIHEV N Y S Y=NIHEV X ^DD("DD") S NIHEV=Y
 N EVDATE S EVDATE=$E($P(VFSTR,U,4),1,12)   ;Don't include seconds
 I EVDATE N Y S Y=EVDATE X ^DD("DD") S EVDATE=Y
 ; VMINP= Visit IEN [1] ^ V File IEN [2] ^ Type [3] ^ Value [4] ^ Date/Time [5]
 S VMIEN=""
 S VMINP=$G(VIEN)_U_$G(VMIEN)_U_$G(TYPE)_U_$G(VALUE)_U_$G(EVDATE)
 D SET^BGOVMSR(.RET,.VMINP)
 I RET'>0 S RET="-1^V Measurement NIH entry was not added" Q RET
 S VMIEN=RET
 S FDA=$NA(FDA(FNUM,VMIEN_","))
 S @FDA@(.07)=$S($G(NIHEV)]"":NIHEV,1:EVDATE) ;          [.07]  DATE/TIME VITALS ENTERED (D)
 S @FDA@(.08)="`"_DUZ ;                                  [.08]  ENTERED BY (P200')
 S @FDA@(1216)=$S($G(EVDATE)]"":EVDATE,1:"N") ;          [1216] DATE/TIME ENTERED (D)
 S @FDA@(1217)="`"_DUZ ;                                 [1217] ENTERED BY (P200')
 S @FDA@(1218)=$S($G(EVDATE)]"":EVDATE,1:"N") ;          [1218] DATE/TIME LAST MODIFIED (D)
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VMIEN) Q RET
 D:'RET VFEVT^BGOUTL2(FNUM,VMIEN,'$G(VFNEW))
 S:'RET RET=VMIEN
 ;Add in the Qualifier multiple, QUALS array = N array $P22, $P23, $P24, etc.
 F I=1:1 S QUAL=$P(QUALS,U,I) Q:QUAL=""  D
 .S QIEN="+"_I_","_VMIEN_","
 .N FDA,ERR,IEN2
 .S FDA(FNUM_5,QIEN,.01)=QUAL ;                     [5]    QUALIFIER (Multiple-9000010.015)
 .D UPDATE^DIE(,"FDA","IEN2","ERR")
 .I $G(ERR("DIERR",1)) S RET=-ERR("DIERR",1)_U_ERR("DIERR",1,"TEXT",1)
 Q RET
HOOK(IEN,VMIEN) ;Hook it back to the parent
 I +VMIEN D
 .N SIEN,FDA,ERR,IEN2
 .I DEL="@" S VMIEN="@"
 .S SIEN=IEN_","_VFIEN_","
 .S FDA(9000010.6315,SIEN,.2)=VMIEN
 .D UPDATE^DIE(,"FDA","IEN2","ERR")
 Q
 ; EIE V Measurement file entries for LKW or NSST
 ; VFIEN = V STROKE file ien VFIEN
 ; Flag the entry as Entered in Error
EIEVM(RET2,VFIEN) ;EP
 N VIEN,VMARR
 K VMARR
 S VIEN=$P($G(^AUPNVSTR(VFIEN,0)),"^",3)
 I $G(VIEN)="" S RET=0 Q
 D GETVM(VIEN)
 I RET=0 Q RET  ;  no VM entries for Visit IEN found
 N VMFIEN
 S VMFIEN=""
 F  S VMFIEN=$O(VMARR(VMFIEN)) Q:VMFIEN=""  D
 .N INP
 .S INP=VMFIEN_"^4" ;   Reason = 4 = INVALID RECORD (default)
 .D SETEIE
 Q
 ; Return V Measurement file entries for visit VIEN
 ;  Input = VIEN
 ;  Returns: 1/entries in VMARR array, 0/No entries found
 ;  Screen for TYPE = LKW or NSST entries
 ;  For NSST entries field match criteria:
 ;      [NIHDAT]   .02  EVENT DATE/TIME (D), [0;2]         =  [VITALDT] .07 DATE/TIME VITALS ENTERED (D), [0;7]
 ;      [NIHVALUE] .19  TOTAL STROKE SCORE (NJ2,0),[0;19]  =  [VALUE]   .04 VALUE (RFXO), [0;4]
GETVM(VIEN) ;
 N CNT,VMIEN,VALUE,VITALDT
 I 'VIEN S VMARR(1)=$$ERR^BGOUTL(1002) Q
 S (CNT,VMIEN,RET)=0
 F  S VMIEN=$O(^AUPNVMSR("AD",VIEN,VMIEN)) Q:'VMIEN  D
 .N X,USR,DAT,TYPE,TYPENM
 .S X=$G(^AUPNVMSR(VMIEN,0))
 .Q:X=""
 .S VALUE=$P(X,"^",4),VITALDT=$P($G(^AUPNVMSR(VMIEN,12)),"^",1)
 .S DAT=+$G(^(12)),USR=+$P($G(^(12)),U,4)
 .S TYPE=+X
 .S TYPENM=$P($G(^AUTTMSR(TYPE,0)),U)
 .Q:TYPENM=""
 .Q:TYPENM'="LKW"&(TYPENM'="NSST")  ;   only LKW and NSST records
 .N NAME
 .S NAME=$P($G(^VA(200,USR,0)),U)
 .S:'DAT DAT=+$G(^AUPNVSIT(VIEN,0))
 .I TYPENM="NSST" D
 ..N NIHDT,NIHREC
 ..S NIHDT=0
 ..F  S NIHDT=$O(^AUPNVSTR(VFIEN,15,"B",NIHDT)) Q:'NIHDT  D
 ...S NIHREC=0,NIHREC=$O(^AUPNVSTR(VFIEN,15,"B",NIHDT,NIHREC))
 ...N NIHNODE,NIHVALUE,NIHDAT
 ...S NIHNODE=$G(^AUPNVSTR(VFIEN,15,NIHREC,0)),NIHDAT=$E($P(NIHNODE,"^",2),1,12),NIHVALUE=$P(NIHNODE,"^",19)
 ...Q:NIHDAT'=VITALDT!(NIHVALUE'=VALUE)
 ...S VMARR(VMIEN)=TYPENM_U_DAT_U_$$ISLOCKED^BEHOENCX(VIEN) ;               NSST ENTRY
 .S:TYPENM="LKW" VMARR(VMIEN)=TYPENM_U_DAT_U_$$ISLOCKED^BEHOENCX(VIEN) ;    LKW  ENTRY
 .S CNT=CNT+1
 I $D(VMARR) S RET=1
 Q RET
 ; Update EIE for V Measurement file entry
SETEIE ;
 N FDA,REASON,VFIEN
 S VFIEN=$P(INP,U)
 S REASON=$P(INP,U,2)
 I REASON<0 I REASON>4 S RET="-1^Reason EIE out of range" Q  ; Input out of range
 I VFIEN="" S RET=$$ERR^BGOUTL(1008) Q  ; Missing input data
 I '$D(^AUPNVMSR(VFIEN)) S RET=$$ERR^BGOUTL(1035) Q  ; Item not found
 S FDA=$NA(FDA(9000010.01,VFIEN_","))
 S @FDA@(2)=1
 S @FDA@(3)=DUZ
 S RET=$$UPDATE^BGOUTL(.FDA,,VFIEN)
 N EIEN S EIEN="+1,"_VFIEN_","
 N FDA,ERR,IEN2
 ;S FDA($$FNUM_4,EIEN,.01)=REASON
 S FDA(9000010.014,EIEN,.01)=REASON
 D UPDATE^DIE(,"FDA","IEN2","ERR")
 I $G(ERR("DIERR",1)) S RET=-ERR("DIERR",1)_U_ERR("DIERR",1,"TEXT",1)
 S:RET="" RET=1
 Q
 ;Return V File #
FNUM(RET,INP) S RET=9000010.63
 Q RET
 ;
DMULT(RET,VFIEN,SUBIEN,NODE) ;  Delete a multiple entry from V file
 I $G(VFIEN)=""!($G(SUBIEN)="")!($G(NODE)="") S RET="-1^""missing delete multiple parameter""" Q RET
 N ERR,DA,DIK
 S ERR=""
 S RET=""
 S DA(1)=VFIEN,DA=+SUBIEN
 S DIK="^AUPNVSTR("_DA(1)_NODE
 S:DA ERR=$$DELETE^BGOUTL(DIK,.DA)
 I ERR'="" S RET=RET_"^"_ERR
 Q
