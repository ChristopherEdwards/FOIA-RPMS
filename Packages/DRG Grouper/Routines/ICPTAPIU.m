ICPTAPIU ;VA/ALB/ABR - CPT UTILITIES FOR APIS ; MAR 4, 1997
 ;;2.0;LEXICON UTILITY;;Sep 23, 1996
 ;;6.0;CPT/HCPCS;**1,6**;May 19, 1997
 ;
EFF(FILE,CODE,EDT) ; returns effective date and status for code/modifier
 ;
 ;  Input:   FILE = file number  REQUIRED
 ;                  81 for CPT file
 ;                  81.3 for CPT MODIFIER file
 ;           CODE = CPT CODE ien or CPT MODIFIER ien REQUIRED
 ;            EDT = date to check for (FileMan format) (default = today)
 ;
 ;  Output:    effective date^status
 ;          where STATUS = 1 = active
 ;                         0 = inactive  
 ;             -1^error message
 ;
 ; Variables:  EFILE = indirect file reference for code
 ;               EFF = effective date
 ;              EFFN = sub-entry ien
 ;               STR = output
 ;
 N EFILE,EFF,EFFN,STR
 I '$G(FILE) S STR="-1^NO FILE SELECTED" G EFFQ
 I '(FILE=81!(FILE=81.3)) S STR="-1^INVALID FILE" G EFFQ
 I '$G(CODE) S STR="-1^NO "_$S(FILE=81:"CODE",1:"MODIFIER")_" SELECTED" G EFFQ
 S FILE=$S(FILE=81:"^ICPT(",1:"^DIC(81.3,")
 I $G(EDT)="" S EDT=DT
 S EFILE=FILE_CODE_",60,"
 S EFF=$O(@(EFILE_"""B"","_(EDT+.001)_")"),-1) I 'EFF S STR="-1^NO DATA" G EFFQ
 S EFFN=$O(@(EFILE_"""B"","_EFF_",0)")) ; node 60 (effective date) sub-entry
 S STR=$G(@(EFILE_EFFN_",0)")) S:'STR STR="-1^NO DATA"
EFFQ Q STR
 ;
CPTDIST() ; DISTRIBUTION DATE
 ;  Input:  none (extrinsic variable)
 ; Output:  returns DISTRIBUTION DATE, date codes effective in Austin
 Q $P($G(^DIC(81.2,1,0)),U,2)
 ;
CAT(CAT,DFN) ; return CATEGORY NAME given ien
 ;   Input:  CAT = category ien REQUIRED
 ;           DFN - not in use but included in anticipation of future need
 ;
 ;  Output:  STR = CATEGORY NAME^SOURCE (C or H)^MAJOR CATEGORY IEN^MAJOR CATEGORY NAME  
 ;           STR = -1^error message, if error condition occurred
 ;
 N CATN,STR,MCATIEN,MCATNM
 S (MCATIEN,MCATNM)=""
 I $G(CAT)="" S STR="-1^NO CATEGORY SELECTED" G CATQ
 I '$G(CAT) S STR="-1^INVALID CATEGORY FORMAT" G CATQ
 S STR=$G(^DIC(81.1,+CAT,0))
 I '$L(STR) S STR="-1^NO SUCH CATEGORY" G CATQ
 I $P(STR,U,2)="" S STR="-1^TYPE OF CATEGORY UNSPECIFIED"
 S CATN=$P(STR,U)
 I $P(STR,U,2)="m" S MCATNM=CATN,MCATIEN=+CAT
 I $P(STR,U,2)="s" D
 . S MCATIEN=$P(STR,U,3)
 . I MCATIEN S MCATNM=$P($G(^DIC(81.1,MCATIEN,0)),U)
 S STR=CATN_U_$P(STR,U,6)_U_MCATIEN_U_MCATNM
CATQ Q STR
 ;
NUM(Y) ; convert cpt/hcpcs code to numeric
 ;    convert HCPCS to $A() of alpha _ numeric portion
 ;
 ;   Input:  Y - CPT or HCPCS code
 ;
 ;  Output:  'plussed' value for CPT code,
 ;         numeric for HCPCS based on $A of 1st character (alpha)
 ;          concatenated with the 4-digit portion of code
 ;
 ;  **This does not convert to ien**
 ;  This converts to a numeric that may be used for range sorting
 ;
 Q $S(Y:+Y,1:$A(Y)_$E(Y,2,5))
 ;
COPY ; api to print copyright information
 ;
 N DIR,DIWL,DIWR,DIWF,VARR,VAXX,X
 Q:'$D(^DIC(81.2,1))  K ^UTILITY($J,"W")
 W !!! S DIWL=1,DIWR=80,DIWF="W" F VARR=0:0 S VARR=$O(^DIC(81.2,1,1,VARR)) Q:VARR'>0  S VAXX=^(VARR,0),X=VAXX D ^DIWP
 D:$D(VAXX) ^DIWW
 Q
