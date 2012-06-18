BVPMAIN ; IHS/ITSC/LJF - VPR ENTRY POINT ;
 ;;1.0;VIEW PATIENT RECORD;;NOV 17, 2004
 ;
 ;This routine calls a list template to view a patient's record.
 ;The first screen displayed is the patient's health summary.
 ;
 I '$$PKGCK^BVPU("APCHS","PCC HEALTH SUMMARY") D  D EXIT Q
 . D MSG^BVPU("**HEALTH SUMMARY SOFTWARE NOT INSTALLED**",2,1,1)
 ;
 K ^TMP("BVP",$J) D KILL^AUPNPAT
 F  D GETPAT Q:$G(DFN)<1  D
 . NEW APCHSPAT,APCHSTYP,APCHSTAT,APCHSMTY,AMCHDAYS,AMCHDOB,BVPSAV
 . D GETHSTYP I '$G(APCHSTYP) D EXIT Q
 . S APCHSPAT=DFN,BVPSAV=DFN
 . D EN,FULL^VALM1,EXIT
 ;
EOJ ; -- end of job
 D KILL^AUPNPAT,EN^XBVK("VALM"),EN^XBVK("APCH")
 D KILL^%ZISS
 Q
 ;
EN ;EP -- main entry point for list template BVP HS VIEW
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D MSG^BVPU("Building Health Summary Display.  Please wait...",1,0,0)
 D EN^VALM("BVP HS VIEW")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP -- header code
 S VALMSG=$$VALMSG^BVPU
 Q
 ;
INIT ;EP -- init variables and list array
 NEW X
 K ^TMP("BVP",$J)
 D GUIR^XBLM("EN^APCHS","^TMP(""BVP"",$J,")
 S X=0 F  S X=$O(^TMP("BVP",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BVP",$J,X,0)=^TMP("BVP",$J,X)
 D TERM^VALM0
 S VALMSG=$$VALMSG^BVPU
 Q
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1,MSG^BVPU("",2,0,0)
 Q
 ;
EXIT ;EP -- exit code
 K ^TMP("BVP",$J)
 K DFN,BVPSAV,APCHSPAT
 Q
 ;
EXPND ;EP -- expand code
 Q
 ;
RESET ;EP -- update partition for return to list manager
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D MSG^BVPU("Updating Health Summary Display.  Please Wait...",1,0,0)
 S DFN=BVPSAV D SETPT(DFN)   ;make sure patient is still set
 D INIT,HDR K BVPSECX Q
 ;
RESET2 ;EP -- update partition without recreating display array
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R" D HDR Q
 ;
GETPAT ; -- ask user to select patient
 K DIC,DFN S DIC=9000001,DIC(0)="AEMQZ" D ^DIC I Y>0 S DFN=+Y K DIC,Y
 Q
 ;
GETHSTYP ;EP -- ask user for health summary type
 ; Called by ^BVPVRL1
 NEW DIC,DR,DD,X,Y
 S DIC="^APCHSCTL(",DIC(0)="AEMQ"
 ; get default health summary type
 S Y=$G(^DISV(DUZ,"^APCHSCTL(")) I $D(^APCHSCTL(+Y,0)) S DIC("B")=$P(^(0),U) ;last selected by user
 I '$D(DIC("B")) S DIC("B")="VPR MINI"                                       ;OR set to general HS type
 D ^DIC K DIC Q:Y<1  S APCHSTYP=+Y
 Q
 ;
VST ;EP -- view/edit pcc visits
 ; Called by BVP VISIT VIEW (Visit Details) protocol
 D FULL^VALM1
 S APCDPAT=DFN D GETVISIT^APCDDISP,^APCDVD,EOJ^APCDDISP
 S (DFN,AUPNPAT)=BVPSAV D SETPT(DFN)
 D RESET2
 Q
 ;
HS ;EP; -- change health summary
 ; Called by BVP HS CHANGE (Change Health Summary) protocol
 NEW BVPHS,X,Y
 D FULL^VALM1
 S BVPHS=APCHSTYP D GETHSTYP
 I +$G(APCHSTYP)<1 S APCHSTYP=BVPHS D RESET2 Q
 D EN^BVPMAIN S VALMBCK="Q"
 Q
 ;
SETPT(DFN) ;EP; -- sets AUPN variables when DFN is set
 NEW X,DIC,Y S X="`"_DFN,DIC=2,DIC(0)="" D ^DIC Q
