BMCVDVD ; IHS/OIT/FCJ - CHECK FOR DUPLICATES WHEN ENTERING NEW VENDOR ;   [ 10/31/2003  12:11 PM ]
 ;;4.0;REFERRED CARE INFO SYSTEM;**5**;JAN 09, 2006
 ;BMC*4.0*5 IHS.OIT.FCJ ORIGIAL ROUTINE FR ACHSVDVD
 ;
EP ;
 I '$D(BMCPROV) G A1^BMCVDV
 K BMCZEIN
 I '$D(^AUTTVNDR(BMCPROV,11)) G END
 S BMCEIN=$P(^AUTTVNDR(BMCPROV,11),U,1)
 I BMCEIN="" G MESSAGE
 ;
 ;got this far, then we know we have an EIN
 ;now check the address
 S BMCYAYA=$G(^AUTTVNDR(BMCPROV,13))
 I $P(BMCYAYA,U,1)=""!($P(BMCYAYA,U,2)="")!($P(BMCYAYA,U,3)="") W !!,"Vendor address incomplete.",!,"Please make sure that at least street, city, and state are complete" H 3 D GETADDR Q:$D(DTOUT)!$D(DUOUT)  G EP
 ;
 ;
 S BMCSUFF=$P(^AUTTVNDR(BMCPROV,11),U,2)
 I BMCSUFF'="" G GETD
 I '$D(^AUTTVNDR("C",BMCEIN)) G GETD
 S X=$O(^AUTTVNDR("C",BMCEIN,0))
 I '$O(^AUTTVNDR("C",BMCEIN,X)) G GETD
 S X=0
 F  S X=$O(^AUTTVNDR("C",BMCEIN,X)) G:X="" WRITE D
 . S BMCUFF=$P($G(^AUTTVNDR(X,11)),U,2)
 . I X'=BMCPROV,BMCSUFF="" S BMCZEIN(X)=BMCEIN
 . I X'=BMCPROV,BMCUFF=BMCSUFF S BMCZEIN(X)=BMCEIN
 .Q
GETD ;
 S BMCEINS=BMCEIN_BMCSUFF,X=0
 I '$D(^AUTTVNDR("E",BMCEINS)) G WRITE
 S X=$O(^AUTTVNDR("E",BMCEINS,X))
 I '$O(^AUTTVNDR("E",BMCEINS,X)) G WRITE
 S X=0
 F  S X=$O(^AUTTVNDR("E",BMCEINS,X)) G WRITE:X="" S:X'=BMCPROV BMCZEIN(X)=BMCEINS
WRITE ;
 I '$D(BMCZEIN),$D(BMCDFLG) Q
 I '$D(BMCZEIN),'$D(BMCDFLG) G A1A^BMCVDV
 W !!?12,*7,*7,"***** The EIN you have entered for this VENDOR is a *****",!?11,"***** duplicate of the EIN for the following VENDOR(S) *****",!!
 S Z=0
 F  S Z=$O(BMCZEIN(Z)) Q:Z=""  W !,$P(^AUTTVNDR(Z,0),U,1),?40,$P(BMCZEIN(Z),U)
CHECK ;
 I '$D(^XUSEC("BMCZVEN",DUZ)) W !!?20,"** Duplicate EIN's are NOT ALLOWED! **",!?15,"Please copy this information and notify your supervisor.",!! G END:'$D(BMCDFLG) S Y=0 G EDIT0
EDIT ;
 W !!?20,"** Duplicate EIN's are NOT ALLOWED! **",!?24,"You MUST enter a UNIQUE EIN or",!?25,"a SUFFIX to an existing EIN."
 I $D(%(0)),'$D(BMCDFLG) G CHOOSE
 K DIR
 S DIR("A")="Do you wish to EDIT NOW",DIR(0)="Y",DIR("B")="NO"
 W !!
 D ^DIR
 K DIR
 G END:$D(DIRUT)&'$D(BMCDFLG)
 ;Check to see if vendor/provider edit option
 I '$D(BMCDFLG),Y=0 G A1A^BMCVDV
 ;Check to see if initial document
EDIT0 ;
 I $D(BMCDFLG),$D(DIRUT) K BMCPROV Q
 I $D(BMCDFLG),Y=0 K BMCPROV Q
 S Y="E"
 G EDIT1
 ;
CHOOSE ;
 W !!!,"Entry for "_$P(^AUTTVNDR(BMCPROV,0),U,1)_"  "_$S($D(BMCEINS):BMCEINS,1:BMCEIN)
 K DIR
 S DIR(0)="S^E:Edit;D:Delete",DIR("B")="Delete"
 D ^DIR
 K DIR
 G EDIT:$D(DUOUT),EDIT:$D(DIROUT),EDIT:$D(DIRUT)
 I Y["D" G DELETE
EDIT1 ;
 I Y["E" W !!,"Edit entry "_$P(^AUTTVNDR(BMCPROV,0),U)_"  "_$S($D(BMCEINS):BMCEINS,1:BMCEIN) W !! S DR="1101;1102",DIE="^AUTTVNDR(",DA=BMCPROV D ^DIE K:$D(Y) BMCPROV
 K BMCEIN,BMCZEIN,BMCSUFF,Z,X,DA,BMCEINS,DIR,DIC,DIE,DIK
 G EP
 ;
DELETE ;
 K DIR
 S DIR(0)="Y",DIR("A")="DELETE entry "_$P(^AUTTVNDR(BMCPROV,0),U,1)_"  "_$S($D(BMCEINS):BMCEINS,1:BMCEIN),DIR("B")="YES"
 D ^DIR
 K DIR
 G:Y=0 EDIT
 S DIK="^AUTTVNDR(",DA=BMCPROV
 W "   ...DELETING..."
 D ^DIK
 G END
MESSAGE ;EP
 U IO
 W !!,"There is no EIN on file for ",$P(^AUTTVNDR(BMCPROV,0),U,1),".",!,"Please edit to continue this process."
 I IOST["C-" K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue..." W !!!! D ^DIR S Y="E" G EDIT1
END ;
 K BMCEIN,BMCZEIN,BMCSUFF,Z,X,DA,BMCEINS,BMCPROV
 G A1^BMCVDV
 ;
GETADDR ;
 ;prompt for and require an address for this provider
 S Y=$$DIR^XBDIR("Y","Edit address now?  ","NO","","","",2)
 I Y=0 S DTOUT=1
 ;
 I $D(DTOUT)!$D(DUOUT) Q
 W !! S DR="1301:1304",DIE="^AUTTVNDR(",DA=BMCPROV D ^DIE
 Q
 ;
VCHK ;
 S BMCVFLG=""
 S BMCTST=$P(Y,U,1)
 F %=1102,1110,1116,1125,1302,1303,1304  D
 . S VAL=$$GET1^DIQ(9999999.11,BMCTST,%,"I")
 . I VAL="" D @(+%)
 K BMCTST
 Q
 ;
1102 W !,"Vendor EIN suffix incomplete",! S BMCVFLG=1 Q
 ;
1110 W !,"Vendor FED/NON-FED field incomplete",! S BMCVFLG=1 Q
 ;
1116 W "Vendor Congressional District incomplete",! S BMCVFLG=1 Q
 ;
1125 W "Vendor Geographical Location incomplete",! S BMCVFLG=1 Q
 ;
1302 W !,"Vendor mailing address city incomplete",! S BMCVFLG=1 Q
 ;
1303 W !,"Vendor mailing address state incomplete",! S BMCVFLG=1 Q
 ;
1304 W !,"Vendor mailing address zip incomplete",! S BMCVFLG=1 Q
