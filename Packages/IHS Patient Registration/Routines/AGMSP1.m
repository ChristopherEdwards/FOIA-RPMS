AGMSP1 ; IHS/ASDS/EFG - PRINT PAGE 1 OF MSP FORM ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;I AG("MSPPRINT") EXISTS, MAP DATA FROM AUPNMSP TO THE FORM
 ;
EN ;EP
 W !,"PART I",!
 I '$D(AG("MSPPRINT")) D BLANK1
 I $D(AG("MSPPRINT")) D MAP1
 W !!!
 W !,?50,"Continued on next page ==>"
 W !,AGLINE("EQ")
 W !,$P($G(^DIC(4,DUZ(2),0)),U),?73,"PAGE 1"
 Q
BLANK1 ;THIS SECTION IS USED TO PRINT THE BLANK PAGE 1
 W !,?2,"1. Are you receiving Black Lung (BL) Benefits ? ",!
 W !,?5,"[ ] YES  Date primary benefits begin: _______________"
 W !,?14,"BL is primary only for claims related to BL"
 W !,?5,"[ ] NO",!
 W !,?2,"2. Are the services to be paid by a government program such as a research"
 W !,?5,"grant ? ",!
 W !,?5,"[ ] YES  Government Program will pay primary benefits for these services.",!
 W !,?5,"[ ] NO",!
 W !,?2,"3. Has the Department of Veteran Affairs (DVA) authorized and agreed to pay"
 W !,?5,"for care at this facility ? ",!
 W !,?5,"[ ] YES: VA is primary for these services."
 W !,?5,"[ ] NO",!
 W !,?2,"4. Was the illness/injury due to a work related accident/condition ? ",!
 W !,?5,"[ ] YES  Date of injury/illness: _______________"
 W !,?14,"Name and address of Workman's Compensation (WC) plan:",!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,"Patient's policy or identification number: _______________"
 W !,?14,"Name and address of your employer:",!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?2,"WC is primary payer only for claims related to work-related injuries or"
 W !?2,"illness. GO TO PART III.",!
 W !?5,"[ ] NO - GO TO PART II",!
 Q
MAP1 ;THIS SECTION IS USED TO PRINT THE PATIENT'S DATA ON THE FORM
 W !,?2,"1. Are you receiving Black Lung (BL) Benefits ? ",!
 I $P(MSPRES(9000037,AG("DA"),.06),U)="" D
 . W !,?5,"[ ] YES  Date primary benefits begin: _______________",!
 . W !,?5,"[ ] NO",!
 I $P(MSPRES(9000037,AG("DA"),.06),U)="NO" D
 . W !,?5,"[ ] YES  Date primary benefits begin: _______________",!
 . W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.06),U)="YES" D
 . W !,?5,"[X] YES  Date primary benefits begin: "
 . W $P(MSPRES(9000037,AG("DA"),.07),U)
 . W !,?5,"[ ] NO",!
 ;
 W !,?2,"2. Are the services to be paid by a government program such as a research"
 W !,?5,"grant ? ",!
 I $P(MSPRES(9000037,AG("DA"),.08),U)="YES" D
 . W !,?5,"[X] YES  Government Program will pay primary benefits for these services.",!
 . W !,?5,"[ ] NO",!
 I $P(MSPRES(9000037,AG("DA"),.08),U)="NO" D
 . W !,?5,"[ ] YES  Government Program will pay primary benefits for these services.",!
 . W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.08),U)="" D
 . W !,?5,"[ ] YES  Government Program will pay primary benefits for these services.",!
 . W !,?5,"[ ] NO",!
 ;
 W !,?2,"3. Has the Department of Veteran Affairs (DVA) authorized and agreed to pay"
 W !,?5,"for care at this facility ? ",!
 I $P(MSPRES(9000037,AG("DA"),.09),U)="YES" D
 . W !,?5,"[X] YES",!
 . W !,?5,"[ ] NO",!
 I $P(MSPRES(9000037,AG("DA"),.09),U)="NO" D
 . W !,?5,"[ ] YES",!
 . W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.09),U)="" D
 . W !,?5,"[ ] YES",!
 . W !,?5,"[ ] NO",!
 ;
 W !,?2,"4. Was the illness/injury due to a work related accident/condition ? ",!
 I $P(MSPRES(9000037,AG("DA"),.11),U)="NO"!($P(MSPRES(9000037,AG("DA"),.11),U)="") D
 . W !,?5,"[ ] YES  Date of injury/illness: _______________"
 . W !!,?14,"Name and address of Workman's Compensation (WC) plan:",!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,"Patient's policy or identification number: _______________"
 . W !,?14,"Name and address of your employer:",!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . I $P(MSPRES(9000037,AG("DA"),.11),U)="NO" W !,?5,"[X] NO - GO TO PART II"
 . I $P(MSPRES(9000037,AG("DA"),.11),U)="" W !,?5,"[ ] NO - GO TO PART II"
 I $P(MSPRES(9000037,AG("DA"),.11),U)="YES" D
 . W !,?5,"[X] YES  "
 . I $P(MSPRES(9000037,AG("DA"),.12),U)'="" D
 . . W "Date of injury/illness: ",$P(MSPRES(9000037,AG("DA"),.12),U)
 . I $P(MSPRES(9000037,AG("DA"),.12),U)="" D
 . . W "Date of injury/illness: _______________"
 . W !,?14,"Name and address of Workman's Compensation (WC) plan:",!
 . I $P(MSPRES(9000037,AG("DA"),.13),U)="" D
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 . I $P(MSPRES(9000037,AG("DA"),.13),U)'="" D
 .. S AG("INSPTR")=$P($G(^AUPNMSP(AG("DA"),1)),U,8)
 .. S AG("INSADDR")=$G(^AUTNINS(AG("INSPTR"),0))
 .. W !,?14,$P(AG("INSADDR"),U),!  ;INSURER NAME
 .. W !,?14,$P(AG("INSADDR"),U,2),!  ;INSURER STREET
 .. W !,?14,$P(AG("INSADDR"),U,3)  ;INSURER CITY
 .. I $P(AG("INSADDR"),U,4)'="" D
 ... W ", ",$P($G(^DIC(5,$P(AG("INSADDR"),U,4),0)),U,2)  ;INSURER STATE
 .. W "  ",$P(AG("INSADDR"),U,5),!  ;INSURER ZIP CODE
 . I $P(MSPRES(9000037,AG("DA"),.14),U)="" D
 .. W !!,?14,"Patient's policy or identification number: _______________"
 . I $P(MSPRES(9000037,AG("DA"),.14),U)'="" D
 .. W !,?14,"Patient's policy or identification number: ",$P(MSPRES(9000037,AG("DA"),.14),U)
 . I $P(MSPRES(9000037,AG("DA"),.15),U)="" D
 .. W !,?14,"Name and address of your employer:",!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 . I $P(MSPRES(9000037,AG("DA"),.15),U)'="" D
 .. S AG("EMPPTR")=$P($G(^AUPNMSP(AG("DA"),1)),U,10)
 .. I $G(AG("EMPPTR"))'="" D
 ... S AG("EMPADDR")=$G(^AUTNEMPL(AG("EMPPTR"),0))
 ... W !,?14,"Name and address of your employer:",!
 ... W !,?14,$P(AG("EMPADDR"),U),!  ;EMPLOYER
 ... W !,?14,$P(AG("EMPADDR"),U,2),!  ;EMPLOYER STREET
 ... W !,?14,$P(AG("EMPADDR"),U,3)  ;EMPLOYER CITY
 ... W:$P(AG("EMPADDR"),U,4)'="" ", ",$P($G(^DIC(5,$P(AG("EMPADDR"),U,4),0)),U,2)  ;EMPLOYER STATE
 ... W ", ",$P(AG("EMPADDR"),U,5),!  ;EMPLOYER ZIP
 .. I $G(AG("EMPPTR"))="" D
 ... W !,?14,$E(AGLINE("_"),1,50),!
 ... W !,?14,$E(AGLINE("_"),1,50),!
 ... W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?5,"[ ] NO - GO TO PART II",!
 K AG("INSPTR"),AG("INSADDR"),AG("EMPPTR"),AG("EMPADDR")
 Q
