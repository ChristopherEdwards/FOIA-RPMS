BEDDUTIU ;VNGT/HS/BEE-BEDD Utility Routine 3 ; 08 Nov 2011  12:00 PM
 ;;1.0;BEDD DASHBOARD;;Dec 17, 2012;Build 31
 ;
 Q
 ;
ICAU(ICAU) ;EP - Return List of Injury Causes
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; ICAU Array - List of Injury Causes
 ;
 NEW CIEN,CTIEN,CNT
 K ICAU
 S CTIEN=$O(^AMER(2,"B","CAUSE OF INJURY","")) Q:CTIEN=""
 S CNT=0,CIEN="" F  S CIEN=$O(^AMER(3,"AC",CTIEN,CIEN)) Q:+CIEN=0  D
 . S CNT=CNT+1
 . S ICAU(CNT)=CIEN_"^"_$$GET1^DIQ(9009083,CIEN_",",".01","I")
 Q
 ;
SCEN(SCEN) ;EP - Return List of Injury Setting
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; SCEN Array - List of Injury Settings
 ;
 NEW SIEN,STIEN,CNT
 K SCEN
 S STIEN=$O(^AMER(2,"B","SCENE OF INJURY","")) Q:STIEN=""
 S CNT=0,SIEN="" F  S SIEN=$O(^AMER(3,"AC",STIEN,SIEN)) Q:+SIEN=0  D
 . S CNT=CNT+1
 . S SCEN(CNT)=SIEN_"^"_$$GET1^DIQ(9009083,SIEN_",",".01","I")
 Q
 ;
SAFE(SAFE) ;EP - Return List of Safety Measures
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; SAFE Array - List of Safety Measures
 ;
 NEW SIEN,STIEN,CNT
 K SAFE
 S STIEN=$O(^AMER(2,"B","SAFETY EQUIPMENT","")) Q:STIEN=""
 S CNT=0,SIEN="" F  S SIEN=$O(^AMER(3,"AC",STIEN,SIEN)) Q:+SIEN=0  D
 . S CNT=CNT+1
 . S SAFE(CNT)=SIEN_"^"_$$GET1^DIQ(9009083,SIEN_",",".01","I")
 Q
 ;
CONS(CONS) ;EP - Return List of Consult Types
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; CONS Array - List of Consult Types
 ;
 NEW CIEN,CTTYP,CNT
 K CONS
 S CNT=0,CTTYP="" F  S CTTYP=$O(^AMER(2.9,"B",CTTYP)) Q:CTTYP=""  D
 . S CIEN="" F  S CIEN=$O(^AMER(2.9,"B",CTTYP,CIEN)) Q:CIEN=""  D
 .. S CNT=CNT+1
 .. S CONS(CNT)=CIEN_"^"_CTTYP
 Q
 ;
PROC(PROC) ;EP - Return List of ER Procedures
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; PROC Array - List of ER Procedures
 ;
 NEW PIEN,PCIEN,CNT,PRC
 K PROC
 S PCIEN=$O(^AMER(2,"B","ER PROCEDURES","")) Q:PCIEN=""
 S PIEN="" F  S PIEN=$O(^AMER(3,"AC",PCIEN,PIEN)) Q:+PIEN=0  D
 . S PRC=$$GET1^DIQ(9009083,PIEN_",",".01","I") Q:PRC=""
 . S PRC(PRC)=PIEN_"^"_PRC
 ;
 S CNT=0,PRC="" F  S PRC=$O(PRC(PRC)) Q:PRC=""  D
 . S CNT=CNT+1
 . S PROC(CNT)=PRC(PRC)
 Q
 ;
VTYP(VTYP) ;EP - Return List of ER Visit Types
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; VTYP Array - List of ER Visit Types
 ;
 NEW VIEN,VTIEN,CNT,VTY
 K VTYP
 S VTIEN=$O(^AMER(2,"B","VISIT TYPE","")) Q:VTIEN=""
 S VIEN="" F  S VIEN=$O(^AMER(3,"AC",VTIEN,VIEN)) Q:+VIEN=0  D
 . S VTY=$$GET1^DIQ(9009083,VIEN_",",".01","I") Q:VTY=""
 . S VTY(VTY)=VIEN_"^"_VTY
 ;
 S CNT=0,VTY="" F  S VTY=$O(VTY(VTY)) Q:VTY=""  D
 . S CNT=CNT+1
 . S VTYP(CNT)=VTY(VTY)
 Q
 ;
TFRM(TFRM) ;EP - Return List of Transfer From Values
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; TFRM Array - List of Transfer From Values
 ;
 NEW TIEN,CNT,TFR,TFIEN
 K TFRM
 S CNT=0,TFIEN="" F  S TFIEN=$O(^AMER(2.1,"B",TFIEN)) Q:TFIEN=""  D
 . S TIEN="" F  S TIEN=$O(^AMER(2.1,"B",TFIEN,TIEN)) Q:+TIEN=0  D
 .. S CNT=CNT+1,TFRM(CNT)=TIEN_"^"_TFIEN
 Q
 ;
 ;
MTRN(MTRN) ;EP - Return Mode of Transport List
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; MTRN Array - List of Mode of Transport Entries
 ;
 NEW MIEN,MTIEN,CNT,MTR
 K MTRN
 S MTIEN=$O(^AMER(2,"B","TRANSFER DETAILS","")) Q:MTIEN=""
 S MIEN="" F  S MIEN=$O(^AMER(3,"AC",MTIEN,MIEN)) Q:+MIEN=0  D
 . S MTR=$$GET1^DIQ(9009083,MIEN_",",".01","I") Q:MTR=""
 . S MTR(MTR)=MIEN_"^"_MTR
 ;
 S CNT=0,MTR="" F  S MTR=$O(MTR(MTR)) Q:MTR=""  D
 . S CNT=CNT+1
 . S MTRN(CNT)=MTR(MTR)
 Q
 ;
ACMP(ACMP) ;EP - Return Ambulance Company Name List
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; ACMP Array - List of Ambulance Company Names
 ;
 NEW AIEN,ACIEN,CNT,ACN
 K ACMP
 S ACIEN=$O(^AMER(2,"B","AMBULANCE COMPANY","")) Q:ACIEN=""
 S AIEN="" F  S AIEN=$O(^AMER(3,"AC",ACIEN,AIEN)) Q:+AIEN=0  D
 . S ACN=$$GET1^DIQ(9009083,AIEN_",",".01","I") Q:ACN=""
 . S ACN(ACN)=AIEN_"^"_ACN
 ;
 S CNT=0,ACN="" F  S ACN=$O(ACN(ACN)) Q:ACN=""  D
 . S CNT=CNT+1
 . S ACMP(CNT)=ACN(ACN)
 Q
 ;
DEVLST(DEVICE) ;EP - Return List of Devices
 ;
 K DEVICE
 ;
 D DEVICE^CIAVUTIO(.DEVICE,"",1,"500")
 ;
 Q
 ;
ADMDTM(DFN) ;EP - Return Current Admission Date/Time
 Q $$FMTE^BEDDUTIL($$GET1^DIQ(9009081,DFN_",",1,"I"))
 ;
ADMCMP(DFN) ;EP - Return Presenting Complaint
 Q $$GET1^DIQ(9009081,DFN_",",8,"I")
 ;
ADMVTP(DFN) ;EP - Return Admission Visit Type
 Q $$GET1^DIQ(9009081,DFN_",",3,"I")
 ;
ADMTRN(DFN) ;EP - Return Admission Transferred
 Q $$GET1^DIQ(9009081,DFN_",",2.1,"I")
 ;
ADMFTRN(DFN) ;EP - Return Admission Transferred From
 Q $$GET1^DIQ(9009081,DFN_",",2.2,"I")
 ;
ADMMOT(DFN) ;EP - Return Admission Mode of Transport
 Q $$GET1^DIQ(9009081,DFN_",",2.3,"I")
 ;
ADMMAT(DFN) ;EP - Return Admission Medical Attendant Present
 Q $$GET1^DIQ(9009081,DFN_",",2.4,"I")
 ;
ADMAMN(DFN) ;EP - Return Admission Ambulance Number
 Q $$GET1^DIQ(9009081,DFN_",",12,"I")
 ;
ADMAMB(DFN) ;EP - Return Admission Ambulance Billing
 Q $$GET1^DIQ(9009081,DFN_",",13,"I")
 ;
ADMAMC(DFN) ;EP - Return Admission Ambulance Company
 Q $$GET1^DIQ(9009081,DFN_",",15,"I")
 ;
ADMCHK(DFN) ;EP - Determine if patient is already admitted
 ;
 I $G(DFN)="" Q ""
 I $D(^AMERADM("B",DFN)) Q 1
 Q ""
 ;
CLIN(CLIN) ;EP - Return Clinic ^AMER(3) ien
 ;
 ;Convert clinic file 40.7 pointer to ^AMER(3) pointer
 I CLIN="" Q ""
 ;
 S CLIN=$$GET1^DIQ(40.7,CLIN_",",1,"I") Q:CLIN="" ""
 ;
 S CLIN=$O(^AMER(3,"B",CLIN,""))
 Q CLIN
 ;
PRV(VIEN,AMERDA,PRMNRS) ;EP - Log ER VISIT Provider entries in V PROVIDER
 ;
 I $G(VIEN)="" Q
 I $G(AMERDA)="" Q
 ;
 S PRMNRS=$G(PRMNRS,"")
 ;
 NEW VPROV,PIEN,PRV,PS,PDT
 ;
 ;Get a list of current providers for visit
 I $D(^AUPNVPRV("AD",VIEN)) D
 . ;
 . ;Get list of existing entries
 . S PIEN="" F  S PIEN=$O(^AUPNVPRV("AD",VIEN,PIEN)) Q:+PIEN=0  S VPROV($P(^AUPNVPRV(PIEN,0),"^",1))=""
 ;
 ;Retrieve Patient
 S DFN=$$GET1^DIQ(9009080,AMERDA_",",".02","I")
 ;
 ;Discharge Provider
 S PRV=$$GET1^DIQ(9009080,AMERDA_",","6.3","I")
 S PDT=$$GET1^DIQ(9009080,AMERDA_",","6.2","I")
 S PS="P"
 I PRV]"",'$D(VPROV(PRV)) D SPRV(DFN,VIEN,PRV,PDT,PS) S VPROV(PRV)=""
 ;
 ;Admitting Provider
 S PRV=$$GET1^DIQ(9009080,AMERDA_",",".06","I")
 S PDT=$$GET1^DIQ(9009080,AMERDA_",","12.1","I")
 S PS="S"
 I PRV]"",'$D(VPROV(PRV)) D SPRV(DFN,VIEN,PRV,PDT,PS) S VPROV(PRV)=""
 ;
 ;Triage Nurse
 S PRV=$$GET1^DIQ(9009080,AMERDA_",",".07","I")
 S PDT=$$GET1^DIQ(9009080,AMERDA_",","12.2","I")
 S PS="S"
 I PRV]"",'$D(VPROV(PRV)) D SPRV(DFN,VIEN,PRV,PDT,PS) S VPROV(PRV)=""
 ;
 ;Discharge Nurse
 S PRV=$$GET1^DIQ(9009080,AMERDA_",","6.4","I")
 S PDT=$$GET1^DIQ(9009080,AMERDA_",","6.2","I")
 S PS="S"
 I PRV]"",'$D(VPROV(PRV)) D SPRV(DFN,VIEN,PRV,PDT,PS) S VPROV(PRV)=""
 ;
 ;Primary Nurse
 S PRV=PRMNRS
 S PDT=$$GET1^DIQ(9009080,AMERDA_",","6.2","I")
 S PS="S"
 I PRV]"",'$D(VPROV(PRV)) D SPRV(DFN,VIEN,PRV,PDT,PS) S VPROV(PRV)=""
 ;
 Q
 ;
PRPOV(VIEN,AMERDA,PRPOV) ;EP - Log ER Procedure providers entries in V PROVIDER
 ;
 I $G(VIEN)="" Q
 I $G(AMERDA)="" Q
 ;
 NEW VPROV,PIEN,PRV,PS,PDT
 ;
 ;Get a list of current providers for visit
 I $D(^AUPNVPRV("AD",VIEN)) D
 . ;
 . ;Get list of existing entries
 . S PIEN="" F  S PIEN=$O(^AUPNVPRV("AD",VIEN,PIEN)) Q:+PIEN=0  S VPROV($P(^AUPNVPRV(PIEN,0),"^",1))=""
 ;
 ;Retrieve Patient
 S DFN=$$GET1^DIQ(9009080,AMERDA_",",".02","I")
 ;
 S PRV="" F  S PRV=$O(PRPOV(PRV)) Q:PRV=""  D
 . ;
 . ;First Try Proc Beg Dt/Tm
 . S PDT=$P(PRPOV(PRV),U)_","_$P(PRPOV(PRV),U,2)
 . ;
 . ;Then Try Proc End Dt/Tm
 . I $TR(PDT,",")="" S PDT=$P(PRPOV(PRV),U,3)_","_$P(PRPOV(PRV),U,4)
 . I $TR(PDT,",")]"" S PDT=$$HTFM^XLFDT(PDT)
 . ;
 . ;Then Try Admit Dt/Tm
 . I $TR(PDT,",")="" S PDT=$$GET1^DIQ(9009080,AMERDA_",",".01","I")
 . ;
 . S PS="S"
 . ;
 . ;See if already logged
 . I PRV]"",'$D(VPROV(PRV)) D SPRV(DFN,VIEN,PRV,PDT,PS) S VPROV(PRV)=""
 Q
 ;
SPRV(DFN,VIEN,PRV,VDT,PS) ;EP - Log the Provider in V PROVIDER
 ;
 NEW DIC,DD,DO,DINUM,X,Y
 K DD,DO,DINUM
 S DIC="^AUPNVPRV(" S DIC(0)="XML" S X=PRV
 S DIC("DR")=".02////"_DFN_";.03////"_VIEN_";.04////"_PS_";1201////"_VDT
 D FILE^DICN
 K DD,DO,DINUM
 ;
 Q
 ;
POV(VIEN,AMERDA) ;EP - Log ER VISIT Provider entries in V POV
 ;
 I $G(VIEN)="" Q
 I $G(AMERDA)="" Q
 ;
 NEW VPOV,PIEN,POV,PS,DIEN
 ;
 ;Get a list of current providers for visit
 I $D(^AUPNVPOV("AD",VIEN)) D
 . ;
 . ;Get list of existing entries
 . S PIEN="" F  S PIEN=$O(^AUPNVPOV("AD",VIEN,PIEN)) Q:+PIEN=0  S VPOV($P(^AUPNVPOV(PIEN,0),"^",1))=""
 ;
 ;Retrieve Patient
 S DFN=$$GET1^DIQ(9009080,AMERDA_",",".02","I")
 ;
 ;Pull Prime DX Info
 S POV=$$GET1^DIQ(9009080,AMERDA_",","5.2","I")
 S PNAR=$$GET1^DIQ(9009080,AMERDA_",","5.3","I")
 S:PNAR="" PNAR=$$GET1^DIQ(80,POV_",",".01","E")
 S VDT=$$GET1^DIQ(9009080,AMERDA_",",".01","I")
 I POV]"",'$D(VPOV(POV)) D SPOV(DFN,VIEN,POV,PNAR,VDT,"P") S VPOV(POV)=""
 ;
 ;Now loop through list and process remaining DX's
 S DIEN=0 F  S DIEN=$O(^AMERVSIT(AMERDA,5,DIEN)) Q:'DIEN  D
 . ;
 . NEW DA,IENS,POV,PNAR
 . S DA(1)=AMERDA,DA=DIEN,IENS=$$IENS^DILF(.DA)
 . S POV=$$GET1^DIQ(9009080.05,IENS,".01","I") Q:POV=""
 . Q:$D(VPOV(POV))
 . S PNAR=$$GET1^DIQ(9009080.05,IENS,"1","I")
 . D SPOV(DFN,VIEN,POV,PNAR,VDT,"S") S VPOV(POV)=""
 ;
 Q
 ;
SPOV(DFN,VIEN,POV,PNAR,VDT,PS) ;EP - Log the Provider in V PROVIDER
 ;
 NEW DIC,DD,DO,DINUM,X,Y,NIEN
 ;
 ;First Log Narrative Entry
 S NIEN=$$NARR(PNAR)
 ;
 K DD,DO,DINUM
 S DIC="^AUPNVPOV(" S DIC(0)="XML" S X=POV
 S DIC("DR")=".02////"_DFN_";.03////"_VIEN_";.04////"_NIEN_";.12////"_PS_";1201////"_VDT
 ;
 D FILE^DICN
 K DD,DO,DINUM
 ;
 Q
 ;
NARR(NAR) ;EP - Get Provider Narrative IEN
 ;
 ;RETURN THE IEN OF A PROVIDER NARRATIVE ENTRY - IF NECESSARY CREAT THE ENTRY
 ;
 I $G(NAR)="" Q ""
 ;
 NEW DIC,DLAYGO,X,Y
 S X=NAR
 S (DIC,DLAYGO)=9999999.27,DIC(0)="LX"
 D ^DIC I Y=-1 Q ""
 Q +Y
 ;
DTCMP(DATE,ADJ) ;EP - Add or subtract days from supplied date
 ;
 ;Input:
 ; DATE (Optional) - Date to add or subtract from (if blank DT is used)
 ;  ADJ - Number of days to add or subtract
 ;
 NEW X1,X2,X,%H
 ;
 S DATE=$G(DATE,"") S:DATE="" DATE=$$DT^XLFDT
 S ADJ=+$G(ADJ)
 S X1=DATE,X2=ADJ D C^%DTC
 Q X
 ;
DTCHK(DATE,ADMDT,CHK,BGDT) ;EP - Date checking function
 ;
 ;Input:
 ; DATE - Date to be checked
 ; ADMDT (Optional) - The admit date to check against
 ; CHK - The type of checks to perform
 ;       "F" - No future dates
 ;       "A" - Must be after admit date
 ;       "P" - Must be prior to admit date
 ;       "B" - Check to make sure DATE is after BGDT
 ; BGDT (Optional) - The beginning date to check against
 ;
 NEW CDT
 ;
 S DATE=$G(DATE,"") I DATE="" Q "DATE"
 S ADMDT=$G(ADMDT,"")
 S BGDT=$G(BGDT,"")
 S CHK=$G(CHK,"") I CHK="" Q "DATE"
 ;
 S DATE=$$DATE^BEDDUTIU(DATE)
 S ADMDT=$$DATE^BEDDUTIU(ADMDT)
 S BGDT=$$DATE^BEDDUTIU(BGDT)
 ;
 ;Get current date time
 S CDT=$$FNOW^BEDDUTIL()
 ;
 ;Future date check
 I CHK["F",DATE>CDT Q "F"
 ;
 ;Admit date check
 I CHK["A",ADMDT>0,ADMDT>DATE Q "A"
 ;
 I CHK["P",ADMDT>0,DATE>ADMDT Q "P"
 ;
 I CHK["B",BGDT>0,BGDT>DATE Q "B"
 ;
 Q "DATE"
 ;
DATE(X)  ;EP - Convert External Date to FileMan
 ;
 NEW %DT,Y
 ;
 S X=$TR(X," ","@")
 S %DT="T" D ^%DT
 S:Y=-1 Y=""
 ;
 Q Y
 ;
ASAVE(DUZ,ADM) ;EP - Admit a Patient to the ER
 ;Not Implemented
 Q 1
 ;;
 ;;Input:
 ;; DUZ - User DUZ
 ;; ADM Array - Array containing Admission Information
 ;;
 ;Set up complete DUZ
 ;D DUZ^XUP(DUZ)
 ;;
 ;NEW AMERVER,AMERSVER,DFN,DOB,AMERDFN,SAVE
 ;;
 ;S AMERVER=$$VERSION^XPDUTL("AMER")
 ;S AMERSVER=$$VERSION^XPDUTL("PIMS")
 ;;
 ;Reset Admission Scratch Global
 ;K ^TMP("AMER",$J)
 ;;
 ;DFN
 ;S (AMERDFN,DFN)=$G(ADM("DFN"))
 ;S ^TMP("AMER",$J,1,1)=$G(ADM("DFN"))
 ;;
 ;DOB
 ;S DOB=$$GET1^DIQ(2,DFN_",",.03,"I")
 ;;
 ;Admission Date/Time
 ;S ^TMP("AMER",$J,1,2)=$G(ADM("ADMDTTM"))
 ;;
 ;Presenting Complaint
 ;S ^TMP("AMER",$J,1,3)=$G(ADM("COMP"))
 ;;
 ;Visit Type
 ;I $G(ADM("VTYPE"))]"" D
 ;. NEW VTYPE
 ;. S VTYPE=$$GET1^DIQ(9009083,ADM("VTYPE")_",",.01,"I")
 ;. S ^TMP("AMER",$J,1,5)=ADM("VTYPE")_"^"_VTYPE
 ;;
 ;;Transfered
 ;I $G(ADM("TRAN"))]"" S ^TMP("AMER",$J,1,6)=ADM("TRAN")
 ;;
 ;;Transfer From
 ;I $G(ADM("TFROM"))]"" D
 ;. NEW TFROM
 ;. S TFROM=$$GET1^DIQ(9009082.1,ADM("TFROM")_",",.01,"I")
 ;. S ^TMP("AMER",$J,1,7)=ADM("TFROM")_"^"_TFROM
 ;;
 ;;Medical Attendant Present
 ;I $G(ADM("MATT"))]"" S ^TMP("AMER",$J,1,9)=ADM("MATT")
 ;;
 ;;Mode of Transport
 ;I $G(ADM("MTRAN"))]"" D
 ;. NEW MTRAN
 ;. S MTRAN=$$GET1^DIQ(9009083,ADM("MTRAN")_",",.01,"I")
 ;. S ^TMP("AMER",$J,1,10)=ADM("MTRAN")_"^"_MTRAN
 ;;
 ;;Ambulance Number
 ;S ^TMP("AMER",$J,1,11)=$G(ADM("ANUM"))
 ;;
 ;;Ambulance Billing
 ;S ^TMP("AMER",$J,1,12)=$G(ADM("ABILL"))
 ;;
 ;;Ambulance Company
 ;I $G(ADM("ACMP"))]"" D
 ;. NEW ACMP
 ;. S ACMP=$$GET1^DIQ(9009083,ADM("ACMP")_",",.01,"I")
 ;. S ^TMP("AMER",$J,1,14)=ADM("ACMP")_"^"_ACMP
 ;;
 ;;Complete Admission
 ;;S SAVE=$$ADMIT^AMERBEDD(DFN)
 ;;
 Q 1
 ;
ERR ;EP - Capture the error
 D ^%ZTER
 Q
