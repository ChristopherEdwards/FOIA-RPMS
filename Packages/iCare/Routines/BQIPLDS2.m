BQIPLDS2 ;VNGT/HS/ALA-Panel Def Description Utility Cont. ; 04 Feb 2011  1:58 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**3,4**;Apr 18, 2012;Build 66
 ;
 ;
ALGY ;EP - Allergy
 ; Only reformat description with designated operand
 I $G(FPARMS("ALLOP"))="" Q
 ; If only a single Allergy was identified operand is meaningless
 I '$D(FMPARMS("ALLERGY")) Q
 S FPARMS("ALLOP")=$S(FPARMS("ALLOP")="&":", AND ",1:", OR ")
 N DX,APM
 S (DX,APM)="",FPARMS("ALLERGY")=""
 F  S DX=$O(FMPARMS("ALLERGY",DX)) Q:DX=""  D
 . I $D(AFMPARMS("ALLERGY",DX)) D
 .. S APM=$$ADDAP^BQIPLDS1("ALLERGY",DX)
 . I $O(FMPARMS("ALLERGY",DX))="" S FPARMS("ALLERGY")=FPARMS("ALLERGY")_DX_APM Q
 . S FPARMS("ALLERGY")=FPARMS("ALLERGY")_DX_APM_FPARMS("ALLOP")
 K FMPARMS("ALLERGY"),AFMPARMS("ALLERGY")
 Q
 ;
DEC ;EP - Format Deceased status
 I $D(FPARMS("DEC")) D
 . N DEC
 . S DEC=FPARMS("DEC")
 . I DEC="Y" S DEC="Deceased, "
 . I DEC="N" S DEC=""
 . S FPARMS("DEC")=DEC
 ;
 I $D(FPARMS("LIV")) D
 . N LIV
 . S LIV=FPARMS("LIV")
 . I LIV="Y" S LIV="Living, "
 . I LIV="N" S LIV=""
 . S FPARMS("LIV")=LIV
 ;
INAC ;EP- Inactive patients
 I $D(FPARMS("INAC")) D
 . N INAC
 . S INAC=FPARMS("INAC")
 . I INAC="Y" S INAC="Inactive, "
 . I INAC="N" S INAC=""
 . S FPARMS("INAC")=INAC
 ;
 S FPARMS("DEC")=$$TKO^BQIUL1($G(FPARMS("DEC"))_$G(FPARMS("LIV"))_$G(FPARMS("INAC")),", ")
 Q
 ;
ALNAS(VALUE) ;EP - Allergies Not Assessed
 ;
 Q $S(VALUE="Y":"Not Assessed",1:"")
 ;
ALNKN(VALUE,PORD,FNAME) ;EP - Allergies Not Known
 ;
 ;Combine with Allergies Not Assessed
 S PORD=$$PORD^BQIDCDF(FSOURCE,"ALNAS") Q:PORD=""
 S FNAME="ALNAS"
 ;
 Q $S(VALUE="Y":"Not Known",1:"")
 ;
AGE ; Format Age Line
 ;
 NEW PORD,AGE,XAGE
 ;
 S PORD=$$PORD^BQIDCDF(FSOURCE,"AGE") Q:PORD=""
 ;
 ; Added the following line to replace the subsequent code for PR_0124
 I VALUE]"" D
 . NEW EXT,OP,COM
 . S AGE=VALUE,OP=0
 . I $E(AGE,1)="'" S OP=1,AGE=$E(AGE,2,99)
 . S COM=$E(AGE,1)
 . I OP,COM="<" S XAGE="Greater than or equal to ",AGE=$E(AGE,2,99)
 . E  I OP,COM=">" S XAGE="Less than or equal to ",AGE=$E(AGE,2,99)
 . E  I COM="<" S XAGE="Less than ",AGE=$E(AGE,2,99)
 . E  I COM=">" S XAGE="Greater than ",AGE=$E(AGE,2,99)
 . E  S XAGE="Equal to ",AGE=$E(AGE,2,99)
 . ;
 . I AGE["YRS" S AGE=XAGE_+AGE_" years"
 . I AGE["MOS" S AGE=XAGE_+AGE_" months"
 . I AGE["DYS" S AGE=XAGE_+AGE_" days"
 . ;
 . S VALUE=AGE
 ;
 I $D(FPARMS(PORD,"AGE"))>9 D
 . NEW PREV,AGE1,AGE2
 . S PREV=$O(FPARMS(PORD,"AGE","")) Q:PREV=""
 . ;
 . ;Check for inclusive
 . I PREV["Greater than or equal to" D  Q
 .. S AGE1=$P(PREV,"Greater than or equal to ",2) Q:AGE1=""
 .. S AGE2=$P(AGE,"Less than or equal to ",2) Q:AGE2=""
 .. S VALUE="Between (inclusive) "_AGE1_" and "_AGE2
 .. K FPARMS(PORD,"AGE",PREV)
 . ;
 . ;Check for exclusive
 . I PREV["Less than " D  Q
 .. S AGE1=$P(PREV,"Less than ",2) Q:AGE1=""
 .. S AGE2=$P(AGE,"Greater than ",2) Q:AGE2=""
 .. S VALUE="Less than "_AGE1_" or greater than "_AGE2
 .. K FPARMS(PORD,"AGE",PREV)
 ;
 Q
