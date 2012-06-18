AGMSP2 ; IHS/ASDS/EFG - PRINT PAGE 2 OF MSP FORM ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;I AG("MSPPRINT") EXISTS, MAP DATA FROM AUPNMSP TO THE FORM
EN ;EP
 W !,"PART II",!
 I '$D(AG("MSPPRINT")) D BLANK1
 I $D(AG("MSPPRINT")) D MAP1
 W !
 W !,?50,"Continued on next page ==>"
 W !,AGLINE("EQ")
 W !,$P($G(^DIC(4,DUZ(2),0)),U),?73,"PAGE 2"
 Q
BLANK1 ;THIS SECTION IS USED TO PRINT THE BLANK PAGE 2
 W !,?2,"1. Was the illness/injury due to a non-work-related accident ? ",!
 W !,?5,"[ ] YES  Date of accident :  _______________",!
 W !,?5,"[ ] NO - GO TO PART III",!
 W !,?2,"2. What type of accident caused the illness/injury ? ",!
 W !,?5,"[ ] Automobile",!
 W !,?5,"[ ] Non-Automobile",!
 W !,?14,"Name and address of no-fault or liability insurer : ",!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?5,"Insurance claim number : _______________",!
 W !,"No-fault insurer is primary payer only for those claims related to the accident."
 W !,"GO TO PART III.",!
 W !,?5,"[ ] Other",!
 W !?2,"3. Was another party responsible for this accident ? ",!
 W !,?5,"[ ] YES",!
 W !,?14,"Name and address of any liability insurer : ",!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,"Insurance claim number : _______________",!
 W !?2,"The liability insurer is primary only for those claims related to"
 W !?2,"the accident. GO TO PART III.",!
 W !,?5,"[ ] NO - GO TO PART III",!
 Q
MAP1 ;THIS SECTION IS USED TO PRINT THE PATIENT'S DATA ON THE FORM
 W !,?2,"1. Was the illness/injury due to a non-work related accident ? ",!
 I $P(MSPRES(9000037,AG("DA"),.16),U)="" D
 . W !,?5,"[ ] YES  Date of accident :  _______________",!
 . W !,?5,"[ ] NO - GO TO PART III",!
 I $P(MSPRES(9000037,AG("DA"),.16),U)="NO" D
 . W !,?5,"[ ] YES  Date of accident :  _______________",!
 . W !,?5,"[X] NO - GO TO PART III",!
 I $P(MSPRES(9000037,AG("DA"),.16),U)="YES" D
 . W !,?5,"[X] YES  Date of accident : "
 . W $P(MSPRES(9000037,AG("DA"),.17),U)
 . W !,?5,"[ ] NO - GO TO PART III",!
 ;
 W !,?2,"2. What type of accident caused the illness/injury ? ",!
 I $P(MSPRES(9000037,AG("DA"),.18),U)=""!($P(MSPRES(9000037,AG("DA"),.18),U)="OTHER") D
 . W !,?5,"[ ] Automobile",!
 . W !,?5,"[ ] Non-Automobile",!
 . W !,?5,"Name and address of no-fault or liability insurer : ",!
 . W !,?5,$E(AGLINE("_"),1,50),!
 . W !,?5,$E(AGLINE("_"),1,50),!
 . W !,?5,$E(AGLINE("_"),1,50),!
 . W !,?5,"Insurance claim number : _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.18),U)="" W !,?5,"[ ] Other",!
 . I $P(MSPRES(9000037,AG("DA"),.18),U)="OTHER" W !,?5,"[X] Other",!
 I $P(MSPRES(9000037,AG("DA"),.18),U)="AUTOMOBILE"!($P(MSPRES(9000037,AG("DA"),.18),U)="NON-AUTOMOBILE") D
 . I $P(MSPRES(9000037,AG("DA"),.18),U)="AUTOMOBILE" D
 .. W !,?5,"[X] Automobile",!
 .. W !,?5,"[ ] Non-Automobile",!
 . I $P(MSPRES(9000037,AG("DA"),.18),U)="NON-AUTOMOBILE" D
 .. W !,?5,"[ ] Automobile",!
 .. W !,?5,"[X] Non-Automobile",!
 . W !,?5,"Name and address of no-fault or liability insurer : ",!
 . I $P(MSPRES(9000037,AG("DA"),.19),U)="" D
 .. W !,?5,$E(AGLINE("_"),1,50),!
 .. W !,?5,$E(AGLINE("_"),1,50),!
 .. W !,?5,$E(AGLINE("_"),1,50),!
 . I $P(MSPRES(9000037,AG("DA"),.19),U)'="" D
 .. S AG("INSPTR")=$P($G(^AUPNMSP(AG("DA"),2)),U,4)
 .. S AG("INSADDR")=$G(^AUTNINS(AG("INSPTR"),0))
 .. W !,?5,$P(AG("INSADDR"),U),!  ;INSURER NAME
 .. W !,?5,$P(AG("INSADDR"),U,2),!  ;INSURER STREET
 .. W !,?5,$P(AG("INSADDR"),U,3)  ;INSURER CITY
 .. I $P(AG("INSADDR"),U,4)'="" D
 ... W ", ",$P($G(^DIC(5,$P(AG("INSADDR"),U,4),0)),U,2)  ;INSURER STATE
 .. W ", ",$P(AG("INSADDR"),U,5),!  ;INSURER ZIP
 . I $P(MSPRES(9000037,AG("DA"),.21),U)="" D
 .. W !,?5,"Insurance claim number : _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.21),U)'="" D
 .. W !,?5,"Insurance claim number : ",$P(MSPRES(9000037,AG("DA"),.21),U),!
 . W !,?5,"[ ] Other",!
 ;
 W !?2,"3. Was another party responsible for this accident ? ",!
 I $P(MSPRES(9000037,AG("DA"),.22),U)=""!($P(MSPRES(9000037,AG("DA"),.22),U)="NO") D
 . W !,?5,"[ ] YES",!
 . W !,?14,"Name and address of any liability insurer : ",!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,"Insurance claim number : _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.22),U)="" W !,?5,"[ ] NO - GO TO PART III",!
 . I $P(MSPRES(9000037,AG("DA"),.22),U)="NO" W !,?5,"[X] NO - GO TO PART III",!
 I $P(MSPRES(9000037,AG("DA"),.22),U)="YES" D
 . W !,?5,"[X] YES",!
 . W !,?14,"Name and address of any liability insurer : ",!
 . I $P(MSPRES(9000037,AG("DA"),.23),U)="" D
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 . I $P(MSPRES(9000037,AG("DA"),.23),U)'="" D
 .. S AG("INSPTR")=$P($G(^AUPNMSP(AG("DA"),2)),U,7)
 .. S AG("INSADDR")=$G(^AUTNINS(AG("INSPTR"),0))
 .. W !,?14,$P(AG("INSADDR"),U),!  ;INSURER NAME
 .. W !,?14,$P(AG("INSADDR"),U,2),!  ;INSURER STREET
 .. W !,?14,$P(AG("INSADDR"),U,3)  ;INSURER CITY
 .. I $P(AG("INSADDR"),U,4)'="" D
 ... W ", ",$P($G(^DIC(5,$P(AG("INSADDR"),U,4)),0),U,2)  ;INSURER STATE
 .. W ", ",$P(AG("INSADDR"),U,5),!  ;INSURER ZIP
 . I $P(MSPRES(9000037,AG("DA"),.24),U)="" D
 .. W !,?5,"Insurance claim number : _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.24),U)'="" D
 .. W !,?5,"Insurance claim number : ",$P(MSPRES(9000037,AG("DA"),.24),U),!
 . W !,?5,"[ ] NO - GO TO PART III",!
 K AG("INSPTR"),AG("INSADDR")
 Q
