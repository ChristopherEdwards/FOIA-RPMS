ANSEAF ;IHS/OIRM/DSD/CSC - ENTER/EDIT ADJUSTMENT FACTORS; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;ADD/EDIT ADJUSTMENT FACTORS
EN F  D EN1 Q:$D(DTOUT)!$D(DUOUT)
EXIT K DUOUT,ANSA
 Q
EN1 K ANSA
 D DISP
A1 S DIC="^ANSD(59.3,",DIC(0)="AQZEM",DIC("A")="Adjustment Factor: "
 W !
 D DIC^ANSDIC
 I +Y<1 S DUOUT="" Q
 S F=+Y
 I $P($G(ANSAF),U,F) W "  Deleted." S $P(ANSAF,U,F)="" D DELET^ANSEA2 Q
 S $P(ANSAF,U,F)=F
 D:'$D(^ANSR(+$G(ANSDA),"F",F)) FACTOR^ANSEA2
 W "  Added."
 Q
DISP Q:'$G(ANSDA)
 N I,ANSA
 S I=0
 F  S I=$O(^ANSR(ANSDA,"F",I)) Q:'I  S $P(ANSAF,U,I)=I,ANSA(I)=""
 I '$D(ANSA) W !!,"No Adjustment Listed For This Patient. " Q
 W !!,"Current Adjustments: "
 S J=0
 F I=1:1 S J=$O(ANSA(J)) Q:J=""  I $D(^ANSD(59.3,J,0)) D
 .W:I>1 ", "
 .W $P(^ANSD(59.3,J,0),U,2)
 Q
