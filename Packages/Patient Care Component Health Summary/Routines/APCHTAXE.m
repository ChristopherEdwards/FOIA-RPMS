APCHTAXE ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
MAJPROC ;EP
 W:$D(IOF) @IOF
 W !!,"This option is used to update the list of CPT codes that"
 W !,"should be included in the History of Surgery component of the"
 W !,"health summary.  This taxonomy should contain only CPT codes"
 W !,"for procedures/surgeries that you would expect to see on the"
 W !,"history of surgery section of the health summary.",!!
 D PAUSE
 S APCHTAXI=$O(^ATXAX("B","APCH HS MAJOR PROCEDURE CPTS",0))
 S APCHFILE=81
 S APCHTAXN=$P(^ATXAX(APCHTAXI,0),U)
 D EN
 Q
MINPROC ;EP
 W:$D(IOF) @IOF
 W !!,"This option is used to update the list of CPT codes that"
 W !,"should be included in the History of MINOR Surgery component of the"
 W !,"health summary.  This taxonomy should contain only CPT codes"
 W !,"for procedures/surgeries that you would expect to see on the"
 W !,"MINOR surgery section of the health summary.",!!
 D PAUSE
 S APCHTAXI=$O(^ATXAX("B","APCH HS MINOR PROCEDURE CPTS",0))
 S APCHFILE=81
 S APCHTAXN=$P(^ATXAX(APCHTAXI,0),U)
 D EN
 Q
EOJ ;EP
 D ^XBFMK
 K APCHITEM,APCHX,APCHTAXI,APCHITMI,APCHHIGH,APCHTXLI,APCHFILE,APCHTAXN
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("APCH TAXONOMY EDIT")
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
 S VALMHDR(1)="Updating the "_APCHTAXN_" taxonomy"
 Q
 ;
INIT ; -- init variables and list array
 I APCHFILE=60 D LAB Q
 I $P(^ATXAX(APCHTAXI,0),U,13) D CANDISP Q
 K APCHITEM S APCHHIGH="",C=0
 S APCHX=0 F  S APCHX=$O(^ATXAX(APCHTAXI,21,APCHX)) Q:APCHX'=+APCHX  D
 .S C=C+1
 .S APCHITMI=$P(^ATXAX(APCHTAXI,21,APCHX,0),U)
 .I APCHFILE=9999999.05 S APCHITEM(C,0)=C_")  "_APCHITMI I 1
 .E  S APCHITEM(C,0)=C_")  "_$$VAL^XBDIQ1($P(^ATXAX(APCHTAXI,0),U,15),APCHITMI,.01)
 .S APCHITEM("IDX",C,C)=APCHITMI
 .Q
 S (VALMCNT,APCHHIGH)=C
 Q
CANDISP ;
 K APCHITEM S APCHHIGH="",C=0
 S APCHX=0 F  S APCHX=$O(^ATXAX(APCHTAXI,21,APCHX)) Q:APCHX'=+APCHX  D
 .S C=C+1
 .S APCHITEM(C,0)=C_")  "_$P(^ATXAX(APCHTAXI,21,APCHX,0),U)_"-"_$P(^ATXAX(APCHTAXI,21,APCHX,0),U,2)
 .S APCHITEM("IDX",C,C)=APCHX
 .Q
 S (VALMCNT,APCHHIGH)=C
 Q
LAB ;
 K APCHITEM S APCHHIGH="",C=0
 S APCHX=0 F  S APCHX=$O(^ATXLAB(APCHTAXI,21,APCHX)) Q:APCHX'=+APCHX  D
 .S C=C+1
 .S APCHITMI=$P(^ATXLAB(APCHTAXI,21,APCHX,0),U)
 .S APCHITEM(C,0)=C_")  "_$P($G(^LAB(60,APCHITMI,0)),U)
 .S APCHITEM("IDX",C,C)=APCHITMI
 .Q
 S (VALMCNT,APCHHIGH)=C
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
 W !!,IORVON,"Please NOTE:",IORVOFF
 W !,"To remove a CPT code from the list you must put a minus sign before"
 W !,"the code.  For example, to remove code 56011 from this taxonomy you must type"
 W !,"-56011 at the ENTER ANOTHER CPT prompt."
 W !
 D PAUSE
 I APCHFILE=60,$P(^ATXLAB(APCHTAXI,0),U,22) W !!,"The ",$P(^ATXLAB(APCHTAXI,0),U)," Taxonomy is READ ONLY.",!,"You can not update it." D PAUSE G REMX
 I APCHFILE'=60,$P(^ATXAX(APCHTAXI,0),U,22) W !!,"The ",$P(^ATXAX(APCHTAXI,0),U)," Taxonomy is READ ONLY.",!,"You can not update it." D PAUSE G REMX
 W ! K DIR
 I APCHFILE=80 D ICD9ADD G REMX
 I APCHFILE=80.1 D ICD0ADD G REMX
 I APCHFILE=81 D ICPTADD G REMX
 ;I APCHFILE'=60,$P(^ATXTYPE(APCHTAXT,0),U,4)=1 D ICD9ADD G REMX
 S DIR(0)="NO^1:"_APCHHIGH,DIR("A")="Remove Which Item"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No item selected." G REMX
 I $D(DIRUT) W !,"No item selected." G REMX
 S APCHITMI=APCHITEM("IDX",Y,Y)
 ;sure
 I APCHFILE=60 K DIR S DIR(0)="Y",DIR("A")="Are you sure you want to remove the "_$P(^LAB(60,APCHITMI,0),U)_" lab test",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I APCHFILE'=60,APCHTAXT K DIR D
 .S DIR(0)="Y",DIR("A")="Are you sure you want to remove the "_$S(APCHFILE'=9999999.05:$$VAL^XBDIQ1($P(^ATXAX(APCHTAXI,0),U,15),APCHITMI,.01),1:APCHITMI)_" "_$$VAL^XBDIQ1(9002226,APCHTAXI,.15),DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y G REM
 I $D(DIRUT) G REMX
 D ^XBFMK
 I APCHFILE=60 S DA(1)=APCHTAXI,DA=$O(^ATXLAB(APCHTAXI,21,"B",APCHITMI,0)),DIE="^ATXLAB("_APCHTAXI_",21,",DR=".01///@" D ^DIE
 I APCHFILE'=60 S DA(1)=APCHTAXI,DA=$O(^ATXAX(APCHTAXI,21,"B",APCHITMI,0)),DIE="^ATXAX("_APCHTAXI_",21,",DR=".01///@" D ^DIE
REMX ;
 D ^XBFMK
 D BACK
 Q
ADD ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
 W !
 I APCHFILE=60,$P(^ATXLAB(APCHTAXI,0),U,22) W !!,"The ",$P(^ATXLAB(APCHTAXI,0),U)," is READ ONLY.",!,"You can not update it." D PAUSE G ADDX
 I APCHFILE'=60,$P(^ATXAX(APCHTAXI,0),U,22) W !!,"The ",$P(^ATXAX(APCHTAXI,0),U)," is READ ONLY.",!,"You can not update it." D PAUSE G ADDX
 I APCHFILE=60 D LABADD G ADDX
 I APCHFILE=80 D ICD9ADD G ADDX
 I APCHFILE=80.1 D ICD0ADD G ADDX
 I APCHFILE=81 D ICPTADD G ADDX
 K DIC
 S DIC(0)="AEMQ",DIC=$P(^ATXAX(APCHTAXI,0),U,15) D ^DIC
 I Y=-1 G ADDX
 I $D(^ATXAX(APCHTAXI,21,"B",$S(APCHFILE'=9999999.05:+Y,1:$P(^AUTTCOM(+Y,0),U,1)))) W !!,"That item is already in the taxonomy." H 2 G ADD
 S DA=APCHTAXI
 S (X,APCHTXLI)=+Y
 I APCHFILE=9999999.05 S (X,APCHTXLI)=$P(^AUTTCOM(+Y,0),U)  ;special processing for community
 S APCHFILE=$P(^ATXAX(APCHTAXI,0),U,15)
 S DA(1)=APCHTAXI
 S DIC="^ATXAX("_DA_",21,"
 S DIC(0)="L",DIC("DR")=".02////"_APCHTXLI K DD,DO
 S:'$D(^ATXAX(DA,21,0)) ^ATXAX(DA,21,0)="^9002226.02101A"
 D FILE^DICN
 I '$D(^ATXAX(APCHTAXI,21,"B",APCHTXLI)) W !!,"adding ITEM failed." H 2 G ADD
 G ADDX
LABADD ;
 K DIC
 S DIC(0)="AEMQ",DIC="^LAB(60,",DIC("A")="Which LAB Test: " D ^DIC
 I Y=-1 G ADDX
 I $D(^ATXLAB(APCHTAXI,21,"B",+Y)) W !!,"Lab test ",$P(^LAB(60,+Y,0),U)," is already in the taxonomy." H 2 G ADD
 S DA=APCHTAXI
 S (X,APCHTXLI)=+Y
 S DA(1)=APCHTAXI
 S DIC="^ATXLAB("_DA_",21,"
 S DIC(0)="L" K DD,DO
 S:'$D(^ATXLAB(DA,21,0)) ^ATXLAB(DA,21,0)="^9002228.02101PA"
 D FILE^DICN
 I '$D(^ATXLAB(APCHTAXI,21,"B",APCHTXLI)) W !!,"adding lab test failed." H 2 G ADD
ADDX ;
 K DIC,DA,DR,APCHTXLI,DD,DO
 D BACK
 Q
ICD9ADD ;
 ;D ICD9ADD^APCHTAXF
 Q
ICD0ADD ;
 ;D ICD0ADD^APCHTAXH
 Q
ICPTADD ;
 D ICPTADD^APCHTAXL
 Q
