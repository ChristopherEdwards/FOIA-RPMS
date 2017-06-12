BQIDCERA ;PRXM/HC/ALA-Emergency Room Visits ; 09 Dec 2005  3:15 PM
 ;;2.4;ICARE MANAGEMENT SYSTEM;**2**;Apr 01, 2015;Build 10
 ;
 Q
 ;
VIS(DATA,PARMS,MPARMS) ;EP
 ;
 ;Description
 ;  Executable to retrieve ER visits for the specified parameters
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Output
 ;  ^TMP(UID,"BQIDCERA",DFN,VISIT IEN)=""
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP(UID,"BQIDCERA"))
 K @DATA
 ;
FND ;  Find if the patients have emergency room visits
 ;
 NEW FDT,TDT,STRT,VSTIEN,DFN,NM,TMFRAME,X,Y,%DT,ER
 S NM=""
 F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 ;
 S TMFRAME=$G(PARMS("TMFRAME"))
 I $G(DT)="" D DT^DICRW
 I TMFRAME["T-" D
 . S %DT="",X=TMFRAME D ^%DT S FDT=Y
 S TDT=DT
 ;
 ;S ER=$$FIND1^DIC(40.7,"","Q","EMERGENCY","B","","ERROR")
 S ER=$O(^DIC(40.7,"B","EMERGENCY MEDICINE",""))
 I ER="" Q
 ;I 'ER Q
 ;
 ; Order through visit date/time x-ref in Visit file.
 S STRT=FDT-.01
 F  S STRT=$O(^AUPNVSIT("B",STRT)) Q:'STRT!(STRT>TDT)  D
 . S VSTIEN=""
 . F  S VSTIEN=$O(^AUPNVSIT("B",STRT,VSTIEN)) Q:VSTIEN=""  D
 .. ; If the clinic code is not 30 (Emergency), quit
 .. ;I $$GET1^DIQ(9000010,VSTIEN,.08,"I")'=ER Q
 .. I $P($G(^AUPNVSIT(VSTIEN,0)),"^",8)'=ER Q
 .. ; If the visit has been "deleted", quit
 .. ;I $$GET1^DIQ(9000010,VSTIEN,.11,"I")=1 Q
 .. I $P($G(^AUPNVSIT(VSTIEN,0)),"^",11)=1 Q
 .. I $P($G(^AUPNVSIT(VSTIEN,0)),"^",9)=1 Q
 .. ;S DFN=$$GET1^DIQ(9000010,VSTIEN,.05,"I") I DFN="" Q
 .. S DFN=$P($G(^AUPNVSIT(VSTIEN,0)),"^",5) I DFN="" Q
 .. ; Exclude deceased patients
 .. I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 .. ; If patient has no active HRNs, quit
 .. I '$$HRN^BQIUL1(DFN) Q
 .. ; If patient has no visit in last 3 years, quit
 .. I '$$VTHR^BQIUL1(DFN) Q
 .. ; If the visit is already flagged, quit
 .. I $D(^BQIPAT(DFN,10,"AC",VSTIEN))>0 Q
 .. ;S @DATA@(DFN,VSTIEN)=VSTIEN_U_$$GET1^DIQ(9000010,VSTIEN,.01,"I")
 .. S @DATA@(DFN,VSTIEN)=VSTIEN_U_$P($G(^AUPNVSIT(VSTIEN,0)),"^",1)
 Q
