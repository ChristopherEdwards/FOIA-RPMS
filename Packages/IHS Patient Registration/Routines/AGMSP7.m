AGMSP7 ; IHS/ASDS/EFG - PRINT PAGE 7 OF MSP FORM ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;I AG("MSPPRINT") EXISTS, MAP DATA FROM AUPNMSP TO THE FORM
EN ;EP
 W !,"PART VI - ESRD (con't)",!
 I '$D(AG("MSPPRINT")) D BLANK1
 I $D(AG("MSPPRINT")) D MAP1
 W !!!!!!!!!
 ;W !,?50,"Continued on next page ==>"
 W !,AGLINE("EQ")
 W !,$P($G(^DIC(4,DUZ(2),0)),U),?73,"PAGE 7"
 Q
BLANK1 ;THIS SECTION IS USED TO PRINT THE BLANK PAGE 7
 W !,?2,"4. Are you within the 30 month coordination period ? ",!
 W !,?5,"[ ] YES",!
 W !,?5,"[ ] NO. STOP. Medicare is primary.",!
 W !,?2,"5. Are you entitled to Medicare on the basis of either ESRD and age or ESRD"
 W !,?5,"and disability ? ",!
 W !,?5,"[ ] YES",!
 W !,?5,"[ ] NO. STOP. The group health plan (GHP) is primary during the 30-month"
 W !?19,"coordination period.",!
 W !,?2,"6. Was your initial entitlement to Medicare (including simultaneous"
 W !,?5,"entitlement) based on ESRD ? ",!
 W !,?5,"[ ] YES. STOP. The GHP continues to pay primary during the 30-month"
 W !?19,"coordination period.",!
 W !,?5,"[ ] NO. Initial entitlement is based on age or diability.",!
 W !,?2,"7. Does the working aged or disability MSP provision apply (i.e., is the GHP"
 W !,?5,"primary based on age or disability entitlement) ? ",!
 W !,?5,"[ ] YES. The GHP continues to pay primary during the 30-month"
 W !?14,"coordination period.",!
 W !,?5,"[ ] NO. Medicare continues to pay primary.",!
 W !!!
 W !,?2,"        SIGNATURE : ______________________________"
 W !,?2,"   SIGNATURE DATE : __________________"
 W !,?2,"DATE SURVEY GIVEN : __________________"
 Q
MAP1 ;THIS SECTION IS USED TO PRINT THE PATIENT'S DATA ON THE FORM
 W !,?2,"4. Are you within the 30 month coordination period ? ",!
 I $P(MSPRES(9000037,AG("DA"),.67),U)=""!($P(MSPRES(9000037,AG("DA"),.67),U)="NO") D
 . W !,?5,"[ ] YES",!
 . I $P(MSPRES(9000037,AG("DA"),.67),U)="" W !,?5,"[ ] NO",!
 . I $P(MSPRES(9000037,AG("DA"),.67),U)="NO" W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.67),U)="YES" D
 . W !,?5,"[X] YES",!
 . W !,?5,"[ ] NO",!
 ;
 W !,?2,"5. Are you entitled to Medicare on the basis of either ESRD and age or ESRD"
 W !,?5,"and disability ? ",!
 I $P(MSPRES(9000037,AG("DA"),.68),U)=""!($P(MSPRES(9000037,AG("DA"),.68),U)="NO") D
 . W !,?5,"[ ] YES",!
 . I $P(MSPRES(9000037,AG("DA"),.68),U)="" W !,?5,"[ ] NO",!
 . I $P(MSPRES(9000037,AG("DA"),.68),U)="NO" W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.68),U)="YES" D
 . W !,?5,"[X] YES",!
 . W !,?5,"[ ] NO",!
 ;
 W !,?2,"6. Was your initial entitlement to Medicare (including simultaneous"
 W !,?5,"entitlement) based on ESRD ? ",!
 I $P(MSPRES(9000037,AG("DA"),.69),U)=""!($P(MSPRES(9000037,AG("DA"),.69),U)="NO") D
 . W !,?5,"[ ] YES",!
 . I $P(MSPRES(9000037,AG("DA"),.69),U)="" W !,?5,"[ ] NO",!
 . I $P(MSPRES(9000037,AG("DA"),.69),U)="NO" W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.69),U)="YES" D
 . W !,?5,"[X] YES",!
 . W !,?5,"[ ] NO",!
 ;
 W !,?2,"7. Does the working aged or disability MSP provision apply (i.e., is the GHP"
 W !,?5,"primary based on age or disability entitlement) ? ",!
 I $P(MSPRES(9000037,AG("DA"),.71),U)=""!($P(MSPRES(9000037,AG("DA"),.71),U)="NO") D
 . W !,?5,"[ ] YES",!
 . I $P(MSPRES(9000037,AG("DA"),.71),U)="" W !,?5,"[ ] NO",!
 . I $P(MSPRES(9000037,AG("DA"),.71),U)="NO" W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.71),U)="YES" D
 . W !,?5,"[X] YES",!
 . W !,?5,"[ ] NO",!
 ;
 W !!!
 S $P(SIGLINE,"_",30)=""
 W !,?2,"SIGNATURE : ",SIGLINE   ;,$P(MSPRES(9000037,AG("DA"),.02),U)
 S Y=$P($G(^AUPNMSP(AG("DA"),7)),U)
 X ^DD("DD")
 W !?2,"SIGNATURE DATE : ",Y
 W !!?2,"DATE SURVEY GIVEN: ",$P(MSPRES(9000037,AG("DA"),.01),U)
 Q
