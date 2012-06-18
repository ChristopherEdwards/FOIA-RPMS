BDGPV1 ; IHS/ANMC/LJF - PROVIDER INQUIRY CONT. ; 
 ;;5.3;PIMS;**1003**;MAY 28, 2004
 ;IHS/ITSC/LJF 05/13/2005 PATCH 1003 added code to view day surgeries
 ;
CWAD ;EP; code to display CWAD info
 NEW BDGN,DFN
 D GETITEM I BDGN="" D RETURN Q
 S DFN=$P(BDGN,U,2)
 I $L($T(CWAD^TIULX)) D CWAD^TIULX
 D RETURN
 Q
 ;
EXPND ;EP; code to expand on entries shown
 NEW BDGN
 D GETITEM I BDGN="" D RETURN Q
 S X=$P(BDGN,U) D @X D RETURN
 Q
 ;
IP ; expand inpatient entries
 NEW DFN,DGPMCA
 S DFN=$P(BDGN,U,2),DGPMCA=$P(BDGN,U,3)
 D EN^BDGEPI
 Q
 ;
SR ; expand va surgery entries
 I $T(VIEW^BSRLA0)="" Q    ;routine not available
 NEW SRDR
 S SRDR=$P(BDGN,U,2) I '$D(^SRF(+SRDR)) Q
 D VIEW^BSRLA0,PAUSE^BDGF
 Q
 ;
DS ;expand day surgery file entries
 D EN^BDGPI3("",$P(BDGN,U,3),$P(BDGN,U,2))   ;IHS/ITSC/LJF 5/13/2005 PATCH 1003
 Q
 ;
OP ; expand appts
 NEW DFN,SDCL,SDT,SDW
 S DFN=$P(BDGN,U,2),SDCL=$P(BDGN,U,3),SDT=$P(BDGN,U,4),SDW=$P(BDGN,U,5)
 I (DFN="")!(SDCL="")!(SDT="")!(SDW="") Q
 D EN^BSDAMEP
 Q
 ;
GETITEM ; -- select entry from list
 NEW X,Y,Z
 D FULL^VALM1
 S BDGN=""
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=$O(VALMY(0))
 S Y=0 F  S Y=$O(^TMP("BDGPV",$J,"IDX",Y)) Q:Y=""  Q:BDGN]""  D
 . S Z=0 F  S Z=$O(^TMP("BDGPV",$J,"IDX",Y,Z)) Q:'Z  Q:BDGN]""  D
 .. Q:^TMP("BDGPV",$J,"IDX",Y,Z)=""
 .. I Z=X S BDGN=^TMP("BDGPV",$J,"IDX",Y,Z)_U_X
 Q
 ;
RETURN ; return to higher level list template
 D TERM^VALM0 S VALMBCK="R" Q
 ;
