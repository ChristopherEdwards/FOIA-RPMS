ADGVAR ; IHS/ADC/PDW/ENM - VARIABLE SET AND KILL ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;**1012**;MAR 25, 1999
 ;
VERSION ;EP; entry point called by main menu
 ;
L1 D RVON W @IOF W !?31,"*****************",!?27,"**",?50,"**"
L2 W !?24,"**   INDIAN HEALTH SERVICE   **"
 W !?19,"** ADMISSION/DISCHARGE/TRANSFER SYSTEM **"
 S DGX=$O(^DIC(9.4,"C","DG",0))
 I DGX="" W !!,"VERSION ERROR; NOTIFY YOUR SITE MANAGER!",!! Q
VERS W !?24,"**        VERSION ",^DIC(9.4,DGX,"VERSION"),"        **"
 W !?27,"**",?50,"**",!?30,"******************"
 ;
SITE I '$D(DUZ(2)) W !!,"YOU MUST SIGN ON PROPERLY THROUGH THE KERNEL TO USE ADT!" S XQUIT=1 Q
 S DGX=$P($G(^DIC(4,DUZ(2),0)),U) W !!?80-$L(DGX)\2,DGX
 I DGX="" W !!,"INVALID FACILITY; NOTIFY YOUR SITE MANAGER!" S XQUIT="" Q
 S DGSITE=$S($D(^AUTTSITE(1,0)):$P(^(0),U),1:"")
 I DGSITE="" W *7,!!,"ADMITTING FACILITY IS NOT DEFINED",!,"NOTIFY YOUR SITE MANGER" S XQUIT=1 K DGSITE Q
 ;W !,"DGSITE: ",DGSITE
 I DUZ(2)'=DGSITE W *7,!!,"YOU ARE NOT SET TO THE ADMITTING FACILITY",!,"NOTIFY YOUR SITE MANAGER" S XQUIT=1
 K DGSITE,DGX I $D(XQUIT) G QUIT
 ;
VAR ;PEP;***> set package variables from site parameter file
 ; -- can be called by other packages that need to check
 ;      mas parameters
 I '$D(^DG(43,1,9999999))!('$D(^DG(43,1,9999999.01))) W !!,*7,?20,"ADT Site Parameters are not set up!",!?10,"DO NOT use ADT until System Definition has been completed!",!! G QUIT
 S DGOPT("GEN")=^DG(43,1,9999999),DGOPT("QA")=^DG(43,1,9999999.01)
 ;S DGOPT("QA1")=^DG(43,1,9999999.02)  ;cmi/maw 06/15/2010 PATCH 1012 not in data dictionary
 Q
 ;
QUIT ;PEP - kill variables and quit
 K DGAB,DGAB9,DGAS,DGAU,DGDE,DGDEWA,DGDIR,DGDIS,DGDOM,DGFA,DGFA9
 K DGFS,DGFU,DGHEM,DGNHCU,DGOP,DGREH,DGTI,DGTO,DGU,L,MASD,MASDEV
 K PARA,USER,STR,STR1,DGV
 K DGOPT,DGZRVN,DGZRVF Q  ;kill IHS package-wide variables
 ;
MENU ;ENTRY POINT  >>> entry action for all submenus
 S ADG("TITLE")=$P($G(XQY0),U,2)
 I $L(ADG("TITLE"))>2 W @IOF,!!?80-$L(ADG("TITLE"))/2,ADG("TITLE")
 S X=$P($G(^DIC(4,DUZ(2),0)),U)
 W !!?80-$L(X)\2,"(",X,")"
 K ADG
 Q
 ;
PRTOPT ;ENTRY POINT  >>> exit action for print options
 NEW X,Y,Z
 Q:IOST'["C-"
 K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR W @IOF
 K DIR Q
 ;
RVON ;EP;***> set reverse video variables
 S (DGZRVN,DGZRVF)="" I '$D(IO) S IO=""
 I IO="" S IOP="" D ^%ZIS
 I $D(^%ZIS(2,IOST(0),5)) S DGZRVN=$P(^(5),U,4),DGZRVF=$P(^(5),U,5)
 Q
