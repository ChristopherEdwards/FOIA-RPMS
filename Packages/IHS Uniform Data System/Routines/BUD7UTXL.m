BUD7UTXL ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;9.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 02, 2015;Build 42
 ;; ;
EP(BUDTAXI) ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 D EN^XBVK("BUD")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("BUD 07 TAXONOMY EDIT")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Updating the "_$P(^ATXLAB(BUDTAXI,0),U)_" taxonomy"
 Q
 ;
INIT ; -- init variables and list array
 K BUDLAB S BUDHIGH="",C=0
 S BUDX=0 F  S BUDX=$O(^ATXLAB(BUDTAXI,21,BUDX)) Q:BUDX'=+BUDX  D
 .S C=C+1
 .S BUDLABI=$P(^ATXLAB(BUDTAXI,21,BUDX,0),U)
 .S BUDLAB(C,0)=C_")  "_$P($G(^LAB(60,BUDLABI,0)),U)
 .S BUDLAB("IDX",C,C)=BUDLABI
 .Q
 S (VALMCNT,BUDHIGH)=C
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
REM ;
 W ! K DIR
 S DIR(0)="NO^1:"_BUDHIGH,DIR("A")="Remove Which Lab test"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No lab test selected." G REMX
 I $D(DIRUT) W !,"No lab test selected." G REMX
 S BUDLABI=BUDLAB("IDX",Y,Y)
 ;sure
 K DIR S DIR(0)="Y",DIR("A")="Are you sure you want to remove the "_$P(^LAB(60,BUDLABI,0),U)_" lab test",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y G REM
 I $D(DIRUT) G REMX
 D ^XBFMK
 S DA(1)=BUDTAXI,DA=$O(^ATXLAB(BUDTAXI,21,"B",BUDLABI,0)),DIE="^ATXLAB("_BUDTAXI_",21,",DR=".01///@" D ^DIE
REMX ;
 D ^XBFMK
 D BACK
 Q
ADD ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
 W !
 K DIC
 S DIC(0)="AEMQ",DIC="^LAB(60,",DIC("A")="Which LAB Test: " D ^DIC
 I Y=-1 G ADDX
 I $D(^ATXLAB(BUDTAXI,21,"B",+Y)) W !!,"Lab test ",$P(^LAB(60,+Y,0),U)," is already in the taxonomy." H 2 G ADD
 S DA=BUDTAXI
 S (X,BUDTAXLI)=+Y
 S DA(1)=BUDTAXI
 S DIC="^ATXLAB("_DA_",21,"
 S DIC(0)="L" K DD,DO
 S:'$D(^ATXLAB(DA,21,0)) ^ATXLAB(DA,21,0)="^9002228.02101PA"
 D FILE^DICN
 I '$D(^ATXLAB(BUDTAXI,21,"B",BUDTAXLI)) W !!,"adding lab test failed." H 2 G ADD
ADDX ;
 K DIC,DA,DR,BUDTAXLI,DD,DO
 D BACK
 Q
