BQIDCMYC ;PRXM/HC/ALA-"MY PATIENTS-COMMUNITY" ; 14 Oct 2005  4:09 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
LST(DATA,PARMS,MPARMS) ;EP **not used yet**
 ;Description
 ;  This returns a maximum count of patients based on a passed in
 ;  community and provider.  Corresponds with the predefined panel
 ;  MY PATIENTS-COMMUNITY.
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Expected to return DATA
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIDCMYC",UID))
 K @DATA
 ;
FND ;  Find patients in one or more communities
 NEW IEN,NM,COMM,PROV
 S NM="",COMM="",PROV=""
 I '$D(PARMS) Q
 ;
 F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 ;
 I $G(COMM)]"" D FND1
 I $D(MPARMS("COMM")) S COMM="" F  S COMM=$O(MPARMS("COMM",COMM)) Q:COMM=""  D FND1
 Q
FND1 ; Check one community
 N COMM1
 S COMM1=COMM
 ;
 ; X-ref uses the community name and not IEN.
 I COMM?1.N S COMM=$$GET1^DIQ(9999999.05,COMM,.01,"E")
 ; For now quit. Should eventually jump to process by provider.
 I COMM="" Q
 ;
 S IEN=""
 F  S IEN=$O(^AUPNPAT("AC",COMM,IEN)) Q:IEN=""  D
 . ; If patient is deceased, quit
 . I $P($G(^DPT(IEN,.35)),U,1)'="" Q
 . ; If patient has no active HRNs, quit
 . I '$$HRN^BQIUL1(IEN) Q
 . ; If patient has no visit in last 3 years, quit
 . ;I '$$VTHR^BQIUL1(IEN) Q
 . S LOC=0
 . F  S LOC=$O(^AUPNPAT(IEN,41,LOC)) Q:'LOC  D
 .. I $P($G(^AUPNPAT(IEN,41,LOC,0)),U,3)'="" Q
 .. I PROV'="",$$GET1^DIQ(9000001,IEN_",",.14,"I")'=PROV Q
 .. ; Check whether the IEN matches the community IEN that was filed.
 .. ; There are some with duplicate names.
 .. I COMM1?1.N,$$GET1^DIQ(9000001,IEN_",",1117,"I")'=COMM1 Q
 .. S @DATA@(IEN)=""
 Q
