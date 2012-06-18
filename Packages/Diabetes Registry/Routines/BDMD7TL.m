BDMD7TL ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;; ;
EP(BDMTAXI) ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 I '$D(BDMGUI) D EN^XBVK("BDM")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("BDMD7 TAXONOMY EDIT")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Updating the "_BDMTAXN_" taxonomy"
 Q
 ;
INIT ; -- init variables and list array
 I BDMTAXT="L" D LAB Q
 K BDMLAB S BDMHIGH="",C=0
 S BDMX=0 F  S BDMX=$O(^ATXAX(BDMTAXI,21,BDMX)) Q:BDMX'=+BDMX  D
 .S C=C+1
 .S BDMLABI=$P(^ATXAX(BDMTAXI,21,BDMX,0),U)
 .S BDMLAB(C,0)=C_")  "_$$VAL^XBDIQ1($P(^ATXAX(BDMTAXI,0),U,15),BDMLABI,.01)
 .S BDMLAB("IDX",C,C)=BDMLABI
 .Q
 S (VALMCNT,BDMHIGH)=C
 Q
LAB ;
 K BDMLAB S BDMHIGH="",C=0
 S BDMX=0 F  S BDMX=$O(^ATXLAB(BDMTAXI,21,BDMX)) Q:BDMX'=+BDMX  D
 .S C=C+1
 .S BDMLABI=$P(^ATXLAB(BDMTAXI,21,BDMX,0),U)
 .S BDMLAB(C,0)=C_")  "_$P($G(^LAB(60,BDMLABI,0)),U)
 .S BDMLAB("IDX",C,C)=BDMLABI
 .Q
 S (VALMCNT,BDMHIGH)=C
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
 S DIR(0)="NO^1:"_BDMHIGH,DIR("A")="Remove Which Item"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No item selected." G REMX
 I $D(DIRUT) W !,"No item selected." G REMX
 S BDMLABI=BDMLAB("IDX",Y,Y)
 ;sure
 I BDMTAXT="L" K DIR S DIR(0)="Y",DIR("A")="Are you sure you want to remove the "_$P(^LAB(60,BDMLABI,0),U)_" lab test",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I BDMTAXT="T" K DIR S DIR(0)="Y",DIR("A")="Are you sure you want to remove the "_$$VAL^XBDIQ1($P(^ATXAX(BDMTAXI,0),U,15),BDMLABI,.01)_" "_$$VAL^XBDIQ1(9002226,BDMTAXI,.15),DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y G REM
 I $D(DIRUT) G REMX
 D ^XBFMK
 I BDMTAXT="L" S DA(1)=BDMTAXI,DA=$O(^ATXLAB(BDMTAXI,21,"B",BDMLABI,0)),DIE="^ATXLAB("_BDMTAXI_",21,",DR=".01///@" D ^DIE
 I BDMTAXT="T" S DA(1)=BDMTAXI,DA=$O(^ATXAX(BDMTAXI,21,"B",BDMLABI,0)),DIE="^ATXAX("_BDMTAXI_",21,",DR=".01///@" D ^DIE
REMX ;
 D ^XBFMK
 D BACK
 Q
ADD ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
 W !
 I BDMTAXT="L" D LABADD G ADDX
 K DIC
 S DIC(0)="AEMQ",DIC=$P(^ATXAX(BDMTAXI,0),U,15) D ^DIC
 I Y=-1 G ADDX
 I $D(^ATXAX(BDMTAXI,21,"B",+Y)) W !!,"That item is already in the taxonomy." H 2 G ADD
 S DA=BDMTAXI
 S (X,BDMTXLI)=+Y
 S BDMFILE=$P(^ATXAX(BDMTAXI,0),U,15)
 S DA(1)=BDMTAXI
 S DIC="^ATXAX("_DA_",21,"
 S DIC(0)="L",DIC("DR")=".02////"_BDMTXLI K DD,DO
 S:'$D(^ATXAX(DA,21,0)) ^ATXAX(DA,21,0)="^9002226.02101A"
 D FILE^DICN
 I '$D(^ATXAX(BDMTAXI,21,"B",BDMTXLI)) W !!,"adding ITEM failed." H 2 G ADD
 G ADDX
LABADD ;
 K DIC
 S DIC(0)="AEMQ",DIC="^LAB(60,",DIC("A")="Which LAB Test: " D ^DIC
 I Y=-1 G ADDX
 S BDMTXLI=+Y
 I '$P(^ATXLAB(BDMTAXI,0),U,11),$O(^LAB(60,BDMTXLI,2,0)) S BDMYN="" D  G:'BDMYN ADDX
 .W !!,"This lab test, ",$P(^LAB(60,BDMTXLI,0),U),", is a panel test and the"
 .W !,"taxonomy ",$P(^ATXLAB(BDMTAXI,0),U)," should not contain panel tests.",!
 .S DIR(0)="Y",DIR("A")="Do you still want to add this lab test to this taxonomy",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .Q:$D(DIRUT)
 .S BDMYN=Y
 I $D(^ATXLAB(BDMTAXI,21,"B",+Y)) W !!,"Lab test ",$P(^LAB(60,+Y,0),U)," is already in the taxonomy." H 2 G ADD
 S DA=BDMTAXI
 S X=BDMTXLI
 S DA(1)=BDMTAXI
 S DIC="^ATXLAB("_DA_",21,"
 S DIC(0)="L" K DD,DO
 S:'$D(^ATXLAB(DA,21,0)) ^ATXLAB(DA,21,0)="^9002228.02101PA"
 D FILE^DICN
 I '$D(^ATXLAB(BDMTAXI,21,"B",BDMTXLI)) W !!,"adding lab test failed." H 2 G ADD
ADDX ;
 K DIC,DA,DR,BDMTXLI,DD,DO,BDMFILE
 D BACK
 Q
