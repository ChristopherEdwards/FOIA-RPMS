TIURA2 ; SLC/JER - More review screen actions ;8/28/01
 ;;1.0;TEXT INTEGRATION UTILITIES;**88,58,100,123,1002**;Jun 20, 1997
 ; 6/20/00: Moved DISPLAY, BROWSE, & BROWS1 from TIURA to TIURA2
 ;IHS/ITSC/LJF 7/30/2003 bypass rebuild if called by BTIURPT
 ;IHS/OIT/LJF 03/17/2005 PATCH #1002 - added PEP to BROWS1 subroutine
 ;                                     to be called by PCC Audit function
 ;
DISPLAY ; Detailed Display
 N TIUDA,TIUD,TIUDATA,TIUI,Y,DIROUT,TIUQUIT,RSTRCTD
 I '$D(VALMY) D EN^VALM2(XQORNOD(0))
 S TIUI=0
 F  S TIUI=$O(VALMY(TIUI)) Q:+TIUI'>0  D  Q:$D(TIUQUIT)
 . N TIUVIEW
 . S TIUDATA=$G(^TMP("TIURIDX",$J,TIUI))
 . D CLEAR^VALM1
 . W !!,"Reviewing #",+TIUDATA
 . S TIUDA=+$P(TIUDATA,U,2)
 . S TIUVIEW=$$CANDO^TIULP(TIUDA,"VIEW")
 . I +TIUVIEW'>0 D  Q
 . . W !!,$C(7),$P(TIUVIEW,U,2),!
 . . I $$READ^TIUU("EA","RETURN to continue...") ; pause
 . . D RESTORE^VALM10(+TIUI)
 . S RSTRCTD=$$DOCRES^TIULRR(TIUDA)
 . I RSTRCTD D  Q
 . . W !!,$C(7),"Ok, no harm done...",!
 . . I $$READ^TIUU("EA","RETURN to continue...") ; pause
 . . D RESTORE^VALM10(+TIUI)
 . D EN^TIUAUDIT
 . I +$G(TIUQUIT) D FIXLSTNW^TIULM Q
 . I TIUI'=$P($G(TIUGLINK),U,2) D RESTORE^VALM10(+TIUI) ; See rtn TIURL
 K VALMY S VALMBCK="R"
 Q
BROWSE(TIULTMP) ; Browse selected documents
 ; TIULTMP is list template name
 N TIUDA,DFN,TIU,TIUCHNG,TIUDATA,TIUI,Y,DIROUT,TIUQUIT
 N TIUGDATA
 I '$D(VALMY) D EN^VALM2(XQORNOD(0))
 S TIUI=0
 F  S TIUI=$O(VALMY(TIUI)) Q:+TIUI'>0  D  Q:$D(TIUQUIT)
 . N TIUVIEW,TIUGACT,RSTRCTD
 . S TIUDATA=$G(^TMP("TIURIDX",$J,TIUI))
 . S TIUDA=+$P(TIUDATA,U,2)
 . S TIUGDATA=$G(^TMP("TIUR",$J,"IDDATA",TIUDA)) ; ID note/entry
 . D CLEAR^VALM1
 . W !!,"Reviewing Item #",TIUI
 . S RSTRCTD=$$DOCRES^TIULRR(TIUDA)
 . I RSTRCTD D  Q
 . . W !!,$C(7),"Ok, no harm done...",!
 . . I $$READ^TIUU("EA","RETURN to continue...") ; pause
 . D BROWS1(TIULTMP,TIUDA,TIUGDATA)
 ; -- Update or Rebuild list: --
 I $G(TIUCHNG("DELETE"))!$G(TIUCHNG("ADDM")) S TIUCHNG("RBLD")=1
 S TIUCHNG("UPDATE")=1 ; default
 ;D UPRBLD^TIURL(.TIUCHNG,.VALMY) K VALMY     ;IHS/ITSC/LJF 7/30/2003
 K VALMY                                      ;IHS/ITSC/LJF 7/30/2003
 S VALMBCK="R"
 Q
GETSORT(PRMSORT,EXPSORT) ; Get order for ID entries
 Q $S($G(EXPSORT)'="":EXPSORT,1:PRMSORT)
 ;
BROWS1(TIULTMP,TIUDA,TIUGDATA) ;PEP; Browse single document;IHS/OIT/LJF 3/17/2005 PATCH #1002
 ;  Calls EN^VALM
 N %DT,C,D0,DIQ2,FINISH,TIU,TIUVIEW
 I '$D(TIUGDATA) S TIUGDATA=$$IDDATA^TIURECL1(TIUDA)
 I TIULTMP="TIU COMPLETE NOTES",$P(TIUGDATA,U,2) W !!,"You are completing the PARENT ENTRY of this interdisciplinary note."
 I '$P(TIUGDATA,U,2) D  Q:+TIUVIEW'>0  ;TIU*1*123
 . S TIUVIEW=$$CANDO^TIULP(TIUDA,"VIEW")
 . I +TIUVIEW'>0 D
 . . W !!,$C(7),$P(TIUVIEW,U,2),!
 . . I $$READ^TIUU("EA","RETURN to continue...") ; pause
 I '$D(TIUPRM0)!'$D(TIUPRM1) D SETPARM^TIULE
 D EN^VALM(TIULTMP)
 K ^TMP("TIUVIEW",$J)
 Q
 ;
EXPAND ; Expand/Collapse ID notes, Addenda in lists
 N TIUDNM,TIULNM,TIUSTAT
 D:'$D(VALMY) EN^VALM2(XQORNOD(0))
 I $D(VALMY) D EC^TIURECL(.VALMY)
 W !,"Refreshing the list."
 K VALMY
 S VALMCNT=+$G(@VALMAR@(0))
 S VALMBCK="R"
 Q
 ;
PRNTSCRN(VALMY) ; Evaluate whether a record may be printed
 N TIUI S TIUI=""
 F  S TIUI=$O(VALMY(TIUI)) Q:+TIUI'>0  D  Q:$D(DIROUT)
 . N TIUPMTHD,TIUDTYP,TIUPFHDR,TIUPFNBR,TIUPGRP,TIUPRINT,TIUFLAG,RSTRCTD
 . S RSTRCTD=0,TIUDATA=$G(^TMP("TIURIDX",$J,TIUI))
 . S TIUDA=+$P(TIUDATA,U,2),TIUTYP=$P(^TIU(8925,TIUDA,0),U)
 . ; Evaluate whether user can print record
 . S TIUPRINT=$$CANDO^TIULP(TIUDA,"PRINT RECORD")
 . I +TIUPRINT'>0 D  Q
 . . W !!,"Item #",TIUI,": ",!,$P(TIUPRINT,U,2),!
 . . K VALMY(TIUI)
 . . I $$READ^TIUU("EA","RETURN to continue...")
 . ;-- Add Check for restricted record when available --
 . S DFN=+$P(^TIU(8925,TIUDA,0),U,2)
 . S RSTRCTD=$$PTRES^TIULRR(DFN)
 . I +RSTRCTD D  Q
 . . W !!,"Item #",TIUI," Removed from print list.",!
 . . K VALMY(TIUI)
 . . I $$READ^TIUU("EA","Press RETURN to continue...")
 . I +$G(TIUPFLG) S TIUFLAG=+$$CHARTONE^TIURA1(TIUDA)
 Q
