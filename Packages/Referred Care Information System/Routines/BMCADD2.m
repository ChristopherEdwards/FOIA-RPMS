BMCADD2 ; IHS/PHXAO/TMJ - display routine referrals ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;; ;
EN ; -- main entry point for BMC GENRET SELECTION ITEMS
 K BMCCSEL,BMCRR
 D EN^VALM("BMC ROUTINE REFERRAL LIST")
 D CLEAR^VALM1
 K BMCDISP,BMCSEL,BMCLIST,C,X,I,K,J,BMCHIGH,BMCCUT,BMCCSEL,BMCCNTL
 K VALMHDR,VALMCNT
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Locally defined routine referral template selection"
 S VALMSG="  +  next screen  - previous screen   ?? help"
 Q
 ;
INIT ; -- init variables and list array
 K BMCDISP,BMCSEL,BMCHIGH,BMCLIST
 S BMCHIGH=0,X=0 F  S X=$O(^BMCRTNRF("B",X)) Q:X=""  S Y=$O(^BMCRTNRF("B",X,0)),BMCHIGH=BMCHIGH+1,BMCSEL(BMCHIGH)=Y
 S BMCCUT=BMCHIGH/2 S:BMCCUT'=(BMCCUT\1) BMCCUT=(BMCCUT\1)+1
 S (C,I)=0,J=1,K=1 F  S I=$O(BMCSEL(I)) Q:I'=+I!($D(BMCDISP(I)))  D
 .S C=C+1,BMCLIST(C,0)=I_") "_$P(^BMCRTNRF(BMCSEL(I),0),U) S BMCDISP(I)="",BMCLIST("IDX",C,C)=""
 .S J=I+BMCCUT I $D(BMCSEL(J)),'$D(BMCDISP(J)) S $E(BMCLIST(C,0),40)=J_") "_$P(^BMCRTNRF(BMCSEL(J),0),U) S BMCDISP(J)=""
 K BMCDISP
 S VALMCNT=C
 Q
 ;
HELP ; -- help code
 D FULL^VALM1
 W:$D(IOF) @IOF
 W !,"Enter an S to Select a Routine Referral Template, Q to Quit",!
 S X="?" D DISP^XQORM1 W !
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
 ;
SELECT ;EP - called from protocol
 S DIR(0)="N^1:"_BMCHIGH_":",DIR("A")="Which Routine Referral Template" K DA D ^DIR K DIR
 I $D(DIRUT) W !,"No items selected." K BMCRR Q
 S BMCRR=+BMCSEL(+Y)
 Q
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
EXIT ; -- exit code
 K BMCDISP
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
