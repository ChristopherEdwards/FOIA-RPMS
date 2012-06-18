APCDELH ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;; ;
EP ;ep - called from option
 W:$D(IOF) @IOF
 W !!,"This option allows you to enter historical information about the patient",!,"using the historical mnemonics.",!
 D GETPAT
 I '$G(APCDPAT) D EXIT Q
EN ; -- main entry point for APCD EL HISTORICAL ITEMS
 D EN^VALM("APCD EL HISTORICAL ITEMS")
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="This is a test header for APCD EL HISTORICAL ITEMS."
 S VALMHDR(2)="This is the second line"
 Q
 ;
GETPAT ; GET PATIENT
 W !
 S APCDPAT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 I $D(APCDPARM),$P(APCDPARM,U,3)="Y" W !?25,"Ok" S %=1 D YN^DICN Q:%'=1
 S APCDPAT=+Y
 Q
INIT ; -- init variables and list array
 F LINE=1:1:30 D SET^VALM10(LINE,LINE_"     Line number "_LINE)
 S VALMCNT=30
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
