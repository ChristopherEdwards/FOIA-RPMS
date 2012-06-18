BLSELL ; IHS/CMI/LAB - UPDATE TESTS TO EXPORT ; [ 12/19/2002  7:26 AM ]
 ;;5.2;LR;**1015**;NOV 18, 2002
 ;; ;
EN ;EP  -- main entry point for BLS LOINC TO EXPORT
 D EN^VALM("BLS LOINC TO EXPORT")
 D CLEAR^VALM1
 D FULL^VALM1
 D EXIT
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="List of Lab Tests (by LOINC Code) that are currently being"
 S VALMHDR(2)="exported to CDC."
 S VALMHDR(3)="You may add a new code to the list or remove an existing code from the list."
 Q
 ;
INIT ; -- init variables and list array
 K BLSELL S BLSC=0,BLSX=0
 F  S BLSX=$O(^BLSELL(BLSX)) Q:BLSX'=+BLSX  D
 .S BLSC=BLSC+1,BLSELL("IDX",BLSC,BLSC)=BLSX
 .S BLSIEN=$P(^BLSELL(BLSX,0),U),BLSELL(BLSC,0)=BLSC_")",$E(BLSELL(BLSC,0),6)=$P(^LAB(95.3,BLSIEN,0),U),$E(BLSELL(BLSC,0),13)=$P($G(^LAB(95.3,BLSIEN,80)),U)
 S VALMCNT=BLSC
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 D EN^XBVK("BLS")
 D ^XBFMK
 Q
 ;
EXPND ; -- expand code
 Q
 ;
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I D ^XBFMK
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
 W !,"Adding new Lab Test (LOINC code) to the exported lab test list....",!
 D ^XBFMK
 S DIC="^BLSELL(",DIC(0)="AEMQL" D ^DIC
 D BACK
 Q
 ;
REM ;
 D FULL^VALM1
 NEW LIEN
 S LIEN=0
 D EN^VALM2(XQORNOD(0),"OS") ;this list man call allows user to select an entry in list
 I '$D(VALMY) W !,"No Loinc Code selected." G REMX
 S LIEN=$O(VALMY(0)) I 'LIEN K LIEN,VALMY,XQORNOD W !,"No Loinc Code selected." G REMX
 S LIEN=BLSELL("IDX",LIEN,LIEN)
 I '$D(^BLSELL(LIEN,0)) W !,"Not a valid LOINC ENTRY." K LIEN S LIEN=0 G REMX
 W !!,"Deleting LOINC code "_$P(^LAB(95.3,$P(^BLSELL(LIEN,0),U),0),U)_" from list of exported Lab Tests.",!
 S DA=LIEN,DIK="^BLSELL(" D ^DIK
 K DIK
REMX ;
 D EOP
 K DIR
 K LIEN
 D BACK
 Q
 ;
BANNER ;EP
 NEW BLSTEXT,BLSLINE,BLSX,BLSJ,BLS
 S BLSTEXT="TEXT",BLSLINE=3
PRINT W:$D(IOF) @IOF
 F BLSJ=1:1:BLSLINE S BLSX=$T(@BLSTEXT+BLSJ),BLSX=$P(BLSX,";;",2) W !?80-$L(BLSX)\2,BLSX K BLSX
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S BLS("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(BLS("SITE"))\2,BLS("SITE")
XIT ;
 K DIC,DA,X,Y,%Y,%,BLSJ,BLSX,BLSTEXT,BLSLINE,BLS
 Q
TEXT ;
 ;;*****************************
 ;;**   IHS Lab Loinc Menu    **
 ;;*****************************
 ;;QUIT
