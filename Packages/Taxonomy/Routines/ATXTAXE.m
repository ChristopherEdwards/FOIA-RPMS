ATXTAXE ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 D ^XBFMK
 K ATXITEM,ATXX,ATXTAXI,ATXITMI,ATXHIGH,ATXTXLI
 Q
 ;; ;
EN ;EP -- main entry point for
 S DIE="^ATXAX(",DR=".02;5101;1101",DA=ATXTAXI D ^DIE
 ;
 D EN^VALM("ATX TAXONOMY GENERIC EDIT")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
HDR ; -- header code
 S VALMHDR(1)="Updating the "_ATXTAXN_" taxonomy"
 Q
 ;
INIT ; -- init variables and list array
 I ATXFILE=60 D LAB Q
 I $P(^ATXAX(ATXTAXI,0),U,13)!($$ACAN($P(^ATXAX(ATXTAXI,0),U,15))) D CANDISP Q
 K ATXITEM S ATXHIGH="",C=0
 S ATXX=0 F  S ATXX=$O(^ATXAX(ATXTAXI,21,ATXX)) Q:ATXX'=+ATXX  D
 .S C=C+1
 .S ATXITMI=$P(^ATXAX(ATXTAXI,21,ATXX,0),U)
 .I ATXFILE=9999999.05 S ATXITEM(C,0)=C_")  "_ATXITMI I 1
 .E  S ATXITEM(C,0)=C_")  "_$$VAL^XBDIQ1($P(^ATXAX(ATXTAXI,0),U,15),ATXITMI,.01)
 .S ATXITEM("IDX",C,C)=ATXITMI
 .Q
 S (VALMCNT,ATXHIGH)=C
 Q
ACAN(F) ;
 I $G(F)="" Q 0
 I F=80 Q 1
 I F=80.1 Q 1
 I F=81 Q 1
 Q 0
CANDISP ;
 K ATXITEM S ATXHIGH="",C=0
 S ATXX=0 F  S ATXX=$O(^ATXAX(ATXTAXI,21,ATXX)) Q:ATXX'=+ATXX  D
 .S C=C+1
 .S ATXITEM(C,0)=C_")  "_$$STRIP^XLFSTR($P(^ATXAX(ATXTAXI,21,ATXX,0),U)," ")_" - "_$$STRIP^XLFSTR($P(^ATXAX(ATXTAXI,21,ATXX,0),U,2)," ")
 .S $E(ATXITEM(C,0),30)=$S($P(^ATXAX(ATXTAXI,21,ATXX,0),U,3):"   "_$P(^ICDS($P(^ATXAX(ATXTAXI,21,ATXX,0),U,3),0),U,1),1:"")
 .S ATXITEM("IDX",C,C)=ATXX
 .Q
 S (VALMCNT,ATXHIGH)=C
 Q
LAB ;
 K ATXITEM S ATXHIGH="",C=0
 S ATXX=0 F  S ATXX=$O(^ATXLAB(ATXTAXI,21,ATXX)) Q:ATXX'=+ATXX  D
 .S C=C+1
 .S ATXITMI=$P(^ATXLAB(ATXTAXI,21,ATXX,0),U)
 .S ATXITEM(C,0)=C_")  "_$P($G(^LAB(60,ATXITMI,0)),U)
 .S ATXITEM("IDX",C,C)=ATXITMI
 .Q
 S (VALMCNT,ATXHIGH)=C
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
 D FULL^VALM1
 W !
 I ATXFILE=60,$P(^ATXLAB(ATXTAXI,0),U,22) W !!,"The ",$P(^ATXLAB(ATXTAXI,0),U)," Taxonomy is READ ONLY.",!,"You can not update it." D PAUSE G REMX
 I ATXFILE'=60,$P(^ATXAX(ATXTAXI,0),U,22) W !!,"The ",$P(^ATXAX(ATXTAXI,0),U)," Taxonomy is READ ONLY.",!,"You can not update it." D PAUSE G REMX
 I ATXFILE'=60,$P(^ATXAX(ATXTAXI,0),U,5)'=DUZ W !!,"You are not the creator of the ",$P(^ATXAX(ATXTAXI,0),U)," Taxonomy.",!,"Sorry, but you cannot edit it." D PAUSE G REMX
 I ATXFILE=60,$P(^ATXLAB(ATXTAXI,0),U,5)'=DUZ W !!,"You are not the creator of the ",$P(^ATXLAB(ATXTAXI,0),U)," Taxonomy.",!,"Sorry, but you cannot edit it." D PAUSE G REMX
 W ! K DIR
 NEW ATXREMM
 S ATXREMM=1
 I ATXFILE=80 D ICD9ADD G REMX
 I ATXFILE=80.1 D ICD0ADD G REMX
 I ATXFILE=81 D ICPTADD G REMX
 ;I ATXFILE'=60,$P(^ATXTYPE(ATXTAXT,0),U,4)=1 D ICD9ADD G REMX
 S DIR(0)="NO^1:"_ATXHIGH,DIR("A")="Remove Which Item"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No item selected." G REMX
 I $D(DIRUT) W !,"No item selected." G REMX
 S ATXITMI=ATXITEM("IDX",Y,Y)
 ;sure
 I ATXFILE=60 K DIR S DIR(0)="Y",DIR("A")="Are you sure you want to remove the "_$P(^LAB(60,ATXITMI,0),U)_" lab test",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I ATXFILE'=60,ATXTAXT K DIR D
 .S DIR(0)="Y",DIR("A")="Are you sure you want to remove the "_$S(ATXFILE'=9999999.05:$$VAL^XBDIQ1($P(^ATXAX(ATXTAXI,0),U,15),ATXITMI,.01),1:ATXITMI)_" "_$$VAL^XBDIQ1(9002226,ATXTAXI,.15),DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y G REM
 I $D(DIRUT) G REMX
 D ^XBFMK
 I ATXFILE=60 S DA(1)=ATXTAXI,DA=$O(^ATXLAB(ATXTAXI,21,"B",ATXITMI,0)),DIE="^ATXLAB("_ATXTAXI_",21,",DR=".01///@" D ^DIE
 I ATXFILE'=60 S DA(1)=ATXTAXI,DA=$O(^ATXAX(ATXTAXI,21,"B",ATXITMI,0)),DIE="^ATXAX("_ATXTAXI_",21,",DR=".01///@" D ^DIE
REMX ;
 D ^XBFMK
 D BACK
 Q
ADD ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
 W !
 I ATXFILE=60,$P(^ATXLAB(ATXTAXI,0),U,22) W !!,"The ",$P(^ATXLAB(ATXTAXI,0),U)," is READ ONLY.",!,"You can not update it." D PAUSE G ADDX
 I ATXFILE'=60,$P(^ATXAX(ATXTAXI,0),U,22) W !!,"The ",$P(^ATXAX(ATXTAXI,0),U)," is READ ONLY.",!,"You can not update it." D PAUSE G ADDX
 I ATXFILE'=60,$P(^ATXAX(ATXTAXI,0),U,5)'=DUZ W !!,"You are not the creator of the ",$P(^ATXAX(ATXTAXI,0),U)," Taxonomy.",!,"Sorry, but you cannot edit it." D PAUSE G ADDX
 I ATXFILE=60,$P(^ATXLAB(ATXTAXI,0),U,5)'=DUZ W !!,"You are not the creator of the ",$P(^ATXLAB(ATXTAXI,0),U)," Taxonomy.",!,"Sorry, but you cannot edit it." D PAUSE G ADDX
 I ATXFILE=60 D LABADD G ADDX
 I ATXFILE=80 D ICD9ADD G ADDX
 I ATXFILE=80.1 D ICD0ADD G ADDX
 I ATXFILE=81 D ICPTADD G ADDX
 K DIC
 S DIC(0)="AEMQ",DIC=$P(^ATXAX(ATXTAXI,0),U,15) D ^DIC
 I Y=-1 G ADDX
 I $D(^ATXAX(ATXTAXI,21,"B",$S(ATXFILE'=9999999.05:+Y,1:$P(^AUTTCOM(+Y,0),U,1)))) W !!,"That item is already in the taxonomy." H 2 G ADD
 S DA=ATXTAXI
 S (X,ATXTXLI)=+Y
 I ATXFILE=9999999.05 S (X,ATXTXLI)=$P(^AUTTCOM(+Y,0),U)  ;special processing for community
 S ATXFILE=$P(^ATXAX(ATXTAXI,0),U,15)
 S DA(1)=ATXTAXI
 S DIC="^ATXAX("_DA_",21,"
 S DIC(0)="L",DIC("DR")=".02////"_ATXTXLI K DD,DO
 S:'$D(^ATXAX(DA,21,0)) ^ATXAX(DA,21,0)="^9002226.02101A"
 D FILE^DICN
 I '$D(^ATXAX(ATXTAXI,21,"B",ATXTXLI)) W !!,"adding ITEM failed." H 2 G ADD
 G ADDX
LABADD ;
 K DIC
 S DIC(0)="AEMQ",DIC="^LAB(60,",DIC("A")="Which LAB Test: " D ^DIC
 I Y=-1 G ADDX
 S ATXTXLI=+Y
 I '$P(^ATXLAB(ATXTAXI,0),U,11),$O(^LAB(60,ATXTXLI,2,0)) S ATXYN="" D  G:'ATXYN ADDX
 .W !!,"This lab test, ",$P(^LAB(60,ATXTXLI,0),U),", is a panel test and the"
 .W !,"taxonomy ",$P(^ATXLAB(ATXTAXI,0),U)," should not contain panel tests.",!
 .S DIR(0)="Y",DIR("A")="Do you still want to add this lab test to this taxonomy",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .Q:$D(DIRUT)
 .S ATXYN=Y
 I $D(^ATXLAB(ATXTAXI,21,"B",ATXTXLI)) W !!,"Lab test ",$P(^LAB(60,ATXTXLI,0),U)," is already in the taxonomy." H 2 G ADD
 S DA=ATXTAXI
 S X=ATXTXLI
 S DA(1)=ATXTAXI
 S DIC="^ATXLAB("_DA_",21,"
 S DIC(0)="L" K DD,DO
 S:'$D(^ATXLAB(DA,21,0)) ^ATXLAB(DA,21,0)="^9002228.02101PA"
 D FILE^DICN
 I '$D(^ATXLAB(ATXTAXI,21,"B",ATXTXLI)) W !!,"adding lab test failed." H 2 G ADD
ADDX ;
 K DIC,DA,DR,ATXTXLI,DD,DO
 D BACK
 Q
ICD9ADD ;
 D ICD9ADD^ATXTAXF
 Q
ICD0ADD ;
 D ICD9ADD^ATXTAXF
 Q
ICPTADD ;
 D ICPTADD^ATXTAXL
 Q
