APCDVD ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 18-MAY-1995 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;; ;
EN ;PEP -- main entry point for APCD VISIT DISPLAY
 K ^TMP("APCDVDSG",$J)
 Q:'$G(APCDVSIT)
 I '$G(APCDLIML) D EN^APCDVDSG(APCDVSIT)
 I $G(APCDLIML)=1 D EN^APCDVDSB(APCDVSIT) K APCDLIML
 NEW VALMCNT
 D TERM^VALM0
 D CLEAR^VALM1
 D EN^VALM("APCD VISIT DISPLAY")
 K ^TMP("APCDVDSG",$J),APCDBROW
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
EN1 ;EP - called from input templates
 D EN^XBNEW("EN^APCDVD","APCDVSIT;VALM*")
 K Y
 Q
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("APCDVDSG",$J,""),-1)
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
 ;
IEN ;EP - called from option
 W !!,"Visit display by IEN"
 S DIR(0)="N^1:99999999999:0",DIR("A")="Enter the VISIT IEN" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I '$D(^AUPNVSIT(Y)) W !!,"That visit does not exist." K Y Q
 S APCDVSIT=Y
 D EN
 K APCDVSIT
 Q
 ;
FINDDELV ;EP - called from option
 ;find and display a deleted visit, given date and optionally, patient name
