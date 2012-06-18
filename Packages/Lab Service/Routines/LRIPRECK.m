LRIPRECK ;SLC/FHS - PRE-INIT ENVIRONMENT CHECK FOR VERSION 5.2 ;10/18/90 13:36 ; 
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
EN ;
 I $G(U)'="^" G DUZ
 I $S('$D(DUZ):1,'$D(^VA(200,+DUZ)):1,'$D(IO):1,1:0) G DUZ
 I $S('$D(DUZ(0)):1,DUZ(0)'="@":1,1:0) G DUZ0
 I $D(^DD(60,0,"VR")),+^DD(60,0,"VR")<5.1 W !,$C(7),"YOU MUST HAVE AT LEAST VERSION 5.1 BEFORE I CAN INIT THIS VERSION ",$P($T(+2),";",3),! K DIFQ Q
EN1 ;
 I $O(^DD(63.04,0)) S GLO="^DD(63.04",GLO1="^XTMP634",CM="," D ENT^LRIGCOPY
 I '$O(^DD(63.04,0)) W !?5,"You must first run the LR63INIT routines ",!!,$C(7) K DIFQ Q
 I '$D(^DD(62.4,.01,0))#2 W !?5,"You must first run ^LAINIT ",!!,$C(7) K DIFQ Q
FIRST ;
 S IOP="HOME",%ZIS="" D ^%ZIS I POP W !,"HOME device is not defined ",! K DIFQ Q
NPC I $G(^DD(60,0,"VR")),$G(^DD(60,0,"VR"))<5.11,$G(^LAB(60,"PREINIT"))'=2 D
 . W !!?5,"You must start the New Person conversion process before doing LRINITS ",!! K DIFQ
 Q:'$D(DIFQ)
GLB ;
 W !!,"Checking for required globals.",!
 F I=60,61,62,62.6,69.9 I '$D(^LAB(I,0))#2 W !,"Global ^LAB("_I_",0) is missing Load Global Tape ",!!,$C(7) K DIFQ Q
 I $D(DIFQ) W !!?10,"Global check complete 'OK' ",!
 I '$O(^LAB(60,0)) W !!?10,"You must load the LABORATORY PACKAGE Globals",!,"Consult your installation guide.",!!,$C(7) K DIFQ Q
 G:$G(^DD(60,0,"VR"))>5.1!('$D(^DD(60,0))) END
 F I=1:1 Q:$P($T(MSG+I),";",3)="END"  W !?5,$P($T(MSG+I),";",3)
 W !!?10,"OK to continue " S %=2 D YN^DICN I %'=1 K DIFQ Q
 Q
MSG ;
 ;;Please ensure that the laboratory service has collected all of 
 ;;workload (AMIS) data to this date. This information will be lost
 ;;after V 5.2 is installed.
 ;;
 ;;Please perform Purge old Orders and Accessions Option. This will
 ;;reduce the conversion time of the install.
 ;;
 ;;Make a copy of your tasked/startup Laboratory options. You will have
 ;;to re-enter the dates and times after the install.
 ;;END
 Q
DUZ W !!?10,"Please log in using access and verify codes",!!,$C(7) K DIFQ Q
DUZ0 W !!?10,"You do not have programmer access in your fileman access code",!!,$C(7) K DIFQ Q
END ;
 Q
