APCLACGI ; IHS/CMI/LAB - LIST ICARE PANELS
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
 ;
 ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("APCL ICARE LIST")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 I APCLPTS="I" D
 .S VALMHDR(1)="iCare Panels owned or shared by "_$$VAL^XBDIQ1(200,DUZ,.01)
 .S VALMHDR(2)="Please select the iCare Panel you wish to report on."
 .S X="",$E(X,7)="Panel Name",$E(X,40)="Total # Patients"
 .S VALMHDR(3)=X
 I APCLPTS="E" D
 .S VALMHDR(1)="EHR Personal Lists owned or shared by "_$$VAL^XBDIQ1(200,DUZ,.01)
 .S VALMHDR(2)="Please select the EHR Personal List you wish to report on."
 .S X="",$E(X,7)="Panel Name"  ;,$E(X,40)="Total # Patients"
 .S VALMHDR(3)=X
 Q
 ;
INIT ; -- init variables and list array
 I APCLPTS="I" D ICARE
 I APCLPTS="E" D EHR
 Q
ICARE ;
 S APCLDATA=""
 K ^TMP("BQIPLRT",$J)
 D LISTS^BQIPLRT(.APCLDATA)
 K APCLICAR S APCLHIGH="",C=0
 S X=0 F  S X=$O(^TMP("BQIPLRT",$J,X)) Q:X'=+X  D
 .Q:$P(^TMP("BQIPLRT",$J,X),U,2)=""
 .S C=C+1
 .S APCLICAR(C,0)=C_")  "_$P(^TMP("BQIPLRT",$J,X),U,5),$E(APCLICAR(C,0),40)=$P(^TMP("BQIPLRT",$J,X),U,8)
 .S APCLICAR("IDX",C,C)=X
 .Q
 S (VALMCNT,APCLHIGH)=C
 Q
EHR ;
 S APCLDATA=""
 K ^TMP("BQITABLE",$J)
 D TAB^BQIUTB(.APCLDATA,"PERS")
 K APCLICAR S APCLHIGH="",C=0
 S X=0 F  S X=$O(^TMP("BQITABLE",$J,X)) Q:X'=+X  D
 .Q:$P(^TMP("BQITABLE",$J,X),U,2)=""
 .S C=C+1
 .S APCLICAR(C,0)=C_")  "_$P(^TMP("BQITABLE",$J,X),U,2)  ;,$E(APCLICAR(C,0),40)=$P(^TMP("BQITABLE",$J,X),U,8)
 .S APCLICAR("IDX",C,C)=X
 .Q
 S (VALMCNT,APCLHIGH)=C
 Q
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
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
SEL ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
ADD1 W !!
 S DIR(0)="NO^1:"_APCLHIGH,DIR("A")="Which Group"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No group/panel selected." G DISPX
 I $D(DIRUT) W !,"No group/panel selected." G DISPX
 S APCLIEN=$P(APCLICAR("IDX",Y,Y),U,1)
 I APCLPTS="I" S APCLICP=$P(^TMP("BQIPLRT",$J,APCLIEN),U,1)_U_$P(^TMP("BQIPLRT",$J,APCLIEN),U,3)_U_$P(^TMP("BQIPLRT",$J,APCLIEN),U,5)
 I APCLPTS="E" S APCLICP=DUZ_U_$P(^TMP("BQITABLE",$J,X),U,1)_U_$P($P(^TMP("BQITABLE",$J,X),U,2),"_")
 Q
DISPX ;
 D BACK
 Q
