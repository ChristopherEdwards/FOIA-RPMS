BQIPLDS2 ;VNGT/HS/ALA-Panel Def Description Utility Cont. ; 04 Feb 2011  1:58 PM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
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
