BKMVUTL ;PRXM/HC/ALA - HMS UTILITIES ; 21 Sep 2005  6:38 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
SRC ;  State Reporting Category Prompt
 K DIR
 NEW Y,X
 S SRCAT=""
 S DIR(0)="SO^H:HIV;A:AIDS"
 D ^DIR K DIR
 I Y="^"!(Y="") Q
 S SRCAT=Y
 Q
 ;
PROB(PIEN) ; EP - Return date/time from Problem
 ;  Input Parameter
 ;    PIEN = IEN of problem
 ;
 NEW VISDTM
 S VISDTM=$$GET1^DIQ(9000011,PIEN,.08,"I")
 I VISDTM="" S VISDTM=$$GET1^DIQ(9000011,PIEN,.03,"I")
 Q VISDTM
 ;
STC(FIL,FLD,VAL) ; EP - Find a value for a set of codes code
 ;  Input Parameters
 ;    FIL = FileMan File Number
 ;    FLD = FileMan Field Number
 ;    VAL = Code Value
 ;
 NEW VEDATA,VEQFL,VEVL,VALUE
 S VEDATA=$P(^DD(FIL,FLD,0),U,3),VEQFL=0
 ;
 F I=1:1 S VEVL=$P(VEDATA,";",I) Q:VEVL=""  D  Q:VEQFL
 . S VALUE=$P(VEVL,":",2) I VAL=$P(VEVL,":",1) S VEQFL=1
 ;
 Q VALUE
 ;
HRN(BKMVDFN) ;EP - Find any active HRNs for a patient
 NEW HRN,FLAG,SITE
 S FLAG=0,SITE=0
 F  S SITE=$O(^AUPNPAT(BKMVDFN,41,SITE)) Q:'SITE  D  Q:FLAG
 . I $P($G(^AUPNPAT(BKMVDFN,41,SITE,0)),U,3)="" S FLAG=1
 Q FLAG
