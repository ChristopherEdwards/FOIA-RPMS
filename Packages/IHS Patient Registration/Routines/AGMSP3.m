AGMSP3 ; IHS/ASDS/EFG - PRINT PAGE 3 OF MSP FORM ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;I AG("MSPPRINT") EXISTS, MAP DATA FROM AUPNMSP TO THE FORM
EN ;EP
 W !,"PART III",!
 I '$D(AG("MSPPRINT")) D BLANK1
 I $D(AG("MSPPRINT")) D MAP1
 W !!
 W !,?50,"Continued on next page ==>"
 W !,AGLINE("EQ")
 W !,$P($G(^DIC(4,DUZ(2),0)),U),?73,"PAGE 3"
 Q
BLANK1 ;THIS SECTION IS USED TO PRINT THE BLANK PAGE 3
 W !,?2,"1. Are you entitled to Medicare based on : ",!
 W !,?5,"[ ] Age - GO TO PART IV",!
 W !,?5,"[ ] Disability _ GO TO PART V",!
 W !,?5,"[ ] ESRD - GO TO PART VI",!
 W !,"PART IV - Age",!
 W !,?2,"1. Are you currently employed ? ",!
 W !,?5,"[ ] YES",!
 W !,?14,"Name and address of your employer : ",!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?5,"[ ] NO  Date of retirement : _______________",!
 W !,?2,"2. Is your spouse currently employed ? ",!
 W !,?5,"[ ] YES",!
 W !,?14,"Name and address of spouse's employer : ",!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?5,"[ ] NO. Date of retirement : _______________",!
 W !?2,"If the patient answered no to both questions 1 and 2, Medicare is primary"
 W !?2,"unless the patient answered yes to questions in part I or II."
 W !?2,"STOP. DO NOT PROCEED ANY FURTHER."
 Q
MAP1 ;THIS SECTION IS USED TO PRINT THE PATIENT'S DATA ON THE FORM
 W !,?2,"1. Are you entitled to Medicare based on : ",!
 I $P(MSPRES(9000037,AG("DA"),.25),U)="AGE" D
 . W !,?5,"[X] Age - GO TO PART IV",!
 E  W !,?5,"[ ] Age - GO TO PART IV",!
 I $P(MSPRES(9000037,AG("DA"),.25),U)="DISABILITY" D
 . W !,?5,"[X] Disability _ GO TO PART V",!
 E  W !,?5,"[ ] Disability _ GO TO PART V",!
 I $P(MSPRES(9000037,AG("DA"),.25),U)="ESRD" D
 . W !,?5,"[X] ESRD - GO TO PART VI",!
 E  W !,?5,"[ ] ESRD - GO TO PART VI",!
 ;
 W !,"PART IV - Age",!
 W !,?2,"1. Are you currently employed ? ",!
 I $P(MSPRES(9000037,AG("DA"),.26),U)=""!($P(MSPRES(9000037,AG("DA"),.26),U)="NO") D
 . W !,?5,"[ ] YES",!
 . W !,?14,"Name and address of your employer : ",!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . I $P(MSPRES(9000037,AG("DA"),.26),U)="" W !,?5,"[ ] NO  Date of retirement : _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.26),U)="NO" D
 .. W !,?5,"[X] NO  Date of retirement : "
 .. W $P(MSPRES(9000037,AG("DA"),.28),U),!
 I $P(MSPRES(9000037,AG("DA"),.26),U)="YES" D
 . W !,?5,"[X] YES",!
 . W !,?14,"Name and address of your employer : ",!
 . S AG("EMPPTR")=$P($G(^AUPNMSP(AG("DA"),4)),U,2)
 . I $G(AG("EMPPTR"))'="" D
 .. S AG("EMPADDR")=$G(^AUTNEMPL(AG("EMPPTR"),0))
 .. W !,?14,$P(AG("EMPADDR"),U),!  ;EMPLOYER
 .. W !,?14,$P(AG("EMPADDR"),U,2),!  ;EMPLOYER STREET
 .. W !,?14,$P(AG("EMPADDR"),U,3)  ;EMPLOYER CITY
 .. I $P(AG("EMPADDR"),U,4)'="" D
 ... W ", ",$P($G(^DIC(5,$P(AG("EMPADDR"),U,4),0)),U,2)  ;EMPLOYER STATE
 .. W ", ",$P(AG("EMPADDR"),U,5),!  ;EMPLOYER ZIP
 . I $G(AG("EMPPTR"))="" D
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?5,"[ ] NO  Date of retirement : _______________",!
 ;
 W !,?2,"2. Is your spouse currently employed ? ",!
 I $P(MSPRES(9000037,AG("DA"),.29),U)=""!($P(MSPRES(9000037,AG("DA"),.29),U)="NO") D
 . W !,?5,"[ ] YES",!
 . W !,?14,"Name and address of spouse's employer : ",!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . I $P(MSPRES(9000037,AG("DA"),.29),U)="" W !,?5,"[ ] NO  Date of retirement : _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.29),U)="NO" W !,?5,"[X] NO  Date of retirement : ",$P(MSPRES(9000037,AG("DA"),.32),U),!
 I $P(MSPRES(9000037,AG("DA"),.29),U)="YES" D
 . W !,?5,"[X] YES",!
 . S AG("EMPPTR")=$P($G(^AUPNMSP(AG("DA"),4)),U,5)
 . I $G(AG("EMPPTR"))'="" D
 .. S AG("EMPADDR")=$G(^AUTNEMPL(AG("EMPPTR"),0))
 .. W !,?14,$P(AG("EMPADDR"),U),!  ;EMPLOYER
 .. W !,?14,$P(AG("EMPADDR"),U,2),!  ;EMPLOYER STREET
 .. W !,?14,$P(AG("EMPADDR"),U,3)  ;EMPLOYER CITY
 .. I $P(AG("EMPADDR"),U,4)'="" D
 ... W ", ",$P($G(^DIC(5,$P(AG("EMPADDR"),U,4),0)),U,2)  ;EMPLOYER STATE
 .. W ", ",$P(AG("EMPADDR"),U,5),!  ;EMPLOYER ZIP
 . I $G(AG("EMPPTR"))="" D
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?5,"[ ] NO  Date of retirement : _______________",!
 ;
 W !,?2,"3. Do you have group health plan (GHP) coverage based on your own, or a"
 W !,?5,"spouse's current employment ? ",!
 I $P(MSPRES(9000037,AG("DA"),.33),U)="" D
 . W !,?5,"[ ] YES",!
 . W !,?5,"[ ] NO",!
 I $P(MSPRES(9000037,AG("DA"),.33),U)="YES" D
 . W !,?5,"[X] YES",!
 . W !,?5,"[ ] NO",!
 I $P(MSPRES(9000037,AG("DA"),.33),U)="NO" D
 . W !,?5,"[ ] YES",!
 . W !,?5,"[X] NO",!
 K AG("EMPPTR"),AG("EMPADDR")
 Q
