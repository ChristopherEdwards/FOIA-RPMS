BSDCLAV ; IHS/ANMC/LJF - CLINIC AVAIL REPORT ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BSDRM CLINIC AVAILABILITY
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM CLINIC AVAILABILITY")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDCLAV",$J),^TMP("BSDCLAV1",$J)
 D GUIR^XBLM("IHS^SDCLAV0","^TMP(""BSDCLAV1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDCLAV1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDCLAV",$J,X,0)=^TMP("BSDCLAV1",$J,X)
 K ^TMP("BSDCLAV1",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDCLAV",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
CANC ;EP; called to find cancelled appts
 NEW SDN1,SDN2,SDN3
 S SDN1=0
 F  S SDN1=$O(^DPT("ASDCN",SDC,SDAP,SDN1)) Q:SDN1=""  D
 . S SDN2=$P(^DPT(+SDN1,0),U)
 . S X=$$SCAPPT(SDC,SDAP,SDN1),M1=$P(X,U,2),SDC3=$P(X,U,9)
 . S SDN3=$$HRCN^BDGF2(+SDN1,+$$FAC^BSDU(SDC))
 . S SDN3=$S(SDN3="":"UNKNOWN",1:SDN3)
 . D NM2^SDCLAV0
 Q
 ;
SCAPPT(CLINIC,DATE,PAT) ; return IEN for appt in ^SC
 NEW X,Y
 S X=0 F  S X=$O(^SC(CLINIC,"S",DATE,1,X)) Q:'X  D
 . I $P($G(^SC(CLINIC,"S",DATE,1,X,0)),U)=PAT S Y=X
 Q $G(^SC(CLINIC,"S",DATE,1,+$G(Y),0))
