PSBZVSD ;IHS/MSC/MGH - BCMA RPCS  ;24-Mar-2014 23:48;DU
 ;;3.0;BAR CODE MED ADMIN;**1017**;Mar 2004;Build 40
 ;Search virtual due list to see why the scanned in med was not found in it
 ;Search is first for VA Generic drug, then STRENGTH and then ROUTE
 ;Return message on what was not found
 ;Inp= TYPE ^ IEN  -type is DD,SOL,ADD, or ID
 ;     List= List of IENs on VDL for that same page
 ;Ret=-1^text ^header ^ .01 of IEN
EN(DATA,DRGIEN,DFN,LIST) ;EP-
 S DATA(0)=1
 S DATA(1)="-1^Invalid Medication Lookup"
 Q:$G(DUZ("AG"))'="I"
 N DMATCH,SMATCH,RMATCH,DNAME,VANAME
 S RET="",(DMATCH,SMATCH,RMATCH)=0
 S DRGIEN=$$FIND1^DIC(50,"","AX",DRGIEN,"B^C")  ;Allows lookup by Drug IEN or Synonym
 Q:'DRGIEN
 S DNAME=$$GET1^DIQ(50,DRGIEN,.01)
 S VANAME=$$GET1^DIQ(50,DRGIEN,20)
 D DISP(DRGIEN,VANAME,.LIST)
 Q
DISP(DRG,VANAME,LIST) ;EP-
 N CDRG,NAME,IEN,GIEN,TYPE,IEN
 S CDRG="" F  S CDRG=$O(LIST(CDRG)) Q:CDRG=""  D
 .S IEN=$G(LIST(CDRG))
 .S TYPE=$P($G(LIST(CDRG)),U,1)
 .S IEN=$P($G(LIST(CDRG)),U,2)
 .Q:'+IEN
 .S GIEN=$S(TYPE="SOL":$$GET1^DIQ(52.7,IEN,1,"I"),TYPE="ADD":$$GET1^DIQ(52.6,IEN,1,"I"),TYPE="DD":IEN,1:"")
 .S NAME=$$GET1^DIQ(50,GIEN,20)
 .I NAME=VANAME S DMATCH=1 D ROUTE(DRG,GIEN)
 I DMATCH=0&(SMATCH=0)&(RMATCH=0) S DATA(1)="-1^Scanned Drug Not Found in Virtual Due List^Wrong Drug ^"_DNAME Q
 I DMATCH=1&(RMATCH=0)&(SMATCH=0) S DATA(1)="-1^Scanned Drug dose does not match route ordered^Wrong Route ^"_DNAME Q
 I DMATCH=1&(RMATCH=1)&(SMATCH=0) S DATA(1)="-1^Scanned Drug does not match dose ordered^Wrong Dose ^"_DNAME Q
 I DMATCH=1&(RMATCH=1)&(SMATCH=1) S DATA(1)="-1^Idential match is not found.Please use Unable to Scan option ^Not Identical ^"_DNAME
 Q
STRENGTH(DRG,GIEN) ;EP -see if the strength matches
 N VASTR,DRSTR1
 S VASTR=$$GET1^DIQ(50,DRG,901)
 S DRSTR=$$GET1^DIQ(50,GIEN,901)
 I VASTR=""&(DRSTR="") D
 .S VASTR=$$GET1^DIQ(50,DRG,21,"I")
 .S DRSTR=$$GET1^DIQ(50,GIEN,21,"I")
 I VASTR=DRSTR S SMATCH=1
 Q
ROUTE(DRG,GIEN) ;EP- See if the route matches
 N VAROU,DRROU,POI,POI2
 S POI=$$GET1^DIQ(50,DRG,2.1,"I")
 S POI2=$$GET1^DIQ(50,GIEN,2.1,"I")
 S VAROU=$$GET1^DIQ(50.7,POI,.06)
 S DRROU=$$GET1^DIQ(50.7,POI2,.06)
 I VAROU=DRROU S RMATCH=1 D STRENGTH(DRG,GIEN)
 Q
 ;For IV barcodes, check that the patient matches
 ;If pt matches then find the bag number in file 55
 ;If its there, compare it to items on the VDL
 ;Inp= CNT from calling program
 ;     STRING= Scanned barcode
 ;     TAB = BCMA tab (PBTAB,IVTAB)
IVCHK(DATA,CNT,STRING,TAB,DFN) ;EP- Check for IV bag barcode match
 I STRING["V"!(STRING["W") D
 .I DFN'="" D
 ..I DFN=+STRING D CHKIV Q
 ..I DFN'=+STRING S DATA(CNT)="-1^Scanned drug does not match patient^Wrong Patient"
 E  I STRING?.N D
 .D:$G(DFN) CHKDRG
 Q
 ;
CHKDRG ;EP-
 N SLIST,ALIST,SOL,ADD,DD,ERR,CNT,IEN,ERRTXT,ERRTXT2,NAME
 S ERR=0,CNT=0
 K LIST
 S NAME=$$GET1^DIQ(50,STRING,.01)
 D GETLST(.SLIST,.ALIST)
 S INP=STRING
 S SOL=0 F  S SOL=$O(SLIST(SOL)) Q:SOL=""  D
 .S IEN=$G(SLIST(SOL))
 .I IEN'="" D
 ..S DD=$P($G(^PS(52.7,IEN,0)),U,2)
 ..S CNT=CNT+1
 ..S LIST(CNT)="DD^"_DD
 S ADD=0 F  S ADD=$O(ALIST(ADD)) Q:ADD=""  D
 .S IEN=$G(ALIST(ADD))
 .I IEN'="" D
 ..S DD=$P($G(^PS(52.6,IEN,0)),U,2)
 ..S CNT=CNT+1
 ..S LIST(CNT)="DD^"_DD
 D EN(.ERR,INP,DFN,.LIST)
 Q
CHKIV ;EP- Find the item in pts list
 N IEN,BAG,DONE,LIST,ADDIEN,SOLIEN,SLIST,ALIST,RETURN,ERR
 S DONE=0,DATA="",ERR=0
 S IEN=0 F  S IEN=$O(^PS(55,DFN,"IVBCMA",IEN)) Q:IEN=""!(DONE=1)  D
 .S BAG=$P($G(^PS(55,DFN,"IVBCMA",IEN,0)),U,1)
 .I BAG=STRING D
 ..S DONE=1
 ..D GETLST(.SLIST,.ALIST)
 ..S SOL=0 F  S SOL=$O(^PS(55,DFN,"IVBCMA",IEN,"SOL",SOL)) Q:SOL=""!(ERR=1)  D
 ...S SOLIEN=$P($G(^PS(55,DFN,"IVBCMA",IEN,"SOL",SOL,0)),U,1)
 ...S INP="SOL^"_SOLIEN
 ...D EN(.RETURN,INP,DFN,.SLIST)
 ...I $D(RETURN(1)) S ERR=1,DATA(CNT)=RETURN(1)
 ..Q:ERR=1
 ..S ADD=0 F  S ADD=$O(^PS(55,DFN,"IVBCMA",IEN,"AD",ADD)) Q:ADD=""!(ERR=1)  D
 ...S ADDIEN=$P($G(^PS(55,DFN,"IVBCMA",IEN,"AD",ADD,0)),U,1)
 ...S INP="ADD^"_ADDIEN
 ...D EN(.RETURN,INP,DFN,.ALIST)
 ...I $D(RETURN(1)) S ERR=1,DATA(CNT)=RETURN(1)
 I DONE=0 S DATA(CNT)="-1^Drug Not Found in Virtual Due List^Wrong Drug"
 Q
GETLST(SLIST,ALIST) ;EP- Get list of solutions and additives
 N SIEN,AIEN,RESULTS,NODE,CNT2
 S CNT2=1
 K ^TMP("PSB",$J)
 D RPC^PSBVDLTB(.RESULTS,DFN,TAB)
 S NUM=$G(@RESULTS@(0))
 F I=2:1:NUM D
 .S NODE=$G(@RESULTS@(I))
 .I $P(NODE,U,1)="SOL" S SLIST(CNT2)=$P(NODE,U,2)
 .I $P(NODE,U,1)="ADD" S ALIST(CNT2)=$P(NODE,U,2)
 .I $P(NODE,U,1)="END" S CNT2=CNT2+1
 Q
