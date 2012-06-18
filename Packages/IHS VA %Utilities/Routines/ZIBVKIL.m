ZIBVKIL ; IHS/ADC/GTH - BUILD A KILL VARIABLE ROUTINE ; [ 11/04/97  10:26 AM ]
 ;;3.0;IHS/VA UTILITIES;**4**;FEB 07, 1997
 ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 ;
 ; Build a name space variable killer routine in ^.ns.KVAR.
 ;
 ; Select a %INDEX host file summary from which to build the
 ; routine.  Select a name space for the variables and the
 ; routine to be built.  Enter any package wide variables.
 ;
 ; Add D ^.ns.VKL0 to all menu exit actions where package
 ; variables are to remain.
 ;
 ; Add D KILL^XUSCLEAN to the exit of all other menus.
 ;
 ; I $P(^%ZOSF("OS"),"-",1)'="MSM" W !,*7,"OPERATING SYSTEM '",$P(^%ZOSF("OS"),"-",1),"' NOT SUPPORTED." Q ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 I $P(^%ZOSF("OS"),"^",1)'["MSM" W !,*7,"OPERATING SYSTEM '",$P(^%ZOSF("OS"),"^",1),"' NOT SUPPORTED." Q  ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 ;
 D HOME^%ZIS
 NEW XBNS
NS ;
 KILL DIR
 S DIR(0)="F^2:4",DIR("A")="Name Space - or ' ^ 'to exit"
 D ^DIR
 I X="^" G EXIT
 I Y="" G NS
 I '$D(^DIC(9.4,"C",Y)) W !,"NO PACKAGE ??",! G NS
 S XBNS=Y
PKGVAR ;
 KILL DIR
 S DIR(0)="F^0:235",DIR("A")="List of Package Wide Variables or '^' to bypass",DIR("?")="LIST var1,var2, ... "
 D ^DIR
 I Y'="^" F XBI=1:1 S X=$P(Y,",",XBI) Q:X=""  S XBVPKG(X)=""
KROU ;
 KILL DIR
 S DIR(0)="F^0:235",DIR("A")="List of other Kill routines to chain",DIR("?")=" ^ROU1,^ROU2, ... with '^'s"
 D ^DIR
 I Y]"",Y'="^"  F XBI=1:1 S XBROU=$P(Y,",",XBI) Q:XBROU=""  S X=$P(XBROU,"^",2) D
 . I X="" W !,XBROU,"   error in list >> ",Y G KROU
 . X ^%ZOSF("TEST")
 . I '$T W !,X,"   error in list >> ",Y G KROU
 .Q
 I Y]"" S XBKROU=" D "_Y
 D ^XBVCHV
 I '$D(^XBVROU($J)) W !,"NO FILE ??",! G NS
S ;
 F I=1:1 Q:'$T(@I)  S XBLD(I)=$P($T(@I),";;",2,99)
 X XBLD(1)
EXIT ;
 D KILL^XUSCLEAN
 KILL ^XBVROU($J),XBKROU,XBLD
 W !,"REMEMBER TO EDIT THE TOP LINES OF THE ROUTINES CREATED !",!!
 Q
 ;
1 ;;S XBNUM=0 X XBLD(2),XBLD(3),XBLD(4),XBLD(6) ZS @XBROU W !,XBROU," Saved ",!!
2 ;;ZR  S XBROU=XBNS_"VKL"_XBNUM,X=XBROU_" ; - kill variables",XBLNS=$L(XBNS) ZI X S X=" ;;" ZI X
3 ;;S XBVAR=XBNS,XBHD=" K ",X=" K " F  S XBVAR=$O(^XBVROU($J,"V",XBVAR)) Q:$E(XBVAR,1,XBLNS)'=XBNS  I '$D(XBVPKG(XBVAR)) S X=X_XBVAR_"," S XBLX=$L(X) I XBLX>235 S X=$E(X,1,XBLX-1) ZI X S X=" K " X ^%ZOSF("SIZE") I Y>3000 X XBLD(5),XBLD(2)
4 ;;S XBLX=$L(X) I XBLX>3 S X=$E(X,1,XBLX-1) ZI X
5 ;;S XBNUM=XBNUM+1 S X=" D ^"_XBNS_"VKL"_XBNUM ZI X ZS @XBROU W !,XBROU," Saved",!!
6 ;;I $D(XBKROU) S X=XBKROU ZI X W !,"ADDING ",X,!
