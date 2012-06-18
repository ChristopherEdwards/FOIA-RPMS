AZHZCL1 ;DSD/PDW - PERFORM PRINTS,SETS,PULLS ; AUGUST 14, 1992
 ;;1.0;AZHZ;;AUG 14, 1992
 ;;
DOIT ;ENTRY POINT  ; Loop through Compiled Edits global for Prints, Set edits, or Restore Data Base depending on the variables AZHZHIT,AZHZSET
 Q:(DUOUT!DFOUT)  ;-----
 S AZHZ("B")="" I $D(^AZHZTEMP("LDFN")),+^AZHZTEMP("LDFN") S DFN=^("LDFN"),AZHZ("B")=^(DFN)
 F AZHZCC=1:1 S AZHZ("B")=$O(^AZHZTEMP("B",AZHZ("B"))) Q:(DFOUT!DUOUT)  Q:AZHZ("B")=""  S DFN=0 F  S DFN=$O(^AZHZTEMP("B",AZHZ("B"),DFN)) Q:(DFOUT!DUOUT)  Q:'DFN  D  S ^AZHZTEMP("LDFN")=DFN
 .U IO D AZHZPG W:'AZHZHIT !,^AZHZTEMP(DFN),?35,DFN
 .;rescan prior to sets to insure old data still fails input transforms
 .I AZHZHIT,AZHZSET="N" K ^AZHZTEMP(DFN) D SCDFN^AZHZCL Q:'$D(^AZHZTEMP(DFN))  ;-----
 .F AZHZN="I","V" D DOIT2
 .D OTH
 .U IO D AZHZPG W:'(AZHZCC#100) "."
 K ^AZHZTEMP("LDFN")
 Q  ;----
 ;---------------------------------------------------------------------
DOIT2 ; perform edits/prints
 Q:(DUOUT!DFOUT)  ;-----
 S AZHZFLD="",DR="" F  S AZHZFLD=$O(^AZHZTEMP(DFN,AZHZN,AZHZFLD)) Q:(DFOUT!DUOUT)  Q:'AZHZFLD  D
 .S AZHZX1=^(AZHZFLD,"O"),AZHZX2=^("N"),AZHZX=^(AZHZSET) S:AZHZX="" AZHZX="@"
 .I AZHZHIT,AZHZSET="O",AZHZX="@",((AZHZFLD=1110)!(AZHZFLD=1112)) S AZHZP=$S(AZHZFLD=1110:10,1:12),$P(^AUPNPAT(DFN,11),U,AZHZP)="" ; hard set necessary to delete these fields
 .E  S DR=DR_";"_AZHZFLD_"////"_AZHZX
 .U IO D AZHZPG W:'AZHZHIT !,?5,AZHZT(AZHZFLD),?15,":",AZHZX1,?45,":",AZHZX2
 .I $L(DR)>200 D DRDIE
 I $L(DR) D DRDIE
 Q  ;----
 ;---------------------------------------------------------------------
DRDIE S DIE=$S(AZHZN="I":"^AUPNPAT(",1:"^DPT("),DA=DFN,DR=$E(DR,2,999) S:DIE["AUPN" DR=DR_";.03////"_DT D:AZHZHIT ^DIE ;W !,?15,DIE,DA," ",DR
 S DR=""
EDOIT Q  ;-----
 ;---------------------------------------------------------------------
OTH ;EP perform print/set of 'other names'
 Q:(DFOUT!DUOUT)  Q:'$D(^AZHZTEMP(DFN,"OTHER"))
 S DA=0 F  S DA=$O(^AZHZTEMP(DFN,"OTHER",DA)) Q:(DFOUT!DUOUT)  Q:'DA  S AZHZX=^AZHZTEMP(DFN,"OTHER",DA,.01,AZHZSET) S:AZHZX="" AZHZX="@" S DR=".01////"_AZHZX,AZHZX1=^("O"),AZHZX2=^("N") D
 .U IO D AZHZPG W:'AZHZHIT !,?5,"OTHER",?15,":",AZHZX1,?45,":",AZHZX2
 .S DA(1)=DFN,DIE="^DPT("_DFN_",.01," D:AZHZHIT ^DIE
 .;W !,?15,DIE,DA," ",DR
EOTH Q  ;-----
 ;---------------------------------------------------------------------
INIT ;ENTRY POINT ; INITIALIZE PARAMETERS
 S:'$D(DUOUT) DUOUT=0 S:'$D(DFOUT) DFOUT=0
 Q:(DUOUT!DFOUT)  ;-----
 Q:'$D(^AUTTSITE(1,0))  S AZHZSITE=+^(0),U="^"
 I '$D(AZHZIOP) S IOP="HOME" D ^%ZIS,DT^DICRW
 I '$D(AZHZIOP) S %ZIS="Q" D ^%ZIS I POP S (DFOUT,DUOUT)=1 Q
 S IOM=80
 I $D(IO("Q")) D QUE^AZHZCLN S (DFOUT,DUOUT)=1 Q
 K AZHZPG D AZHZHDR W !,"Starting at " D ^%T W "    " D ^%D W !
 S AZHZX=$T(INITT) F I=2:1 S AZHZX1=$P(AZHZX,";;",I) Q:AZHZX1=""  S AZHZX2=$P(AZHZX1,"^"),AZHZT(AZHZX2)=$P(AZHZX1,"^",2)
 S (DUOUT,DFOUT)=0
 Q  ;-----
INITT ;;.01^NAME;;.09^SSN;;.111^ADD L1;;.112^ADD L2;;.113^ADD L3;;.114^ADD L4;;.211^NOK;;.2401^FA NAM;;.2402^MO NAM;;.2403^MO MAD;;1112^ELIG;;1109^TR QT;;1110^IN QT;;.331^EMR CON
 ;---------------------------------------------------------------------
EXIT ;ENTRY POINT kill variables and exit
 U IO W !,"FINISHED AT " D ^%T H 3 K AZHZHDR D AZHZHDR I '$D(AZHZIOP) D ^%ZISC
 K AZHZ,AZHZ11,AZHZB,AZHZCC,AZHZDAT,AZHZDR,AZHZDT,AZHZFAC,AZHZFACC,AZHZFLD,AZHZFLDN,AZHZGL,AZHZHDR,AZHZHIT,AZHZL,AZHZLFAC,AZHZLINE,AZHZLS,AZHZN,AZHZNODE,AZHZODR,AZHZAAP,AZHZAS
 K AZHZP,AZHZPG,AZHZQI,AZHZQT,AZHZQTF,AZHZQTS,AZHZRUN,AZHZSET,AZHZSITE,AZHZT,AZHZTP,AZHZTS,AZHZX,AZHZX1,AZHZX2,AZHZZ
 K AZHZASN,AZHZD,AZHZIEN,AZHZPN,AZHZQIS,AZHZS,AZHZSAN,AZHZXX,AZHZUSR,AZHZSASN,IEN,X,X1,X2,Y,I,AZHZVCC,%X,%Y
 K AZHZRTN,AZHZX3,DUOUT,DFOUT,%,AZHZNAM,AZHZFN,AZHZLN,AZHZMN,AGOPT,AZHZBZ,AZHZXC
EEXIT Q
 ;---------------------------------------------------------------------
AZHZPG ;ENTRY POINT page controller
 S:'$D(DUOUT) DUOUT=0 S:'$D(DFOUT) DFOUT=0
 Q:($Y<(IOSL-4))!(DUOUT!DFOUT)  S:'$D(AZHZPG) AZHZPG=0 S AZHZPG=AZHZPG+1 I $E(IOST)="C" R !,"^ to quit ",AZHZX:DTIME I $E(AZHZX)="^" S DUOUT=1,DFOUT=1 Q
AZHZHDR ; Header controller
 W !,@IOF Q:'$D(AZHZHDR)  S:'$D(AZHZLINE) $P(AZHZLINE,"-",IOM-2)="" S:'$D(AZHZPG) AZHZPG=1 I '$D(AZHZDT) D DT^DICRW S Y=DT D DD^%DT S AZHZDT=Y
 U IO W ?(IOM-20-$L(AZHZHDR)/2),AZHZHDR,?(IOM-25),AZHZDT,?(IOM-10),"PAGE: ",AZHZPG,!,AZHZLINE
EAZHZPG Q  ;-----
 ;---------------------------------------------------------------------
