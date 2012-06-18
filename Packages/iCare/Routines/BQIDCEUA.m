BQIDCEUA ;PRXM/HC/ALA-Unanticipated Emergency Room Revisits ; 12 Dec 2005  1:07 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
VIS(DATA,PARMS,MPARMS) ;EP
 ;
 ;Description
 ;  Executable to retrieve unanticipated emergency room visits flags
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Output
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIDCEUA",UID))
 K @DATA
 ;
 NEW IEN,NM,FDT,TDT,VTYP,X,DIC,Y,ADDTM,VIEN,DFN,%DT,TMFRAME,ER
 S NM=""
 F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 ;
 I $G(TMFRAME)="" Q
 I TMFRAME["T-" D
 . S %DT="",X=TMFRAME D ^%DT S FDT=Y
 I $G(DT)="" D DT^DICRW
 S TDT=DT
 ;
 S VTYP=$$FIND1^DIC(9009083,"","Q","UNSCHEDULED REVISIT","B","","ERROR")
 I 'VTYP Q
 ;
 S ER=$$FIND1^DIC(40.7,"","Q","EMERGENCY","B","","ERROR")
 I 'ER Q
 ;
 ;  Check the ER Visit File
 S ADDTM=FDT
 F  S ADDTM=$O(^AMERVSIT("B",ADDTM)) Q:ADDTM=""!(ADDTM\1>TDT)  D
 . S IEN=""
 . F  S IEN=$O(^AMERVSIT("B",ADDTM,IEN)) Q:IEN=""  D
 .. I $$GET1^DIQ(9009080,IEN_",",.05,"I")'=VTYP Q
 .. S DFN=$$GET1^DIQ(9009080,IEN_",",.02,"I") I DFN="" Q
 .. ; Exclude deceased patients
 .. I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 .. ; If patient has no active HRNs, quit
 .. I '$$HRN^BQIUL1(DFN) Q
 .. ; If patient has no visit in last 3 years, quit
 .. ;I '$$VTHR^BQIUL1(DFN) Q
 .. S VIEN=$$GET1^DIQ(9009080,IEN_",",.03,"I")
 .. I VIEN="" Q
 .. I $$GET1^DIQ(9000010,VIEN,.11,"I")=1 Q
 .. I $$GET1^DIQ(9000010,VIEN,.08,"I")'=ER Q
 .. I $D(^BQIPAT(DFN,10,"AC",VIEN))>0 Q
 .. S @DATA@(DFN,IEN)=VIEN_U_$$GET1^DIQ(9000010,VIEN,.01,"I")
 ;
 Q
 ;  Check the ER Admission File
 S DFN=0
 F  S DFN=$O(^AMERADM(DFN)) Q:'DFN  D
 . S ADDTM=$$GET1^DIQ(9009081,DFN,1,"I")\1
 . I ADDTM<FDT Q
 . I $$GET1^DIQ(9009081,DFN,3,"I")'=VTYP Q
 . S @DATA@(DFN,DFN)=U_ADDTM
 Q
