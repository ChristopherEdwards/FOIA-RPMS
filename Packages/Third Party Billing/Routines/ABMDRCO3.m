ABMDRCO3 ; IHS/ASDST/DMJ - CO VISITS REPORT (PRINT) ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
HEAD ;EP to print page heading
 W $$EN^ABMVDF("IOF"),!,?11,"*****Confidential Patient Data Covered by Privacy Act*****",!
 W !,?132-$L(ABMD("FAC"))/2,ABMD("FAC")
 W !,?45,"COMMISSIONED OFFICERS & DEPENDENTS VISITS"
 W !,?55,ABMD("BDT")_" to "_ABMD("EDT")
 S X=$S(ABMD("II")="O":"OUTPATIENT VISITS",ABMD("II")="I":"INPATIENT VISITS",1:"DENTAL VISITS")
 W !,?132-$L(X)/2,X,!
 F ABMD("J")=1:1:132 W "-"
 W !,"Patient Name",?23,"Chart #",?36,"SSN",?45,"CO or Dep"
 W ?58,"Sponsor",?80,"SSN"
 W ?97,$S(ABMD("II")="I":"Admit Date",1:"Visit Date")
 W ?110,$S(ABMD("II")="I":"Dsch Date",1:"No. of Visits")
 I ABMD("II")="I" W ?122,"# of Days"
 W ! F J=1:1:132 W "-"
 W ! Q
 ;
PAGE ;EP to form feed to new page
 I IOST'?1"C-".E D HEAD Q
 K DIR W ! S DIR(0)="EO",ABMDSTOP=""
 S DIR("A")="Enter <return> to continue or '^' to stop"
 D ^DIR K DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S ABMD("STOP")="^" Q
 D HEAD
 Q
 ;
PRVTINS ;EP does patient have co dep info in prvt ins file?
 G PRV9:ABMD("CHMP")=""
 G PRV9:ABMD("BENP")="CO",PRV9:ABMD("BENP")="RET"
 S ABMD("INS")=$O(^AUPNPRVT("I",ABMD("CHMP"),ABMD("DFN"),0)) G PRV9:ABMD("INS")=""
 Q:$P($G(^AUPNPRVT(ABMD("DFN"),11,ABMD("INS"),0)),U)=""  ;ABM*2.5*8 IHS/SD/TPF 6/14/2005 IM17673
 S ABMD("STR1")=^AUPNPRVT(ABMD("DFN"),11,ABMD("INS"),0) W ?58,$P(ABMD("STR1"),"^",4)
 S X=$P(ABMD("STR1"),"^",2) W ?80,$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,9)
PRV9 Q
 ;
TOTAL ;EP to print visit total
 Q:ABMD("STOP")="^"
 I $Y>(IOSL-6) D PAGE
 I ABMD("II")="O" W !!,?80,"TOTAL OUTPATIENT VISITS:",?112,$J(ABMD("TOT"),3)
 I ABMD("II")="I" W !!,?95,"TOTAL INPATIENT DAYS:",?121,$J(ABMD("TOT"),3)
 I ABMD("II")="D" W !!,?80,"TOTAL DENTAL VISITS:",?112,$J(ABMD("TOT"),3)
 S ABMD("TOT")=0 ;reset for next category
 I IOST?1"C-".E W ! K DIR S DIR(0)="EO",DIR("A")="Enter <return> to continue or '^' to stop" D ^DIR K DIR I $D(DTOUT)!$D(DIROUT)!$D(DUOUT) S ABMD("STOP")="^" Q
 Q
