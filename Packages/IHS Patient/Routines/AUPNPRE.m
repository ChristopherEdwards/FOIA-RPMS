AUPNPRE ; IHS/CMI/LAB - AUPN ENV CHECK ;
 ;;99.1;IHS DICTIONARIES (PATIENT);;MAR 09, 1999
 ;;
 ;
 ;THANKS GEORGE HUGGINS FOR THIS ROUTINE
 I '$G(DUZ) K DIFQ W $C(7),!,"DUZ UNDEFINED OR 0." Q
 ;
 I '$L($G(DUZ(0))) K DIFQ W $C(7),!,"DUZ(0) UNDEFINED OR NULL." Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$C("Hello, "_$P(X,",",2)_" "_$P(X,",")),!,$$C("Checking Environment....")
 ;
 I $G(^DD("VERSION"))<21 K DIFQ W $C(7),!,$$C("I NEED AT LEAST FILEMAN 21.") Q
 W !,$$C("FileMan OK...")
 ;
 I $G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))<8 K DIFQ W $C(7),!,$$C("I NEED AT LEAST KERNEL 8.") Q
 W !,$$C("Kernel OK...")
 ;
 Q
C(X,Y) ;EP
 S %=$S($D(Y):Y,$D(IOM):IOM,1:80)
 Q $J("",%-$L(X)\2)_X
