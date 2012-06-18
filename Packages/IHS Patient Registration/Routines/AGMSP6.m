AGMSP6 ; IHS/ASDS/EFG - PRINT PAGE 6 OF MSP FORM ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;I AG("MSPPRINT") EXISTS, MAP DATA FROM AUPNMSP TO THE FORM
EN ;EP
 W !,"PART VI - ESRD",!
 I '$D(AG("MSPPRINT")) D BLANK1
 I $D(AG("MSPPRINT")) D MAP1
 W !
 W !,?50,"Continued on next page ==>"
 W !,AGLINE("EQ")
 W !,$P($G(^DIC(4,DUZ(2),0)),U),?73,"PAGE 6"
 Q
BLANK1 ;THIS SECTION IS USED TO PRINT THE BLANK PAGE 6
 W !,?2,"1. Do you have group health plan (GHP) coverage ? ",!
 W !,?5,"[ ] YES",!
 W !,?14,"Name and address of GHP : ",!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,"Policy Identification Number : _______________",!
 W !,?14,"Group Identification Number : _______________",!
 W !,?14,"Name of Policy Holder : ______________________",!
 W !,?14,"Relationship to Patient : ____________________",!
 W !,?14,"Name and address of employer, if any, from which you receive"
 W !,?14,"GHP coverage : ",!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?14,$E(AGLINE("_"),1,50),!
 W !,?5,"[ ] NO. STOP. Medicare is primary.",!
 W !,?2,"2. Have you received a kidney transplant ? ",!
 W !,?5,"[ ] YES  Date of transplant : _______________",!
 W !,?5,"[ ] NO",!
 W !,?2,"3. Have you received maintenance dialysis treatments ? ",!
 W !,?5,"[ ] YES  Date dialysis began : _______________",!
 W !,?19,"If you participated in a self dialysis training"
 W !,?19,"program, provide date training started : _______________",!
 W !,?5,"[ ] NO",!
 Q
MAP1 ;THIS SECTION IS USED TO PRINT THE PATIENT'S DATA ON THE FORM
 W !,?2,"1. Do you have group health plan (GHP) coverage ? ",!
 I $P(MSPRES(9000037,AG("DA"),.54),U)=""!($P(MSPRES(9000037,AG("DA"),.54),U)="NO") D
 . W !,?5,"[ ] YES",!
 . W !,?14,"Name and address of GHP : ",!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,"Policy Identification Number : _______________",!
 . W !,?14,"Group Identification Number :  _______________",!
 . W !,?14,"Name of Policy Holder : ______________________",!
 . W !,?14,"Relationship to Patient : ____________________",!
 . W !,?14,"Name and address of employer, if any, from which you receive"
 . W !,?14,"GHP coverage : ",!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . W !,?14,$E(AGLINE("_"),1,50),!
 . I $P(MSPRES(9000037,AG("DA"),.54),U)="" W !,?5,"[ ] NO",!
 . I $P(MSPRES(9000037,AG("DA"),.54),U)="NO" W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.54),U)="YES" D
 . W !,?5,"[X] YES",!
 . W !,?14,"Name and address of GHP : ",!
 . I $P(MSPRES(9000037,AG("DA"),.55),U)="" D
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 . I $P(MSPRES(9000037,AG("DA"),.55),U)'="" D
 .. S AG("INSPTR")=$P($G(^AUPNMSP(AG("DA"),6)),U,2)
 .. S AG("INSADDR")=$G(^AUTNINS(AG("INSPTR"),0))
 .. W !,?14,$P(AG("INSADDR"),U),!  ;INSURER NAME
 .. W !,?14,$P(AG("INSADDR"),U,2),!  ;INSURER STREET
 .. W !,?14,$P(AG("INSADDR"),U,3)  ;INSURER CITY
 .. I $P(AG("INSADDR"),U,4)'="" D
 ... W ", ",$P(^DIC(5,$P(AG("INSADDR"),U,4),0),U,2)  ;INSURER STATE
 .. W ", ",$P(AG("INSADDR"),U,5),!  ;INSURER ZIP
 . I $P(MSPRES(9000037,AG("DA"),.56),U)="" D
 .. W !,?14,"Policy Identification Number : _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.56),U)'="" D
 .. W !,?14,"Policy Identification Number : ",$P(MSPRES(9000037,AG("DA"),.56),U),!
 . I $P(MSPRES(9000037,AG("DA"),.57),U)="" D
 .. W !,?14,"Group Identification Number :  _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.57),U)'="" D
 .. W !,?14,"Group Identification Number : ",$P(MSPRES(9000037,AG("DA"),.57),U),!
 . I $P(MSPRES(9000037,AG("DA"),.58),U)="" D
 .. W !,?14,"Name of Policy Holder : ______________________",!
 . I $P(MSPRES(9000037,AG("DA"),.58),U)'="" D
 .. W !,?14,"Name of Policy Holder : ",$P(MSPRES(9000037,AG("DA"),.58),U),!
 . I $P(MSPRES(9000037,AG("DA"),.59),U)="" D
 .. W !,?14,"Relationship to Patient : ____________________",!
 . I $P(MSPRES(9000037,AG("DA"),.59),U)'="" D
 .. S AG("RELPTR")=$P($G(^AUPNMSP(AG("DA"),6)),U,6)
 .. W !,?14,"Relationship to Patient : ",$P($G(^AUTTRLSH(AG("RELPTR"),0)),U),!
 . W !,?14,"Name and address of employer, if any, from which you receive"
 . W !,?14,"GHP coverage : ",!
 . I $P(MSPRES(9000037,AG("DA"),.61),U)="" D
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 .. W !,?14,$E(AGLINE("_"),1,50),!
 . I $P(MSPRES(9000037,AG("DA"),.61),U)'="" D
 .. S AG("EMPPTR")=$P($G(^AUPNMSP(AG("DA"),6)),U,7)
 .. I $G(AG("EMPPTR"))'="" D
 ... S AG("EMPADDR")=$G(^AUTNEMPL(AG("EMPPTR"),0))
 ... W !,?14,$P(AG("EMPADDR"),U),!  ;EMPLOYER NAME
 ... W !,?14,$P(AG("EMPADDR"),U,2),!  ;EMPLOYER STREET
 ... W !,?14,$P(AG("EMPADDR"),U,3)  ;EMPLOYER CITY
 ... I $P(AG("EMPADDR"),U,4)'="" D
 .... W ", ",$P($G(^DIC(5,$P(AG("EMPADDR"),U,4),0)),U,2)  ;EMPLOYER STATE
 ... W ", ",$P(AG("EMPADDR"),U,5),!  ;EMPLOYER ZIP
 . W !,?5,"[ ] NO",!
 ;
 W !,?2,"2. Have you received a kidney transplant ? ",!
 I $P(MSPRES(9000037,AG("DA"),.62),U)=""!($P(MSPRES(9000037,AG("DA"),.62),U)="NO") D
 . W !,?5,"[ ] YES  Date of transplant : _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.62),U)="" W !,?5,"[ ] NO",!
 . I $P(MSPRES(9000037,AG("DA"),.62),U)="NO" W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.62),U)="YES" D
 . W !,?5,"[X] YES  "
 . I $P(MSPRES(9000037,AG("DA"),.63),U)="" W "Date of transplant : _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.63),U)'="" W "Date of transplant : ",$P(MSPRES(9000037,AG("DA"),.63),U),!
 . W !,?5,"[ ] NO",!
 ;
 W !,?2,"3. Have you received maintenance dialysis treatments ? ",!
 I $P(MSPRES(9000037,AG("DA"),.64),U)=""!($P(MSPRES(9000037,AG("DA"),.64),U)="NO") D
 . W !,?5,"[ ] YES  Date dialysis began : _______________",!
 . W !,?14,"If you participated in a self dialysis training"
 . W !,?14,"program, provide date training started : _______________",!
 . I $P(MSPRES(9000037,AG("DA"),.64),U)="" W !,?5,"[ ] NO",!
 . I $P(MSPRES(9000037,AG("DA"),.64),U)="NO" W !,?5,"[X] NO",!
 I $P(MSPRES(9000037,AG("DA"),.64),U)="YES" D
 . W !,?5,"[X] YES  Date dialysis began : "
 . I $P(MSPRES(9000037,AG("DA"),.65),U)="" W "_______________",!
 . I $P(MSPRES(9000037,AG("DA"),.65),U)'="" W $P(MSPRES(9000037,AG("DA"),.65),U),!
 . W !,?14,"If you participated in a self dialysis training"
 . W !,?14,"program, provide date training started : "
 . I $P(MSPRES(9000037,AG("DA"),.66),U)="" W "_______________",!
 . I $P(MSPRES(9000037,AG("DA"),.66),U)'="" W $P(MSPRES(9000037,AG("DA"),.66),U),!
 . W !,?5,"[ ] NO",!
 K AG("INSPTR"),AG("INSADDR"),AG("EMPPTR"),AG("EMPADDR"),AG("RELPTR")
 Q
