LR7OENV ; IHS/DIR/FJE - Environment check routine for patch LR*5.2*120 ;
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;**120**;Apr 18, 1996
 ;
EN ;Enter here for environmental installation check
 I $S('($D(DUZ)#2):1,'($D(DUZ(0))#2):1,'DUZ:1,1:0) W !!,*7,">>>  DUZ and DUZ(0) must be defined as an active user to initialize.",!,"     Please setup these parameters (Sign-on) before continuing.",! S XPDQUIT=1 Q
 I DUZ(0)'="@" W !!,*7,">>>  You must have programmer access (DUZ(0)=@) to run this init.",! S XPDQUIT=1 Q
 I +$G(^DD(60,0,"VR"))<5.2 W !!,*7,">>>  You must at least be running Lab 5.2 to continue.",! S XPDQUIT=1 Q
 I +$G(^DD(200,0,"VR"))<7.1 W !!,*7,">>>  You must at least be running KERNEL 7.1 to continue.",! S XPDQUIT=1 Q
 Q
