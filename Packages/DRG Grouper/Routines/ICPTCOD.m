ICPTCOD ;VA/ALB/ABR - CPT CODE APIS ; 3/3/97
 ;;2.0;LEXICON UTILITY;;Sep 23, 1996
 ;;6.0;CPT/HCPCS;**6**;May 19, 1997
 ;;2.08;CPT FILES;**1**;DEC 17, 2007
 ;
CPT(CODE,CDT,SRC,DFN) ;  returns basic info on CPT/HCPCS code
 ;  Input:  CODE - CPT or HCPCS code, ien or .01 format, REQUIRED
 ;           CDT - active as of date, default = today (FileMan format)
 ;           SRC - SCREEN SOURCE
 ;                 If '$G(SRC), level 1, Level 2 only.
 ;                 If $G(SRC), include level 3.
 ;           DFN - not in use but included in anticipation of future need
 ;
 ;  Output:  string:
 ;      ien^CPT CODE^SHORT NAME^CATEGORY ien^SOURCE^EFFECTIVE DATE^STATUS
 ;             where STATUS = 0 - inactive
 ;                          = 1 - active
 ;           EFFECTIVE DATE = date status became effective
 ;  -or-
 ;         -1^error description
 ;
 ;
 ; Variables:
 ;     DATA = 0-node for cpt code
 ;      EFF = effective date
 ;      EFFS = status
 ;      STR = output
 ;
 N DATA,EFF,EFFS,STR
 I $G(CODE)="" S STR="-1^NO CODE SELECTED" G CPTQ
 I $G(CDT)="" S CDT=DT  ;if no date selected, picks today.
 ;S CODE=$G(CODE),CODE=$S(CODE:+CODE,1:$$CODEN(CODE)) ; find ien for code
 S CODE=$G(CODE),CODE=$S(CODE?1.N:+CODE,1:$$CODEN(CODE))  ;IHS/OIT/CLS 03/05/2008
 I CODE<1!'$D(^ICPT(CODE)) S STR="-1^NO SUCH ENTRY" G CPTQ ; if no code, return error
 I '$G(SRC),$P(^ICPT(CODE,0),U,6)="L" S STR="-1^VA LOCAL CODE SELECTED" G CPTQ
 ;
 ;  move 0-node data into string
 S DATA=$G(^ICPT(CODE,0))
 I '$L(DATA) S STR="-1^NO DATA" G CPTQ
 S STR=CODE_U_DATA,$P(STR,U,5)=$P(STR,U,7),STR=$P(STR,U,1,5)
 S EFF=$$EFF^ICPTAPIU(81,CODE,CDT)
 I EFF'>0 S EFF="^0"
 S STR=STR_U_EFF
CPTQ Q STR
 ;
CPTD(CODE,OUTARR,DFN) ; returns CPT description in array
 ;
 ;   Input:   CODE - CPT/HCPCS code  REQUIRED
 ;          OUTARR - array to store description
 ;                   name of array - e.g. "ABC" or "ABC("TEST")"
 ;                   or temp array.
 ;                   Default = ^TMP("ICPTD",$J)
 ;          DFN - not in use but included in anticipation of future need
 ;
 ;  Output:    # of lines
 ;             @OUTARR(1-n)  lines of description
 ;
 ;             -1^error message
 ;
 ; **NOTE - USER IS RESPONSIBLE FOR INITIALIZING ^TMP("ICPTD",$J), IF USED**
 ;
 N ARR,END,I,N
 I $G(CODE)="" S N="-1^NO CODE SELECTED" G CPTDQ
 I $G(OUTARR)="" S OUTARR="^TMP(""ICPTD"",$J,"
 ;
 ; check to make sure OUTARR is in proper format
 I OUTARR'["(" S OUTARR=OUTARR_"("
 I OUTARR[")" S OUTARR=$P(OUTARR,")")
 S END=$E(OUTARR,$L(OUTARR)) I END'="("&(END'=",") S OUTARR=OUTARR_","
 ;
 ; If ^TMP("ICPTD",$J, used, clear before using
 I OUTARR="^TMP(""ICPTD"",$J," K ^TMP("ICPTD",$J)
 S CODE=$G(CODE),CODE=$S(CODE:+CODE,1:$$CODEN(CODE)),I=0,N=0
 I CODE<1!'$D(^ICPT(CODE)) S N="-1^NO SUCH CODE" G CPTDQ ; if no code, return error
 F  S I=$O(^ICPT(CODE,"D",I)) Q:'I  S N=N+1,ARR=OUTARR_N_")",@ARR=$G(^(I,0))
CPTDQ Q N
 ;
CODM(CODE,OUTARR,SRC,CDT,DFN) ;  returns list of modifiers for a code
 ;
 ;  Input:    CODE = CPT/HCPCS code (Internal or external format)
 ;          OUTARR = array name for list returned
 ;                   name of array - e.g. "ABC" or "ABC("TEST")"
 ;                   or temp array.
 ;                   Default = ^TMP("ICPTM",$J)
 ;             SRC = Source Screen.
 ;                   If 0 or Null, use national(level 1,level 2)mods only
 ;                   If SRC>0, use all mods, locals (level 3) included.
 ;             CDT = date in Fileman format to check modifier status.
 ;                   If 0 or Null, return all the modifiers for a code.
 ;                   Else return only modifiers active on the date of CDT
 ;             DFN = not in use. Included in anticipation of future need.
 ;
 ; Output:    STR = # of modifiers that apply
 ;          OUTARR array in the format:
 ;            OUTARR(mod) = name^mod ien
 ;                (mod is the .01 field)
 ;             -1^error description
 ;
 ;**NOTE - USER IS RESPONSIBLE FOR INITIALIZING ^TMP("ICPTM",$J) ARRAY**
 ;
 N ARR,CODI,CODA,BR,END,ER,MD,MDST,MI,MN,STR,CODEC,ACTMD
 ;
 I $G(CODE)="" S STR="-1^NO CPT SELECTED" G CODMQ
 I $G(OUTARR)="" S OUTARR="^TMP(""ICPTM"",$J,"
 S STR=0,CODI=$S(CODE:+CODE,1:$$CODEN(CODE)),CODEC=$$CODEC(CODI),CODA=$$NUM^ICPTAPIU(CODEC)
 I '$D(^ICPT(CODI,0)) S STR="-1^NO SUCH CODE" G CODMQ
 I '$G(SRC),$P(^ICPT(CODI,0),U,6)="L" S STR="-1^VA LOCAL CODE SELECTED" G CODMQ
 ;
 ; check to make sure OUTARR is in proper format
 I OUTARR'["(" S OUTARR=OUTARR_"("
 I OUTARR[")" S OUTARR=$P(OUTARR,")")
 S END=$E(OUTARR,$L(OUTARR)) I END'="("&(END'=",") S OUTARR=OUTARR_","
 ;
 ; If ^TMP("ICPTM",$J, used, clear before using
 I OUTARR="^TMP(""ICPTM"",$J," K ^TMP("ICPTM",$J)
 ;find first begin range
 ;  BR = Begin Range; ER = End Range
 S BR="" F  S BR=$O(^DIC(81.3,"M",BR)) Q:BR>CODA!'BR  D  ; find begin range
 .S ER="" F  S ER=$O(^DIC(81.3,"M",BR,ER)) Q:'ER  I CODA'>ER D
 ..S MI=0 F  S MI=$O(^DIC(81.3,"M",BR,ER,MI)) Q:'MI  D
 ...S MDST=$G(^DIC(81.3,MI,0)) Q:'$L(MDST)  ; quits if no data node
 ...I '$G(SRC) Q:$P(MDST,U,4)="V"  ; screens out local (VA) modifiers
 ...I $G(CDT) S ACTMD="",ACTMD=$$MOD^ICPTMOD(MI,"I",CDT,SRC) Q:($P(ACTMD,U)=-1)!($P(ACTMD,U,7)=0)  ;screens out inactive modifiers if asked to.
 ...S MD=$P(MDST,U,1,2),MN=$P(MD,U)
 ...I $L(MN)'=2 Q  ; checks for valid modifier format
 ...S ARR=OUTARR_""""_MN_""")",@ARR=$P(MD,U,2)_U_MI,STR=STR+1
 I 'STR S STR=0
CODMQ Q STR
 ;
CODEN(CODE) ;-- This function will return the ien of a CPT or HCPCS code
 ;   Input:  CPT/HCPCS code
 ;  Output:  ien of code
 ;
 Q +$O(^ICPT("B",CODE,0))
 ;
CODEC(CODE) ;--This function will return the CPT or HCPCS code of an ien.
 ;  Input: ien of CPT/HCPCS code
 ;  Output: CPT/HCPCS code
 ;
 N Y
 S Y=$P($G(^ICPT(CODE,0)),U,1)
 Q Y
 ;
VALCPT(CODE,CDT,SRC,DFN) ;check if CPT code is valid for selection
 ;   Input:  CODE - CPT or HCPCS code, ien or .01 format, REQUIRED
 ;           CDT - active as of date, default = today (FileMan format)
 ;           SRC - SCREEN SOURCE '$G(SRC) level 1, Level 2 only, $G(SRC) include level 3
 ;           DFN - not in use but included in anticipation of future need
 ;
 ;   Output: STR:  1 if valid code for selection
 ;                -1^error message    if not selectable
 ;
 N STR
 S CODE=$G(CODE),SRC=$G(SRC),DFN=$G(DFN)
 I $G(CDT)="" S CDT=DT
 S STR=$$CPT(CODE,CDT,SRC,DFN)
 I STR<0 G VALCPTQ
 I '$P(STR,U,7) S STR="-1^Inactive Code for "_$$FMTE^XLFDT(CDT)
 I STR>0 S STR=1
VALCPTQ Q STR
