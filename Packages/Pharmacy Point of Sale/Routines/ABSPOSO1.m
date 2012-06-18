ABSPOSO1 ; IHS/FCS/DRS - NCPDP Override Main menu ; [ 09/03/2002  11:14 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,6,7**;JUN 21, 2001
 ;---------------------------------------------------------------
 ; IHS/SD/lwj  9/3/02  NCPDP 5.1 changes
 ; In 3.2, prior authorization was updated and stored in field 416.
 ; In 5.1, 416 is obsolete, and the information could be stored
 ; in field 461, and 462 or in the prior authorization segment.
 ; For now, the insurer/processors appear to be using 461, and 
 ; 462 rather than the segment.  In any case, we needed to change
 ; the way we capture prior authorization information - AND - we
 ; have to keep populating 416 since we have to still process 3.2
 ; claims.  This routine was changed to call PRIORA in ABSPOSo2
 ; rather than EDIT^ABSPOSO2 when we are processing a prior auth.
 ;(Field prompts also altered to match 5.1 standards.)
 ;---------------------------------------------------------------
 ;IHS/SD/lwj 6/10/03 Multiple changes
 ;  First, new logic was added to prompt for and store the
 ;  values for the 5.1 DUR multiple.  Second, code in MENU
 ;  altered to avoid <NOLINE> error when the prompt time
 ;  outs and a value is not entered.
 ;---------------------------------------------------------------
 ;IHS/SD/lwj 9/4/03 patch 7 V1.0 prior authorization menu
 ; option altered to reflect 3.2 only
 ;---------------------------------------------------------------
 Q
TEST D MENU("") Q
MENU(IEN)          ;EP -
 ;
 ;IHS/SD/lwj 6/19/03 patch 6 POS separate ien and dien if dien there
 ;
 S DIEN=$P(IEN,U,2)
 S IEN=$P(IEN,U)
 ;end changes  IHS/SD/lwj 6/19/03 patch 6
 ;
 D SETLIST
 N PROMPT S PROMPT(1)="Select which claim data you wish to override."
 S PROMPT(2)="Use   ^   to exit this menu."
 N SEL F  D  Q:'SEL  Q:SEL=-1
 . S SEL=$$LIST^ABSPOSU4("S",$$LISTROOT,$$ANSROOT,"Override Claim Defaults",.PROMPT,1,20,$S($G(DTOUT):DTOUT,1:300))
 .;IHS/SD/lwj 6/10/03 time out causes error next line
 .;remarked out, following line added to avoid <NOLINE>
 . ;I SEL W ! H 1 D @$P($T(LIST+SEL),";",4) ;
 . I +SEL>0 W ! H 1 D @$P($T(LIST+SEL),";",4) ;
 Q
LISTROOT()         Q "^TMP("""_$T(+0)_""","_$J_","
ANSROOT()          Q "^TMP("""_$T(+0)_""","_($J+.1)_","
SETLIST K ^TMP("ABSPOSO1",$J),^TMP("ABSPOSO1",$J+.1)
 N I,X F I=1:1 D  Q:X="*"
 . S X=$T(LIST+I),X=$P(X,";",2,$L(X)) Q:X="*"
 . S ^TMP("ABSPOSO1",$J,I,"I")=$P(X,";")
 . S ^TMP("ABSPOSO1",$J,I,"E")=$P(X,";",2)
 S ^TMP("ABSPOSO1",$J,0)=I-1
 Q
 ;
 ; IHS/SD/lwj 9/3/02 - the following 3 lines were removed from LIST -
 ; new 1 - 3 lines were added to replace them
 ;1;Preauthorization #;EDIT^ABSPOSO2(IEN,416)
 ;2;Person Code;EDIT^ABSPOSO2(IEN,303)
 ;3;Relationship Code;EDIT^ABSPOSO2(IEN,306)
 ;
 ; IHS/SD/lwj 9/3/02 - since still unimplemented, the following 
 ; lines were removed from the menu options in LIST
 ;I;Order of insurance;NOTIMP
 ;P;Pricing;NOTIMP
 ;
LIST ;
 ;1;Prior Authorization (3.2);PRIORA^ABSPOSO2(IEN)  ;IHS/SD/lwj 9/3/02
 ;2;Patient Gender Code;EDIT^ABSPOSO2(IEN,303)
 ;3;Patient Relationship Code;EDIT^ABSPOSO2(IEN,306)
 ;4;Eligibility Clarification Code;EDIT^ABSPOSO2(IEN,309)
 ;5;NCPDP 5.1 DUR Segment Input;EDIT^ABSPOSD2(DIEN)
 ;*;Enter/edit/override any NCPDP field;EDIT^ABSPOSO2(IEN)
 ;*
NOTIMP W !,"That option isn't yet implemented.",! N % R %:3 Q
