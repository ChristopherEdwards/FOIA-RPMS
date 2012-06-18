AGMSP5 ; IHS/ASDS/EFG - PRINT PAGE 5 OF MSP FORM ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;I AG("MSPPRINT") EXISTS, MAP DATA FROM AUPNMSP TO THE FORM
EN ;EP
 W !,"PART V - Disability (con't)",!
 I '$D(AG("MSPPRINT")) D BLANK1
 I $D(AG("MSPPRINT")) D MAP1
 W !,?50,"Continued on next page ==>"
 W !,AGLINE("EQ")
 W !,$P($G(^DIC(4,DUZ(2),0)),U),?73,"PAGE 5"
 Q
BLANK1 ;THIS SECTION IS USED TO PRINT THE BLANK PAGE 5
 W !,?2,"2. Is a family member currently employed ? "
 W !,?5,"[ ] YES"
 W !,?14,"Name and address of family member's employer : ",!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50)
 W !,?5,"[ ] NO",!
 W !?2,"If the patient answers no to both questions 1 and 2, Medicare is primary"
 W !?2,"unless the patient answered yes to questions in part I or II."
 W !?2,"STOP. DO NOT PROCEED ANY FURTHER."
 W !!?2,"3. Do you have group health plan (GHP) coverage based on your own or a family"
 W !,?5,"member's current employment ? "
 W !,?5,"[ ] YES"
 W !,?5,"[ ] NO. STOP. Medicare is primary unless the patient answered yes to"
 W !?19,"questions in part I or II.",!
 W !,?2,"4. Does the employer that sponsors your GHP employ 100 or more employees ? ",!
 W !,?5,"[ ] YES. STOP. The GHP is primary. Obtain the following information:",!
 W !,?14,"Name and address of GHP : ",!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,"Policy Identification Number : _______________",!
 W !,?14,"Group Identification Number :  _______________",!
 W !,?14,"Name of Policy Holder : ______________________",!
 W !,?14,"Relationship to Patient : ____________________",!
 W !,?5,"[ ] NO. STOP. Medicare is primary unless the patient answered yes to"
 W !?19,"questions in part I or II.",!
 W !!!
 Q
MAP1 ;THIS SECTION IS USED TO PRINT THE PATIENT'S DATA ON THE FORM
 W !,?2,"2. Is a family member currently employed ? ",!
 I $P(MSPRES(9000037,AG("DA"),.44),U)=""!($P(MSPRES(9000037,AG("DA"),.44),U)="NO") D
 . W !,?5,"[ ] YES",!
 . W !,?14,"Name and address of family member's employer : ",!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . I $P(MSPRES(9000037,AG("DA"),.44),U)="" W !,?5,"[ ] NO",!
 . I $P(MSPRES(9000037,AG("DA"),.44),U)="NO" W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.44),U)="YES" D
 . S AG("EMPPTR")=$P($G(^AUPNMSP(AG("DA"),5)),U,5)
 . I $G(AG("EMPPTR"))'="" D
 .. S AG("EMPADDR")=$G(^AUTNEMPL(AG("EMPPTR"),0))
 .. W !,?5,"[X] YES",!
 .. W !,?14,"Name and address of family member's employer : ",!
 .. W !,?14,$P(AG("EMPADDR"),U),!  ;EMPLOYER NAME
 .. W !,?14,$P(AG("EMPADDR"),U,2),!  ;EMPLOYER STREET
 .. W !,?14,$P(AG("EMPADDR"),U,3)  ;EMPLOYER CITY
 .. I $P(AG("EMPADDR"),U,4)'="" D
 ... W ", ",$P($G(^DIC(5,$P(AG("EMPADDR"),U,4),0)),U,2)  ;EMPLOYER STATE
 .. W ", ",$P(AG("EMPADDR"),U,5),!  ;EMPLOYER ZIP
 .. W !,?5,"[ ] NO",!
 . I $G(AG("EMPADDR"))="" D
 .. W !,?5,"[X] YES",!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?5,"[ ] NO",!
 ;
 W !?2,"3. Do you have group health plan (GHP) coverage based on your own, or a family"
 W !,?5,"member's current employment ? ",!
 I $P(MSPRES(9000037,AG("DA"),.46),U)=""!($P(MSPRES(9000037,AG("DA"),.46),U)="NO") D
 . W !,?5,"[ ] YES",!
 . I $P(MSPRES(9000037,AG("DA"),.46),U)="" W !,?5,"[ ] NO",!
 . I $P(MSPRES(9000037,AG("DA"),.46),U)="NO" W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.46),U)="YES" D
 . W !,?5,"[X] YES",!
 . W !,?5,"[ ] NO",!
 ;
 W !,?2,"4. Does the employer that sponsors your GHP employ 100 or more employees ? ",!
 I $P(MSPRES(9000037,AG("DA"),.47),U)=""!($P(MSPRES(9000037,AG("DA"),.47),U)="NO") D
 . W !,?5,"[ ] YES",!
 . W !,?14,"Name and address of GHP : ",!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,"Policy Identification Number : _______________",!
 . W !,?14,"Group Identification Number :  _______________",!
 . W !,?14,"Name of Policy Holder : ______________________",!
 . W !,?14,"Relationship to Patient : ____________________",!
 . I $P(MSPRES(9000037,AG("DA"),.47),U)="" W !,?5,"[ ] NO",!
 . I $P(MSPRES(9000037,AG("DA"),.47),U)="NO" W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.47),U)="YES" D
 . W !,?5,"[X] YES",!
 . W !,?14,"Name and address of GHP : ",!
 . I $P(MSPRES(9000037,AG("DA"),.48),U)="" D
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 . I $P(MSPRES(9000037,AG("DA"),.48),U)'="" D
 .. S AG("INSPTR")=$P($G(^AUPNMSP(AG("DA"),5)),U,8)
 .. S AG("INSADDR")=$G(^AUTNINS(AG("INSPTR"),0))
 .. W !,?14,$P(AG("INSADDR"),U),!  ;INSURER NAME
 .. W !,?14,$P(AG("INSADDR"),U,2),!  ;INSURER STREET
 .. W !,?14,$P(AG("INSADDR"),U,3)  ;INSURER CITY
 .. I $P(AG("INSADDR"),U,4)'="" D
 ... W ", ",$P($G(^DIC(5,$P(AG("INSADDR"),U,4),0)),U,2)  ;INSURER STATE
 .. W ", ",$P(AG("INSADDR"),U,5),!  ;INSURER ZIP
 . I $P(MSPRES(9000037,AG("DA"),.49),U)="" D
 .. W !,?14,"Policy Identification Number : _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.49),U)'="" D
 .. W !,?14,"Policy Identification Number : ",$P(MSPRES(9000037,AG("DA"),.49),U),!
 . I $P(MSPRES(9000037,AG("DA"),.51),U)="" D
 .. W !,?14,"Group Identification Number :  _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.51),U)'="" D
 .. W !,?14,"Group Identification Number : ",$P(MSPRES(9000037,AG("DA"),.51),U),!
 . I $P(MSPRES(9000037,AG("DA"),.52),U)="" D
 .. W !,?14,"Name of Policy Holder : ______________________",!
 . I $P(MSPRES(9000037,AG("DA"),.52),U)'="" D
 .. W !,?14,"Name of Policy Holder : ",$P(MSPRES(9000037,AG("DA"),.52),U),!
 . I $P(MSPRES(9000037,AG("DA"),.53),U)="" D
 .. W !,?14,"Relationship to Patient : ____________________",!
 . I $P(MSPRES(9000037,AG("DA"),.53),U)'="" D
 .. S AG("RELPTR")=$P($G(^AUPNMSP(AG("DA"),5)),U,12)
 .. W !,?14,"Relationship to Patient : ",$P($G(^AUTTRLSH(AG("RELPTR"),0)),U),!
 . W !,?5,"[ ] NO",!
 K AG("INSPTR"),AG("INSADDR"),AG("EMPPTR"),AG("EMPADDR"),AG("RELPTR")
 Q
