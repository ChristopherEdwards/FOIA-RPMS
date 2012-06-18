ACHSVDVD ; IHS/ITSC/PMF - CHECK FOR DUPLICATES WHEN ENTERING NEW VENDOR ;   [ 10/31/2003  12:11 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**6**;JUN 11, 2001
 ;ITS/SET/JVK ACHS*3.1*6 TEST FOR COMPLETE VENDOR INFO 4/14/2003
 ;
EP ;
 K ACHSZEIN,ACHSEIN,ACHSSUFF,ACHSUFF,X,ACHSEINS,Z
 I '$D(ACHSPROV) G A1^ACHSVDV
 K ACHSZEIN
 I '$D(^AUTTVNDR(ACHSPROV,11)) G END
 S ACHSEIN=$P(^AUTTVNDR(ACHSPROV,11),U,1)
 I ACHSEIN="" G MESSAGE
 ;
 ;got this far, then we know we have an EIN
 ;now check the address
 S ACHSYAYA=$G(^AUTTVNDR(ACHSPROV,13))
 I $P(ACHSYAYA,U,1)=""!($P(ACHSYAYA,U,2)="")!($P(ACHSYAYA,U,3)="") W !!,"Vendor address incomplete.",!,"Please make sure that at least street, city, and state are complete" H 3 D GETADDR Q:$D(DTOUT)!$D(DUOUT)  G EP
 ;
 ;
 S ACHSSUFF=$P(^AUTTVNDR(ACHSPROV,11),U,2)
 I ACHSSUFF'="" G GETD
 I '$D(^AUTTVNDR("C",ACHSEIN)) G GETD
 S X=$O(^AUTTVNDR("C",ACHSEIN,0))
 I '$O(^AUTTVNDR("C",ACHSEIN,X)) G GETD
 S X=0
 F  S X=$O(^AUTTVNDR("C",ACHSEIN,X)) G:X="" WRITE D
 . S ACHSUFF=$P($G(^AUTTVNDR(X,11)),U,2)
 . I X'=ACHSPROV,ACHSSUFF="" S ACHSZEIN(X)=ACHSEIN
 . I X'=ACHSPROV,ACHSUFF=ACHSSUFF S ACHSZEIN(X)=ACHSEIN
 .Q
GETD ;
 S ACHSEINS=ACHSEIN_ACHSSUFF,X=0
 I '$D(^AUTTVNDR("E",ACHSEINS)) G WRITE
 S X=$O(^AUTTVNDR("E",ACHSEINS,X))
 I '$O(^AUTTVNDR("E",ACHSEINS,X)) G WRITE
 S X=0
 F  S X=$O(^AUTTVNDR("E",ACHSEINS,X)) G WRITE:X="" S:X'=ACHSPROV ACHSZEIN(X)=ACHSEINS
WRITE ;
 I '$D(ACHSZEIN),$D(ACHSDFLG) Q
 I '$D(ACHSZEIN),'$D(ACHSDFLG) G A1A^ACHSVDV
 W !!?12,*7,*7,"***** The EIN you have entered for this VENDOR is a *****",!?11,"***** duplicate of the EIN for the following VENDOR(S) *****",!!
 S Z=0
 F  S Z=$O(ACHSZEIN(Z)) Q:Z=""  W !,$P(^AUTTVNDR(Z,0),U,1),?40,$P(ACHSZEIN(Z),U)
CHECK ;
 I '$D(^XUSEC("ACHSZMGR",DUZ)) W !!?20,"** Duplicate EIN's are NOT ALLOWED! **",!?15,"Please copy this information and notify your supervisor.",!! G END:'$D(ACHSDFLG) S Y=0 G EDIT0
EDIT ;
 W !!?20,"** Duplicate EIN's are NOT ALLOWED! **",!?24,"You MUST enter a UNIQUE EIN or",!?25,"a SUFFIX to an existing EIN."
 I $D(%(0)),'$D(ACHSDFLG) G CHOOSE
 K DIR
 S DIR("A")="Do you wish to EDIT NOW",DIR(0)="Y",DIR("B")="NO"
 W !!
 D ^DIR
 K DIR
 G END:$D(DIRUT)&'$D(ACHSDFLG)
 ;Check to see if vendor/provider edit option
 I '$D(ACHSDFLG),Y=0 G A1A^ACHSVDV
 ;Check to see if initial document
EDIT0 ;
 I $D(ACHSDFLG),$D(DIRUT) K ACHSPROV Q
 I $D(ACHSDFLG),Y=0 K ACHSPROV Q
 S Y="E"
 G EDIT1
 ;
CHOOSE ;
 W !!!,"Entry for "_$P(^AUTTVNDR(ACHSPROV,0),U,1)_"  "_$S($D(ACHSEINS):ACHSEINS,1:ACHSEIN)
 K DIR
 S DIR(0)="S^E:Edit;D:Delete",DIR("B")="Delete"
 D ^DIR
 K DIR
 G EDIT:$D(DUOUT),EDIT:$D(DIROUT),EDIT:$D(DIRUT)
 I Y["D" G DELETE
EDIT1 ;
 I Y["E" W !!,"Edit entry "_$P(^AUTTVNDR(ACHSPROV,0),U)_"  "_$S($D(ACHSEINS):ACHSEINS,1:ACHSEIN) W !! S DR="1101;1102",DIE="^AUTTVNDR(",DA=ACHSPROV D ^DIE K:$D(Y) ACHSPROV
 K ACHSEIN,ACHSZEIN,ACHSSUFF,Z,X,DA,ACHSEINS,DIR,DIC,DIE,DIK
 G EP
 ;
DELETE ;
 K DIR
 S DIR(0)="Y",DIR("A")="DELETE entry "_$P(^AUTTVNDR(ACHSPROV,0),U,1)_"  "_$S($D(ACHSEINS):ACHSEINS,1:ACHSEIN),DIR("B")="YES"
 D ^DIR
 K DIR
 G:Y=0 EDIT
 S DIK="^AUTTVNDR(",DA=ACHSPROV
 W "   ...DELETING..."
 D ^DIK
 G END
MESSAGE ;EP
 U IO
 W !!,"There is no EIN on file for ",$P(^AUTTVNDR(ACHSPROV,0),U,1),".",!,"Please edit to continue this process."
 I IOST["C-" K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue..." W !!!! D ^DIR S Y="E" G EDIT1
END ;
 K ACHSEIN,ACHSZEIN,ACHSSUFF,Z,X,DA,ACHSEINS,ACHSPROV
 G A1^ACHSVDV
 ;
GETADDR ;
 ;prompt for and require an address for this provider
 S Y=$$DIR^XBDIR("Y","Edit address now?  ","NO","","","",2)
 I Y=0 S DTOUT=1
 ;
 I $D(DTOUT)!$D(DUOUT) Q
 W !! S DR="1301:1304",DIE="^AUTTVNDR(",DA=ACHSPROV D ^DIE
 Q
 ;
VCHK ;
 ;IHS/SET/JVK ACHS*3.1*6 4/14/2003
 ;ENTRY POINT FROM ACHSA1
 ;ADDED THIS SECTION AS TEST FOR COMPLETE VENDOR EIN INFO
 S ACHSVFLG=""
 S ACHSTST=$P(Y,U,1)
 F %=1102,1110,1116,1125,1302,1303,1304  D
 . S VAL=$$GET1^DIQ(9999999.11,ACHSTST,%,"I")
 . I VAL="" D @(+%)
 . Q
 K ACHSTST
 Q
 ;
1102 W !,"Vendor EIN suffix incomplete",! S ACHSVFLG=1 Q
 ;
1110 W !,"Vendor FED/NON-FED field incomplete",! S ACHSVFLG=1 Q
 ;
1116 W "Vendor Congressional District incomplete",! S ACHSVFLG=1 Q
 ;
1125 W "Vendor Geographical Location incomplete",! S ACHSVFLG=1 Q
 ;
1302 W !,"Vendor mailing address city incomplete",! S ACHSVFLG=1 Q
 ;
1303 W !,"Vendor mailing address state incomplete",! S ACHSVFLG=1 Q
 ;
1304 W !,"Vendor mailing address zip incomplete",! S ACHSVFLG=1 Q
 ;IHS/SET/JVK ACHS*3.1*6 END NEW CODE
