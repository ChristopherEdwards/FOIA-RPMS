ACDREG ;IHS/ADC/EDE/KML - PATIENT INQUIR;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
EN ;EP
 ;//[ACDREG]
 ;
 ;W @IOF
 ;S:'$D(ACDLINE) $P(ACDLINE,"=",80)="="
 ;W !!,"SIGN ON PROGRAM is: ",$P(^AUTTLOC(DUZ(2),0),U,2),!,ACDLINE,!
 S ACDDUZ(2)=DUZ(2),DUZ(2)=0
 F  D PAT I Y<0 D K Q
 Q
 ;
PAT ; DO ONE PATIENT
 S DIC("A")="Inquire on patient: "
 S DUZ(2)=ACDDUZ(2)
 S DIC(0)="AEQMI",DIC="^DPT(" D ^DIC I Y<0 Q
 S DUZ(2)=ACDDUZ(2)
 I '$D(^AUPNPAT(+Y,0)) W !!!,$P(^DPT(+Y,0),U)," 'IS NOT' registered for your sign on program."
 I  W !!,"This means: CDMIS data entry for this patient 'IS NOT' allowed." Q
 W !!!,$P(^DPT(+Y,0),U)," 'IS' registered for your sign on program."
 W !,"This means: CDMIS data entry for this patient 'IS' allowed.",!
 Q
K ;
 K ACDLINE,DIC,Y
 Q
