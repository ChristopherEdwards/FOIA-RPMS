BLRSM ;IHS/MSC/MKK - IHS Lab SiGN or SYmptom List Manager Routine ; 10-Mar-2015 09:14 ; MKK
 ;;5.2;LAB SERVICE;**1033,1034**;NOV 1, 1997;Build 88
 ;; ;
EN(ICDFLAG) ; -- main entry point for BLR SNOMED SELECT
 S ICDFLAG=$G(ICDFLAG,0)
 D EN^VALM("BLR SNOMED SELECT")
 Q
 ;
SELECT ; EP - Do the Selection
 K DIR
 S DIR(0)="N^"_VALMBG_":"_VALMLST_":0"
 D ^DIR
 I $G(X)="^^^"  S Y=99999999  G FATALERR^BLRSGNSY     ; Trick to exit
 S WHICHONE=+$G(Y)
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$G(^TMP("BLR SNOMED GET",$J,"HDR"))
 ; S VALMHDR(2)="This is the second line"
 Q
 ;
INIT ; -- init variables and list array
 S (LINE,NUM)=0
 K DUPS
 F  S NUM=$O(VARS(NUM))  Q:NUM<1  D
 . ; If ICDFLAG, then SNOMED must also have an ICD CODE associated with it
 . Q:ICDFLAG&($L($G(VARS(NUM,"ICD",1,"COD")))<1&($L($G(VARS(NUM,"10D",1,"COD")))<1))
 . ;
 . ; S SNOMED=$G(VARS(NUM,"FSN","DSC"))
 . ; S SNOMEDSC=$G(VARS(NUM,"FSN","TRM"))
 . S SNOMED=$G(VARS(NUM,"PRB","DSC"))
 . S SNOMEDSC=$G(VARS(NUM,"PRB","TRM"))
 . S ICDCODE=$G(VARS(NUM,"ICD",1,"COD"))
 . ;
 . ; Q:$D(DUPS(SNOMED))   ; Don't list if Duplicate SNOMED code
 . ;
 . ; S DUPS(SNOMED)=""
 . S LINE=LINE+1
 . ;
 . S LINEVAR=""
 . S LINEVAR=$$SETFLD^VALM1($J(LINE,2)_") "_SNOMED,LINEVAR,"SNOMED")
 . S LINEVAR=$$SETFLD^VALM1(SNOMEDSC,LINEVAR,"SNOMED DESCRIPTION")
 . S LINEVAR=$$SETFLD^VALM1(ICDCODE,LINEVAR,"ICD")    ; IHS/MSC/MKK - LR*5.2*1034
 . ;
 . D SET^VALM10(LINE,LINEVAR)
 . S SNOMED(LINE)=SNOMED_"^"_SNOMEDSC_"^"_ICDCODE
 S VALMCNT=LINE
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
