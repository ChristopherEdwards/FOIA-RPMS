BQIUL1 ;PRXM/HC/DLS - Miscellaneous BQI Utilities ; 26 Oct 2005  9:43 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
FMTE(Y) ;EP - Convert Fileman Date/Time to 'MMM DD,CCYY HH:MM:SS' format.
 ;Description
 ;  Receives Date (Y) in FileMan format and returns formatted date.
 ;
 ;Input
 ;  Y - FileMan date/time (i.e. 3051024.123456).
 ;  
 ;Output
 ;  Date/Time in External format (i.e. OCT 24,2005 12:34:56).
 ;  
 NEW DATM
 S DATM=$TR($$FMTE^DILIBF(Y,"5U"),"@"," ")
 I DATM["24:00" S DATM=$P(DATM," ",1,2)_" 00:00"
 Q DATM
 ;
DATE(DATE) ;EP - Convert standard date/time to a FileMan date/time
 ;Input
 ;  DATE - In a standard format
 ;Output
 ;  -1 is if it couldn't convert to a FileMan date
 ;  otherwise a standard FileMan date
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
FMTMDY(DATE) ;EP - Convert fileman date to MM/DD/YYYY format
 ;Input
 ;  DATE - In fileman format
 ;  
 ;Output
 ;  -1 if couldn't convert to MM/DD/YYYY format
 ;  Otherwise, date in MM/DD/YYYY format
 ;
 Q $TR($$FMTE^XLFDT(DATE,"5Z"),"@"," ")
 ;
TKO(STR,VAL) ;EP - Take off ending character
 ;
 ;Description
 ;  This will take off the ending character at the end of
 ;  a string
 ;Input
 ;  STR - String of data
 ;  VAL - Delimiter character
 ;Output
 ;  same STR without the ending character
 ;
 I $G(STR)="" Q ""
 I $G(VAL)="" Q ""
 ;
 NEW LV
 S LV=$L(VAL)
 I $E(STR,$L(STR)-(LV-1),$L(STR))=VAL S STR=$E(STR,1,$L(STR)-LV)
 ;
 Q STR
 ;
STRIP(STR,VAL) ;EP - Remove one or more trailing characters in a string.
 ;
 ;Description
 ;  Removes one or more trailing characters
 ;  at the end of a string.
 ;Input
 ;  STR - String of data
 ;  VAL - Delimiter character
 ;Output
 ;  Same STR without the trailing character(s).
 ;
 I $G(STR)="" Q STR
 I $G(VAL)="" Q STR
 ;
 F  Q:$E(STR,$L(STR))'=VAL  S STR=$E(STR,1,($L(STR)-1))
 Q STR
 ;
CTRL(X) ;EP - Strip out control characters
 I X'?.ANP F Y=1:1 I $E(X,Y)?.C Q:Y>$L(X)!(X="")  S X=$E(X,1,Y-1)_$E(X,Y+1,999),Y=Y-1
 Q X
 ;
TRIM(STR,VAL) ;EP - Remove one or more leading characters in a string.
 ;
 ;Description
 ;  Removes one or more leading characters from a string.
 ;Input
 ;  STR - String of data
 ;  VAL - Delimiter character
 ;Output
 ;  Same STR without the trailing character(s).
 ;
 I $G(STR)="" Q STR
 I $G(VAL)="" Q STR
 ;
 F  Q:$E(STR,1)'=VAL  S STR=$E(STR,2,($L(STR)))
 Q STR
 ;
TMPFL(MODE,UID,DFN) ;EP - Open to 'R'ead, Open to 'W'rite, 'C'lose or 'D'elete
 ; temporary file designed for use when converting report text to RPC
 ; data strings. Note that UID and DFN are components of the file name.
 ;
 ; Input
 ;    MODE(Required) - 'R'(Read),'W'(Write),'C'(Close),'D'(Delete)
 ;    UID(Req'd for modes D,R,W) - Job identifier
 ;    DFN(Req'd for modes D,R,W) - Patient IEN
 ; Output
 ;    POP - 0 for success, 1 for failure
 ;    
 N POP,HSPATH,HSFN
 S POP=1
 ;
 ; To close a file.
 I MODE="C" D CLOSE^%ZISH("BQIFILE")
 ;
 ; To Delete, Read-From, or Write-To a file.
 I "D/R/W"[MODE D
 .S HSPATH=$$DEFDIR^%ZISH("")
 .I HSPATH="" S HSPATH=$$PWD^%ZISH()
 .S HSFN=UID_"_"_$G(DFN)_".DAT"
 ;
 ; To delete a file
 I MODE="D" S POP=$$DEL^%ZISH(HSPATH,HSFN)
 ;
 ; To Read from or to Write to a file.
 I (MODE="R")!(MODE="W") D
 .D OPEN^%ZISH("BQIFILE",HSPATH,HSFN,MODE)
 Q POP
 ;
CMSI(X) ;EP - CMS Register Lookup
 NEW DIC
 S DIC(0)=$S($G(X)="":"AENZ",1:"NZ")
 S DIC="^ACM(41.1," D ^DIC
 S X=$P(Y,U,2) K:+Y<0 X
 Q
 ;
PRV(VIEN) ;EP - Get PRIMARY provider for a visit
 NEW PRV
 S PRV=$$PRIMVPRV^PXUTL1(VIEN)
 I PRV=0 S PRV=$$PROV(VIEN)
 I PRV=0 Q ""
 Q $$GET1^DIQ(200,PRV_",",.01,"E")
 ;
VVNAR(VIEN) ;EP - Get visit POV narratives
 NEW IEN,POVN,TEXT,CT
 S TEXT="",CT=0,IEN=""
 F  S IEN=$O(^AUPNVPOV("AD",VIEN,IEN)) Q:IEN=""  D
 . S POVN=$$GET1^DIQ(9000010.07,IEN_",",".019","E")
 . I $L(TEXT)+$L(POVN)>250 Q
 . S CT=CT+1
 . S TEXT=TEXT_CT_")"_POVN_";"_$C(13)_$C(10)
 Q $$TKO^BQIUL1(TEXT,";"_$C(13)_$C(10))
 ;
VPNAR(VIEN) ;EP - Get visit provider narratives
 NEW IEN,PRVN,TEXT,CT
 S TEXT="",CT=0,IEN=""
 F  S IEN=$O(^AUPNVPOV("AD",VIEN,IEN)) Q:IEN=""  D
 . S PRVN=$$GET1^DIQ(9000010.07,IEN_",",".04","E")
 . I $L(TEXT)+$L(PRVN)>250 Q
 . S CT=CT+1
 . S TEXT=TEXT_CT_")"_PRVN_";"_$C(13)_$C(10)
 Q $$TKO^BQIUL1(TEXT,";"_$C(13)_$C(10))
 ;
PROB(PIEN) ; EP - Return date/time from Problem
 ;  Input Parameter
 ;    PIEN = IEN of problem
 ;
 ;Since not all dates exist or are not required data entry, the
 ;hierachy is 'DATE ENTERED', and then 'DATE LAST MODIFIED'.
 NEW VISDTM
 ; DATE ENTERED
 S VISDTM=$$GET1^DIQ(9000011,PIEN,.08,"I")
 ; if for some reason DATE ENTERED doesn't exist, look at DATE LAST MODIFIED.
 I VISDTM="" S VISDTM=$$GET1^DIQ(9000011,PIEN,.03,"I")
 Q VISDTM
 ;
PROV(VIEN) ;EP - Check for Hospital Primary Provider
 NEW DGADM,MIEN,PROV
 S PROV=0
 S DGADM=$O(^DGPM("AVISIT",VIEN,""))
 I DGADM="" Q ""
 S MIEN="",QFL=0
 F  S MIEN=$O(^DGPM("CA",DGADM,MIEN),-1) Q:MIEN=""!(QFL)  D
 . S PROV=$$GET1^DIQ(405,MIEN_",",.08,"I") I PROV>0 S QFL=1
 Q PROV
 ;
HRN(BQIDFN) ;EP - Find any active HRNs for a patient
 NEW HRN,FLAG,SITE
 S FLAG=0,SITE=0
 F  S SITE=$O(^AUPNPAT(BQIDFN,41,SITE)) Q:'SITE  D  Q:FLAG
 . I $P($G(^AUPNPAT(BQIDFN,41,SITE,0)),U,3)="" S FLAG=1
 Q FLAG
 ;
VTHR(BQIDFN) ; EP - Find any visits in last 3 years for patient
 NEW FLAG,BDATE,RVDATE,VIEN,RVSDTM,VSDTM,QFL
 S FLAG=0,VIEN="",QFL=0,VSDTM=""
 S BDATE=$$DATE("T-36M"),RVDATE=9999999-BDATE
 S RVSDTM=$O(^AUPNVSIT("AA",BQIDFN,RVDATE),-1)
 I RVSDTM'="" D
 . F  S VIEN=$O(^AUPNVSIT("AA",BQIDFN,RVSDTM,VIEN)) Q:VIEN=""  D  Q:QFL
 .. I $G(^AUPNVSIT(VIEN,0))="" Q
 .. S FLAG=1,QFL=1
 .. S VSDTM=$P($G(^AUPNVSIT(VIEN,0)),U,1)
 Q FLAG_U_VIEN_U_VSDTM
