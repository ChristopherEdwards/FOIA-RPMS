APCPPRE ; IHS/TUCSON/LAB - PRE INIT ; [ 04/03/98  08:39 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;;APR 03, 1998
 NEW APCPNAME
 I '$G(DUZ) K DIFQ W $C(7),!,"DUZ UNDEFINED OR 0." Q
 I '$L($G(DUZ(0))) K DIFQ W $C(7),!,"DUZ(0) UNDEFINED OR NULL." Q
 S X=$P(^VA(200,DUZ,0),U),APCPNAME=$P($T(APCPPRE+1),";",4)
 W !!,$$CTR("Hello, "_$P(X,",",2)_" "_$P(X,",")),!,$$CTR("Checking system requirements....")
 I $G(^DD("VERSION"))<21 K DIFQ W $C(7),!,$$CTR("I NEED AT LEAST FILEMAN 21.") Q
 W !,$$CTR("FileMan OK...")
 I $S('$O(^DIC(9.4,"C","XU",0)):1,$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))<7.1:1,1:0) K DIFQ W $C(7),!,$$CTR("I NEED AT LEAST KERNEL 7.1.") Q
 W !,$$CTR("Kernel OK...")
 ;
 D ^APCPPREI
 Q
 ;----------
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
