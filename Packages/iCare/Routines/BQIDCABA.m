BQIDCABA ;PRXM/HC/ALA-Abnormal Lab Results ; 12 Dec 2005  1:07 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
VIS(DATA,PARMS,MPARMS) ;EP
 ;
 ;Description
 ;  Executable that determines abnormal lab flags for the specified parameters
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Parameters
 ;  TMFRAME = Relative time frame
 ;  FDT = Starting date for the time frame
 ;  TDT = Ending date for the time frame
 ;  IEN = Lab record internal entry number
 ;  VIEN = Visit record internal entry number
 ;  ABNFL = Abnormal lab result
 ;Output
 ;  All records found will be put into ^TMP by patient and visit internal entry
 ;  numbers.  The patient will be checked against the patients found in all the
 ;  panels and added to the ICARE PATIENT INDEX file.
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIDCABA",UID))
 K @DATA
 ;
 NEW IEN,NM,FDT,TDT,VTYP,X,DIC,Y,RSTM,VIEN,DFN,%DT,TMFRAME,ABNFL
 S NM=""
 F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 ;
 I $G(TMFRAME)="" S TMFRAME="T-6M"
 I TMFRAME["T-" D
 . S %DT="",X=TMFRAME D ^%DT S FDT=Y
 I $G(DT)="" D DT^DICRW
 S TDT=DT
 ;
 ;  Go through the V LAB file for the designated time frame to find any
 ;  abnormal lab results
 S RSTM=FDT
 F  S RSTM=$O(^AUPNVLAB("ARDT",RSTM)) Q:RSTM=""!(RSTM\1>TDT)  D
 . S IEN=""
 . F  S IEN=$O(^AUPNVLAB("ARDT",RSTM,IEN)) Q:IEN=""  D
 .. S DFN=$$GET1^DIQ(9000010.09,IEN_",",.02,"I") I DFN="" Q
 .. S VIEN=$$GET1^DIQ(9000010.09,IEN_",",.03,"I") Q:VIEN=""
 .. I $$GET1^DIQ(9000010,VIEN_",",.11,"I")=1 Q
 .. S ABNFL=$$GET1^DIQ(9000010.09,IEN_",",.05,"E")
 .. Q:ABNFL=""
 .. S @DATA@(DFN,IEN)=VIEN_U_$$GET1^DIQ(9000010,VIEN,.01,"I")
 Q
