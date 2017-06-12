BQIDCHSA ;PRXM/HC/BWF-Visits with Service Category of 'Hospitalization' ; 09 Dec 2005  3:15 PM
 ;;2.4;ICARE MANAGEMENT SYSTEM;**2**;Apr 01, 2015;Build 10
 ;
 Q
 ;
VIS(DATA,PARMS,MPARMS) ;EP
 ;
 ;Description
 ;  Retrieves inpatient hospitalizations for the specified parameters
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Output
 ;  ^TMP(UID,"BQIDCHSA",DFN,VISIT IEN)=""
 ;
 NEW UID,ADMDT,DSCDT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP(UID,"BQIDCHSA"))
 K @DATA
 ;
FND ;  Find if the patients have admission flag of "H" - Hospitalization
 ;
 NEW FDT,TDT,STRT,VSTIEN,DFN,NM,TMFRAME,X,Y,DIEN
 S NM=""
 F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 ;
 S TMFRAME=$G(PARMS("TMFRAME"))
 I $G(DT)="" D DT^DICRW
 I TMFRAME["T-" D
 . S FDT=$$DATE^BQIUL1(TMFRAME)
 S TDT=DT
 ;
 ; Order through B x-ref in Visit file. This xref is by visit date, and visit ien.
 S STRT=FDT-.01
 F  S STRT=$O(^AUPNVSIT("B",STRT)) Q:'STRT!(STRT>TDT)  D
 . S VSTIEN=""
 . F  S VSTIEN=$O(^AUPNVSIT("B",STRT,VSTIEN)) Q:VSTIEN=""  D
 .. I $P($G(^AUPNVSIT(VSTIEN,0)),"^",7)'="H" Q
 .. ; If visit has been deleted, quit
 .. ;I $$GET1^DIQ(9000010,VSTIEN,.11,"I")=1 Q
 .. I $P($G(^AUPNVSIT(VSTIEN,0)),"^",11)=1 Q
 .. I $P($G(^AUPNVSIT(VSTIEN,0)),"^",9)=1 Q
 .. ;S ADMDT=$$GET1^DIQ(9000010,VSTIEN,.01,"I")
 .. S ADMDT=$P($G(^AUPNVSIT(VSTIEN,0)),"^",1)
 .. S DIEN=0,DSCDT=""
 .. F  S DIEN=$O(^AUPNVINP("AD",VSTIEN,DIEN)) Q:DIEN=""  D
 ... S DSCDT=$P($G(^AUPNVINP(DIEN,0)),"^",1)
 .. I (ADMDT\1)=(DSCDT\1) Q
 .. ;S DFN=$$GET1^DIQ(9000010,VSTIEN,.05,"I") Q:DFN=""
 .. S DFN=$P($G(^AUPNVSIT(VSTIEN,0)),"^",5) I DFN="" Q
 .. ; Exclude deceased patients
 .. I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 .. ; If patient has no active HRNs, quit
 .. I '$$HRN^BQIUL1(DFN) Q
 .. ; If patient has no visit in last 3 years, quit
 .. I '$$VTHR^BQIUL1(DFN) Q
 .. ;S @DATA@(DFN,VSTIEN)=VSTIEN_U_$$GET1^DIQ(9000010,VSTIEN,.01,"I")
 .. S @DATA@(DFN,VSTIEN)=VSTIEN_U_$P($G(^AUPNVSIT(VSTIEN,0)),"^",1)
 Q
