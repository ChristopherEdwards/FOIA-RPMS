AMERPOV ;GDIT/HS/BEE - SYNCHRONIZE AMER WITH PCC ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**6**;MAR 03, 2009;Build 30
 ;
 Q
 ;
SYNC ;PEP - Sync AMER with PCC
 ;
 ;This API is called by the following:
 ; *MOD^AUPNVSIT has an XBNEW call to this API
 ;
 ;Predefined variable:
 ; AUPNVSIT - Visit IEN
 ;
 NEW AMERVSIT,DFN,RET,ICAUSE,IDT,ILOC,FND,SOI,ACAUSE,PCNT,ADT,AMERPOV,STS
 ;
 ;Input variable: 
 ;Make sure PCC visit is valid
 I $G(AUPNVSIT)="" Q  ;Missing visit
 I '$D(^AUPNVSIT(AUPNVSIT)) Q  ;Invalid visit
 S AMERVSIT=$O(^AMERVSIT("AD",AUPNVSIT,""))
 I AMERVSIT="" Q
 ;
 ;Get DFN
 S DFN=$$GET1^DIQ(9000010,AUPNVSIT,.05,"I") Q:DFN=""
 ;
 ;Synchronize the AMERVSIT POVs with V POV
 D SYNCHERX^AMERERS(AMERVSIT,AUPNVSIT)
 ;
 ;Synchronize the injury information
 ;
 ;Get list of V POV entries
 S STS=$$POV^AMERUTIL("",AUPNVSIT,.AMERPOV)
 ;
 ;Get Scene of Injury code
 S SOI=$O(^AMER(2,"B","SCENE OF INJURY","")) Q:SOI=""
 ;
 ;Loop through list and find injury - take Primary POV injury as first choice
 S (ICAUSE,IDT,ILOC,FND)=""
 S PCNT="" F  S PCNT=$O(AMERPOV(PCNT)) Q:PCNT=""  D  Q:FND
 . NEW PS,IC,ID,IL,PVIEN
 . ;
 . ;Get whether primary or secondary, quit if not primary and we have injury info
 . S PS=$P(AMERPOV(PCNT),U,2) I ICAUSE]"",PS'="P" Q
 . ;
 . ;Pull injury information from V POV
 . S PVIEN=$P(AMERPOV(PCNT),U,6) Q:PVIEN=""
 . ;
 . ;Injury Cause
 . S IC=$$GET1^DIQ(9000010.07,PVIEN_",",.09,"I") Q:IC=""
 . ;
 . ;Injury Date
 . S ID=$$GET1^DIQ(9000010.07,PVIEN_",",.13,"I")
 . ;
 . ;Convert from PCC to AMER values
 . S IL=$$GET1^DIQ(9000010.07,PVIEN_",",.11,"I")
 . I (IL="A")!(IL="B") S CVIL=$$SCENE("HOME",SOI)
 . I (IL="C") S CVIL=$$SCENE("RANCH OR FARM",SOI)
 . I (IL="E") S CVIL=$$SCENE("INDUSTRIAL PLACE",SOI)
 . I (IL="F") S CVIL=$$SCENE("RECREATIONAL/SPORT PLACE",SOI)
 . I (IL="G") S CVIL=$$SCENE("HIGHWAY OR ROAD",SOI)
 . I (IL="H") S CVIL=$$SCENE("PUBLIC BUILDING",SOI)
 . I (IL="I") S CVIL=$$SCENE("RESIDENTIAL INSTITUTION",SOI)
 . I (IL="K") S CVIL=$$SCENE("OTHER",SOI)
 . S:$G(CVIL)="" CVIL=$$SCENE("UNSPECIFIED",SOI)
 . S ICAUSE=IC,IDT=ID,ILOC=CVIL
 ;
 ;If there is an injury make sure it needs saved
 ;
 ;Get the current injury cause from AMER
 S ACAUSE=$$GET1^DIQ(9009080,AMERVSIT_",",3.2,"I")
 ;
 ;Get the current injury date/time from AMER
 S ADT=$$GET1^DIQ(9009080,AMERVSIT_",",3.4,"I")
 ;
 ;IF AMER and PCC causes do not agree clear out AMER as the injuries do not match
 I ACAUSE]"",ICAUSE'=ACAUSE D
 . NEW AMUPD,ERROR
 . S AMUPD(9009080,AMERVSIT_",",3.2)="@"
 . S AMUPD(9009080,AMERVSIT_",",3.1)="0"
 . S AMUPD(9009080,AMERVSIT_",",3.3)="@"
 . S AMUPD(9009080,AMERVSIT_",",3.4)="@"
 . S AMUPD(9009080,AMERVSIT_",",3.5)="@"
 . S AMUPD(9009080,AMERVSIT_",",3.6)="@"
 . S AMUPD(9009080,AMERVSIT_",",3.6)="@"
 . S AMUPD(9009080,AMERVSIT_",",13.1)="@"
 . S AMUPD(9009080,AMERVSIT_",",13.2)="@"
 . S AMUPD(9009080,AMERVSIT_",",13.3)="@"
 . S AMUPD(9009080,AMERVSIT_",",13.4)="@"
 . S AMUPD(9009080,AMERVSIT_",",13.5)="@"
 . S AMUPD(9009080,AMERVSIT_",",13.6)="@"
 . D FILE^DIE("","AMUPD","ERROR")
 ;
 ;Now save the new values, if a change
 D
 . NEW AMUPD,ERROR
 . S AMUPD(9009080,AMERVSIT_",",3.2)=$S(ICAUSE="":"@",1:ICAUSE)
 . S AMUPD(9009080,AMERVSIT_",",3.1)=$S(ICAUSE="":"0",1:1)
 . S AMUPD(9009080,AMERVSIT_",",3.3)=$S(ICAUSE="":"@",1:ILOC)
 . ;
 . ;Only update the injury date if the date is different. This will preserve
 . ;the injury time if entered in AMER
 . I $P(ADT,".")'=$P(IDT,".") D
 .. S AMUPD(9009080,AMERVSIT_",",3.4)=$S(IDT="":"@",1:IDT)
 . ;
 . I ICAUSE="" S AMUPD(9009080,AMERVSIT_",",3.5)="@"
 . I ICAUSE="" S AMUPD(9009080,AMERVSIT_",",3.6)="@"
 . D FILE^DIE("","AMUPD","ERROR")
 ;
 ;Update the decision to admit date
 D
 . NEW DECDT,AMUPD,ERROR
 . S DECDT=$$GET1^DIQ(9000010,AUPNVSIT_",",1116,"I")
 . S AMUPD(9009080,AMERVSIT_",",12.8)=$S(DECDT="":"@",1:DECDT)
 . D FILE^DIE("","AMUPD","ERROR")
 ;
 ;Now sync up the dashboard if installed
 I $T(SYNC^BEDDSYNC)]"" D EN^XBNEW("SYNC^BEDDSYNC","AUPNVSIT")
 Q
 ;
SCENE(SCENE,SOI) ;Return the scene of injury
 ;
 I $G(SCENE)="" Q ""
 ;	
 NEW IEN,FND
 S (FND,IEN)="" F  S IEN=$O(^AMER(3,"B",SCENE,IEN)) Q:IEN=""  D  Q:FND
 . NEW TYPE
 . S TYPE=$$GET1^DIQ(9009083,IEN_",",1,"I") Q:TYPE'=SOI
 . S FND=IEN
 ;
 Q FND
 ;
PDX(X,D0) ;EP - Display the ICD Description - Primary Dx
 NEW ICDINFO,ICDDESC,VDATE
 ;
 S VDATE=$P($$GET1^DIQ(9009080,D0,.01,"I"),".")
 I $$AICD^AMERUTIL() S ICDINFO=$$ICDDX^ICDEX($P(X,U,2),VDATE)
 E  S ICDINFO=$$ICDDX^ICDCODE($P(X,U,2),VDATE)
 ;
 ;Get the description
 S ICDDESC=$P(ICDINFO,U,4)
 W ICDDESC
 Q
 ;
DSPDX(X,D0,CODE,VDATE) ;Display the ICD Description
 ;
 NEW ICDDESC
 ;
 ;Make the call to get the string
 S ICDDESC=$$DX($G(X),$G(D0),$G(CODE),$G(VDATE))
 ;
 W ICDDESC
 ;
 Q ICDDESC
 ;
DX(X,D0,CODE,VDATE) ;Return the ICD Description
 ;
 ;Input
 ;     X - Pointer to file 80 - May be in piece 2
 ;    D0 - Pointer to ER VISIT file entry
 ;  CODE - 1 - Include Code in return value (optional) - Default to not include
 ; VDATE - Date to check on (Optional)
 NEW ICDINFO,ICDDESC
 ;
 S:$L(X,"^")>1 X=$P(X,U,2)
 ;
 S D0=$G(D0)
 S VDATE=$G(VDATE) I VDATE="",D0]"" S VDATE=$P($$GET1^DIQ(9009080,D0,.01,"I"),".")
 S:VDATE="" VDATE=DT
 ;
 I $$AICD^AMERUTIL() S ICDINFO=$$ICDDX^ICDEX(X,VDATE)
 E  S ICDINFO=$$ICDDX^ICDCODE(X,VDATE)
 ;
 ;Get the description
 S ICDDESC=$S($G(CODE)=1:$P(ICDINFO,U,2)_" - ",1:"")_$P(ICDINFO,U,4)
 I $P(ICDINFO,U,2)="" Q ""
 Q ICDDESC
