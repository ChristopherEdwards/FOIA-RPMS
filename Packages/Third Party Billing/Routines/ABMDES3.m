ABMDES3 ; IHS/ASDST/DMJ - Display Summarized HCFA-1500B charges ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p5 - 5/18/04 - Modified to put POS and TOS on line item
 ; IHS/SD/SDR - v2.5 p6 - 7/12/04 - IM14097 - Added fix for FL Override for POS
 ; IHS/SD/SDR - v2.5 p6 - 7/14/04 - IM14187 - Modified to get around bad X-refs if there are any
 ; IHS/SD/SDR - v2.5 p8 - IM15905 - <UNDEF>HCFA+27^ABMDES3
 ; IHS/SD/SDR - v2.5 p10 - IM21581 - Added active insurer print to summary
 ;
HCFA ;EP for displaying charge summary for HCFA-1500
 ;
 D HD
 ;I ABMP("EXP")=22 S ABMEXP=14  ;abm*2.6*6 5010
 I ABMP("EXP")=22!(ABMP("EXP")=32) S ABMEXP=14  ;abm*2.6*6 5010
 E  S ABMEXP=ABMP("EXP")
 S ABMS=0 F  S ABMS=$O(ABMS(ABMS)) Q:'ABMS  D  Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) S DIR(0)="EO" D ^DIR W $$EN^ABMVDF("IOF") Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  D HD
 .S ABMS("I")=1,ABMLN=0 D PROC^ABMDF3E
 .W !,$$HDT^ABMDUTL($P(ABMR(ABMS,0),U))
 .W ?11,$$HDT^ABMDUTL($P(ABMR(ABMS,0),U,2))
 .I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,3))!($D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,4))) D
 ..S ABMFL=0,ABMFLE=0
 ..F ABMLN=3,4 D
 ...F  S ABMFL=$O(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,ABMLN,ABMFL)) Q:ABMFL=""  I ^(ABMFL)'="^" S ABMFLE=1
 .I $G(ABMFLE)=1 D
 ..S ABMFLMSG="Form Locator Override edits exist for POS/TOS"
 ..;
 ..S ABMVTYP=""
 ..I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,3)) D
 ...I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,3,0)) S ABMVTYP=0
 ...I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,3,ABMP("VTYP"))) S ABMVTYP=ABMP("VTYP")
 ...Q:+$G(ABMVTYP)=0
 ...S $P(ABMR(ABMS,0),U,3)=^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,3,ABMVTYP)
 ..;
 ..S ABMVTYP=""
 ..I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,4)) D
 ...I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,4,0)) S ABMVTYP=0
 ...I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,4,ABMP("VTYP"))) S ABMVTYP=ABMP("VTYP")
 ...Q:+$G(ABMVTYP)=0
 ...S $P(ABMR(ABMS,0),U,4)=^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,4,ABMVTYP)
 .W ?22,$J($P(ABMR(ABMS,0),U,3),2),?23,$J($P(ABMR(ABMS,0),U,4),2),?30,$S($P($G(ABMR(ABMS,(-1))),U)'="":$P(ABMR(ABMS,(-1)),U),1:$P(ABMR(ABMS,0),U,5))
 .W ?49,$J($P(ABMR(ABMS,0),U,6),5),?56,$J($FN($P(ABMR(ABMS,0),U,7),",",2),10)
 .W ?72,$J($P(ABMR(ABMS,0),U,8),3)
 W !?58,"----------"
 W !,?10,"TOTAL CHARGE",?56,$J($FN(ABMS("TOT"),",",2),10)
 S ABMP("TOT")=ABMP("TOT")+ABMS("TOT")
 I $G(ABMFLMSG)'="" W !!!!,ABMFLMSG
 F  W ! Q:$Y+4>IOSL
 S DIR(0)="E" D ^DIR K DIR
 Q
 ;
HD ;SCREEN HEADER
 W $$EN^ABMVDF("IOF")
 W !,?20,"***** "
 W $P(^ABMDEXP(ABMP("EXP"),0),U)
 W " CHARGE SUMMARY *****"
 W !!,"Active Insurer: ",$P($G(^AUTNINS(ABMP("INS"),0)),U),!
 W !,?51,"Corr"
 W !?1,"Charge Date  ",?21,"POS",?25,"TOS",?30," Description",?51,"Diag",?60,"Charge",?72,"Qty"
 S ABMS("I")="",$P(ABMS("I"),"-",80)="" W !,ABMS("I")
 Q
