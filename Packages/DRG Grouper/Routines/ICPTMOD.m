ICPTMOD ;VA/ALB/ABR - CPT MODIFIER APIS ; 3/4/97
 ;;2.0;LEXICON UTILITY;;Sep 23, 1996
 ;;6.0;CPT/HCPCS;**6**;May 19, 1997
 ;
 ;  APIs for CPT modifiers
 ;
MOD(MOD,MFT,MDT,SRC,DFN) ;  returns basic info on CPT MODIFIERs
 ;   Input:  MOD - modifier REQUIRED
 ;           MFT - modifier format 
 ;            where:  "I" = ien format
 ;                    "E" = .01 format (default)
 ;           MDT - date to check active for, default = today (FileMan format)
 ;           SRC - Modifier Source Screen.
 ;                 If 0 or Null, check national(level 1,level 2)mods only
 ;           DFN - not in use but included in anticipation of future need
 ;
 ;  Output:  string:
 ;         ien^modifier^NAME^CODE^SOURCE^EFFECTIVE DATE^STATUS
 ;             where STATUS = 0 - inactive
 ;                          = 1 - active
 ;           EFFECTIVE DATE = date status became effective
 ;  -or-
 ;         -1^error description
 ;
 ;
 ; Variables:
 ;     DATA = 0-node for cpt modifier code
 ;      EFF = effective date
 ;      EFFX = ien of effective date
 ;      EFFS = status for date
 ;      STR = output
 ;
 N DATA,EFF,EFFX,EFFS,STR,MODN
 I $G(MOD)="" S STR="-1^NO MODIFIER SELECTED" G MODQ
 I $G(MFT)="" S MFT="E"
 I "E^I"'[MFT S STR="-1^INVALID MODIFIER FORMAT" G MODQ
 I $G(MDT)="" S MDT=DT ;if no date selected, picks today
 ;
 ; find ien of modifier
 ; if mult mods have same name, return list of iens
 I MFT="E" S MODN=$O(^DIC(81.3,"B",MOD,0)) I $O(^(MODN)) S STR="-1^Multiple modifiers w/same name.  Select IEN: " D MULT G MODQ
 I MFT="E" S MOD=MODN ; sets MOD = ien
 S MOD=+MOD
 I 'MOD!'$D(^DIC(81.3,MOD)) S STR="-1^NO SUCH MODIFIER" G MODQ ; if no modifier, return error
 ;
 ;  move 0-node data into string
 S DATA=$G(^DIC(81.3,MOD,0))
 I '$L(DATA) S STR="-1^NO DATA" G MODQ
 S STR=MOD_U_$P(DATA,U,1,4)
 S EFF=$$EFF^ICPTAPIU(81.3,MOD,MDT)
 I EFF'>0 S EFF="^0"
 S STR=STR_U_EFF
 I '$G(SRC),$P(STR,U,5)="V" S STR="-1^VA LOCAL MODIFIER SELECTED"
MODQ Q STR
 ;
MODP(CODE,MOD,MFT,MDT,SRC,DFN) ;  check if modifier can be used with code
 ;
 ;   Input:  CODE - CPT/HCPCS code  (ien or .01 format)  REQUIRED
 ;           MOD - MODIFIER          REQUIRED
 ;           MFT - modifier format
 ;                "I" = ien format
 ;                "E" = .01 format (default)
 ;           MDT - date (default = today)(FileMan format)
 ;           SRC - Modifier Source Screen.
 ;                 If 0 or Null, check national(level 1,level 2)mods only
 ;                 If SRC>0, include VA modifiers
 ;           DFN - not in use but included in anticipation of future need
 ;
 ;  Output:  STR = 0 if pair is unacceptable
 ;           STR = IEN in 81.3^MODIFIER name (.02 field) if acceptable
 ;        or STR = -1^error message
 ;
 ; Variables
 N CODEA,CODN,PR,PRN,STR,MODN,MODN,MODX,POP,MODCK
 I $G(CODE)="" S STR="-1^NO CODE SELECTED" G MODPQ
 I $G(MOD)="" S STR="-1^NO MODIFIER SELECTED" G MODPQ
 I $G(MFT)="" S MFT="E"  ;if no modifier format selected, default to "E"
 I $G(MDT)="" S MDT=DT   ;if no date selected, default to today
 I "E^I"'[MFT S STR="-1^INVALID MODIFIER FORMAT" G MODPQ
 ;
 ; check to see if cpt code exists
 S:'CODE CODN=$$CODEN^ICPTCOD(CODE)
 I CODE S CODN=+CODE
 S CODE=$P($G(^ICPT(CODN,0)),U) I '$L(CODE) S STR="-1^NO SUCH CPT CODE" G MODPQ
 S CODEA=$$NUM^ICPTAPIU(CODE) ; convert code to numeric format
 I '$G(SRC),$P(^ICPT(CODN,0),U,6)="L" S STR="-1^VA LOCAL CODE SELECTED" G MODPQ
 ;
 ; find ien for modifier, if .01 sent in
 S MODCK=""
 I MFT="E" S MODN="",POP=0  F  S MODN=$O(^DIC(81.3,"B",MOD,MODN)) Q:(MODN="")!POP  D
 . S MODCK=MODN
 . D MODC(MODN)
 . I STR>0 S POP=1
 I MFT="I" S MODCK=MOD D MODC(MOD)
 I MODCK="" S MODCK=+MODCK
 I '$D(^DIC(81.3,MODCK,0)) S STR="-1^NO SUCH MODIFIER" G MODPQ
 I '$G(SRC),$P(^DIC(81.3,MODCK,0),U,4)="V" S STR="-1^VA LOCAL MODIFIER SELECTED"
MODPQ Q $G(STR)
 ;
MODC(MOD) ;subroutine checks modifier for range including code, and active
 ;   for date desired.  
 ;  MOD = modifier ien
 ;
 N MODNM
 I MDT=DT,$D(^DIC(81.3,MOD,0)),$P(^DIC(81.3,MOD,0),U,5) S STR="-1^modifier inactive" Q
 S PR=CODEA_.0001,PR=$O(^DIC(81.3,MOD,"M",PR),-1) ; find start of range
 I 'PR S STR=0 Q
 S PRN=^DIC(81.3,MOD,"M",PR) ; END RANGE VALUE
 I 'PRN S STR="-1^bad modifier file entry" Q
 ;
 I PRN<CODEA S STR=0 Q  ; if code greater than end range
 S MODNM=$P($G(^DIC(81.3,MOD,0)),U,2)
 S STR=MOD_"^"_MODNM ; code modifier pair okay pending date check
 ;
 ; check that modifier is active for given date
 I MDT'=DT,'$P($$EFF^ICPTAPIU(81.3,MOD,MDT),U,2) S STR="-1^modifier inactive"
 Q
 ;
MULT ; finds iens for all modifiers with same 2-letter code
 ;  MOD = .01, check B x-ref for other mods with equivalent .01 fields
 ;  output concatenates ien of each mod to STR, separated by ":"
 F MODN=0:0 S MODN=$O(^DIC(81.3,"B",MOD,MODN)) Q:'MODN   S STR=STR_MODN_"; "
 Q
