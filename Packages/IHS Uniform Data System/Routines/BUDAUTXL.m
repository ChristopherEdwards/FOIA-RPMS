BUDAUTXL ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;; ;
EP(BUDTAXI,BUDTAXT) ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 D EN^XBVK("BUD")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("BUD 13 TAXONOMY EDIT")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 I BUDTAXT="LAB" S VALMHDR(1)="Updating the "_$P(^ATXLAB(BUDTAXI,0),U)_" taxonomy"
 I BUDTAXT="DRUG" S VALMHDR(1)="Updating the "_$P(^ATXAX(BUDTAXI,0),U)_" taxonomy"
 Q
 ;
INIT ; -- init variables and list array
 K BUDLAB S BUDHIGH="",C=0
 I BUDTAXT="LAB" S BUDX=0 F  S BUDX=$O(^ATXLAB(BUDTAXI,21,BUDX)) Q:BUDX'=+BUDX  D
 .S C=C+1
 .S BUDLABI=$P(^ATXLAB(BUDTAXI,21,BUDX,0),U)
 .S BUDLAB(C,0)=C_")  "_$P($G(^LAB(60,BUDLABI,0)),U)
 .S BUDLAB("IDX",C,C)=BUDLABI
 .Q
 I BUDTAXT="DRUG" S BUDX=0 F  S BUDX=$O(^ATXAX(BUDTAXI,21,BUDX)) Q:BUDX'=+BUDX  D
 .S C=C+1
 .S BUDLABI=$P(^ATXAX(BUDTAXI,21,BUDX,0),U)
 .S BUDLAB(C,0)=C_")  "_$P($G(^PSDRUG(BUDLABI,0)),U)
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
 I BUDTAXT="LAB" S DIR(0)="NO^1:"_BUDHIGH,DIR("A")="Remove Which Lab test"
 I BUDTAXT="DRUG" S DIR(0)="NO^1:"_BUDHIGH,DIR("A")="Remove Which Drug"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No lab test selected." G REMX
 I $D(DIRUT) W !,"No lab test selected." G REMX
 S BUDLABI=BUDLAB("IDX",Y,Y)
 ;sure
 I BUDTAXT="LAB" K DIR S DIR(0)="Y",DIR("A")="Are you sure you want to remove the "_$P(^LAB(60,BUDLABI,0),U)_" lab test",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I BUDTAXT="DRUG" K DIR S DIR(0)="Y",DIR("A")="Are you sure you want to remove the "_$P(^PSDRUG(BUDLABI,0),U)_" DRUG",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y G REM
 I $D(DIRUT) G REMX
 D ^XBFMK
 I BUDTAXT="LAB" S DA(1)=BUDTAXI,DA=$O(^ATXLAB(BUDTAXI,21,"B",BUDLABI,0)),DIE="^ATXLAB("_BUDTAXI_",21,",DR=".01///@" D ^DIE
 I BUDTAXT="DRUG" S DA(1)=BUDTAXI,DA=$O(^ATXAX(BUDTAXI,21,"B",BUDLABI,0)),DIE="^ATXAX("_BUDTAXI_",21,",DR=".01///@" D ^DIE
REMX ;
 D ^XBFMK
 D BACK
 Q
ADD ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
 W !
 K DIC
 I BUDTAXT="LAB" S DIC(0)="AEMQ",DIC="^LAB(60,",DIC("A")="Which LAB Test: " D ^DIC
 I BUDTAXT="DRUG" S DIC(0)="AEMQ",DIC="^PSDRUG(",DIC("A")="Which Drug: " D ^DIC
 I Y=-1 G ADDX
 I BUDTAXT="LAB" I $D(^ATXLAB(BUDTAXI,21,"B",+Y)) W !!,"Lab test ",$P(^LAB(60,+Y,0),U)," is already in the taxonomy." H 2 G ADD
 I BUDTAXT="DRUG" I $D(^ATXAX(BUDTAXI,21,"B",+Y)) W !!,"Drug test ",$P(^PSDRUG(+Y,0),U)," is already in the taxonomy." H 2 G ADD
 S DA=BUDTAXI
 S (X,BUDTAXLI)=+Y
 S DA(1)=BUDTAXI
 I BUDTAXT="LAB" S DIC="^ATXLAB("_DA_",21,"
 I BUDTAXT="DRUG" S DIC="^ATXAX("_DA_",21,"
 S DIC(0)="L" K DD,DO
 I BUDTAXT="LAB" S:'$D(^ATXLAB(DA,21,0)) ^ATXLAB(DA,21,0)="^9002228.02101PA"
 I BUDTAXT="DRUG" S:'$D(^ATXAX(DA,21,0)) ^ATXAX(DA,21,0)="^9002226.02101A"
 D FILE^DICN
 I BUDTAXT="LAB" I '$D(^ATXLAB(BUDTAXI,21,"B",BUDTAXLI)) W !!,"adding lab test failed." H 2 G ADD
 I BUDTAXT="DRUG" I '$D(^ATXAX(BUDTAXI,21,"B",BUDTAXLI)) W !!,"adding DRUG failed." H 2 G ADD
ADDX ;
 K DIC,DA,DR,BUDTAXLI,DD,DO
 D BACK
 Q
