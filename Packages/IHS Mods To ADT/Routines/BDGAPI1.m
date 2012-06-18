BDGAPI1 ; IHS/ANMC/LJF - PATIENT MOVEMENT API'S ;  [ 06/19/2002  1:22 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;See BDGAPI for details on variables
 ; Required for cancel function -
 ;  BDGR("PAT")  = patient ien
 ;  BDGR("TRAN") = ADT transaction
 ;  BDGR("ACCT") = outside account #
 ;  BDGR("DATE") = event date/time
 ;
CANCEL(BDGR) ;EP; silent API to delete patient movement entries to file 405
 NEW DGQUIET,BDGAPI,ERR
 S DGQUIET=1                ;must be in quiet mode
 S BDGAPI=1                 ;let DGPMV rtns know using API
 ;
 S ERR=$$CHECK^BDGAPI(.BDGR) I ERR Q ERR   ;check common req fields
 ;
 D @BDGR("TRAN") I ERR Q ERR
 Q $G(ERR)
 ;
 ;
1 ; delete admission
 NEW DGPMT,DGPMP,DFN,I,DGPMCA,DGPMDA,BDGN,X,DGPMAN,DA,DGPMN
 S DGPMT=BDGR("TRAN"),DFN=BDGR("PAT"),ERR="",DGPMN=0
 ;
 ; find admission based on acct #
 ;6/19/2002 LJF9 (per Linda) change errors to warnings.
 ;S BDGN=$$CA I $E(ERR,1)=1 Q
 S BDGN=$$CA I '$G(BDGN) Q  ;IHS/ANMC/LJF 6/12/2002 if no IEN, quit no matter the reason
 ;
 ; set up BEFORE variables needed by event driver
 S (DA,DGPMDA,DGPMCA)=BDGN,DGPMAN=$G(^DGPM(DA,0)) K %DT
 S DGPMY=BDGR("ADMIT DATE"),DGPMP=DGPMAN
 D VAR^DGPMV3 S DGPMER=0
 ;
 ; loop through other movements tied to admission and delete them
 F DGI=DGPMDA:0 S DGI=$O(^DGPM("CA",DGPMDA,DGI)) Q:'DGI  D
 . I $D(^DGPM(DGI,0)) D
 .. S DGPMTYP=$P(^DGPM(DGI,0),"^",2),DA=DGI,DIK="^DGPM("
 .. S ^UTILITY("DGPM",$J,DGPMTYP,DA,"P")=^DGPM(DGI,0),^UTILITY("DGPM",$J,DGPMTYP,DA,"A")=""
 .. S ^UTILITY("DGPM",$J,DGPMTYP,DA,"IHSP")=$G(^DGPM(DGI,"IHS"))
 .. S ^UTILITY("DGPM",$J,DGPMTYP,DA,"IHSA")=""
 .. D ^DIK
 ;
 ; kill any treating specialty entry tied to admission
 I DGPMDA,$O(^DGPM("APHY",DGPMDA,0)) D
 . S DIK="^DGPM(",DA=+$O(^DGPM("APHY",DGPMDA,0))
 . I $D(^DGPM(+DA,0)) D
 .. S ^UTILITY("DGPM",$J,6,DA,"P")=^DGPM(DA,0),^UTILITY("DGPM",$J,6,DA,"A")=""
 .. S ^UTILITY("DGPM",$J,6,DA,"IHSA")=""
 .. S ^UTILITY("DGPM",$J,6,DA,"IHSP")=$G(^DGPM(+DA,"IHS"))
 .. S Y=DA D PRIOR^DGPMV36,^DIK S Y=DA D AFTER^DGPMV36
 ;
 ; now delete admission
 S DIK="^DGPM(",DA=DGPMDA D ^DIK
 ;
 ; set AFTER variables for event driver
 S (^UTILITY("DGPM",$J,DGPMT,DGPMDA,"A"),DGPMA)=$G(^DGPM(+DGPMDA,0))
 S ^UTILITY("DGPM",$J,DGPMT,DGPMDA,"IHSA")=$G(^DGPM(+DGPMDA,"IHS"))
 ;
 S DGOK=0 F I=0:0 S I=$O(^UTILITY("DGPM",$J,I)) Q:'I  F J=0:0 S J=$O(^UTILITY("DGPM",$J,I,J)) Q:'J  I (^(J,"A")'=^("P"))!($G(^("IHSA"))'=$G(^("IHSP"))) S DGOK=1 Q
 I DGOK D ^DGPMEVT ;Invoke Movement Event Driver
 D Q^DGPMV3        ;clean up event driver variables
 ;
 Q
 ;
3 ; delete discharge
 NEW DGPMT,DGPMP,DFN,I,DGPMCA,DGPMDA,BDGN,X,IEN,BDGV,BDGCA
 S DGPMT=BDGR("TRAN"),DFN=BDGR("PAT"),ERR=""
 ;
 ; find admission based on acct # or admit date or current admit
 D FINDADM^BDGAPI2
 I 'BDGCA S ERR=ERR_2_U_"Cannot find file 405 entry for visit attached to acct # "_$G(BDGR("ACCT"))_U Q
 S DGPMCA=BDGCA
 ;
 ; now find discharge entry
 S BDGN=$$GET1^DIQ(405,DGPMCA,.17,"I")
 I 'BDGN S ERR=1_U_"No discharge associated with account # "_$G(BDGR("ACCT")) Q
 I $O(^DGPM("APTT1",DFN,BDGR("DISCHARGE DATE"))) S ERR=1_U_"Can only delete discharge for last admission; discharge ien="_BDGN Q
 ;
 ; set up BEFORE variables needed by event driver
 S DGPMDA=BDGN K %DT
 S ^UTILITY("DGPM",$J,DGPMT,DGPMDA,"IHSP")=$G(^DGPM(DGPMDA,"IHS"))
 S DGPMER=0,(^UTILITY("DGPM",$J,DGPMT,DGPMDA,"P"),DGPMP)=^DGPM(DGPMDA,0)
 ;
 ;Delete discharge, update admission mvt
 S DGPMADM=DGPMCA D DD^DGPMVDL1 K DA
 ;
 ; set AFTER variables for event driver
 S (^UTILITY("DGPM",$J,DGPMT,DGPMDA,"A"),DGPMA)=$G(^DGPM(+DGPMDA,0))
 S ^UTILITY("DGPM",$J,DGPMT,DGPMDA,"IHSA")=$G(^DGPM(+DGPMDA,"IHS"))
 ;
 S DGOK=0 F I=0:0 S I=$O(^UTILITY("DGPM",$J,I)) Q:'I  F J=0:0 S J=$O(^UTILITY("DGPM",$J,I,J)) Q:'J  I (^(J,"A")'=^("P"))!($G(^("IHSA"))'=$G(^("IHSP"))) S DGOK=1 Q
 I DGOK D ^DGPMEVT ;Invoke Movement Event Driver
 D Q^DGPMV3        ;clean up event driver variables
 ;
 Q
 ;
 ;LJF9 - everything coming out of this subroutine is an error, not a warning
CA() ; find admission based on acct # or date
 NEW X
 S X=$O(^AUPNVSIT("AXT",+$G(BDGR("ACCT")),0))
 I 'X S ERR=ERR_2_U_"Account # not in Visit file: "_$G(BDGR("ACCT"))_U
 S BDGN=$O(^DGPM("AVISIT",+X,0))
 ;6/19/2002 LJF9 (per Linda) change errors to warnings
 ;I 'BDGN S ERR=ERR_2_U_"Cannot find file 405 entry for visit attached to acct # "_$G(BDGR("ACCT"))_U
 ;
 ; if cannot find using acct #, find via event date
 I 'BDGN S BDGN=$O(^DGPM("APTT"_DGPMT,DFN,BDGR("DATE"),0))
 ;6/19/2002 LJF9 (per Linda) change errors to warnings
 ;I 'BDGN S ERR=1_U_"Cannot find entry using date or acct #; DATE="_BDGR("DATE")_" Acct #="_$G(BDGR("ACCT"))
 I 'BDGN S ERR=2_U_"Cannot find entry using date or acct #; DATE="_BDGR("DATE")_" Acct #="_$G(BDGR("ACCT"))  ;IHS/ANMC/LJF 6/12/2002 LJF9
 Q $G(BDGN)
