ICDCODE ;DLS/DEK - ICD CODE APIS ; 04/28/2003
 ;;18.0;DRG Grouper;**6**;Oct 20, 2000
 ;
 ; External References
 ;   DBIA 10103  $$DT^XLFDT
 ;
ICDDX(CODE,CDT,DFN,SRC) ; return info on ICD Diagnosis code
 ; Input:
 ;    CODE - ICD code, ien or .01 format, REQUIRED
 ;    CDT - date to screen against, default = today (FileMan format)
 ;          If CDT < 10/1/1978, use 10/1/1978
 ;          If CDT > DT, validate with newest In/Activation Dates
 ;          If CDT is year only, use first of the year
 ;          If CDT is year and month only, use first of the month
 ;    DFN - not in use, included in anticipation of future need
 ;    SRC - SCREEN SOURCE
 ;          If '$G(SRC), level 1, Level 2 only.
 ;          If $G(SRC), include level 3.
 ; Output:
 ;    ien^CODE NUMBER^IDENTIFIER^DIAGNOSIS^UNACCEPTABLE AS PRINCIPAL DX^MAJOR DIAGNOSTIC CATEGORY 
 ;       ien^MDC13^COMPLICATION/COMORBIDITY^ICD EXPANDED^STATUS^SEX^INACTIVE DATE^MDC24^MDC25^AGE 
 ;       LOW^AGE HIGH^ACTIVATION DATE^MSG
 ; -or-
 ;    -1^error description
 ;
 ;    STATUS = 0 if inactive, 1 if active
 ;    SEX = M if Male, F if Female, null if non-specific
 ;    Activation Date = date code became active
 ;    Inactivation Date = date code became inactive
 ;    AGE Low = minimum age for code, null if non-specific
 ;    AGE High = maximum age for code, null if non-specific
 ;    MSG = User Alert
 ;
 ; Variables:
 ;    DATA = 0-node for ICD code
 ;    EFF = effective date
 ;
 N DATA,EFF,INV
 I $G(CODE)="" Q "-1^NO CODE SELECTED"
 S INV="-1^INVALID CODE",CODE=+$$CODEN(CODE,80) ;find ien for code
 I CODE<1 Q INV ;if no code, return error
 I '$D(^ICD9(CODE)) Q INV ;if no code, return error
 I '$G(SRC),$P(^ICD9(CODE,0),"^",8) Q "-1^VA LOCAL CODE SELECTED"
 ;move 0-node into string
 S DATA=$G(^ICD9(CODE,0)) I '$L(DATA) Q "-1^NO DATA"
 S CDT=$S($G(CDT)="":$$DT^XLFDT,1:$$DTBR^ICDAPIU(CDT))
 S EFF=$$EFF^ICDSUPT(80,CODE,CDT)
 S $P(DATA,"^",9)=$S(EFF<1:0,1:$P(EFF,"^"))
 S $P(DATA,"^",11)=$P(EFF,"^",2),$P(DATA,"^",16)=$P(EFF,"^",3)
 Q CODE_"^"_DATA_"^"_$$MSG^ICDAPIU(CDT)
 ;
ICDOP(CODE,CDT,DFN,SRC) ; return info on ICD Operation/Procedure code
 ; Input:
 ;    CODE - ICD code, ien or .01 format, REQUIRED
 ;    CDT - date to screen against, default = today (FileMan format)
 ;          If CDT < 10/1/1978, use 10/1/1978
 ;          If CDT > DT, validate with newest In/Activation Dates
 ;          If CDT is year only, use first of the year
 ;          If CDT is year and month only, use first of the month
 ;    DFN - not in use, included in anticipation of future need
 ;    SRC - SCREEN SOURCE
 ;          If '$G(SRC), level 1, Level 2 only.
 ;          If $G(SRC), include level 3.
 ; Output:
 ;       ien^CODE NUMBER^IDENTIFIER^MDC24^OPERATION/PROCEDURE^^^^ICD EXPANDED^STATUS^SEX^INACTIVE 
 ;         DATE^ACTIVATION DATE^MSG
 ;  -or-
 ;       -1^error description
 ;
 ;    STATUS = 0 if inactive, 1 if active
 ;    SEX = M if Male, F if Female, null if non-specific
 ;    Activation Date = date code became active
 ;    Inactivation Date = date code became inactive
 ;    MSG = User alert
 ;
 ; Variables:
 ;    DATA = 0-node for ICD code
 ;    EFF = effective date
 ;
 N DATA,EFF,STR,INV
 I $G(CODE)="" Q "-1^NO CODE SELECTED"
 S INV="-1^INVALID CODE",CODE=+$$CODEN(CODE,80.1) ; find ien for code
 I CODE<1 Q INV ; if no code, return error
 I '$D(^ICD0(CODE)) Q INV ; if no code, return error
 I '$G(SRC),$P(^ICD0(CODE,0),"^",8) Q "-1^VA LOCAL CODE SELECTED"
 ;move 0-node into string
 S DATA=$G(^ICD0(CODE,0)) I '$L(DATA) Q "-1^NO DATA"
 S CDT=$S($G(CDT)="":$$DT^XLFDT,1:$$DTBR^ICDAPIU(CDT))
 S EFF=$$EFF^ICDSUPT(80.1,CODE,CDT)
 S $P(DATA,"^",9)=$S(EFF<1:0,1:$P(EFF,"^"))
 S $P(DATA,"^",11,12)=$P(EFF,"^",2,3)
 Q CODE_"^"_DATA_"^"_$$MSG^ICDAPIU(CDT)
 ;
ICDD(CODE,OUTARR,CDT) ; returns ICD description in array
 ; Input:
 ;    CODE - ICD code  REQUIRED
 ;    OUTARR - array to store description
 ;             name of array - e.g. "ABC" or "ABC("TEST")"
 ;             or temp arr.   Default = ^TMP("ICDD",$J)
 ;    CDT - date to screen against, default = today (FileMan format)
 ;          If CDT < 10/1/1978, use 10/1/1978
 ;          If CDT > DT, use DT
 ;          If CDT is year only, use first of the year
 ;          If CDT is year and month only, use first of the month
 ; Output:
 ;    # of lines
 ;    @OUTARR(1-n) = lines of description
 ;    @OUTARR(n) = User Alert
 ; -or-
 ;    -1^error message
 ;
 ; **NOTE - USER MUST INITIALIZE ^TMP("ICDD",$J), IF USED**
 ;
 N ARR,END,I,N,GLOB,INV
 I $G(CODE)="" Q "-1^NO CODE SELECTED"
 S INV="-1^INVALID CODE"
 I CODE?1.9N Q "-1^"_INV
 S CODE=$$CODEN(CODE),GLOB=$P(CODE,"~",2),CODE=+CODE
 I CODE<1!(GLOB["INVALID") Q INV ;if no code, return error
 I '$D(@(GLOB_CODE_")")) Q INV ;if no code, return error
 I $G(OUTARR)="" S OUTARR="^TMP(""ICDD"",$J,"
 ;ensure OUTARR is proper format
 I OUTARR'["(" S OUTARR=OUTARR_"("
 I OUTARR[")" S OUTARR=$P(OUTARR,")")
 S END=$E(OUTARR,$L(OUTARR)) I END'="("&(END'=",") S OUTARR=OUTARR_","
 ;clear ^TMP("ICDD",$J - if used
 I OUTARR="^TMP(""ICDD"",$J," K ^TMP("ICDD",$J)
 S I=0,N=0,CDT=$S($G(CDT)="":$$DT^XLFDT,1:$$DTBR^ICDAPIU(CDT))
 S N=N+1,ARR=OUTARR_N_")",@ARR=$G(@(GLOB_CODE_",1)"))
 S N=N+1,ARR=OUTARR_N_")",@ARR=" "
 S N=N+1,ARR=OUTARR_N_")",@ARR=$$MSG^ICDAPIU(CDT)
 Q N
 ;
CODEN(CODE,FILE) ; return ien of ICD code
 ; Input:
 ;    CODE - ICD code  REQUIRED
 ;    FILE - File Number to search for code
 ;           80 = ICD Diagnosis file
 ;           80.1 = ICD Opereration/Procedure file
 ;
 ; Output: ien~global root
 ;    where global root is:
 ;           "^ICD9(" - File 80
 ;           "^ICD0(" - File 80.1
 ;    -or-
 ;         -1~error message
 ;
 I $G(CODE)="" Q "-1~NO CODE SELECTED"
 N Y,GLOB,INV
 S INV="INVALID ",CODE=$P(CODE," ")
 ;use FILE if passed
 I $G(FILE) D  Q Y_"~"_GLOB
 . S GLOB=$S(FILE=80:"^ICD9(",FILE=80.1:"^ICD0(",1:INV_"FILE")
 . I $E(GLOB)'="^" S Y=-1,GLOB=INV_"FILE" Q
 . S Y=$S(CODE?1.9N:$$CODEZ(CODE,GLOB),1:$$CODEBA(CODE,GLOB))
 ;FILE not passed - report where found
 I CODE?1.9N S GLOB="^ICD9(",Y=$$CODEZ(CODE,GLOB) D  G CODENQ
 . I Y<1 S GLOB="^ICD0(",Y=$$CODEZ(CODE,GLOB)
 S GLOB=$S(CODE?2N1"."1.3N:"^ICD0(",CODE?3N1".".3N!(CODE?1U2.3N1".".2N):"^ICD9(",1:-1)
 S Y=$S('GLOB:$$CODEBA(CODE,GLOB),1:-1)
CODENQ I Y<1 S GLOB=INV_"CODE"
 Q Y_"~"_GLOB
 ;
CODEC(CODE,FILE) ;return the ICD code of an ien
 ;  Input:
 ;    CODE - ien of ICD code    REQUIRED
 ;    FILE - File Number to search for code
 ;           80 = ICD Diagnosis file
 ;           80.1 = ICD Opereration/Procedure file
 ; Output: ICD code, -1 if not found
 ;
 S CODE=$G(CODE) Q:CODE'?1.9N -1
 N Y,GLOB
 I $G(FILE) D  Q Y
 . S GLOB=$S(FILE=80:"^ICD9(",FILE=80.1:"^ICD0(",1:-1)
 . S Y=$S(GLOB<0:-1,1:$$CODEZ(CODE,GLOB))
 ;FILE not passed - Search for 1st match
 S Y=$$CODEZ(CODE,"^ICD9(",1)
 Q $S(+Y<0:$$CODEZ(CODE,"^ICD0(",1),1:Y)
 ;
CODEZ(CODE,ROOT,FLG) ; based on code ien and root:
 N Y,ICDL            ; if 'FLG return code existence, else zero node - piece 1
 S Y=$P($G(@(ROOT_CODE_",0)")),"^"),ICDL=$L(Y) I ICDL,'$G(FLG) Q CODE
 Q $S('ICDL:-1,1:Y)
 ;
CODEBA(CODE,ROOT) ;return ien based on code and root
 N IEN
 S IEN=$O(@(ROOT_"""BA"","""_CODE_" "","""")"),-1)
 Q $S('IEN:-1,1:IEN)
 ;
