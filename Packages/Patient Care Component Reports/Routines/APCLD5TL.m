APCLD5TL ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;; ;
EP(APCLTAXI) ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 D EN^XBVK("APCL")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("APCLD5 TAXONOMY EDIT")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Updating the "_APCLTAXN_" taxonomy"
 Q
 ;
INIT ; -- init variables and list array
 I APCLTAXT="L" D LAB Q
 K APCLLAB S APCLHIGH="",C=0
 S APCLX=0 F  S APCLX=$O(^ATXAX(APCLTAXI,21,APCLX)) Q:APCLX'=+APCLX  D
 .S C=C+1
 .S APCLLABI=$P(^ATXAX(APCLTAXI,21,APCLX,0),U)
 .S APCLLAB(C,0)=C_")  "_$$VAL^XBDIQ1($P(^ATXAX(APCLTAXI,0),U,15),APCLLABI,.01)
 .S APCLLAB("IDX",C,C)=APCLLABI
 .Q
 S (VALMCNT,APCLHIGH)=C
 Q
LAB ;
 K APCLLAB S APCLHIGH="",C=0
 S APCLX=0 F  S APCLX=$O(^ATXLAB(APCLTAXI,21,APCLX)) Q:APCLX'=+APCLX  D
 .S C=C+1
 .S APCLLABI=$P(^ATXLAB(APCLTAXI,21,APCLX,0),U)
 .S APCLLAB(C,0)=C_")  "_$P($G(^LAB(60,APCLLABI,0)),U)
 .S APCLLAB("IDX",C,C)=APCLLABI
 .Q
 S (VALMCNT,APCLHIGH)=C
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
 S DIR(0)="NO^1:"_APCLHIGH,DIR("A")="Remove Which Item"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No item selected." G REMX
 I $D(DIRUT) W !,"No item selected." G REMX
 S APCLLABI=APCLLAB("IDX",Y,Y)
 ;sure
 I APCLTAXT="L" K DIR S DIR(0)="Y",DIR("A")="Are you sure you want to remove the "_$P(^LAB(60,APCLLABI,0),U)_" lab test",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I APCLTAXT="T" K DIR S DIR(0)="Y",DIR("A")="Are you sure you want to remove the "_$$VAL^XBDIQ1($P(^ATXAX(APCLTAXI,0),U,15),APCLLABI,.01)_" "_$$VAL^XBDIQ1(9002226,APCLTAXI,.15),DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y G REM
 I $D(DIRUT) G REMX
 D ^XBFMK
 I APCLTAXT="L" S DA(1)=APCLTAXI,DA=$O(^ATXLAB(APCLTAXI,21,"B",APCLLABI,0)),DIE="^ATXLAB("_APCLTAXI_",21,",DR=".01///@" D ^DIE
 I APCLTAXT="T" S DA(1)=APCLTAXI,DA=$O(^ATXAX(APCLTAXI,21,"B",APCLLABI,0)),DIE="^ATXAX("_APCLTAXI_",21,",DR=".01///@" D ^DIE
REMX ;
 D ^XBFMK
 D BACK
 Q
ADD ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
 W !
 I APCLTAXT="L" D LABADD G ADDX
 K DIC
 S DIC(0)="AEMQ",DIC=$P(^ATXAX(APCLTAXI,0),U,15) D ^DIC
 I Y=-1 G ADDX
 I $D(^ATXAX(APCLTAXI,21,"B",+Y)) W !!,"That item is already in the taxonomy." H 2 G ADD
 S DA=APCLTAXI
 S (X,APCLTXLI)=+Y
 S APCLFILE=$P(^ATXAX(APCLTAXI,0),U,15)
 S DA(1)=APCLTAXI
 S DIC="^ATXAX("_DA_",21,"
 S DIC(0)="L",DIC("DR")=".02////"_APCLTXLI K DD,DO
 S:'$D(^ATXAX(DA,21,0)) ^ATXAX(DA,21,0)="^9002226.02101A"
 D FILE^DICN
 I '$D(^ATXAX(APCLTAXI,21,"B",APCLTXLI)) W !!,"adding ITEM failed." H 2 G ADD
 G ADDX
LABADD ;
 K DIC
 S DIC(0)="AEMQ",DIC="^LAB(60,",DIC("A")="Which LAB Test: " D ^DIC
 I Y=-1 G ADDX
 S APCLTXLI=+Y
 I '$P(^ATXLAB(APCLTAXI,0),U,11),$O(^LAB(60,APCLTXLI,2,0)) S APCLYN="" D  G:'APCLYN ADDX
 .W !!,"This lab test, ",$P(^LAB(60,APCLTXLI,0),U),", is a panel test and the"
 .W !,"taxonomy ",$P(^ATXLAB(APCLTAXI,0),U)," should not contain panel tests.",!
 .S DIR(0)="Y",DIR("A")="Do you still want to add this lab test to this taxonomy",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .Q:$D(DIRUT)
 .S APCLYN=Y
 I $D(^ATXLAB(APCLTAXI,21,"B",+Y)) W !!,"Lab test ",$P(^LAB(60,+Y,0),U)," is already in the taxonomy." H 2 G ADD
 S DA=APCLTAXI
 S X=APCLTXLI
 S DA(1)=APCLTAXI
 S DIC="^ATXLAB("_DA_",21,"
 S DIC(0)="L" K DD,DO
 S:'$D(^ATXLAB(DA,21,0)) ^ATXLAB(DA,21,0)="^9002228.02101PA"
 D FILE^DICN
 I '$D(^ATXLAB(APCLTAXI,21,"B",APCLTXLI)) W !!,"adding lab test failed." H 2 G ADD
ADDX ;
 K DIC,DA,DR,APCLTXLI,DD,DO,APCLFILE
 D BACK
 Q
