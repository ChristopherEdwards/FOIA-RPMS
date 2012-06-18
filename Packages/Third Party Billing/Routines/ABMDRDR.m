ABMDRDR ; IHS/ASDST/DMJ - Drug File Report ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;03/25/96 11:32 AM
 ;
 K ABM,ABMY S ABM("SYN")=0
 W !!,"This program generates a listing of the Drug File, sorted in alphabetic order,",!,"showing the NDC Number and Dispense Fee of each drug.",!
 K DIR S DIR(0)="Y",DIR("A")="Do you wish the Run the Program",DIR("B")="Y" D ^DIR K DIR G XIT:'Y
 W ! K DIR S DIR(0)="Y",DIR("A")="Should the Listing display the Drug Synonyms",DIR("B")="N" D ^DIR K DIR G XIT:$D(DTOUT)!$D(DUOUT) S:Y ABM("SYN")=1
 S ABM("HD",0)="",ABM("FAST")="" D HD^ABMDRHD
 D ZIS^ABMDRUTL G XIT:$G(POP)
 S ABM("HD",0)="DRUG FILE LISTING"
 G:$D(IO("Q")) QUE
 ;
PRQUE ;EP - Entry Point for Taskman
 S IOP=ABM("IOP") D ^%ZIS Q:$G(POP)  U IO S ABM("PG")=0 D HDB
 S ABM="" F  S ABM=$O(^PSDRUG("B",ABM)) Q:ABM=""  S ABM("D")=$O(^(ABM,0)) I $D(^PSDRUG(ABM("D"),0)) S ABM(0)=^(0),ABM(2)=$G(^(2)),ABM(6)=$G(^(660)) D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .W !,$P(ABM(0),U),?44,$P(ABM(2),U,4),?63,$J($FN($P(ABM(6),U,6),",",3),6),?75,$E($P(ABM(6),U,8),1,3)
 .Q:'ABM("SYN")
 .S ABM("S")=0 F  S ABM("S")=$O(^PSDRUG(ABM("D"),1,ABM("S"))) Q:'ABM("S")  S ABM(1)=^(ABM("S"),0) D
 ..S ABM("X")=$P(ABM(1),U) I ABM("X")="" K ABM("X") Q
 ..F ABM("%")=1:1:$L(ABM("X")) I $E(ABM("X"),ABM("%"))?1U,$E(ABM("X"),ABM("%")-1)?1A S ABM("X")=$E(ABM("X"),0,ABM("%")-1)_$C($A(ABM("X"),ABM("%"))+32)_$E(ABM("X"),ABM("%")+1,99)
 .I $D(ABM("X")) W !?6,ABM("X") K ABM("X")
 G XIT
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB W $$EN^ABMVDF("IOF") S ABM("PG")=ABM("PG")+1 D WHD^ABMDRHD
 W !?60,"Dispense Fee"
 W !?5,"Drug" W:ABM("SYN") " / Synonym" W ?45,"NDC Number",?62,"Per Unit",?74,"Units"
 W !,"-------------------------------------------------------------------------------"
 Q
 ;
XIT D POUT^ABMDRUTL,^%ZISC
 Q
 ;
QUE S ZTRTN="PRQUE^ABMDRDR",ZTDESC="DRUG LISTING"
 D QUE^ABMDRUTL
 G XIT
