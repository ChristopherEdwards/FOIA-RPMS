AGSSINST ; IHS/ASDS/EFG - Install for AGSS menues and routines to process SSA SSN Matching ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 D DT^DICRW S IOP="HOME" D ^%ZIS
 W $$S^AGVDF("IOF")
S W !,"This is the install for the SSA SSN Matching software for ",!,"RPMS Registration Software",!
 K DIR S DIR(0)="E" D ^DIR
 Q:(+$G(DUOUT)+$G(DTOUT)+$G(DROUT)+$G(DIROUT))  Q:Y=""
 S AGI=0 F  S AGI=$O(^AUTTSSN(AGI)) Q:AGI=""  K ^AUTTSSN(AGI)
B W !!,"Loading the Patient SSN Notification Letter",!!
 D ^AGSSLETR
C W !!,"Please specify the offsets for the patient(s) address for printing",!,"   and edit the patient letter appropriately",!
 K DR S DA=$P(^AUTTSITE(1,0),U),DIE="^AGFAC(",DR="201//20:10;200" D ^DIE
 W !,"INSTALLATION completed",!
